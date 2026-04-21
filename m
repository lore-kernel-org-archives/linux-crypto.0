Received: from luna.linkmauve.fr (82-65-109-163.subs.proxad.net [82.65.109.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0AA363093;
	Tue, 21 Apr 2026 12:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.65.109.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776773682; cv=none; b=gMnu+daVJYaNtRUtLL/12L+WxVmIk/FigDzFjwmdu0k0YI9psnf4e9NspaffKT+cBsilCfNwU/X9yoMunrfcvOtLGPJc7fQ8iOCXrmnAebDowpwb7yX0No33vslZKZkIpvuVRHVLm62EtSo4MV/tp+RhbNPcHoAdn+Zb9Hd3m5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776773682; c=relaxed/simple;
	bh=o0pBiccSHaroojxfsDhXFaZzKgxpgndpVvvBsX4NVwI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TxUCEs98GvGo++eflHCWb+TjXKPCXvF1cp4gMZjoE4BBIOw9MklMupa0hTFWlD9DEEilIEKjYvLlcgqXwpiGEWCrmDQISPfgDs75DxzMygeYSJU/zqrdKKXcGsbZmGYcFHunk4VX51N5LoVwbw9sbSBrdER5ACha81ioBXvVZTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linkmauve.fr; spf=pass smtp.mailfrom=linkmauve.fr; arc=none smtp.client-ip=82.65.109.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linkmauve.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linkmauve.fr
Received: by luna.linkmauve.fr (Postfix, from userid 1000)
	id 73E83F40843; Tue, 21 Apr 2026 14:14:36 +0200 (CEST)
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
Subject: [PATCH 0/2] powerpc: Fix a whole bunch of spelling mistakes
Date: Tue, 21 Apr 2026 14:14:12 +0200
Message-ID: <20260421121420.26079-1-linkmauve@linkmauve.fr>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

I’ve done this using the typos tool[1].  It is a one-off as I don’t
expect typos to accumulate too much, but maybe we could setup a periodic
run of this tool?  Future versions will likely catch more mistakes for
instance.

I’ve manually reviewed every single one of these changes, but mistakes
can obviously happen with these automated tools so it might be sensible
to review them thoroughly anyway.

I’ve also tested that this kernel builds and boots on a Wii.

[1] https://github.com/crate-ci/typos

Link Mauve (2):
  powerpc: Add a typos.toml file
  powerpc: Run typos -w

 arch/powerpc/boot/crt0.S                      |   2 +-
 arch/powerpc/boot/dts/fsl/ppa8548.dts         |   2 +-
 arch/powerpc/boot/dts/kuroboxHD.dts           |   2 +-
 arch/powerpc/boot/dts/kuroboxHG.dts           |   2 +-
 arch/powerpc/boot/dts/mgcoge.dts              |   2 +-
 arch/powerpc/boot/dts/mpc8308_p1m.dts         |   4 +-
 arch/powerpc/boot/rs6000.h                    |   4 +-
 arch/powerpc/crypto/aes-gcm-p10.S             |   6 +-
 arch/powerpc/crypto/aes-spe-glue.c            |   2 +-
 arch/powerpc/crypto/aesp10-ppc.pl             |   2 +-
 arch/powerpc/crypto/ghashp10-ppc.pl           |   2 +-
 arch/powerpc/include/asm/book3s/64/hash-64k.h |   6 +-
 arch/powerpc/include/asm/book3s/64/mmu-hash.h |  12 +-
 arch/powerpc/include/asm/book3s/64/radix.h    |   2 +-
 arch/powerpc/include/asm/cpm1.h               |   2 +-
 arch/powerpc/include/asm/cpm2.h               |   2 +-
 arch/powerpc/include/asm/cputable.h           |   2 +-
 arch/powerpc/include/asm/delay.h              |   2 +-
 arch/powerpc/include/asm/epapr_hcalls.h       |   2 +-
 arch/powerpc/include/asm/fsl_hcalls.h         |   4 +-
 arch/powerpc/include/asm/head-64.h            |   4 +-
 arch/powerpc/include/asm/heathrow.h           |   2 +-
 arch/powerpc/include/asm/highmem.h            |   2 +-
 arch/powerpc/include/asm/io.h                 |   4 +-
 arch/powerpc/include/asm/kvm_booke.h          |   2 +-
 arch/powerpc/include/asm/machdep.h            |   2 +-
 arch/powerpc/include/asm/mediabay.h           |   2 +-
 arch/powerpc/include/asm/mpic.h               |   2 +-
 arch/powerpc/include/asm/mpic_msgr.h          |   2 +-
 arch/powerpc/include/asm/nohash/32/mmu-8xx.h  |   2 +-
 arch/powerpc/include/asm/nohash/32/pte-8xx.h  |   2 +-
 arch/powerpc/include/asm/nohash/mmu-e500.h    |   2 +-
 arch/powerpc/include/asm/page_64.h            |   2 +-
 arch/powerpc/include/asm/paravirt.h           |   2 +-
 arch/powerpc/include/asm/pci-bridge.h         |   4 +-
 arch/powerpc/include/asm/pmac_feature.h       |   4 +-
 arch/powerpc/include/asm/ppc_asm.h            |   2 +-
 arch/powerpc/include/asm/prom.h               |   4 +-
 arch/powerpc/include/asm/ps3.h                |   2 +-
 arch/powerpc/include/asm/ps3av.h              |   2 +-
 arch/powerpc/include/asm/reg.h                |   2 +-
 arch/powerpc/include/asm/reg_booke.h          |   2 +-
 arch/powerpc/include/asm/reg_fsl_emb.h        |   2 +-
 arch/powerpc/include/asm/sfp-machine.h        |   4 +-
 arch/powerpc/include/asm/smu.h                |  12 +-
 arch/powerpc/include/asm/tce.h                |   2 +-
 arch/powerpc/include/asm/thread_info.h        |   2 +-
 arch/powerpc/include/asm/tsi108_irq.h         |   2 +-
 arch/powerpc/include/asm/uninorth.h           |   4 +-
 arch/powerpc/include/uapi/asm/bootx.h         |   2 +-
 arch/powerpc/include/uapi/asm/sigcontext.h    |   2 +-
 arch/powerpc/kernel/85xx_entry_mapping.S      |   2 +-
 arch/powerpc/kernel/cputable.c                |   2 +-
 arch/powerpc/kernel/eeh.c                     |   4 +-
 arch/powerpc/kernel/eeh_driver.c              |   8 +-
 arch/powerpc/kernel/eeh_event.c               |   2 +-
 arch/powerpc/kernel/eeh_pe.c                  |   2 +-
 arch/powerpc/kernel/entry_32.S                |   2 +-
 arch/powerpc/kernel/exceptions-64e.S          |   4 +-
 arch/powerpc/kernel/exceptions-64s.S          |   6 +-
 arch/powerpc/kernel/fadump.c                  |   8 +-
 arch/powerpc/kernel/head_44x.S                |  14 +--
 arch/powerpc/kernel/head_85xx.S               |   6 +-
 arch/powerpc/kernel/head_book3s_32.S          |   2 +-
 arch/powerpc/kernel/hw_breakpoint.c           |   2 +-
 arch/powerpc/kernel/idle_book3s.S             |   4 +-
 arch/powerpc/kernel/interrupt.c               |   2 +-
 arch/powerpc/kernel/irq_64.c                  |   2 +-
 arch/powerpc/kernel/legacy_serial.c           |   2 +-
 arch/powerpc/kernel/nvram_64.c                |   2 +-
 arch/powerpc/kernel/paca.c                    |   2 +-
 arch/powerpc/kernel/pci_dn.c                  |   2 +-
 arch/powerpc/kernel/prom.c                    |   4 +-
 arch/powerpc/kernel/prom_init_check.sh        |   2 +-
 arch/powerpc/kernel/ptrace/ptrace-adv.c       |   2 +-
 arch/powerpc/kernel/ptrace/ptrace-decl.h      |   2 +-
 arch/powerpc/kernel/ptrace/ptrace-tm.c        |  10 +-
 arch/powerpc/kernel/setup_64.c                |   4 +-
 arch/powerpc/kernel/signal_32.c               |   2 +-
 arch/powerpc/kernel/signal_64.c               |   2 +-
 arch/powerpc/kernel/smp.c                     |   2 +-
 arch/powerpc/kernel/switch.S                  |   2 +-
 arch/powerpc/kernel/time.c                    |   2 +-
 arch/powerpc/kernel/traps.c                   |   4 +-
 arch/powerpc/kernel/watchdog.c                |   2 +-
 arch/powerpc/kexec/core_64.c                  |   2 +-
 arch/powerpc/kexec/file_load_64.c             |   4 +-
 arch/powerpc/kvm/book3s_hv.c                  |   6 +-
 arch/powerpc/kvm/book3s_hv_p9_entry.c         |   2 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c            |   4 +-
 arch/powerpc/kvm/book3s_pr.c                  |   2 +-
 arch/powerpc/kvm/book3s_xive.c                |  42 +++----
 arch/powerpc/kvm/book3s_xive.h                |   4 +-
 arch/powerpc/kvm/booke.h                      |   2 +-
 arch/powerpc/kvm/bookehv_interrupts.S         |   4 +-
 arch/powerpc/kvm/e500_mmu.c                   |   2 +-
 arch/powerpc/kvm/e500mc.c                     |   2 +-
 arch/powerpc/kvm/powerpc.c                    |   2 +-
 arch/powerpc/lib/copyuser_power7.S            |   4 +-
 arch/powerpc/lib/memcmp_64.S                  |   2 +-
 arch/powerpc/lib/memcpy_power7.S              |   4 +-
 arch/powerpc/lib/rheap.c                      |   4 +-
 arch/powerpc/mm/book3s64/hash_native.c        |   6 +-
 arch/powerpc/mm/book3s64/hash_pgtable.c       |   2 +-
 arch/powerpc/mm/book3s64/hash_tlb.c           |   2 +-
 arch/powerpc/mm/book3s64/hash_utils.c         |   8 +-
 arch/powerpc/mm/book3s64/hugetlbpage.c        |   2 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c      |   2 +-
 arch/powerpc/mm/book3s64/radix_tlb.c          |  10 +-
 arch/powerpc/mm/book3s64/slb.c                |   2 +-
 arch/powerpc/mm/ioremap.c                     |   2 +-
 arch/powerpc/mm/mem.c                         |   2 +-
 arch/powerpc/mm/nohash/kaslr_booke.c          |   2 +-
 arch/powerpc/mm/nohash/tlb.c                  |   2 +-
 arch/powerpc/mm/nohash/tlb_low_64e.S          |   4 +-
 arch/powerpc/perf/hv-24x7.c                   |   2 +-
 arch/powerpc/perf/hv-gpci-requests.h          |   2 +-
 arch/powerpc/perf/hv-gpci.c                   |   2 +-
 arch/powerpc/perf/imc-pmu.c                   |   4 +-
 arch/powerpc/perf/isa207-common.h             |   4 +-
 arch/powerpc/perf/vpa-dtl.c                   |   4 +-
 arch/powerpc/platforms/44x/uic.c              |   2 +-
 arch/powerpc/platforms/512x/clock-commonclk.c |   2 +-
 arch/powerpc/platforms/512x/mpc512x_shared.c  |   2 +-
 arch/powerpc/platforms/52xx/lite5200_pm.c     |   2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pci.c     |   4 +-
 arch/powerpc/platforms/8xx/pic.c              |   4 +-
 arch/powerpc/platforms/book3s/vas-api.c       |   4 +-
 arch/powerpc/platforms/cell/spufs/context.c   |   4 +-
 .../platforms/cell/spufs/spu_restore_crt0.S   |   2 +-
 arch/powerpc/platforms/cell/spufs/switch.c    |   8 +-
 arch/powerpc/platforms/powermac/bootx_init.c  |   2 +-
 arch/powerpc/platforms/powermac/cache.S       |   2 +-
 arch/powerpc/platforms/powermac/feature.c     |   2 +-
 arch/powerpc/platforms/powermac/low_i2c.c     |   2 +-
 arch/powerpc/platforms/powermac/pci.c         |   2 +-
 arch/powerpc/platforms/powermac/pfunc_base.c  |   2 +-
 arch/powerpc/platforms/powermac/setup.c       |   2 +-
 arch/powerpc/platforms/powermac/sleep.S       |   2 +-
 arch/powerpc/platforms/powernv/eeh-powernv.c  |   2 +-
 arch/powerpc/platforms/powernv/opal-lpc.c     |   2 +-
 .../platforms/powernv/opal-memory-errors.c    |   2 +-
 arch/powerpc/platforms/powernv/opal.c         |   6 +-
 arch/powerpc/platforms/powernv/pci-ioda.c     |   2 +-
 arch/powerpc/platforms/powernv/pci-sriov.c    |   2 +-
 arch/powerpc/platforms/powernv/vas-fault.c    |   2 +-
 arch/powerpc/platforms/powernv/vas.h          |   4 +-
 arch/powerpc/platforms/ps3/interrupt.c        |   4 +-
 arch/powerpc/platforms/ps3/platform.h         |   4 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c  |   2 +-
 arch/powerpc/platforms/pseries/iommu.c        |   8 +-
 arch/powerpc/platforms/pseries/lpar.c         |   4 +-
 arch/powerpc/platforms/pseries/msi.c          |   2 +-
 arch/powerpc/platforms/pseries/papr-indices.c |   2 +-
 arch/powerpc/platforms/pseries/papr_scm.c     |   2 +-
 .../platforms/pseries/rtas-work-area.c        |   2 +-
 arch/powerpc/platforms/pseries/suspend.c      |   2 +-
 arch/powerpc/platforms/pseries/vas-sysfs.c    |   2 +-
 arch/powerpc/platforms/pseries/vas.c          |   4 +-
 arch/powerpc/platforms/pseries/vas.h          |   2 +-
 arch/powerpc/sysdev/fsl_pci.c                 |   4 +-
 arch/powerpc/sysdev/indirect_pci.c            |   2 +-
 arch/powerpc/sysdev/xics/icp-native.c         |   2 +-
 arch/powerpc/sysdev/xics/xics-common.c        |   2 +-
 arch/powerpc/sysdev/xive/common.c             |   6 +-
 arch/powerpc/tools/unrel_branch_check.sh      |   2 +-
 arch/powerpc/typos.toml                       | 109 ++++++++++++++++++
 arch/powerpc/xmon/ppc-opc.c                   |   6 +-
 arch/powerpc/xmon/ppc.h                       |   2 +-
 lib/crypto/powerpc/ghashp8-ppc.pl             |   2 +-
 170 files changed, 392 insertions(+), 283 deletions(-)
 create mode 100644 arch/powerpc/typos.toml

-- 
2.54.0

