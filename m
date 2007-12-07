From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [PATCH] [crypto] Geode: Copy the IV back for chaining support
Date: Fri, 7 Dec 2007 19:24:47 +0100
Message-ID: <20071207182447.GB24292@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53636 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756887AbXLGSYs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2007 13:24:48 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is required for one or two crypto users in tree which
chain the IV.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 drivers/crypto/geode-aes.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index c7d5ed0..ff3d770 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -195,6 +195,9 @@ static int fallback_blk_dec(struct blkcipher_desc *desc,
 
 	ret = crypto_blkcipher_decrypt(desc, dst, src, nbytes);
 
+	memcpy(desc->info, crypto_blkcipher_crt(op->fallback.blk)->iv,
+			AES_BLOCK_SIZE);
+
 	desc->tfm = tfm;
 	return ret;
 }
@@ -214,6 +217,9 @@ static int fallback_blk_enc(struct blkcipher_desc *desc,
 
 	ret = crypto_blkcipher_encrypt(desc, dst, src, nbytes);
 
+	memcpy(desc->info, crypto_blkcipher_crt(op->fallback.blk)->iv,
+			AES_BLOCK_SIZE);
+
 	desc->tfm = tfm;
 	return ret;
 }
-- 
1.5.3.4
