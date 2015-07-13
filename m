From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Subject: [PATCH 1/2] Uncomment and make enable_kernel_vsx() routine available
Date: Mon, 13 Jul 2015 13:51:01 -0300
Message-ID: <20150713165057.GA6594@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linuxppc-dev@lists.ozlabs.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	pfsmorigo@linux.vnet.ibm.com, Michael Ellerman <mpe@ellerman.id.au>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:37355 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbbGMQvH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jul 2015 12:51:07 -0400
Received: from /spool/local
	by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <leosilva@linux.vnet.ibm.com>;
	Mon, 13 Jul 2015 13:51:06 -0300
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

enable_kernel_vsx() function was commented since anything was using
it. However, vmx-crypto driver uses VSX instructions which are
only available if VSX is enable. Otherwise it rises an exception oops.

This patch uncomment enable_kernel_vsx() routine and makes it available.

Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/switch_to.h | 1 +
 arch/powerpc/kernel/process.c        | 3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/switch_to.h b/arch/powerpc/include/asm/switch_to.h
index 58abeda..15cca17 100644
--- a/arch/powerpc/include/asm/switch_to.h
+++ b/arch/powerpc/include/asm/switch_to.h
@@ -29,6 +29,7 @@ static inline void save_early_sprs(struct thread_struct *prev) {}
 
 extern void enable_kernel_fp(void);
 extern void enable_kernel_altivec(void);
+extern void enable_kernel_vsx(void);
 extern int emulate_altivec(struct pt_regs *);
 extern void __giveup_vsx(struct task_struct *);
 extern void giveup_vsx(struct task_struct *);
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 8005e18..64e6e9d 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -204,8 +204,6 @@ EXPORT_SYMBOL_GPL(flush_altivec_to_thread);
 #endif /* CONFIG_ALTIVEC */
 
 #ifdef CONFIG_VSX
-#if 0
-/* not currently used, but some crazy RAID module might want to later */
 void enable_kernel_vsx(void)
 {
 	WARN_ON(preemptible());
@@ -220,7 +218,6 @@ void enable_kernel_vsx(void)
 #endif /* CONFIG_SMP */
 }
 EXPORT_SYMBOL(enable_kernel_vsx);
-#endif
 
 void giveup_vsx(struct task_struct *tsk)
 {
-- 
2.1.0
