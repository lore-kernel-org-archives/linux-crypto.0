From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH] crypto/arc4: convert this stream cipher into a block cipher
Date: Fri, 12 Feb 2010 09:42:28 +0100
Message-ID: <20100212084228.GA1535@Chamillionaire.breakpoint.cc>
References: <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com>
 <20100209073718.GA17612@gondor.apana.org.au>
 <20100209145705.GA20421@Chamillionaire.breakpoint.cc>
 <20100209204519.GC26258@gondor.apana.org.au>
 <20100209211238.GC21548@Chamillionaire.breakpoint.cc>
 <20100209214522.GA27002@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Mikulas Patocka <mpatocka@redhat.com>, mbroz@redhat.com,
	dm-devel@redhat.com, agk@redhat.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60009 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751641Ab0BLIme (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Feb 2010 03:42:34 -0500
Content-Disposition: inline
In-Reply-To: <20100209214522.GA27002@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

the state has been moved from ctx into iv. That way encrypt()/decrypt() can
deliver the same result for a given IV. This patch makes the cipher work with
dm-crypt not that it is a good thing. However, the performance may have
improved :)
The name is still ecb(aes) but since this is provided by the blkcipher itself,
I removed the select statement.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
I had it run with wireless and dm-crypt. No problems so far. Not sure if
it makes sense to rename it to arc4 and strip the ecb prefix. It would
make it consistent with salsa but would require another patch.

 crypto/Kconfig                       |    2 +-
 crypto/arc4.c                        |  120 ++++++++++++++++++++++++----------
 crypto/testmgr.h                     |    3 +-
 drivers/net/Kconfig                  |    1 -
 drivers/net/wireless/hostap/Kconfig  |    2 -
 drivers/net/wireless/ipw2x00/Kconfig |    2 -
 net/mac80211/Kconfig                 |    1 -
 7 files changed, 87 insertions(+), 44 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 81c185a..5fab1c3 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -561,7 +561,7 @@ config CRYPTO_ANUBIS
 
 config CRYPTO_ARC4
 	tristate "ARC4 cipher algorithm"
-	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
 	help
 	  ARC4 cipher algorithm.
 
diff --git a/crypto/arc4.c b/crypto/arc4.c
index 8be47e1..b67b656 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * Cryptographic API
  *
  * ARC4 Cipher Algorithm
@@ -13,76 +13,124 @@
  */
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/crypto.h>
+#include <crypto/algapi.h>
 
 #define ARC4_MIN_KEY_SIZE	1
 #define ARC4_MAX_KEY_SIZE	256
 #define ARC4_BLOCK_SIZE		1
 
-struct arc4_ctx {
+struct arc4_iv {
 	u8 S[256];
 	u8 x, y;
 };
 
+struct arc4_ctx {
+	struct arc4_iv iv;
+	u8 new_key;
+};
+
 static int arc4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 			unsigned int key_len)
 {
 	struct arc4_ctx *ctx = crypto_tfm_ctx(tfm);
 	int i, j = 0, k = 0;
 
-	ctx->x = 1;
-	ctx->y = 0;
+	ctx->iv.x = 1;
+	ctx->iv.y = 0;
 
-	for(i = 0; i < 256; i++)
-		ctx->S[i] = i;
+	for (i = 0; i < 256; i++)
+		ctx->iv.S[i] = i;
 
-	for(i = 0; i < 256; i++)
+	for (i = 0; i < 256; i++)
 	{
-		u8 a = ctx->S[i];
+		u8 a = ctx->iv.S[i];
 		j = (j + in_key[k] + a) & 0xff;
-		ctx->S[i] = ctx->S[j];
-		ctx->S[j] = a;
-		if(++k >= key_len)
+		ctx->iv.S[i] = ctx->iv.S[j];
+		ctx->iv.S[j] = a;
+		if (++k >= key_len)
 			k = 0;
 	}
-
+	ctx->new_key = 1;
 	return 0;
 }
 
-static void arc4_crypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void arc4_ivsetup(struct arc4_ctx *ctx, u8 *iv)
 {
-	struct arc4_ctx *ctx = crypto_tfm_ctx(tfm);
+	if (unlikely(!ctx->new_key))
+		return;
+	memcpy(iv, &ctx->iv, sizeof(ctx->iv));
+	ctx->new_key = 0;
+}
 
-	u8 *const S = ctx->S;
-	u8 x = ctx->x;
-	u8 y = ctx->y;
+static int arc4_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	struct crypto_blkcipher *tfm = desc->tfm;
+	struct arc4_ctx *ctx = crypto_blkcipher_ctx(tfm);
+	struct arc4_iv *iv;
+	u8 *S;
+	u8 x;
+	u8 y;
 	u8 a, b;
