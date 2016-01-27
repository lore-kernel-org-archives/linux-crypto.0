From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: aead - move aead_request_cast helper to aead.h
Date: Wed, 27 Jan 2016 14:09:16 -0800
Message-ID: <20160127220916.12466.99501.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: smueller@chronox.de, tadeusz.struk@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Move the helper function to common header for everybody to use.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/atmel-aes.c |    6 ------
 include/crypto/aead.h      |    6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 6dd3317..949af89 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -369,12 +369,6 @@ static inline size_t atmel_aes_padlen(size_t len, size_t block_size)
 	return len ? block_size - len : 0;
 }
 
-static inline struct aead_request *
-aead_request_cast(struct crypto_async_request *req)
-{
-	return container_of(req, struct aead_request, base);
-}
-
 static struct atmel_aes_dev *atmel_aes_find_dev(struct atmel_aes_base_ctx *ctx)
 {
 	struct atmel_aes_dev *aes_dd = NULL;
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 84d13b1..2de15fc 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -304,6 +304,12 @@ static inline struct crypto_aead *crypto_aead_reqtfm(struct aead_request *req)
 	return __crypto_aead_cast(req->base.tfm);
 }
 
+static inline struct aead_request *aead_request_cast(
+					struct crypto_async_request *req)
+{
+	return container_of(req, struct aead_request, base);
+}
+
 /**
  * crypto_aead_encrypt() - encrypt plaintext
  * @req: reference to the aead_request handle that holds all information
