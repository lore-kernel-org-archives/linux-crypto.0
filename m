From: Huang Ying <ying.huang@intel.com>
Subject: [BUGFIX 2/3] crypto: Remove CRYPTO_TFM_REQ_MAY_SLEEP flag in
 AES-NI accelerated ecb/cbc mode
Date: Mon, 15 Jun 2009 17:04:57 +0800
Message-ID: <1245056697.5320.350.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37942 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZFOJE5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2009 05:04:57 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Because AES-NI instructions will touch XMM state, corresponding code
must be enclosed within kernel_fpu_begin/end, which used
preempt_disable/enable. So sleep should be prevented between
kernel_fpu_begin/end.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/crypto/aesni-intel_glue.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -198,6 +198,7 @@ static int ecb_encrypt(struct blkcipher_
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {
@@ -221,6 +222,7 @@ static int ecb_decrypt(struct blkcipher_
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {
@@ -266,6 +268,7 @@ static int cbc_encrypt(struct blkcipher_
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {
@@ -289,6 +292,7 @@ static int cbc_decrypt(struct blkcipher_
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
+	desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {


