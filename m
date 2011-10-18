From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 11/18] crypto: xts: use blocksize constant
Date: Tue, 18 Oct 2011 13:33:07 +0300
Message-ID: <20111018103307.3074.66834.stgit@localhost6.localdomain6>
References: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:43510 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab1JRKdM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Oct 2011 06:33:12 -0400
In-Reply-To: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

XTS has fixed blocksize of 16. Define XTS_BLOCK_SIZE and use in place of
crypto_cipher_blocksize().

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/xts.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 8517054..96f3f88 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -24,6 +24,8 @@
 #include <crypto/b128ops.h>
 #include <crypto/gf128mul.h>
 
+#define XTS_BLOCK_SIZE 16
+
 struct priv {
 	struct crypto_cipher *child;
 	struct crypto_cipher *tweak;
@@ -96,7 +98,7 @@ static int crypt(struct blkcipher_desc *d,
 {
 	int err;
 	unsigned int avail;
-	const int bs = crypto_cipher_blocksize(ctx->child);
+	const int bs = XTS_BLOCK_SIZE;
 	struct sinfo s = {
 		.tfm = crypto_cipher_tfm(ctx->child),
 		.fn = fn
@@ -177,7 +179,7 @@ static int init_tfm(struct crypto_tfm *tfm)
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
-	if (crypto_cipher_blocksize(cipher) != 16) {
+	if (crypto_cipher_blocksize(cipher) != XTS_BLOCK_SIZE) {
 		*flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
 		crypto_free_cipher(cipher);
 		return -EINVAL;
@@ -192,7 +194,7 @@ static int init_tfm(struct crypto_tfm *tfm)
 	}
 
 	/* this check isn't really needed, leave it here just in case */
-	if (crypto_cipher_blocksize(cipher) != 16) {
+	if (crypto_cipher_blocksize(cipher) != XTS_BLOCK_SIZE) {
 		crypto_free_cipher(cipher);
 		crypto_free_cipher(ctx->child);
 		*flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
