// export function camel (str) {
//   const camel = (str || '').replace(/-([^-])/g, g => g[1].toUpperCase());

//   return capitalize(camel);
// }

// export function camelActual (str) {
//   return (str || '').replace(/-(\w)/g, (_, c) => (c ? c.toUpperCase() : ''));
// }

// export function kebab (str) {
//   return (str || '').replace(/([a-z])([A-Z])/g, '$1-$2').toLowerCase();
// }

// export function capitalize (str) {
//   str = str || '';

//   return `${str.substr(0, 1).toUpperCase()}${str.slice(1)}`;
// }

// export function findProduct (store, id) {
//   return store.state.store.products.find(p => p.id === id);
// }

// export function isOnSale (variants) {
//   return variants.some(variant => {
//     return parseFloat(variant.price) < parseFloat(variant.compareAtPrice);
//   });
// }

// export function randomNumber (min, max) {
//   return Math.floor(Math.random() * max) + min;
// }

// export function randomString (length = 5) {
//   let text = '';
//   const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

//   for (let i = 0; i < length; i++) {
//     text += possible.charAt(Math.floor(Math.random() * possible.length));
//   }

//   return text;
// }

export function kebab (str) {
  return (str || '').replace(/([a-z])([A-Z])/g, '$1-$2').toLowerCase()
}

export function toSnakeCase (str) {
  const regEx = /[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+/g
  return str && str
    .match(regEx)
    .map(x => x.toLowerCase())
    .join('_')
}

export function toCamelCase (text) {
  const regEx = /^([A-Z])|[\s-_]+(\w)/g

  return text.replace(
    regEx,
    function (_match, p1, p2, _offset) {
      if (p2) return p2.toUpperCase()
      return p1.toLowerCase()
    }
  )
}

export function compactObject (obj) {
  return Object.fromEntries(
    Object.entries(obj).filter(([key, value]) =>
      !(Array.isArray(value) && value.length === 0) &&
      value !== null &&
      value !== undefined &&
      value !== '' &&
      value !== 0 &&
      !Number.isNaN(value)
    )
  );
};
