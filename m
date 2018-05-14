From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [PATCH 1/5] crypto:chtls: key len correction
Date: Mon, 14 May 2018 16:30:55 +0530
Message-ID: <1526295659-29839-2-git-send-email-atul.gupta@chelsio.com>
References: <1526295659-29839-1-git-send-email-atul.gupta@chelsio.com>
Cc: gustavo@embeddedor.com, dan.carpenter@oracle.com,
        netdev@vger.kernel.org, davem@davemloft.net, atul.gupta@chelsio.com
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1526295659-29839-1-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

corrected the key length to copy 128b key. Removed 192b and 256b
key as user input supports key of size 128b in gcm_ctx

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_hw.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_hw.c b/drivers/crypto/chelsio/chtls/chtls_hw.c
index 54a13aa9..55d5014 100644
--- a/drivers/crypto/chelsio/chtls/chtls_hw.c
+++ b/drivers/crypto/chelsio/chtls/chtls_hw.c
@@ -213,7 +213,7 @@ static int chtls_key_info(struct chtls_sock *csk,
 			  struct _key_ctx *kctx,
 			  u32 keylen, u32 optname)
 {
-	unsigned char key[CHCR_KEYCTX_CIPHER_KEY_SIZE_256];
+	unsigned char key[AES_KEYSIZE_128];
 	struct tls12_crypto_info_aes_gcm_128 *gcm_ctx;
 	unsigned char ghash_h[AEAD_H_SIZE];
 	struct crypto_cipher *cipher;
@@ -228,10 +228,6 @@ static int chtls_key_info(struct chtls_sock *csk,
 
 	if (keylen == AES_KEYSIZE_128) {
 		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_128;
-	} else if (keylen == AES_KEYSIZE_192) {
-		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_192;
-	} else if (keylen == AES_KEYSIZE_256) {
-		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_256;
 	} else {
 		pr_err("GCM: Invalid key length %d\n", keylen);
 		return -EINVAL;
-- 
1.8.3.1
