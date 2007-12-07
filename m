From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [PATCH] [crypto] s390 AES: Copy the IV back for chaining support
Date: Fri, 7 Dec 2007 19:25:46 +0100
Message-ID: <20071207182546.GC24292@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Jan Glauber <jang@linux.vnet.ibm.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53640 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753619AbXLGSZw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2007 13:25:52 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is required for one or two crypto users in tree which
chain the IV.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 arch/s390/crypto/aes_s390.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 8524611..a2eae49 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -242,6 +242,9 @@ static int fallback_blk_dec(struct blkcipher_desc *desc,
 
 	ret = crypto_blkcipher_decrypt(desc, dst, src, nbytes);
 
+	memcpy(desc->info, crypto_blkcipher_crt(sctx->fallback.blk)->iv,
+		AES_BLOCK_SIZE);
+
 	desc->tfm = tfm;
 	return ret;
 }
@@ -262,6 +265,9 @@ static int fallback_blk_enc(struct blkcipher_desc *desc,
 
 	ret = crypto_blkcipher_encrypt(desc, dst, src, nbytes);
 
+	memcpy(desc->info, crypto_blkcipher_crt(sctx->fallback.blk)->iv,
+		AES_BLOCK_SIZE);
+
 	desc->tfm = tfm;
 	return ret;
 }
-- 
1.5.3.4
