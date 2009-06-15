From: Huang Ying <ying.huang@intel.com>
Subject: [BUGFIX 3/3] crypto: Remove CRYPTO_TFM_REQ_MAY_SLEEP from fpu
 template
Date: Mon, 15 Jun 2009 17:05:04 +0800
Message-ID: <1245056704.5320.351.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51940 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759522AbZFOJFD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2009 05:05:03 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

kernel_fpu_begin/end used preempt_disable/enable, so sleep should be
prevented between kernel_fpu_begin/end.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/crypto/fpu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/crypto/fpu.c
+++ b/arch/x86/crypto/fpu.c
@@ -48,7 +48,7 @@ static int crypto_fpu_encrypt(struct blk
 	struct blkcipher_desc desc = {
 		.tfm = child,
 		.info = desc_in->info,
-		.flags = desc_in->flags,
+		.flags = desc_in->flags & ~CRYPTO_TFM_REQ_MAY_SLEEP,
 	};
 
 	kernel_fpu_begin();
@@ -67,7 +67,7 @@ static int crypto_fpu_decrypt(struct blk
 	struct blkcipher_desc desc = {
 		.tfm = child,
 		.info = desc_in->info,
-		.flags = desc_in->flags,
+		.flags = desc_in->flags & ~CRYPTO_TFM_REQ_MAY_SLEEP,
 	};
 
 	kernel_fpu_begin();


