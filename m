From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v2] powerpc/crypto/crct10dif-vpmsum: Fix missing preempt_disable()
Date: Thu, 20 Apr 2017 15:35:09 +1000
Message-ID: <1492666509-4568-1-git-send-email-mpe@ellerman.id.au>
Cc: linuxppc-dev@ozlabs.org, dja@axtens.net,
        linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:36307 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938009AbdDTFfW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 01:35:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In crct10dif_vpmsum() we call enable_kernel_altivec() without first
disabling preemption, which is not allowed.

It used to be sufficient just to call pagefault_disable(), because that
also disabled preemption. But the two were decoupled in commit 8222dbe21e79
("sched/preempt, mm/fault: Decouple preemption from the page fault
logic") in mid 2015.

The crct10dif-vpmsum code inherited this bug from the crc32c-vpmsum code
on which it was modelled.

So add the missing preempt_disable/enable(). We should also call
disable_kernel_fp(), although it does nothing by default, there is a
debug switch to make it active and all enables should be paired with
disables.

Fixes: b01df1c16c9a ("crypto: powerpc - Add CRC-T10DIF acceleration")
Acked-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/crypto/crct10dif-vpmsum_glue.c | 3 +++
 1 file changed, 3 insertions(+)

v2: No change to the patch. Add dja's ack. Add linux-crypto to Cc.

diff --git a/arch/powerpc/crypto/crct10dif-vpmsum_glue.c b/arch/powerpc/crypto/crct10dif-vpmsum_glue.c
index bebfc329f746..02ea277863d1 100644
--- a/arch/powerpc/crypto/crct10dif-vpmsum_glue.c
+++ b/arch/powerpc/crypto/crct10dif-vpmsum_glue.c
@@ -44,10 +44,13 @@ static u16 crct10dif_vpmsum(u16 crci, unsigned char const *p, size_t len)
 
 	if (len & ~VMX_ALIGN_MASK) {
 		crc <<= 16;
+		preempt_disable();
 		pagefault_disable();
 		enable_kernel_altivec();
 		crc = __crct10dif_vpmsum(crc, p, len & ~VMX_ALIGN_MASK);
+		disable_kernel_altivec();
 		pagefault_enable();
+		preempt_enable();
 		crc >>= 16;
 	}
 
-- 
2.7.4
