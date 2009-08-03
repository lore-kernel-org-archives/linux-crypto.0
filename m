From: Huang Ying <ying.huang@intel.com>
Subject: [BUGFIX] crypto: Fix ctr(aes) testing by specifying geniv
Date: Mon,  3 Aug 2009 15:44:43 +0800
Message-ID: <1249285483-22286-1-git-send-email-ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:15319 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbZHCHoq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2009 03:44:46 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When doing "modeprobe tcrypt mode=10", the following error will show
in dmesg.

alg: skcipher: Failed to load transform for ctr(aes): -22
alg: skcipher: Failed to load transform for ctr(aes): -22
tcrypt: one or more tests failed!

Because ctr(aes) testing code will allocate ctr(aes) with geniv, but
defualt geniv mode may not work with ctr(aes). As that of rfc3686,
this is fixed via specifying geniv mode to "seqiv".

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 crypto/ctr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -219,6 +219,8 @@ static struct crypto_instance *crypto_ct
 	inst->alg.cra_blkcipher.encrypt = crypto_ctr_crypt;
 	inst->alg.cra_blkcipher.decrypt = crypto_ctr_crypt;
 
+	inst->alg.cra_blkcipher.geniv = "seqiv";
+
 out:
 	crypto_mod_put(alg);
 	return inst;
