From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [PATCH] [crypto] Geode: use correct encrypt/decrypt function in
	fallback
Date: Sat, 8 Dec 2007 13:41:22 +0100
Message-ID: <20071208124122.GB1911@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36687 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753765AbXLHMlY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 8 Dec 2007 07:41:24 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_blkcipher_decrypt is wrong because it does not care about
the IV.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 drivers/crypto/geode-aes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 68be7d0..581b003 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -190,7 +190,7 @@ static int fallback_blk_dec(struct blkcipher_desc *desc,
 	tfm = desc->tfm;
 	desc->tfm = op->fallback.blk;
 
-	ret = crypto_blkcipher_decrypt(desc, dst, src, nbytes);
+	ret = crypto_blkcipher_decrypt_iv(desc, dst, src, nbytes);
 
 	desc->tfm = tfm;
 	return ret;
@@ -206,7 +206,7 @@ static int fallback_blk_enc(struct blkcipher_desc *desc,
 	tfm = desc->tfm;
 	desc->tfm = op->fallback.blk;
 
-	ret = crypto_blkcipher_encrypt(desc, dst, src, nbytes);
+	ret = crypto_blkcipher_encrypt_iv(desc, dst, src, nbytes);
 
 	desc->tfm = tfm;
 	return ret;
-- 
1.5.3.4
