From: Kevin Coffman <kwc@citi.umich.edu>
Subject: [PATCH] crypto: cts wrapper mode errata
Date: Mon, 31 Mar 2008 14:39:13 -0400
Message-ID: <20080331183913.3095.59520.stgit@jazz.citi.umich.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, kwc@citi.umich.edu
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from citi.umich.edu ([141.211.133.111]:18804 "EHLO citi.umich.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678AbYCaSjO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 31 Mar 2008 14:39:14 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes a couple of minor issues found by J. Bruce Fields
while reviewing with the CTS mode patch already applied.

It also changes the license to "Dual BSD/GPL".

Signed-off-by: Kevin Coffman <kwc@citi.umich.edu>
---

 crypto/cts.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/cts.c b/crypto/cts.c
index 6fe968a..c4e70bf 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -201,7 +201,7 @@ static int cts_cbc_decrypt(struct crypto_cts_ctx *ctx,
 	sg_set_buf(&sgdst[0], d, bsize);
 	err = crypto_blkcipher_decrypt_iv(&lcldesc, sgdst, sgsrc, bsize);
 
-	/* XXX xor with previous block ?? */
+	/* XOR with previous block */
 	crypto_xor(d, desc->info, bsize);
 
 	scatterwalk_map_and_copy(d, dst, offset, nbytes, 1);
@@ -343,5 +343,5 @@ static void __exit crypto_cts_module_exit(void)
 module_init(crypto_cts_module_init);
 module_exit(crypto_cts_module_exit);
 
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("CTS-CBC) CipherText Stealing for CBC");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_DESCRIPTION("CTS-CBC CipherText Stealing for CBC");