+	int ret;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	ret = blkcipher_walk_virt(desc, &walk);
+	if (ret)
+		return ret;
+
+	arc4_ivsetup(ctx, walk.iv);
+
+	iv = (struct arc4_iv *)walk.iv;
+
+	S = iv->S;
+	x = iv->x;
+	y = iv->y;
+
+	while (walk.nbytes) {
+		u8 *in = walk.src.virt.addr;
+		u8 *out = walk.dst.virt.addr;
+		u32 i;
+
+		for (i = 0; i < walk.nbytes; i++) {
+			a = S[x];
+			y = (y + a) & 0xff;
+			b = S[y];
+			S[x] = b;
+			S[y] = a;
+			x = (x + 1) & 0xff;
+			*out = *in ^ S[(a + b) & 0xff];
+
+			in++;
+			out++;
+		}
+		ret = blkcipher_walk_done(desc, &walk, 0);
+		WARN_ON(ret < 0);
+	}
 
-	a = S[x];
-	y = (y + a) & 0xff;
-	b = S[y];
-	S[x] = b;
-	S[y] = a;
-	x = (x + 1) & 0xff;
-	*out++ = *in ^ S[(a + b) & 0xff];
-
-	ctx->x = x;
-	ctx->y = y;
+	iv->x = x;
+	iv->y = y;
+	return ret;
 }
 
 static struct crypto_alg arc4_alg = {
-	.cra_name		=	"arc4",
-	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
+	.cra_name		=	"ecb(arc4)",
+	.cra_priority		=	100,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
 	.cra_blocksize		=	ARC4_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct arc4_ctx),
+	.cra_type		=	&crypto_blkcipher_type,
+	.cra_alignmask		=	3,
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(arc4_alg.cra_list),
-	.cra_u			=	{ .cipher = {
-	.cia_min_keysize	=	ARC4_MIN_KEY_SIZE,
-	.cia_max_keysize	=	ARC4_MAX_KEY_SIZE,
-	.cia_setkey	   	= 	arc4_set_key,
-	.cia_encrypt	 	=	arc4_crypt,
-	.cia_decrypt	  	=	arc4_crypt } }
+	.cra_u			=	{ .blkcipher = {
+	.min_keysize		=	ARC4_MIN_KEY_SIZE,
+	.max_keysize		=	ARC4_MAX_KEY_SIZE,
+	.ivsize			=	sizeof(struct arc4_iv),
+	.setkey			=	arc4_set_key,
+	.encrypt		=	arc4_crypt,
+	.decrypt		=	arc4_crypt } }
 };
 
 static int __init arc4_init(void)
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index fb76517..423cf86 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -24,7 +24,8 @@
 #define MAX_TAP			8
 
 #define MAX_KEYLEN		56
-#define MAX_IVLEN		32
+/* sizeof arc4_iv */
+#define MAX_IVLEN		260
 
 struct hash_testvec {
 	/* only used with keyed hash algorithms */
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index dd9a09c..ddce826 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -3076,7 +3076,6 @@ config PPP_MPPE
        select CRYPTO
        select CRYPTO_SHA1
        select CRYPTO_ARC4
-       select CRYPTO_ECB
        ---help---
          Support for the MPPE Encryption protocol, as employed by the
 	 Microsoft Point-to-Point Tunneling Protocol.
diff --git a/drivers/net/wireless/hostap/Kconfig b/drivers/net/wireless/hostap/Kconfig
index 287d827..2548b56 100644
--- a/drivers/net/wireless/hostap/Kconfig
+++ b/drivers/net/wireless/hostap/Kconfig
@@ -5,10 +5,8 @@ config HOSTAP
 	select WEXT_PRIV
 	select CRYPTO
 	select CRYPTO_ARC4
-	select CRYPTO_ECB
 	select CRYPTO_AES
 	select CRYPTO_MICHAEL_MIC
-	select CRYPTO_ECB
 	select CRC32
 	select LIB80211
 	select LIB80211_CRYPT_WEP
diff --git a/drivers/net/wireless/ipw2x00/Kconfig b/drivers/net/wireless/ipw2x00/Kconfig
index 2715b10..2f2b7d9 100644
--- a/drivers/net/wireless/ipw2x00/Kconfig
+++ b/drivers/net/wireless/ipw2x00/Kconfig
@@ -159,10 +159,8 @@ config LIBIPW
 	select WEXT_SPY
 	select CRYPTO
 	select CRYPTO_ARC4
-	select CRYPTO_ECB
 	select CRYPTO_AES
 	select CRYPTO_MICHAEL_MIC
-	select CRYPTO_ECB
 	select CRC32
 	select LIB80211
 	select LIB80211_CRYPT_WEP
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index a10d508..7925f44 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -2,7 +2,6 @@ config MAC80211
 	tristate "Generic IEEE 802.11 Networking Stack (mac80211)"
 	depends on CFG80211
 	select CRYPTO
-	select CRYPTO_ECB
 	select CRYPTO_ARC4
 	select CRYPTO_AES
 	select CRC32
-- 
1.6.6.1

