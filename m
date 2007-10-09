From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [RFC 3/3] pass keysize to crypto_alloc_blkcipher()
Date: Tue, 9 Oct 2007 21:43:56 +0200
Message-ID: <E1IfejW-0005Er-DT@Chamillionaire.breakpoint.cc>
References: <20071010164400.GA19471@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.5.3.4"
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:54609 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754341AbXJJQsc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Oct 2007 12:48:32 -0400
In-Reply-To: <20071010164400.GA19471@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is a multi-part message in MIME format.
--------------1.5.3.4
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


and fix dm-crypt, wlan stack and trcypt
---
 crypto/tcrypt.c                      |   26 +++++++++++++++-----------
 drivers/md/dm-crypt.c                |    2 +-
 include/linux/crypto.h               |    6 +++---
 net/ieee80211/ieee80211_crypt_tkip.c |    4 ++--
 net/ieee80211/ieee80211_crypt_wep.c  |    6 ++++--
 5 files changed, 25 insertions(+), 19 deletions(-)
--------------1.5.3.4
Content-Type: text/x-patch; name="31317613c156e71eb741afded34554c35ddc83fc.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="31317613c156e71eb741afded34554c35ddc83fc.diff"

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 18d489c..456eb2b 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -501,21 +501,11 @@ static void test_cipher_speed(char *algo, int enc, unsigned int sec,
 
 	printk("\ntesting speed of %s %s\n", algo, e);
 
-	tfm = crypto_alloc_blkcipher(algo, 0, CRYPTO_ALG_ASYNC);
-
-	if (IS_ERR(tfm)) {
-		printk("failed to load transform for %s: %ld\n", algo,
-		       PTR_ERR(tfm));
-		return;
-	}
-	desc.tfm = tfm;
-	desc.flags = 0;
-
 	for (i = 0; speed[i].klen != 0; i++) {
 		if ((speed[i].blen + speed[i].klen) > TVMEMSIZE) {
 			printk("template (%u) too big for tvmem (%u)\n",
 			       speed[i].blen + speed[i].klen, TVMEMSIZE);
-			goto out;
+			return;
 		}
 
 		printk("test %u (%d bit key, %d byte blocks): ", i,
@@ -531,6 +521,18 @@ static void test_cipher_speed(char *algo, int enc, unsigned int sec,
 				break;
 			}
 		}
+
+		tfm = crypto_alloc_blkcipher(algo, speed[i].klen, 0,
+				CRYPTO_ALG_ASYNC);
+
+		if (IS_ERR(tfm)) {
+			printk("failed to load transform for %s: %ld\n", algo,
+					PTR_ERR(tfm));
+			return;
+		}
+		desc.tfm = tfm;
+		desc.flags = 0;
+
 		p = (unsigned char *)tvmem + speed[i].klen;
 
 		ret = crypto_blkcipher_setkey(tfm, key, speed[i].klen);
@@ -556,7 +558,9 @@ static void test_cipher_speed(char *algo, int enc, unsigned int sec,
 			printk("%s() failed flags=%x\n", e, desc.flags);
 			break;
 		}
+		crypto_free_blkcipher(tfm);
 	}
+	return;
 
 out:
 	crypto_free_blkcipher(tfm);
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index bdc52d6..ba5a7df 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -794,7 +794,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad1;
 	}
 
-	tfm = crypto_alloc_blkcipher(cc->cipher, 0, CRYPTO_ALG_ASYNC);
+	tfm = crypto_alloc_blkcipher(cc->cipher, key_size, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm)) {
 		ti->error = "Error allocating crypto tfm";
 		goto bad1;
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index bbc15d0..c6b6d30 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -860,14 +860,14 @@ static inline struct crypto_blkcipher *crypto_blkcipher_cast(
 }
 
 static inline struct crypto_blkcipher *crypto_alloc_blkcipher(
-	const char *alg_name, u32 type, u32 mask)
+	const char *alg_name, u32 keysize, u32 type, u32 mask)
 {
 	type &= ~(CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC);
 	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
 	mask |= CRYPTO_ALG_TYPE_MASK | CRYPTO_ALG_ASYNC;
 
-	return __crypto_blkcipher_cast(crypto_alloc_base(alg_name, 0, type,
-				mask));
+	return __crypto_blkcipher_cast(crypto_alloc_base(alg_name, keysize,
+				type, mask));
 }
 
 static inline struct crypto_tfm *crypto_blkcipher_tfm(
diff --git a/net/ieee80211/ieee80211_crypt_tkip.c b/net/ieee80211/ieee80211_crypt_tkip.c
index 5a48d8e..696a451 100644
--- a/net/ieee80211/ieee80211_crypt_tkip.c
+++ b/net/ieee80211/ieee80211_crypt_tkip.c
@@ -89,7 +89,7 @@ static void *ieee80211_tkip_init(int key_idx)
 
 	priv->key_idx = key_idx;
 
-	priv->tx_tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0,
+	priv->tx_tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0, 0,
 						CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->tx_tfm_arc4)) {
 		printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
@@ -107,7 +107,7 @@ static void *ieee80211_tkip_init(int key_idx)
 		goto fail;
 	}
 
-	priv->rx_tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0,
+	priv->rx_tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0, 0,
 						CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->rx_tfm_arc4)) {
 		printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
diff --git a/net/ieee80211/ieee80211_crypt_wep.c b/net/ieee80211/ieee80211_crypt_wep.c
index 8d18245..fcf989d 100644
--- a/net/ieee80211/ieee80211_crypt_wep.c
+++ b/net/ieee80211/ieee80211_crypt_wep.c
@@ -47,7 +47,8 @@ static void *prism2_wep_init(int keyidx)
 		goto fail;
 	priv->key_idx = keyidx;
 
-	priv->tx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
+	priv->tx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0, 0,
+			CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->tx_tfm)) {
 		printk(KERN_DEBUG "ieee80211_crypt_wep: could not allocate "
 		       "crypto API arc4\n");
@@ -55,7 +56,8 @@ static void *prism2_wep_init(int keyidx)
 		goto fail;
 	}
 
-	priv->rx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
+	priv->rx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0, 0,
+			CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->rx_tfm)) {
 		printk(KERN_DEBUG "ieee80211_crypt_wep: could not allocate "
 		       "crypto API arc4\n");

--------------1.5.3.4--
