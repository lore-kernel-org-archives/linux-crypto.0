From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/7] [CRYPTO] cbc: Optimise in-place decryption
Date: Sat, 02 Sep 2006 21:06:57 +1000
Message-ID: <E1GJTKz-0001Fu-00@gondolin.me.apana.org.au>
References: <20060902110520.GA4690@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47376 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S1751073AbWIBLG5
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Sep 2006 07:06:57 -0400
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Michal Ludvig <michal@logix.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] cbc: Optimise in-place decryption

This optimisation trades the cost of 2 copies per block versus 1 divide
for each segment.  The idea is simply to decrypt backwards.  This way
we avoid overwriting most IVs until we've used it.

Testing with tcrypt shows a performance gain of 10%, making in-place
decryption faster than in-place encryption for AES.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cbc.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/crypto/cbc.c b/crypto/cbc.c
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -159,16 +159,23 @@ static int crypto_cbc_decrypt_inplace(st
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 stack[bsize + alignmask];
-	u8 *tmp = (u8 *)ALIGN((unsigned long)stack, alignmask + 1);
+	u8 *first_iv = (u8 *)ALIGN((unsigned long)stack, alignmask + 1);
 
-	do {
-		fn(crypto_cipher_tfm(tfm), tmp, src);
-		xor(tmp, walk->iv, bsize);
-		memcpy(walk->iv, src, bsize);
-		memcpy(src, tmp, bsize);
+	memcpy(first_iv, walk->iv, bsize);
+
+	/* Start of the last block. */
+	src += nbytes - nbytes % bsize - bsize;
+	memcpy(walk->iv, src, bsize);
+
+	for (;;) {
+		fn(crypto_cipher_tfm(tfm), src, src);
+		if ((nbytes -= bsize) < bsize)
+			break;
+		xor(src, src - bsize, bsize);
+		src -= bsize;
+	}
 
-		src += bsize;
-	} while ((nbytes -= bsize) >= bsize);
+	xor(src, first_iv, bsize);
 
 	return nbytes;
 }

-- 
VGER BF report: H 0.0174255
