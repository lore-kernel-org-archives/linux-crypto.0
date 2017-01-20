From: Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [PATCH] crypto: vmx -- disable preemption to enable vsx in aes_ctr.c
Date: Fri, 20 Jan 2017 16:35:33 +0800
Message-ID: <1484901333.8207.11.camel@TP420>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: leosilva@linux.vnet.ibm.com, pfsmorigo@linux.vnet.ibm.com,
        herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51143 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751403AbdATIfm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2017 03:35:42 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0K8Z772104606
        for <linux-crypto@vger.kernel.org>; Fri, 20 Jan 2017 03:35:41 -0500
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0b-001b2d01.pphosted.com with ESMTP id 283c3sxp13-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Fri, 20 Jan 2017 03:35:41 -0500
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <zhong@linux.vnet.ibm.com>;
        Fri, 20 Jan 2017 08:35:39 -0000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Some preemptible check warnings were reported from enable_kernel_vsx(). This
patch disables preemption in aes_ctr.c before enabling vsx, and they are now 
consistent with other files in the same directory.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 drivers/crypto/vmx/aes_ctr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/vmx/aes_ctr.c b/drivers/crypto/vmx/aes_ctr.c
index 38ed10d..7cf6d31 100644
--- a/drivers/crypto/vmx/aes_ctr.c
+++ b/drivers/crypto/vmx/aes_ctr.c
@@ -80,11 +80,13 @@ static int p8_aes_ctr_setkey(struct crypto_tfm *tfm, const u8 *key,
 	int ret;
 	struct p8_aes_ctr_ctx *ctx = crypto_tfm_ctx(tfm);
 
+	preempt_disable();
 	pagefault_disable();
 	enable_kernel_vsx();
 	ret = aes_p8_set_encrypt_key(key, keylen * 8, &ctx->enc_key);
 	disable_kernel_vsx();
 	pagefault_enable();
+	preempt_enable();
 
 	ret += crypto_blkcipher_setkey(ctx->fallback, key, keylen);
 	return ret;
@@ -99,11 +101,13 @@ static void p8_aes_ctr_final(struct p8_aes_ctr_ctx *ctx,
 	u8 *dst = walk->dst.virt.addr;
 	unsigned int nbytes = walk->nbytes;
 
+	preempt_disable();
 	pagefault_disable();
 	enable_kernel_vsx();
 	aes_p8_encrypt(ctrblk, keystream, &ctx->enc_key);
 	disable_kernel_vsx();
 	pagefault_enable();
+	preempt_enable();
 
 	crypto_xor(keystream, src, nbytes);
 	memcpy(dst, keystream, nbytes);
@@ -132,6 +136,7 @@ static int p8_aes_ctr_crypt(struct blkcipher_desc *desc,
 		blkcipher_walk_init(&walk, dst, src, nbytes);
 		ret = blkcipher_walk_virt_block(desc, &walk, AES_BLOCK_SIZE);
 		while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
+			preempt_disable();
 			pagefault_disable();
 			enable_kernel_vsx();
 			aes_p8_ctr32_encrypt_blocks(walk.src.virt.addr,
@@ -143,6 +148,7 @@ static int p8_aes_ctr_crypt(struct blkcipher_desc *desc,
 						    walk.iv);
 			disable_kernel_vsx();
 			pagefault_enable();
+			preempt_enable();
 
 			/* We need to update IV mostly for last bytes/round */
 			inc = (nbytes & AES_BLOCK_MASK) / AES_BLOCK_SIZE;
