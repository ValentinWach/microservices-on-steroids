import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
    vus: 500,
    duration: '2m',

    thresholds: {
        http_req_duration: [
            { threshold: 'p(95)<500' },
            { threshold: 'p(99)<1000' },
        ],
        http_req_failed: [
            { threshold: 'rate<0.01' },
        ],

        'http_req_duration{name:GET /product}': ['p(95)<500'],
        'http_req_duration{name:GET /}': ['p(95)<500'],
        'http_req_duration{name:POST /cart}': ['p(95)<500'],
        'http_req_duration{name:GET /cart}': ['p(95)<500'],
        'http_req_duration{name:GET /product (checkout)}': ['p(95)<500'],
        'http_req_duration{name:POST /cart/checkout}': ['p(95)<5000'],
        'http_req_duration{name:POST /setCurrency}': ['p(95)<500'],
        'http_req_duration{name:GET /logout}': ['p(95)<500'],
    },
};

const BASE_URL = 'https://shop.vwach.de';

const PRODUCTS = [
    '0PUK6V6EV0',
    '1YMWWN1N4O',
    '2ZYFJ3GM2N',
    '66VCHSJNUP',
    '6E92ZMYYFZ',
    '9SIQT8TOJO',
    'L9ECAV7KIM',
    'LS4PSXUNUM',
    'OLJCESPC7Z',
];

const CURRENCIES = ['EUR', 'USD', 'JPY', 'CAD', 'GBP', 'TRY'];

function randomItem(arr) {
    return arr[Math.floor(Math.random() * arr.length)];
}

function randomSleep(min, max) {
    sleep(Math.random() * (max - min) + min);
}

function formParams(tagName) {
    return {
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        redirects: 0,
        tags: { name: tagName },
    };
}

function addToCart(productId, tagName = 'POST /cart') {
    return http.post(
        `${BASE_URL}/cart`,
        {
            product_id: productId,
            quantity: String(Math.floor(Math.random() * 10) + 1),
        },
        formParams(tagName)
    );
}

function checkout() {
    const productId = randomItem(PRODUCTS);
    http.get(`${BASE_URL}/product/${productId}`, { tags: { name: 'GET /product (checkout)' } });
    addToCart(productId, 'POST /cart');

    const year = new Date().getFullYear() + 1;
    return http.post(
        `${BASE_URL}/cart/checkout`,
        {
            email: 'loadtest@example.com',
            street_address: '1600 Amphitheatre Parkway',
            zip_code: '94043',
            city: 'Mountain View',
            state: 'CA',
            country: 'United States',
            credit_card_number: '4432801561520454',
            credit_card_expiration_month: String(Math.floor(Math.random() * 12) + 1),
            credit_card_expiration_year: String(year),
            credit_card_cvv: String(Math.floor(Math.random() * 900) + 100),
        },
        {
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            tags: { name: 'POST /cart/checkout' },
        }
    );
}

export default function () {
    const rand = Math.random();

    // 50% — browse a product page
    if (rand < 0.50) {
        const productId = randomItem(PRODUCTS);
        const res = http.get(`${BASE_URL}/product/${productId}`, { tags: { name: 'GET /product' } });
        check(res, { 'Product GET status 200': (r) => r.status === 200 });
        randomSleep(10, 45);

    // 30% — home page (0.50 → 0.80)
    } else if (rand < 0.80) {
        const res = http.get(`${BASE_URL}/`, { tags: { name: 'GET /' } });
        check(res, { 'Home GET status 200': (r) => r.status === 200 });
        randomSleep(3, 15);

    // 8% — add to cart (0.80 → 0.88);
    } else if (rand < 0.88) {
        const res = addToCart(randomItem(PRODUCTS));
        check(res, { 'Cart POST status 302': (r) => r.status === 302 });
        randomSleep(1, 3);

    // 5% — view cart (0.88 → 0.93)
    } else if (rand < 0.93) {
        const res = http.get(`${BASE_URL}/cart`, { tags: { name: 'GET /cart' } });
        check(res, { 'Cart GET status 200': (r) => r.status === 200 });
        randomSleep(5, 20);

    // 5% — full checkout (0.93 → 0.98)
    } else if (rand < 0.98) {
        const res = checkout();
        check(res, { 'Checkout POST status 200': (r) => r.status === 200 });
        randomSleep(1, 2);

    // 1% — set currency (0.98 → 0.99)
    } else if (rand < 0.99) {
        const res = http.post(
            `${BASE_URL}/setCurrency`,
            { currency_code: randomItem(CURRENCIES) },
            formParams('POST /setCurrency')
        );
        check(res, { 'SetCurrency POST status 302': (r) => r.status === 302 });
        randomSleep(2, 5);

    // 1% — logout (0.99 → 1.00)
    } else {
        const res = http.get(`${BASE_URL}/logout`, { redirects: 0, tags: { name: 'GET /logout' } });
        check(res, { 'Logout status 302': (r) => r.status === 302 });
        randomSleep(1, 2);
    }
}
