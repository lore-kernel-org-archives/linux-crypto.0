From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH] crypto/arc4: convert this stream cipher into a block
 cipher
Date: Sun, 14 Mar 2010 09:24:32 +0100
Message-ID: <20100314082432.GA1800@Chamillionaire.breakpoint.cc>
References: <20100209204519.GC26258@gondor.apana.org.au>
 <20100209211238.GC21548@Chamillionaire.breakpoint.cc>
 <20100209214522.GA27002@gondor.apana.org.au>
 <20100212084228.GA1535@Chamillionaire.breakpoint.cc>
 <20100216125125.GA390@gondor.apana.org.au>
 <20100221200140.GC11951@Chamillionaire.breakpoint.cc>
 <20100222004547.GA24812@gondor.apana.org.au>
 <20100222005217.GA24920@gondor.apana.org.au>
 <20100222220835.GB31291@Chamillionaire.breakpoint.cc>
 <20100223003239.GC9118@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Mikulas Patocka <mpatocka@redhat.com>, mbroz@redhat.com,
	dm-devel@redhat.com, agk@redhat.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:35375 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754989Ab0CNIYk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Mar 2010 04:24:40 -0400
Content-Disposition: inline
In-Reply-To: <20100223003239.GC9118@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2010-02-23 08:32:39 [+0800]:

>If you can find a way that allows arc4 to be used by multiple
>threads at the same time while storing less than 258 bytes in
>each thread, please let me know :)
:)

>No, what you could do is structure the IV differently based on the
>flag:
>
>struct arc4_iv {
>	union {
>		struct key {
>			u8 key[256];
>			u16 keylen;
>		};
>		struct iv {
>			u8 S[256];
>			u8 x, y;
>		};
>	};
>	u8 type;
>};
>
>This relies on the fact that we never use more than 256 bytes in
>the key so limiting its length is OK.

Okay. So so are we talking about something like that below then? This is
untested and I break other users bexcept lib80211_crypt_tkip. 

the state has been moved from ctx into iv. That way encrypt()/decrypt() can
deliver the same result for a given IV. If the IV is supplied as a plain
key then it wil be converted into a different internal state.
The name is now arc4.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 crypto/Kconfig                       |    2 +-
 crypto/arc4.c                        |  131 +++++++++++++++++++++++-----------
 crypto/testmgr.h                     |    3 +-
 drivers/net/Kconfig                  |    1 -
 drivers/net/wireless/hostap/Kconfig  |    2 -
 drivers/net/wireless/ipw2x00/Kconfig |    2 -
 include/crypto/arc4.h                |   26 +++++++
 net/mac80211/Kconfig                 |    1 -
 net/wireless/lib80211_crypt_tkip.c   |   10 ++-
 9 files changed, 123 insertions(+), 55 deletions(-)
 create mode 100644 include/crypto/arc4.h

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
index 8be47e1..1b20463 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * Cryptographic API
  *
  * ARC4 Cipher Algorithm
@@ -13,76 +13,122 @@
  */
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/crypto.h>
+#include <crypto/algapi.h>
+#include <crypto/arc4.h>
 
 #define ARC4_MIN_KEY_SIZE	1
 #define ARC4_MAX_KEY_SIZE	256
 #define ARC4_BLOCK_SIZE		1
 
-struct arc4_ctx {
-	u8 S[256];
-	u8 x, y;
-};
-
 static int arc4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 			unsigned int key_len)
 {
-	struct arc4_ctx *ctx = crypto_tfm_ctx(tfm);
+	/*
+	 * ARC4 is special: The user should supply an IV as struct arc4_iv and
+	 * fill either the key or the iv.
+	 */
+	return -EOPNOTSUPP;
+}
+
+static void arc4_key_to_iv(const u8 *in_key, u32 key_len, struct arc4_iv *iv)
+{
 	int i, j = 0, k = 0;
 
-	ctx->x = 1;
-	ctx->y = 0;
+	iv->iv.x = 1;
+	iv->iv.y = 0;
 
-	for(i = 0; i < 256; i++)
-		ctx->S[i] = i;
+	for (i = 0; i < 256; i++)
+		iv->iv.S[i] = i;
 
-	for(i = 0; i < 256; i++)
+	for (i = 0; i < 256; i++)
 	{
-		u8 a = ctx->S[i];
+		u8 a = iv->iv.S[i];
 		j = (j + in_key[k] + a) & 0xff;
-		ctx->S[i] = ctx->S[j];
-		ctx->S[j] = a;
-		if(++k >= key_len)
+		iv->iv.S[i] = iv->iv.S[j];
+		iv->iv.S[j] = a;
+		if (++k >= key_len)
 			k = 0;
 	}
-
-	return 0;
 }
 
