const functions = require("firebase-functions");
const admin = require("firebase-admin");
const cron = require("node-cron");

admin.initializeApp();

exports.checkExpirationDates = functions.firestore
    .document("product/{productId}")
    .onWrite((change, context) => {
      const product = change.after.exists ? change.after.data() : null;
      if (!product) {
        return null;
      }

      const expirationDate = product.expirationDate.toDate();
      const today = new Date();
      const daysUntilExpiration =
            Math.ceil((expirationDate - today) / (1000 * 60 * 60 * 24));

      if (daysUntilExpiration === 30 ||
            daysUntilExpiration === 15 ||
            daysUntilExpiration <= 5) {
        const notification = {
          notification: {
            title: "Fecha de expiración cercana",
            body: `El producto "${product.name}" expira 
            en ${daysUntilExpiration} días.`,
          },
          topic: "productExpirations",
        };

        return admin.messaging().send(notification);
      }

      return null;
    });

/**
 * Programa la verificación periódica para
 * que se ejecute a las 20:05 todos los días.
 */
function scheduleExpirationCheck() {
  cron.schedule("15 19 * * *", () => {
    // Invocar manualmente la función checkExpirationDates
    // const change = null;
    // const context = {};
    // exports.checkExpirationDates(change, context);
    const notification = {
      notification: {
        title: "Fecha de expiración cercana",
        body: "probando notificaciones",
      },
      topic: "productExpirations",
    };

    return admin.messaging().send(notification);
  });
}

scheduleExpirationCheck();
