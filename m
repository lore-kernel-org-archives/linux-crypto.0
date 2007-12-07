From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [PATCH] [crypto] Geode: Copy the IV back in case of an fallback.
Date: Fri, 7 Dec 2007 19:24:05 +0100
Message-ID: <20071207182405.GA24292@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53634 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752109AbXLGSYJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2007 13:24:09 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jan pointed this out to me and fixed it in the fallback code for s390
and now I remembered that this could also be fixed here :)

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 drivers/crypto/geode-aes.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 68be7d0..c7d5ed0 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -187,6 +187,9 @@ static int fallback_blk_dec(struct blkcipher_desc *desc,
 	struct crypto_blkcipher *tfm;
 	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
 
+	memcpy(crypto_blkcipher_crt(op->fallback.blk)->iv, desc->info,
+			AES_BLOCK_SIZE);
+
 	tfm = desc->tfm;
 	desc->tfm = op->fallback.blk;
 
@@ -203,6 +206,9 @@ static int fallback_blk_enc(struct blkcipher_desc *desc,
 	struct crypto_blkcipher *tfm;
 	struct geode_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
 
+	memcpy(crypto_blkcipher_crt(op->fallback.blk)->iv, desc->info,
+			AES_BLOCK_SIZE);
+
 	tfm = desc->tfm;
 	desc->tfm = op->fallback.blk;
 
-- 
1.5.3.4
