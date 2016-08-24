From: Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [PATCH] crypto: vmx -  fix null dereference in p8_aes_xts_crypt
Date: Wed, 24 Aug 2016 15:34:40 +0800
Message-ID: <1472024080.3313.20.camel@TP420>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: leosilva@linux.vnet.ibm.com, pfsmorigo@linux.vnet.ibm.com,
        herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3783 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750954AbcHXJCx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2016 05:02:53 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7O8n0XO119134
        for <linux-crypto@vger.kernel.org>; Wed, 24 Aug 2016 04:54:32 -0400
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 250wun6sf3-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 24 Aug 2016 04:54:31 -0400
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <zhong@linux.vnet.ibm.com>;
        Wed, 24 Aug 2016 09:54:30 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5DCF32190061
        for <linux-crypto@vger.kernel.org>; Wed, 24 Aug 2016 09:53:50 +0100 (BST)
Received: from d06av07.portsmouth.uk.ibm.com (d06av07.portsmouth.uk.ibm.com [9.149.37.248])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u7O8sQPf19136802
        for <linux-crypto@vger.kernel.org>; Wed, 24 Aug 2016 08:54:26 GMT
Received: from d06av07.portsmouth.uk.ibm.com (localhost [127.0.0.1])
        by d06av07.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u7O8sQWL029985
        for <linux-crypto@vger.kernel.org>; Wed, 24 Aug 2016 04:54:26 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

walk.iv is not assigned a value in blkcipher_walk_init. It makes iv uninitialized.
It is possibly a null value(as shown below), which is then used by aes_p8_encrypt. 

This patch moves iv = walk.iv after blkcipher_walk_virt, in which walk.iv is set.
 
[17856.268050] Unable to handle kernel paging request for data at address 0x00000000
[17856.268212] Faulting instruction address: 0xd000000002ff04bc
7:mon> t
[link register   ] d000000002ff47b8 p8_aes_xts_crypt+0x168/0x2a0 [vmx_crypto]   (938)
[c000000013b77960] d000000002ff4794 p8_aes_xts_crypt+0x144/0x2a0 [vmx_crypto] (unreliable)
[c000000013b77a70] c000000000544d64 skcipher_decrypt_blkcipher+0x64/0x80
[c000000013b77ac0] d000000003c0175c crypt_convert+0x53c/0x620 [dm_crypt]
[c000000013b77ba0] d000000003c043fc kcryptd_crypt+0x3cc/0x440 [dm_crypt]
[c000000013b77c50] c0000000000f3070 process_one_work+0x1e0/0x590
[c000000013b77ce0] c0000000000f34c8 worker_thread+0xa8/0x660
[c000000013b77d80] c0000000000fc0b0 kthread+0x110/0x130
[c000000013b77e30] c0000000000098f0 ret_from_kernel_thread+0x5c/0x6c

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 drivers/crypto/vmx/aes_xts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/vmx/aes_xts.c b/drivers/crypto/vmx/aes_xts.c
index cfb2541..24353ec3 100644
--- a/drivers/crypto/vmx/aes_xts.c
+++ b/drivers/crypto/vmx/aes_xts.c
@@ -129,8 +129,8 @@ static int p8_aes_xts_crypt(struct blkcipher_desc *desc,
 
 		blkcipher_walk_init(&walk, dst, src, nbytes);
 
-		iv = (u8 *)walk.iv;
 		ret = blkcipher_walk_virt(desc, &walk);
+		iv = walk.iv;
 		memset(tweak, 0, AES_BLOCK_SIZE);
 		aes_p8_encrypt(iv, tweak, &ctx->tweak_key);
 
