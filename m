From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 02/18] crypto: lrw: use blocksize constant
Date: Tue, 18 Oct 2011 13:32:19 +0300
Message-ID: <20111018103219.3074.90878.stgit@localhost6.localdomain6>
References: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:53772 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab1JRKcX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Oct 2011 06:32:23 -0400
In-Reply-To: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

LRW has fixed blocksize of 16. Define LRW_BLOCK_SIZE and use in place of
crypto_cipher_blocksize().

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/lrw.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index fca3246..bee6022 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -27,6 +27,8 @@
 #include <crypto/b128ops.h>
 #include <crypto/gf128mul.h>
 
+#define LRW_BLOCK_SIZE 16
+
 struct priv {
 	struct crypto_cipher *child;
 	/* optimizes multiplying a random (non incrementing, as at the
@@ -61,7 +63,7 @@ static int setkey(struct crypto_tfm *parent, const u8 *key,
 	struct crypto_cipher *child = ctx->child;
 	int err, i;
 	be128 tmp = { 0 };
-	int bsize = crypto_cipher_blocksize(child);
+	int bsize = LRW_BLOCK_SIZE;
 
 	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
 	crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
@@ -134,7 +136,7 @@ static int crypt(struct blkcipher_desc *d,
 {
 	int err;
 	unsigned int avail;
-	const int bs = crypto_cipher_blocksize(ctx->child);
+	const int bs = LRW_BLOCK_SIZE;
 	struct sinfo s = {
 		.tfm = crypto_cipher_tfm(ctx->child),
 		.fn = fn
@@ -218,7 +220,7 @@ static int init_tfm(struct crypto_tfm *tfm)
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
-	if (crypto_cipher_blocksize(cipher) != 16) {
+	if (crypto_cipher_blocksize(cipher) != LRW_BLOCK_SIZE) {
 		*flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
 		crypto_free_cipher(cipher);
 		return -EINVAL;
