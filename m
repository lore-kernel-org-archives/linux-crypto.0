From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/5] [CRYPTO] cbc: Require block size to be a power of 2
Date: Thu, 22 Nov 2007 16:37:47 +0800
Message-ID: <E1Iv7ZD-0001wQ-00@gondolin.me.apana.org.au>
References: <20071122083656.GB7368@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4617 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751182AbXKVIsE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 03:48:04 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Iv7j6-0008A8-VQ
	for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 19:48:01 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] cbc: Require block size to be a power of 2

All common block ciphers have a block size that's a power of 2.  In fact,
all of our block ciphers obey this rule.

If we require this then CBC can be optimised to avoid an expensive divide
on in-place decryption.

I've also changed the saving of the first IV in the in-place decryption
case to the last IV because that lets us use walk->iv (which is already
aligned) for the xor operation where alignment is required.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cbc.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/crypto/cbc.c b/crypto/cbc.c
index b013d6f..6affff8 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -14,6 +14,7 @@
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/log2.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
@@ -143,17 +144,13 @@ static int crypto_cbc_decrypt_inplace(struct blkcipher_desc *desc,
 	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		crypto_cipher_alg(tfm)->cia_decrypt;
 	int bsize = crypto_cipher_blocksize(tfm);
-	unsigned long alignmask = crypto_cipher_alignmask(tfm);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
-	u8 stack[bsize + alignmask];
-	u8 *first_iv = (u8 *)ALIGN((unsigned long)stack, alignmask + 1);
-
-	memcpy(first_iv, walk->iv, bsize);
+	u8 last_iv[bsize];
 
 	/* Start of the last block. */
-	src += nbytes - nbytes % bsize - bsize;
-	memcpy(walk->iv, src, bsize);
+	src += nbytes - (nbytes & (bsize - 1)) - bsize;
+	memcpy(last_iv, src, bsize);
 
 	for (;;) {
 		fn(crypto_cipher_tfm(tfm), src, src);
@@ -163,7 +160,8 @@ static int crypto_cbc_decrypt_inplace(struct blkcipher_desc *desc,
 		src -= bsize;
 	}
 
-	crypto_xor(src, first_iv, bsize);
+	crypto_xor(src, walk->iv, bsize);
+	memcpy(walk->iv, last_iv, bsize);
 
 	return nbytes;
 }
@@ -228,6 +226,10 @@ static struct crypto_instance *crypto_cbc_alloc(struct rtattr **tb)
 	if (IS_ERR(alg))
 		return ERR_PTR(PTR_ERR(alg));
 
+	inst = ERR_PTR(-EINVAL);
+	if (!is_power_of_2(alg->cra_blocksize))
+		goto out_put_alg;
+
 	inst = crypto_alloc_instance("cbc", alg);
 	if (IS_ERR(inst))
 		goto out_put_alg;
