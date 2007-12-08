From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [PATCH] [crypto] s390-aes: use correct encrypt/decrypt function in
	fallback
Date: Sat, 8 Dec 2007 13:42:30 +0100
Message-ID: <20071208124230.GC1911@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org, Jan Glauber <jang@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:51790 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702AbXLHMmb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 8 Dec 2007 07:42:31 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_blkcipher_decrypt is wrong because it does not care about
the IV.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 arch/s390/crypto/aes_s390.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 8524611..46c9705 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -234,13 +234,10 @@ static int fallback_blk_dec(struct blkcipher_desc *desc,
 	struct crypto_blkcipher *tfm;
 	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
 
-	memcpy(crypto_blkcipher_crt(sctx->fallback.blk)->iv, desc->info,
-		AES_BLOCK_SIZE);
-
 	tfm = desc->tfm;
 	desc->tfm = sctx->fallback.blk;
 
-	ret = crypto_blkcipher_decrypt(desc, dst, src, nbytes);
+	ret = crypto_blkcipher_decrypt_iv(desc, dst, src, nbytes);
 
 	desc->tfm = tfm;
 	return ret;
@@ -254,13 +251,10 @@ static int fallback_blk_enc(struct blkcipher_desc *desc,
 	struct crypto_blkcipher *tfm;
 	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
 
-	memcpy(crypto_blkcipher_crt(sctx->fallback.blk)->iv, desc->info,
-		AES_BLOCK_SIZE);
-
 	tfm = desc->tfm;
 	desc->tfm = sctx->fallback.blk;
 
-	ret = crypto_blkcipher_encrypt(desc, dst, src, nbytes);
+	ret = crypto_blkcipher_encrypt_iv(desc, dst, src, nbytes);
 
 	desc->tfm = tfm;
 	return ret;
-- 
1.5.3.4
