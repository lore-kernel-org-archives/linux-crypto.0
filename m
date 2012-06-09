From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/3] crypto: arc4: improve performance by adding ecb(arc4)
Date: Sat, 09 Jun 2012 18:25:40 +0300
Message-ID: <20120609152540.16420.59059.stgit@localhost6.localdomain6>
References: <20120609152535.16420.13917.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Jon Oberheide <jon@oberheide.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:54521 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab2FIPZn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 9 Jun 2012 11:25:43 -0400
In-Reply-To: <20120609152535.16420.13917.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently arc4.c provides simple one-byte blocksize cipher which is wrapped
by ecb() module, giving function call overhead on every encrypted byte. This
patch adds ecb(arc4) directly into arc4.c for higher performance.

tcrypt results (speed ratios: new/old):

AMD Phenom II, x86-64 : x2.7
Intel Core 2, x86-64  : x1.9
Intel Atom N260, i386 : x1.4

Cc: Jon Oberheide <jon@oberheide.org>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/arc4.c |  109 +++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 87 insertions(+), 22 deletions(-)

diff --git a/crypto/arc4.c b/crypto/arc4.c
index 0d12a96..07913fc 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -11,9 +11,11 @@
  * (at your option) any later version.
  *
  */
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/crypto.h>
+#include <crypto/algapi.h>
 
 #define ARC4_MIN_KEY_SIZE	1
 #define ARC4_MAX_KEY_SIZE	256
@@ -48,51 +50,114 @@ static int arc4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	return 0;
 }
 
-static void arc4_crypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void arc4_crypt(struct arc4_ctx *ctx, u8 *out, const u8 *in,
+		       unsigned int len)
 {
-	struct arc4_ctx *ctx = crypto_tfm_ctx(tfm);
-
 	u8 *const S = ctx->S;
-	u8 x = ctx->x;
-	u8 y = ctx->y;
-	u8 a, b;
+	u8 x, y, a, b;
+	u8 ty, ta, tb;
+
+	if (len == 0)
+		return;
+
+	x = ctx->x;
+	y = ctx->y;
 
 	a = S[x];
 	y = (y + a) & 0xff;
 	b = S[y];
-	S[x] = b;
-	S[y] = a;
-	x = (x + 1) & 0xff;
-	*out++ = *in ^ S[(a + b) & 0xff];
+
+	do {
+		S[y] = a;
+		a = (a + b) & 0xff;
+		S[x] = b;
+		x = (x + 1) & 0xff;
+		ta = S[x];
+		ty = (y + ta) & 0xff;
+		tb = S[ty];
+		*out++ = *in++ ^ S[a];
+		if (--len == 0)
+			break;
+		y = ty;
+		a = ta;
+		b = tb;
+	} while (true);
 
 	ctx->x = x;
 	ctx->y = y;
 }
 
-static struct crypto_alg arc4_alg = {
+static void arc4_crypt_one(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+{
+	arc4_crypt(crypto_tfm_ctx(tfm), out, in, 1);
+}
+
+static int ecb_arc4_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+			  struct scatterlist *src, unsigned int nbytes)
+{
+	struct arc4_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct blkcipher_walk walk;
+	int err;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while (walk.nbytes > 0) {
+		u8 *wsrc = walk.src.virt.addr;
+		u8 *wdst = walk.dst.virt.addr;
+
+		arc4_crypt(ctx, wdst, wsrc, walk.nbytes);
+
+		err = blkcipher_walk_done(desc, &walk, 0);
+	}
+
+	return err;
+}
+
+static struct crypto_alg arc4_algs[2] = { {
 	.cra_name		=	"arc4",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	ARC4_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct arc4_ctx),
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(arc4_alg.cra_list),
-	.cra_u			=	{ .cipher = {
-	.cia_min_keysize	=	ARC4_MIN_KEY_SIZE,
-	.cia_max_keysize	=	ARC4_MAX_KEY_SIZE,
-	.cia_setkey		=	arc4_set_key,
-	.cia_encrypt		=	arc4_crypt,
-	.cia_decrypt		=	arc4_crypt } }
-};
+	.cra_u			=	{
+		.cipher = {
+			.cia_min_keysize	=	ARC4_MIN_KEY_SIZE,
+			.cia_max_keysize	=	ARC4_MAX_KEY_SIZE,
+			.cia_setkey		=	arc4_set_key,
+			.cia_encrypt		=	arc4_crypt_one,
+			.cia_decrypt		=	arc4_crypt_one,
+		},
+	},
+}, {
+	.cra_name		=	"ecb(arc4)",
+	.cra_priority		=	100,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=	ARC4_BLOCK_SIZE,
+	.cra_ctxsize		=	sizeof(struct arc4_ctx),
+	.cra_alignmask		=	0,
+	.cra_type		=	&crypto_blkcipher_type,
+	.cra_module		=	THIS_MODULE,
+	.cra_u			=	{
+		.blkcipher = {
+			.min_keysize	=	ARC4_MIN_KEY_SIZE,
+			.max_keysize	=	ARC4_MAX_KEY_SIZE,
+			.setkey		=	arc4_set_key,
+			.encrypt	=	ecb_arc4_crypt,
+			.decrypt	=	ecb_arc4_crypt,
+		},
+	},
+} };
 
 static int __init arc4_init(void)
 {
-	return crypto_register_alg(&arc4_alg);
+	return crypto_register_algs(arc4_algs, ARRAY_SIZE(arc4_algs));
 }
 
-
 static void __exit arc4_exit(void)
 {
-	crypto_unregister_alg(&arc4_alg);
+	crypto_unregister_algs(arc4_algs, ARRAY_SIZE(arc4_algs));
 }
 
 module_init(arc4_init);
