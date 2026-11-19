/**
 * VÉRA — Shared Application Logic, Seed Data & LocalStorage CRUD Engine
 * Pure ES6+ Vanilla JavaScript (Zero frameworks)
 */

(function (global) {
  'use strict';

  const KEYS = {
    PRODUCTS: 'vera_products_v1',
    CART: 'vera_cart_v1',
    ORDERS: 'vera_orders_v1',
    USERS: 'vera_users_v1',
    CURRENT_USER: 'vera_current_user_v1',
    WISHLIST: 'vera_wishlist_v1',
    ADMIN_THEME: 'vera_admin_theme_v1',
    PROMO: 'vera_active_promo_v1'
  };

  // Curated Studio Photography Assets
  const STUDIO_IMAGES = {
    HERO: '/src/assets/images/hero_vera_campaign_1794969110939.jpg',
    ATELIER: '/src/assets/images/editorial_atelier_banner_1794969110334.jpg',
    WOMAN_BLAZER: '/src/assets/images/woman_ivory_blazer_1794969112025.jpg',
    WOMAN_DRESS: '/src/assets/images/woman_silk_dress_1794969129031.jpg',
    WOMAN_TRENCH: '/src/assets/images/woman_trench_coat_1794969110792.jpg',
    WOMAN_TOTE: '/src/assets/images/woman_leather_tote_1794969112902.jpg',
    MAN_COAT: '/src/assets/images/man_charcoal_overcoat_1794969147414.jpg',
    MAN_SUIT: '/src/assets/images/man_ecru_linen_suit_1794969114261.jpg',
    MAN_KNIT: '/src/assets/images/man_espresso_knitwear_1794969131821.jpg',
    KIDS_TRENCH: '/src/assets/images/kids_minimal_trench_1794969116699.jpg',
    PERFUME_SANTAL: '/src/assets/images/perfume_santal_flacon_1794969131865.jpg',
    DETAIL_TAILOR: '/src/assets/images/detail_fabric_tailoring_1794969115948.jpg'
  };

  // Seed Products (10 Editorial Pieces across WOMAN, MAN, KIDS, PERFUMES)
  const SEED_PRODUCTS = [
    {
      id: 'VR-W-001',
      sku: 'VERA-WM-8810',
      name: 'STRUCTURED DOUBLE-BREASTED WOOL BLAZER',
      category: 'WOMAN',
      price: 12990,
      stock: 18,
      colorName: 'Ivory',
      colorHex: '#F3EFE6',
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
      image: STUDIO_IMAGES.WOMAN_BLAZER,
      gallery: [STUDIO_IMAGES.WOMAN_BLAZER, STUDIO_IMAGES.DETAIL_TAILOR, STUDIO_IMAGES.ATELIER],
      description: 'Tailored in heavyweight Italian virgin wool with architectural peak lapels, horn button closure, and full cupro lining.',
      composition: '100% Virgin Wool · Lining: 100% Cupro · Dry clean only. Crafted for structured drape.'
    },
    {
      id: 'VR-W-002',
      sku: 'VERA-WM-8814',
      name: 'BIAS-CUT MULBERRY SILK SLIP DRESS',
      category: 'WOMAN',
      price: 8990,
      stock: 14,
      colorName: 'Champagne',
      colorHex: '#DDD0BC',
      sizes: ['XS', 'S', 'M', 'L'],
      image: STUDIO_IMAGES.WOMAN_DRESS,
      gallery: [STUDIO_IMAGES.WOMAN_DRESS, STUDIO_IMAGES.ATELIER],
      description: 'Fluid midi slip dress cut on the bias in luminous heavyweight silk charmeuse with fine rouleau straps.',
      composition: '100% Mulberry Silk (22 Momme) · Delicate hand wash cold or dry clean.'
    },
    {
      id: 'VR-W-003',
      sku: 'VERA-WM-8821',
      name: 'OVERSIZED GABARDINE ARCHITECTURAL TRENCH',
      category: 'WOMAN',
      price: 15990,
      stock: 9,
      colorName: 'Stone Taupe',
      colorHex: '#9E9689',
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
      image: STUDIO_IMAGES.WOMAN_TRENCH,
      gallery: [STUDIO_IMAGES.WOMAN_TRENCH, STUDIO_IMAGES.DETAIL_TAILOR],
      description: 'Relaxed full-length trench coat crafted from water-repellent combed cotton gabardine with removable self-tie belt.',
      composition: '100% Organic Cotton Gabardine · Water-repellent finish · Dry clean recommended.'
    },
    {
      id: 'VR-W-004',
      sku: 'VERA-WM-8840',
      name: 'BOX-CALF ARCHITECTURAL TOTE BAG',
      category: 'WOMAN',
      price: 18490,
      stock: 4,
      colorName: 'Obsidian Black',
      colorHex: '#111111',
      sizes: ['ONE SIZE'],
      image: STUDIO_IMAGES.WOMAN_TOTE,
      gallery: [STUDIO_IMAGES.WOMAN_TOTE, STUDIO_IMAGES.HERO],
      description: 'Geometric structured tote crafted from smooth full-grain box-calf leather with tonal hand-painted edges and suede interior.',
      composition: '100% Full-Grain Calf Leather · Dimensions: 38 × 30 × 14 cm · Includes dust bag.'
    },
    {
      id: 'VR-M-005',
      sku: 'VERA-MN-4402',
      name: 'CASHMERE BLEND SINGLE-BREASTED OVERCOAT',
      category: 'MAN',
      price: 19990,
      stock: 11,
      colorName: 'Charcoal',
      colorHex: '#3A3B3C',
      sizes: ['S', 'M', 'L', 'XL'],
      image: STUDIO_IMAGES.MAN_COAT,
      gallery: [STUDIO_IMAGES.MAN_COAT, STUDIO_IMAGES.DETAIL_TAILOR],
      description: 'Sharp knee-length overcoat woven in a brushed wool-cashmere blend with concealed placket and interior welt pockets.',
      composition: '85% Virgin Wool, 15% Cashmere · Horn buttons · Dry clean only.'
    },
    {
      id: 'VR-M-006',
      sku: 'VERA-MN-4411',
      name: 'UNLINED ECRU LINEN TAILORED SUIT JACKET',
      category: 'MAN',
      price: 11490,
      stock: 16,
      colorName: 'Ecru',
      colorHex: '#EAE5D9',
      sizes: ['S', 'M', 'L', 'XL'],
      image: STUDIO_IMAGES.MAN_SUIT,
      gallery: [STUDIO_IMAGES.MAN_SUIT, STUDIO_IMAGES.ATELIER],
      description: 'Breathable summer tailoring in washed Belgian linen-cotton with soft unpadded shoulders and patch pockets.',
      composition: '68% European Flax Linen, 32% Cotton · Dry clean or gentle steam.'
    },
    {
      id: 'VR-M-007',
      sku: 'VERA-MN-4425',
      name: 'HEAVY-GAUGE RIBBED MERINO CREWNECK',
      category: 'MAN',
      price: 6490,
      stock: 3,
      colorName: 'Espresso',
      colorHex: '#3B2F2A',
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
      image: STUDIO_IMAGES.MAN_KNIT,
      gallery: [STUDIO_IMAGES.MAN_KNIT, STUDIO_IMAGES.DETAIL_TAILOR],
      description: 'Dense 5-gauge fisherman rib sweater spun from extra-fine Australian merino wool with saddle-shoulder construction.',
      composition: '100% Extra-Fine Merino Wool · Hand wash cold, dry flat.'
    },
    {
      id: 'VR-K-008',
      sku: 'VERA-KD-2104',
      name: 'ORGANIC COTTON BELTED TRENCH COAT',
      category: 'KIDS',
      price: 4990,
      stock: 22,
      colorName: 'Sand',
      colorHex: '#CBBFA9',
      sizes: ['4-5Y', '6-7Y', '8-9Y', '10-11Y'],
      image: STUDIO_IMAGES.KIDS_TRENCH,
      gallery: [STUDIO_IMAGES.KIDS_TRENCH, STUDIO_IMAGES.ATELIER],
      description: 'Timeless double-breasted trench jacket tailored for movement in soft brushed organic cotton twill with tortoiseshell buttons.',
      composition: '100% GOTS Certified Organic Cotton · Machine wash gentle 30°C.'
    },
    {
      id: 'VR-K-009',
      sku: 'VERA-KD-2110',
      name: 'RIBBED CREAM MERINO KNIT PULLOVER',
      category: 'KIDS',
      price: 3490,
      stock: 5,
      colorName: 'Cream',
      colorHex: '#F5F2EB',
      sizes: ['4-5Y', '6-7Y', '8-9Y', '10-11Y'],
      image: STUDIO_IMAGES.KIDS_TRENCH,
      gallery: [STUDIO_IMAGES.KIDS_TRENCH],
      description: 'Soft breathable ribbed knit pullover designed for layering through transitional seasons.',
      composition: '100% Combed Organic Cotton & Merino Blend · Cold gentle wash.'
    },
    {
      id: 'VR-P-010',
      sku: 'VERA-PF-0401',
      name: 'VÉRA SANTAL 04 EAU DE PARFUM — 100 ML',
      category: 'PERFUMES',
      price: 7990,
      stock: 27,
      colorName: 'Smoked Amber',
      colorHex: '#8A4F1D',
      sizes: ['ONE SIZE'],
      image: STUDIO_IMAGES.PERFUME_SANTAL,
      gallery: [STUDIO_IMAGES.PERFUME_SANTAL, STUDIO_IMAGES.ATELIER],
      description: 'Architectural woody extrait opening with Mysore sandalwood, crushed cardamom, white cedar, and dry vetiver.',
      composition: 'Notes: Mysore Sandalwood, Cardamom, Iris Root, Vetiver · 100 ml / 3.4 fl. oz.'
    }
  ];

  const SEED_USERS = [
    {
      id: 'USR-101',
      name: 'Ananya Sharma',
      email: 'ananya.sharma@example.in',
      password: 'vera2026',
      phone: '+91 98201 44510',
      city: 'Mumbai',
      addresses: [
        {
          id: 'ADDR-1',
          label: 'Home — South Mumbai',
          line1: '14B Altamount Road, Kemps Corner',
          city: 'Mumbai',
          state: 'Maharashtra',
          pin: '400026',
          phone: '+91 98201 44510'
        }
      ]
    },
    {
      id: 'USR-102',
      name: 'Aarav Mehta',
      email: 'aarav.mehta@example.in',
      password: 'vera2026',
      phone: '+91 98112 78230',
      city: 'New Delhi',
      addresses: [
        {
          id: 'ADDR-2',
          label: 'Residence — Jor Bagh',
          line1: '42 Jor Bagh Market Road',
          city: 'New Delhi',
          state: 'Delhi',
          pin: '110003',
          phone: '+91 98112 78230'
        }
      ]
    },
    {
      id: 'USR-103',
      name: 'Diya Nair',
      email: 'diya.nair@example.in',
      password: 'vera2026',
      phone: '+91 99001 56321',
      city: 'Bengaluru',
      addresses: [
        {
          id: 'ADDR-3',
          label: 'Studio — Indiranagar',
          line1: '100 Feet Road, HAL 2nd Stage',
          city: 'Bengaluru',
          state: 'Karnataka',
          pin: '560038',
          phone: '+91 99001 56321'
        }
      ]
    },
    {
      id: 'USR-104',
      name: 'Kabir Kapoor',
      email: 'kabir.kapoor@example.in',
      password: 'vera2026',
      phone: '+91 98490 21887',
      city: 'Hyderabad',
      addresses: [
        {
          id: 'ADDR-4',
          label: 'Residence — Jubilee Hills',
          line1: 'Plot 88, Road No. 45, Jubilee Hills',
          city: 'Hyderabad',
          state: 'Telangana',
          pin: '500033',
          phone: '+91 98490 21887'
        }
      ]
    }
  ];

  const SEED_ORDERS = [
    {
      id: 'VR-2026-1048',
      customerName: 'Ananya Sharma',
      customerEmail: 'ananya.sharma@example.in',
      phone: '+91 98201 44510',
      address: '14B Altamount Road, Kemps Corner',
      city: 'Mumbai',
      state: 'Maharashtra',
      pin: '400026',
      paymentMethod: 'UPI',
      status: 'Delivered',
      createdAt: '2026-11-10T11:20:00Z',
      items: [
        { productId: 'VR-W-001', name: 'STRUCTURED DOUBLE-BREASTED WOOL BLAZER', size: 'S', color: 'Ivory', price: 12990, qty: 1, image: STUDIO_IMAGES.WOMAN_BLAZER },
        { productId: 'VR-P-010', name: 'VÉRA SANTAL 04 EAU DE PARFUM — 100 ML', size: 'ONE SIZE', color: 'Smoked Amber', price: 7990, qty: 1, image: STUDIO_IMAGES.PERFUME_SANTAL }
      ],
      subtotal: 20980,
      discount: 0,
      gst: 2518,
      shipping: 0,
      total: 20980
    },
    {
      id: 'VR-2026-1049',
      customerName: 'Aarav Mehta',
      customerEmail: 'aarav.mehta@example.in',
      phone: '+91 98112 78230',
      address: '42 Jor Bagh Market Road',
      city: 'New Delhi',
      state: 'Delhi',
      pin: '110003',
      paymentMethod: 'Card',
      status: 'Shipped',
      createdAt: '2026-11-14T16:40:00Z',
      items: [
        { productId: 'VR-M-005', name: 'CASHMERE BLEND SINGLE-BREASTED OVERCOAT', size: 'L', color: 'Charcoal', price: 19990, qty: 1, image: STUDIO_IMAGES.MAN_COAT }
      ],
      subtotal: 19990,
      discount: 0,
      gst: 2399,
      shipping: 0,
      total: 19990
    },
    {
      id: 'VR-2026-1050',
      customerName: 'Diya Nair',
      customerEmail: 'diya.nair@example.in',
      phone: '+91 99001 56321',
      address: '100 Feet Road, HAL 2nd Stage',
      city: 'Bengaluru',
      state: 'Karnataka',
      pin: '560038',
      paymentMethod: 'UPI',
      status: 'Processing',
      createdAt: '2026-11-16T09:15:00Z',
      items: [
        { productId: 'VR-W-002', name: 'BIAS-CUT MULBERRY SILK SLIP DRESS', size: 'M', color: 'Champagne', price: 8990, qty: 1, image: STUDIO_IMAGES.WOMAN_DRESS },
        { productId: 'VR-W-004', name: 'BOX-CALF ARCHITECTURAL TOTE BAG', size: 'ONE SIZE', color: 'Obsidian Black', price: 18490, qty: 1, image: STUDIO_IMAGES.WOMAN_TOTE }
      ],
      subtotal: 27480,
      discount: 2748,
      gst: 2968,
      shipping: 0,
      total: 24732
    },
    {
      id: 'VR-2026-1051',
      customerName: 'Kabir Kapoor',
      customerEmail: 'kabir.kapoor@example.in',
      phone: '+91 98490 21887',
      address: 'Plot 88, Road No. 45, Jubilee Hills',
      city: 'Hyderabad',
      state: 'Telangana',
      pin: '500033',
      paymentMethod: 'COD',
      status: 'Processing',
      createdAt: '2026-11-17T14:05:00Z',
      items: [
        { productId: 'VR-M-007', name: 'HEAVY-GAUGE RIBBED MERINO CREWNECK', size: 'M', color: 'Espresso', price: 6490, qty: 1, image: STUDIO_IMAGES.MAN_KNIT }
      ],
      subtotal: 6490,
      discount: 0,
      gst: 779,
      shipping: 0,
      total: 6490
    },
    {
      id: 'VR-2026-1052',
      customerName: 'Ananya Sharma',
      customerEmail: 'ananya.sharma@example.in',
      phone: '+91 98201 44510',
      address: '14B Altamount Road, Kemps Corner',
      city: 'Mumbai',
      state: 'Maharashtra',
      pin: '400026',
      paymentMethod: 'Card',
      status: 'Delivered',
      createdAt: '2026-10-28T13:30:00Z',
      items: [
        { productId: 'VR-W-003', name: 'OVERSIZED GABARDINE ARCHITECTURAL TRENCH', size: 'S', color: 'Stone Taupe', price: 15990, qty: 1, image: STUDIO_IMAGES.WOMAN_TRENCH }
      ],
      subtotal: 15990,
      discount: 0,
      gst: 1919,
      shipping: 0,
      total: 15990
    }
  ];

  // Ensure initial LocalStorage data exists
  function initStore() {
    if (!localStorage.getItem(KEYS.PRODUCTS)) {
      localStorage.setItem(KEYS.PRODUCTS, JSON.stringify(SEED_PRODUCTS));
    }
    if (!localStorage.getItem(KEYS.USERS)) {
      localStorage.setItem(KEYS.USERS, JSON.stringify(SEED_USERS));
    }
    if (!localStorage.getItem(KEYS.ORDERS)) {
      localStorage.setItem(KEYS.ORDERS, JSON.stringify(SEED_ORDERS));
    }
    if (!localStorage.getItem(KEYS.CART)) {
      localStorage.setItem(KEYS.CART, JSON.stringify([]));
    }
    if (!localStorage.getItem(KEYS.WISHLIST)) {
      localStorage.setItem(KEYS.WISHLIST, JSON.stringify(['VR-W-001', 'VR-P-010']));
    }
  }

  function readJSON(key, fallback) {
    try {
      const raw = localStorage.getItem(key);
      return raw ? JSON.parse(raw) : fallback;
    } catch {
      return fallback;
    }
  }

  function writeJSON(key, data) {
    localStorage.setItem(key, JSON.stringify(data));
  }

  // Indian Rupee Formatting: ₹ 12,990.00
  function formatINR(amount) {
    const num = Number(amount) || 0;
    return (
      '₹ ' +
      num.toLocaleString('en-IN', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
      })
    );
  }

  function formatDate(iso) {
    if (!iso) return '—';
    const d = new Date(iso);
    return d.toLocaleDateString('en-IN', {
      day: '2-digit',
      month: 'short',
      year: 'numeric'
    });
  }

  function escapeHTML(str) {
    return String(str || '')
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  // Resilient Image Helper
  function handleImgError(imgEl, title) {
    if (!imgEl || imgEl.dataset.fallbackApplied) return;
    imgEl.dataset.fallbackApplied = '1';
    const wrap = document.createElement('div');
    wrap.className = 'vera-img-fallback';
    wrap.innerHTML =
      '<div class="font-display ls-wide small mb-1">VÉRA</div>' +
      '<div class="small text-muted-vera">' +
      escapeHTML(title || 'Editorial Archive') +
      '</div>';
    imgEl.replaceWith(wrap);
  }

  // Toast Notification (Non-blocking)
  function showToast(message, actionLabel, actionHref) {
    let container = document.getElementById('veraToastContainer');
    if (!container) {
      container = document.createElement('div');
      container.id = 'veraToastContainer';
      container.className = 'vera-toast-container';
      document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    toast.className = 'vera-toast';
    toast.setAttribute('role', 'status');
    toast.innerHTML =
      '<span>' +
      escapeHTML(message) +
      '</span>' +
      (actionLabel && actionHref
        ? '<a href="' +
          escapeHTML(actionHref) +
          '" class="text-white text-decoration-underline flex-shrink-0">' +
          escapeHTML(actionLabel) +
          '</a>'
        : '<button type="button" class="btn-close btn-close-white btn-sm" aria-label="Close"></button>');

    const closeBtn = toast.querySelector('button');
    if (closeBtn) {
      closeBtn.addEventListener('click', () => toast.remove());
    }

    container.appendChild(toast);
    setTimeout(() => {
      if (toast.parentNode) toast.remove();
    }, 3400);
  }

  // =========================================================================
  // Product CRUD
  // =========================================================================
  function getProducts() {
    initStore();
    return readJSON(KEYS.PRODUCTS, []);
  }

  function getProductById(id) {
    return getProducts().find((p) => p.id === id) || null;
  }

  function saveProduct(productData) {
    const products = getProducts();
    const idx = products.findIndex((p) => p.id === productData.id);
    if (idx >= 0) {
      products[idx] = { ...products[idx], ...productData };
    } else {
      products.unshift(productData);
    }
    writeJSON(KEYS.PRODUCTS, products);
    return productData;
  }

  function deleteProduct(id) {
    const products = getProducts().filter((p) => p.id !== id);
    writeJSON(KEYS.PRODUCTS, products);
  }

  // =========================================================================
  // Cart CRUD
  // =========================================================================
  function getCart() {
    initStore();
    return readJSON(KEYS.CART, []);
  }

  function getCartCount() {
    return getCart().reduce((sum, item) => sum + (Number(item.qty) || 0), 0);
  }

  function addToCart(productId, size, qty = 1) {
    const product = getProductById(productId);
    if (!product) return false;
    if (product.stock <= 0) {
      showToast('Item currently out of stock');
      return false;
    }

    const chosenSize = size || (product.sizes && product.sizes[0]) || 'ONE SIZE';
    const cart = getCart();
    const existing = cart.find(
      (item) => item.productId === productId && item.size === chosenSize
    );

    if (existing) {
      existing.qty = Math.min(product.stock, existing.qty + qty);
    } else {
      cart.push({
        productId: product.id,
        name: product.name,
        price: product.price,
        size: chosenSize,
        color: product.colorName,
        image: product.image,
        qty: qty
      });
    }

    writeJSON(KEYS.CART, cart);
    updateCartBadges();
    showToast('Added to Bag — ' + chosenSize, 'View Bag', 'cart.html');
    return true;
  }

  function updateCartQty(productId, size, delta) {
    const cart = getCart();
    const idx = cart.findIndex((i) => i.productId === productId && i.size === size);
    if (idx === -1) return;

    const product = getProductById(productId);
    const maxStock = product ? Math.max(1, product.stock) : 99;
    const nextQty = cart[idx].qty + delta;

    if (nextQty <= 0) {
      cart.splice(idx, 1);
    } else {
      cart[idx].qty = Math.min(maxStock, nextQty);
    }

    writeJSON(KEYS.CART, cart);
    updateCartBadges();
  }

  function removeFromCart(productId, size) {
    const cart = getCart().filter(
      (i) => !(i.productId === productId && i.size === size)
    );
    writeJSON(KEYS.CART, cart);
    updateCartBadges();
  }

  function clearCart() {
    writeJSON(KEYS.CART, []);
    localStorage.removeItem(KEYS.PROMO);
    updateCartBadges();
  }

  function getActivePromo() {
    return localStorage.getItem(KEYS.PROMO) || '';
  }

  function setPromoCode(code) {
    const normalized = String(code || '').trim().toUpperCase();
    if (normalized === 'VERA10' || normalized === 'FIRST15') {
      localStorage.setItem(KEYS.PROMO, normalized);
      return { valid: true, code: normalized };
    }
    if (!normalized) {
      localStorage.removeItem(KEYS.PROMO);
      return { valid: false, code: '' };
    }
    return { valid: false, code: normalized };
  }

  function calculateCartTotals() {
    const cart = getCart();
    const subtotal = cart.reduce((sum, item) => sum + item.price * item.qty, 0);
    const promo = getActivePromo();
    let discountRate = 0;
    if (promo === 'VERA10') discountRate = 0.1;
    if (promo === 'FIRST15') discountRate = 0.15;

    const discount = Math.round(subtotal * discountRate);
    const taxableBase = Math.max(0, subtotal - discount);
    // Prices are GST-inclusive in India (12% included component shown transparently)
    const gstIncluded = Math.round((taxableBase * 12) / 112);
    const shipping = taxableBase === 0 || taxableBase >= 5000 ? 0 : 250;
    const total = taxableBase + shipping;

    return {
      subtotal,
      discount,
      promo,
      gstIncluded,
      shipping,
      total
    };
  }

  function updateCartBadges() {
    const count = getCartCount();
    document.querySelectorAll('[data-cart-badge]').forEach((el) => {
      el.textContent = String(count);
    });
  }

  // =========================================================================
  // Wishlist
  // =========================================================================
  function getWishlist() {
    initStore();
    return readJSON(KEYS.WISHLIST, []);
  }

  function isWishlisted(productId) {
    return getWishlist().includes(productId);
  }

  function toggleWishlist(productId) {
    const list = getWishlist();
    const idx = list.indexOf(productId);
    let added = false;
    if (idx >= 0) {
      list.splice(idx, 1);
      showToast('Removed from Wishlist');
    } else {
      list.push(productId);
      added = true;
      showToast('Saved to Wishlist', 'View', 'account.html#wishlist');
    }
    writeJSON(KEYS.WISHLIST, list);
    return added;
  }

  // =========================================================================
  // Orders & Checkout
  // =========================================================================
  function getOrders() {
    initStore();
    return readJSON(KEYS.ORDERS, []);
  }

  function createOrder(orderPayload) {
    const orders = getOrders();
    const orderNumber = 'VR-2026-' + String(1053 + orders.length);
    const totals = calculateCartTotals();
    const cart = getCart();

    const newOrder = {
      id: orderNumber,
      customerName: orderPayload.customerName,
      customerEmail: orderPayload.customerEmail,
      phone: orderPayload.phone,
      address: orderPayload.address,
      city: orderPayload.city,
      state: orderPayload.state,
      pin: orderPayload.pin,
      paymentMethod: orderPayload.paymentMethod,
      status: 'Processing',
      createdAt: new Date().toISOString(),
      items: cart.map((c) => ({ ...c })),
      subtotal: totals.subtotal,
      discount: totals.discount,
      gst: totals.gstIncluded,
      shipping: totals.shipping,
      total: totals.total
    };

    orders.unshift(newOrder);
    writeJSON(KEYS.ORDERS, orders);

    // Deduct stock in localStorage products
    const products = getProducts();
    cart.forEach((item) => {
      const prod = products.find((p) => p.id === item.productId);
      if (prod) {
        prod.stock = Math.max(0, prod.stock - item.qty);
      }
    });
    writeJSON(KEYS.PRODUCTS, products);

    clearCart();
    return newOrder;
  }

  function updateOrderStatus(orderId, newStatus) {
    const orders = getOrders();
    const target = orders.find((o) => o.id === orderId);
    if (!target) return null;
    target.status = newStatus;
    writeJSON(KEYS.ORDERS, orders);
    return target;
  }

  // =========================================================================
  // Users & Authentication
  // =========================================================================
  function getUsers() {
    initStore();
    return readJSON(KEYS.USERS, []);
  }

  function getCurrentUser() {
    const id = localStorage.getItem(KEYS.CURRENT_USER);
    if (!id) return null;
    return getUsers().find((u) => u.id === id) || null;
  }

  function loginUser(email, password) {
    const users = getUsers();
    const found = users.find(
      (u) => u.email.toLowerCase() === String(email).trim().toLowerCase() && u.password === password
    );
    if (!found) return null;
    localStorage.setItem(KEYS.CURRENT_USER, found.id);
    return found;
  }

  function registerUser({ name, email, password, phone, city }) {
    const users = getUsers();
    const exists = users.some(
      (u) => u.email.toLowerCase() === String(email).trim().toLowerCase()
    );
    if (exists) {
      return { error: 'An account with this email already exists.' };
    }
    const newUser = {
      id: 'USR-' + (101 + users.length),
      name: name.trim(),
      email: email.trim().toLowerCase(),
      password,
      phone: phone || '+91 98000 00000',
      city: city || 'Mumbai',
      addresses: []
    };
    users.push(newUser);
    writeJSON(KEYS.USERS, users);
    localStorage.setItem(KEYS.CURRENT_USER, newUser.id);
    return { user: newUser };
  }

  function logoutUser() {
    localStorage.removeItem(KEYS.CURRENT_USER);
  }

  function addAddressToCurrentUser(addr) {
    const current = getCurrentUser();
    if (!current) return null;
    const users = getUsers();
    const idx = users.findIndex((u) => u.id === current.id);
    if (idx === -1) return null;
    const newAddr = {
      id: 'ADDR-' + Date.now(),
      ...addr
    };
    users[idx].addresses = users[idx].addresses || [];
    users[idx].addresses.push(newAddr);
    writeJSON(KEYS.USERS, users);
    return newAddr;
  }

  function removeAddressFromCurrentUser(addrId) {
    const current = getCurrentUser();
    if (!current) return;
    const users = getUsers();
    const idx = users.findIndex((u) => u.id === current.id);
    if (idx === -1) return;
    users[idx].addresses = (users[idx].addresses || []).filter((a) => a.id !== addrId);
    writeJSON(KEYS.USERS, users);
  }

  // =========================================================================
  // Shared Storefront Shell Initialization (Search Overlay + Transparent Header)
  // =========================================================================
  function renderProductCardHTML(product) {
    const wishActive = isWishlisted(product.id) ? 'is-active' : '';
    const wishIcon = isWishlisted(product.id) ? 'bi-heart-fill' : 'bi-heart';
    const sizesHtml = (product.sizes || [])
      .map(
        (sz) =>
          '<button type="button" class="vera-quick-size-btn" data-quick-add="' +
          escapeHTML(product.id) +
          '" data-size="' +
          escapeHTML(sz) +
          '" aria-label="Quick add size ' +
          escapeHTML(sz) +
          '">' +
          escapeHTML(sz) +
          '</button>'
      )
      .join('');

    return (
      '<article class="vera-product-card">' +
      '  <div class="vera-product-media">' +
      '    <button type="button" class="vera-wishlist-icon-btn ' +
      wishActive +
      '" data-wishlist-toggle="' +
      escapeHTML(product.id) +
      '" aria-label="Toggle wishlist">' +
      '      <i class="bi ' +
      wishIcon +
      '"></i>' +
      '    </button>' +
      '    <a href="product-detail.html?id=' +
      encodeURIComponent(product.id) +
      '" class="d-block w-100 h-100">' +
      '      <img src="' +
      escapeHTML(product.image) +
      '" alt="' +
      escapeHTML(product.name) +
      '" referrerpolicy="no-referrer" onerror="VERA.handleImgError(this, \'' +
      escapeHTML(product.name).replace(/'/g, '') +
      '\')" />' +
      '    </a>' +
      '    <div class="vera-quick-add">' +
      '      <div class="d-flex justify-content-between align-items-center mb-1 px-1">' +
      '        <span class="font-display" style="font-size:9px;letter-spacing:0.12em;color:#666;">QUICK ADD</span>' +
      (product.stock <= 5 && product.stock > 0
        ? '<span class="font-display" style="font-size:9px;letter-spacing:0.1em;color:#b45309;">LOW STOCK</span>'
        : product.stock === 0
        ? '<span class="font-display" style="font-size:9px;letter-spacing:0.1em;color:#b91c1c;">SOLD OUT</span>'
        : '') +
      '      </div>' +
      '      <div class="d-flex flex-wrap gap-1">' +
      (product.stock > 0 ? sizesHtml : '<span class="small text-muted-vera px-1">Notify me when restocked</span>') +
      '      </div>' +
      '    </div>' +
      '  </div>' +
      '  <div class="vera-product-meta">' +
      '    <div class="vera-product-kicker">' +
      escapeHTML(product.category) +
      ' · ' +
      escapeHTML(product.colorName) +
      '</div>' +
      '    <a href="product-detail.html?id=' +
      encodeURIComponent(product.id) +
      '" class="vera-product-title">' +
      escapeHTML(product.name) +
      '</a>' +
      '    <div class="vera-product-price">' +
      formatINR(product.price) +
      '</div>' +
      '  </div>' +
      '</article>'
    );
  }

  function initSearchOverlay() {
    const overlay = document.getElementById('veraSearchOverlay');
    const input = document.getElementById('veraSearchInput');
    const resultsEl = document.getElementById('veraSearchResults');
    const openBtns = document.querySelectorAll('[data-open-search]');
    const closeBtns = document.querySelectorAll('[data-close-search]');

    if (!overlay || !input || !resultsEl) return;

    function renderSearchResults(query) {
      const q = String(query || '').trim().toLowerCase();
      const all = getProducts();
      const matches = q
        ? all.filter(
            (p) =>
              p.name.toLowerCase().includes(q) ||
              p.category.toLowerCase().includes(q) ||
              p.colorName.toLowerCase().includes(q) ||
              p.sku.toLowerCase().includes(q)
          )
        : all.slice(0, 4);

      if (matches.length === 0) {
        resultsEl.innerHTML =
          '<div class="col-12 py-5 text-center text-muted-vera ls-editorial small">No garments found matching "' +
          escapeHTML(query) +
          '".</div>';
        return;
      }

      resultsEl.innerHTML = matches
        .slice(0, 8)
        .map((p) => '<div class="col-6 col-md-3">' + renderProductCardHTML(p) + '</div>')
        .join('');
    }

    openBtns.forEach((btn) => {
      btn.addEventListener('click', () => {
        overlay.classList.add('is-open');
        const header = document.getElementById('veraHeader');
        if (header) header.classList.add('is-scrolled');
        renderSearchResults(input.value);
        setTimeout(() => input.focus(), 50);
      });
    });

    closeBtns.forEach((btn) => {
      btn.addEventListener('click', () => {
        overlay.classList.remove('is-open');
      });
    });

    input.addEventListener('input', (e) => renderSearchResults(e.target.value));

    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && overlay.classList.contains('is-open')) {
        overlay.classList.remove('is-open');
      }
    });
  }

  function initStorefrontHeader() {
    const header = document.getElementById('veraHeader');
    if (header && header.classList.contains('header-transparent')) {
      const onScroll = () => {
        if (window.scrollY > 40) {
          header.classList.add('is-scrolled');
        } else {
          header.classList.remove('is-scrolled');
        }
      };
      onScroll();
      window.addEventListener('scroll', onScroll, { passive: true });
    }

    // Event delegation for Quick-Add and Wishlist buttons across all storefront pages
    document.addEventListener('click', (e) => {
      const quickBtn = e.target.closest('[data-quick-add]');
      if (quickBtn) {
        e.preventDefault();
        const pid = quickBtn.getAttribute('data-quick-add');
        const size = quickBtn.getAttribute('data-size');
        addToCart(pid, size, 1);
        return;
      }

      const wishBtn = e.target.closest('[data-wishlist-toggle]');
      if (wishBtn) {
        e.preventDefault();
        const pid = wishBtn.getAttribute('data-wishlist-toggle');
        const added = toggleWishlist(pid);
        wishBtn.classList.toggle('is-active', added);
        const icon = wishBtn.querySelector('i');
        if (icon) {
          icon.className = added ? 'bi bi-heart-fill' : 'bi bi-heart';
        }
      }
    });

    updateCartBadges();
    initSearchOverlay();
  }

  // =========================================================================
  // Admin Shell Helpers (Dark/Light Mode + Sidebar Collapse)
  // =========================================================================
  function initAdminShell() {
    const shell = document.getElementById('adminShell');
    if (!shell) return;

    const savedTheme = localStorage.getItem(KEYS.ADMIN_THEME) || 'light';
    if (savedTheme === 'dark') {
      shell.classList.add('admin-dark');
    }

    const themeBtn = document.getElementById('adminThemeToggle');
    if (themeBtn) {
      const syncLabel = () => {
        const isDark = shell.classList.contains('admin-dark');
        themeBtn.innerHTML = isDark
          ? '<i class="bi bi-sun"></i> <span>Light</span>'
          : '<i class="bi bi-moon"></i> <span>Dark</span>';
      };
      syncLabel();
      themeBtn.addEventListener('click', () => {
        shell.classList.toggle('admin-dark');
        const next = shell.classList.contains('admin-dark') ? 'dark' : 'light';
        localStorage.setItem(KEYS.ADMIN_THEME, next);
        syncLabel();
      });
    }

    const collapseBtn = document.getElementById('adminSidebarToggle');
    if (collapseBtn) {
      collapseBtn.addEventListener('click', () => {
        shell.classList.toggle('sidebar-collapsed');
      });
    }
  }

  // Initialize on DOM ready
  document.addEventListener('DOMContentLoaded', () => {
    initStore();
    initStorefrontHeader();
    initAdminShell();
  });

  // Expose VERA Public API
  global.VERA = {
    STUDIO_IMAGES,
    initStore,
    formatINR,
    formatDate,
    escapeHTML,
    handleImgError,
    showToast,
    getProducts,
    getProductById,
    saveProduct,
    deleteProduct,
    getCart,
    getCartCount,
    addToCart,
    updateCartQty,
    removeFromCart,
    clearCart,
    getActivePromo,
    setPromoCode,
    calculateCartTotals,
    updateCartBadges,
    getWishlist,
    isWishlisted,
    toggleWishlist,
    getOrders,
    createOrder,
    updateOrderStatus,
    getUsers,
    getCurrentUser,
    loginUser,
    registerUser,
    logoutUser,
    addAddressToCurrentUser,
    removeAddressFromCurrentUser,
    renderProductCardHTML
  };
})(window);
