From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 31/35] crypto: hash - Zap unaligned buffers
Date: Wed, 15 Jul 2009 15:16:25 +0800
Message-ID: <E1MQyj3-00052D-Ue@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48342 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752874AbZGOHga (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:36:30 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyj5-0004vw-Ch
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:28 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: hash - Zap unaligned buffers

Some unaligned buffers on the stack weren't zapped properly which
may cause secret data to be leaked.  This patch fixes them by doing
a zero memset.

It is also possible for us to place random kernel stack contents
in the digest buffer if a digest operation fails.  This is fixed
by only copying if the operation succeeded.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ahash.c |    3 +--
 crypto/shash.c |   14 +++++++++++---
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index cc824ef..1576f95 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -152,8 +152,7 @@ static int ahash_setkey_unaligned(struct crypto_ahash *tfm, const u8 *key,
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	ret = ahash->setkey(tfm, alignbuffer, keylen);
-	memset(alignbuffer, 0, keylen);
-	kfree(buffer);
+	kzfree(buffer);
 	return ret;
 }
 
diff --git a/crypto/shash.c b/crypto/shash.c
index fd92c03..e543283 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -45,8 +45,7 @@ static int shash_setkey_unaligned(struct crypto_shash *tfm, const u8 *key,
 	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
 	memcpy(alignbuffer, key, keylen);
 	err = shash->setkey(tfm, alignbuffer, keylen);
-	memset(alignbuffer, 0, keylen);
-	kfree(buffer);
+	kzfree(buffer);
 	return err;
 }
 
@@ -79,13 +78,16 @@ static int shash_update_unaligned(struct shash_desc *desc, const u8 *data,
 				     ((unsigned long)data & alignmask);
 	u8 buf[shash_align_buffer_size(unaligned_len, alignmask)]
 		__attribute__ ((aligned));
+	int err;
 
 	if (unaligned_len > len)
 		unaligned_len = len;
 
 	memcpy(buf, data, unaligned_len);
+	err = shash->update(desc, buf, unaligned_len);
+	memset(buf, 0, unaligned_len);
 
-	return shash->update(desc, buf, unaligned_len) ?:
+	return err ?:
 	       shash->update(desc, data + unaligned_len, len - unaligned_len);
 }
 
@@ -114,7 +116,13 @@ static int shash_final_unaligned(struct shash_desc *desc, u8 *out)
 	int err;
 
 	err = shash->final(desc, buf);
+	if (err)
+		goto out;
+
 	memcpy(out, buf, ds);
+
+out:
+	memset(buf, 0, ds);
 	return err;
 }
 
