Received: from luna.linkmauve.fr (82-65-109-163.subs.proxad.net [82.65.109.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462243A1685;
	Tue, 21 Apr 2026 12:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.65.109.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776773697; cv=none; b=mjc3lWutSGAXuaRejXd7cqB+CUnt0U2J1zkwQSSLnpTj4xAYdCqFfoZnLw76M4tJ0e9MJQtGTNFmqWuTjcYLY+tiTSyF0a57DfIbtxsEN0N+hr7VoQsC6dY1EEpUrFs3bSgETitZ8lrlg5RBd37fcteu9+xlCyTkmnjGQaUHQIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776773697; c=relaxed/simple;
	bh=LvdZpXfPSjV9Pyb9fwPS5MzrciIPVzqw4RMsvfB3iIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=APrBqwZV/VMmoEbWKk5A/mMSjqlJ3vrrMlMlh0CdX34jgW5ARO3Pet1Ei7MIyJuGz0acALPkh00d1Wx96LKwnFx/oj94OYAJxCkKHIbNtL2v6IkZZGgGIWLgoSEh/jKA/GjLki23dodjoml3Ib8Z8A3lMQ0l1L/gQSMBbkmjUxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linkmauve.fr; spf=pass smtp.mailfrom=linkmauve.fr; arc=none smtp.client-ip=82.65.109.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linkmauve.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linkmauve.fr
Received: by luna.linkmauve.fr (Postfix, from userid 1000)
	id 192A2F40863; Tue, 21 Apr 2026 14:14:46 +0200 (CEST)
From: Link Mauve <linkmauve@linkmauve.fr>
To: linuxppc-dev@lists.ozlabs.org
Cc: Link Mauve <linkmauve@linkmauve.fr>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Geoff Levand <geoff@infradead.org>,
	Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
	"Oliver O'Halloran" <oohall@gmail.com>,
	Anatolij Gustschin <agust@denx.de>,
	=?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
	Nayna Jain <nayna@linux.ibm.com>,
	Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Thomas Huth <thuth@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	David Hildenbrand <david@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Will Deacon <will@kernel.org>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	Nam Cao <namcao@linutronix.de>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Jiri Bohac <jbohac@suse.cz>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Kees Cook <kees@kernel.org>,
	Stephen Rothwell <sfr@cab.auug.org.au>,
	Xichao Zhao <zhao.xichao@vivo.com>,
	Gautam Menghani <gautam@linux.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Li Chen <chenl311@chinatelecom.cn>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Petr Mladek <pmladek@suse.com>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	"Nysal Jan K.A." <nysal@linux.ibm.com>,
	Aditya Gupta <adityag@linux.ibm.com>,
	Sayali Patil <sayalip@linux.ibm.com>,
	Rohan McLure <rmclure@linux.ibm.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Donnellan <andrew+kernel@donnellan.id.au>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Chen Ni <nichen@iscas.ac.cn>,
	Haren Myneni <haren@linux.ibm.com>,
	Jonathan Greental <yonatan02greental@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Gaurav Batra <gbatra@linux.ibm.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	=?UTF-8?q?Adrian=20Barna=C5=9B?= <abarnas@google.com>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Thierry Reding <treding@nvidia.com>,
	Yury Norov <ynorov@nvidia.com>,
	"Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>,
	Ruben Wauters <rubenru09@aol.com>,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	x86@kernel.org
Subject: [PATCH 2/2] powerpc: Run typos -w
Date: Tue, 21 Apr 2026 14:14:14 +0200
Message-ID: <20260421121420.26079-3-linkmauve@linkmauve.fr>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260421121420.26079-1-linkmauve@linkmauve.fr>
References: <20260421121420.26079-1-linkmauve@linkmauve.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Alongside the previous commit, this fixes all known typos from that
tool, avoiding the known good words.

I have manually reviewed every single of these changes, and tested that
the kernel still builds and boots on the Wii, but this obviously doesn’t
exercises all paths.

I’ve used typos 1.45.1, released on 2026-04-13, I expect future versions
to catch more typos but we can run them periodically.

Signed-off-by: Link Mauve <linkmauve@linkmauve.fr>
---
 arch/powerpc/boot/crt0.S                      |  2 +-
 arch/powerpc/boot/dts/fsl/ppa8548.dts         |  2 +-
 arch/powerpc/boot/dts/kuroboxHD.dts           |  2 +-
 arch/powerpc/boot/dts/kuroboxHG.dts           |  2 +-
 arch/powerpc/boot/dts/mgcoge.dts              |  2 +-
 arch/powerpc/boot/dts/mpc8308_p1m.dts         |  4 +-
 arch/powerpc/boot/rs6000.h                    |  4 +-
 arch/powerpc/crypto/aes-gcm-p10.S             |  6 +--
 arch/powerpc/crypto/aes-spe-glue.c            |  2 +-
 arch/powerpc/crypto/aesp10-ppc.pl             |  2 +-
 arch/powerpc/crypto/ghashp10-ppc.pl           |  2 +-
 arch/powerpc/include/asm/book3s/64/hash-64k.h |  6 +--
 arch/powerpc/include/asm/book3s/64/mmu-hash.h | 12 +++---
 arch/powerpc/include/asm/book3s/64/radix.h    |  2 +-
 arch/powerpc/include/asm/cpm1.h               |  2 +-
 arch/powerpc/include/asm/cpm2.h               |  2 +-
 arch/powerpc/include/asm/cputable.h           |  2 +-
 arch/powerpc/include/asm/delay.h              |  2 +-
 arch/powerpc/include/asm/epapr_hcalls.h       |  2 +-
 arch/powerpc/include/asm/fsl_hcalls.h         |  4 +-
 arch/powerpc/include/asm/head-64.h            |  4 +-
 arch/powerpc/include/asm/heathrow.h           |  2 +-
 arch/powerpc/include/asm/highmem.h            |  2 +-
 arch/powerpc/include/asm/io.h                 |  4 +-
 arch/powerpc/include/asm/kvm_booke.h          |  2 +-
 arch/powerpc/include/asm/machdep.h            |  2 +-
 arch/powerpc/include/asm/mediabay.h           |  2 +-
 arch/powerpc/include/asm/mpic.h               |  2 +-
 arch/powerpc/include/asm/mpic_msgr.h          |  2 +-
 arch/powerpc/include/asm/nohash/32/mmu-8xx.h  |  2 +-
 arch/powerpc/include/asm/nohash/32/pte-8xx.h  |  2 +-
 arch/powerpc/include/asm/nohash/mmu-e500.h    |  2 +-
 arch/powerpc/include/asm/page_64.h            |  2 +-
 arch/powerpc/include/asm/paravirt.h           |  2 +-
 arch/powerpc/include/asm/pci-bridge.h         |  4 +-
 arch/powerpc/include/asm/pmac_feature.h       |  4 +-
 arch/powerpc/include/asm/ppc_asm.h            |  2 +-
 arch/powerpc/include/asm/prom.h               |  4 +-
 arch/powerpc/include/asm/ps3.h                |  2 +-
 arch/powerpc/include/asm/ps3av.h              |  2 +-
 arch/powerpc/include/asm/reg.h                |  2 +-
 arch/powerpc/include/asm/reg_booke.h          |  2 +-
 arch/powerpc/include/asm/reg_fsl_emb.h        |  2 +-
 arch/powerpc/include/asm/sfp-machine.h        |  4 +-
 arch/powerpc/include/asm/smu.h                | 12 +++---
 arch/powerpc/include/asm/tce.h                |  2 +-
 arch/powerpc/include/asm/thread_info.h        |  2 +-
 arch/powerpc/include/asm/tsi108_irq.h         |  2 +-
 arch/powerpc/include/asm/uninorth.h           |  4 +-
 arch/powerpc/include/uapi/asm/bootx.h         |  2 +-
 arch/powerpc/include/uapi/asm/sigcontext.h    |  2 +-
 arch/powerpc/kernel/85xx_entry_mapping.S      |  2 +-
 arch/powerpc/kernel/cputable.c                |  2 +-
 arch/powerpc/kernel/eeh.c                     |  4 +-
 arch/powerpc/kernel/eeh_driver.c              |  8 ++--
 arch/powerpc/kernel/eeh_event.c               |  2 +-
 arch/powerpc/kernel/eeh_pe.c                  |  2 +-
 arch/powerpc/kernel/entry_32.S                |  2 +-
 arch/powerpc/kernel/exceptions-64e.S          |  4 +-
 arch/powerpc/kernel/exceptions-64s.S          |  6 +--
 arch/powerpc/kernel/fadump.c                  |  8 ++--
 arch/powerpc/kernel/head_44x.S                | 14 +++----
 arch/powerpc/kernel/head_85xx.S               |  6 +--
 arch/powerpc/kernel/head_book3s_32.S          |  2 +-
 arch/powerpc/kernel/hw_breakpoint.c           |  2 +-
 arch/powerpc/kernel/idle_book3s.S             |  4 +-
 arch/powerpc/kernel/interrupt.c               |  2 +-
 arch/powerpc/kernel/irq_64.c                  |  2 +-
 arch/powerpc/kernel/legacy_serial.c           |  2 +-
 arch/powerpc/kernel/nvram_64.c                |  2 +-
 arch/powerpc/kernel/paca.c                    |  2 +-
 arch/powerpc/kernel/pci_dn.c                  |  2 +-
 arch/powerpc/kernel/prom.c                    |  4 +-
 arch/powerpc/kernel/prom_init_check.sh        |  2 +-
 arch/powerpc/kernel/ptrace/ptrace-adv.c       |  2 +-
 arch/powerpc/kernel/ptrace/ptrace-decl.h      |  2 +-
 arch/powerpc/kernel/ptrace/ptrace-tm.c        | 10 ++---
 arch/powerpc/kernel/setup_64.c                |  4 +-
 arch/powerpc/kernel/signal_32.c               |  2 +-
 arch/powerpc/kernel/signal_64.c               |  2 +-
 arch/powerpc/kernel/smp.c                     |  2 +-
 arch/powerpc/kernel/switch.S                  |  2 +-
 arch/powerpc/kernel/time.c                    |  2 +-
 arch/powerpc/kernel/traps.c                   |  4 +-
 arch/powerpc/kernel/watchdog.c                |  2 +-
 arch/powerpc/kexec/core_64.c                  |  2 +-
 arch/powerpc/kexec/file_load_64.c             |  4 +-
 arch/powerpc/kvm/book3s_hv.c                  |  6 +--
 arch/powerpc/kvm/book3s_hv_p9_entry.c         |  2 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c            |  4 +-
 arch/powerpc/kvm/book3s_pr.c                  |  2 +-
 arch/powerpc/kvm/book3s_xive.c                | 42 +++++++++----------
 arch/powerpc/kvm/book3s_xive.h                |  4 +-
 arch/powerpc/kvm/booke.h                      |  2 +-
 arch/powerpc/kvm/bookehv_interrupts.S         |  4 +-
 arch/powerpc/kvm/e500_mmu.c                   |  2 +-
 arch/powerpc/kvm/e500mc.c                     |  2 +-
 arch/powerpc/kvm/powerpc.c                    |  2 +-
 arch/powerpc/lib/copyuser_power7.S            |  4 +-
 arch/powerpc/lib/memcmp_64.S                  |  2 +-
 arch/powerpc/lib/memcpy_power7.S              |  4 +-
 arch/powerpc/lib/rheap.c                      |  4 +-
 arch/powerpc/mm/book3s64/hash_native.c        |  6 +--
 arch/powerpc/mm/book3s64/hash_pgtable.c       |  2 +-
 arch/powerpc/mm/book3s64/hash_tlb.c           |  2 +-
 arch/powerpc/mm/book3s64/hash_utils.c         |  8 ++--
 arch/powerpc/mm/book3s64/hugetlbpage.c        |  2 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c      |  2 +-
 arch/powerpc/mm/book3s64/radix_tlb.c          | 10 ++---
 arch/powerpc/mm/book3s64/slb.c                |  2 +-
 arch/powerpc/mm/ioremap.c                     |  2 +-
 arch/powerpc/mm/mem.c                         |  2 +-
 arch/powerpc/mm/nohash/kaslr_booke.c          |  2 +-
 arch/powerpc/mm/nohash/tlb.c                  |  2 +-
 arch/powerpc/mm/nohash/tlb_low_64e.S          |  4 +-
 arch/powerpc/perf/hv-24x7.c                   |  2 +-
 arch/powerpc/perf/hv-gpci-requests.h          |  2 +-
 arch/powerpc/perf/hv-gpci.c                   |  2 +-
 arch/powerpc/perf/imc-pmu.c                   |  4 +-
 arch/powerpc/perf/isa207-common.h             |  4 +-
 arch/powerpc/perf/vpa-dtl.c                   |  4 +-
 arch/powerpc/platforms/44x/uic.c              |  2 +-
 arch/powerpc/platforms/512x/clock-commonclk.c |  2 +-
 arch/powerpc/platforms/512x/mpc512x_shared.c  |  2 +-
 arch/powerpc/platforms/52xx/lite5200_pm.c     |  2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pci.c     |  4 +-
 arch/powerpc/platforms/8xx/pic.c              |  4 +-
 arch/powerpc/platforms/book3s/vas-api.c       |  4 +-
 arch/powerpc/platforms/cell/spufs/context.c   |  4 +-
 .../platforms/cell/spufs/spu_restore_crt0.S   |  2 +-
 arch/powerpc/platforms/cell/spufs/switch.c    |  8 ++--
 arch/powerpc/platforms/powermac/bootx_init.c  |  2 +-
 arch/powerpc/platforms/powermac/cache.S       |  2 +-
 arch/powerpc/platforms/powermac/feature.c     |  2 +-
 arch/powerpc/platforms/powermac/low_i2c.c     |  2 +-
 arch/powerpc/platforms/powermac/pci.c         |  2 +-
 arch/powerpc/platforms/powermac/pfunc_base.c  |  2 +-
 arch/powerpc/platforms/powermac/setup.c       |  2 +-
 arch/powerpc/platforms/powermac/sleep.S       |  2 +-
 arch/powerpc/platforms/powernv/eeh-powernv.c  |  2 +-
 arch/powerpc/platforms/powernv/opal-lpc.c     |  2 +-
 .../platforms/powernv/opal-memory-errors.c    |  2 +-
 arch/powerpc/platforms/powernv/opal.c         |  6 +--
 arch/powerpc/platforms/powernv/pci-ioda.c     |  2 +-
 arch/powerpc/platforms/powernv/pci-sriov.c    |  2 +-
 arch/powerpc/platforms/powernv/vas-fault.c    |  2 +-
 arch/powerpc/platforms/powernv/vas.h          |  4 +-
 arch/powerpc/platforms/ps3/interrupt.c        |  4 +-
 arch/powerpc/platforms/ps3/platform.h         |  4 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c  |  2 +-
 arch/powerpc/platforms/pseries/iommu.c        |  8 ++--
 arch/powerpc/platforms/pseries/lpar.c         |  4 +-
 arch/powerpc/platforms/pseries/msi.c          |  2 +-
 arch/powerpc/platforms/pseries/papr-indices.c |  2 +-
 arch/powerpc/platforms/pseries/papr_scm.c     |  2 +-
 .../platforms/pseries/rtas-work-area.c        |  2 +-
 arch/powerpc/platforms/pseries/suspend.c      |  2 +-
 arch/powerpc/platforms/pseries/vas-sysfs.c    |  2 +-
 arch/powerpc/platforms/pseries/vas.c          |  4 +-
 arch/powerpc/platforms/pseries/vas.h          |  2 +-
 arch/powerpc/sysdev/fsl_pci.c                 |  4 +-
 arch/powerpc/sysdev/indirect_pci.c            |  2 +-
 arch/powerpc/sysdev/xics/icp-native.c         |  2 +-
 arch/powerpc/sysdev/xics/xics-common.c        |  2 +-
 arch/powerpc/sysdev/xive/common.c             |  6 +--
 arch/powerpc/tools/unrel_branch_check.sh      |  2 +-
 arch/powerpc/xmon/ppc-opc.c                   |  6 +--
 arch/powerpc/xmon/ppc.h                       |  2 +-
 lib/crypto/powerpc/ghashp8-ppc.pl             |  2 +-
 169 files changed, 283 insertions(+), 283 deletions(-)

diff --git a/arch/powerpc/boot/crt0.S b/arch/powerpc/boot/crt0.S
index 121cab9d579b..2325020ce0df 100644
--- a/arch/powerpc/boot/crt0.S
+++ b/arch/powerpc/boot/crt0.S
@@ -184,7 +184,7 @@ p_base:	mflr	r10		/* r10 now points to runtime addr of p_base */
 	cmpdi	r14,0
 	beq	3f
 
-	/* Calcuate the runtime offset. */
+	/* Calculate the runtime offset. */
 	subf	r13,r13,r9
 
 	/* Run through the list of relocations and process the
diff --git a/arch/powerpc/boot/dts/fsl/ppa8548.dts b/arch/powerpc/boot/dts/fsl/ppa8548.dts
index f39838d93994..32558104b3a9 100644
--- a/arch/powerpc/boot/dts/fsl/ppa8548.dts
+++ b/arch/powerpc/boot/dts/fsl/ppa8548.dts
@@ -95,7 +95,7 @@ i2c@3100 {
 
 	/*
 	 * Only ethernet controller @25000 and @26000 are used.
-	 * Use alias enet2 and enet3 for the remainig controllers,
+	 * Use alias enet2 and enet3 for the remaining controllers,
 	 * to stay compatible with mpc8548si-pre.dtsi.
 	 */
 	enet2: ethernet@24000 {
diff --git a/arch/powerpc/boot/dts/kuroboxHD.dts b/arch/powerpc/boot/dts/kuroboxHD.dts
index 0a4545159e80..6d045d75ff19 100644
--- a/arch/powerpc/boot/dts/kuroboxHD.dts
+++ b/arch/powerpc/boot/dts/kuroboxHD.dts
@@ -1,5 +1,5 @@
 /*
- * Device Tree Souce for Buffalo KuroboxHD
+ * Device Tree Source for Buffalo KuroboxHD
  *
  * Choose CONFIG_LINKSTATION to build a kernel for KuroboxHD, or use
  * the default configuration linkstation_defconfig.
diff --git a/arch/powerpc/boot/dts/kuroboxHG.dts b/arch/powerpc/boot/dts/kuroboxHG.dts
index 0e758b347cdb..c868d6422ab2 100644
--- a/arch/powerpc/boot/dts/kuroboxHG.dts
+++ b/arch/powerpc/boot/dts/kuroboxHG.dts
@@ -1,5 +1,5 @@
 /*
- * Device Tree Souce for Buffalo KuroboxHG
+ * Device Tree Source for Buffalo KuroboxHG
  *
  * Choose CONFIG_LINKSTATION to build a kernel for KuroboxHG, or use
  * the default configuration linkstation_defconfig.
diff --git a/arch/powerpc/boot/dts/mgcoge.dts b/arch/powerpc/boot/dts/mgcoge.dts
index 9cefed207234..5f1cb0e98e5f 100644
--- a/arch/powerpc/boot/dts/mgcoge.dts
+++ b/arch/powerpc/boot/dts/mgcoge.dts
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Device Tree for the MGCOGE plattform from keymile
+ * Device Tree for the MGCOGE platform from keymile
  *
  * Copyright 2008 DENX Software Engineering GmbH
  * Heiko Schocher <hs@denx.de>
diff --git a/arch/powerpc/boot/dts/mpc8308_p1m.dts b/arch/powerpc/boot/dts/mpc8308_p1m.dts
index 41f917f97dab..48a98449ecbb 100644
--- a/arch/powerpc/boot/dts/mpc8308_p1m.dts
+++ b/arch/powerpc/boot/dts/mpc8308_p1m.dts
@@ -90,14 +90,14 @@ can@1,0 {
 			compatible = "nxp,sja1000";
 			reg = <0x1 0x0 0x80>;
 			interrupts = <18 0x8>;
-			interrups-parent = <&ipic>;
+			interrupts-parent = <&ipic>;
 		};
 
 		cpld@2,0 {
 			compatible = "denx,mpc8308_p1m-cpld";
 			reg = <0x2 0x0 0x8>;
 			interrupts = <48 0x8>;
-			interrups-parent = <&ipic>;
+			interrupts-parent = <&ipic>;
 		};
 	};
 
diff --git a/arch/powerpc/boot/rs6000.h b/arch/powerpc/boot/rs6000.h
index 16df8f3c43f1..24c4b528ccb2 100644
--- a/arch/powerpc/boot/rs6000.h
+++ b/arch/powerpc/boot/rs6000.h
@@ -17,7 +17,7 @@ struct external_filehdr {
 };
 
         /* IBM RS/6000 */
-#define U802WRMAGIC     0730    /* writeable text segments **chh**      */
+#define U802WRMAGIC     0730    /* writable text segments **chh**      */
 #define U802ROMAGIC     0735    /* readonly sharable text segments      */
 #define U802TOCMAGIC    0737    /* readonly text segments and TOC       */
 
@@ -63,7 +63,7 @@ AOUTHDR;
 #define SMALL_AOUTSZ (28)
 #define AOUTHDRSZ 72
 
-#define	RS6K_AOUTHDR_OMAGIC	0x0107	/* old: text & data writeable */
+#define	RS6K_AOUTHDR_OMAGIC	0x0107	/* old: text & data writable */
 #define	RS6K_AOUTHDR_NMAGIC	0x0108	/* new: text r/o, data r/w */
 #define	RS6K_AOUTHDR_ZMAGIC	0x010B	/* paged: text r/o, both page-aligned */
 
diff --git a/arch/powerpc/crypto/aes-gcm-p10.S b/arch/powerpc/crypto/aes-gcm-p10.S
index 89f50eef3512..615d4d73e5fe 100644
--- a/arch/powerpc/crypto/aes-gcm-p10.S
+++ b/arch/powerpc/crypto/aes-gcm-p10.S
@@ -326,7 +326,7 @@ __More_1x:
 	xxlor	32+28, 7, 7
 	xxlor	32+29, 8, 8
 	lwz	23, 240(6)	# n rounds
-	addi	22, 23, -9	# remaing AES rounds
+	addi	22, 23, -9	# remaining AES rounds
 
 	cmpdi	12, 0
 	bgt	__Loop_1x
@@ -700,7 +700,7 @@ __Process_encrypt:
 # Process 8x AES/GCM blocks
 #
 __Process_8x_enc:
-	# 8x blcoks
+	# 8x blocks
 	li	10, 128
 	divdu	12, 5, 10	# n 128 bytes-blocks
 
@@ -978,7 +978,7 @@ __Process_decrypt:
 # Process 8x AES/GCM blocks
 #
 __Process_8x_dec:
-	# 8x blcoks
+	# 8x blocks
 	li	10, 128
 	divdu	12, 5, 10	# n 128 bytes-blocks
 
diff --git a/arch/powerpc/crypto/aes-spe-glue.c b/arch/powerpc/crypto/aes-spe-glue.c
index 7d2827e65240..7b8cd5fecee0 100644
--- a/arch/powerpc/crypto/aes-spe-glue.c
+++ b/arch/powerpc/crypto/aes-spe-glue.c
@@ -357,7 +357,7 @@ static int ppc_xts_decrypt(struct skcipher_request *req)
 /*
  * Algorithm definitions. Disabling alignment (cra_alignmask=0) was chosen
  * because the e500 platform can handle unaligned reads/writes very efficiently.
- * This improves IPsec thoughput by another few percent. Additionally we assume
+ * This improves IPsec throughput by another few percent. Additionally we assume
  * that AES context is always aligned to at least 8 bytes because it is created
  * with kmalloc() in the crypto infrastructure
  */
diff --git a/arch/powerpc/crypto/aesp10-ppc.pl b/arch/powerpc/crypto/aesp10-ppc.pl
index 2c06ce2a2c7c..ab7b56018a0e 100644
--- a/arch/powerpc/crypto/aesp10-ppc.pl
+++ b/arch/powerpc/crypto/aesp10-ppc.pl
@@ -276,7 +276,7 @@ L192:
 	vsububm		$mask,$mask,$key	# adjust the mask
 
 Loop192:
-	vperm		$key,$in1,$in1,$mask	# roate-n-splat
+	vperm		$key,$in1,$in1,$mask	# rotate-n-splat
 	vsldoi		$tmp,$zero,$in0,12	# >>32
 	vcipherlast	$key,$key,$rcon
 
diff --git a/arch/powerpc/crypto/ghashp10-ppc.pl b/arch/powerpc/crypto/ghashp10-ppc.pl
index 27a6b0bec645..7642684f525e 100644
--- a/arch/powerpc/crypto/ghashp10-ppc.pl
+++ b/arch/powerpc/crypto/ghashp10-ppc.pl
@@ -25,7 +25,7 @@
 # Relative comparison is therefore more informative. This initial
 # version is ~2.1x slower than hardware-assisted AES-128-CTR, ~12x
 # faster than "4-bit" integer-only compiler-generated 64-bit code.
-# "Initial version" means that there is room for futher improvement.
+# "Initial version" means that there is room for further improvement.
 
 $flavour=shift;
 $output =shift;
diff --git a/arch/powerpc/include/asm/book3s/64/hash-64k.h b/arch/powerpc/include/asm/book3s/64/hash-64k.h
index 7deb3a66890b..5aaafaf17995 100644
--- a/arch/powerpc/include/asm/book3s/64/hash-64k.h
+++ b/arch/powerpc/include/asm/book3s/64/hash-64k.h
@@ -41,7 +41,7 @@
 
 /*
  * 64k aligned address free up few of the lower bits of RPN for us
- * We steal that here. For more deatils look at pte_pfn/pfn_pte()
+ * We steal that here. For more details look at pte_pfn/pfn_pte()
  */
 #define H_PAGE_COMBO	_RPAGE_RPN0 /* this is a combo 4k page */
 #define H_PAGE_4K_PFN	_RPAGE_RPN1 /* PFN is for a single 4k page */
@@ -109,7 +109,7 @@ static inline real_pte_t __real_pte(pte_t pte, pte_t *ptep, int offset)
 }
 
 /*
- * shift the hidx representation by one-modulo-0xf; i.e hidx 0 is respresented
+ * shift the hidx representation by one-modulo-0xf; i.e hidx 0 is represented
  * as 1, 1 as 2,... , and 0xf as 0.  This convention lets us represent a
  * invalid hidx 0xf with a 0x0 bit value. PTEs are anyway zero'd when
  * allocated. We dont have to zero them gain; thus save on the initialization.
@@ -252,7 +252,7 @@ static inline void mark_hpte_slot_valid(unsigned char *hpte_slot_array,
  * CONFIG_TRANSPARENT_HUGEPAGE=n to optimize away code blocks at build
  * time in such case.
  *
- * For ppc64 we need to differntiate from explicit hugepages from THP, because
+ * For ppc64 we need to differentiate from explicit hugepages from THP, because
  * for THP we also track the subpage details at the pmd level. We don't do
  * that for explicit huge pages.
  *
diff --git a/arch/powerpc/include/asm/book3s/64/mmu-hash.h b/arch/powerpc/include/asm/book3s/64/mmu-hash.h
index af12e2ba8eb8..d62350d14dbf 100644
--- a/arch/powerpc/include/asm/book3s/64/mmu-hash.h
+++ b/arch/powerpc/include/asm/book3s/64/mmu-hash.h
@@ -586,7 +586,7 @@ static inline void slb_set_size(u16 size) { }
  * Now certain config support MAX_PHYSMEM more than 512TB. Hence we will need
  * to use more than one context for linear mapping the kernel.
  * For vmalloc and memmap, we use just one context with 512TB. With 64 byte
- * struct page size, we need ony 32 TB in memmap for 2PB (51 bits (MAX_PHYSMEM_BITS)).
+ * struct page size, we need only 32 TB in memmap for 2PB (51 bits (MAX_PHYSMEM_BITS)).
  */
 #if (H_MAX_PHYSMEM_BITS > MAX_EA_BITS_PER_CONTEXT)
 #define MAX_KERNEL_CTX_CNT	(1UL << (H_MAX_PHYSMEM_BITS - MAX_EA_BITS_PER_CONTEXT))
@@ -600,7 +600,7 @@ static inline void slb_set_size(u16 size) { }
 
 /*
  * 256MB segment
- * The proto-VSID space has 2^(CONTEX_BITS + ESID_BITS) - 1 segments
+ * The proto-VSID space has 2^(CONTEXT_BITS + ESID_BITS) - 1 segments
  * available for user + kernel mapping. VSID 0 is reserved as invalid, contexts
  * 1-4 are used for kernel mapping. Each segment contains 2^28 bytes. Each
  * context maps 2^49 bytes (512TB).
@@ -622,11 +622,11 @@ static inline void slb_set_size(u16 size) { }
 #define MAX_USER_CONTEXT_65BIT_VA ((ASM_CONST(1) << (65 - (SID_SHIFT + ESID_BITS))) - 2)
 
 /*
- * This should be computed such that protovosid * vsid_mulitplier
- * doesn't overflow 64 bits. The vsid_mutliplier should also be
+ * This should be computed such that protovosid * vsid_multiplier
+ * doesn't overflow 64 bits. The vsid_multiplier should also be
  * co-prime to vsid_modulus. We also need to make sure that number
  * of bits in multiplied result (dividend) is less than twice the number of
- * protovsid bits for our modulus optmization to work.
+ * protovsid bits for our modulus optimization to work.
  *
  * The below table shows the current values used.
  * |-------+------------+----------------------+------------+-------------------|
@@ -756,7 +756,7 @@ static inline unsigned long vsid_scramble(unsigned long protovsid,
 	unsigned long vsid;
 	unsigned long vsid_modulus = ((1UL << vsid_bits) - 1);
 	/*
-	 * We have same multipler for both 256 and 1T segements now
+	 * We have same multiplier for both 256 and 1T segments now
 	 */
 	vsid = protovsid * vsid_multiplier;
 	vsid = (vsid >> vsid_bits) + (vsid & vsid_modulus);
diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index da954e779744..c51bfbfeda85 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -222,7 +222,7 @@ static inline void radix__set_pte_at(struct mm_struct *mm, unsigned long addr,
 	 *
 	 * This is not necessary for correctness, because a spurious fault
 	 * is tolerated by the page fault handler, and this store will
-	 * eventually be seen. In testing, there was no noticable increase
+	 * eventually be seen. In testing, there was no noticeable increase
 	 * in user faults on POWER9. Avoiding ptesync here is a significant
 	 * win for things like fork. If a future microarchitecture benefits
 	 * from ptesync, it should probably go into update_mmu_cache, rather
diff --git a/arch/powerpc/include/asm/cpm1.h b/arch/powerpc/include/asm/cpm1.h
index e3c6969853ef..1f3acc317465 100644
--- a/arch/powerpc/include/asm/cpm1.h
+++ b/arch/powerpc/include/asm/cpm1.h
@@ -477,7 +477,7 @@ typedef struct iic {
 } iic_t;
 
 /*
- * RISC Controller Configuration Register definitons
+ * RISC Controller Configuration Register definitions
  */
 #define RCCR_TIME	0x8000			/* RISC Timer Enable */
 #define RCCR_TIMEP(t)	(((t) & 0x3F)<<8)	/* RISC Timer Period */
diff --git a/arch/powerpc/include/asm/cpm2.h b/arch/powerpc/include/asm/cpm2.h
index a22acc36eb9b..060aef361581 100644
--- a/arch/powerpc/include/asm/cpm2.h
+++ b/arch/powerpc/include/asm/cpm2.h
@@ -576,7 +576,7 @@ typedef struct fcc_enet {
 	ushort	fen_maxd2;	/* Max DMA2 length (1520) */
 	ushort	fen_maxd;	/* internal max DMA count */
 	ushort	fen_dmacnt;	/* internal DMA counter */
-	uint	fen_octc;	/* Total octect counter */
+	uint	fen_octc;	/* Total octet counter */
 	uint	fen_colc;	/* Total collision counter */
 	uint	fen_broc;	/* Total broadcast packet counter */
 	uint	fen_mulc;	/* Total multicast packet count */
diff --git a/arch/powerpc/include/asm/cputable.h b/arch/powerpc/include/asm/cputable.h
index ec16c12296da..9d68cfbdd018 100644
--- a/arch/powerpc/include/asm/cputable.h
+++ b/arch/powerpc/include/asm/cputable.h
@@ -236,7 +236,7 @@ static inline void cpu_feature_keys_init(void) { }
 #define PPC_FEATURE_HAS_EFP_DOUBLE_COMP 0
 #endif
 
-/* We only set the TM feature if the kernel was compiled with TM supprt */
+/* We only set the TM feature if the kernel was compiled with TM support */
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 #define CPU_FTR_TM_COMP			CPU_FTR_TM
 #define PPC_FEATURE2_HTM_COMP		PPC_FEATURE2_HTM
diff --git a/arch/powerpc/include/asm/delay.h b/arch/powerpc/include/asm/delay.h
index 51bb8c1476c7..4a953bd22552 100644
--- a/arch/powerpc/include/asm/delay.h
+++ b/arch/powerpc/include/asm/delay.h
@@ -32,7 +32,7 @@ extern void udelay(unsigned long usecs);
 
 /**
  * spin_event_timeout - spin until a condition gets true or a timeout elapses
- * @condition: a C expression to evalate
+ * @condition: a C expression to evaluate
  * @timeout: timeout, in microseconds
  * @delay: the number of microseconds to delay between each evaluation of
  *         @condition
diff --git a/arch/powerpc/include/asm/epapr_hcalls.h b/arch/powerpc/include/asm/epapr_hcalls.h
index 8fc5aaa4bbba..1f0f7997ff12 100644
--- a/arch/powerpc/include/asm/epapr_hcalls.h
+++ b/arch/powerpc/include/asm/epapr_hcalls.h
@@ -38,7 +38,7 @@
  */
 
 /* A "hypercall" is an "sc 1" instruction.  This header file provides C
- * wrapper functions for the ePAPR hypervisor interface.  It is inteded
+ * wrapper functions for the ePAPR hypervisor interface.  It is intended
  * for use by Linux device drivers and other operating systems.
  *
  * The hypercalls are implemented as inline assembly, rather than assembly
diff --git a/arch/powerpc/include/asm/fsl_hcalls.h b/arch/powerpc/include/asm/fsl_hcalls.h
index b889d13547fd..7106914ed222 100644
--- a/arch/powerpc/include/asm/fsl_hcalls.h
+++ b/arch/powerpc/include/asm/fsl_hcalls.h
@@ -336,7 +336,7 @@ static inline unsigned int fh_partition_stop(unsigned int partition)
  * structures.  The array must be guest physically contiguous.
  *
  * This structure must be aligned on 32-byte boundary, so that no single
- * strucuture can span two pages.
+ * structure can span two pages.
  */
 struct fh_sg_list {
 	uint64_t source;   /**< guest physical address to copy from */
@@ -555,7 +555,7 @@ static inline unsigned int fh_get_core_state(unsigned int handle,
  * fh_enter_nap - enter nap on a vcpu
  *
  * Note that though the API supports entering nap on a vcpu other
- * than the caller, this may not be implmented and may return EINVAL.
+ * than the caller, this may not be implemented and may return EINVAL.
  *
  * @handle: handle of partition containing the vcpu
  * @vcpu: vcpu number within the partition
diff --git a/arch/powerpc/include/asm/head-64.h b/arch/powerpc/include/asm/head-64.h
index 3966bd5810cb..3c824da530e9 100644
--- a/arch/powerpc/include/asm/head-64.h
+++ b/arch/powerpc/include/asm/head-64.h
@@ -6,7 +6,7 @@
 
 #ifdef __ASSEMBLER__
 /*
- * We can't do CPP stringification and concatination directly into the section
+ * We can't do CPP stringification and concatenation directly into the section
  * name for some reason, so these macros can do it for us.
  */
 .macro define_ftsec name
@@ -29,7 +29,7 @@
  *
  * For each fixed section, code is generated into it in the order which it
  * appears in the source.  Fixed section entries can be placed at a fixed
- * location within the section using _LOCATION postifx variants. These must
+ * location within the section using _LOCATION postfix variants. These must
  * be ordered according to their relative placements within the section.
  *
  * OPEN_FIXED_SECTION(section_name, start_address, end_address)
diff --git a/arch/powerpc/include/asm/heathrow.h b/arch/powerpc/include/asm/heathrow.h
index 8bc5b168762e..3baa6645ae2a 100644
--- a/arch/powerpc/include/asm/heathrow.h
+++ b/arch/powerpc/include/asm/heathrow.h
@@ -49,7 +49,7 @@
 #define HRW_SWIM_CLONE_FLOPPY	0x00080000	/* ??? (0) */
 #define HRW_AUD_RUN22		0x00100000	/* ??? (1) */
 #define HRW_SCSI_LINK_MODE	0x00200000	/* Read ??? (1) */
-#define HRW_ARB_BYPASS		0x00400000	/* Disable internal PCI arbitrer */
+#define HRW_ARB_BYPASS		0x00400000	/* Disable internal PCI arbiter */
 #define HRW_IDE1_RESET_N	0x00800000	/* Media bay */
 #define HRW_SLOW_SCC_PCLK	0x01000000	/* ??? (0) */
 #define HRW_RESET_SCC		0x02000000
diff --git a/arch/powerpc/include/asm/highmem.h b/arch/powerpc/include/asm/highmem.h
index c0fcd1bbdba9..5ba270308ece 100644
--- a/arch/powerpc/include/asm/highmem.h
+++ b/arch/powerpc/include/asm/highmem.h
@@ -12,7 +12,7 @@
  *
  *
  * Redesigned the x86 32-bit VM architecture to deal with
- * up to 16 Terrabyte physical memory. With current x86 CPUs
+ * up to 16 Terabyte physical memory. With current x86 CPUs
  * we now support up to 64 Gigabytes physical RAM.
  *
  * Copyright (C) 1999 Ingo Molnar <mingo@redhat.com>
diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
index 7a89754842d6..15d5d5f9c79c 100644
--- a/arch/powerpc/include/asm/io.h
+++ b/arch/powerpc/include/asm/io.h
@@ -56,7 +56,7 @@ extern unsigned long pci_dram_offset;
 
 extern resource_size_t isa_mem_base;
 
-/* Boolean set by platform if PIO accesses are suppored while _IO_BASE
+/* Boolean set by platform if PIO accesses are supported while _IO_BASE
  * is not set or addresses cannot be translated to MMIO. This is typically
  * set when the platform supports "special" PIO accesses via a non memory
  * mapped mechanism, and allows things like the early udbg UART code to
@@ -427,7 +427,7 @@ __do_out_asm(_rec_outl, "stwbrx")
  * They are themselves used by the macros that define the actual accessors
  * and can be used by the hooks if any.
  *
- * Note that PIO operations are always defined in terms of their corresonding
+ * Note that PIO operations are always defined in terms of their corresponding
  * MMIO operations. That allows platforms like iSeries who want to modify the
  * behaviour of both to only hook on the MMIO version and get both. It's also
  * possible to hook directly at the toplevel PIO operation if they have to
diff --git a/arch/powerpc/include/asm/kvm_booke.h b/arch/powerpc/include/asm/kvm_booke.h
index 7c3291aa8922..2bf9818447fa 100644
--- a/arch/powerpc/include/asm/kvm_booke.h
+++ b/arch/powerpc/include/asm/kvm_booke.h
@@ -13,7 +13,7 @@
 #include <linux/kvm_host.h>
 
 /*
- * Number of available lpids. Only the low-order 6 bits of LPID rgister are
+ * Number of available lpids. Only the low-order 6 bits of LPID register are
  * implemented on e500mc+ cores.
  */
 #define KVMPPC_NR_LPIDS                        64
diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index 3298eec123a3..5e453123ad64 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -96,7 +96,7 @@ struct machdep_calls {
 	int		(*hmi_exception_early)(struct pt_regs *regs);
 	long		(*machine_check_early)(struct pt_regs *regs);
 
-	/* Called during machine check exception to retrive fixup address. */
+	/* Called during machine check exception to retrieve fixup address. */
 	bool		(*mce_check_early_recovery)(struct pt_regs *regs);
 
 	void            (*machine_check_log_err)(void);
diff --git a/arch/powerpc/include/asm/mediabay.h b/arch/powerpc/include/asm/mediabay.h
index 230fda4707b8..587b8983ac94 100644
--- a/arch/powerpc/include/asm/mediabay.h
+++ b/arch/powerpc/include/asm/mediabay.h
@@ -23,7 +23,7 @@ struct macio_dev;
 #ifdef CONFIG_PMAC_MEDIABAY
 
 /* Check the content type of the bay, returns MB_NO if the bay is still
- * transitionning
+ * transitioning
  */
 extern int check_media_bay(struct macio_dev *bay);
 
diff --git a/arch/powerpc/include/asm/mpic.h b/arch/powerpc/include/asm/mpic.h
index 0c03a98986cd..be27b0a285eb 100644
--- a/arch/powerpc/include/asm/mpic.h
+++ b/arch/powerpc/include/asm/mpic.h
@@ -406,7 +406,7 @@ static inline u32 fsl_mpic_primary_get_version(void)
  * for the range if interrupts passed in. No HW initialization is
  * actually performed.
  * 
- * @phys_addr:	physial base address of the MPIC
+ * @phys_addr:	physical base address of the MPIC
  * @flags:	flags, see constants above
  * @isu_size:	number of interrupts in an ISU. Use 0 to use a
  *              standard ISU-less setup (aka powermac)
diff --git a/arch/powerpc/include/asm/mpic_msgr.h b/arch/powerpc/include/asm/mpic_msgr.h
index cd25eeced208..ffba5a23f540 100644
--- a/arch/powerpc/include/asm/mpic_msgr.h
+++ b/arch/powerpc/include/asm/mpic_msgr.h
@@ -37,7 +37,7 @@ extern struct mpic_msgr *mpic_msgr_get(unsigned int reg_num);
  * @msgr:	the message register to return
  *
  * Disables the given message register and marks it as free.
- * After this call has completed successully the message
+ * After this call has completed successfully the message
  * register is available to be acquired by a call to
  * mpic_msgr_get.
  */
diff --git a/arch/powerpc/include/asm/nohash/32/mmu-8xx.h b/arch/powerpc/include/asm/nohash/32/mmu-8xx.h
index 74ad32e1588c..5bbf71e9c27e 100644
--- a/arch/powerpc/include/asm/nohash/32/mmu-8xx.h
+++ b/arch/powerpc/include/asm/nohash/32/mmu-8xx.h
@@ -39,7 +39,7 @@
  * 0 => Kernel => 11 (all accesses performed according as user iaw page definition)
  * 1 => Kernel+Accessed => 01 (all accesses performed according to page definition)
  * 2 => User => 11 (all accesses performed according as user iaw page definition)
- * 3 => User+Accessed => 10 (all accesses performed according to swaped page definition) for KUEP
+ * 3 => User+Accessed => 10 (all accesses performed according to swapped page definition) for KUEP
  * 4-15 => Not Used
  */
 #define MI_APG_INIT	0xde000000
diff --git a/arch/powerpc/include/asm/nohash/32/pte-8xx.h b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
index e2ea8ba9f8ca..fc90a3258886 100644
--- a/arch/powerpc/include/asm/nohash/32/pte-8xx.h
+++ b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
@@ -21,7 +21,7 @@
  * These will get masked from the level 2 descriptor at TLB load time, and
  * copied to the MD_TWC before it gets loaded.
  * Large page sizes added.  We currently support two sizes, 4K and 8M.
- * This also allows a TLB hander optimization because we can directly
+ * This also allows a TLB handler optimization because we can directly
  * load the PMD into MD_TWC.  The 8M pages are only used for kernel
  * mapping of well known areas.  The PMD (PGD) entries contain control
  * flags in addition to the address, so care must be taken that the
diff --git a/arch/powerpc/include/asm/nohash/mmu-e500.h b/arch/powerpc/include/asm/nohash/mmu-e500.h
index 2fad5ff426a0..41160c9cee29 100644
--- a/arch/powerpc/include/asm/nohash/mmu-e500.h
+++ b/arch/powerpc/include/asm/nohash/mmu-e500.h
@@ -51,7 +51,7 @@
 #define MAS0_ESEL(x)		(((x) << MAS0_ESEL_SHIFT) & MAS0_ESEL_MASK)
 #define MAS0_NV(x)		((x) & 0x00000FFF)
 #define MAS0_HES		0x00004000
-#define MAS0_WQ_ALLWAYS		0x00000000
+#define MAS0_WQ_ALWAYS		0x00000000
 #define MAS0_WQ_COND		0x00001000
 #define MAS0_WQ_CLR_RSRV       	0x00002000
 
diff --git a/arch/powerpc/include/asm/page_64.h b/arch/powerpc/include/asm/page_64.h
index d96c984d023b..c28172e414fd 100644
--- a/arch/powerpc/include/asm/page_64.h
+++ b/arch/powerpc/include/asm/page_64.h
@@ -48,7 +48,7 @@ static inline void clear_page(void *addr)
 	iterations = ppc64_caches.l1d.blocks_per_page / 8;
 
 	/*
-	 * Some verisions of gcc use multiply instructions to
+	 * Some versions of gcc use multiply instructions to
 	 * calculate the offsets so lets give it a hand to
 	 * do better.
 	 */
diff --git a/arch/powerpc/include/asm/paravirt.h b/arch/powerpc/include/asm/paravirt.h
index 92343a23ad15..3c3e0b624846 100644
--- a/arch/powerpc/include/asm/paravirt.h
+++ b/arch/powerpc/include/asm/paravirt.h
@@ -164,7 +164,7 @@ static inline bool vcpu_is_preempted(int cpu)
 		 * The result of vcpu_is_preempted() is used in a
 		 * speculative way, and is always subject to invalidation
 		 * by events internal and external to Linux. While we can
-		 * be called in preemptable context (in the Linux sense),
+		 * be called in preemptible context (in the Linux sense),
 		 * we're not accessing per-cpu resources in a way that can
 		 * race destructively with Linux scheduler preemption and
 		 * migration, and callers can tolerate the potential for
diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
index 1dae53130782..060c3015b098 100644
--- a/arch/powerpc/include/asm/pci-bridge.h
+++ b/arch/powerpc/include/asm/pci-bridge.h
@@ -91,7 +91,7 @@ struct pci_controller {
 	 * Used for variants of PCI indirect handling and possible quirks:
 	 *  SET_CFG_TYPE - used on 4xx or any PHB that does explicit type0/1
 	 *  EXT_REG - provides access to PCI-e extended registers
-	 *  SURPRESS_PRIMARY_BUS - we suppress the setting of PCI_PRIMARY_BUS
+	 *  SUPPRESS_PRIMARY_BUS - we suppress the setting of PCI_PRIMARY_BUS
 	 *   on Freescale PCI-e controllers since they used the PCI_PRIMARY_BUS
 	 *   to determine which bus number to match on when generating type0
 	 *   config cycles
@@ -107,7 +107,7 @@ struct pci_controller {
 	 */
 #define PPC_INDIRECT_TYPE_SET_CFG_TYPE		0x00000001
 #define PPC_INDIRECT_TYPE_EXT_REG		0x00000002
-#define PPC_INDIRECT_TYPE_SURPRESS_PRIMARY_BUS	0x00000004
+#define PPC_INDIRECT_TYPE_SUPPRESS_PRIMARY_BUS	0x00000004
 #define PPC_INDIRECT_TYPE_NO_PCIE_LINK		0x00000008
 #define PPC_INDIRECT_TYPE_BIG_ENDIAN		0x00000010
 #define PPC_INDIRECT_TYPE_BROKEN_MRM		0x00000020
diff --git a/arch/powerpc/include/asm/pmac_feature.h b/arch/powerpc/include/asm/pmac_feature.h
index 420e2878ae67..37da833413e7 100644
--- a/arch/powerpc/include/asm/pmac_feature.h
+++ b/arch/powerpc/include/asm/pmac_feature.h
@@ -51,7 +51,7 @@
 #define PMAC_TYPE_PSURGE		0x10	/* PowerSurge */
 #define PMAC_TYPE_ANS			0x11	/* Apple Network Server */
 
-/* Here is the infamous serie of OHare based machines
+/* Here is the infamous series of OHare based machines
  */
 #define PMAC_TYPE_COMET			0x20	/* Believed to be PowerBook 2400 */
 #define PMAC_TYPE_HOOPER		0x21	/* Believed to be PowerBook 3400 */
@@ -61,7 +61,7 @@
 #define PMAC_TYPE_UNKNOWN_OHARE		0x2f	/* Unknown, but OHare based */
 
 /* Here are the Heathrow based machines
- * FIXME: Differenciate wallstreet,mainstreet,wallstreetII
+ * FIXME: Differentiate wallstreet,mainstreet,wallstreetII
  */
 #define PMAC_TYPE_GOSSAMER		0x30	/* Gossamer motherboard */
 #define PMAC_TYPE_SILK			0x31	/* Desktop PowerMac G3 */
diff --git a/arch/powerpc/include/asm/ppc_asm.h b/arch/powerpc/include/asm/ppc_asm.h
index 46947c82a712..7f4f0c3ae0db 100644
--- a/arch/powerpc/include/asm/ppc_asm.h
+++ b/arch/powerpc/include/asm/ppc_asm.h
@@ -600,7 +600,7 @@ END_FTR_SECTION_NESTED(CPU_FTR_CELL_TB_BUG, CPU_FTR_CELL_TB_BUG, 96)
  *
  * The lower case r0-r31 should be used in preference to the upper
  * case R0-R31 as they provide more error checking in the assembler.
- * Use R0-31 only when really nessesary.
+ * Use R0-31 only when really necessary.
  */
 
 #define	r0	%r0
diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index f679a11a7e7f..70f496f1b8a1 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -31,7 +31,7 @@ struct property;
 /*
  * This is what gets passed to the kernel by prom_init or kexec
  *
- * The dt struct contains the device tree structure, full pathes and
+ * The dt struct contains the device tree structure, full paths and
  * property contents. The dt strings contain a separate block with just
  * the strings for the property names, and is fully page aligned and
  * self contained in a page, so that it can be kept around by the kernel,
@@ -59,7 +59,7 @@ struct boot_param_header {
 };
 
 /*
- * OF address retreival & translation
+ * OF address retrieval & translation
  */
 
 /* Parse the ibm,dma-window property of an OF node into the busno, phys and
diff --git a/arch/powerpc/include/asm/ps3.h b/arch/powerpc/include/asm/ps3.h
index b090ceb32a69..7e0b919614be 100644
--- a/arch/powerpc/include/asm/ps3.h
+++ b/arch/powerpc/include/asm/ps3.h
@@ -452,7 +452,7 @@ extern struct ps3_prealloc ps3flash_bounce_buffer;
 /* logical performance monitor */
 
 /**
- * enum ps3_lpm_rights - Rigths granted by the system policy module.
+ * enum ps3_lpm_rights - Rights granted by the system policy module.
  *
  * @PS3_LPM_RIGHTS_USE_LPM: The right to use the lpm.
  * @PS3_LPM_RIGHTS_USE_TB: The right to use the internal trace buffer.
diff --git a/arch/powerpc/include/asm/ps3av.h b/arch/powerpc/include/asm/ps3av.h
index c8b0f2ffcd35..16458270dc2b 100644
--- a/arch/powerpc/include/asm/ps3av.h
+++ b/arch/powerpc/include/asm/ps3av.h
@@ -676,7 +676,7 @@ extern u8 ps3av_mode_cs_info[];
 #define PS3AV_STATUS_INVALID_COMMAND		0x0003	/* obsolete invalid CID */
 #define PS3AV_STATUS_INVALID_PORT		0x0004	/* invalid port number */
 #define PS3AV_STATUS_INVALID_VID		0x0005	/* invalid video format */
-#define PS3AV_STATUS_INVALID_COLOR_SPACE	0x0006	/* invalid video colose space */
+#define PS3AV_STATUS_INVALID_COLOR_SPACE	0x0006	/* invalid video color space */
 #define PS3AV_STATUS_INVALID_FS			0x0007	/* invalid audio sampling freq */
 #define PS3AV_STATUS_INVALID_AUDIO_CH		0x0008	/* invalid audio channel number */
 #define PS3AV_STATUS_UNSUPPORTED_VERSION	0x0009	/* version mismatch  */
diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index 3449dd2b577d..851021697631 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -1246,7 +1246,7 @@
 /* Processor Version Register (PVR) field extraction */
 
 #define PVR_VER(pvr)	(((pvr) >>  16) & 0xFFFF)	/* Version field */
-#define PVR_REV(pvr)	(((pvr) >>   0) & 0xFFFF)	/* Revison field */
+#define PVR_REV(pvr)	(((pvr) >>   0) & 0xFFFF)	/* Revision field */
 
 #define pvr_version_is(pvr)	(PVR_VER(mfspr(SPRN_PVR)) == (pvr))
 
diff --git a/arch/powerpc/include/asm/reg_booke.h b/arch/powerpc/include/asm/reg_booke.h
index 56f9d3b1de85..3f65e0c5e882 100644
--- a/arch/powerpc/include/asm/reg_booke.h
+++ b/arch/powerpc/include/asm/reg_booke.h
@@ -494,7 +494,7 @@
 /* Bit definitions for L2CSR0. */
 #define L2CSR0_L2E	0x80000000	/* L2 Cache Enable */
 #define L2CSR0_L2PE	0x40000000	/* L2 Cache Parity/ECC Enable */
-#define L2CSR0_L2WP	0x1c000000	/* L2 I/D Way Partioning */
+#define L2CSR0_L2WP	0x1c000000	/* L2 I/D Way Partitioning */
 #define L2CSR0_L2CM	0x03000000	/* L2 Cache Coherency Mode */
 #define L2CSR0_L2FI	0x00200000	/* L2 Cache Flash Invalidate */
 #define L2CSR0_L2IO	0x00100000	/* L2 Cache Instruction Only */
diff --git a/arch/powerpc/include/asm/reg_fsl_emb.h b/arch/powerpc/include/asm/reg_fsl_emb.h
index ec459c3d9498..e74dd063f6a0 100644
--- a/arch/powerpc/include/asm/reg_fsl_emb.h
+++ b/arch/powerpc/include/asm/reg_fsl_emb.h
@@ -77,7 +77,7 @@ static __always_inline void mtpmr(unsigned int rn, unsigned int val)
 
 #define PMGC0_FAC	0x80000000	/* Freeze all Counters */
 #define PMGC0_PMIE	0x40000000	/* Interrupt Enable */
-#define PMGC0_FCECE	0x20000000	/* Freeze countes on
+#define PMGC0_FCECE	0x20000000	/* Freeze counters on
 					   Enabled Condition or
 					   Event */
 
diff --git a/arch/powerpc/include/asm/sfp-machine.h b/arch/powerpc/include/asm/sfp-machine.h
index 8b957aabb826..f971555f734b 100644
--- a/arch/powerpc/include/asm/sfp-machine.h
+++ b/arch/powerpc/include/asm/sfp-machine.h
@@ -258,8 +258,8 @@
 
 /* asm fragments for mul and div */
 
-/* umul_ppmm(high_prod, low_prod, multipler, multiplicand) multiplies two
- * UWtype integers MULTIPLER and MULTIPLICAND, and generates a two UWtype
+/* umul_ppmm(high_prod, low_prod, multiplier, multiplicand) multiplies two
+ * UWtype integers MULTIPLIER and MULTIPLICAND, and generates a two UWtype
  * word product in HIGH_PROD and LOW_PROD.
  */
 #define umul_ppmm(ph, pl, m0, m1) \
diff --git a/arch/powerpc/include/asm/smu.h b/arch/powerpc/include/asm/smu.h
index 2ac6ab903023..5848d4fb703d 100644
--- a/arch/powerpc/include/asm/smu.h
+++ b/arch/powerpc/include/asm/smu.h
@@ -521,7 +521,7 @@ extern int smu_queue_i2c(struct smu_i2c_cmd *cmd);
 
 
 /*
- * - SMU "sdb" partitions informations -
+ * - SMU "sdb" partitions information -
  */
 
 
@@ -569,7 +569,7 @@ struct smu_sdbp_fvt {
 };
 
 /* This partition contains voltage & current sensor calibration
- * informations
+ * information
  */
 #define SMU_SDB_CPUVCP_ID		0x21
 
@@ -610,9 +610,9 @@ struct smu_sdbp_sensortree {
 	__u8	unknown[3];
 };
 
-/* This partition contains CPU thermal control PID informations. So far
+/* This partition contains CPU thermal control PID information. So far
  * only single CPU machines have been seen with an SMU, so we assume this
- * carries only informations for those
+ * carries only information for those
  */
 #define SMU_SDB_CPUPIDDATA_ID		0x17
 
@@ -667,7 +667,7 @@ extern struct smu_sdbp_header *smu_sat_get_sdb_partition(unsigned int sat_id,
  * file is opened. poll() isn't implemented yet. The reply will consist
  * of a header as well, followed by the reply data if any. You should
  * always provide a buffer large enough for the maximum reply data, I
- * recommand one page.
+ * recommend one page.
  *
  * It is illegal to send SMU commands through a file descriptor configured
  * for events reception
@@ -688,7 +688,7 @@ struct smu_user_cmd_hdr
 struct smu_user_reply_hdr
 {
 	__u32		status;			/* Command status */
-	__u32		reply_len;		/* Length of data follwing */
+	__u32		reply_len;		/* Length of data following */
 };
 
 #endif /*  _SMU_H */
diff --git a/arch/powerpc/include/asm/tce.h b/arch/powerpc/include/asm/tce.h
index 0c34d2756d92..6fe0f68a7b72 100644
--- a/arch/powerpc/include/asm/tce.h
+++ b/arch/powerpc/include/asm/tce.h
@@ -13,7 +13,7 @@
 
 /*
  * Tces come in two formats, one for the virtual bus and a different
- * format for PCI.  PCI TCEs can have hardware or software maintianed
+ * format for PCI.  PCI TCEs can have hardware or software maintained
  * coherency.
  */
 #define TCE_VB			0
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index 97f35f9b1a96..600409fb51b7 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -52,7 +52,7 @@
  * low level task data.
  */
 struct thread_info {
-	int		preempt_count;		/* 0 => preemptable,
+	int		preempt_count;		/* 0 => preemptible,
 						   <0 => BUG */
 #ifdef CONFIG_SMP
 	unsigned int	cpu;
diff --git a/arch/powerpc/include/asm/tsi108_irq.h b/arch/powerpc/include/asm/tsi108_irq.h
index df602ca4cc52..d6a4f9a764bd 100644
--- a/arch/powerpc/include/asm/tsi108_irq.h
+++ b/arch/powerpc/include/asm/tsi108_irq.h
@@ -80,7 +80,7 @@
 #define IRQ_TSI108_TIMER3	TSI108_IRQ(35)	/* Global Timer 3 */
 
 /*
- * PCI bus INTA# - INTD# lines demultiplexor
+ * PCI bus INTA# - INTD# lines demultiplexer
  */
 #define IRQ_PCI_INTAD_BASE	TSI108_IRQ(36)
 #define IRQ_PCI_INTA		(IRQ_PCI_INTAD_BASE + 0)
diff --git a/arch/powerpc/include/asm/uninorth.h b/arch/powerpc/include/asm/uninorth.h
index 6949b5daa37d..0348d172dcc4 100644
--- a/arch/powerpc/include/asm/uninorth.h
+++ b/arch/powerpc/include/asm/uninorth.h
@@ -61,7 +61,7 @@
  *
  * Obviously, the GART is not cache coherent and so any change to it
  * must be flushed to memory (or maybe just make the GART space non
- * cachable). AGP memory itself doesn't seem to be cache coherent neither.
+ * cacheable). AGP memory itself doesn't seem to be cache coherent neither.
  *
  * In order to invalidate the GART (which is probably necessary to inval
  * the bridge internal TLBs), the following sequence has to be written,
@@ -200,7 +200,7 @@
 #define UNI_N_CLOCK_STOPPED_PCI0	0x00000002
 #define UNI_N_CLOCK_STOPPED_18		0x00000001
 
-/* Intrepid registe to OF do-platform-clockspreading */
+/* Intrepid register to OF do-platform-clockspreading */
 #define UNI_N_CLOCK_SPREADING		0x190
 
 /* Uninorth 1.5 rev. has additional perf. monitor registers at 0xf00-0xf50 */
diff --git a/arch/powerpc/include/uapi/asm/bootx.h b/arch/powerpc/include/uapi/asm/bootx.h
index 1b8c121071d9..d99f48fa9c6e 100644
--- a/arch/powerpc/include/uapi/asm/bootx.h
+++ b/arch/powerpc/include/uapi/asm/bootx.h
@@ -60,7 +60,7 @@ typedef struct boot_info_map_entry
 } boot_info_map_entry_t;
 
 
-/* Here are the boot informations that are passed to the bootstrap
+/* Here are the boot information that are passed to the bootstrap
  * Note that the kernel arguments and the device tree are appended
  * at the end of this structure. */
 typedef struct boot_infos
diff --git a/arch/powerpc/include/uapi/asm/sigcontext.h b/arch/powerpc/include/uapi/asm/sigcontext.h
index 630aeda56d59..38729c98d4c6 100644
--- a/arch/powerpc/include/uapi/asm/sigcontext.h
+++ b/arch/powerpc/include/uapi/asm/sigcontext.h
@@ -81,7 +81,7 @@ struct sigcontext {
  *
  * FPR/VSR 0-31 doubleword 0 is stored in fp_regs, and VMX/VSR 32-63
  * is stored at the start of vmx_reserve.  vmx_reserve is extended for
- * backwards compatility to store VSR 0-31 doubleword 1 after the VMX
+ * backwards compatibility to store VSR 0-31 doubleword 1 after the VMX
  * registers and vscr/vrsave.
  */
 	elf_vrreg_t	__user *v_regs;
diff --git a/arch/powerpc/kernel/85xx_entry_mapping.S b/arch/powerpc/kernel/85xx_entry_mapping.S
index dedc17fac8f8..cbabc1db7114 100644
--- a/arch/powerpc/kernel/85xx_entry_mapping.S
+++ b/arch/powerpc/kernel/85xx_entry_mapping.S
@@ -174,7 +174,7 @@ skpinv:	addi	r6,r6,1				/* Increment */
 
 #elif defined(ENTRY_MAPPING_KEXEC_SETUP)
 /*
- * 6. Setup a 1:1 mapping in TLB1. Esel 0 is unsued, 1 or 2 contains the tmp
+ * 6. Setup a 1:1 mapping in TLB1. Esel 0 is unused, 1 or 2 contains the tmp
  * mapping so we start at 3. We setup 8 mappings, each 256MiB in size. This
  * will cover the first 2GiB of memory.
  */
diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index 6f6801da9dc1..60a9fccc2e79 100644
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -124,7 +124,7 @@ struct cpu_spec * __init identify_cpu(unsigned long offset, unsigned int pvr)
 
 /*
  * Used by cpufeatures to get the name for CPUs with a PVR table.
- * If they don't hae a PVR table, cpufeatures gets the name from
+ * If they don't have a PVR table, cpufeatures gets the name from
  * cpu device-tree node.
  */
 void __init identify_cpu_name(unsigned int pvr)
diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
index bb836f02101c..16ccb92ebc6c 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -351,7 +351,7 @@ static inline unsigned long eeh_token_to_phys(unsigned long token)
 
 /*
  * On PowerNV platform, we might already have fenced PHB there.
- * For that case, it's meaningless to recover frozen PE. Intead,
+ * For that case, it's meaningless to recover frozen PE. Instead,
  * We have to handle fenced PHB firstly.
  */
 static int eeh_phb_check_failure(struct eeh_pe *pe)
@@ -1084,7 +1084,7 @@ void eeh_remove_device(struct pci_dev *dev)
 	 * During the hotplug for EEH error recovery, we need the EEH
 	 * device attached to the parent PE in order for BAR restore
 	 * a bit later. So we keep it for BAR restore and remove it
-	 * from the parent PE during the BAR resotre.
+	 * from the parent PE during the BAR restore.
 	 */
 	edev->pdev = NULL;
 
diff --git a/arch/powerpc/kernel/eeh_driver.c b/arch/powerpc/kernel/eeh_driver.c
index 028f69158532..2c9a58b6e167 100644
--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -178,7 +178,7 @@ static void eeh_enable_irq(struct eeh_dev *edev)
 		 * their own code, not by abusing the core information
 		 * to avoid it.
 		 *
-		 * I so wish that the assymetry would be the other way
+		 * I so wish that the asymmetry would be the other way
 		 * round and a few more irq_disable calls render that
 		 * shit unusable forever.
 		 *
@@ -646,7 +646,7 @@ static int eeh_reset_device(struct eeh_pe *pe, struct pci_bus *bus,
 
 	/*
 	 * We don't remove the corresponding PE instances because
-	 * we need the information afterwords. The attached EEH
+	 * we need the information afterwards. The attached EEH
 	 * devices are expected to be attached soon when calling
 	 * into pci_hp_add_devices().
 	 */
@@ -724,7 +724,7 @@ static int eeh_reset_device(struct eeh_pe *pe, struct pci_bus *bus,
  *
  * NB: This needs to be recursive to ensure the leaf PEs get removed
  * before their parents do. Although this is possible to do recursively
- * we don't since this is easier to read and we need to garantee
+ * we don't since this is easier to read and we need to guarantee
  * the leaf nodes will be handled first.
  */
 static void eeh_pe_cleanup(struct eeh_pe *pe)
@@ -977,7 +977,7 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
 
 	/* If all device drivers were EEH-unaware, then shut
 	 * down all of the device drivers, and hope they
-	 * go down willingly, without panicing the system.
+	 * go down willingly, without panicking the system.
 	 */
 	if (result == PCI_ERS_RESULT_NONE) {
 		pr_info("EEH: Reset with hotplug activity\n");
diff --git a/arch/powerpc/kernel/eeh_event.c b/arch/powerpc/kernel/eeh_event.c
index 279c1ceccd6d..4012ab408e0e 100644
--- a/arch/powerpc/kernel/eeh_event.c
+++ b/arch/powerpc/kernel/eeh_event.c
@@ -134,7 +134,7 @@ int __eeh_send_failure_event(struct eeh_pe *pe)
 	list_add(&event->list, &eeh_eventlist);
 	spin_unlock_irqrestore(&eeh_eventlist_lock, flags);
 
-	/* For EEH deamon to knick in */
+	/* For EEH daemon to knick in */
 	complete(&eeh_eventlist_event);
 
 	return 0;
diff --git a/arch/powerpc/kernel/eeh_pe.c b/arch/powerpc/kernel/eeh_pe.c
index 040e8f69a4aa..d42a1b9e266d 100644
--- a/arch/powerpc/kernel/eeh_pe.c
+++ b/arch/powerpc/kernel/eeh_pe.c
@@ -254,7 +254,7 @@ void eeh_pe_dev_traverse(struct eeh_pe *root,
  * __eeh_pe_get - Check the PE address
  *
  * For one particular PE, it can be identified by PE address
- * or tranditional BDF address. BDF address is composed of
+ * or traditional BDF address. BDF address is composed of
  * Bus/Device/Function number. The extra data referred by flag
  * indicates which type of address should be used.
  */
diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index d8426251b1cd..21b495c0ee7d 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -44,7 +44,7 @@
  */
 
 /*
- * Align to 4k in order to ensure that all functions modyfing srr0/srr1
+ * Align to 4k in order to ensure that all functions modifying srr0/srr1
  * fit into one page in order to not encounter a TLB miss between the
  * modification of srr0/srr1 and the associated rfi.
  */
diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
index 63f6b9f513a4..8124c1bd79af 100644
--- a/arch/powerpc/kernel/exceptions-64e.S
+++ b/arch/powerpc/kernel/exceptions-64e.S
@@ -874,7 +874,7 @@ kernel_dbg_exc:
 	bl	unknown_exception
 	b	interrupt_return
 
-/* Embedded Hypervisor priviledged  */
+/* Embedded Hypervisor privileged  */
 	START_EXCEPTION(ehpriv);
 	NORMAL_EXCEPTION_PROLOG(0x320, BOOKE_INTERRUPT_HV_PRIV,
 			        PROLOG_ADDITION_NONE)
@@ -1292,7 +1292,7 @@ have_hes:
 	 */
 _GLOBAL(a2_tlbinit_code_start)
 
-	ori	r11,r3,MAS0_WQ_ALLWAYS
+	ori	r11,r3,MAS0_WQ_ALWAYS
 	oris	r11,r11,MAS0_ESEL(3)@h /* Use way 3: workaround A2 erratum 376 */
 	mtspr	SPRN_MAS0,r11
 	lis	r3,(MAS1_VALID | MAS1_IPROT)@h
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index b7229430ca94..1b94b088af02 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1608,7 +1608,7 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_TYPE_RADIX)
  *
  * When running in HV mode, Linux sets up the LPCR[LPES] bit such that
  * interrupts are delivered with HSRR registers, guests use SRRs, which
- * reqiures IHSRR_IF_HVMODE.
+ * requires IHSRR_IF_HVMODE.
  *
  * On bare metal POWER9 and later, Linux sets the LPCR[HVICE] bit such that
  * external interrupts are delivered as Hypervisor Virtualization Interrupts
@@ -2042,7 +2042,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 
 #ifdef CONFIG_RELOCATABLE
 	/*
-	 * Requires __LOAD_FAR_HANDLER beause kvmppc_hcall lives
+	 * Requires __LOAD_FAR_HANDLER because kvmppc_hcall lives
 	 * outside the head section.
 	 */
 	__LOAD_FAR_HANDLER(r10, kvmppc_hcall, real_trampolines)
@@ -2980,7 +2980,7 @@ TRAMP_REAL_BEGIN(rfscv_flush_fallback)
 	sync
 
 	/*
-	 * The load adresses are at staggered offsets within cachelines,
+	 * The load addresses are at staggered offsets within cachelines,
 	 * which suits some pipelines better (on others it should not
 	 * hurt).
 	 */
diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 501d43bf18f3..969fa84aecd0 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -75,7 +75,7 @@ static struct cma *fadump_cma;
  * Initialize only the area equivalent to boot memory size for CMA use.
  * The remaining portion of fadump reserved memory will be not given
  * to CMA and pages for those will stay reserved. boot memory size is
- * aligned per CMA requirement to satisy cma_init_reserved_mem() call.
+ * aligned per CMA requirement to satisfy cma_init_reserved_mem() call.
  * But for some reason even if it fails we still have the memory reservation
  * with us and we can still continue doing fadump.
  */
@@ -388,7 +388,7 @@ static unsigned long __init get_fadump_area_size(void)
 	size += fw_dump.hpte_region_size;
 	/*
 	 * Account for pagesize alignment of boot memory area destination address.
-	 * This faciliates in mmap reading of first kernel's memory.
+	 * This facilitates in mmap reading of first kernel's memory.
 	 */
 	size = PAGE_ALIGN(size);
 	size += fw_dump.boot_memory_size;
@@ -1426,8 +1426,8 @@ static ssize_t enabled_show(struct kobject *kobj,
 }
 
 /*
- * /sys/kernel/fadump/hotplug_ready sysfs node returns 1, which inidcates
- * to usersapce that fadump re-registration is not required on memory
+ * /sys/kernel/fadump/hotplug_ready sysfs node returns 1, which indicates
+ * to userspace that fadump re-registration is not required on memory
  * hotplug events.
  */
 static ssize_t hotplug_ready_show(struct kobject *kobj,
diff --git a/arch/powerpc/kernel/head_44x.S b/arch/powerpc/kernel/head_44x.S
index 25642e802ed3..adb25de2633c 100644
--- a/arch/powerpc/kernel/head_44x.S
+++ b/arch/powerpc/kernel/head_44x.S
@@ -65,7 +65,7 @@ _GLOBAL(_start);
 /*
  * Relocate ourselves to the current runtime address.
  * This is called only by the Boot CPU.
- * "relocate" is called with our current runtime virutal
+ * "relocate" is called with our current runtime virtual
  * address.
  * r21 will be loaded with the physical runtime address of _stext
  */
@@ -75,7 +75,7 @@ _GLOBAL(_start);
 	addi	r21,r21,(_stext - 0b)@l 	/* Get our current runtime base */
 
 	/*
-	 * We have the runtime (virutal) address of our base.
+	 * We have the runtime (virtual) address of our base.
 	 * We calculate our shift of offset from a 256M page.
 	 * We could map the 256M page we belong to at PAGE_OFFSET and
 	 * get going from there.
@@ -85,7 +85,7 @@ _GLOBAL(_start);
 	rlwinm	r6,r21,0,4,31			/* r6 = PHYS_START % 256M */
 	rlwinm	r5,r4,0,4,31			/* r5 = KERNELBASE % 256M */
 	subf	r3,r5,r6			/* r3 = r6 - r5 */
-	add	r3,r4,r3			/* Required Virutal Address */
+	add	r3,r4,r3			/* Required Virtual Address */
 
 	bl	relocate
 #endif
@@ -152,7 +152,7 @@ _GLOBAL(_start);
 	 */
 
 	/* KERNELBASE&~0xfffffff => (r4,r5) */
-	li	r4, 0		/* higer 32bit */
+	li	r4, 0		/* higher 32bit */
 	lis	r5,KERNELBASE@h
 	rlwinm	r5,r5,0,0,3	/* Align to 256M, lower 32bit */
 
@@ -283,7 +283,7 @@ interrupt_base:
 
 	/* Auxiliary Processor Unavailable Interrupt */
 	EXCEPTION(0x2020, BOOKE_INTERRUPT_AP_UNAVAIL, \
-		  AuxillaryProcessorUnavailable, unknown_exception)
+		  AuxiliaryProcessorUnavailable, unknown_exception)
 
 	/* Decrementer Interrupt */
 	DECREMENTER_EXCEPTION
@@ -981,7 +981,7 @@ skpinv:	addi	r4,r4,1				/* Increment */
 	SET_IVOR(6,  Program);
 	SET_IVOR(7,  FloatingPointUnavailable);
 	SET_IVOR(8,  SystemCall);
-	SET_IVOR(9,  AuxillaryProcessorUnavailable);
+	SET_IVOR(9,  AuxiliaryProcessorUnavailable);
 	SET_IVOR(10, Decrementer);
 	SET_IVOR(11, FixedIntervalTimer);
 	SET_IVOR(12, WatchdogTimer);
@@ -1199,7 +1199,7 @@ clear_utlb_entry:
 	SET_IVOR(6,  Program);
 	SET_IVOR(7,  FloatingPointUnavailable);
 	SET_IVOR(8,  SystemCall);
-	SET_IVOR(9,  AuxillaryProcessorUnavailable);
+	SET_IVOR(9,  AuxiliaryProcessorUnavailable);
 	SET_IVOR(10, Decrementer);
 	SET_IVOR(11, FixedIntervalTimer);
 	SET_IVOR(12, WatchdogTimer);
diff --git a/arch/powerpc/kernel/head_85xx.S b/arch/powerpc/kernel/head_85xx.S
index 8867596d35ad..83229e39d645 100644
--- a/arch/powerpc/kernel/head_85xx.S
+++ b/arch/powerpc/kernel/head_85xx.S
@@ -174,7 +174,7 @@ set_ivor:
 	SET_IVOR(6,  Program);
 	SET_IVOR(7,  FloatingPointUnavailable);
 	SET_IVOR(8,  SystemCall);
-	SET_IVOR(9,  AuxillaryProcessorUnavailable);
+	SET_IVOR(9,  AuxiliaryProcessorUnavailable);
 	SET_IVOR(10, Decrementer);
 	SET_IVOR(11, FixedIntervalTimer);
 	SET_IVOR(12, WatchdogTimer);
@@ -394,7 +394,7 @@ interrupt_base:
 	SYSCALL_ENTRY   0xc00 BOOKE_INTERRUPT_SYSCALL SPRN_SRR1
 
 	/* Auxiliary Processor Unavailable Interrupt */
-	EXCEPTION(0x2900, AP_UNAVAIL, AuxillaryProcessorUnavailable, unknown_exception)
+	EXCEPTION(0x2900, AP_UNAVAIL, AuxiliaryProcessorUnavailable, unknown_exception)
 
 	/* Decrementer Interrupt */
 	DECREMENTER_EXCEPTION
@@ -822,7 +822,7 @@ SYM_FUNC_END(KernelSPE)
 #endif /* CONFIG_SPE */
 
 /*
- * Translate the effec addr in r3 to phys addr. The phys addr will be put
+ * Translate the effect addr in r3 to phys addr. The phys addr will be put
  * into r3(higher 32bit) and r4(lower 32bit)
  */
 SYM_FUNC_START_LOCAL(get_phys_addr)
diff --git a/arch/powerpc/kernel/head_book3s_32.S b/arch/powerpc/kernel/head_book3s_32.S
index c1779455ea32..86e75d2d2f81 100644
--- a/arch/powerpc/kernel/head_book3s_32.S
+++ b/arch/powerpc/kernel/head_book3s_32.S
@@ -236,7 +236,7 @@ __secondary_hold_acknowledge:
 	.long	-1
 
 /* System reset */
-/* core99 pmac starts the seconary here by changing the vector, and
+/* core99 pmac starts the secondary here by changing the vector, and
    putting it back to what it was (unknown_async_exception) when done.  */
 	EXCEPTION(INTERRUPT_SYSTEM_RESET, Reset, unknown_async_exception)
 
diff --git a/arch/powerpc/kernel/hw_breakpoint.c b/arch/powerpc/kernel/hw_breakpoint.c
index a1318ce18d0e..f5f9e4432d23 100644
--- a/arch/powerpc/kernel/hw_breakpoint.c
+++ b/arch/powerpc/kernel/hw_breakpoint.c
@@ -199,7 +199,7 @@ int hw_breakpoint_arch_parse(struct perf_event *bp,
 	if (attr->bp_type & HW_BREAKPOINT_W)
 		hw->type |= HW_BRK_TYPE_WRITE;
 	if (hw->type == HW_BRK_TYPE_TRANSLATE)
-		/* must set alteast read or write */
+		/* must set atleast read or write */
 		return ret;
 	if (!attr->exclude_user)
 		hw->type |= HW_BRK_TYPE_USER;
diff --git a/arch/powerpc/kernel/idle_book3s.S b/arch/powerpc/kernel/idle_book3s.S
index 3d97fb833834..93ec97b31f26 100644
--- a/arch/powerpc/kernel/idle_book3s.S
+++ b/arch/powerpc/kernel/idle_book3s.S
@@ -41,7 +41,7 @@ _GLOBAL(isa300_idle_stop_noloss)
  * The SRESET wakeup returns to this function's caller by calling
  * idle_return_gpr_loss with r3 set to desired return value.
  *
- * A wakeup without GPR loss may alteratively be handled as in
+ * A wakeup without GPR loss may alternatively be handled as in
  * isa300_idle_stop_noloss and blr directly, as an optimisation.
  *
  * The caller is responsible for saving/restoring SPRs, MSR, timebase,
@@ -148,7 +148,7 @@ _GLOBAL(idle_return_gpr_loss)
  * The SRESET wakeup returns to this function's caller by calling
  * idle_return_gpr_loss with r3 set to desired return value.
  *
- * A wakeup without GPR loss may alteratively be handled as in
+ * A wakeup without GPR loss may alternatively be handled as in
  * isa300_idle_stop_noloss and blr directly, as an optimisation.
  *
  * The caller is responsible for saving/restoring SPRs, MSR, timebase,
diff --git a/arch/powerpc/kernel/interrupt.c b/arch/powerpc/kernel/interrupt.c
index e63bfde13e03..e3398c7d6de2 100644
--- a/arch/powerpc/kernel/interrupt.c
+++ b/arch/powerpc/kernel/interrupt.c
@@ -417,7 +417,7 @@ notrace unsigned long interrupt_exit_kernel_prepare(struct pt_regs *regs)
 		if (!prep_irq_for_enabled_exit(unlikely(stack_store))) {
 			/*
 			 * Replay pending soft-masked interrupts now. Don't
-			 * just local_irq_enabe(); local_irq_disable(); because
+			 * just local_irq_enable(); local_irq_disable(); because
 			 * if we are returning from an asynchronous interrupt
 			 * here, another one might hit after irqs are enabled,
 			 * and it would exit via this same path allowing
diff --git a/arch/powerpc/kernel/irq_64.c b/arch/powerpc/kernel/irq_64.c
index d5c48d1b0a31..5600a86f8ddd 100644
--- a/arch/powerpc/kernel/irq_64.c
+++ b/arch/powerpc/kernel/irq_64.c
@@ -417,7 +417,7 @@ bool prep_irq_for_idle_irqsoff(void)
  * Take the SRR1 wakeup reason, index into this table to find the
  * appropriate irq_happened bit.
  *
- * Sytem reset exceptions taken in idle state also come through here,
+ * System reset exceptions taken in idle state also come through here,
  * but they are NMI interrupts so do not need to wait for IRQs to be
  * restored, and should be taken as early as practical. These are marked
  * with 0xff in the table. The Power ISA specifies 0100b as the system
diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
index ae1906bfe8a5..5bc45222e0cd 100644
--- a/arch/powerpc/kernel/legacy_serial.c
+++ b/arch/powerpc/kernel/legacy_serial.c
@@ -601,7 +601,7 @@ device_initcall(serial_dev_init);
 #ifdef CONFIG_SERIAL_8250_CONSOLE
 /*
  * This is called very early, as part of console_init() (typically just after
- * time_init()). This function is respondible for trying to find a good
+ * time_init()). This function is responsible for trying to find a good
  * default console on serial ports. It tries to match the open firmware
  * default output with one of the available serial console drivers that have
  * been probed earlier by find_legacy_serial_ports()
diff --git a/arch/powerpc/kernel/nvram_64.c b/arch/powerpc/kernel/nvram_64.c
index 42b29324287c..660b3923ba46 100644
--- a/arch/powerpc/kernel/nvram_64.c
+++ b/arch/powerpc/kernel/nvram_64.c
@@ -267,7 +267,7 @@ int nvram_read_partition(struct nvram_os_partition *part, char *buff,
  * OS partitions and try again.
  * 4.) Will first try getting a chunk that will satisfy the requested size.
  * 5.) If a chunk of the requested size cannot be allocated, then try finding
- * a chunk that will satisfy the minum needed.
+ * a chunk that will satisfy the minimum needed.
  *
  * Returns 0 on success, else -1.
  */
diff --git a/arch/powerpc/kernel/paca.c b/arch/powerpc/kernel/paca.c
index 7502066c3c53..0e263b97e016 100644
--- a/arch/powerpc/kernel/paca.c
+++ b/arch/powerpc/kernel/paca.c
@@ -141,7 +141,7 @@ static struct lppaca * __init new_lppaca(int cpu, unsigned long limit)
 #ifdef CONFIG_PPC_64S_HASH_MMU
 /*
  * 3 persistent SLBs are allocated here.  The buffer will be zero
- * initially, hence will all be invaild until we actually write them.
+ * initially, hence will all be invalid until we actually write them.
  *
  * If you make the number of persistent SLB entries dynamic, please also
  * update PR KVM to flush and restore them accordingly.
diff --git a/arch/powerpc/kernel/pci_dn.c b/arch/powerpc/kernel/pci_dn.c
index a7b664befed2..7a6fe1300714 100644
--- a/arch/powerpc/kernel/pci_dn.c
+++ b/arch/powerpc/kernel/pci_dn.c
@@ -406,7 +406,7 @@ void *pci_traverse_device_nodes(struct device_node *start,
 	struct device_node *dn, *nextdn;
 	void *ret;
 
-	/* We started with a phb, iterate all childs */
+	/* We started with a phb, iterate all children */
 	for (dn = start->child; dn; dn = nextdn) {
 		const __be32 *classp;
 		u32 class = 0;
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 9ed9dde7d231..f80de43bfc58 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -814,7 +814,7 @@ void __init early_init_devtree(void *params)
 	of_scan_flat_dt(early_init_dt_scan_fw_dump, NULL);
 #endif
 
-	/* Retrieve various informations from the /chosen node of the
+	/* Retrieve various information from the /chosen node of the
 	 * device-tree, including the platform type, initrd location and
 	 * size, TCE reserve, and more ...
 	 */
@@ -888,7 +888,7 @@ void __init early_init_devtree(void *params)
 
 	dt_cpu_ftrs_scan();
 
-	/* Retrieve CPU related informations from the flat tree
+	/* Retrieve CPU related information from the flat tree
 	 * (altivec support, boot CPU ID, ...)
 	 */
 	of_scan_flat_dt(early_init_dt_scan_cpus, NULL);
diff --git a/arch/powerpc/kernel/prom_init_check.sh b/arch/powerpc/kernel/prom_init_check.sh
index 3090b97258ae..a72401eb99e6 100644
--- a/arch/powerpc/kernel/prom_init_check.sh
+++ b/arch/powerpc/kernel/prom_init_check.sh
@@ -70,7 +70,7 @@ do
 		fi
 	done
 
-	# ignore register save/restore funcitons
+	# ignore register save/restore functions
 	case $UNDEF in
 	_restgpr_*|_restgpr0_*|_rest32gpr_*)
 		OK=1
diff --git a/arch/powerpc/kernel/ptrace/ptrace-adv.c b/arch/powerpc/kernel/ptrace/ptrace-adv.c
index 399f5d94a3df..64f00b83e197 100644
--- a/arch/powerpc/kernel/ptrace/ptrace-adv.c
+++ b/arch/powerpc/kernel/ptrace/ptrace-adv.c
@@ -159,7 +159,7 @@ static long set_instruction_bp(struct task_struct *child,
 		if (bp_info->addr2 >= TASK_SIZE)
 			return -EIO;
 
-		/* We need a pair of IAC regsisters */
+		/* We need a pair of IAC registers */
 		if (!slot1_in_use && !slot2_in_use) {
 			slot = 1;
 			child->thread.debug.iac1 = bp_info->addr;
diff --git a/arch/powerpc/kernel/ptrace/ptrace-decl.h b/arch/powerpc/kernel/ptrace/ptrace-decl.h
index 4171a5727197..992f6185c383 100644
--- a/arch/powerpc/kernel/ptrace/ptrace-decl.h
+++ b/arch/powerpc/kernel/ptrace/ptrace-decl.h
@@ -12,7 +12,7 @@
 #endif
 
 /*
- * Max register writeable via put_reg
+ * Max register writable via put_reg
  */
 #ifdef CONFIG_PPC32
 #define PT_MAX_PUT_REG	PT_MQ
diff --git a/arch/powerpc/kernel/ptrace/ptrace-tm.c b/arch/powerpc/kernel/ptrace/ptrace-tm.c
index 447bff87fd21..19f477c90cc0 100644
--- a/arch/powerpc/kernel/ptrace/ptrace-tm.c
+++ b/arch/powerpc/kernel/ptrace/ptrace-tm.c
@@ -53,7 +53,7 @@ static int set_user_ckpt_trap(struct task_struct *task, unsigned long trap)
  * @regset:	The user regset structure.
  *
  * This function checks for the active number of available
- * regisers in transaction checkpointed GPR category.
+ * registers in transaction checkpointed GPR category.
  */
 int tm_cgpr_active(struct task_struct *target, const struct user_regset *regset)
 {
@@ -195,7 +195,7 @@ int tm_cgpr_set(struct task_struct *target, const struct user_regset *regset,
  * @regset:	The user regset structure.
  *
  * This function checks for the active number of available
- * regisers in transaction checkpointed FPR category.
+ * registers in transaction checkpointed FPR category.
  */
 int tm_cfpr_active(struct task_struct *target, const struct user_regset *regset)
 {
@@ -307,7 +307,7 @@ int tm_cfpr_set(struct task_struct *target, const struct user_regset *regset,
  * @regset:	The user regset structure.
  *
  * This function checks for the active number of available
- * regisers in checkpointed VMX category.
+ * registers in checkpointed VMX category.
  */
 int tm_cvmx_active(struct task_struct *target, const struct user_regset *regset)
 {
@@ -435,7 +435,7 @@ int tm_cvmx_set(struct task_struct *target, const struct user_regset *regset,
  * @regset:	The user regset structure.
  *
  * This function checks for the active number of available
- * regisers in transaction checkpointed VSX category.
+ * registers in transaction checkpointed VSX category.
  */
 int tm_cvsx_active(struct task_struct *target, const struct user_regset *regset)
 {
@@ -546,7 +546,7 @@ int tm_cvsx_set(struct task_struct *target, const struct user_regset *regset,
  * @regset:	The user regset structure.
  *
  * This function checks the active number of available
- * regisers in the transactional memory SPR category.
+ * registers in the transactional memory SPR category.
  */
 int tm_spr_active(struct task_struct *target, const struct user_regset *regset)
 {
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 8fd7cbf3bd04..1bdcc336a8dc 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -540,7 +540,7 @@ void smp_release_cpus(void)
  * Initialize some remaining members of the ppc64_caches and systemcfg
  * structures
  * (at least until we get rid of them completely). This is mostly some
- * cache informations about the CPU that will be used by cache flush
+ * cache information about the CPU that will be used by cache flush
  * routines and/or provided to userland
  */
 
@@ -682,7 +682,7 @@ void __init initialize_cache_info(void)
 
 /*
  * This returns the limit below which memory accesses to the linear
- * mapping are guarnateed not to cause an architectural exception (e.g.,
+ * mapping are guaranteed not to cause an architectural exception (e.g.,
  * TLB or SLB miss fault).
  *
  * This is used to allocate PACAs and various interrupt stacks that
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index 7a718ed32b27..d7163124fcce 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -95,7 +95,7 @@ __unsafe_save_general_regs(struct pt_regs *regs, struct mcontext __user *frame)
 	int val, i;
 
 	for (i = 0; i <= PT_RESULT; i ++) {
-		/* Force usr to alway see softe as 1 (interrupts enabled) */
+		/* Force usr to always see softe as 1 (interrupts enabled) */
 		if (i == PT_SOFTE)
 			val = 1;
 		else
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index 86bb5bb4c143..8bba96dce9e3 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -214,7 +214,7 @@ static long setup_tm_sigcontexts(struct sigcontext __user *sc,
 	 * the context). This is very important because we must ensure we
 	 * don't lose the VRSAVE content that may have been set prior to
 	 * the process doing its first vector operation
-	 * Userland shall check AT_HWCAP to know wether it can rely on the
+	 * Userland shall check AT_HWCAP to know whether it can rely on the
 	 * v_regs pointer or not.
 	 */
 #ifdef CONFIG_ALTIVEC
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 3467f86fd78f..247e6cc41628 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -1180,7 +1180,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	if (smp_ops && smp_ops->probe)
 		smp_ops->probe();
 
-	// Initalise the generic SMT topology support
+	// Initialise the generic SMT topology support
 	num_threads = 1;
 	if (smt_enabled_at_boot)
 		num_threads = smt_enabled_at_boot;
diff --git a/arch/powerpc/kernel/switch.S b/arch/powerpc/kernel/switch.S
index 59e3ee99db0e..0652392c917f 100644
--- a/arch/powerpc/kernel/switch.S
+++ b/arch/powerpc/kernel/switch.S
@@ -11,7 +11,7 @@
 
 #ifdef CONFIG_PPC_BOOK3S_64
 /*
- * Cancel all explict user streams as they will have no use after context
+ * Cancel all explicit user streams as they will have no use after context
  * switch and will stop the HW from creating streams itself
  */
 #define STOP_STREAMS		\
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 4bbeb8644d3d..dbd258558f4f 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -902,7 +902,7 @@ void secondary_cpu_time_init(void)
 	 */
 	start_cpu_decrementer();
 
-	/* FIME: Should make unrelated change to move snapshot_timebase
+	/* FIXME: Should make unrelated change to move snapshot_timebase
 	 * call here ! */
 	register_decrementer_clockevent(smp_processor_id());
 }
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index cb8e9357383e..e32b477034b1 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -220,7 +220,7 @@ static void oops_end(unsigned long flags, struct pt_regs *regs,
 	raw_local_irq_restore(flags);
 
 	/*
-	 * system_reset_excption handles debugger, crash dump, panic, for 0x100
+	 * system_reset_exception handles debugger, crash dump, panic, for 0x100
 	 */
 	if (TRAP(regs) == INTERRUPT_SYSTEM_RESET)
 		return;
@@ -287,7 +287,7 @@ void die(const char *str, struct pt_regs *regs, long err)
 	unsigned long flags;
 
 	/*
-	 * system_reset_excption handles debugger, crash dump, panic, for 0x100
+	 * system_reset_exception handles debugger, crash dump, panic, for 0x100
 	 */
 	if (TRAP(regs) != INTERRUPT_SYSTEM_RESET) {
 		if (debugger(regs))
diff --git a/arch/powerpc/kernel/watchdog.c b/arch/powerpc/kernel/watchdog.c
index 764001deb060..9fe8a0b6b3c5 100644
--- a/arch/powerpc/kernel/watchdog.c
+++ b/arch/powerpc/kernel/watchdog.c
@@ -309,7 +309,7 @@ static void wd_smp_clear_cpu_pending(int cpu)
 	 * normal operation there will be no race here, no problem.
 	 *
 	 * In the lockup case, this atomic clear-bit vs a store that refills
-	 * other bits in the accessed word wll not be a problem. The bit clear
+	 * other bits in the accessed word will not be a problem. The bit clear
 	 * is atomic so it will not cause the store to get lost, and the store
 	 * will never set this bit so it will not overwrite the bit clear. The
 	 * only way for a stuck CPU to return to the pending bitmap is to
diff --git a/arch/powerpc/kexec/core_64.c b/arch/powerpc/kexec/core_64.c
index 825ab8a88f18..509d89078da0 100644
--- a/arch/powerpc/kexec/core_64.c
+++ b/arch/powerpc/kexec/core_64.c
@@ -349,7 +349,7 @@ void default_machine_kexec(struct kimage *image)
 
 	printk("kexec: Starting switchover sequence.\n");
 
-	/* switch to a staticly allocated stack.  Based on irq stack code.
+	/* switch to a statically allocated stack.  Based on irq stack code.
 	 * We setup preempt_count to avoid using VMX in memcpy.
 	 * XXX: the task struct will likely be invalid once we do the copy!
 	 */
diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index 8c72e12ea44e..08f6b210cd8f 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -453,7 +453,7 @@ static int load_elfcorehdr_segment(struct kimage *image, struct kexec_buf *kbuf)
 }
 
 /**
- * load_crashdump_segments_ppc64 - Initialize the additional segements needed
+ * load_crashdump_segments_ppc64 - Initialize the additional segments needed
  *                                 to load kdump kernel.
  * @image:                         Kexec image.
  * @kbuf:                          Buffer contents and memory parameters.
@@ -717,7 +717,7 @@ static int update_pci_dma_nodes(void *fdt, const char *dmapropname)
 }
 
 /**
- * setup_new_fdt_ppc64 - Update the flattend device-tree of the kernel
+ * setup_new_fdt_ppc64 - Update the flattened device-tree of the kernel
  *                       being loaded.
  * @image:               kexec image being loaded.
  * @fdt:                 Flattened device tree for the next kernel.
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 61dbeea317f3..7d8b091da7f1 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1775,7 +1775,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 	/*
 	 * We get these next two if the guest accesses a page which it thinks
 	 * it has mapped but which is not actually present, either because
-	 * it is for an emulated I/O device or because the corresonding
+	 * it is for an emulated I/O device or because the corresponding
 	 * host page has been paged out.
 	 *
 	 * Any other HDSI/HISI interrupts have been handled already for P7/8
@@ -2029,7 +2029,7 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 	/*
 	 * We get these next two if the guest accesses a page which it thinks
 	 * it has mapped but which is not actually present, either because
-	 * it is for an emulated I/O device or because the corresonding
+	 * it is for an emulated I/O device or because the corresponding
 	 * host page has been paged out.
 	 */
 	case BOOK3S_INTERRUPT_H_DATA_STORAGE:
@@ -5242,7 +5242,7 @@ static int kvm_vm_ioctl_get_smmu_info_hv(struct kvm *kvm,
 	info->flags = KVM_PPC_PAGE_SIZES_REAL | KVM_PPC_1T_SEGMENTS;
 	info->slb_size = 32;
 
-	/* We only support these sizes for now, and no muti-size segments */
+	/* We only support these sizes for now, and no multi-size segments */
 	sps = &info->sps[0];
 	kvmppc_add_seg_page_size(&sps, 12, 0);
 	kvmppc_add_seg_page_size(&sps, 16, SLB_VSID_L | SLB_VSID_LP_01);
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 34bc0a8a1288..96aac8888008 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -656,7 +656,7 @@ int kvmhv_vcpu_entry_p9(struct kvm_vcpu *vcpu, u64 time_limit, unsigned long lpc
 	 * entry.
 	 *
 	 * The "radix prefetch bug" test can be used to test for this bug, as
-	 * it also exists fo DD2.1 and below.
+	 * it also exists for DD2.1 and below.
 	 */
 	if (cpu_has_feature(CPU_FTR_P9_RADIX_PREFETCH_BUG))
 		mtspr(SPRN_HDSISR, HDSISR_CANARY);
diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 5fbb95d90e99..6ac8364a7639 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -163,7 +163,7 @@ static DEFINE_SPINLOCK(kvmppc_uvmem_bitmap_lock);
  *  All its GFNs are moved to Normal-GFNs.
  *
  *  UV_TERMINATE transitions the secure-VM back to normal-VM. All
- *  the secure-GFN and shared-GFNs are tranistioned to normal-GFN
+ *  the secure-GFN and shared-GFNs are transitioned to normal-GFN
  *  Note: The contents of the normal-GFN is undefined at this point.
  *
  * GFN state implementation:
@@ -1010,7 +1010,7 @@ static vm_fault_t kvmppc_uvmem_migrate_to_ram(struct vm_fault *vmf)
 /*
  * Release the device PFN back to the pool
  *
- * Gets called when secure GFN tranistions from a secure-PFN
+ * Gets called when secure GFN transitions from a secure-PFN
  * to a normal PFN during H_SVM_PAGE_OUT.
  * Gets called with kvm->arch.uvmem_lock held.
  */
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 2ba2dd26a7ea..9d79b6151166 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -633,7 +633,7 @@ static void kvmppc_set_pvr_pr(struct kvm_vcpu *vcpu, u32 pvr)
  * emulate 32 bytes dcbz length.
  *
  * The Book3s_64 inventors also realized this case and implemented a special bit
- * in the HID5 register, which is a hypervisor ressource. Thus we can't use it.
+ * in the HID5 register, which is a hypervisor resource. Thus we can't use it.
  *
  * My approach here is to patch the dcbz instruction on executing pages.
  */
diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
index 1d67237783b7..05acb3c743fc 100644
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -430,7 +430,7 @@ static void xive_vm_scan_for_rerouted_irqs(struct kvmppc_xive *xive,
 				goto next;
 
 			/*
-			 * Allright, it *has* been re-routed, kill it from
+			 * Alright, it *has* been re-routed, kill it from
 			 * the queue.
 			 */
 			qpage[idx] = cpu_to_be32((entry & 0x80000000) | XICS_DUMMY);
@@ -1117,7 +1117,7 @@ static u8 xive_lock_and_mask(struct kvmppc_xive *xive,
 	state->old_q = !!(val & 1);
 
 	/*
-	 * Synchronize hardware to sensure the queues are updated when
+	 * Synchronize hardware to ensure the queues are updated when
 	 * masking
 	 */
 	xive_native_sync_source(hw_num);
@@ -1174,7 +1174,7 @@ static void xive_finish_unmask(struct kvmppc_xive *xive,
 
 /*
  * Target an interrupt to a given server/prio, this will fallback
- * to another server if necessary and perform the HW targetting
+ * to another server if necessary and perform the HW targeting
  * updates as needed
  *
  * NOTE: Must be called with the state lock held
@@ -1225,16 +1225,16 @@ static int xive_target_interrupt(struct kvm *kvm,
 }
 
 /*
- * Targetting rules: In order to avoid losing track of
+ * Targeting rules: In order to avoid losing track of
  * pending interrupts across mask and unmask, which would
  * allow queue overflows, we implement the following rules:
  *
  *  - Unless it was never enabled (or we run out of capacity)
- *    an interrupt is always targetted at a valid server/queue
+ *    an interrupt is always targeted at a valid server/queue
  *    pair even when "masked" by the guest. This pair tends to
  *    be the last one used but it can be changed under some
- *    circumstances. That allows us to separate targetting
- *    from masking, we only handle accounting during (re)targetting,
+ *    circumstances. That allows us to separate targeting
+ *    from masking, we only handle accounting during (re)targeting,
  *    this also allows us to let an interrupt drain into its target
  *    queue after masking, avoiding complex schemes to remove
  *    interrupts out of remote processor queues.
@@ -1300,16 +1300,16 @@ int kvmppc_xive_set_xive(struct kvm *kvm, u32 irq, u32 server,
 	/*
 	 * We first handle masking/unmasking since the locking
 	 * might need to be retried due to EOIs, we'll handle
-	 * targetting changes later. These functions will return
+	 * targeting changes later. These functions will return
 	 * with the SB lock held.
 	 *
 	 * xive_lock_and_mask() will also set state->guest_priority
 	 * but won't otherwise change other fields of the state.
 	 *
 	 * xive_lock_for_unmask will not actually unmask, this will
-	 * be done later by xive_finish_unmask() once the targetting
+	 * be done later by xive_finish_unmask() once the targeting
 	 * has been done, so we don't try to unmask an interrupt
-	 * that hasn't yet been targetted.
+	 * that hasn't yet been targeted.
 	 */
 	if (priority == MASKED)
 		xive_lock_and_mask(xive, sb, state);
@@ -1318,7 +1318,7 @@ int kvmppc_xive_set_xive(struct kvm *kvm, u32 irq, u32 server,
 
 
 	/*
-	 * Then we handle targetting.
+	 * Then we handle targeting.
 	 *
 	 * First calculate a new "actual priority"
 	 */
@@ -1332,14 +1332,14 @@ int kvmppc_xive_set_xive(struct kvm *kvm, u32 irq, u32 server,
 	/*
 	 * Then check if we actually need to change anything,
 	 *
-	 * The condition for re-targetting the interrupt is that
+	 * The condition for re-targeting the interrupt is that
 	 * we have a valid new priority (new_act_prio is not 0xff)
 	 * and either the server or the priority changed.
 	 *
 	 * Note: If act_priority was ff and the new priority is
 	 *       also ff, we don't do anything and leave the interrupt
-	 *       untargetted. An attempt of doing an int_on on an
-	 *       untargetted interrupt will fail. If that is a problem
+	 *       untargeted. An attempt of doing an int_on on an
+	 *       untargeted interrupt will fail. If that is a problem
 	 *       we could initialize interrupts with valid default
 	 */
 
@@ -1406,10 +1406,10 @@ int kvmppc_xive_int_on(struct kvm *kvm, u32 irq)
 	pr_devel("int_on(irq=0x%x)\n", irq);
 
 	/*
-	 * Check if interrupt was not targetted
+	 * Check if interrupt was not targeted
 	 */
 	if (state->act_priority == MASKED) {
-		pr_devel("int_on on untargetted interrupt\n");
+		pr_devel("int_on on untargeted interrupt\n");
 		return -EINVAL;
 	}
 
@@ -1615,7 +1615,7 @@ int kvmppc_xive_set_mapped(struct kvm *kvm, unsigned long guest_irq,
 
 	/*
 	 * Configure the IRQ to match the existing configuration of
-	 * the IPI if it was already targetted. Otherwise this will
+	 * the IPI if it was already targeted. Otherwise this will
 	 * mask the interrupt in a lossy way (act_priority is 0xff)
 	 * which is fine for a never started interrupt.
 	 */
@@ -2387,12 +2387,12 @@ static int xive_set_source(struct kvmppc_xive *xive, long irq, u64 addr)
 
 	/*
 	 * Now, we select a target if we have one. If we don't we
-	 * leave the interrupt untargetted. It means that an interrupt
-	 * can become "untargetted" across migration if it was masked
+	 * leave the interrupt untargeted. It means that an interrupt
+	 * can become "untargeted" across migration if it was masked
 	 * by set_xive() but there is little we can do about it.
 	 */
 
-	/* First convert prio and mark interrupt as untargetted */
+	/* First convert prio and mark interrupt as untargeted */
 	act_prio = xive_prio_from_guest(guest_prio);
 	state->act_priority = MASKED;
 
@@ -2415,7 +2415,7 @@ static int xive_set_source(struct kvmppc_xive *xive, long irq, u64 addr)
 			rc = xive_target_interrupt(xive->kvm, state,
 						   server, act_prio);
 		/*
-		 * If provisioning or targetting failed, leave it
+		 * If provisioning or targeting failed, leave it
 		 * alone and masked. It will remain disabled until
 		 * the guest re-targets it.
 		 */
diff --git a/arch/powerpc/kvm/book3s_xive.h b/arch/powerpc/kvm/book3s_xive.h
index 62bf39f53783..5364029bc091 100644
--- a/arch/powerpc/kvm/book3s_xive.h
+++ b/arch/powerpc/kvm/book3s_xive.h
@@ -38,11 +38,11 @@ struct kvmppc_xive_irq_state {
 	u32 pt_number;			/* XIVE Pass-through number if any */
 	struct xive_irq_data *pt_data;	/* XIVE Pass-through associated data */
 
-	/* Targetting as set by guest */
+	/* Targeting as set by guest */
 	u8 guest_priority;		/* Guest set priority */
 	u8 saved_priority;		/* Saved priority when masking */
 
-	/* Actual targetting */
+	/* Actual targeting */
 	u32 act_server;			/* Actual server */
 	u8 act_priority;		/* Actual priority */
 
diff --git a/arch/powerpc/kvm/booke.h b/arch/powerpc/kvm/booke.h
index 9c5b8e76014f..67ad80e81723 100644
--- a/arch/powerpc/kvm/booke.h
+++ b/arch/powerpc/kvm/booke.h
@@ -15,7 +15,7 @@
 #include <asm/switch_to.h>
 #include "timing.h"
 
-/* interrupt priortity ordering */
+/* interrupt priority ordering */
 #define BOOKE_IRQPRIO_DATA_STORAGE 0
 #define BOOKE_IRQPRIO_INST_STORAGE 1
 #define BOOKE_IRQPRIO_ALIGNMENT 2
diff --git a/arch/powerpc/kvm/bookehv_interrupts.S b/arch/powerpc/kvm/bookehv_interrupts.S
index 8b4a402217ba..c90d0a7c7e99 100644
--- a/arch/powerpc/kvm/bookehv_interrupts.S
+++ b/arch/powerpc/kvm/bookehv_interrupts.S
@@ -133,9 +133,9 @@ END_BTB_FLUSH_SECTION
 
 	/*
 	 * We don't use external PID support. lwepx faults would need to be
-	 * handled by KVM and this implies aditional code in DO_KVM (for
+	 * handled by KVM and this implies additional code in DO_KVM (for
 	 * DTB_MISS, DSI and LRAT) to check ESR[EPID] and EPLC[EGS] which
-	 * is too intrusive for the host. Get last instuction in
+	 * is too intrusive for the host. Get last instruction in
 	 * kvmppc_get_last_inst().
 	 */
 	li	r9, KVM_INST_FETCH_FAILED
diff --git a/arch/powerpc/kvm/e500_mmu.c b/arch/powerpc/kvm/e500_mmu.c
index 75ed1496ead5..196f5903b3ff 100644
--- a/arch/powerpc/kvm/e500_mmu.c
+++ b/arch/powerpc/kvm/e500_mmu.c
@@ -485,7 +485,7 @@ int kvmppc_core_vcpu_translate(struct kvm_vcpu *vcpu,
 	}
 
 	tr->physical_address = kvmppc_mmu_xlate(vcpu, index, eaddr);
-	/* XXX what does "writeable" and "usermode" even mean? */
+	/* XXX what does "writable" and "usermode" even mean? */
 	tr->valid = 1;
 
 	return 0;
diff --git a/arch/powerpc/kvm/e500mc.c b/arch/powerpc/kvm/e500mc.c
index e476e107a932..d377a6e93d19 100644
--- a/arch/powerpc/kvm/e500mc.c
+++ b/arch/powerpc/kvm/e500mc.c
@@ -403,7 +403,7 @@ static int __init kvmppc_e500mc_init(void)
 
 	/*
 	 * Use two lpids per VM on dual threaded processors like e6500
-	 * to workarround the lack of tlb write conditional instruction.
+	 * to workaround the lack of tlb write conditional instruction.
 	 * Expose half the number of available hardware lpids to the lpid
 	 * allocator.
 	 */
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 00302399fc37..646b3a3686ad 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -112,7 +112,7 @@ int kvmppc_prepare_to_enter(struct kvm_vcpu *vcpu)
 		smp_mb();
 
 		if (kvm_request_pending(vcpu)) {
-			/* Make sure we process requests preemptable */
+			/* Make sure we process requests preemptible */
 			local_irq_enable();
 			trace_kvm_check_requests(vcpu);
 			r = kvmppc_core_check_requests(vcpu);
diff --git a/arch/powerpc/lib/copyuser_power7.S b/arch/powerpc/lib/copyuser_power7.S
index 17dbcfbae25f..d0e0bed379a0 100644
--- a/arch/powerpc/lib/copyuser_power7.S
+++ b/arch/powerpc/lib/copyuser_power7.S
@@ -323,7 +323,7 @@ err3;	std	r0,0(r3)
 
 4:	sub	r5,r5,r6
 
-	/* Get the desination 128B aligned */
+	/* Get the destination 128B aligned */
 	neg	r6,r3
 	srdi	r7,r6,4
 	mtocrf	0x01,r7
@@ -497,7 +497,7 @@ err3;	stw	r7,4(r3)
 
 4:	sub	r5,r5,r6
 
-	/* Get the desination 128B aligned */
+	/* Get the destination 128B aligned */
 	neg	r6,r3
 	srdi	r7,r6,4
 	mtocrf	0x01,r7
diff --git a/arch/powerpc/lib/memcmp_64.S b/arch/powerpc/lib/memcmp_64.S
index 142c666d3897..6fff90714acd 100644
--- a/arch/powerpc/lib/memcmp_64.S
+++ b/arch/powerpc/lib/memcmp_64.S
@@ -163,7 +163,7 @@ _GLOBAL_TOC(memcmp)
 
 	/* Try to compare the first double word which is not 8 bytes aligned:
 	 * load the first double word at (src & ~7UL) and shift left appropriate
-	 * bits before comparision.
+	 * bits before comparison.
 	 */
 	rlwinm  r6,r3,3,26,28
 	beq     .Lsameoffset_8bytes_aligned
diff --git a/arch/powerpc/lib/memcpy_power7.S b/arch/powerpc/lib/memcpy_power7.S
index b7c5e7fca8b9..a75ce988d11e 100644
--- a/arch/powerpc/lib/memcpy_power7.S
+++ b/arch/powerpc/lib/memcpy_power7.S
@@ -287,7 +287,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
 
 4:	sub	r5,r5,r6
 
-	/* Get the desination 128B aligned */
+	/* Get the destination 128B aligned */
 	neg	r6,r3
 	srdi	r7,r6,4
 	mtocrf	0x01,r7
@@ -461,7 +461,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
 
 4:	sub	r5,r5,r6
 
-	/* Get the desination 128B aligned */
+	/* Get the destination 128B aligned */
 	neg	r6,r3
 	srdi	r7,r6,4
 	mtocrf	0x01,r7
diff --git a/arch/powerpc/lib/rheap.c b/arch/powerpc/lib/rheap.c
index d6d72719801b..52af3bca9f20 100644
--- a/arch/powerpc/lib/rheap.c
+++ b/arch/powerpc/lib/rheap.c
@@ -3,7 +3,7 @@
  * heap points to. Normal heap implementations use the memory they manage
  * to place their list. We cannot do that because the memory we manage may
  * have special properties, for example it is uncachable or of different
- * endianess.
+ * endianness.
  *
  * Author: Pantelis Antoniou <panto@intracom.gr>
  *
@@ -366,7 +366,7 @@ int rh_attach_region(rh_info_t * info, unsigned long start, int size)
 }
 EXPORT_SYMBOL_GPL(rh_attach_region);
 
-/* Detatch given address range, splits free block if needed. */
+/* Detach given address range, splits free block if needed. */
 unsigned long rh_detach_region(rh_info_t * info, unsigned long start, int size)
 {
 	struct list_head *l;
diff --git a/arch/powerpc/mm/book3s64/hash_native.c b/arch/powerpc/mm/book3s64/hash_native.c
index e9e2dd70c060..c812a6320ad6 100644
--- a/arch/powerpc/mm/book3s64/hash_native.c
+++ b/arch/powerpc/mm/book3s64/hash_native.c
@@ -75,13 +75,13 @@ static inline unsigned long  ___tlbie(unsigned long vpn, int psize,
 	 * We need 14 to 65 bits of va for a tlibe of 4K page
 	 * With vpn we ignore the lower VPN_SHIFT bits already.
 	 * And top two bits are already ignored because we can
-	 * only accomodate 76 bits in a 64 bit vpn with a VPN_SHIFT
+	 * only accommodate 76 bits in a 64 bit vpn with a VPN_SHIFT
 	 * of 12.
 	 */
 	va = vpn << VPN_SHIFT;
 	/*
 	 * clear top 16 bits of 64bit va, non SLS segment
-	 * Older versions of the architecture (2.02 and earler) require the
+	 * Older versions of the architecture (2.02 and earlier) require the
 	 * masking of the top 16 bits.
 	 */
 	if (mmu_has_feature(MMU_FTR_TLBIE_CROP_VA))
@@ -171,7 +171,7 @@ static inline void __tlbiel(unsigned long vpn, int psize, int apsize, int ssize)
 	va = vpn << VPN_SHIFT;
 	/*
 	 * clear top 16 bits of 64 bit va, non SLS segment
-	 * Older versions of the architecture (2.02 and earler) require the
+	 * Older versions of the architecture (2.02 and earlier) require the
 	 * masking of the top 16 bits.
 	 */
 	if (mmu_has_feature(MMU_FTR_TLBIE_CROP_VA))
diff --git a/arch/powerpc/mm/book3s64/hash_pgtable.c b/arch/powerpc/mm/book3s64/hash_pgtable.c
index d9b5b751d7b7..e235617a88a6 100644
--- a/arch/powerpc/mm/book3s64/hash_pgtable.c
+++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
@@ -331,7 +331,7 @@ pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
 
 /*
  * A linux hugepage PMD was changed and the corresponding hash table entries
- * neesd to be flushed.
+ * needs to be flushed.
  */
 void hpte_do_hugepage_flush(struct mm_struct *mm, unsigned long addr,
 			    pmd_t *pmdp, unsigned long old_pmd)
diff --git a/arch/powerpc/mm/book3s64/hash_tlb.c b/arch/powerpc/mm/book3s64/hash_tlb.c
index ec2941cec815..0da108ba0353 100644
--- a/arch/powerpc/mm/book3s64/hash_tlb.c
+++ b/arch/powerpc/mm/book3s64/hash_tlb.c
@@ -34,7 +34,7 @@ EXPORT_SYMBOL_IF_KUNIT(ppc64_tlb_batch);
 
 /*
  * A linux PTE was changed and the corresponding hash table entry
- * neesd to be flushed. This function will either perform the flush
+ * needs to be flushed. This function will either perform the flush
  * immediately or will batch it up if the current CPU has an active
  * batch on it.
  */
diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
index 9dc5889d6ecb..3355cdcf26cb 100644
--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -543,7 +543,7 @@ static void hash_linear_map_add_slot(phys_addr_t paddr, int slot) {}
 /*
  * 'R' and 'C' update notes:
  *  - Under pHyp or KVM, the updatepp path will not set C, thus it *will*
- *     create writeable HPTEs without C set, because the hcall H_PROTECT
+ *     create writable HPTEs without C set, because the hcall H_PROTECT
  *     that we use in that case will not update C
  *  - The above is however not a problem, because we also don't do that
  *     fancy "no flush" variant of eviction and we use H_REMOVE which will
@@ -551,7 +551,7 @@ static void hash_linear_map_add_slot(phys_addr_t paddr, int slot) {}
  *
  *    - Under bare metal,  we do have the race, so we need R and C set
  *    - We make sure R is always set and never lost
- *    - C is _PAGE_DIRTY, and *should* always be set for a writeable mapping
+ *    - C is _PAGE_DIRTY, and *should* always be set for a writable mapping
  */
 unsigned long htab_convert_pte_flags(unsigned long pteflags, unsigned long flags)
 {
@@ -565,7 +565,7 @@ unsigned long htab_convert_pte_flags(unsigned long pteflags, unsigned long flags
 	 * Linux uses slb key 0 for kernel and 1 for user.
 	 * kernel RW areas are mapped with PPP=0b000
 	 * User area is mapped with PPP=0b010 for read/write
-	 * or PPP=0b011 for read-only (including writeable but clean pages).
+	 * or PPP=0b011 for read-only (including writable but clean pages).
 	 */
 	if (pteflags & _PAGE_PRIVILEGED) {
 		/*
@@ -718,7 +718,7 @@ int htab_remove_mapping(unsigned long vstart, unsigned long vend,
 	if (!mmu_hash_ops.hpte_removebolted)
 		return -ENODEV;
 
-	/* Unmap the full range specificied */
+	/* Unmap the full range specified */
 	vaddr = ALIGN_DOWN(vstart, step);
 	time_limit = jiffies + HZ;
 
diff --git a/arch/powerpc/mm/book3s64/hugetlbpage.c b/arch/powerpc/mm/book3s64/hugetlbpage.c
index 2bcbbf9d85ac..0092f9863f0c 100644
--- a/arch/powerpc/mm/book3s64/hugetlbpage.c
+++ b/arch/powerpc/mm/book3s64/hugetlbpage.c
@@ -107,7 +107,7 @@ int __hash_page_huge(unsigned long ea, unsigned long access, unsigned long vsid,
 
 		pa = pte_pfn(__pte(old_pte)) << PAGE_SHIFT;
 
-		/* clear HPTE slot informations in new PTE */
+		/* clear HPTE slot information in new PTE */
 		new_pte = (new_pte & ~_PAGE_HPTEFLAGS) | H_PAGE_HASHPTE;
 
 		slot = hpte_insert_repeating(hash, vpn, pa, rflags, 0,
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 10aced261cff..b31961df8b12 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -763,7 +763,7 @@ static void __meminit free_vmemmap_pages(struct page *page,
 		unsigned long base_pfn = page_to_pfn(page);
 
 		/*
-		 * with 2M vmemmap mmaping we can have things setup
+		 * with 2M vmemmap mmapping we can have things setup
 		 * such that even though atlmap is specified we never
 		 * used altmap.
 		 */
diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3s64/radix_tlb.c
index 7de5760164a9..4377659bd7ce 100644
--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -385,7 +385,7 @@ static inline void _tlbie_lpid(unsigned long lpid, unsigned long ric)
 
 	/*
 	 * Workaround the fact that the "ric" argument to __tlbie_pid
-	 * must be a compile-time contraint to match the "i" constraint
+	 * must be a compile-time constraint to match the "i" constraint
 	 * in the asm statement.
 	 */
 	switch (ric) {
@@ -408,7 +408,7 @@ static __always_inline void _tlbie_lpid_guest(unsigned long lpid, unsigned long
 {
 	/*
 	 * Workaround the fact that the "ric" argument to __tlbie_pid
-	 * must be a compile-time contraint to match the "i" constraint
+	 * must be a compile-time constraint to match the "i" constraint
 	 * in the asm statement.
 	 */
 	switch (ric) {
@@ -737,7 +737,7 @@ static DEFINE_PER_CPU(unsigned int, mm_cpumask_trim_clock);
  * Interval between flushes at which we send out IPIs to check whether the
  * mm_cpumask can be trimmed for the case where it's not a single-threaded
  * process flushing its own mm. The intent is to reduce the cost of later
- * flushes. Don't want this to be so low that it adds noticable cost to TLB
+ * flushes. Don't want this to be so low that it adds noticeable cost to TLB
  * flushing, or so high that it doesn't help reduce global TLBIEs.
  */
 static unsigned long tlb_mm_cpumask_trim_timer = 1073;
@@ -1384,7 +1384,7 @@ void radix__flush_tlb_all(void)
 	asm volatile(PPC_TLBIE_5(%0, %4, %3, %2, %1)
 		     : : "r"(rb), "i"(r), "i"(1), "i"(ric), "r"(rs) : "memory");
 	/*
-	 * now flush host entires by passing PRS = 0 and LPID == 0
+	 * now flush host entries by passing PRS = 0 and LPID == 0
 	 */
 	asm volatile(PPC_TLBIE_5(%0, %4, %3, %2, %1)
 		     : : "r"(rb), "i"(r), "i"(prs), "i"(ric), "r"(0) : "memory");
@@ -1452,7 +1452,7 @@ static inline void _tlbie_pid_lpid(unsigned long pid, unsigned long lpid,
 
 	/*
 	 * Workaround the fact that the "ric" argument to __tlbie_pid
-	 * must be a compile-time contraint to match the "i" constraint
+	 * must be a compile-time constraint to match the "i" constraint
 	 * in the asm statement.
 	 */
 	switch (ric) {
diff --git a/arch/powerpc/mm/book3s64/slb.c b/arch/powerpc/mm/book3s64/slb.c
index 15f73abd1506..4f30354cd20a 100644
--- a/arch/powerpc/mm/book3s64/slb.c
+++ b/arch/powerpc/mm/book3s64/slb.c
@@ -269,7 +269,7 @@ void slb_dump_contents(struct slb_entry *slb_ptr)
 		/* RR is not so useful as it's often not used for allocation */
 		pr_err("SLB RR allocator index %d\n", get_paca()->stab_rr);
 
-		/* Dump slb cache entires as well. */
+		/* Dump slb cache entries as well. */
 		pr_err("SLB cache ptr value = %d\n", get_paca()->slb_save_cache_ptr);
 		pr_err("Valid SLB cache entries:\n");
 		n = min_t(int, get_paca()->slb_save_cache_ptr, SLB_CACHE_ENTRIES);
diff --git a/arch/powerpc/mm/ioremap.c b/arch/powerpc/mm/ioremap.c
index 4b4feba9873b..2ad6ffb2124f 100644
--- a/arch/powerpc/mm/ioremap.c
+++ b/arch/powerpc/mm/ioremap.c
@@ -39,7 +39,7 @@ void __iomem *ioremap_prot(phys_addr_t addr, size_t size, pgprot_t prot)
 	pte_t pte = __pte(pgprot_val(prot));
 	void *caller = __builtin_return_address(0);
 
-	/* writeable implies dirty for kernel addresses */
+	/* writable implies dirty for kernel addresses */
 	if (pte_write(pte))
 		pte = pte_mkdirty(pte);
 
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 648d0c5602ec..aad54a68a64d 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -337,7 +337,7 @@ static int __init add_system_ram_resources(void)
 			res->start = start;
 			/*
 			 * In memblock, end points to the first byte after
-			 * the range while in resourses, end points to the
+			 * the range while in resources, end points to the
 			 * last byte in the range.
 			 */
 			res->end = end - 1;
diff --git a/arch/powerpc/mm/nohash/kaslr_booke.c b/arch/powerpc/mm/nohash/kaslr_booke.c
index 5e4897daaaea..80b3639288f8 100644
--- a/arch/powerpc/mm/nohash/kaslr_booke.c
+++ b/arch/powerpc/mm/nohash/kaslr_booke.c
@@ -57,7 +57,7 @@ static unsigned long __init rotate_xor(unsigned long hash, const void *area,
 	return hash;
 }
 
-/* Attempt to create a simple starting entropy. This can make it defferent for
+/* Attempt to create a simple starting entropy. This can make it different for
  * every build but it is still not enough. Stronger entropy should
  * be added to make it change for every boot.
  */
diff --git a/arch/powerpc/mm/nohash/tlb.c b/arch/powerpc/mm/nohash/tlb.c
index 0a650742f3a0..a70f02485778 100644
--- a/arch/powerpc/mm/nohash/tlb.c
+++ b/arch/powerpc/mm/nohash/tlb.c
@@ -2,7 +2,7 @@
 /*
  * This file contains the routines for TLB flushing.
  * On machines where the MMU does not use a hash table to store virtual to
- * physical translations (ie, SW loaded TLBs or Book3E compilant processors,
+ * physical translations (ie, SW loaded TLBs or Book3E compliant processors,
  * this does -not- include 603 however which shares the implementation with
  * hash based processors)
  *
diff --git a/arch/powerpc/mm/nohash/tlb_low_64e.S b/arch/powerpc/mm/nohash/tlb_low_64e.S
index de568297d5c5..10d12825096a 100644
--- a/arch/powerpc/mm/nohash/tlb_low_64e.S
+++ b/arch/powerpc/mm/nohash/tlb_low_64e.S
@@ -99,8 +99,8 @@ END_BTB_FLUSH_SECTION
 	 * ESR_ST   is 0x00800000
 	 * _PAGE_BAP_SW is 0x00000010
 	 * So the shift is >> 19. This tests for supervisor writeability.
-	 * If the page happens to be supervisor writeable and not user
-	 * writeable, we will take a new fault later, but that should be
+	 * If the page happens to be supervisor writable and not user
+	 * writable, we will take a new fault later, but that should be
 	 * a rare enough case.
 	 *
 	 * We also move ESR_ST in _PAGE_DIRTY position
diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index 243c0a1c8cda..16e499a063c5 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -363,7 +363,7 @@ static long h_get_24x7_catalog_page(char page[], u64 version, u32 index)
  * parameters.
  *
  * NOTE: For the Core domain events, rather than making domain a required
- *	 parameter we could default it to PHYS_CORE and allowe users to
+ *	 parameter we could default it to PHYS_CORE and allow users to
  *	 override the domain to one of the VCPU domains.
  *
  *	 However, this can make the interface a little inconsistent.
diff --git a/arch/powerpc/perf/hv-gpci-requests.h b/arch/powerpc/perf/hv-gpci-requests.h
index 5e86371a20c7..59d02f175426 100644
--- a/arch/powerpc/perf/hv-gpci-requests.h
+++ b/arch/powerpc/perf/hv-gpci-requests.h
@@ -25,7 +25,7 @@
  *   partition_id
  *   sibling_part_id,
  *   phys_processor_idx:
- *   0xffffffffffffffff: or -1, which means it is irrelavant for the event
+ *   0xffffffffffffffff: or -1, which means it is irrelevant for the event
  *
  * __count(offset, bytes, name):
  *	a counter that should be exposed via perf
diff --git a/arch/powerpc/perf/hv-gpci.c b/arch/powerpc/perf/hv-gpci.c
index 5cac2cf3bd1e..4c74826177a6 100644
--- a/arch/powerpc/perf/hv-gpci.c
+++ b/arch/powerpc/perf/hv-gpci.c
@@ -337,7 +337,7 @@ static ssize_t affinity_domain_via_virtual_processor_show(struct device *dev,
 
 	/*
 	 * Pass the counter request 0xA0 corresponds to request
-	 * type 'Affinity_domain_information_by_virutal_processor',
+	 * type 'Affinity_domain_information_by_virtual_processor',
 	 * to retrieve the system affinity domain information.
 	 * starting_index value refers to the starting hardware
 	 * processor index.
diff --git a/arch/powerpc/perf/imc-pmu.c b/arch/powerpc/perf/imc-pmu.c
index c1563b4eaa94..871a9800f2d0 100644
--- a/arch/powerpc/perf/imc-pmu.c
+++ b/arch/powerpc/perf/imc-pmu.c
@@ -773,7 +773,7 @@ static void core_imc_counters_release(struct perf_event *event)
 	 */
 	core_id = event->cpu / threads_per_core;
 
-	/* Take the lock and decrement the refernce count for this core */
+	/* Take the lock and decrement the reference count for this core */
 	ref = &core_imc_refc[core_id];
 	if (!ref)
 		return;
@@ -1442,7 +1442,7 @@ static int trace_imc_event_init(struct perf_event *event)
 	if (!perfmon_capable())
 		return -EACCES;
 
-	/* Return if this is a couting event */
+	/* Return if this is a counting event */
 	if (event->attr.sample_period == 0)
 		return -ENOENT;
 
diff --git a/arch/powerpc/perf/isa207-common.h b/arch/powerpc/perf/isa207-common.h
index f594fa6580d1..c19f0dcf3f79 100644
--- a/arch/powerpc/perf/isa207-common.h
+++ b/arch/powerpc/perf/isa207-common.h
@@ -69,7 +69,7 @@
 	 PERF_SAMPLE_BRANCH_KERNEL      |\
 	 PERF_SAMPLE_BRANCH_HV)
 
-/* Contants to support power9 raw encoding format */
+/* Constants to support power9 raw encoding format */
 #define p9_EVENT_COMBINE_SHIFT	10	/* Combine bit */
 #define p9_EVENT_COMBINE_MASK	0x3ull
 #define p9_EVENT_COMBINE(v)	(((v) >> p9_EVENT_COMBINE_SHIFT) & p9_EVENT_COMBINE_MASK)
@@ -89,7 +89,7 @@
 	 EVENT_LINUX_MASK					|	\
 	 EVENT_PSEL_MASK))
 
-/* Contants to support power10 raw encoding format */
+/* Constants to support power10 raw encoding format */
 #define p10_SDAR_MODE_SHIFT		22
 #define p10_SDAR_MODE_MASK		0x3ull
 #define p10_SDAR_MODE(v)		(((v) >> p10_SDAR_MODE_SHIFT) & \
diff --git a/arch/powerpc/perf/vpa-dtl.c b/arch/powerpc/perf/vpa-dtl.c
index 3e3d65b6c796..18fe466f63ab 100644
--- a/arch/powerpc/perf/vpa-dtl.c
+++ b/arch/powerpc/perf/vpa-dtl.c
@@ -93,7 +93,7 @@ struct vpa_pmu_buf {
 };
 
 /*
- * To corelate each DTL entry with other events across CPU's,
+ * To correlate each DTL entry with other events across CPU's,
  * we need to map timebase from "struct dtl_entry" which phyp
  * provides with boot timebase. This also needs timebase frequency.
  * Formula is: ((timbase from DTL entry - boot time) / frequency)
@@ -170,7 +170,7 @@ static void vpa_dtl_capture_aux(long *n_entries, struct vpa_pmu_buf *buf,
  *
  * Here in the private aux structure, we maintain head to know where
  * to copy data next time in the PMU driver. vpa_pmu_buf->head is moved to
- * maintain the aux head for PMU driver. It is responsiblity of PMU
+ * maintain the aux head for PMU driver. It is responsibility of PMU
  * driver to make sure data is copied between perf_aux_output_begin and
  * perf_aux_output_end.
  *
diff --git a/arch/powerpc/platforms/44x/uic.c b/arch/powerpc/platforms/44x/uic.c
index 3f90126a9056..ddee8c3d93b8 100644
--- a/arch/powerpc/platforms/44x/uic.c
+++ b/arch/powerpc/platforms/44x/uic.c
@@ -108,7 +108,7 @@ static void uic_mask_ack_irq(struct irq_data *d)
 	 * a level irq will have no effect if the interrupt
 	 * is still asserted by the device, even if
 	 * the interrupt is already masked. Therefore
-	 * we only ack the egde interrupts here, while
+	 * we only ack the edge interrupts here, while
 	 * level interrupts are ack'ed after the actual
 	 * isr call in the uic_unmask_irq()
 	 */
diff --git a/arch/powerpc/platforms/512x/clock-commonclk.c b/arch/powerpc/platforms/512x/clock-commonclk.c
index 079cb3627eac..0c8f6f822d64 100644
--- a/arch/powerpc/platforms/512x/clock-commonclk.c
+++ b/arch/powerpc/platforms/512x/clock-commonclk.c
@@ -1150,7 +1150,7 @@ static void __init mpc5121_clk_provide_backwards_compat(void)
 	 * provide a full list of what is missing, to avoid noise in the
 	 * absence of up-to-date device tree data -- backwards
 	 * compatibility to old DTBs is a requirement, updates may be
-	 * desirable or preferrable but are not at all mandatory
+	 * desirable or preferable but are not at all mandatory
 	 */
 	if (did_register) {
 		pr_notice("device tree lacks clock specs, adding fallbacks (0x%x,%s%s%s%s%s%s%s%s%s%s)\n",
diff --git a/arch/powerpc/platforms/512x/mpc512x_shared.c b/arch/powerpc/platforms/512x/mpc512x_shared.c
index 8c1f3b629fc7..c00deec19594 100644
--- a/arch/powerpc/platforms/512x/mpc512x_shared.c
+++ b/arch/powerpc/platforms/512x/mpc512x_shared.c
@@ -107,7 +107,7 @@ static void mpc512x_set_pixel_clock(unsigned int pixclock)
 	 *   higher frequency to not overload the hardware) until the
 	 *   first match is found -- any potential subsequent match
 	 *   would only be as good as the former match or typically
-	 *   would be less preferrable
+	 *   would be less preferable
 	 *
 	 * the offset increment of pixelclock divided by 64 is an
 	 * arbitrary choice -- it's simple to calculate, in the typical
diff --git a/arch/powerpc/platforms/52xx/lite5200_pm.c b/arch/powerpc/platforms/52xx/lite5200_pm.c
index 4900f5f48cce..2586b80b97d2 100644
--- a/arch/powerpc/platforms/52xx/lite5200_pm.c
+++ b/arch/powerpc/platforms/52xx/lite5200_pm.c
@@ -124,7 +124,7 @@ static void lite5200_restore_regs(void)
 	_memcpy_toio(gps, &sgps, sizeof(*gps));
 
 
-	/* XLB Arbitrer */
+	/* XLB Arbiter */
 	out_be32(&xlb->snoop_window, sxlb.snoop_window);
 	out_be32(&xlb->master_priority, sxlb.master_priority);
 	out_be32(&xlb->master_pri_enable, sxlb.master_pri_enable);
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pci.c b/arch/powerpc/platforms/52xx/mpc52xx_pci.c
index 0ca4401ba781..dd2e08a14314 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_pci.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_pci.c
@@ -312,7 +312,7 @@ mpc52xx_pci_setup(struct pci_controller *hose,
 
 	tmp = in_be32(&pci_regs->gscr);
 #if 0
-	/* Reset the exteral bus ( internal PCI controller is NOT reset ) */
+	/* Reset the external bus ( internal PCI controller is NOT reset ) */
 	/* Not necessary and can be a bad thing if for example the bootloader
 	   is displaying a splash screen or ... Just left here for
 	   documentation purpose if anyone need it */
@@ -400,7 +400,7 @@ mpc52xx_add_bridge(struct device_node *node)
 	pci_process_bridge_OF_ranges(hose, node, 1);
 
 	/* Finish setting up PCI using values obtained by
-	 * pci_proces_bridge_OF_ranges */
+	 * pci_process_bridge_OF_ranges */
 	mpc52xx_pci_setup(hose, pci_regs, rsrc.start);
 
 	return 0;
diff --git a/arch/powerpc/platforms/8xx/pic.c b/arch/powerpc/platforms/8xx/pic.c
index 933d6ab7f512..8411355883a2 100644
--- a/arch/powerpc/platforms/8xx/pic.c
+++ b/arch/powerpc/platforms/8xx/pic.c
@@ -13,7 +13,7 @@
 #include "pic.h"
 
 
-#define PIC_VEC_SPURRIOUS      15
+#define PIC_VEC_SPURIOUS      15
 
 static struct irq_domain *mpc8xx_pic_host;
 static unsigned long mpc8xx_cached_irq_mask;
@@ -77,7 +77,7 @@ unsigned int mpc8xx_get_irq(void)
 	 */
 	irq = in_be32(&siu_reg->sc_sivec) >> 26;
 
-	if (irq == PIC_VEC_SPURRIOUS)
+	if (irq == PIC_VEC_SPURIOUS)
 		return 0;
 
         return irq_find_mapping(mpc8xx_pic_host, irq);
diff --git a/arch/powerpc/platforms/book3s/vas-api.c b/arch/powerpc/platforms/book3s/vas-api.c
index e96d79db69fe..bf258294e13d 100644
--- a/arch/powerpc/platforms/book3s/vas-api.c
+++ b/arch/powerpc/platforms/book3s/vas-api.c
@@ -489,7 +489,7 @@ static void vas_mmap_close(struct vm_area_struct *vma)
 	 * address. So it has to be the same VMA that is getting freed.
 	 */
 	if (WARN_ON(txwin->task_ref.vma != vma)) {
-		pr_err("Invalid paste address mmaping\n");
+		pr_err("Invalid paste address mmapping\n");
 		return;
 	}
 
@@ -564,7 +564,7 @@ static int coproc_mmap(struct file *fp, struct vm_area_struct *vma)
 
 	pfn = paste_addr >> PAGE_SHIFT;
 
-	/* flags, page_prot from cxl_mmap(), except we want cachable */
+	/* flags, page_prot from cxl_mmap(), except we want cacheable */
 	vm_flags_set(vma, VM_IO | VM_PFNMAP);
 	vma->vm_page_prot = pgprot_cached(vma->vm_page_prot);
 
diff --git a/arch/powerpc/platforms/cell/spufs/context.c b/arch/powerpc/platforms/cell/spufs/context.c
index 44377dfff1f8..5c05f880fb73 100644
--- a/arch/powerpc/platforms/cell/spufs/context.c
+++ b/arch/powerpc/platforms/cell/spufs/context.c
@@ -137,8 +137,8 @@ void spu_unmap_mappings(struct spu_context *ctx)
 }
 
 /**
- * spu_acquire_saved - lock spu contex and make sure it is in saved state
- * @ctx:	spu contex to lock
+ * spu_acquire_saved - lock spu context and make sure it is in saved state
+ * @ctx:	spu context to lock
  */
 int spu_acquire_saved(struct spu_context *ctx)
 {
diff --git a/arch/powerpc/platforms/cell/spufs/spu_restore_crt0.S b/arch/powerpc/platforms/cell/spufs/spu_restore_crt0.S
index 6d799f84763a..eb1c0f9fed35 100644
--- a/arch/powerpc/platforms/cell/spufs/spu_restore_crt0.S
+++ b/arch/powerpc/platforms/cell/spufs/spu_restore_crt0.S
@@ -86,7 +86,7 @@ restore_reg_insts:       /* must be quad-word aligned. */
 	 * However it is possible that instructions immediately
 	 * following the 'stop 0x3ffc' have been modified at run
 	 * time so as to recreate the exact SPU_Status settings
-	 * from the application, e.g. illegal instruciton, halt,
+	 * from the application, e.g. illegal instruction, halt,
 	 * etc.
 	 */
 .global exit_fini
diff --git a/arch/powerpc/platforms/cell/spufs/switch.c b/arch/powerpc/platforms/cell/spufs/switch.c
index b41e81b22fdc..ef3cfca70082 100644
--- a/arch/powerpc/platforms/cell/spufs/switch.c
+++ b/arch/powerpc/platforms/cell/spufs/switch.c
@@ -9,11 +9,11 @@
  * Host-side part of SPU context switch sequence outlined in
  * Synergistic Processor Element, Book IV.
  *
- * A fully premptive switch of an SPE is very expensive in terms
+ * A fully preemptive switch of an SPE is very expensive in terms
  * of time and system resources.  SPE Book IV indicates that SPE
  * allocation should follow a "serially reusable device" model,
  * in which the SPE is assigned a task until it completes.  When
- * this is not possible, this sequence may be used to premptively
+ * this is not possible, this sequence may be used to preemptively
  * save, and then later (optionally) restore the context of a
  * program executing on an SPE.
  */
@@ -574,7 +574,7 @@ static inline void save_mfc_rag(struct spu_state *csa, struct spu *spu)
 {
 	/* Save, Step 38:
 	 *     Save RA_GROUP_ID register and the
-	 *     RA_ENABLE reigster in the CSA.
+	 *     RA_ENABLE register in the CSA.
 	 */
 	csa->priv1.resource_allocation_groupID_RW =
 		spu_resource_allocation_groupID_get(spu);
@@ -1227,7 +1227,7 @@ static inline void restore_mfc_rag(struct spu_state *csa, struct spu *spu)
 {
 	/* Restore, Step 29:
 	 *     Restore RA_GROUP_ID register and the
-	 *     RA_ENABLE reigster from the CSA.
+	 *     RA_ENABLE register from the CSA.
 	 */
 	spu_resource_allocation_groupID_set(spu,
 			csa->priv1.resource_allocation_groupID_RW);
diff --git a/arch/powerpc/platforms/powermac/bootx_init.c b/arch/powerpc/platforms/powermac/bootx_init.c
index 72eb99aba40f..51f2e2edf284 100644
--- a/arch/powerpc/platforms/powermac/bootx_init.c
+++ b/arch/powerpc/platforms/powermac/bootx_init.c
@@ -527,7 +527,7 @@ void __init bootx_init(unsigned long r3, unsigned long r4)
 #endif
 
 	/* New BootX enters kernel with MMU off, i/os are not allowed
-	 * here. This hack will have been done by the boostrap anyway.
+	 * here. This hack will have been done by the bootstrap anyway.
 	 */
 	if (bi->version < 4) {
 		/*
diff --git a/arch/powerpc/platforms/powermac/cache.S b/arch/powerpc/platforms/powermac/cache.S
index b8ae56e9f414..edeafca6bb66 100644
--- a/arch/powerpc/platforms/powermac/cache.S
+++ b/arch/powerpc/platforms/powermac/cache.S
@@ -112,7 +112,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
 	b	1b
 1:	/* disp-flush L2. The interesting thing here is that the L2 can be
 	 * up to 2Mb ... so using the ROM, we'll end up wrapping back to memory
-	 * but that is probbaly fine. We disp-flush over 4Mb to be safe
+	 * but that is probably fine. We disp-flush over 4Mb to be safe
 	 */
 	lis	r4,2
 	mtctr	r4
diff --git a/arch/powerpc/platforms/powermac/feature.c b/arch/powerpc/platforms/powermac/feature.c
index 2cc257f75c50..ec83c87f1fff 100644
--- a/arch/powerpc/platforms/powermac/feature.c
+++ b/arch/powerpc/platforms/powermac/feature.c
@@ -2588,7 +2588,7 @@ static void __init probe_uninorth(void)
 	       (unsigned int)res.start, uninorth_rev);
 	printk(KERN_INFO "Mapped at 0x%08lx\n", (unsigned long)uninorth_base);
 
-	/* Set the arbitrer QAck delay according to what Apple does
+	/* Set the arbiter QAck delay according to what Apple does
 	 */
 	if (uninorth_rev < 0x11) {
 		actrl = UN_IN(UNI_N_ARB_CTRL) & ~UNI_N_ARB_CTRL_QACK_DELAY_MASK;
diff --git a/arch/powerpc/platforms/powermac/low_i2c.c b/arch/powerpc/platforms/powermac/low_i2c.c
index 73b7f4e8c047..c9c85cbef532 100644
--- a/arch/powerpc/platforms/powermac/low_i2c.c
+++ b/arch/powerpc/platforms/powermac/low_i2c.c
@@ -912,7 +912,7 @@ static void __init smu_i2c_probe(void)
 
 	printk(KERN_INFO "SMU i2c %pOF\n", controller);
 
-	/* Look for childs, note that they might not be of the right
+	/* Look for children, note that they might not be of the right
 	 * type as older device trees mix i2c busses and other things
 	 * at the same level
 	 */
diff --git a/arch/powerpc/platforms/powermac/pci.c b/arch/powerpc/platforms/powermac/pci.c
index d71359b5331c..bcdefed2ab84 100644
--- a/arch/powerpc/platforms/powermac/pci.c
+++ b/arch/powerpc/platforms/powermac/pci.c
@@ -628,7 +628,7 @@ static void __init setup_u3_agp(struct pci_controller* hose)
 	 * to reassign bus numbers for HT. If we ever have P2P bridges
 	 * on AGP, we'll have to move pci_assign_all_busses to the
 	 * pci_controller structure so we enable it for AGP and not for
-	 * HT childs.
+	 * HT children.
 	 * We hard code the address because of the different size of
 	 * the reg address cell, we shall fix that by killing struct
 	 * reg_property and using some accessor functions instead
diff --git a/arch/powerpc/platforms/powermac/pfunc_base.c b/arch/powerpc/platforms/powermac/pfunc_base.c
index 8253de737373..ecc1e15dc7ee 100644
--- a/arch/powerpc/platforms/powermac/pfunc_base.c
+++ b/arch/powerpc/platforms/powermac/pfunc_base.c
@@ -283,7 +283,7 @@ static int unin_do_write_reg32(PMF_STD_ARGS, u32 offset, u32 value, u32 mask)
 
 	raw_spin_lock_irqsave(&feature_lock, flags);
 	/* This is fairly bogus in darwin, but it should work for our needs
-	 * implemeted that way:
+	 * implemented that way:
 	 */
 	UN_OUT(offset, (UN_IN(offset) & ~mask) | (value & mask));
 	raw_spin_unlock_irqrestore(&feature_lock, flags);
diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/platforms/powermac/setup.c
index eb092f293113..b333ff907515 100644
--- a/arch/powerpc/platforms/powermac/setup.c
+++ b/arch/powerpc/platforms/powermac/setup.c
@@ -485,7 +485,7 @@ machine_device_initcall(powermac, pmac_declare_of_platform_devices);
 #ifdef CONFIG_SERIAL_PMACZILOG_CONSOLE
 /*
  * This is called very early, as part of console_init() (typically just after
- * time_init()). This function is respondible for trying to find a good
+ * time_init()). This function is responsible for trying to find a good
  * default console on serial ports. It tries to match the open firmware
  * default output with one of the available serial console drivers.
  */
diff --git a/arch/powerpc/platforms/powermac/sleep.S b/arch/powerpc/platforms/powermac/sleep.S
index 822ed70cdcbf..c78ee0611246 100644
--- a/arch/powerpc/platforms/powermac/sleep.S
+++ b/arch/powerpc/platforms/powermac/sleep.S
@@ -229,7 +229,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_SPEC7450)
 	mtspr	SPRN_HID0,r2
 	sync
 
-/* This loop puts us back to sleep in case we have a spurrious
+/* This loop puts us back to sleep in case we have a spurious
  * wakeup so that the host bridge properly stays asleep. The
  * CPU will be turned off, either after a known time (about 1
  * second) on wallstreet & lombard, or as soon as the CPU enters
diff --git a/arch/powerpc/platforms/powernv/eeh-powernv.c b/arch/powerpc/platforms/powernv/eeh-powernv.c
index db3370d1673c..30dd62e92964 100644
--- a/arch/powerpc/platforms/powernv/eeh-powernv.c
+++ b/arch/powerpc/platforms/powernv/eeh-powernv.c
@@ -669,7 +669,7 @@ static int pnv_eeh_get_pe_state(struct eeh_pe *pe)
  * @pe: EEH PE
  * @delay: delay while PE state is temporarily unavailable
  *
- * Retrieve the state of the specified PE. For IODA-compitable
+ * Retrieve the state of the specified PE. For IODA-compatible
  * platform, it should be retrieved from IODA table. Therefore,
  * we prefer passing down to hardware implementation to handle
  * it.
diff --git a/arch/powerpc/platforms/powernv/opal-lpc.c b/arch/powerpc/platforms/powernv/opal-lpc.c
index 2bb326b58ff8..eff69ff28150 100644
--- a/arch/powerpc/platforms/powernv/opal-lpc.c
+++ b/arch/powerpc/platforms/powernv/opal-lpc.c
@@ -288,7 +288,7 @@ static ssize_t lpc_debug_write(struct file *filp, const char __user *ubuf,
 
 		/*
 		 * Select access size based on count and alignment and
-		 * access type. IO and MEM only support byte acceses,
+		 * access type. IO and MEM only support byte accesses,
 		 * FW supports all 3.
 		 */
 		len = 1;
diff --git a/arch/powerpc/platforms/powernv/opal-memory-errors.c b/arch/powerpc/platforms/powernv/opal-memory-errors.c
index 54815882d7c0..51c54911458c 100644
--- a/arch/powerpc/platforms/powernv/opal-memory-errors.c
+++ b/arch/powerpc/platforms/powernv/opal-memory-errors.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * OPAL asynchronus Memory error handling support in PowerNV.
+ * OPAL asynchronous Memory error handling support in PowerNV.
  *
  * Copyright 2013 IBM Corporation
  * Author: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
index 1946dbdc9fa1..e679c6f85148 100644
--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -285,7 +285,7 @@ static void dequeue_replay_msg(enum opal_msg_type msg_type)
 
 /*
  * Opal message notifier based on message type. Allow subscribers to get
- * notified for specific messgae type.
+ * notified for specific message type.
  */
 int opal_message_notifier_register(enum opal_msg_type msg_type,
 					struct notifier_block *nb)
@@ -1017,7 +1017,7 @@ static int __init opal_init(void)
 	/* Initialise OPAL sensor interface */
 	opal_sensor_init();
 
-	/* Initialise OPAL hypervisor maintainence interrupt handling */
+	/* Initialise OPAL hypervisor maintenance interrupt handling */
 	opal_hmi_handler_init();
 
 	/* Create i2c platform devices */
@@ -1026,7 +1026,7 @@ static int __init opal_init(void)
 	/* Handle non-volatile memory devices */
 	opal_pdev_init("pmem-region");
 
-	/* Setup a heatbeat thread if requested by OPAL */
+	/* Setup a heartbeat thread if requested by OPAL */
 	opal_init_heartbeat();
 
 	/* Detect In-Memory Collection counters and create devices*/
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 32ecbc46e74b..f0b0827a773c 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -387,7 +387,7 @@ static void __init pnv_ioda_parse_m64_window(struct pnv_phb *phb)
 		return;
 	}
 
-	/* Configure M64 informations */
+	/* Configure M64 information */
 	res = &hose->mem_resources[1];
 	res->name = dn->full_name;
 	res->start = of_translate_address(dn, r + 2);
diff --git a/arch/powerpc/platforms/powernv/pci-sriov.c b/arch/powerpc/platforms/powernv/pci-sriov.c
index 7105a573aec4..ad035f4039ae 100644
--- a/arch/powerpc/platforms/powernv/pci-sriov.c
+++ b/arch/powerpc/platforms/powernv/pci-sriov.c
@@ -86,7 +86,7 @@
  *    When using mode a) described above segment 0 in maps to PE#0 which might
  *    be already being used by another device on the PHB.
  *
- *    As a result we need allocate a contigious range of PE numbers, then shift
+ *    As a result we need allocate a contiguous range of PE numbers, then shift
  *    the address programmed into the SR-IOV BAR of the PF so that the address
  *    of VF0 matches up with the segment corresponding to the first allocated
  *    PE number. This is handled in pnv_pci_vf_resource_shift().
diff --git a/arch/powerpc/platforms/powernv/vas-fault.c b/arch/powerpc/platforms/powernv/vas-fault.c
index 2b47d5a86328..f0193dd7f14d 100644
--- a/arch/powerpc/platforms/powernv/vas-fault.c
+++ b/arch/powerpc/platforms/powernv/vas-fault.c
@@ -46,7 +46,7 @@ static void dump_fifo(struct vas_instance *vinst, void *entry)
 /*
  * Process valid CRBs in fault FIFO.
  * NX process user space requests, return credit and update the status
- * in CRB. If it encounters transalation error when accessing CRB or
+ * in CRB. If it encounters translation error when accessing CRB or
  * request buffers, raises interrupt on the CPU to handle the fault.
  * It takes credit on fault window, updates nx_fault_stamp in CRB with
  * the following information and pastes CRB in fault FIFO.
diff --git a/arch/powerpc/platforms/powernv/vas.h b/arch/powerpc/platforms/powernv/vas.h
index 08d9d3d5a22b..5fbe1d887b0a 100644
--- a/arch/powerpc/platforms/powernv/vas.h
+++ b/arch/powerpc/platforms/powernv/vas.h
@@ -17,7 +17,7 @@
  * Overview of Virtual Accelerator Switchboard (VAS).
  *
  * VAS is a hardware "switchboard" that allows senders and receivers to
- * exchange messages with _minimal_ kernel involvment. The receivers are
+ * exchange messages with _minimal_ kernel involvement. The receivers are
  * typically NX coprocessor engines that perform compression or encryption
  * in hardware, but receivers can also be other software threads.
  *
@@ -298,7 +298,7 @@ enum vas_notify_after_count {
  * to process all of them. So read all valid CRB entries until find the
  * invalid one. So use pswid which is pasted by NX and ccw[0] (reserved
  * bit in BE) to check valid CRB. CCW[0] will not be touched by user
- * space. Application gets CRB formt error if it updates this bit.
+ * space. Application gets CRB format error if it updates this bit.
  *
  * Invalidate FIFO during allocation and process all entries from last
  * successful read until finds invalid pswid and ccw[0] values.
diff --git a/arch/powerpc/platforms/ps3/interrupt.c b/arch/powerpc/platforms/ps3/interrupt.c
index a4ad4b49eef7..a71c30f2e8ab 100644
--- a/arch/powerpc/platforms/ps3/interrupt.c
+++ b/arch/powerpc/platforms/ps3/interrupt.c
@@ -384,7 +384,7 @@ int ps3_send_event_locally(unsigned int virq)
  * @virq: The assigned Linux virq.
  *
  * An event irq represents a virtual device interrupt.  The interrupt_id
- * coresponds to the software interrupt number.
+ * corresponds to the software interrupt number.
  */
 
 int ps3_sb_event_receive_port_setup(struct ps3_system_bus_device *dev,
@@ -460,7 +460,7 @@ EXPORT_SYMBOL(ps3_sb_event_receive_port_destroy);
  * @virq: The assigned Linux virq.
  *
  * An io irq represents a non-virtualized device interrupt.  interrupt_id
- * coresponds to the interrupt number of the interrupt controller.
+ * corresponds to the interrupt number of the interrupt controller.
  */
 
 int ps3_io_irq_setup(enum ps3_cpu_binding cpu, unsigned int interrupt_id,
diff --git a/arch/powerpc/platforms/ps3/platform.h b/arch/powerpc/platforms/ps3/platform.h
index 6beecdb0d51f..37cf51b4cb60 100644
--- a/arch/powerpc/platforms/ps3/platform.h
+++ b/arch/powerpc/platforms/ps3/platform.h
@@ -229,8 +229,8 @@ int ps3_repository_read_boot_dat_info(u64 *lpar_addr, unsigned int *size);
 
 /**
  * enum spu_resource_type - Type of spu resource.
- * @spu_resource_type_shared: Logical spu is shared with other partions.
- * @spu_resource_type_exclusive: Logical spu is not shared with other partions.
+ * @spu_resource_type_shared: Logical spu is shared with other partitions.
+ * @spu_resource_type_exclusive: Logical spu is not shared with other partitions.
  *
  * Returned by ps3_repository_read_spu_resource_id().
  */
diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
index b12ef382fec7..a70db15e35d0 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -672,7 +672,7 @@ static int pseries_eeh_configure_bridge(struct eeh_pe *pe)
  * @size: size to read
  * @val: return value
  *
- * Read config space from the speicifed device
+ * Read config space from the specified device
  */
 static int pseries_eeh_read_config(struct eeh_dev *edev, int where, int size, u32 *val)
 {
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 3e1f915fe4f6..f94ff2d54250 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -1117,7 +1117,7 @@ static void find_existing_ddw_windows_named(const char *name)
 		/* If at the time of system initialization, there are DDWs in OF,
 		 * it means this is during kexec. DDW could be direct or dynamic.
 		 * We will just mark DDWs as "dynamic" since this is kdump path,
-		 * no need to worry about perforance. ddw_list_new_entry() will
+		 * no need to worry about performance. ddw_list_new_entry() will
 		 * set window->direct = false.
 		 */
 		window = ddw_list_new_entry(pdn, dma64);
@@ -2085,7 +2085,7 @@ static long spapr_tce_create_table(struct iommu_table_group *table_group, int nu
 	ret = -ENODEV;
 
 	pdn = pci_dma_find_parent_node(pdev, table_group);
-	if (!pdn || !PCI_DN(pdn)) { /* Niether of 32s|64-bit exist! */
+	if (!pdn || !PCI_DN(pdn)) { /* Neither of 32s|64-bit exist! */
 		dev_warn(&pdev->dev, "No dma-windows exist for the node %pOF\n", pdn);
 		goto out_failed;
 	}
@@ -2291,7 +2291,7 @@ static long spapr_tce_unset_window(struct iommu_table_group *table_group, int nu
 		win_name = DMA64_PROPNAME;
 
 	pdn = pci_dma_find(dn, NULL);
-	if (!pdn || !PCI_DN(pdn)) { /* Niether of 32s|64-bit exist! */
+	if (!pdn || !PCI_DN(pdn)) { /* Neither of 32s|64-bit exist! */
 		dev_warn(&pdev->dev, "No dma-windows exist for the node %pOF\n", pdn);
 		goto out_failed;
 	}
@@ -2350,7 +2350,7 @@ static long spapr_tce_take_ownership(struct iommu_table_group *table_group, stru
 	mutex_lock(&dma_win_init_mutex);
 
 	pdn = pci_dma_find(dn, NULL);
-	if (!pdn || !PCI_DN(pdn)) { /* Niether of 32s|64-bit exist! */
+	if (!pdn || !PCI_DN(pdn)) { /* Neither of 32s|64-bit exist! */
 		dev_warn(&pdev->dev, "No dma-windows exist for the node %pOF\n", pdn);
 		mutex_unlock(&dma_win_init_mutex);
 		return -1;
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 6a415febc53b..f92b224a96da 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -1157,7 +1157,7 @@ static void hugepage_block_invalidate(unsigned long *slot, unsigned long *vpn,
 	for (i = 0; i < count; i++) {
 		/*
 		 * Shifting 3 bits more on the right to get a
-		 * 8 pages aligned virtual addresse.
+		 * 8 pages aligned virtual address.
 		 */
 		vpgb = (vpn[i] >> (shift - VPN_SHIFT + 3));
 		if (!pix || vpgb != current_vpgb) {
@@ -1365,7 +1365,7 @@ static void do_block_remove(unsigned long number, struct ppc64_tlb_batch *batch,
 		pte_iterate_hashed_subpages(pte, psize, vpn, index, shift) {
 			/*
 			 * Shifting 3 bits more on the right to get a
-			 * 8 pages aligned virtual addresse.
+			 * 8 pages aligned virtual address.
 			 */
 			vpgb = (vpn >> (shift - VPN_SHIFT + 3));
 			if (!pix || vpgb != current_vpgb) {
diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
index 8285b9a29fbf..121f6cdd9733 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -315,7 +315,7 @@ static int msi_quota_for_device(struct pci_dev *dev, int request)
 	 * use the remainder as spare MSIs for anyone that wants them. */
 	counts.spare += total % counts.num_devices;
 
-	/* Divide any spare by the number of over-quota requestors */
+	/* Divide any spare by the number of over-quota requesters */
 	if (counts.over_quota)
 		counts.quota += counts.spare / counts.over_quota;
 
diff --git a/arch/powerpc/platforms/pseries/papr-indices.c b/arch/powerpc/platforms/pseries/papr-indices.c
index 3c7545591c45..7f97697409f9 100644
--- a/arch/powerpc/platforms/pseries/papr-indices.c
+++ b/arch/powerpc/platforms/pseries/papr-indices.c
@@ -191,7 +191,7 @@ static const char *indices_sequence_fill_work_area(struct papr_rtas_sequence *se
 /*
  * papr_indices_handle_read - returns indices blob data to the user space
  *
- * ibm,get-indices RTAS call fills the work area with the certian
+ * ibm,get-indices RTAS call fills the work area with the certain
  * format but does not return the bytes written in the buffer and
  * copied RTAS_GET_INDICES_BUF_SIZE data to the blob for each RTAS
  * call. So send RTAS_GET_INDICES_BUF_SIZE buffer to the user space
diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index 63eca4ebb5e5..82fa3afc6a2c 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -44,7 +44,7 @@ struct papr_scm_perf_stats {
 	__be32 stats_version;
 	/* Number of stats following */
 	__be32 num_statistics;
-	/* zero or more performance matrics */
+	/* zero or more performance metrics */
 	struct papr_scm_perf_stat scm_statistic[];
 } __packed;
 
diff --git a/arch/powerpc/platforms/pseries/rtas-work-area.c b/arch/powerpc/platforms/pseries/rtas-work-area.c
index 7fe34bee84d8..b6336746db96 100644
--- a/arch/powerpc/platforms/pseries/rtas-work-area.c
+++ b/arch/powerpc/platforms/pseries/rtas-work-area.c
@@ -127,7 +127,7 @@ void __ref rtas_work_area_free(struct rtas_work_area *area)
  * Initialization of the work area allocator happens in two parts. To
  * reliably reserve an arena that satisfies RTAS addressing
  * requirements, we must perform a memblock allocation early,
- * immmediately after RTAS instantiation. Then we have to wait until
+ * immediately after RTAS instantiation. Then we have to wait until
  * the slab allocator is up before setting up the descriptor mempool
  * and adding the arena to a gen_pool.
  */
diff --git a/arch/powerpc/platforms/pseries/suspend.c b/arch/powerpc/platforms/pseries/suspend.c
index c51db63d3e88..cc0b452209ae 100644
--- a/arch/powerpc/platforms/pseries/suspend.c
+++ b/arch/powerpc/platforms/pseries/suspend.c
@@ -106,7 +106,7 @@ static ssize_t store_hibernate(struct device *dev,
 #define KERN_DT_UPDATE	1
 
 /**
- * show_hibernate - Report device tree update responsibilty
+ * show_hibernate - Report device tree update responsibility
  * @dev:		subsys root device
  * @attr:		device attribute struct
  * @buf:		buffer
diff --git a/arch/powerpc/platforms/pseries/vas-sysfs.c b/arch/powerpc/platforms/pseries/vas-sysfs.c
index 4f6fbbb672ae..7fce87c3c21b 100644
--- a/arch/powerpc/platforms/pseries/vas-sysfs.c
+++ b/arch/powerpc/platforms/pseries/vas-sysfs.c
@@ -45,7 +45,7 @@ static ssize_t update_total_credits_store(struct vas_cop_feat_caps *caps,
 	 * QoS capabilities from the hypervisor.
 	 */
 	if (!err)
-		err = vas_reconfig_capabilties(caps->win_type, creds);
+		err = vas_reconfig_capabilities(caps->win_type, creds);
 
 	if (err)
 		return -EINVAL;
diff --git a/arch/powerpc/platforms/pseries/vas.c b/arch/powerpc/platforms/pseries/vas.c
index fa05f04364fe..d2e8f39f3351 100644
--- a/arch/powerpc/platforms/pseries/vas.c
+++ b/arch/powerpc/platforms/pseries/vas.c
@@ -848,7 +848,7 @@ static int reconfig_close_windows(struct vas_caps *vcap, int excess_creds,
  * changes. Reconfig window configurations based on the credits
  * availability from this new capabilities.
  */
-int vas_reconfig_capabilties(u8 type, int new_nr_creds)
+int vas_reconfig_capabilities(u8 type, int new_nr_creds)
 {
 	struct vas_cop_feat_caps *caps;
 	int old_nr_creds;
@@ -915,7 +915,7 @@ int pseries_vas_dlpar_cpu(void)
 				      (u64)virt_to_phys(&hv_cop_caps));
 	if (!rc) {
 		new_nr_creds = be16_to_cpu(hv_cop_caps.target_lpar_creds);
-		rc = vas_reconfig_capabilties(VAS_GZIP_DEF_FEAT_TYPE, new_nr_creds);
+		rc = vas_reconfig_capabilities(VAS_GZIP_DEF_FEAT_TYPE, new_nr_creds);
 	}
 
 	if (rc)
diff --git a/arch/powerpc/platforms/pseries/vas.h b/arch/powerpc/platforms/pseries/vas.h
index 45567cd13178..c59f1080e9e9 100644
--- a/arch/powerpc/platforms/pseries/vas.h
+++ b/arch/powerpc/platforms/pseries/vas.h
@@ -138,7 +138,7 @@ struct pseries_vas_window {
 };
 
 int sysfs_add_vas_caps(struct vas_cop_feat_caps *caps);
-int vas_reconfig_capabilties(u8 type, int new_nr_creds);
+int vas_reconfig_capabilities(u8 type, int new_nr_creds);
 int __init sysfs_pseries_vas_init(struct vas_all_caps *vas_caps);
 
 #ifdef CONFIG_PPC_VAS
diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 600f83cea1cd..dc8f1b37bf24 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -597,7 +597,7 @@ static int fsl_add_bridge(struct platform_device *pdev, int is_primary)
 	/* check PCI express link status */
 	if (early_find_capability(hose, 0, 0, PCI_CAP_ID_EXP)) {
 		hose->indirect_type |= PPC_INDIRECT_TYPE_EXT_REG |
-			PPC_INDIRECT_TYPE_SURPRESS_PRIMARY_BUS;
+			PPC_INDIRECT_TYPE_SUPPRESS_PRIMARY_BUS;
 		if (fsl_pcie_check_link(hose))
 			hose->indirect_type |= PPC_INDIRECT_TYPE_NO_PCIE_LINK;
 		/* Fix Class Code to PCI_CLASS_BRIDGE_PCI_NORMAL for pre-3.0 controller */
@@ -747,7 +747,7 @@ static int mpc83xx_pcie_write_config(struct pci_bus *bus, unsigned int devfn,
 {
 	struct pci_controller *hose = pci_bus_to_host(bus);
 
-	/* PPC_INDIRECT_TYPE_SURPRESS_PRIMARY_BUS */
+	/* PPC_INDIRECT_TYPE_SUPPRESS_PRIMARY_BUS */
 	if (offset == PCI_PRIMARY_BUS && bus->number == hose->first_busno)
 		val &= 0xffffff00;
 
diff --git a/arch/powerpc/sysdev/indirect_pci.c b/arch/powerpc/sysdev/indirect_pci.c
index 1aacb403a010..41b63e0171c6 100644
--- a/arch/powerpc/sysdev/indirect_pci.c
+++ b/arch/powerpc/sysdev/indirect_pci.c
@@ -120,7 +120,7 @@ int indirect_write_config(struct pci_bus *bus, unsigned int devfn,
 			 (devfn << 8) | reg | cfg_type));
 
 	/* suppress setting of PCI_PRIMARY_BUS */
-	if (hose->indirect_type & PPC_INDIRECT_TYPE_SURPRESS_PRIMARY_BUS)
+	if (hose->indirect_type & PPC_INDIRECT_TYPE_SUPPRESS_PRIMARY_BUS)
 		if ((offset == PCI_PRIMARY_BUS) &&
 			(bus->number == hose->first_busno))
 		val &= 0xffffff00;
diff --git a/arch/powerpc/sysdev/xics/icp-native.c b/arch/powerpc/sysdev/xics/icp-native.c
index 4e89158a577c..915024dffaf0 100644
--- a/arch/powerpc/sysdev/xics/icp-native.c
+++ b/arch/powerpc/sysdev/xics/icp-native.c
@@ -243,7 +243,7 @@ static int __init icp_native_init_one_node(struct device_node *np,
 	int num_reg;
 	int num_servers = 0;
 
-	/* This code does the theorically broken assumption that the interrupt
+	/* This code does the theoretically broken assumption that the interrupt
 	 * server numbers are the same as the hard CPU numbers.
 	 * This happens to be the case so far but we are playing with fire...
 	 * should be fixed one of these days. -BenH.
diff --git a/arch/powerpc/sysdev/xics/xics-common.c b/arch/powerpc/sysdev/xics/xics-common.c
index c3fa539a9898..e8dd461ea08b 100644
--- a/arch/powerpc/sysdev/xics/xics-common.c
+++ b/arch/powerpc/sysdev/xics/xics-common.c
@@ -67,7 +67,7 @@ void xics_update_irq_servers(void)
 
 	/* Global interrupt distribution server is specified in the last
 	 * entry of "ibm,ppc-interrupt-gserver#s" property. Get the last
-	 * entry fom this property for current boot cpu id and use it as
+	 * entry from this property for current boot cpu id and use it as
 	 * default distribution server
 	 */
 	for (j = 0; j < i; j += 2) {
diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index c120be73d149..5a7688152933 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -144,7 +144,7 @@ static u32 xive_read_eq(struct xive_q *q, bool just_peek)
  * Note2: This will also "flush" "the pending_count" of a queue
  * into the "count" when that queue is observed to be empty.
  * This is used to keep track of the amount of interrupts
- * targetting a queue. When an interrupt is moved away from
+ * targeting a queue. When an interrupt is moved away from
  * a queue, we only decrement that queue count once the queue
  * has been observed empty to avoid races.
  */
@@ -521,7 +521,7 @@ static bool xive_try_pick_target(int cpu)
  * in the queue.
  *
  * Instead increment a separate counter "pending_count" which
- * will be substracted from "count" later when that CPU observes
+ * will be subtracted from "count" later when that CPU observes
  * the queue to be empty.
  */
 static void xive_dec_target_count(int cpu)
@@ -840,7 +840,7 @@ static int xive_irq_set_vcpu_affinity(struct irq_data *d, void *state)
 		/* No target ? nothing to do */
 		if (xd->target == XIVE_INVALID_TARGET) {
 			/*
-			 * An untargetted interrupt should have been
+			 * An untargeted interrupt should have been
 			 * also masked at the source
 			 */
 			WARN_ON(xd->saved_p);
diff --git a/arch/powerpc/tools/unrel_branch_check.sh b/arch/powerpc/tools/unrel_branch_check.sh
index 8301efee1e6c..13dcdc0c49b6 100755
--- a/arch/powerpc/tools/unrel_branch_check.sh
+++ b/arch/powerpc/tools/unrel_branch_check.sh
@@ -59,7 +59,7 @@ while IFS=: read -r from branch to sym; do
 		fi
 		printf -v to '0x%x' $(( "0x$from" + to ))
 		;;
-	*)	printf 'Unkown branch format\n'
+	*)	printf 'Unknown branch format\n'
 		;;
 	esac
 	if [ "$to" = "$sim" ]; then
diff --git a/arch/powerpc/xmon/ppc-opc.c b/arch/powerpc/xmon/ppc-opc.c
index de9b4236728c..f5c43a7b1e00 100644
--- a/arch/powerpc/xmon/ppc-opc.c
+++ b/arch/powerpc/xmon/ppc-opc.c
@@ -327,7 +327,7 @@ const struct powerpc_operand powerpc_operands[] =
     PPC_OPERAND_PARENS | PPC_OPERAND_SIGNED | PPC_OPERAND_DS },
 
   /* The DUIS or BHRBE fields in a XFX form instruction, 10 bits
-     unsigned imediate */
+     unsigned immediate */
 #define DUIS DS + 1
 #define BHRBE DUIS
   { 0x3ff, 11, NULL, NULL, 0 },
@@ -697,7 +697,7 @@ const struct powerpc_operand powerpc_operands[] =
 #define TBR SV + 1
   { 0x3ff, 11, insert_tbr, extract_tbr,
     PPC_OPERAND_OPTIONAL | PPC_OPERAND_OPTIONAL_VALUE},
-  /* If the TBR operand is ommitted, use the value 268.  */
+  /* If the TBR operand is omitted, use the value 268.  */
   { -1, 268, NULL, NULL, 0},
 
   /* The TO field in a D or X form instruction.  */
@@ -837,7 +837,7 @@ const struct powerpc_operand powerpc_operands[] =
   /* The S field in a XL form instruction.  */
 #define SXL S + 1
   { 0x1, 11, NULL, NULL, PPC_OPERAND_OPTIONAL | PPC_OPERAND_OPTIONAL_VALUE},
-  /* If the SXL operand is ommitted, use the value 1.  */
+  /* If the SXL operand is omitted, use the value 1.  */
   { -1, 1, NULL, NULL, 0},
 
   /* SH field starting at bit position 16.  */
diff --git a/arch/powerpc/xmon/ppc.h b/arch/powerpc/xmon/ppc.h
index 1d98b8dd134e..b107d56df668 100644
--- a/arch/powerpc/xmon/ppc.h
+++ b/arch/powerpc/xmon/ppc.h
@@ -402,7 +402,7 @@ extern const unsigned int num_powerpc_operands;
 
 /* This flag is only used with PPC_OPERAND_OPTIONAL.  If this operand
    is omitted, then the value it should use for the operand is stored
-   in the SHIFT field of the immediatly following operand field.  */
+   in the SHIFT field of the immediately following operand field.  */
 #define PPC_OPERAND_OPTIONAL_VALUE (0x400000)
 
 /* This flag is only used with PPC_OPERAND_OPTIONAL.  The operand is
diff --git a/lib/crypto/powerpc/ghashp8-ppc.pl b/lib/crypto/powerpc/ghashp8-ppc.pl
index 7c38eedc02cc..9847ae10d715 100644
--- a/lib/crypto/powerpc/ghashp8-ppc.pl
+++ b/lib/crypto/powerpc/ghashp8-ppc.pl
@@ -25,7 +25,7 @@
 # Relative comparison is therefore more informative. This initial
 # version is ~2.1x slower than hardware-assisted AES-128-CTR, ~12x
 # faster than "4-bit" integer-only compiler-generated 64-bit code.
-# "Initial version" means that there is room for futher improvement.
+# "Initial version" means that there is room for further improvement.
 
 $flavour=shift;
 $output =shift;
-- 
2.54.0

