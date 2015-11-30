From: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
Subject: [PATCH 1/2] IV size failing on skcipher API
Date: Mon, 30 Nov 2015 16:19:03 -0200
Message-ID: <20151130181859.GA15519@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: pfsmorigo@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

IV size was zero on CBC and CTR modes,
causing a bug triggered by skcipher.

Fixing this  adding a correct size.

Signed-off-by: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
Signed-off-by: Paulo Smorigo <pfsmorigo@linux.vnet.ibm.com>
---
 drivers/crypto/vmx/aes_cbc.c | 2 +-
 drivers/crypto/vmx/aes_ctr.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/vmx/aes_cbc.c b/drivers/crypto/vmx/aes_cbc.c
index 0b8fe2e..78a9786 100644
--- a/drivers/crypto/vmx/aes_cbc.c
+++ b/drivers/crypto/vmx/aes_cbc.c
@@ -191,7 +191,7 @@ struct crypto_alg p8_aes_cbc_alg = {
 	.cra_init = p8_aes_cbc_init,
 	.cra_exit = p8_aes_cbc_exit,
 	.cra_blkcipher = {
-			  .ivsize = 0,
+			  .ivsize = AES_BLOCK_SIZE,
 			  .min_keysize = AES_MIN_KEY_SIZE,
 			  .max_keysize = AES_MAX_KEY_SIZE,
 			  .setkey = p8_aes_cbc_setkey,
diff --git a/drivers/crypto/vmx/aes_ctr.c b/drivers/crypto/vmx/aes_ctr.c
index ee1306c..1febc4f 100644
--- a/drivers/crypto/vmx/aes_ctr.c
+++ b/drivers/crypto/vmx/aes_ctr.c
@@ -175,7 +175,7 @@ struct crypto_alg p8_aes_ctr_alg = {
 	.cra_init = p8_aes_ctr_init,
 	.cra_exit = p8_aes_ctr_exit,
 	.cra_blkcipher = {
-			  .ivsize = 0,
+			  .ivsize = AES_BLOCK_SIZE,
 			  .min_keysize = AES_MIN_KEY_SIZE,
 			  .max_keysize = AES_MAX_KEY_SIZE,
 			  .setkey = p8_aes_ctr_setkey,
-- 
2.1.0