-static void arc4_crypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
+static void arc4_ivsetup(struct arc4_iv *iv)
 {
-	struct arc4_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct arc4_iv tmp_iv;
 
-	u8 *const S = ctx->S;
-	u8 x = ctx->x;
-	u8 y = ctx->y;
-	u8 a, b;
+	if (iv->type == ARC4_TYPE_IV)
+		return;
 
-	a = S[x];
-	y = (y + a) & 0xff;
-	b = S[y];
-	S[x] = b;
-	S[y] = a;
-	x = (x + 1) & 0xff;
-	*out++ = *in ^ S[(a + b) & 0xff];
+	memcpy(&tmp_iv, iv, sizeof(tmp_iv));
+	arc4_key_to_iv(tmp_iv.key.key, tmp_iv.key.key_len, iv);
+	iv->type = ARC4_TYPE_IV;
+}
+
+static int arc4_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	struct arc4_iv *aiv;
+	u8 *S;
+	u8 x;
+	u8 y;
+	u8 a, b;
+	int ret;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	ret = blkcipher_walk_virt(desc, &walk);
+	if (ret)
+		return ret;
+
+	aiv = (struct arc4_iv *)walk.iv;
+	arc4_ivsetup(aiv);
+
+	S = aiv->iv.S;
+	x = aiv->iv.x;
+	y = aiv->iv.y;
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
 
-	ctx->x = x;
-	ctx->y = y;
+	aiv->iv.x = x;
+	aiv->iv.y = y;
+	return ret;
 }
 
 static struct crypto_alg arc4_alg = {
 	.cra_name		=	"arc4",
-	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
+	.cra_priority		=	100,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
 	.cra_blocksize		=	ARC4_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct arc4_ctx),
+	.cra_ctxsize		=	0,
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
@@ -90,7 +136,6 @@ static int __init arc4_init(void)
 	return crypto_register_alg(&arc4_alg);
 }
 
-
 static void __exit arc4_exit(void)
 {
 	crypto_unregister_alg(&arc4_alg);
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
diff --git a/include/crypto/arc4.h b/include/crypto/arc4.h
new file mode 100644
index 0000000..1423c92
--- /dev/null
+++ b/include/crypto/arc4.h
@@ -0,0 +1,26 @@
+#ifndef __CRYPTO_ARC4_H__
+#define __CRYPTO_ARC4_H__
+
+struct arc4_iv {
+	union {
+		struct arc4_key {
+			u8 key[256];
+			u16 key_len;
+		} key;
+		struct arc4_riv {
+			u8 S[256];
+			u8 x, y;
+		} iv;
+	};
+#define ARC4_TYPE_KEY   0
+#define ARC4_TYPE_IV    1
+	u8 type;
+};
+
+static inline void arc4_setup_iv(struct arc4_iv *iv, const u8 *key, u32 len)
+{
+	memcpy(iv->key.key, key, len);
+	iv->key.key_len = len;
+	iv->type = ARC4_TYPE_KEY;
+}
+#endif
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
diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index c362873..4c1290d 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -94,7 +94,7 @@ static void *lib80211_tkip_init(int key_idx)
 
 	priv->key_idx = key_idx;
 
-	priv->tx_tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0,
+	priv->tx_tfm_arc4 = crypto_alloc_blkcipher("arc4", 0,
 						CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->tx_tfm_arc4)) {
 		printk(KERN_DEBUG "lib80211_crypt_tkip: could not allocate "
@@ -112,7 +112,7 @@ static void *lib80211_tkip_init(int key_idx)
 		goto fail;
 	}
 
-	priv->rx_tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0,
+	priv->rx_tfm_arc4 = crypto_alloc_blkcipher("arc4", 0,
 						CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->rx_tfm_arc4)) {
 		printk(KERN_DEBUG "lib80211_crypt_tkip: could not allocate "
@@ -360,6 +360,7 @@ static int lib80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
 	struct lib80211_tkip_data *tkey = priv;
 	struct blkcipher_desc desc = { .tfm = tkey->tx_tfm_arc4 };
+	struct arc4_iv *iv = crypto_blkcipher_crt(tkey->tx_tfm_arc4)->iv;
 	int len;
 	u8 rc4key[16], *pos, *icv;
 	u32 crc;
@@ -392,7 +393,7 @@ static int lib80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	icv[2] = crc >> 16;
 	icv[3] = crc >> 24;
 
-	crypto_blkcipher_setkey(tkey->tx_tfm_arc4, rc4key, 16);
+	arc4_setup_iv(iv, rc4key, 16);
 	sg_init_one(&sg, pos, len + 4);
 	return crypto_blkcipher_encrypt(&desc, &sg, &sg, len + 4);
 }
@@ -414,6 +415,7 @@ static int lib80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
 	struct lib80211_tkip_data *tkey = priv;
 	struct blkcipher_desc desc = { .tfm = tkey->rx_tfm_arc4 };
+	struct arc4_iv *iv = crypto_blkcipher_crt(tkey->rx_tfm_arc4)->iv;
 	u8 rc4key[16];
 	u8 keyidx, *pos;
 	u32 iv32;
@@ -485,7 +487,7 @@ static int lib80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 
 	plen = skb->len - hdr_len - 12;
 
-	crypto_blkcipher_setkey(tkey->rx_tfm_arc4, rc4key, 16);
+	arc4_setup_iv(iv, rc4key, 16);
 	sg_init_one(&sg, pos, plen + 4);
 	if (crypto_blkcipher_decrypt(&desc, &sg, &sg, plen + 4)) {
 		if (net_ratelimit()) {
-- 
1.6.6

