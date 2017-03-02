From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v2 17/32] x86: kvmclock: Clear encryption attribute when
 SEV is active
Date: Thu, 2 Mar 2017 10:15:48 -0500
Message-ID: <148846774841.2349.10333552865190947646.stgit__43670.4953936443$1488488767$gmane$org@brijesh-build-machine>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: <simon.guinot@sequanux.org>, <linux-efi@vger.kernel.org>,
        <brijesh.singh@amd.com>, <kvm@vger.kernel.org>,
        <rkrcmar@redhat.com>, <matt@codeblueprint.co.uk>,
        <linux-pci@vger.kernel.org>, <linus.walleij@linaro.org>,
        <gary.hook@amd.com>, <linux-mm@kvack.org>,
        <paul.gortmaker@windriver.com>, <hpa@zytor.com>, <cl@linux.com>,
        <dan.j.williams@intel.com>, <aarcange@redhat.com>,
        <sfr@canb.auug.org.au>, <andriy.shevchenko@linux.intel.com>,
        <herbert@gondor.apana.org.au>, <bhe@redhat.com>,
        <xemul@parallels.com>, <joro@8bytes.org>, <x86@kernel.org>,
        <peterz@infradead.org>, <piotr.luc@intel.com>, <mingo@redhat.com>,
        <msalter@redhat.com>, <ross.zwisler@linux.intel.com>, <bp@suse.de>,
        <dyoung@redhat.com>, <thomas.lendacky@amd.com>, <jroedel@suse.de>,
        <keescook@chromium.org>, <arnd@arndb.de>, <toshi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam03on0079.outbound.protection.outlook.com ([104.47.42.79]:19147
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750743AbdCBVF7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Mar 2017 16:05:59 -0500
In-Reply-To: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The guest physical memory area holding the struct pvclock_wall_clock and
struct pvclock_vcpu_time_info are shared with the hypervisor. Hypervisor
periodically updates the contents of the memory. When SEV is active we must
clear the encryption attributes of the shared memory pages so that both
hypervisor and guest can access the data.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kernel/kvmclock.c |   65 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 56 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 278de4f..3b38b3d 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
 
+#include <asm/mem_encrypt.h>
 #include <asm/x86_init.h>
 #include <asm/reboot.h>
 
@@ -44,7 +45,7 @@ early_param("no-kvmclock", parse_no_kvmclock);
 
 /* The hypervisor will put information about time periodically here */
 static struct pvclock_vsyscall_time_info *hv_clock;
-static struct pvclock_wall_clock wall_clock;
+static struct pvclock_wall_clock *wall_clock;
 
 struct pvclock_vsyscall_time_info *pvclock_pvti_cpu0_va(void)
 {
@@ -62,15 +63,18 @@ static void kvm_get_wallclock(struct timespec *now)
 	int low, high;
 	int cpu;
 
-	low = (int)__pa_symbol(&wall_clock);
-	high = ((u64)__pa_symbol(&wall_clock) >> 32);
+	if (!wall_clock)
+		return;
+
+	low = (int)slow_virt_to_phys(wall_clock);
+	high = ((u64)slow_virt_to_phys(wall_clock) >> 32);
 
 	native_write_msr(msr_kvm_wall_clock, low, high);
 
 	cpu = get_cpu();
 
 	vcpu_time = &hv_clock[cpu].pvti;
-	pvclock_read_wallclock(&wall_clock, vcpu_time, now);
+	pvclock_read_wallclock(wall_clock, vcpu_time, now);
 
 	put_cpu();
 }
@@ -246,11 +250,40 @@ static void kvm_shutdown(void)
 	native_machine_shutdown();
 }
 
+static phys_addr_t kvm_memblock_alloc(phys_addr_t size, phys_addr_t align)
+{
+	phys_addr_t mem;
+
+	mem = memblock_alloc(size, align);
+	if (!mem)
+		return 0;
+
+	/* When SEV is active clear the encryption attributes of the pages */
+	if (sev_active()) {
+		if (early_set_memory_decrypted(__va(mem), size))
+			goto e_free;
+	}
+
+	return mem;
+e_free:
+	memblock_free(mem, size);
+	return 0;
+}
+
+static void kvm_memblock_free(phys_addr_t addr, phys_addr_t size)
+{
+	/* When SEV is active restore the encryption attributes of the pages */
+	if (sev_active())
+		early_set_memory_encrypted(__va(addr), size);
+
+	memblock_free(addr, size);
+}
+
 void __init kvmclock_init(void)
 {
 	struct pvclock_vcpu_time_info *vcpu_time;
-	unsigned long mem;
-	int size, cpu;
+	unsigned long mem, mem_wall_clock;
+	int size, cpu, wall_clock_size;
 	u8 flags;
 
 	size = PAGE_ALIGN(sizeof(struct pvclock_vsyscall_time_info)*NR_CPUS);
@@ -267,15 +300,29 @@ void __init kvmclock_init(void)
 	printk(KERN_INFO "kvm-clock: Using msrs %x and %x",
 		msr_kvm_system_time, msr_kvm_wall_clock);
 
-	mem = memblock_alloc(size, PAGE_SIZE);
-	if (!mem)
+	wall_clock_size = PAGE_ALIGN(sizeof(struct pvclock_wall_clock));
+	mem_wall_clock = kvm_memblock_alloc(wall_clock_size, PAGE_SIZE);
+	if (!mem_wall_clock)
 		return;
+
+	wall_clock = __va(mem_wall_clock);
+	memset(wall_clock, 0, wall_clock_size);
+
+	mem = kvm_memblock_alloc(size, PAGE_SIZE);
+	if (!mem) {
+		kvm_memblock_free(mem_wall_clock, wall_clock_size);
+		wall_clock = NULL;
+		return;
+	}
+
 	hv_clock = __va(mem);
 	memset(hv_clock, 0, size);
 
 	if (kvm_register_clock("primary cpu clock")) {
 		hv_clock = NULL;
-		memblock_free(mem, size);
+		kvm_memblock_free(mem, size);
+		kvm_memblock_free(mem_wall_clock, wall_clock_size);
+		wall_clock = NULL;
 		return;
 	}
 
