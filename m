From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 03/18] crypto: lrw: split gf128mul table initialization from
	setkey
Date: Tue, 18 Oct 2011 13:32:24 +0300
Message-ID: <20111018103224.3074.92875.stgit@localhost6.localdomain6>
References: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:39029 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab1JRKc1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Oct 2011 06:32:27 -0400
In-Reply-To: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Split gf128mul initialization from setkey so that it can be used outside
lrw-module.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/lrw.c |   61 ++++++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index bee6022..91c17fa 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -29,8 +29,7 @@
 
 #define LRW_BLOCK_SIZE 16
 
-struct priv {
-	struct crypto_cipher *child;
+struct lrw_table_ctx {
 	/* optimizes multiplying a random (non incrementing, as at the
 	 * start of a new sector) value with key2, we could also have
 	 * used 4k optimization tables or no optimization at all. In the
@@ -45,6 +44,11 @@ struct priv {
 	be128 mulinc[128];
 };
 
+struct priv {
+	struct crypto_cipher *child;
+	struct lrw_table_ctx table;
+};
+
 static inline void setbit128_bbe(void *b, int bit)
 {
 	__set_bit(bit ^ (0x80 -
@@ -56,28 +60,16 @@ static inline void setbit128_bbe(void *b, int bit)
 			), b);
 }
 
-static int setkey(struct crypto_tfm *parent, const u8 *key,
-		  unsigned int keylen)
+static int lrw_init_table(struct lrw_table_ctx *ctx, const u8 *tweak)
 {
-	struct priv *ctx = crypto_tfm_ctx(parent);
-	struct crypto_cipher *child = ctx->child;
-	int err, i;
 	be128 tmp = { 0 };
-	int bsize = LRW_BLOCK_SIZE;
-
-	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
-				       CRYPTO_TFM_REQ_MASK);
-	if ((err = crypto_cipher_setkey(child, key, keylen - bsize)))
-		return err;
-	crypto_tfm_set_flags(parent, crypto_cipher_get_flags(child) &
-				     CRYPTO_TFM_RES_MASK);
+	int i;
 
 	if (ctx->table)
 		gf128mul_free_64k(ctx->table);
 
 	/* initialize multiplication table for Key2 */
-	ctx->table = gf128mul_init_64k_bbe((be128 *)(key + keylen - bsize));
+	ctx->table = gf128mul_init_64k_bbe((be128 *)tweak);
 	if (!ctx->table)
 		return -ENOMEM;
 
@@ -91,6 +83,32 @@ static int setkey(struct crypto_tfm *parent, const u8 *key,
 	return 0;
 }
 
+static void lrw_free_table(struct lrw_table_ctx *ctx)
+{
+	if (ctx->table)
+		gf128mul_free_64k(ctx->table);
+}
+
+static int setkey(struct crypto_tfm *parent, const u8 *key,
+		  unsigned int keylen)
+{
+	struct priv *ctx = crypto_tfm_ctx(parent);
+	struct crypto_cipher *child = ctx->child;
+	int err, bsize = LRW_BLOCK_SIZE;
+	const u8 *tweak = key + keylen - bsize;
+
+	crypto_cipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_cipher_set_flags(child, crypto_tfm_get_flags(parent) &
+				       CRYPTO_TFM_REQ_MASK);
+	err = crypto_cipher_setkey(child, key, keylen - bsize);
+	if (err)
+		return err;
+	crypto_tfm_set_flags(parent, crypto_cipher_get_flags(child) &
+				     CRYPTO_TFM_RES_MASK);
+
+	return lrw_init_table(&ctx->table, tweak);
+}
+
 struct sinfo {
 	be128 t;
 	struct crypto_tfm *tfm;
@@ -157,7 +175,7 @@ static int crypt(struct blkcipher_desc *d,
 	s.t = *iv;
 
 	/* T <- I*Key2 */
-	gf128mul_64k_bbe(&s.t, ctx->table);
+	gf128mul_64k_bbe(&s.t, ctx->table.table);
 
 	goto first;
 
@@ -165,7 +183,8 @@ static int crypt(struct blkcipher_desc *d,
 		do {
 			/* T <- I*Key2, using the optimization
 			 * discussed in the specification */
-			be128_xor(&s.t, &s.t, &ctx->mulinc[get_index128(iv)]);
+			be128_xor(&s.t, &s.t,
+				  &ctx->table.mulinc[get_index128(iv)]);
 			inc(iv);
 
 first:
@@ -233,8 +252,8 @@ static int init_tfm(struct crypto_tfm *tfm)
 static void exit_tfm(struct crypto_tfm *tfm)
 {
 	struct priv *ctx = crypto_tfm_ctx(tfm);
-	if (ctx->table)
-		gf128mul_free_64k(ctx->table);
+
+	lrw_free_table(&ctx->table);
 	crypto_free_cipher(ctx->child);
 }
 
