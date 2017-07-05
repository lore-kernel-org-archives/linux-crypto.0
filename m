From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 1/3] crypto: kpp: add get/set_flags helpers
Date: Wed, 5 Jul 2017 13:07:58 +0300
Message-ID: <1499249280-31779-2-git-send-email-tudor.ambarus@microchip.com>
References: <1499249280-31779-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <wsa@the-dreams.de>,
        <linux-i2c@vger.kernel.org>, <nicolas.ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-i2c-owner@vger.kernel.org>
In-Reply-To: <1499249280-31779-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-i2c-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

These helpers will be used for fallbacks to kpp software
implementations.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 include/crypto/kpp.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
index 2133d17..1bde0a6 100644
--- a/include/crypto/kpp.h
+++ b/include/crypto/kpp.h
@@ -145,6 +145,16 @@ static inline struct crypto_kpp *crypto_kpp_reqtfm(struct kpp_request *req)
 	return __crypto_kpp_tfm(req->base.tfm);
 }
 
+static inline u32 crypto_kpp_get_flags(struct crypto_kpp *tfm)
+{
+	return crypto_tfm_get_flags(crypto_kpp_tfm(tfm));
+}
+
+static inline void crypto_kpp_set_flags(struct crypto_kpp *tfm, u32 flags)
+{
+	crypto_tfm_set_flags(crypto_kpp_tfm(tfm), flags);
+}
+
 /**
  * crypto_free_kpp() - free KPP tfm handle
  *
-- 
2.7.4
