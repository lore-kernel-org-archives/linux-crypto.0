From: Bob Ham <bob.ham-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Subject: [PATCH 1/2] hwrng: chaoskey - Add support for Araneus Alea I USB RNG
Date: Fri,  3 Jun 2016 12:13:07 +0100
Message-ID: <1464952388-2405-2-git-send-email-bob.ham@collabora.com>
References: <1464952388-2405-1-git-send-email-bob.ham@collabora.com>
Cc: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Clemens Ladisch <clemens-P6GI/4k7KOmELgA04lAiVw@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
To: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Keith Packard <keithp-aN4HjG94KOLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464952388-2405-1-git-send-email-bob.ham-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Adds support for the Araneus Alea I USB hardware Random Number
Generator which is interfaced with in exactly the same way as the
Altus Metrum ChaosKey.  We just add the appropriate device ID and
modify the config help text.

Signed-off-by: Bob Ham <bob.ham-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
---
 drivers/usb/misc/Kconfig    | 11 ++++++-----
 drivers/usb/misc/chaoskey.c |  4 ++++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
index e9e5ae5..6e70597 100644
--- a/drivers/usb/misc/Kconfig
+++ b/drivers/usb/misc/Kconfig
@@ -260,11 +260,12 @@ config USB_CHAOSKEY
 	tristate "ChaosKey random number generator driver support"
 	depends on HW_RANDOM
 	help
-	  Say Y here if you want to connect an AltusMetrum ChaosKey to
-	  your computer's USB port. The ChaosKey is a hardware random
-	  number generator which hooks into the kernel entropy pool to
-	  ensure a large supply of entropy for /dev/random and
-	  /dev/urandom and also provides direct access via /dev/chaoskeyX
+	  Say Y here if you want to connect an AltusMetrum ChaosKey or
+	  Araneus Alea I to your computer's USB port. These devices
+	  are hardware random number generators which hook into the
+	  kernel entropy pool to ensure a large supply of entropy for
+	  /dev/random and /dev/urandom and also provides direct access
+	  via /dev/chaoskeyX
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called chaoskey.
diff --git a/drivers/usb/misc/chaoskey.c b/drivers/usb/misc/chaoskey.c
index 76350e4..9aef46b 100644
--- a/drivers/usb/misc/chaoskey.c
+++ b/drivers/usb/misc/chaoskey.c
@@ -55,6 +55,9 @@ MODULE_LICENSE("GPL");
 #define CHAOSKEY_VENDOR_ID	0x1d50	/* OpenMoko */
 #define CHAOSKEY_PRODUCT_ID	0x60c6	/* ChaosKey */
 
+#define ALEA_VENDOR_ID		0x12d8	/* Araneus */
+#define ALEA_PRODUCT_ID		0x0001	/* Alea I */
+
 #define CHAOSKEY_BUF_LEN	64	/* max size of USB full speed packet */
 
 #define NAK_TIMEOUT (HZ)		/* stall/wait timeout for device */
@@ -69,6 +72,7 @@ MODULE_LICENSE("GPL");
 
 static const struct usb_device_id chaoskey_table[] = {
 	{ USB_DEVICE(CHAOSKEY_VENDOR_ID, CHAOSKEY_PRODUCT_ID) },
+	{ USB_DEVICE(ALEA_VENDOR_ID, ALEA_PRODUCT_ID) },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, chaoskey_table);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
