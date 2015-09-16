From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH stable 1/2] powerpc: Uncomment and make enable_kernel_vsx() routine available
Date: Wed, 16 Sep 2015 11:40:36 +1000
Message-ID: <1442367639-11527-1-git-send-email-mpe@ellerman.id.au>
Cc: <linuxppc-dev@ozlabs.org>, linux-crypto@vger.kernel.org,
	Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>

commit 72cd7b44bc99376b3f3c93cedcd052663fcdf705 upstream.

enable_kernel_vsx() function was commented since anything was using
it. However, vmx-crypto driver uses VSX instructions which are
only available if VSX is enable. Otherwise it rises an exception oops.

This patch uncomment enable_kernel_vsx() routine and makes it available.

Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: stable@vger.kernel.org # 4.1
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/include/asm/switch_to.h | 1 +
 arch/powerpc/kernel/process.c        | 3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/switch_to.h b/arch/powerpc/include/asm/switch_to.h
index 58abeda64cb7..15cca17cba4b 100644
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
index febb50dd5328..0596373cd1c3 100644
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
2.1.4
