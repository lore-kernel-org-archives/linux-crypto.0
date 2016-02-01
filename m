From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v2 1/2] crypto: aead - move aead_request_cast helper to
 aead.h
Date: Mon, 01 Feb 2016 11:17:30 -0800
Message-ID: <20160201191730.21093.458.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: smueller@chronox.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Move the helper function to common header for everybody to use.

changes in v2:
- move the helper to crypto/internal/aead.h
  instead of crypto/aead.h

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/atmel-aes.c     |    6 ------
 include/crypto/internal/aead.h |    6 ++++++
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
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index 5554cdd..da38649 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -80,6 +80,12 @@ static inline u32 aead_request_flags(struct aead_request *req)
 	return req->base.flags;
 }
 
+static inline struct aead_request *aead_request_cast(
+	struct crypto_async_request *req)
+{
+	return container_of(req, struct aead_request, base);
+}
+
 static inline void crypto_set_aead_spawn(
 	struct crypto_aead_spawn *spawn, struct crypto_instance *inst)
 {
