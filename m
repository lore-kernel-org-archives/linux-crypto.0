Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793019817;
	b=keSWSTFTyL9/cxMzX77zpy7TkgIRWRKadK4DM7+Fe3TNc6YeTE/drrWEpDkOajNak5sM
	 h5zonu/l7q8YrXPSeflURj0Ll0R//CgWh8Ejq5LgZ0v2CYk3x+qYx41f1yr5Afke1Lx0b
	 fV8WdbCHGw3Ky97tzJ2xGZmcqTXPj9wWCQN1i/cWrKgSknPf7Tqz9mbtGhNuS8ZHRj/aw
	 E9kspT2s/bexme1mq6VBLaf84wcS8uc6ghAqegwlUj9GIUwxh8cjWCoMqAYJa2QFfGhU1
	 adxgsQQ3Tfk2ZhWCANsIwfDhHOVXqKRmYVe71Fd7C/iLpbYH1+5keRYwd/PkLYG7Ofw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793019817;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Rspamd-Pre-Result:X-Rspamd-Queue-Id:
	 X-Rspamd-Pre-Result:X-Rspamd-Action:X-Rspamd-Server:X-Spam-Level:
	 X-Spamd-Result:X-Spam-Flag:X-Spam-Score;
	bh=gFB3eg5fDCFlNUWglviNSDlpa44d691MBWtuZI9x1Dg=;
	b=p/nYtFLDFhB6fbTpb4u7R24mzAmBuG5zWwEI1w0df1xAvctrwQanFVQ2ZRWb9iQKjhwp
	 ekp0zfrAHKXhbhUynxQUOjnOMVDWJr/lQx2KDeMWxzZJKYWdFo3YfOQQvM6czkrfLPQrC
	 RMYVbvSlhxJk39Prv1D4f2q7NiCRoKpWK18pDiOrPD71RdTVBRR2uBnn/kEqtOOBkapjG
	 oXFhRij8yPchgfswLvEjLTEDN/j9DEl4QAFDBfAjf0mlPRMSSE2r3zpV7kwTEIfdjqFaA
	 G/Xm20sIupRLF+Q77asXugCpEm6q/WvR9tewR36Ipa+h0YpVMkN/ylr7gyT8ot7LVSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990D8606A322;
	Mon, 26 Oct 2026 13:03:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 990D8606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2536A222CD;
	Mon, 26 Oct 2026 13:03:33 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 97E0E13408;
	Mon, 26 Oct 2026 13:03:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Hlb2G6JP32pnWwAAD6G6ig
	(envelope-from <jgross@suse.com>); Mon, 26 Oct 2026 13:03:30 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-edac@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-crypto@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	platform-driver-x86@vger.kernel.org,
	linux-fbdev@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Pu Wen <puwen@hygon.cn>,
	Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Len Brown <lenb@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	David Airlie <airlied@redhat.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Huang Rui <ray.huang@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Perry Yuan <perry.yuan@amd.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Ashok Raj <ashok.raj.linux@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
	Xi Pardee <xi.pardee@linux.intel.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Helge Deller <deller@gmx.de>,
	xen-devel@lists.xenproject.org,
	linux-geode@lists.infradead.org,
	Michael Kelley <mhklinux@outlook.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Subject: [PATCH v5 11/12] treewide: convert rdmsrq() from a macro to an inline function
Date: Mon, 26 Oct 2026 14:02:22 +0100
Message-ID: <20261026130223.773129-12-jgross@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026130223.773129-1-jgross@suse.com>
References: <20261026130223.773129-1-jgross@suse.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 2536A222CD
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00

Today rdmsrq() is a macro using its second parameter as the target for
storing the read MSR value.

Convert rdmsrq() to an inline function returning the MSR value.

The users have been converted using the following semantic patch:

  // Options: --include-headers

  virtual patch
  virtual report

  @@
  expression msr, val;
  @@
  (
  - rdmsrq(msr,val)
  + val = rdmsrq(msr)
  )

Signed-off-by: Juergen Gross <jgross@suse.com>
Acked-by: Damien Le Moal <dlemoal@kernel.org>             # ATA
Reviewed-by: Michael Kelley <mhklinux@outlook.com>        # Hyper-V
Acked-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>   # ACPI, cpufreq, powercap, thermal
Acked-by: Sean Christopherson <seanjc@google.com>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>     # resctrl
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com> # cpufreq
Acked-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>   # pdx86
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>     # amd-pstate
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>        # mce, amd64_edac
---
 arch/x86/coco/sev/core.c                      |  2 +-
 arch/x86/events/amd/brs.c                     |  4 +--
 arch/x86/events/amd/core.c                    |  4 +--
 arch/x86/events/amd/ibs.c                     | 18 +++++-----
 arch/x86/events/amd/lbr.c                     |  8 ++---
 arch/x86/events/amd/power.c                   |  8 ++---
 arch/x86/events/amd/uncore.c                  |  4 +--
 arch/x86/events/core.c                        | 20 +++++------
 arch/x86/events/intel/core.c                  | 11 +++---
 arch/x86/events/intel/cstate.c                |  2 +-
 arch/x86/events/intel/ds.c                    |  2 +-
 arch/x86/events/intel/knc.c                   |  6 ++--
 arch/x86/events/intel/lbr.c                   | 14 ++++----
 arch/x86/events/intel/p4.c                    |  6 ++--
 arch/x86/events/intel/p6.c                    |  4 +--
 arch/x86/events/intel/pt.c                    | 12 +++----
 arch/x86/events/intel/uncore.c                |  2 +-
 arch/x86/events/intel/uncore_nhmex.c          |  4 +--
 arch/x86/events/intel/uncore_snb.c            |  2 +-
 arch/x86/events/intel/uncore_snbep.c          |  6 ++--
 arch/x86/events/msr.c                         |  2 +-
 arch/x86/events/perf_event.h                  |  6 ++--
 arch/x86/events/rapl.c                        |  4 +--
 arch/x86/events/zhaoxin/core.c                |  6 ++--
 arch/x86/hyperv/hv_apic.c                     |  6 ++--
 arch/x86/hyperv/hv_init.c                     | 26 +++++++-------
 arch/x86/hyperv/hv_spinlock.c                 |  2 +-
 arch/x86/include/asm/apic.h                   |  4 +--
 arch/x86/include/asm/debugreg.h               |  2 +-
 arch/x86/include/asm/fsgsbase.h               |  2 +-
 arch/x86/include/asm/kvm_host.h               |  2 +-
 arch/x86/include/asm/msr.h                    | 15 ++++----
 arch/x86/include/asm/paravirt.h               |  8 ++---
 arch/x86/kernel/apic/apic.c                   | 14 ++++----
 arch/x86/kernel/apic/apic_numachip.c          |  6 ++--
 arch/x86/kernel/cet.c                         |  2 +-
 arch/x86/kernel/cpu/amd.c                     | 14 ++++----
 arch/x86/kernel/cpu/aperfmperf.c              |  8 ++---
 arch/x86/kernel/cpu/bugs.c                    | 12 +++----
 arch/x86/kernel/cpu/bus_lock.c                |  8 ++---
 arch/x86/kernel/cpu/centaur.c                 |  8 ++---
 arch/x86/kernel/cpu/common.c                  | 12 +++----
 arch/x86/kernel/cpu/feat_ctl.c                |  4 +--
 arch/x86/kernel/cpu/hygon.c                   |  4 +--
 arch/x86/kernel/cpu/intel.c                   |  6 ++--
 arch/x86/kernel/cpu/intel_epb.c               |  4 +--
 arch/x86/kernel/cpu/mce/amd.c                 |  4 +--
 arch/x86/kernel/cpu/mce/core.c                |  8 ++---
 arch/x86/kernel/cpu/mce/inject.c              |  2 +-
 arch/x86/kernel/cpu/mce/intel.c               | 18 +++++-----
 arch/x86/kernel/cpu/mce/p5.c                  |  8 ++---
 arch/x86/kernel/cpu/mce/winchip.c             |  2 +-
 arch/x86/kernel/cpu/microcode/intel.c         |  2 +-
 arch/x86/kernel/cpu/mshyperv.c                |  6 ++--
 arch/x86/kernel/cpu/mtrr/amd.c                |  4 +--
 arch/x86/kernel/cpu/mtrr/cleanup.c            |  4 +--
 arch/x86/kernel/cpu/mtrr/generic.c            | 32 ++++++++---------
 arch/x86/kernel/cpu/mtrr/mtrr.c               |  2 +-
 arch/x86/kernel/cpu/resctrl/core.c            |  2 +-
 arch/x86/kernel/cpu/resctrl/monitor.c         |  4 +--
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c     |  4 +--
 arch/x86/kernel/cpu/resctrl/rdtgroup.c        |  2 +-
 arch/x86/kernel/cpu/topology.c                |  2 +-
 arch/x86/kernel/cpu/topology_amd.c            |  4 +--
 arch/x86/kernel/cpu/transmeta.c               |  2 +-
 arch/x86/kernel/cpu/tsx.c                     | 10 +++---
 arch/x86/kernel/cpu/umwait.c                  |  2 +-
 arch/x86/kernel/cpu/zhaoxin.c                 |  4 +--
 arch/x86/kernel/fpu/core.c                    |  2 +-
 arch/x86/kernel/hpet.c                        |  2 +-
 arch/x86/kernel/kvm.c                         |  2 +-
 arch/x86/kernel/mmconf-fam10h_64.c            |  6 ++--
 arch/x86/kernel/process.c                     |  4 +--
 arch/x86/kernel/process_64.c                  | 14 ++++----
 arch/x86/kernel/shstk.c                       |  8 ++---
 arch/x86/kernel/traps.c                       |  4 +--
 arch/x86/kernel/tsc.c                         |  2 +-
 arch/x86/kernel/tsc_msr.c                     |  6 ++--
 arch/x86/kernel/tsc_sync.c                    |  6 ++--
 arch/x86/kvm/msrs.c                           |  2 +-
 arch/x86/kvm/svm/pmu.c                        |  4 +--
 arch/x86/kvm/svm/svm.c                        |  6 ++--
 arch/x86/kvm/vmx/main.c                       |  2 +-
 arch/x86/kvm/vmx/nested.c                     |  4 +--
 arch/x86/kvm/vmx/pmu_intel.c                  |  8 ++---
 arch/x86/kvm/vmx/sgx.c                        |  6 ++--
 arch/x86/kvm/vmx/vmx.c                        | 34 +++++++++----------
 arch/x86/kvm/x86.c                            |  6 ++--
 arch/x86/lib/insn-eval.c                      |  6 ++--
 arch/x86/lib/msr-smp.c                        |  2 +-
 arch/x86/mm/pat/memtype.c                     |  2 +-
 arch/x86/pci/amd_bus.c                        |  8 ++---
 arch/x86/platform/olpc/olpc-xo1-rtc.c         |  6 ++--
 arch/x86/platform/olpc/olpc-xo1-sci.c         |  2 +-
 arch/x86/power/cpu.c                          | 10 +++---
 arch/x86/realmode/init.c                      |  2 +-
 arch/x86/virt/hw.c                            |  8 ++---
 arch/x86/virt/svm/sev.c                       | 22 ++++++------
 arch/x86/virt/vmx/tdx/tdx.c                   |  2 +-
 arch/x86/xen/suspend.c                        |  2 +-
 drivers/acpi/processor_perflib.c              |  2 +-
 drivers/ata/pata_cs5535.c                     |  4 +--
 drivers/ata/pata_cs5536.c                     |  2 +-
 drivers/char/agp/nvidia-agp.c                 |  6 ++--
 drivers/char/hw_random/via-rng.c              |  4 +--
 drivers/cpufreq/acpi-cpufreq.c                |  8 ++---
 drivers/cpufreq/amd-pstate.c                  |  4 +--
 drivers/cpufreq/e_powersaver.c                | 20 +++++------
 drivers/cpufreq/intel_pstate.c                | 28 +++++++--------
 drivers/cpufreq/longhaul.c                    | 12 +++----
 drivers/cpufreq/longrun.c                     | 16 ++++-----
 drivers/cpufreq/powernow-k7.c                 | 10 +++---
 drivers/cpufreq/powernow-k8.c                 |  8 ++---
 drivers/cpufreq/speedstep-centrino.c          |  4 +--
 drivers/cpufreq/speedstep-lib.c               | 14 ++++----
 drivers/edac/amd64_edac.c                     |  6 ++--
 drivers/edac/intel-bff.c                      |  4 +--
 drivers/gpio/gpio-cs5535.c                    |  2 +-
 drivers/hv/mshv_vtl_main.c                    |  2 +-
 drivers/hwmon/hwmon-vid.c                     |  4 +--
 drivers/idle/intel_idle.c                     | 26 +++++++-------
 drivers/misc/cs5535-mfgpt.c                   |  6 ++--
 drivers/mtd/nand/raw/cs553x_nand.c            |  6 ++--
 drivers/platform/x86/intel/ifs/load.c         | 10 +++---
 drivers/platform/x86/intel/ifs/runtest.c      |  8 ++---
 drivers/platform/x86/intel/pmc/cnp.c          |  2 +-
 .../intel/speed_select_if/isst_if_mbox_msr.c  |  6 ++--
 .../intel/speed_select_if/isst_tpmi_core.c    |  2 +-
 drivers/platform/x86/intel_ips.c              | 20 +++++------
 drivers/powercap/intel_rapl_msr.c             |  2 +-
 drivers/thermal/intel/intel_hfi.c             |  8 ++---
 drivers/thermal/intel/therm_throt.c           | 22 ++++++------
 drivers/thermal/intel/x86_pkg_temp_thermal.c  |  6 ++--
 drivers/video/fbdev/geode/display_gx.c        |  2 +-
 drivers/video/fbdev/geode/gxfb_core.c         |  2 +-
 drivers/video/fbdev/geode/lxfb_ops.c          | 18 +++++-----
 drivers/video/fbdev/geode/suspend_gx.c        |  8 ++---
 drivers/video/fbdev/geode/video_gx.c          |  8 ++---
 include/linux/cs5535.h                        |  2 +-
 139 files changed, 488 insertions(+), 490 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index eb2e853e950a..6a13af13ca59 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -2046,7 +2046,7 @@ void __init snp_secure_tsc_init(void)
 	secrets = (__force struct snp_secrets_page *)mem;
 
 	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
-	rdmsrq(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
+	tsc_freq_mhz = rdmsrq(MSR_AMD64_GUEST_TSC_FREQ);
 
 	/* Extract the GUEST TSC MHZ from BIT[17:0], rest is reserved space */
 	tsc_freq_mhz &= GENMASK_ULL(17, 0);
diff --git a/arch/x86/events/amd/brs.c b/arch/x86/events/amd/brs.c
index 54b13faba116..0cc060c7a9e6 100644
--- a/arch/x86/events/amd/brs.c
+++ b/arch/x86/events/amd/brs.c
@@ -325,7 +325,7 @@ void amd_brs_drain(void)
 		u32 brs_idx = tos - i;
 		u64 from, to;
 
-		rdmsrq(brs_to(brs_idx), to);
+		to = rdmsrq(brs_to(brs_idx));
 
 		/* Entry does not belong to us (as marked by kernel) */
 		if (to == BRS_POISON)
@@ -338,7 +338,7 @@ void amd_brs_drain(void)
 		 */
 		to = (u64)(((s64)to << shift) >> shift);
 
-		rdmsrq(brs_from(brs_idx), from);
+		from = rdmsrq(brs_from(brs_idx));
 
 		if (!amd_brs_match_plm(event, from, to))
 			continue;
diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 49b6b8fce566..80ed49dba255 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -663,7 +663,7 @@ static inline u64 amd_pmu_get_global_status(void)
 	u64 status;
 
 	/* PerfCntrGlobalStatus is read-only */
-	rdmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, status);
+	status = rdmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS);
 
 	return status;
 }
@@ -683,7 +683,7 @@ static bool amd_pmu_test_overflow_topbit(int idx)
 {
 	u64 counter;
 
-	rdmsrq(x86_pmu_event_addr(idx), counter);
+	counter = rdmsrq(x86_pmu_event_addr(idx));
 
 	return !(counter & BIT_ULL(x86_pmu.cntval_bits - 1));
 }
diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 3531f9c23b8c..17eab32164df 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -505,7 +505,7 @@ perf_ibs_event_update(struct perf_ibs *perf_ibs, struct perf_event *event,
 	 * prev count manually on overflow.
 	 */
 	while (!perf_event_try_update(event, count, 64)) {
-		rdmsrq(event->hw.config_base, *config);
+		*config = rdmsrq(event->hw.config_base);
 		count = perf_ibs->get_count(*config);
 	}
 }
@@ -610,7 +610,7 @@ static void perf_ibs_stop(struct perf_event *event, int flags)
 	if (!stopping && (hwc->state & PERF_HES_UPTODATE))
 		return;
 
-	rdmsrq(hwc->config_base, config);
+	config = rdmsrq(hwc->config_base);
 
 	if (stopping) {
 		/*
@@ -1437,7 +1437,7 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	hwc = &event->hw;
 	msr = hwc->config_base;
 	buf = ibs_data.regs;
-	rdmsrq(msr, *buf);
+	*buf = rdmsrq(msr);
 	if (!(*buf++ & perf_ibs->valid_mask))
 		goto fail;
 
@@ -1455,7 +1455,7 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	offset_max = perf_ibs_get_offset_max(perf_ibs, event, check_rip);
 
 	do {
-		rdmsrq(msr + offset, *buf++);
+		*buf++ = rdmsrq(msr + offset);
 		size++;
 		offset = find_next_bit(perf_ibs->offset_mask,
 				       perf_ibs->offset_max,
@@ -1497,17 +1497,17 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
 		if (perf_ibs == &perf_ibs_op) {
 			if (ibs_caps & IBS_CAPS_BRNTRGT) {
-				rdmsrq(MSR_AMD64_IBSBRTARGET, *buf++);
+				*buf++ = rdmsrq(MSR_AMD64_IBSBRTARGET);
 				br_target_idx = size;
 				size++;
 			}
 			if (ibs_caps & IBS_CAPS_OPDATA4) {
-				rdmsrq(MSR_AMD64_IBSOPDATA4, *buf++);
+				*buf++ = rdmsrq(MSR_AMD64_IBSOPDATA4);
 				size++;
 			}
 		}
 		if (perf_ibs == &perf_ibs_fetch && (ibs_caps & IBS_CAPS_FETCHCTLEXTD)) {
-			rdmsrq(MSR_AMD64_ICIBSEXTDCTL, *buf++);
+			*buf++ = rdmsrq(MSR_AMD64_ICIBSEXTDCTL);
 			size++;
 		}
 	}
@@ -1768,7 +1768,7 @@ static inline int ibs_eilvt_valid(void)
 
 	preempt_disable();
 
-	rdmsrq(MSR_AMD64_IBSCTL, val);
+	val = rdmsrq(MSR_AMD64_IBSCTL);
 	offset = val & IBSCTL_LVT_OFFSET_MASK;
 
 	if (!(val & IBSCTL_LVT_OFFSET_VALID)) {
@@ -1883,7 +1883,7 @@ static inline int get_ibs_lvt_offset(void)
 {
 	u64 val;
 
-	rdmsrq(MSR_AMD64_IBSCTL, val);
+	val = rdmsrq(MSR_AMD64_IBSCTL);
 	if (!(val & IBSCTL_LVT_OFFSET_VALID))
 		return -EINVAL;
 
diff --git a/arch/x86/events/amd/lbr.c b/arch/x86/events/amd/lbr.c
index a55646fcb846..0972690c7d45 100644
--- a/arch/x86/events/amd/lbr.c
+++ b/arch/x86/events/amd/lbr.c
@@ -76,7 +76,7 @@ static __always_inline u64 amd_pmu_lbr_get_from(unsigned int idx)
 {
 	u64 val;
 
-	rdmsrq(MSR_AMD_SAMP_BR_FROM + idx * 2, val);
+	val = rdmsrq(MSR_AMD_SAMP_BR_FROM + idx * 2);
 
 	return val;
 }
@@ -85,7 +85,7 @@ static __always_inline u64 amd_pmu_lbr_get_to(unsigned int idx)
 {
 	u64 val;
 
-	rdmsrq(MSR_AMD_SAMP_BR_FROM + idx * 2 + 1, val);
+	val = rdmsrq(MSR_AMD_SAMP_BR_FROM + idx * 2 + 1);
 
 	return val;
 }
@@ -404,11 +404,11 @@ void amd_pmu_lbr_enable_all(void)
 	}
 
 	if (cpu_feature_enabled(X86_FEATURE_AMD_LBR_PMC_FREEZE)) {
-		rdmsrq(MSR_IA32_DEBUGCTLMSR, dbg_ctl);
+		dbg_ctl = rdmsrq(MSR_IA32_DEBUGCTLMSR);
 		wrmsrq(MSR_IA32_DEBUGCTLMSR, dbg_ctl | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI);
 	}
 
-	rdmsrq(MSR_AMD_DBG_EXTN_CFG, dbg_extn_cfg);
+	dbg_extn_cfg = rdmsrq(MSR_AMD_DBG_EXTN_CFG);
 	wrmsrq(MSR_AMD_DBG_EXTN_CFG, dbg_extn_cfg | DBG_EXTN_CFG_LBRV2EN);
 }
 
diff --git a/arch/x86/events/amd/power.c b/arch/x86/events/amd/power.c
index 66197214b010..5a5ebce0a526 100644
--- a/arch/x86/events/amd/power.c
+++ b/arch/x86/events/amd/power.c
@@ -52,8 +52,8 @@ static void event_update(struct perf_event *event)
 
 	prev_pwr_acc = hwc->pwr_acc;
 	prev_ptsc = hwc->ptsc;
-	rdmsrq(MSR_F15H_CU_PWR_ACCUMULATOR, new_pwr_acc);
-	rdmsrq(MSR_F15H_PTSC, new_ptsc);
+	new_pwr_acc = rdmsrq(MSR_F15H_CU_PWR_ACCUMULATOR);
+	new_ptsc = rdmsrq(MSR_F15H_PTSC);
 
 	/*
 	 * Calculate the CU power consumption over a time period, the unit of
@@ -79,8 +79,8 @@ static void __pmu_event_start(struct perf_event *event)
 
 	event->hw.state = 0;
 
-	rdmsrq(MSR_F15H_PTSC, event->hw.ptsc);
-	rdmsrq(MSR_F15H_CU_PWR_ACCUMULATOR, event->hw.pwr_acc);
+	event->hw.ptsc = rdmsrq(MSR_F15H_PTSC);
+	event->hw.pwr_acc = rdmsrq(MSR_F15H_CU_PWR_ACCUMULATOR);
 }
 
 static void pmu_event_start(struct perf_event *event, int mode)
diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index 7aa5a5b652a2..29c120b4ed0c 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -151,7 +151,7 @@ static void amd_uncore_read(struct perf_event *event)
 	 * read counts directly from the corresponding PERF_CTR.
 	 */
 	if (hwc->event_base_rdpmc < 0)
-		rdmsrq(hwc->event_base, new);
+		new = rdmsrq(hwc->event_base);
 	else
 		new = rdpmc(hwc->event_base_rdpmc);
 
@@ -983,7 +983,7 @@ static void amd_uncore_umc_read(struct perf_event *event)
 	 * UMC counters do not have RDPMC assignments. Read counts directly
 	 * from the corresponding PERF_CTR.
 	 */
-	rdmsrq(hwc->event_base, new);
+	new = rdmsrq(hwc->event_base);
 
 	/*
 	 * Unlike the other uncore counters, UMC counters saturate and set the
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 4e344fb1ae3e..c2e15b490bba 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -852,7 +852,7 @@ void x86_pmu_disable_all(void)
 
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
-		rdmsrq(x86_pmu_config_addr(idx), val);
+		val = rdmsrq(x86_pmu_config_addr(idx));
 		if (!(val & ARCH_PERFMON_EVENTSEL_ENABLE))
 			continue;
 		val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
@@ -1734,10 +1734,10 @@ void perf_event_print_debug(void)
 		return;
 
 	if (x86_pmu.version >= 2) {
-		rdmsrq(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
-		rdmsrq(MSR_CORE_PERF_GLOBAL_STATUS, status);
-		rdmsrq(MSR_CORE_PERF_GLOBAL_OVF_CTRL, overflow);
-		rdmsrq(MSR_ARCH_PERFMON_FIXED_CTR_CTRL, fixed);
+		ctrl = rdmsrq(MSR_CORE_PERF_GLOBAL_CTRL);
+		status = rdmsrq(MSR_CORE_PERF_GLOBAL_STATUS);
+		overflow = rdmsrq(MSR_CORE_PERF_GLOBAL_OVF_CTRL);
+		fixed = rdmsrq(MSR_ARCH_PERFMON_FIXED_CTR_CTRL);
 
 		pr_info("\n");
 		pr_info("CPU#%d: ctrl:       %016llx\n", cpu, ctrl);
@@ -1745,19 +1745,19 @@ void perf_event_print_debug(void)
 		pr_info("CPU#%d: overflow:   %016llx\n", cpu, overflow);
 		pr_info("CPU#%d: fixed:      %016llx\n", cpu, fixed);
 		if (pebs_constraints) {
-			rdmsrq(MSR_IA32_PEBS_ENABLE, pebs);
+			pebs = rdmsrq(MSR_IA32_PEBS_ENABLE);
 			pr_info("CPU#%d: pebs:       %016llx\n", cpu, pebs);
 		}
 		if (x86_pmu.lbr_nr) {
-			rdmsrq(MSR_IA32_DEBUGCTLMSR, debugctl);
+			debugctl = rdmsrq(MSR_IA32_DEBUGCTLMSR);
 			pr_info("CPU#%d: debugctl:   %016llx\n", cpu, debugctl);
 		}
 	}
 	pr_info("CPU#%d: active:     %016llx\n", cpu, *(u64 *)cpuc->active_mask);
 
 	for_each_set_bit(idx, cntr_mask, X86_PMC_IDX_MAX) {
-		rdmsrq(x86_pmu_config_addr(idx), pmc_ctrl);
-		rdmsrq(x86_pmu_event_addr(idx), pmc_count);
+		pmc_ctrl = rdmsrq(x86_pmu_config_addr(idx));
+		pmc_count = rdmsrq(x86_pmu_event_addr(idx));
 
 		prev_left = per_cpu(pmc_prev_left[idx], cpu);
 
@@ -1769,7 +1769,7 @@ void perf_event_print_debug(void)
 			cpu, idx, prev_left);
 	}
 	for_each_set_bit(idx, fixed_cntr_mask, X86_PMC_IDX_MAX) {
-		rdmsrq(x86_pmu_fixed_ctr_addr(idx), pmc_count);
+		pmc_count = rdmsrq(x86_pmu_fixed_ctr_addr(idx));
 
 		pr_info("CPU#%d: fixed-PMC%d count: %016llx\n",
 			cpu, idx, pmc_count);
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 0a34d674df59..20e96e6c649c 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2974,7 +2974,7 @@ static inline u64 intel_pmu_get_status(void)
 {
 	u64 status;
 
-	rdmsrq(MSR_CORE_PERF_GLOBAL_STATUS, status);
+	status = rdmsrq(MSR_CORE_PERF_GLOBAL_STATUS);
 
 	return status;
 }
@@ -3533,7 +3533,7 @@ static void intel_pmu_enable_event_ext(struct perf_event *event)
 		else
 			new.thresh = ARCH_PEBS_THRESH_SINGLE;
 
-		rdmsrq(MSR_IA32_PEBS_INDEX, old.whole);
+		old.whole = rdmsrq(MSR_IA32_PEBS_INDEX);
 		if (new.thresh != old.thresh || !old.en) {
 			if (old.thresh == ARCH_PEBS_THRESH_MULTI && old.wr > 0) {
 				/*
@@ -6367,8 +6367,7 @@ static void intel_update_pmu_caps(struct pmu *pmu)
 		update_pmu_cap_from_perfmonext(pmu);
 
 	if (is_hybrid() && this_cpu_has(X86_FEATURE_PDCM)) {
-		rdmsrq(MSR_IA32_PERF_CAPABILITIES,
-		       hybrid(pmu, intel_cap).capabilities);
+		hybrid(pmu, intel_cap).capabilities = rdmsrq(MSR_IA32_PERF_CAPABILITIES);
 
 		/*
 		 * Restore perf_metrics on platforms with broken
@@ -6525,7 +6524,7 @@ static void intel_pmu_cpu_starting(int cpu)
 	if (!is_hybrid() && x86_pmu.intel_cap.perf_metrics) {
 		union perf_capabilities perf_cap;
 
-		rdmsrq(MSR_IA32_PERF_CAPABILITIES, perf_cap.capabilities);
+		perf_cap.capabilities = rdmsrq(MSR_IA32_PERF_CAPABILITIES);
 		if (!perf_cap.perf_metrics) {
 			x86_pmu.intel_cap.perf_metrics = 0;
 			x86_pmu.intel_ctrl &= ~GLOBAL_CTRL_EN_PERF_METRICS;
@@ -8104,7 +8103,7 @@ __init int intel_pmu_init(void)
 	if (boot_cpu_has(X86_FEATURE_PDCM)) {
 		u64 capabilities;
 
-		rdmsrq(MSR_IA32_PERF_CAPABILITIES, capabilities);
+		capabilities = rdmsrq(MSR_IA32_PERF_CAPABILITIES);
 		x86_pmu.intel_cap.capabilities = capabilities;
 	}
 
diff --git a/arch/x86/events/intel/cstate.c b/arch/x86/events/intel/cstate.c
index f3d5ee07f8f2..69eb6cf51d3b 100644
--- a/arch/x86/events/intel/cstate.c
+++ b/arch/x86/events/intel/cstate.c
@@ -324,7 +324,7 @@ static inline u64 cstate_pmu_read_counter(struct perf_event *event)
 {
 	u64 val;
 
-	rdmsrq(event->hw.event_base, val);
+	val = rdmsrq(event->hw.event_base);
 	return val;
 }
 
diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 8444670cee4a..b3b6ea4679ac 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -3356,7 +3356,7 @@ static int intel_pmu_drain_arch_pebs(struct pt_regs *iregs,
 	bool corrupted = false;
 	u64 mask;
 
-	rdmsrq(MSR_IA32_PEBS_INDEX, index.whole);
+	index.whole = rdmsrq(MSR_IA32_PEBS_INDEX);
 
 	if (unlikely(!index.wr)) {
 		intel_pmu_pebs_event_update_no_drain(cpuc, X86_PMC_IDX_MAX);
diff --git a/arch/x86/events/intel/knc.c b/arch/x86/events/intel/knc.c
index e887adc108ac..c4f81215f758 100644
--- a/arch/x86/events/intel/knc.c
+++ b/arch/x86/events/intel/knc.c
@@ -160,7 +160,7 @@ static void knc_pmu_disable_all(void)
 {
 	u64 val;
 
-	rdmsrq(MSR_KNC_IA32_PERF_GLOBAL_CTRL, val);
+	val = rdmsrq(MSR_KNC_IA32_PERF_GLOBAL_CTRL);
 	val &= ~(KNC_ENABLE_COUNTER0|KNC_ENABLE_COUNTER1);
 	wrmsrq(MSR_KNC_IA32_PERF_GLOBAL_CTRL, val);
 }
@@ -169,7 +169,7 @@ static void knc_pmu_enable_all(int added)
 {
 	u64 val;
 
-	rdmsrq(MSR_KNC_IA32_PERF_GLOBAL_CTRL, val);
+	val = rdmsrq(MSR_KNC_IA32_PERF_GLOBAL_CTRL);
 	val |= (KNC_ENABLE_COUNTER0|KNC_ENABLE_COUNTER1);
 	wrmsrq(MSR_KNC_IA32_PERF_GLOBAL_CTRL, val);
 }
@@ -201,7 +201,7 @@ static inline u64 knc_pmu_get_status(void)
 {
 	u64 status;
 
-	rdmsrq(MSR_KNC_IA32_PERF_GLOBAL_STATUS, status);
+	status = rdmsrq(MSR_KNC_IA32_PERF_GLOBAL_STATUS);
 
 	return status;
 }
diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 0b446d8912e4..68d184ea5bcf 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -141,7 +141,7 @@ static void __intel_pmu_lbr_enable(bool pmi)
 	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR) && !pmi && cpuc->lbr_sel)
 		wrmsrq(MSR_LBR_SELECT, lbr_select);
 
-	rdmsrq(MSR_IA32_DEBUGCTLMSR, debugctl);
+	debugctl = rdmsrq(MSR_IA32_DEBUGCTLMSR);
 	orig_debugctl = debugctl;
 
 	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR))
@@ -211,7 +211,7 @@ static inline u64 intel_pmu_lbr_tos(void)
 {
 	u64 tos;
 
-	rdmsrq(x86_pmu.lbr_tos, tos);
+	tos = rdmsrq(x86_pmu.lbr_tos);
 	return tos;
 }
 
@@ -304,7 +304,7 @@ static __always_inline u64 rdlbr_from(unsigned int idx, struct lbr_entry *lbr)
 	if (lbr)
 		return lbr->from;
 
-	rdmsrq(x86_pmu.lbr_from + idx, val);
+	val = rdmsrq(x86_pmu.lbr_from + idx);
 
 	return lbr_from_signext_quirk_rd(val);
 }
@@ -316,7 +316,7 @@ static __always_inline u64 rdlbr_to(unsigned int idx, struct lbr_entry *lbr)
 	if (lbr)
 		return lbr->to;
 
-	rdmsrq(x86_pmu.lbr_to + idx, val);
+	val = rdmsrq(x86_pmu.lbr_to + idx);
 
 	return val;
 }
@@ -328,7 +328,7 @@ static __always_inline u64 rdlbr_info(unsigned int idx, struct lbr_entry *lbr)
 	if (lbr)
 		return lbr->info;
 
-	rdmsrq(x86_pmu.lbr_info + idx, val);
+	val = rdmsrq(x86_pmu.lbr_info + idx);
 
 	return val;
 }
@@ -477,7 +477,7 @@ void intel_pmu_lbr_save(void *ctx)
 	task_ctx->tos = tos;
 
 	if (cpuc->lbr_select)
-		rdmsrq(MSR_LBR_SELECT, task_ctx->lbr_sel);
+		task_ctx->lbr_sel = rdmsrq(MSR_LBR_SELECT);
 }
 
 static void intel_pmu_arch_lbr_save(void *ctx)
@@ -754,7 +754,7 @@ void intel_pmu_lbr_read_32(struct cpu_hw_events *cpuc)
 			u64     lbr;
 		} msr_lastbranch;
 
-		rdmsrq(x86_pmu.lbr_from + lbr_idx, msr_lastbranch.lbr);
+		msr_lastbranch.lbr = rdmsrq(x86_pmu.lbr_from + lbr_idx);
 
 		*br = (struct perf_branch_entry){
 			.from	= msr_lastbranch.from,
diff --git a/arch/x86/events/intel/p4.c b/arch/x86/events/intel/p4.c
index 5368dc31787c..e675e85682f1 100644
--- a/arch/x86/events/intel/p4.c
+++ b/arch/x86/events/intel/p4.c
@@ -860,7 +860,7 @@ static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
 	u64 v;
 
 	/* an official way for overflow indication */
-	rdmsrq(hwc->config_base, v);
+	v = rdmsrq(hwc->config_base);
 	if (v & P4_CCCR_OVF) {
 		wrmsrq(hwc->config_base, v & ~P4_CCCR_OVF);
 		return 1;
@@ -873,7 +873,7 @@ static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
 	 * the counter has reached zero value and continued counting before
 	 * real NMI signal was received:
 	 */
-	rdmsrq(hwc->event_base, v);
+	v = rdmsrq(hwc->event_base);
 	if (!(v & ARCH_P4_UNFLAGGED_BIT))
 		return 1;
 
@@ -1373,7 +1373,7 @@ __init int p4_pmu_init(void)
 	/* If we get stripped -- indexing fails */
 	BUILD_BUG_ON(ARCH_P4_MAX_CCCR > INTEL_PMC_MAX_GENERIC);
 
-	rdmsrq(MSR_IA32_MISC_ENABLE, misc);
+	misc = rdmsrq(MSR_IA32_MISC_ENABLE);
 	if (!(misc & MSR_IA32_MISC_ENABLE_EMON)) {
 		pr_cont("unsupported Netburst CPU model %d ",
 			boot_cpu_data.x86_model);
diff --git a/arch/x86/events/intel/p6.c b/arch/x86/events/intel/p6.c
index fb991e0ac614..4268b576b5d8 100644
--- a/arch/x86/events/intel/p6.c
+++ b/arch/x86/events/intel/p6.c
@@ -143,7 +143,7 @@ static void p6_pmu_disable_all(void)
 	u64 val;
 
 	/* p6 only has one enable register */
-	rdmsrq(MSR_P6_EVNTSEL0, val);
+	val = rdmsrq(MSR_P6_EVNTSEL0);
 	val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
 	wrmsrq(MSR_P6_EVNTSEL0, val);
 }
@@ -153,7 +153,7 @@ static void p6_pmu_enable_all(int added)
 	unsigned long val;
 
 	/* p6 only has one enable register */
-	rdmsrq(MSR_P6_EVNTSEL0, val);
+	val = rdmsrq(MSR_P6_EVNTSEL0);
 	val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 	wrmsrq(MSR_P6_EVNTSEL0, val);
 }
diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 49349afee611..2478d93e2e45 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -196,7 +196,7 @@ static int __init pt_pmu_hw_init(void)
 	int ret;
 	long i;
 
-	rdmsrq(MSR_PLATFORM_INFO, reg);
+	reg = rdmsrq(MSR_PLATFORM_INFO);
 	pt_pmu.max_nonturbo_ratio = (reg & 0xff00) >> 8;
 
 	/*
@@ -232,7 +232,7 @@ static int __init pt_pmu_hw_init(void)
 		 * "IA32_VMX_MISC[bit 14]" being 1 means PT can trace
 		 * post-VMXON.
 		 */
-		rdmsrq(MSR_IA32_VMX_MISC, reg);
+		reg = rdmsrq(MSR_IA32_VMX_MISC);
 		if (reg & BIT(14))
 			pt_pmu.vmx = true;
 	}
@@ -934,7 +934,7 @@ static void pt_handle_status(struct pt *pt)
 	int advance = 0;
 	u64 status;
 
-	rdmsrq(MSR_IA32_RTIT_STATUS, status);
+	status = rdmsrq(MSR_IA32_RTIT_STATUS);
 
 	if (status & RTIT_STATUS_ERROR) {
 		pr_err_ratelimited("ToPA ERROR encountered, trying to recover\n");
@@ -993,12 +993,12 @@ static void pt_read_offset(struct pt_buffer *buf)
 	struct topa_page *tp;
 
 	if (!buf->single) {
-		rdmsrq(MSR_IA32_RTIT_OUTPUT_BASE, pt->output_base);
+		pt->output_base = rdmsrq(MSR_IA32_RTIT_OUTPUT_BASE);
 		tp = phys_to_virt(pt->output_base);
 		buf->cur = &tp->topa;
 	}
 
-	rdmsrq(MSR_IA32_RTIT_OUTPUT_MASK, pt->output_mask);
+	pt->output_mask = rdmsrq(MSR_IA32_RTIT_OUTPUT_MASK);
 	/* offset within current output region */
 	buf->output_off = pt->output_mask >> 32;
 	/* index of current output region within this table */
@@ -1621,7 +1621,7 @@ static void pt_event_start(struct perf_event *event, int mode)
 			 * PMI might have just cleared these, so resume_allowed
 			 * must be checked again also.
 			 */
-			rdmsrq(MSR_IA32_RTIT_STATUS, status);
+			status = rdmsrq(MSR_IA32_RTIT_STATUS);
 			if (!(status & (RTIT_STATUS_TRIGGEREN |
 					RTIT_STATUS_ERROR |
 					RTIT_STATUS_STOPPED)) &&
diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index b2109b37ea7f..ab2c5a962b31 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -171,7 +171,7 @@ u64 uncore_msr_read_counter(struct intel_uncore_box *box, struct perf_event *eve
 {
 	u64 count;
 
-	rdmsrq(event->hw.event_base, count);
+	count = rdmsrq(event->hw.event_base);
 
 	return count;
 }
diff --git a/arch/x86/events/intel/uncore_nhmex.c b/arch/x86/events/intel/uncore_nhmex.c
index 7a6855281102..81e838e6f729 100644
--- a/arch/x86/events/intel/uncore_nhmex.c
+++ b/arch/x86/events/intel/uncore_nhmex.c
@@ -216,7 +216,7 @@ static void nhmex_uncore_msr_disable_box(struct intel_uncore_box *box)
 	u64 config;
 
 	if (msr) {
-		rdmsrq(msr, config);
+		config = rdmsrq(msr);
 		config &= ~((1ULL << uncore_num_counters(box)) - 1);
 		/* WBox has a fixed counter */
 		if (uncore_msr_fixed_ctl(box))
@@ -231,7 +231,7 @@ static void nhmex_uncore_msr_enable_box(struct intel_uncore_box *box)
 	u64 config;
 
 	if (msr) {
-		rdmsrq(msr, config);
+		config = rdmsrq(msr);
 		config |= (1ULL << uncore_num_counters(box)) - 1;
 		/* WBox has a fixed counter */
 		if (uncore_msr_fixed_ctl(box))
diff --git a/arch/x86/events/intel/uncore_snb.c b/arch/x86/events/intel/uncore_snb.c
index 055131c508ff..da864724ff20 100644
--- a/arch/x86/events/intel/uncore_snb.c
+++ b/arch/x86/events/intel/uncore_snb.c
@@ -533,7 +533,7 @@ static int icl_get_cbox_num(void)
 {
 	u64 num_boxes;
 
-	rdmsrq(ICL_UNC_CBO_CONFIG, num_boxes);
+	num_boxes = rdmsrq(ICL_UNC_CBO_CONFIG);
 
 	return num_boxes & ICL_UNC_NUM_CBO_MASK;
 }
diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 1b460cf27a10..65834b182b7a 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -645,7 +645,7 @@ static void snbep_uncore_msr_disable_box(struct intel_uncore_box *box)
 
 	msr = uncore_msr_box_ctl(box);
 	if (msr) {
-		rdmsrq(msr, config);
+		config = rdmsrq(msr);
 		config |= SNBEP_PMON_BOX_CTL_FRZ;
 		wrmsrq(msr, config);
 	}
@@ -658,7 +658,7 @@ static void snbep_uncore_msr_enable_box(struct intel_uncore_box *box)
 
 	msr = uncore_msr_box_ctl(box);
 	if (msr) {
-		rdmsrq(msr, config);
+		config = rdmsrq(msr);
 		config &= ~SNBEP_PMON_BOX_CTL_FRZ;
 		wrmsrq(msr, config);
 	}
@@ -6373,7 +6373,7 @@ void spr_uncore_cpu_init(void)
 		 * of UNCORE_SPR_CHA) is incorrect on some SPR variants because of a
 		 * firmware bug. Using the value from SPR_MSR_UNC_CBO_CONFIG to replace it.
 		 */
-		rdmsrq(SPR_MSR_UNC_CBO_CONFIG, num_cbo);
+		num_cbo = rdmsrq(SPR_MSR_UNC_CBO_CONFIG);
 		/*
 		 * The MSR doesn't work on the EMR XCC, but the firmware bug doesn't impact
 		 * the EMR XCC. Don't let the value from the MSR replace the existing value.
diff --git a/arch/x86/events/msr.c b/arch/x86/events/msr.c
index 76d6418c5055..0e59781549ca 100644
--- a/arch/x86/events/msr.c
+++ b/arch/x86/events/msr.c
@@ -158,7 +158,7 @@ static inline u64 msr_read_counter(struct perf_event *event)
 	u64 now;
 
 	if (event->hw.event_base)
-		rdmsrq(event->hw.event_base, now);
+		now = rdmsrq(event->hw.event_base);
 	else
 		now = rdtsc_ordered();
 
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index e274802ef062..20642560f965 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -1678,11 +1678,11 @@ static __always_inline void __amd_pmu_lbr_disable(void)
 {
 	u64 dbg_ctl, dbg_extn_cfg;
 
-	rdmsrq(MSR_AMD_DBG_EXTN_CFG, dbg_extn_cfg);
+	dbg_extn_cfg = rdmsrq(MSR_AMD_DBG_EXTN_CFG);
 	wrmsrq(MSR_AMD_DBG_EXTN_CFG, dbg_extn_cfg & ~DBG_EXTN_CFG_LBRV2EN);
 
 	if (cpu_feature_enabled(X86_FEATURE_AMD_LBR_PMC_FREEZE)) {
-		rdmsrq(MSR_IA32_DEBUGCTLMSR, dbg_ctl);
+		dbg_ctl = rdmsrq(MSR_IA32_DEBUGCTLMSR);
 		wrmsrq(MSR_IA32_DEBUGCTLMSR, dbg_ctl & ~DEBUGCTLMSR_FREEZE_LBRS_ON_PMI);
 	}
 }
@@ -1836,7 +1836,7 @@ static __always_inline void __intel_pmu_lbr_disable(void)
 {
 	u64 debugctl;
 
-	rdmsrq(MSR_IA32_DEBUGCTLMSR, debugctl);
+	debugctl = rdmsrq(MSR_IA32_DEBUGCTLMSR);
 	debugctl &= ~(DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI);
 	wrmsrq(MSR_IA32_DEBUGCTLMSR, debugctl);
 }
diff --git a/arch/x86/events/rapl.c b/arch/x86/events/rapl.c
index 8ed03c32f560..180cc18282ca 100644
--- a/arch/x86/events/rapl.c
+++ b/arch/x86/events/rapl.c
@@ -193,7 +193,7 @@ static inline unsigned int get_rapl_pmu_idx(int cpu, int scope)
 static inline u64 rapl_read_counter(struct perf_event *event)
 {
 	u64 raw;
-	rdmsrq(event->hw.event_base, raw);
+	raw = rdmsrq(event->hw.event_base);
 	return raw;
 }
 
@@ -222,7 +222,7 @@ static u64 rapl_event_update(struct perf_event *event)
 
 	prev_raw_count = local64_read(&hwc->prev_count);
 	do {
-		rdmsrq(event->hw.event_base, new_raw_count);
+		new_raw_count = rdmsrq(event->hw.event_base);
 	} while (!local64_try_cmpxchg(&hwc->prev_count,
 				      &prev_raw_count, new_raw_count));
 
diff --git a/arch/x86/events/zhaoxin/core.c b/arch/x86/events/zhaoxin/core.c
index e506f677db57..1980e5995e27 100644
--- a/arch/x86/events/zhaoxin/core.c
+++ b/arch/x86/events/zhaoxin/core.c
@@ -268,7 +268,7 @@ static inline u64 zhaoxin_pmu_get_status(void)
 {
 	u64 status;
 
-	rdmsrq(MSR_CORE_PERF_GLOBAL_STATUS, status);
+	status = rdmsrq(MSR_CORE_PERF_GLOBAL_STATUS);
 
 	return status;
 }
@@ -295,7 +295,7 @@ static void zhaoxin_pmu_disable_fixed(struct hw_perf_event *hwc)
 
 	mask = 0xfULL << (idx * 4);
 
-	rdmsrq(hwc->config_base, ctrl_val);
+	ctrl_val = rdmsrq(hwc->config_base);
 	ctrl_val &= ~mask;
 	wrmsrq(hwc->config_base, ctrl_val);
 }
@@ -331,7 +331,7 @@ static void zhaoxin_pmu_enable_fixed(struct hw_perf_event *hwc)
 	bits <<= (idx * 4);
 	mask = 0xfULL << (idx * 4);
 
-	rdmsrq(hwc->config_base, ctrl_val);
+	ctrl_val = rdmsrq(hwc->config_base);
 	ctrl_val &= ~mask;
 	ctrl_val |= bits;
 	wrmsrq(hwc->config_base, ctrl_val);
diff --git a/arch/x86/hyperv/hv_apic.c b/arch/x86/hyperv/hv_apic.c
index 95f1782d1e17..4e30f9a11bc4 100644
--- a/arch/x86/hyperv/hv_apic.c
+++ b/arch/x86/hyperv/hv_apic.c
@@ -38,7 +38,7 @@ static u64 hv_apic_icr_read(void)
 {
 	u64 reg_val;
 
-	rdmsrq(HV_X64_MSR_ICR, reg_val);
+	reg_val = rdmsrq(HV_X64_MSR_ICR);
 	return reg_val;
 }
 
@@ -64,10 +64,10 @@ static u32 hv_apic_read(u32 reg)
 
 	switch (reg) {
 	case APIC_EOI:
-		rdmsrq(HV_X64_MSR_EOI, reg_val.q);
+		reg_val.q = rdmsrq(HV_X64_MSR_EOI);
 		return reg_val.l;
 	case APIC_TASKPRI:
-		rdmsrq(HV_X64_MSR_TPR, reg_val.q);
+		reg_val.q = rdmsrq(HV_X64_MSR_TPR);
 		return reg_val.l;
 
 	default:
diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index b90e6f487533..0a3f2e9e77ba 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -101,7 +101,7 @@ static int hyperv_init_ghcb(void)
 	 * returned by MSR_AMD64_SEV_ES_GHCB is above shared
 	 * memory boundary and map it here.
 	 */
-	rdmsrq(MSR_AMD64_SEV_ES_GHCB, ghcb_gpa);
+	ghcb_gpa = rdmsrq(MSR_AMD64_SEV_ES_GHCB);
 
 	/* Mask out vTOM bit and map as decrypted */
 	ghcb_gpa &= ~ms_hyperv.shared_gpa_boundary;
@@ -134,7 +134,7 @@ static int hv_cpu_init(unsigned int cpu)
 		 * For root partition we get the hypervisor provided VP assist
 		 * page, instead of allocating a new page.
 		 */
-		rdmsrq(HV_X64_MSR_VP_ASSIST_PAGE, msr.as_uint64);
+		msr.as_uint64 = rdmsrq(HV_X64_MSR_VP_ASSIST_PAGE);
 		*hvp = memremap(msr.pfn << HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_SHIFT,
 				PAGE_SIZE, MEMREMAP_WB);
 	} else {
@@ -182,7 +182,7 @@ static void hv_reenlightenment_notify(struct work_struct *dummy)
 {
 	struct hv_tsc_emulation_status emu_status;
 
-	rdmsrq(HV_X64_MSR_TSC_EMULATION_STATUS, *(u64 *)&emu_status);
+	*(u64 *)&emu_status = rdmsrq(HV_X64_MSR_TSC_EMULATION_STATUS);
 
 	/* Don't issue the callback if TSC accesses are not emulated */
 	if (hv_reenlightenment_cb && emu_status.inprogress)
@@ -195,11 +195,11 @@ void hyperv_stop_tsc_emulation(void)
 	u64 freq;
 	struct hv_tsc_emulation_status emu_status;
 
-	rdmsrq(HV_X64_MSR_TSC_EMULATION_STATUS, *(u64 *)&emu_status);
+	*(u64 *)&emu_status = rdmsrq(HV_X64_MSR_TSC_EMULATION_STATUS);
 	emu_status.inprogress = 0;
 	wrmsrq(HV_X64_MSR_TSC_EMULATION_STATUS, *(u64 *)&emu_status);
 
-	rdmsrq(HV_X64_MSR_TSC_FREQUENCY, freq);
+	freq = rdmsrq(HV_X64_MSR_TSC_FREQUENCY);
 	tsc_khz = div64_u64(freq, 1000);
 }
 EXPORT_SYMBOL_GPL(hyperv_stop_tsc_emulation);
@@ -259,7 +259,7 @@ void clear_hv_tscchange_cb(void)
 	if (!hv_reenlightenment_available())
 		return;
 
-	rdmsrq(HV_X64_MSR_REENLIGHTENMENT_CONTROL, *(u64 *)&re_ctrl);
+	*(u64 *)&re_ctrl = rdmsrq(HV_X64_MSR_REENLIGHTENMENT_CONTROL);
 	re_ctrl.enabled = 0;
 	wrmsrq(HV_X64_MSR_REENLIGHTENMENT_CONTROL, *(u64 *)&re_ctrl);
 
@@ -295,7 +295,7 @@ static int hv_cpu_die(unsigned int cpu)
 			 */
 			memunmap(hv_vp_assist_page[cpu]);
 			hv_vp_assist_page[cpu] = NULL;
-			rdmsrq(HV_X64_MSR_VP_ASSIST_PAGE, msr.as_uint64);
+			msr.as_uint64 = rdmsrq(HV_X64_MSR_VP_ASSIST_PAGE);
 			msr.enable = 0;
 		}
 		wrmsrq(HV_X64_MSR_VP_ASSIST_PAGE, msr.as_uint64);
@@ -304,7 +304,7 @@ static int hv_cpu_die(unsigned int cpu)
 	if (hv_reenlightenment_cb == NULL)
 		return 0;
 
-	rdmsrq(HV_X64_MSR_REENLIGHTENMENT_CONTROL, *((u64 *)&re_ctrl));
+	*((u64 *)&re_ctrl) = rdmsrq(HV_X64_MSR_REENLIGHTENMENT_CONTROL);
 	if (re_ctrl.target_vp == hv_vp_index[cpu]) {
 		/*
 		 * Reassign reenlightenment notifications to some other online
@@ -375,7 +375,7 @@ static int hv_suspend(void *data)
 	hv_set_hypercall_pg(NULL);
 
 	/* Disable the hypercall page in the hypervisor */
-	rdmsrq(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
+	hypercall_msr.as_uint64 = rdmsrq(HV_X64_MSR_HYPERCALL);
 	hypercall_msr.enable = 0;
 	wrmsrq(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
 
@@ -392,7 +392,7 @@ static void hv_resume(void *data)
 	WARN_ON(ret);
 
 	/* Re-enable the hypercall page */
-	rdmsrq(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
+	hypercall_msr.as_uint64 = rdmsrq(HV_X64_MSR_HYPERCALL);
 	hypercall_msr.enable = 1;
 	hypercall_msr.guest_physical_address =
 		vmalloc_to_pfn(hv_hypercall_pg_saved);
@@ -530,7 +530,7 @@ void __init hyperv_init(void)
 	if (hv_hypercall_pg == NULL)
 		goto clean_guest_os_id;
 
-	rdmsrq(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
+	hypercall_msr.as_uint64 = rdmsrq(HV_X64_MSR_HYPERCALL);
 	hypercall_msr.enable = 1;
 
 	if (hv_root_partition()) {
@@ -676,7 +676,7 @@ void hyperv_report_panic(struct pt_regs *regs, long err, bool in_die)
 		return;
 	panic_reported = true;
 
-	rdmsrq(HV_X64_MSR_GUEST_OS_ID, guest_id);
+	guest_id = rdmsrq(HV_X64_MSR_GUEST_OS_ID);
 
 	wrmsrq(HV_X64_MSR_CRASH_P0, err);
 	wrmsrq(HV_X64_MSR_CRASH_P1, guest_id);
@@ -710,7 +710,7 @@ bool hv_is_hyperv_initialized(void)
 	 * that the hypercall page is setup
 	 */
 	hypercall_msr.as_uint64 = 0;
-	rdmsrq(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
+	hypercall_msr.as_uint64 = rdmsrq(HV_X64_MSR_HYPERCALL);
 
 	return hypercall_msr.enable;
 }
diff --git a/arch/x86/hyperv/hv_spinlock.c b/arch/x86/hyperv/hv_spinlock.c
index 6b4bdea18218..7ef2d794e2e8 100644
--- a/arch/x86/hyperv/hv_spinlock.c
+++ b/arch/x86/hyperv/hv_spinlock.c
@@ -50,7 +50,7 @@ static void hv_qlock_wait(u8 *byte, u8 val)
 	if (READ_ONCE(*byte) == val) {
 		unsigned long msr_val;
 
-		rdmsrq(HV_X64_MSR_GUEST_IDLE, msr_val);
+		msr_val = rdmsrq(HV_X64_MSR_GUEST_IDLE);
 
 		(void)msr_val;
 	}
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 9cd493d467d4..e028140fac49 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -220,7 +220,7 @@ static inline u32 native_apic_msr_read(u32 reg)
 	if (reg == APIC_DFR)
 		return -1;
 
-	rdmsrq(APIC_BASE_MSR + (reg >> 4), msr);
+	msr = rdmsrq(APIC_BASE_MSR + (reg >> 4));
 	return (u32)msr;
 }
 
@@ -233,7 +233,7 @@ static inline u64 native_x2apic_icr_read(void)
 {
 	unsigned long val;
 
-	rdmsrq(APIC_BASE_MSR + (APIC_ICR >> 4), val);
+	val = rdmsrq(APIC_BASE_MSR + (APIC_ICR >> 4));
 	return val;
 }
 
diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index 854d82b88ff4..60a3df32a4d3 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -180,7 +180,7 @@ static inline unsigned long get_debugctlmsr(void)
 	if (boot_cpu_data.x86 < 6)
 		return 0;
 #endif
-	rdmsrq(MSR_IA32_DEBUGCTLMSR, debugctlmsr);
+	debugctlmsr = rdmsrq(MSR_IA32_DEBUGCTLMSR);
 
 	return debugctlmsr;
 }
diff --git a/arch/x86/include/asm/fsgsbase.h b/arch/x86/include/asm/fsgsbase.h
index 70ff4ef457b1..9de49d732e9e 100644
--- a/arch/x86/include/asm/fsgsbase.h
+++ b/arch/x86/include/asm/fsgsbase.h
@@ -60,7 +60,7 @@ static inline unsigned long x86_fsbase_read_cpu(void)
 	if (boot_cpu_has(X86_FEATURE_FSGSBASE))
 		fsbase = rdfsbase();
 	else
-		rdmsrq(MSR_FS_BASE, fsbase);
+		fsbase = rdmsrq(MSR_FS_BASE);
 
 	return fsbase;
 }
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1ee4b127004d..e1e5d32c6286 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1880,7 +1880,7 @@ static inline unsigned long read_msr(unsigned long msr)
 {
 	u64 value;
 
-	rdmsrq(msr, value);
+	value = rdmsrq(msr);
 	return value;
 }
 #endif
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 6d7bab33af71..95761803c2e6 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -173,14 +173,13 @@ static inline u64 native_read_pmc(int counter)
 #include <asm/paravirt.h>
 #else
 #include <linux/errno.h>
-/*
- * Access to machine-specific registers (available on 586 and better only)
- * Note: the rd* operations modify the parameters directly (without using
- * pointer indirection), this allows gcc to optimize better
- */
 
-#define rdmsrq(msr, val)			\
-	((val) = native_read_msr((msr)))
+/* Access to machine-specific registers (available on 586 and better only) */
+
+static __always_inline u64 rdmsrq(u32 msr)
+{
+	return native_read_msr(msr);
+}
 
 static inline void wrmsrq(u32 msr, u64 val)
 {
@@ -237,7 +236,7 @@ int wrmsr_safe_regs_on_cpu(unsigned int cpu, u32 regs[8]);
 #else  /*  CONFIG_SMP  */
 static inline int rdmsrq_on_cpu(unsigned int cpu, u32 msr_no, u64 *q)
 {
-	rdmsrq(msr_no, *q);
+	*q = rdmsrq(msr_no);
 	return 0;
 }
 static inline int wrmsrq_on_cpu(unsigned int cpu, u32 msr_no, u64 q)
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 93754aa60d5e..19442bc3af37 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -150,10 +150,10 @@ static inline int paravirt_write_msr_safe(u32 msr, u64 val)
 	return PVOP_CALL2(int, pv_ops, cpu.write_msr_safe, msr, val);
 }
 
-#define rdmsrq(msr, val)			\
-do {						\
-	val = paravirt_read_msr(msr);		\
-} while (0)
+static __always_inline u64 rdmsrq(u32 msr)
+{
+	return paravirt_read_msr(msr);
+}
 
 static inline void wrmsrq(u32 msr, u64 val)
 {
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 90025451ace2..7a6c77e6a44e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1193,7 +1193,7 @@ void disable_local_APIC(void)
 	if (enabled_via_apicbase) {
 		struct msr val;
 
-		rdmsrq(MSR_IA32_APICBASE, val.q);
+		val.q = rdmsrq(MSR_IA32_APICBASE);
 		val.l &= ~MSR_IA32_APICBASE_ENABLE;
 		wrmsrq(MSR_IA32_APICBASE, val.q);
 	}
@@ -1710,7 +1710,7 @@ static bool x2apic_hw_locked(void)
 
 	x86_arch_cap_msr = x86_read_arch_cap_msr();
 	if (x86_arch_cap_msr & ARCH_CAP_XAPIC_DISABLE) {
-		rdmsrq(MSR_IA32_XAPIC_DISABLE_STATUS, msr);
+		msr = rdmsrq(MSR_IA32_XAPIC_DISABLE_STATUS);
 		return (msr & LEGACY_XAPIC_DISABLED);
 	}
 	return false;
@@ -1723,7 +1723,7 @@ static void __x2apic_disable(void)
 	if (!boot_cpu_has(X86_FEATURE_APIC))
 		return;
 
-	rdmsrq(MSR_IA32_APICBASE, msr);
+	msr = rdmsrq(MSR_IA32_APICBASE);
 	if (!(msr & X2APIC_ENABLE))
 		return;
 	/* Disable xapic and x2apic first and then reenable xapic mode */
@@ -1736,7 +1736,7 @@ static void __x2apic_enable(void)
 {
 	u64 msr;
 
-	rdmsrq(MSR_IA32_APICBASE, msr);
+	msr = rdmsrq(MSR_IA32_APICBASE);
 	if (msr & X2APIC_ENABLE)
 		return;
 	wrmsrq(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);
@@ -1976,7 +1976,7 @@ static bool __init apic_verify(unsigned long addr)
 
 	/* The BIOS may have set up the APIC at some other address */
 	if (boot_cpu_data.x86 >= 6) {
-		rdmsrq(MSR_IA32_APICBASE, val.q);
+		val.q = rdmsrq(MSR_IA32_APICBASE);
 		if (val.l & MSR_IA32_APICBASE_ENABLE)
 			addr = val.l & MSR_IA32_APICBASE_BASE;
 	}
@@ -1999,7 +1999,7 @@ bool __init apic_force_enable(unsigned long addr)
 	 * and AMD K7 (Model > 1) or later.
 	 */
 	if (boot_cpu_data.x86 >= 6) {
-		rdmsrq(MSR_IA32_APICBASE, val.q);
+		val.q = rdmsrq(MSR_IA32_APICBASE);
 		if (!(val.l & MSR_IA32_APICBASE_ENABLE)) {
 			pr_info("Local APIC disabled by BIOS -- reenabling.\n");
 			val.l &= ~MSR_IA32_APICBASE_BASE;
@@ -2476,7 +2476,7 @@ static void lapic_resume(void *data)
 		 * SMP! We'll need to do this as part of the CPU restore!
 		 */
 		if (boot_cpu_data.x86 >= 6) {
-			rdmsrq(MSR_IA32_APICBASE, val.q);
+			val.q = rdmsrq(MSR_IA32_APICBASE);
 			val.l &= ~MSR_IA32_APICBASE_BASE;
 			val.l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
 			wrmsrq(MSR_IA32_APICBASE, val.q);
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index a60c8960bbfd..3af93e3f2179 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -32,7 +32,7 @@ static u32 numachip1_get_apic_id(u32 x)
 	unsigned int id = (x >> 24) & 0xff;
 
 	if (cpu_feature_enabled(X86_FEATURE_NODEID_MSR)) {
-		rdmsrq(MSR_FAM10H_NODE_ID, value);
+		value = rdmsrq(MSR_FAM10H_NODE_ID);
 		id |= (value << 2) & 0xff00;
 	}
 
@@ -43,7 +43,7 @@ static u32 numachip2_get_apic_id(u32 x)
 {
 	u64 mcfg;
 
-	rdmsrq(MSR_FAM10H_MMIO_CONF_BASE, mcfg);
+	mcfg = rdmsrq(MSR_FAM10H_MMIO_CONF_BASE);
 	return ((mcfg >> (28 - 8)) & 0xfff00) | (x >> 24);
 }
 
@@ -151,7 +151,7 @@ static void fixup_cpu_id(struct cpuinfo_x86 *c, int node)
 
 	/* Account for nodes per socket in multi-core-module processors */
 	if (boot_cpu_has(X86_FEATURE_NODEID_MSR)) {
-		rdmsrq(MSR_FAM10H_NODE_ID, val);
+		val = rdmsrq(MSR_FAM10H_NODE_ID);
 		nodes = ((val >> 3) & 7) + 1;
 	}
 
diff --git a/arch/x86/kernel/cet.c b/arch/x86/kernel/cet.c
index 99444409c026..3efceee443b7 100644
--- a/arch/x86/kernel/cet.c
+++ b/arch/x86/kernel/cet.c
@@ -56,7 +56,7 @@ static void do_user_cp_fault(struct pt_regs *regs, unsigned long error_code)
 	 * will be whatever is live in userspace. So read the SSP before enabling
 	 * interrupts so locking the fpregs to do it later is not required.
 	 */
-	rdmsrq(MSR_IA32_PL3_SSP, ssp);
+	ssp = rdmsrq(MSR_IA32_PL3_SSP);
 
 	cond_local_irq_enable(regs);
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 3972966cb023..1714bd67604d 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -160,7 +160,7 @@ static void init_amd_k6(struct cpuinfo_x86 *c)
 		if (mbytes > 508)
 			mbytes = 508;
 
-		rdmsrq(MSR_K6_WHCR, val.q);
+		val.q = rdmsrq(MSR_K6_WHCR);
 		if ((val.l & 0x0000FFFF) == 0) {
 			unsigned long flags;
 			val.l = (1 << 0) | ((mbytes / 4) << 1);
@@ -181,7 +181,7 @@ static void init_amd_k6(struct cpuinfo_x86 *c)
 		if (mbytes > 4092)
 			mbytes = 4092;
 
-		rdmsrq(MSR_K6_WHCR, val.q);
+		val.q = rdmsrq(MSR_K6_WHCR);
 		if ((val.l & 0xFFFF0000) == 0) {
 			unsigned long flags;
 			val.l = ((mbytes >> 2) << 22) | (1 << 16);
@@ -228,7 +228,7 @@ static void init_amd_k7(struct cpuinfo_x86 *c)
 	 * As per AMD technical note 27212 0.2
 	 */
 	if ((c->x86_model == 8 && c->x86_stepping >= 1) || (c->x86_model > 8)) {
-		rdmsrq(MSR_K7_CLK_CTL, val.q);
+		val.q = rdmsrq(MSR_K7_CLK_CTL);
 		if ((val.l & 0xfff00000) != 0x20000000) {
 			pr_info("CPU: CLK_CTL MSR was %x. Reprogramming to %x\n",
 				val.l, ((val.l & 0x000fffff) | 0x20000000));
@@ -429,7 +429,7 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
 		    (c->x86 == 0x10 && c->x86_model >= 0x2)) {
 			u64 val;
 
-			rdmsrq(MSR_K7_HWCR, val);
+			val = rdmsrq(MSR_K7_HWCR);
 			if (!(val & BIT(24)))
 				pr_warn(FW_BUG "TSC doesn't count with P0 frequency!\n");
 		}
@@ -583,7 +583,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 	 */
 	if (cpu_has(c, X86_FEATURE_SME) || cpu_has(c, X86_FEATURE_SEV)) {
 		/* Check if memory encryption is enabled */
-		rdmsrq(MSR_AMD64_SYSCFG, msr);
+		msr = rdmsrq(MSR_AMD64_SYSCFG);
 		if (!(msr & MSR_AMD64_SYSCFG_MEM_ENCRYPT))
 			goto clear_all;
 
@@ -600,7 +600,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 		if (!sme_me_mask)
 			setup_clear_cpu_cap(X86_FEATURE_SME);
 
-		rdmsrq(MSR_K7_HWCR, msr);
+		msr = rdmsrq(MSR_K7_HWCR);
 		if (!(msr & MSR_K7_HWCR_SMMLOCK))
 			goto clear_sev;
 
@@ -1115,7 +1115,7 @@ static void init_amd(struct cpuinfo_x86 *c)
 	init_amd_cacheinfo(c);
 
 	if (cpu_has(c, X86_FEATURE_SVM)) {
-		rdmsrq(MSR_VM_CR, vm_cr);
+		vm_cr = rdmsrq(MSR_VM_CR);
 		if (vm_cr & SVM_VM_CR_SVM_DIS_MASK) {
 			pr_notice_once("SVM disabled (by BIOS) in MSR_VM_CR\n");
 			clear_cpu_cap(c, X86_FEATURE_SVM);
diff --git a/arch/x86/kernel/cpu/aperfmperf.c b/arch/x86/kernel/cpu/aperfmperf.c
index 7ffc78d5ebf2..492dc9a11d6b 100644
--- a/arch/x86/kernel/cpu/aperfmperf.c
+++ b/arch/x86/kernel/cpu/aperfmperf.c
@@ -41,8 +41,8 @@ static void init_counter_refs(void *data)
 {
 	u64 aperf, mperf;
 
-	rdmsrq(MSR_IA32_APERF, aperf);
-	rdmsrq(MSR_IA32_MPERF, mperf);
+	aperf = rdmsrq(MSR_IA32_APERF);
+	mperf = rdmsrq(MSR_IA32_MPERF);
 
 	this_cpu_write(cpu_samples.aperf, aperf);
 	this_cpu_write(cpu_samples.mperf, mperf);
@@ -479,8 +479,8 @@ void arch_scale_freq_tick(void)
 	if (!cpu_feature_enabled(X86_FEATURE_APERFMPERF))
 		return;
 
-	rdmsrq(MSR_IA32_APERF, aperf);
-	rdmsrq(MSR_IA32_MPERF, mperf);
+	aperf = rdmsrq(MSR_IA32_APERF);
+	mperf = rdmsrq(MSR_IA32_MPERF);
 	acnt = aperf - s->aperf;
 	mcnt = mperf - s->mperf;
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 000ebee2d247..5696cfce34d4 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -761,7 +761,7 @@ void update_srbds_msr(void)
 	if (!boot_cpu_has(X86_FEATURE_SRBDS_CTRL))
 		return;
 
-	rdmsrq(MSR_IA32_MCU_OPT_CTRL, mcu_ctrl);
+	mcu_ctrl = rdmsrq(MSR_IA32_MCU_OPT_CTRL);
 
 	switch (srbds_mitigation) {
 	case SRBDS_MITIGATION_OFF:
@@ -897,7 +897,7 @@ void update_gds_msr(void)
 
 	switch (gds_mitigation) {
 	case GDS_MITIGATION_OFF:
-		rdmsrq(MSR_IA32_MCU_OPT_CTRL, mcu_ctrl);
+		mcu_ctrl = rdmsrq(MSR_IA32_MCU_OPT_CTRL);
 		mcu_ctrl |= GDS_MITG_DIS;
 		break;
 	case GDS_MITIGATION_FULL_LOCKED:
@@ -907,7 +907,7 @@ void update_gds_msr(void)
 		 * CPUs.
 		 */
 	case GDS_MITIGATION_FULL:
-		rdmsrq(MSR_IA32_MCU_OPT_CTRL, mcu_ctrl);
+		mcu_ctrl = rdmsrq(MSR_IA32_MCU_OPT_CTRL);
 		mcu_ctrl &= ~GDS_MITG_DIS;
 		break;
 	case GDS_MITIGATION_FORCE:
@@ -924,7 +924,7 @@ void update_gds_msr(void)
 	 * GDS_MITG_DIS will be ignored if this processor is locked but the boot
 	 * processor was not.
 	 */
-	rdmsrq(MSR_IA32_MCU_OPT_CTRL, mcu_ctrl_after);
+	mcu_ctrl_after = rdmsrq(MSR_IA32_MCU_OPT_CTRL);
 	WARN_ON_ONCE(mcu_ctrl != mcu_ctrl_after);
 }
 
@@ -959,7 +959,7 @@ static void __init gds_select_mitigation(void)
 	if (gds_mitigation == GDS_MITIGATION_FORCE)
 		gds_mitigation = GDS_MITIGATION_FULL;
 
-	rdmsrq(MSR_IA32_MCU_OPT_CTRL, mcu_ctrl);
+	mcu_ctrl = rdmsrq(MSR_IA32_MCU_OPT_CTRL);
 	if (mcu_ctrl & GDS_MITG_LOCKED) {
 		if (gds_mitigation == GDS_MITIGATION_OFF)
 			pr_warn("Mitigation locked. Disable failed.\n");
@@ -3288,7 +3288,7 @@ void __init cpu_select_mitigations(void)
 	 * init code as it is not enumerated and depends on the family.
 	 */
 	if (cpu_feature_enabled(X86_FEATURE_MSR_SPEC_CTRL)) {
-		rdmsrq(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+		x86_spec_ctrl_base = rdmsrq(MSR_IA32_SPEC_CTRL);
 
 		/*
 		 * Previously running kernel (kexec), may have some controls
diff --git a/arch/x86/kernel/cpu/bus_lock.c b/arch/x86/kernel/cpu/bus_lock.c
index 177f964d4d36..cf853af86ae4 100644
--- a/arch/x86/kernel/cpu/bus_lock.c
+++ b/arch/x86/kernel/cpu/bus_lock.c
@@ -105,7 +105,7 @@ static bool split_lock_verify_msr(bool on)
 		ctrl &= ~MSR_TEST_CTRL_SPLIT_LOCK_DETECT;
 	if (wrmsrq_safe(MSR_TEST_CTRL, ctrl))
 		return false;
-	rdmsrq(MSR_TEST_CTRL, tmp);
+	tmp = rdmsrq(MSR_TEST_CTRL);
 	return ctrl == tmp;
 }
 
@@ -145,7 +145,7 @@ static void __init __split_lock_setup(void)
 		return;
 	}
 
-	rdmsrq(MSR_TEST_CTRL, msr_test_ctrl_cache);
+	msr_test_ctrl_cache = rdmsrq(MSR_TEST_CTRL);
 
 	if (!split_lock_verify_msr(true)) {
 		pr_info("MSR access failed: Disabled\n");
@@ -305,7 +305,7 @@ void bus_lock_init(void)
 	if (!boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT))
 		return;
 
-	rdmsrq(MSR_IA32_DEBUGCTLMSR, val);
+	val = rdmsrq(MSR_IA32_DEBUGCTLMSR);
 
 	if ((boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
 	    (sld_state == sld_warn || sld_state == sld_fatal)) ||
@@ -383,7 +383,7 @@ static void __init split_lock_setup(struct cpuinfo_x86 *c)
 	 * MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT is.  All CPUs that set
 	 * it have split lock detection.
 	 */
-	rdmsrq(MSR_IA32_CORE_CAPS, ia32_core_caps);
+	ia32_core_caps = rdmsrq(MSR_IA32_CORE_CAPS);
 	if (ia32_core_caps & MSR_IA32_CORE_CAPS_SPLIT_LOCK_DETECT)
 		goto supported;
 
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index 513fa1f640f9..6cd89b5ac9de 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -30,7 +30,7 @@ static void init_c3(struct cpuinfo_x86 *c)
 
 		/* enable ACE unit, if present and disabled */
 		if ((tmp & (ACE_PRESENT | ACE_ENABLED)) == ACE_PRESENT) {
-			rdmsrq(MSR_VIA_FCR, msr);
+			msr = rdmsrq(MSR_VIA_FCR);
 			/* enable ACE unit */
 			wrmsrq(MSR_VIA_FCR, msr | ACE_FCR);
 			pr_info("CPU: Enabled ACE h/w crypto\n");
@@ -38,7 +38,7 @@ static void init_c3(struct cpuinfo_x86 *c)
 
 		/* enable RNG unit, if present and disabled */
 		if ((tmp & (RNG_PRESENT | RNG_ENABLED)) == RNG_PRESENT) {
-			rdmsrq(MSR_VIA_RNG, msr);
+			msr = rdmsrq(MSR_VIA_RNG);
 			/* enable RNG unit */
 			wrmsrq(MSR_VIA_RNG, msr | RNG_ENABLE);
 			pr_info("CPU: Enabled h/w RNG\n");
@@ -52,7 +52,7 @@ static void init_c3(struct cpuinfo_x86 *c)
 #ifdef CONFIG_X86_32
 	/* Cyrix III family needs CX8 & PGE explicitly enabled. */
 	if (c->x86_model >= 6 && c->x86_model <= 13) {
-		rdmsrq(MSR_VIA_FCR, msr);
+		msr = rdmsrq(MSR_VIA_FCR);
 		wrmsrq(MSR_VIA_FCR, msr | (1 << 1 | 1 << 7));
 		set_cpu_cap(c, X86_FEATURE_CX8);
 	}
@@ -169,7 +169,7 @@ static void init_centaur(struct cpuinfo_x86 *c)
 			name = "??";
 		}
 
-		rdmsrq(MSR_IDT_FCR1, val.q);
+		val.q = rdmsrq(MSR_IDT_FCR1);
 		newlo = (val.l | fcr_set) & (~fcr_clr);
 
 		if (newlo != val.l) {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 9bd50c68cd7e..631d3cef9fa0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -346,7 +346,7 @@ static void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
 
 	/* Disable processor serial number: */
 
-	rdmsrq(MSR_IA32_BBL_CR_CTL, val.q);
+	val.q = rdmsrq(MSR_IA32_BBL_CR_CTL);
 	val.l |= 0x200000;
 	wrmsrq(MSR_IA32_BBL_CR_CTL, val.q);
 
@@ -607,7 +607,7 @@ __noendbr u64 ibt_save(bool disable)
 	u64 msr = 0;
 
 	if (cpu_feature_enabled(X86_FEATURE_IBT)) {
-		rdmsrq(MSR_IA32_S_CET, msr);
+		msr = rdmsrq(MSR_IA32_S_CET);
 		if (disable)
 			wrmsrq(MSR_IA32_S_CET, msr & ~CET_ENDBR_EN);
 	}
@@ -620,7 +620,7 @@ __noendbr void ibt_restore(u64 save)
 	u64 msr;
 
 	if (cpu_feature_enabled(X86_FEATURE_IBT)) {
-		rdmsrq(MSR_IA32_S_CET, msr);
+		msr = rdmsrq(MSR_IA32_S_CET);
 		msr &= ~CET_ENDBR_EN;
 		msr |= (save & CET_ENDBR_EN);
 		wrmsrq(MSR_IA32_S_CET, msr);
@@ -1356,7 +1356,7 @@ u64 x86_read_arch_cap_msr(void)
 	u64 x86_arch_cap_msr = 0;
 
 	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
-		rdmsrq(MSR_IA32_ARCH_CAPABILITIES, x86_arch_cap_msr);
+		x86_arch_cap_msr = rdmsrq(MSR_IA32_ARCH_CAPABILITIES);
 
 	return x86_arch_cap_msr;
 }
@@ -1947,10 +1947,10 @@ static bool detect_null_seg_behavior(void)
 	 */
 
 	unsigned long old_base, tmp;
-	rdmsrq(MSR_FS_BASE, old_base);
+	old_base = rdmsrq(MSR_FS_BASE);
 	wrmsrq(MSR_FS_BASE, 1);
 	loadsegment(fs, 0);
-	rdmsrq(MSR_FS_BASE, tmp);
+	tmp = rdmsrq(MSR_FS_BASE);
 	wrmsrq(MSR_FS_BASE, old_base);
 	return tmp == 0;
 }
diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index 10a92927a515..7228fc2bb43e 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -40,7 +40,7 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
 	 * as they exist on any CPU that supports VMX, i.e. we want the WARN if
 	 * the RDMSR faults.
 	 */
-	rdmsrq(MSR_IA32_VMX_PROCBASED_CTLS, val.q);
+	val.q = rdmsrq(MSR_IA32_VMX_PROCBASED_CTLS);
 	supported = val.h;
 	c->vmx_capability[PRIMARY_CTLS] = supported;
 
@@ -53,7 +53,7 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
 	c->vmx_capability[TERTIARY_CTLS_LOW] = val.l;
 	c->vmx_capability[TERTIARY_CTLS_HIGH] = val.h;
 
-	rdmsrq(MSR_IA32_VMX_PINBASED_CTLS, val.q);
+	val.q = rdmsrq(MSR_IA32_VMX_PINBASED_CTLS);
 	supported = val.h;
 	rdmsrq_safe(MSR_IA32_VMX_VMFUNC, &val.q);
 	funcs = val.h;
diff --git a/arch/x86/kernel/cpu/hygon.c b/arch/x86/kernel/cpu/hygon.c
index ec51c2b9a257..44b462799cf6 100644
--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -99,7 +99,7 @@ static void bsp_init_hygon(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
 		u64 val;
 
-		rdmsrq(MSR_K7_HWCR, val);
+		val = rdmsrq(MSR_K7_HWCR);
 		if (!(val & BIT(24)))
 			pr_warn(FW_BUG "TSC doesn't count with P0 frequency!\n");
 	}
@@ -194,7 +194,7 @@ static void init_hygon(struct cpuinfo_x86 *c)
 	init_hygon_cacheinfo(c);
 
 	if (cpu_has(c, X86_FEATURE_SVM)) {
-		rdmsrq(MSR_VM_CR, vm_cr);
+		vm_cr = rdmsrq(MSR_VM_CR);
 		if (vm_cr & SVM_VM_CR_SVM_DIS_MASK) {
 			pr_notice_once("SVM disabled (by BIOS) in MSR_VM_CR\n");
 			clear_cpu_cap(c, X86_FEATURE_SVM);
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 4297ceb2cb24..2aabe9affa0c 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -159,7 +159,7 @@ static void detect_tme_early(struct cpuinfo_x86 *c)
 	u64 tme_activate;
 	int keyid_bits;
 
-	rdmsrq(MSR_IA32_TME_ACTIVATE, tme_activate);
+	tme_activate = rdmsrq(MSR_IA32_TME_ACTIVATE);
 
 	if (!TME_ACTIVATE_LOCKED(tme_activate) || !TME_ACTIVATE_ENABLED(tme_activate)) {
 		pr_info_once("x86/tme: not enabled by BIOS\n");
@@ -335,7 +335,7 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 	 * string flag and enhanced fast string capabilities accordingly.
 	 */
 	if (c->x86_vfm >= INTEL_PENTIUM_M_DOTHAN) {
-		rdmsrq(MSR_IA32_MISC_ENABLE, misc_enable);
+		misc_enable = rdmsrq(MSR_IA32_MISC_ENABLE);
 		if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
 			/* X86_FEATURE_ERMS is set based on CPUID */
 			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
@@ -579,7 +579,7 @@ static void init_intel(struct cpuinfo_x86 *c)
 	if (boot_cpu_has(X86_FEATURE_DS)) {
 		u64 l;
 
-		rdmsrq(MSR_IA32_MISC_ENABLE, l);
+		l = rdmsrq(MSR_IA32_MISC_ENABLE);
 		if (!(l & MSR_IA32_MISC_ENABLE_BTS_UNAVAIL))
 			set_cpu_cap(c, X86_FEATURE_BTS);
 		if (!(l & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL))
diff --git a/arch/x86/kernel/cpu/intel_epb.c b/arch/x86/kernel/cpu/intel_epb.c
index 2c56f8730f59..a02d562253d9 100644
--- a/arch/x86/kernel/cpu/intel_epb.c
+++ b/arch/x86/kernel/cpu/intel_epb.c
@@ -79,7 +79,7 @@ static int intel_epb_save(void *data)
 {
 	u64 epb;
 
-	rdmsrq(MSR_IA32_ENERGY_PERF_BIAS, epb);
+	epb = rdmsrq(MSR_IA32_ENERGY_PERF_BIAS);
 	/*
 	 * Ensure that saved_epb will always be nonzero after this write even if
 	 * the EPB value read from the MSR is 0.
@@ -94,7 +94,7 @@ static void intel_epb_restore(void *data)
 	u64 val = this_cpu_read(saved_epb);
 	u64 epb;
 
-	rdmsrq(MSR_IA32_ENERGY_PERF_BIAS, epb);
+	epb = rdmsrq(MSR_IA32_ENERGY_PERF_BIAS);
 	if (val) {
 		val &= EPB_MASK;
 	} else {
diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index 1cc20b855b7e..9695af953299 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -438,7 +438,7 @@ static void threshold_restart_block(void *_tr)
 	if (!this_cpu_read(threshold_banks) && !tr->set_lvt_off)
 		return;
 
-	rdmsrq(tr->b->address, val.q);
+	val.q = rdmsrq(tr->b->address);
 
 	/*
 	 * Reset error count and overflow bit.
@@ -658,7 +658,7 @@ static void disable_err_thresholding(struct cpuinfo_x86 *c, unsigned int bank)
 		return;
 	}
 
-	rdmsrq(MSR_K7_HWCR, hwcr);
+	hwcr = rdmsrq(MSR_K7_HWCR);
 
 	/* McStatusWrEn has to be set */
 	need_toggle = !(hwcr & BIT(18));
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 50b1614968be..33d54728a5a3 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1845,7 +1845,7 @@ static void __mcheck_cpu_cap_init(void)
 	u64 cap;
 	u8 b;
 
-	rdmsrq(MSR_IA32_MCG_CAP, cap);
+	cap = rdmsrq(MSR_IA32_MCG_CAP);
 
 	b = cap & MCG_BANKCNT_MASK;
 
@@ -1864,7 +1864,7 @@ static void __mcheck_cpu_init_generic(void)
 {
 	u64 cap;
 
-	rdmsrq(MSR_IA32_MCG_CAP, cap);
+	cap = rdmsrq(MSR_IA32_MCG_CAP);
 	if (cap & MCG_CTL_P)
 		wrmsrq(MSR_IA32_MCG_CTL, ~0ULL);
 }
@@ -1896,7 +1896,7 @@ static void __mcheck_cpu_init_prepare_banks(void)
 		wrmsrq(mca_msr_reg(i, MCA_CTL), b->ctl);
 		wrmsrq(mca_msr_reg(i, MCA_STATUS), 0);
 
-		rdmsrq(mca_msr_reg(i, MCA_CTL), msrval);
+		msrval = rdmsrq(mca_msr_reg(i, MCA_CTL));
 		b->init = !!msrval;
 	}
 }
@@ -2207,7 +2207,7 @@ void mca_bsp_init(struct cpuinfo_x86 *c)
 	if (mce_flags.smca)
 		smca_bsp_init();
 
-	rdmsrq(MSR_IA32_MCG_CAP, cap);
+	cap = rdmsrq(MSR_IA32_MCG_CAP);
 
 	/* Use accurate RIP reporting if available. */
 	if ((cap & MCG_EXT_P) && MCG_EXT_CNT(cap) >= 9)
diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index 6f8a49d8baeb..aa933864f32e 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -743,7 +743,7 @@ static void check_hw_inj_possible(void)
 		u64 status = MCI_STATUS_VAL, ipid;
 
 		/* Check whether bank is populated */
-		rdmsrq(MSR_AMD64_SMCA_MCx_IPID(bank), ipid);
+		ipid = rdmsrq(MSR_AMD64_SMCA_MCx_IPID(bank));
 		if (!ipid)
 			continue;
 
diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
index 4655223ba560..2edb05d5e2d7 100644
--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -94,7 +94,7 @@ static bool cmci_supported(int *banks)
 	if (!boot_cpu_has(X86_FEATURE_APIC) || lapic_get_maxlvt() < 6)
 		return false;
 
-	rdmsrq(MSR_IA32_MCG_CAP, cap);
+	cap = rdmsrq(MSR_IA32_MCG_CAP);
 	*banks = min_t(unsigned, MAX_NR_BANKS, cap & MCG_BANKCNT_MASK);
 	return !!(cap & MCG_CMCI_P);
 }
@@ -106,7 +106,7 @@ static bool lmce_supported(void)
 	if (mca_cfg.lmce_disabled)
 		return false;
 
-	rdmsrq(MSR_IA32_MCG_CAP, tmp);
+	tmp = rdmsrq(MSR_IA32_MCG_CAP);
 
 	/*
 	 * LMCE depends on recovery support in the processor. Hence both
@@ -123,7 +123,7 @@ static bool lmce_supported(void)
 	 * WARN if the MSR isn't locked as init_ia32_feat_ctl() unconditionally
 	 * locks the MSR in the event that it wasn't already locked by BIOS.
 	 */
-	rdmsrq(MSR_IA32_FEAT_CTL, tmp);
+	tmp = rdmsrq(MSR_IA32_FEAT_CTL);
 	if (WARN_ON_ONCE(!(tmp & FEAT_CTL_LOCKED)))
 		return false;
 
@@ -141,7 +141,7 @@ static void cmci_set_threshold(int bank, int thresh)
 	u64 val;
 
 	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
-	rdmsrq(MSR_IA32_MCx_CTL2(bank), val);
+	val = rdmsrq(MSR_IA32_MCx_CTL2(bank));
 	val &= ~MCI_CTL2_CMCI_THRESHOLD_MASK;
 	wrmsrq(MSR_IA32_MCx_CTL2(bank), val | thresh);
 	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
@@ -184,7 +184,7 @@ static bool cmci_skip_bank(int bank, u64 *val)
 	if (test_bit(bank, mce_banks_ce_disabled))
 		return true;
 
-	rdmsrq(MSR_IA32_MCx_CTL2(bank), *val);
+	*val = rdmsrq(MSR_IA32_MCx_CTL2(bank));
 
 	/* Already owned by someone else? */
 	if (*val & MCI_CTL2_CMCI_EN) {
@@ -233,7 +233,7 @@ static void cmci_claim_bank(int bank, u64 val, int bios_zero_thresh, int *bios_w
 
 	val |= MCI_CTL2_CMCI_EN;
 	wrmsrq(MSR_IA32_MCx_CTL2(bank), val);
-	rdmsrq(MSR_IA32_MCx_CTL2(bank), val);
+	val = rdmsrq(MSR_IA32_MCx_CTL2(bank));
 
 	/* If the enable bit did not stick, this bank should be polled. */
 	if (!(val & MCI_CTL2_CMCI_EN)) {
@@ -324,7 +324,7 @@ static void __cmci_disable_bank(int bank)
 
 	if (!test_bit(bank, this_cpu_ptr(mce_banks_owned)))
 		return;
-	rdmsrq(MSR_IA32_MCx_CTL2(bank), val);
+	val = rdmsrq(MSR_IA32_MCx_CTL2(bank));
 	val &= ~MCI_CTL2_CMCI_EN;
 	wrmsrq(MSR_IA32_MCx_CTL2(bank), val);
 	__clear_bit(bank, this_cpu_ptr(mce_banks_owned));
@@ -430,7 +430,7 @@ void intel_init_lmce(void)
 	if (!lmce_supported())
 		return;
 
-	rdmsrq(MSR_IA32_MCG_EXT_CTL, val);
+	val = rdmsrq(MSR_IA32_MCG_EXT_CTL);
 
 	if (!(val & MCG_EXT_CTL_LMCE_EN))
 		wrmsrq(MSR_IA32_MCG_EXT_CTL, val | MCG_EXT_CTL_LMCE_EN);
@@ -443,7 +443,7 @@ void intel_clear_lmce(void)
 	if (!lmce_supported())
 		return;
 
-	rdmsrq(MSR_IA32_MCG_EXT_CTL, val);
+	val = rdmsrq(MSR_IA32_MCG_EXT_CTL);
 	val &= ~MCG_EXT_CTL_LMCE_EN;
 	wrmsrq(MSR_IA32_MCG_EXT_CTL, val);
 }
diff --git a/arch/x86/kernel/cpu/mce/p5.c b/arch/x86/kernel/cpu/mce/p5.c
index 3c2b6cc918b1..b441c720f9b7 100644
--- a/arch/x86/kernel/cpu/mce/p5.c
+++ b/arch/x86/kernel/cpu/mce/p5.c
@@ -26,8 +26,8 @@ noinstr void pentium_machine_check(struct pt_regs *regs)
 	u64 addr, type;
 
 	instrumentation_begin();
-	rdmsrq(MSR_IA32_P5_MC_ADDR, addr);
-	rdmsrq(MSR_IA32_P5_MC_TYPE, type);
+	addr = rdmsrq(MSR_IA32_P5_MC_ADDR);
+	type = rdmsrq(MSR_IA32_P5_MC_TYPE);
 
 	pr_emerg("CPU#%d: Machine Check Exception:  0x%8X (type 0x%8X).\n",
 		 smp_processor_id(), (u32)addr, (u32)type);
@@ -55,8 +55,8 @@ void intel_p5_mcheck_init(struct cpuinfo_x86 *c)
 		return;
 
 	/* Read registers before enabling: */
-	rdmsrq(MSR_IA32_P5_MC_ADDR, q);
-	rdmsrq(MSR_IA32_P5_MC_TYPE, q);
+	q = rdmsrq(MSR_IA32_P5_MC_ADDR);
+	q = rdmsrq(MSR_IA32_P5_MC_TYPE);
 	pr_info("Intel old style machine check architecture supported.\n");
 
 	/* Enable MCE: */
diff --git a/arch/x86/kernel/cpu/mce/winchip.c b/arch/x86/kernel/cpu/mce/winchip.c
index 7040243533d9..7b967f2abd8f 100644
--- a/arch/x86/kernel/cpu/mce/winchip.c
+++ b/arch/x86/kernel/cpu/mce/winchip.c
@@ -30,7 +30,7 @@ void winchip_mcheck_init(struct cpuinfo_x86 *c)
 {
 	struct msr val;
 
-	rdmsrq(MSR_IDT_FCR1, val.q);
+	val.q = rdmsrq(MSR_IDT_FCR1);
 	val.l |= (1<<2);	/* Enable EIERRINT (int 18 MCE) */
 	val.l &= ~(1<<4);	/* Enable MCE */
 	wrmsrq(MSR_IDT_FCR1, val.q);
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 9f09d388ed20..7d481d28fcdb 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -1017,7 +1017,7 @@ static __init bool staging_available(void)
 	if (!(val & ARCH_CAP_MCU_ENUM))
 		return false;
 
-	rdmsrq(MSR_IA32_MCU_ENUMERATION, val);
+	val = rdmsrq(MSR_IA32_MCU_ENUMERATION);
 	return !!(val & MCU_STAGING);
 }
 
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index b4af7c0a70ac..e1388ed27384 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -74,7 +74,7 @@ u64 hv_get_non_nested_msr(unsigned int reg)
 	if (hv_is_synic_msr(reg) && ms_hyperv.paravisor_present)
 		hv_ivm_msr_read(reg, &value);
 	else
-		rdmsrq(reg, value);
+		value = rdmsrq(reg);
 	return value;
 }
 EXPORT_SYMBOL_GPL(hv_get_non_nested_msr);
@@ -399,7 +399,7 @@ static unsigned long hv_get_tsc_khz(void)
 {
 	unsigned long freq;
 
-	rdmsrq(HV_X64_MSR_TSC_FREQUENCY, freq);
+	freq = rdmsrq(HV_X64_MSR_TSC_FREQUENCY);
 
 	return freq / 1000;
 }
@@ -660,7 +660,7 @@ static void __init ms_hyperv_init_platform(void)
 		 */
 		u64	hv_lapic_frequency;
 
-		rdmsrq(HV_X64_MSR_APIC_FREQUENCY, hv_lapic_frequency);
+		hv_lapic_frequency = rdmsrq(HV_X64_MSR_APIC_FREQUENCY);
 		hv_lapic_frequency = div_u64(hv_lapic_frequency, HZ);
 		lapic_timer_period = hv_lapic_frequency;
 		pr_info("Hyper-V: LAPIC Timer Frequency: %#x\n",
diff --git a/arch/x86/kernel/cpu/mtrr/amd.c b/arch/x86/kernel/cpu/mtrr/amd.c
index 9e440e30c179..b3d4529799da 100644
--- a/arch/x86/kernel/cpu/mtrr/amd.c
+++ b/arch/x86/kernel/cpu/mtrr/amd.c
@@ -13,7 +13,7 @@ amd_get_mtrr(unsigned int reg, unsigned long *base,
 	unsigned long val;
 	struct msr msr;
 
-	rdmsrq(MSR_K6_UWCCR, msr.q);
+	msr.q = rdmsrq(MSR_K6_UWCCR);
 	/* Upper dword is region 1, lower is region 0 */
 	if (reg == 1)
 		val = msr.h;
@@ -67,7 +67,7 @@ amd_set_mtrr(unsigned int reg, unsigned long base, unsigned long size, mtrr_type
 	/*
 	 * Low is MTRR0, High MTRR 1
 	 */
-	rdmsrq(MSR_K6_UWCCR, msr.q);
+	msr.q = rdmsrq(MSR_K6_UWCCR);
 	regs[0] = msr.l;
 	regs[1] = msr.h;
 
diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index cd1a6dec4064..2b72c784db9e 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -670,7 +670,7 @@ int __init mtrr_cleanup(void)
 	if (!cpu_feature_enabled(X86_FEATURE_MTRR) || enable_mtrr_cleanup < 1)
 		return 0;
 
-	rdmsrq(MSR_MTRRdefType, def);
+	def = rdmsrq(MSR_MTRRdefType);
 	def &= 0xff;
 	if (def != MTRR_TYPE_UNCACHABLE)
 		return 0;
@@ -870,7 +870,7 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 	if (!cpu_feature_enabled(X86_FEATURE_MTRR) || disable_mtrr_trim)
 		return 0;
 
-	rdmsrq(MSR_MTRRdefType, def);
+	def = rdmsrq(MSR_MTRRdefType);
 	def &= MTRR_DEF_TYPE_TYPE;
 	if (def != MTRR_TYPE_UNCACHABLE)
 		return 0;
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 67cf69f24b00..4d8034a7fdc8 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -112,7 +112,7 @@ static inline void k8_check_syscfg_dram_mod_en(void)
 	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return;
 
-	rdmsrq(MSR_AMD64_SYSCFG, val.q);
+	val.q = rdmsrq(MSR_AMD64_SYSCFG);
 	if (val.l & K8_MTRRFIXRANGE_DRAM_MODIFY) {
 		pr_err(FW_WARN "MTRR: CPU %u: SYSCFG[MtrrFixDramModEn]"
 		       " not cleared by BIOS, clearing this bit\n",
@@ -559,10 +559,10 @@ get_mtrr_var_range(unsigned int index, struct mtrr_var_range *vr)
 {
 	struct msr val;
 
-	rdmsrq(MTRRphysBase_MSR(index), val.q);
+	val.q = rdmsrq(MTRRphysBase_MSR(index));
 	vr->base_lo = val.l;
 	vr->base_hi = val.h;
-	rdmsrq(MTRRphysMask_MSR(index), val.q);
+	val.q = rdmsrq(MTRRphysMask_MSR(index));
 	vr->mask_lo = val.l;
 	vr->mask_hi = val.h;
 }
@@ -588,12 +588,12 @@ static void get_fixed_ranges(mtrr_type *frs)
 
 	k8_check_syscfg_dram_mod_en();
 
-	rdmsrq(MSR_MTRRfix64K_00000, p[0]);
+	p[0] = rdmsrq(MSR_MTRRfix64K_00000);
 
 	for (i = 0; i < 2; i++)
-		rdmsrq(MSR_MTRRfix16K_80000 + i, p[1 + i]);
+		p[1 + i] = rdmsrq(MSR_MTRRfix16K_80000 + i);
 	for (i = 0; i < 8; i++)
-		rdmsrq(MSR_MTRRfix4K_C0000 + i, p[3 + i]);
+		p[3 + i] = rdmsrq(MSR_MTRRfix4K_C0000 + i);
 }
 
 void mtrr_save_fixed_ranges(void *info)
@@ -700,7 +700,7 @@ bool __init get_mtrr_state(void)
 
 	vrs = mtrr_state.var_ranges;
 
-	rdmsrq(MSR_MTRRcap, q);
+	q = rdmsrq(MSR_MTRRcap);
 	mtrr_state.have_fixed = q & MTRR_CAP_FIX;
 
 	for (i = 0; i < num_var_ranges; i++)
@@ -708,13 +708,13 @@ bool __init get_mtrr_state(void)
 	if (mtrr_state.have_fixed)
 		get_fixed_ranges(mtrr_state.fixed_ranges);
 
-	rdmsrq(MSR_MTRRdefType, q);
+	q = rdmsrq(MSR_MTRRdefType);
 	mtrr_state.def_type = q & MTRR_DEF_TYPE_TYPE;
 	mtrr_state.enabled = (q & MTRR_DEF_TYPE_ENABLE) >> MTRR_STATE_SHIFT;
 
 	if (amd_special_default_mtrr()) {
 		/* TOP_MEM2 */
-		rdmsrq(MSR_K8_TOP_MEM2, mtrr_tom2);
+		mtrr_tom2 = rdmsrq(MSR_K8_TOP_MEM2);
 		mtrr_tom2 &= 0xffffff800000ULL;
 	}
 
@@ -770,7 +770,7 @@ static void set_fixed_range(int msr, bool *changed, unsigned int *msrwords)
 {
 	struct msr val;
 
-	rdmsrq(msr, val.q);
+	val.q = rdmsrq(msr);
 
 	if (val.l != msrwords[0] || val.h != msrwords[1]) {
 		mtrr_wrmsr(msr, msrwords[0], msrwords[1]);
@@ -818,7 +818,7 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 	 */
 	get_cpu();
 
-	rdmsrq(MTRRphysMask_MSR(reg), mask);
+	mask = rdmsrq(MTRRphysMask_MSR(reg));
 
 	if (!(mask & MTRR_PHYSMASK_V)) {
 		/*  Invalid (i.e. free) range */
@@ -828,7 +828,7 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 		goto out_put_cpu;
 	}
 
-	rdmsrq(MTRRphysBase_MSR(reg), base_msr);
+	base_msr = rdmsrq(MTRRphysBase_MSR(reg));
 
 	/* Work out the shifted address mask: */
 	tmp = mask & PAGE_MASK;
@@ -889,7 +889,7 @@ static bool set_mtrr_var_ranges(unsigned int index, struct mtrr_var_range *vr)
 	bool changed = false;
 	struct msr val;
 
-	rdmsrq(MTRRphysBase_MSR(index), val.q);
+	val.q = rdmsrq(MTRRphysBase_MSR(index));
 	if ((vr->base_lo & ~MTRR_PHYSBASE_RSVD) != (val.l & ~MTRR_PHYSBASE_RSVD)
 	    || (vr->base_hi & ~phys_hi_rsvd) != (val.h & ~phys_hi_rsvd)) {
 
@@ -897,7 +897,7 @@ static bool set_mtrr_var_ranges(unsigned int index, struct mtrr_var_range *vr)
 		changed = true;
 	}
 
-	rdmsrq(MTRRphysMask_MSR(index), val.q);
+	val.q = rdmsrq(MTRRphysMask_MSR(index));
 
 	if ((vr->mask_lo & ~MTRR_PHYSMASK_RSVD) != (val.l & ~MTRR_PHYSMASK_RSVD)
 	    || (vr->mask_hi & ~phys_hi_rsvd) != (val.h & ~phys_hi_rsvd)) {
@@ -952,7 +952,7 @@ void mtrr_disable(void)
 	struct msr val;
 
 	/* Save MTRR state */
-	rdmsrq(MSR_MTRRdefType, val.q);
+	val.q = rdmsrq(MSR_MTRRdefType);
 	deftype_lo = val.l;
 	deftype_hi = val.h;
 
@@ -1065,7 +1065,7 @@ static int generic_have_wrcomb(void)
 {
 	u64 config;
 
-	rdmsrq(MSR_MTRRcap, config);
+	config = rdmsrq(MSR_MTRRcap);
 	return config & MTRR_CAP_WC;
 }
 
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.c b/arch/x86/kernel/cpu/mtrr/mtrr.c
index 468c53b20acf..9b7abd58b677 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.c
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.c
@@ -571,7 +571,7 @@ void __init mtrr_bp_init(void)
 	if (mtrr_enabled()) {
 		/* Get the number of variable MTRR ranges. */
 		if (mtrr_if == &generic_mtrr_ops)
-			rdmsrq(MSR_MTRRcap, config);
+			config = rdmsrq(MSR_MTRRcap);
 		else
 			config = mtrr_if->var_regs;
 		num_var_ranges = config & MTRR_CAP_VCNT;
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 55214d6fdc49..dd0e20179fce 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -165,7 +165,7 @@ static inline void cache_alloc_hsw_probe(void)
 	if (wrmsrq_safe(MSR_IA32_L3_CBM_BASE, max_cbm))
 		return;
 
-	rdmsrq(MSR_IA32_L3_CBM_BASE, l3_cbm_0);
+	l3_cbm_0 = rdmsrq(MSR_IA32_L3_CBM_BASE);
 
 	/* If all the bits were set in MSR, return success */
 	if (l3_cbm_0 != max_cbm)
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 3838e0a13d36..530c425d7ee4 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -147,7 +147,7 @@ static int __rmid_read_phys(u32 prmid, enum resctrl_event_id eventid, u64 *val)
 	 * are error bits.
 	 */
 	wrmsrq(MSR_IA32_QM_EVTSEL, msr_val.q);
-	rdmsrq(MSR_IA32_QM_CTR, msr_val.q);
+	msr_val.q = rdmsrq(MSR_IA32_QM_CTR);
 
 	if (msr_val.q & RMID_VAL_ERROR)
 		return -EIO;
@@ -310,7 +310,7 @@ static int __cntr_id_read(u32 cntr_id, u64 *val)
 	 * is set if the counter data is unavailable.
 	 */
 	wrmsrq(MSR_IA32_QM_EVTSEL, msr_val.q);
-	rdmsrq(MSR_IA32_QM_CTR, msr_val.q);
+	msr_val.q = rdmsrq(MSR_IA32_QM_CTR);
 
 	if (msr_val.q & RMID_VAL_ERROR)
 		return -EIO;
diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index d7caab0409b6..0408ac7f66fd 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -250,7 +250,7 @@ int resctrl_arch_measure_cycles_lat_fn(void *_plr)
 	/*
 	 * Disable hardware prefetchers.
 	 */
-	rdmsrq(MSR_MISC_FEATURE_CONTROL, saved);
+	saved = rdmsrq(MSR_MISC_FEATURE_CONTROL);
 	wrmsrq(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits);
 	mem_r = READ_ONCE(plr->kmem);
 	/*
@@ -346,7 +346,7 @@ static int measure_residency_fn(struct perf_event_attr *miss_attr,
 	/*
 	 * Disable hardware prefetchers.
 	 */
-	rdmsrq(MSR_MISC_FEATURE_CONTROL, saved);
+	saved = rdmsrq(MSR_MISC_FEATURE_CONTROL);
 	wrmsrq(MSR_MISC_FEATURE_CONTROL, prefetch_disable_bits);
 
 	/* Initialize rest of local variables */
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 5ffa39fa86fa..37f0b1f7fe4f 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -96,7 +96,7 @@ void resctrl_arch_mon_event_config_read(void *_config_info)
 		pr_warn_once("Invalid event id %d\n", config_info->evtid);
 		return;
 	}
-	rdmsrq(MSR_IA32_EVT_CFG_BASE + index, msrval);
+	msrval = rdmsrq(MSR_IA32_EVT_CFG_BASE + index);
 
 	/* Report only the valid event configuration bits */
 	config_info->mon_config = msrval & MAX_EVT_CONFIG_BITS;
diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
index 4913b64ec592..68337da5aa09 100644
--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -151,7 +151,7 @@ static __init bool check_for_real_bsp(u32 apic_id)
 	 * kernel must rely on the firmware enumeration order.
 	 */
 	if (has_apic_base) {
-		rdmsrq(MSR_IA32_APICBASE, msr);
+		msr = rdmsrq(MSR_IA32_APICBASE);
 		is_bsp = !!(msr & MSR_IA32_APICBASE_BSP);
 	}
 
diff --git a/arch/x86/kernel/cpu/topology_amd.c b/arch/x86/kernel/cpu/topology_amd.c
index c5a6944df86a..5192f13f3686 100644
--- a/arch/x86/kernel/cpu/topology_amd.c
+++ b/arch/x86/kernel/cpu/topology_amd.c
@@ -140,7 +140,7 @@ static void parse_fam10h_node_id(struct topo_scan *tscan)
 	if (!boot_cpu_has(X86_FEATURE_NODEID_MSR))
 		return;
 
-	rdmsrq(MSR_FAM10H_NODE_ID, nid.msr);
+	nid.msr = rdmsrq(MSR_FAM10H_NODE_ID);
 	store_node(tscan, nid.nodes_per_pkg + 1, nid.node_id);
 	tscan->c->topo.llc_id = nid.node_id;
 }
@@ -168,7 +168,7 @@ static void topoext_fixup(struct topo_scan *tscan)
 			MSR_AMD64_CPUID_EXT_FEAT_TOPOEXT_BIT) <= 0)
 		return;
 
-	rdmsrq(MSR_AMD64_CPUID_EXT_FEAT, msrval);
+	msrval = rdmsrq(MSR_AMD64_CPUID_EXT_FEAT);
 	if (msrval & MSR_AMD64_CPUID_EXT_FEAT_TOPOEXT) {
 		set_cpu_cap(c, X86_FEATURE_TOPOEXT);
 		pr_info_once(FW_INFO "CPU: Re-enabling disabled Topology Extensions Support.\n");
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index 35d498f24e34..f8632becda18 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -87,7 +87,7 @@ static void init_transmeta(struct cpuinfo_x86 *c)
 	}
 
 	/* Unhide possibly hidden capability flags */
-	rdmsrq(0x80860004, msr);
+	msr = rdmsrq(0x80860004);
 	wrmsrq(0x80860004, msr | ~0U);
 	cpuid_refresh_leaf(c, 0x1);
 	c->x86_capability[CPUID_1_EDX] = cpuid_edx(0x00000001);
diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index 209b5a22d880..b500845d2049 100644
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -35,7 +35,7 @@ static void tsx_disable(void)
 {
 	u64 tsx;
 
-	rdmsrq(MSR_IA32_TSX_CTRL, tsx);
+	tsx = rdmsrq(MSR_IA32_TSX_CTRL);
 
 	/* Force all transactions to immediately abort */
 	tsx |= TSX_CTRL_RTM_DISABLE;
@@ -55,7 +55,7 @@ static void tsx_enable(void)
 {
 	u64 tsx;
 
-	rdmsrq(MSR_IA32_TSX_CTRL, tsx);
+	tsx = rdmsrq(MSR_IA32_TSX_CTRL);
 
 	/* Enable the RTM feature in the cpu */
 	tsx &= ~TSX_CTRL_RTM_DISABLE;
@@ -126,11 +126,11 @@ static void tsx_clear_cpuid(void)
 	 */
 	if (boot_cpu_has(X86_FEATURE_RTM_ALWAYS_ABORT) &&
 	    boot_cpu_has(X86_FEATURE_TSX_FORCE_ABORT)) {
-		rdmsrq(MSR_TSX_FORCE_ABORT, msr);
+		msr = rdmsrq(MSR_TSX_FORCE_ABORT);
 		msr |= MSR_TFA_TSX_CPUID_CLEAR;
 		wrmsrq(MSR_TSX_FORCE_ABORT, msr);
 	} else if (cpu_feature_enabled(X86_FEATURE_MSR_TSX_CTRL)) {
-		rdmsrq(MSR_IA32_TSX_CTRL, msr);
+		msr = rdmsrq(MSR_IA32_TSX_CTRL);
 		msr |= TSX_CTRL_CPUID_CLEAR;
 		wrmsrq(MSR_IA32_TSX_CTRL, msr);
 	}
@@ -157,7 +157,7 @@ static void tsx_dev_mode_disable(void)
 	    !cpu_feature_enabled(X86_FEATURE_SRBDS_CTRL))
 		return;
 
-	rdmsrq(MSR_IA32_MCU_OPT_CTRL, mcu_opt_ctrl);
+	mcu_opt_ctrl = rdmsrq(MSR_IA32_MCU_OPT_CTRL);
 
 	if (mcu_opt_ctrl & RTM_ALLOW) {
 		mcu_opt_ctrl &= ~RTM_ALLOW;
diff --git a/arch/x86/kernel/cpu/umwait.c b/arch/x86/kernel/cpu/umwait.c
index e4a31c536642..8c3cf0f95e9a 100644
--- a/arch/x86/kernel/cpu/umwait.c
+++ b/arch/x86/kernel/cpu/umwait.c
@@ -218,7 +218,7 @@ static int __init umwait_init(void)
 	 * changed. This is the only place where orig_umwait_control_cached
 	 * is modified.
 	 */
-	rdmsrq(MSR_IA32_UMWAIT_CONTROL, orig_umwait_control_cached);
+	orig_umwait_control_cached = rdmsrq(MSR_IA32_UMWAIT_CONTROL);
 
 	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "umwait:online",
 				umwait_cpu_online, umwait_cpu_offline);
diff --git a/arch/x86/kernel/cpu/zhaoxin.c b/arch/x86/kernel/cpu/zhaoxin.c
index fe504fd43c77..f89aec38a349 100644
--- a/arch/x86/kernel/cpu/zhaoxin.c
+++ b/arch/x86/kernel/cpu/zhaoxin.c
@@ -29,7 +29,7 @@ static void init_zhaoxin_cap(struct cpuinfo_x86 *c)
 
 		/* Enable ACE unit, if present and disabled */
 		if ((tmp & (ACE_PRESENT | ACE_ENABLED)) == ACE_PRESENT) {
-			rdmsrq(MSR_ZHAOXIN_FCR57, msr);
+			msr = rdmsrq(MSR_ZHAOXIN_FCR57);
 			/* Enable ACE unit */
 			wrmsrq(MSR_ZHAOXIN_FCR57, msr | ACE_FCR);
 			pr_info("CPU: Enabled ACE h/w crypto\n");
@@ -37,7 +37,7 @@ static void init_zhaoxin_cap(struct cpuinfo_x86 *c)
 
 		/* Enable RNG unit, if present and disabled */
 		if ((tmp & (RNG_PRESENT | RNG_ENABLED)) == RNG_PRESENT) {
-			rdmsrq(MSR_ZHAOXIN_FCR57, msr);
+			msr = rdmsrq(MSR_ZHAOXIN_FCR57);
 			/* Enable RNG unit */
 			wrmsrq(MSR_ZHAOXIN_FCR57, msr | RNG_ENABLE);
 			pr_info("CPU: Enabled h/w RNG\n");
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 80a7f41cf3ad..bbe881cf4492 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -377,7 +377,7 @@ void fpu_sync_guest_vmexit_xfd_state(void)
 
 	lockdep_assert_irqs_disabled();
 	if (fpu_state_size_dynamic()) {
-		rdmsrq(MSR_IA32_XFD, fpstate->xfd);
+		fpstate->xfd = rdmsrq(MSR_IA32_XFD);
 		__this_cpu_write(xfd_state, fpstate->xfd);
 	}
 }
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 8dc7b710e125..8a27b9ae9fc7 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -971,7 +971,7 @@ static bool __init hpet_is_pc10_damaged(void)
 		return false;
 
 	/* Check whether PC10 is enabled in PKG C-state limit */
-	rdmsrq(MSR_PKG_CST_CONFIG_CONTROL, pcfg);
+	pcfg = rdmsrq(MSR_PKG_CST_CONFIG_CONTROL);
 	if ((pcfg & 0xF) < 8)
 		return false;
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 9f0efbe94793..ce98631561da 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -766,7 +766,7 @@ static int kvm_suspend(void *data)
 
 #ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
 	if (kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL))
-		rdmsrq(MSR_KVM_POLL_CONTROL, val);
+		val = rdmsrq(MSR_KVM_POLL_CONTROL);
 	has_guest_poll = !(val & 1);
 #endif
 	return 0;
diff --git a/arch/x86/kernel/mmconf-fam10h_64.c b/arch/x86/kernel/mmconf-fam10h_64.c
index ef6104e7cc72..348ac8fce3ad 100644
--- a/arch/x86/kernel/mmconf-fam10h_64.c
+++ b/arch/x86/kernel/mmconf-fam10h_64.c
@@ -97,7 +97,7 @@ static void get_fam10h_pci_mmconf_base(void)
 
 	/* SYS_CFG */
 	address = MSR_AMD64_SYSCFG;
-	rdmsrq(address, val);
+	val = rdmsrq(address);
 
 	/* TOP_MEM2 is not enabled? */
 	if (!(val & (1<<21))) {
@@ -105,7 +105,7 @@ static void get_fam10h_pci_mmconf_base(void)
 	} else {
 		/* TOP_MEM2 */
 		address = MSR_K8_TOP_MEM2;
-		rdmsrq(address, val);
+		val = rdmsrq(address);
 		tom2 = max(val & 0xffffff800000ULL, 1ULL << 32);
 	}
 
@@ -177,7 +177,7 @@ void fam10h_check_enable_mmcfg(void)
 		return;
 
 	address = MSR_FAM10H_MMIO_CONF_BASE;
-	rdmsrq(address, val);
+	val = rdmsrq(address);
 
 	/* try to make sure that AP's setting is identical to BSP setting */
 	if (val & FAM10H_MMIO_CONF_ENABLE) {
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 346c438ac880..85e6b076ef17 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -730,7 +730,7 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p)
 	    arch_has_block_step()) {
 		unsigned long debugctl, msk;
 
-		rdmsrq(MSR_IA32_DEBUGCTLMSR, debugctl);
+		debugctl = rdmsrq(MSR_IA32_DEBUGCTLMSR);
 		debugctl &= ~DEBUGCTLMSR_BTF;
 		msk = tifn & _TIF_BLOCKSTEP;
 		debugctl |= (msk >> TIF_BLOCKSTEP) << DEBUGCTLMSR_BTF_SHIFT;
@@ -980,7 +980,7 @@ void __init arch_post_acpi_subsys_init(void)
 	 * the machine is affected K8_INTP_C1E_ACTIVE_MASK bits are set in
 	 * MSR_K8_INT_PENDING_MSG.
 	 */
-	rdmsrq(MSR_K8_INT_PENDING_MSG, val);
+	val = rdmsrq(MSR_K8_INT_PENDING_MSG);
 	if (!(val & K8_INTP_C1E_ACTIVE_MASK))
 		return;
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 2bce7b3f97ed..28dbe7e629fc 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -97,8 +97,8 @@ void __show_regs(struct pt_regs *regs, enum show_regs_mode mode,
 		return;
 
 	if (mode == SHOW_REGS_USER) {
-		rdmsrq(MSR_FS_BASE, fs);
-		rdmsrq(MSR_KERNEL_GS_BASE, shadowgs);
+		fs = rdmsrq(MSR_FS_BASE);
+		shadowgs = rdmsrq(MSR_KERNEL_GS_BASE);
 		printk("%sFS:  %016lx GS:  %016lx\n",
 		       log_lvl, fs, shadowgs);
 		return;
@@ -109,9 +109,9 @@ void __show_regs(struct pt_regs *regs, enum show_regs_mode mode,
 	savesegment(fs, fsindex);
 	savesegment(gs, gsindex);
 
-	rdmsrq(MSR_FS_BASE, fs);
-	rdmsrq(MSR_GS_BASE, gs);
-	rdmsrq(MSR_KERNEL_GS_BASE, shadowgs);
+	fs = rdmsrq(MSR_FS_BASE);
+	gs = rdmsrq(MSR_GS_BASE);
+	shadowgs = rdmsrq(MSR_KERNEL_GS_BASE);
 
 	cr0 = read_cr0();
 	cr2 = read_cr2();
@@ -197,7 +197,7 @@ static noinstr unsigned long __rdgsbase_inactive(void)
 		native_swapgs();
 	} else {
 		instrumentation_begin();
-		rdmsrq(MSR_KERNEL_GS_BASE, gsbase);
+		gsbase = rdmsrq(MSR_KERNEL_GS_BASE);
 		instrumentation_end();
 	}
 
@@ -463,7 +463,7 @@ unsigned long x86_gsbase_read_cpu_inactive(void)
 		gsbase = __rdgsbase_inactive();
 		local_irq_restore(flags);
 	} else {
-		rdmsrq(MSR_KERNEL_GS_BASE, gsbase);
+		gsbase = rdmsrq(MSR_KERNEL_GS_BASE);
 	}
 
 	return gsbase;
diff --git a/arch/x86/kernel/shstk.c b/arch/x86/kernel/shstk.c
index eb690ba90180..c6cba46626e7 100644
--- a/arch/x86/kernel/shstk.c
+++ b/arch/x86/kernel/shstk.c
@@ -231,7 +231,7 @@ static unsigned long get_user_shstk_addr(void)
 
 	fpregs_lock_and_load();
 
-	rdmsrq(MSR_IA32_PL3_SSP, ssp);
+	ssp = rdmsrq(MSR_IA32_PL3_SSP);
 
 	fpregs_unlock();
 
@@ -248,7 +248,7 @@ int shstk_pop(u64 *val)
 
 	fpregs_lock_and_load();
 
-	rdmsrq(MSR_IA32_PL3_SSP, ssp);
+	ssp = rdmsrq(MSR_IA32_PL3_SSP);
 	if (val && get_user(*val, (__user u64 *)ssp))
 		ret = -EFAULT;
 	else
@@ -268,7 +268,7 @@ int shstk_push(u64 val)
 
 	fpregs_lock_and_load();
 
-	rdmsrq(MSR_IA32_PL3_SSP, ssp);
+	ssp = rdmsrq(MSR_IA32_PL3_SSP);
 	ssp -= SS_FRAME_SIZE;
 	ret = write_user_shstk_64((__user void *)ssp, val);
 	if (!ret)
@@ -497,7 +497,7 @@ static int wrss_control(bool enable)
 		return 0;
 
 	fpregs_lock_and_load();
-	rdmsrq(MSR_IA32_U_CET, msrval);
+	msrval = rdmsrq(MSR_IA32_U_CET);
 
 	if (enable) {
 		features_set(ARCH_SHSTK_WRSS);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 30aa8369957e..9cd11dc7bb17 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1250,7 +1250,7 @@ static noinstr void exc_debug_kernel(struct pt_regs *regs, unsigned long dr6)
 		 */
 		unsigned long debugctl;
 
-		rdmsrq(MSR_IA32_DEBUGCTLMSR, debugctl);
+		debugctl = rdmsrq(MSR_IA32_DEBUGCTLMSR);
 		debugctl |= DEBUGCTLMSR_BTF;
 		wrmsrq(MSR_IA32_DEBUGCTLMSR, debugctl);
 	}
@@ -1509,7 +1509,7 @@ static bool handle_xfd_event(struct pt_regs *regs)
 	if (!IS_ENABLED(CONFIG_X86_64) || !cpu_feature_enabled(X86_FEATURE_XFD))
 		return false;
 
-	rdmsrq(MSR_IA32_XFD_ERR, xfd_err);
+	xfd_err = rdmsrq(MSR_IA32_XFD_ERR);
 	if (!xfd_err)
 		return false;
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 723347e2cf7f..39baee2307c3 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1088,7 +1088,7 @@ static void __init detect_art(void)
 	if (art_base_clk.denominator < ART_MIN_DENOMINATOR)
 		return;
 
-	rdmsrq(MSR_IA32_TSC_ADJUST, art_base_clk.offset);
+	art_base_clk.offset = rdmsrq(MSR_IA32_TSC_ADJUST);
 
 	/* Make this sticky over multiple CPU init calls */
 	setup_force_cpu_cap(X86_FEATURE_ART);
diff --git a/arch/x86/kernel/tsc_msr.c b/arch/x86/kernel/tsc_msr.c
index d74743c8d2a4..6a1d22e8b846 100644
--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -179,15 +179,15 @@ unsigned long cpu_khz_from_msr(void)
 
 	freq_desc = (struct freq_desc *)id->driver_data;
 	if (freq_desc->use_msr_plat) {
-		rdmsrq(MSR_PLATFORM_INFO, val.q);
+		val.q = rdmsrq(MSR_PLATFORM_INFO);
 		ratio = (val.l >> 8) & 0xff;
 	} else {
-		rdmsrq(MSR_IA32_PERF_STATUS, val.q);
+		val.q = rdmsrq(MSR_IA32_PERF_STATUS);
 		ratio = (val.h >> 8) & 0x1f;
 	}
 
 	/* Get FSB FREQ ID */
-	rdmsrq(MSR_FSB_FREQ, val.q);
+	val.q = rdmsrq(MSR_FSB_FREQ);
 	index = val.l & freq_desc->mask;
 	md = &freq_desc->muldiv[index];
 
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index ec3aa340d351..a21ea3c85f6f 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -66,7 +66,7 @@ void tsc_verify_tsc_adjust(bool resume)
 
 	adj->nextcheck = jiffies + HZ;
 
-	rdmsrq(MSR_IA32_TSC_ADJUST, curval);
+	curval = rdmsrq(MSR_IA32_TSC_ADJUST);
 	if (adj->adjusted == curval)
 		return;
 
@@ -166,7 +166,7 @@ bool __init tsc_store_and_check_tsc_adjust(bool bootcpu)
 	if (check_tsc_unstable())
 		return false;
 
-	rdmsrq(MSR_IA32_TSC_ADJUST, bootval);
+	bootval = rdmsrq(MSR_IA32_TSC_ADJUST);
 	cur->bootval = bootval;
 	cur->nextcheck = jiffies + HZ;
 	tsc_sanitize_first_cpu(cur, bootval, smp_processor_id(), bootcpu);
@@ -188,7 +188,7 @@ bool tsc_store_and_check_tsc_adjust(bool bootcpu)
 	if (!boot_cpu_has(X86_FEATURE_TSC_ADJUST))
 		return false;
 
-	rdmsrq(MSR_IA32_TSC_ADJUST, bootval);
+	bootval = rdmsrq(MSR_IA32_TSC_ADJUST);
 	cur->bootval = bootval;
 	cur->nextcheck = jiffies + HZ;
 	cur->warned = false;
diff --git a/arch/x86/kvm/msrs.c b/arch/x86/kvm/msrs.c
index e91650af44c2..e429f9296e23 100644
--- a/arch/x86/kvm/msrs.c
+++ b/arch/x86/kvm/msrs.c
@@ -1215,7 +1215,7 @@ static __always_inline void kvm_access_xstate_msr(struct kvm_vcpu *vcpu,
 
 	kvm_fpu_get();
 	if (access == MSR_TYPE_R)
-		rdmsrq(msr_info->index, msr_info->data);
+		msr_info->data = rdmsrq(msr_info->index);
 	else
 		wrmsrq(msr_info->index, msr_info->data);
 	kvm_fpu_put();
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index c18286545a7a..5ebee82dba84 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -249,7 +249,7 @@ static void amd_mediated_pmu_load(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	u64 global_status;
 
-	rdmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, global_status);
+	global_status = rdmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS);
 	/* Clear host global_status MSR if non-zero. */
 	if (global_status)
 		wrmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, global_status);
@@ -263,7 +263,7 @@ static void amd_mediated_pmu_put(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	wrmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_CTL, 0);
-	rdmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS, pmu->global_status);
+	pmu->global_status = rdmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS);
 
 	/* Clear global status bits if non-zero */
 	if (pmu->global_status)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 136069dfcd44..1b2150534c04 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4758,8 +4758,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 		vmcb_mark_all_clean(svm->vmcb);
 
 		if (!msr_write_intercepted(svm, MSR_AMD64_PERF_CNTR_GLOBAL_CTL))
-			rdmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
-			       vcpu_to_pmu(vcpu)->global_ctrl);
+			vcpu_to_pmu(vcpu)->global_ctrl =
+				rdmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_CTL);
 	}
 
 	/* if exit due to PF check for async PF */
@@ -5620,7 +5620,7 @@ static __init void svm_adjust_mmio_mask(void)
 		return;
 
 	/* If memory encryption is not enabled, use existing mask */
-	rdmsrq(MSR_AMD64_SYSCFG, msr);
+	msr = rdmsrq(MSR_AMD64_SYSCFG);
 	if (!(msr & MSR_AMD64_SYSCFG_MEM_ENCRYPT))
 		return;
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d75170a6199e..3d8fa36fb74f 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -909,7 +909,7 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
 	 * the #NM exception.
 	 */
 	if (is_xfd_nm_fault(vcpu))
-		rdmsrq(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
+		vcpu->arch.guest_fpu.xfd_err = rdmsrq(MSR_IA32_XFD_ERR);
 }
 
 static void handle_exception_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 516ba03bf608..89cc051d8aff 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7371,8 +7371,8 @@ static void nested_vmx_setup_cr_fixed(struct nested_vmx_msrs *msrs)
 	msrs->cr4_fixed0 = VMXON_CR4_ALWAYSON;
 
 	/* These MSRs specify bits which the guest must keep fixed off. */
-	rdmsrq(MSR_IA32_VMX_CR0_FIXED1, msrs->cr0_fixed1);
-	rdmsrq(MSR_IA32_VMX_CR4_FIXED1, msrs->cr4_fixed1);
+	msrs->cr0_fixed1 = rdmsrq(MSR_IA32_VMX_CR0_FIXED1);
+	msrs->cr4_fixed1 = rdmsrq(MSR_IA32_VMX_CR4_FIXED1);
 
 	if (vmx_umip_emulated())
 		msrs->cr4_fixed1 |= X86_CR4_UMIP;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index fb7ad53855f1..49ec015b5114 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -323,7 +323,7 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
 		int err = 0;
 
 		if (read)
-			rdmsrq(index, msr_info->data);
+			msr_info->data = rdmsrq(index);
 		else
 			err = wrmsrq_safe(index, msr_info->data);
 		__set_bit(INTEL_PMC_IDX_FIXED_VLBR, vcpu_to_pmu(vcpu)->pmc_in_use);
@@ -787,7 +787,7 @@ static bool intel_pmu_is_mediated_pmu_supported(struct x86_pmu_capability *host_
 	u64 host_perf_cap = 0;
 
 	if (boot_cpu_has(X86_FEATURE_PDCM))
-		rdmsrq(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
+		host_perf_cap = rdmsrq(MSR_IA32_PERF_CAPABILITIES);
 
 	/*
 	 * Require v4+ for MSR_CORE_PERF_GLOBAL_STATUS_SET, and full-width
@@ -816,7 +816,7 @@ static void intel_mediated_pmu_load(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	u64 global_status, toggle;
 
-	rdmsrq(MSR_CORE_PERF_GLOBAL_STATUS, global_status);
+	global_status = rdmsrq(MSR_CORE_PERF_GLOBAL_STATUS);
 	toggle = pmu->global_status ^ global_status;
 	if (global_status & toggle)
 		wrmsrq(MSR_CORE_PERF_GLOBAL_OVF_CTRL, global_status & toggle);
@@ -831,7 +831,7 @@ static void intel_mediated_pmu_put(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	/* MSR_CORE_PERF_GLOBAL_CTRL is already saved at VM-exit. */
-	rdmsrq(MSR_CORE_PERF_GLOBAL_STATUS, pmu->global_status);
+	pmu->global_status = rdmsrq(MSR_CORE_PERF_GLOBAL_STATUS);
 
 	/* Clear hardware MSR_CORE_PERF_GLOBAL_STATUS MSR, if non-zero. */
 	if (pmu->global_status)
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 771c75a58343..765cac151023 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -420,9 +420,9 @@ void setup_default_sgx_lepubkeyhash(void)
 		sgx_pubkey_hash[3] = 0xd4f8c05909f9bb3bULL;
 	} else {
 		/* MSR_IA32_SGXLEPUBKEYHASH0 is read above */
-		rdmsrq(MSR_IA32_SGXLEPUBKEYHASH1, sgx_pubkey_hash[1]);
-		rdmsrq(MSR_IA32_SGXLEPUBKEYHASH2, sgx_pubkey_hash[2]);
-		rdmsrq(MSR_IA32_SGXLEPUBKEYHASH3, sgx_pubkey_hash[3]);
+		sgx_pubkey_hash[1] = rdmsrq(MSR_IA32_SGXLEPUBKEYHASH1);
+		sgx_pubkey_hash[2] = rdmsrq(MSR_IA32_SGXLEPUBKEYHASH2);
+		sgx_pubkey_hash[3] = rdmsrq(MSR_IA32_SGXLEPUBKEYHASH3);
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 82eb891f684c..aa8d23ba1204 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1261,13 +1261,13 @@ static inline void pt_save_msr(struct pt_ctx *ctx, u32 addr_range)
 {
 	u32 i;
 
-	rdmsrq(MSR_IA32_RTIT_STATUS, ctx->status);
-	rdmsrq(MSR_IA32_RTIT_OUTPUT_BASE, ctx->output_base);
-	rdmsrq(MSR_IA32_RTIT_OUTPUT_MASK, ctx->output_mask);
-	rdmsrq(MSR_IA32_RTIT_CR3_MATCH, ctx->cr3_match);
+	ctx->status = rdmsrq(MSR_IA32_RTIT_STATUS);
+	ctx->output_base = rdmsrq(MSR_IA32_RTIT_OUTPUT_BASE);
+	ctx->output_mask = rdmsrq(MSR_IA32_RTIT_OUTPUT_MASK);
+	ctx->cr3_match = rdmsrq(MSR_IA32_RTIT_CR3_MATCH);
 	for (i = 0; i < addr_range; i++) {
-		rdmsrq(MSR_IA32_RTIT_ADDR0_A + i * 2, ctx->addr_a[i]);
-		rdmsrq(MSR_IA32_RTIT_ADDR0_B + i * 2, ctx->addr_b[i]);
+		ctx->addr_a[i] = rdmsrq(MSR_IA32_RTIT_ADDR0_A + i * 2);
+		ctx->addr_b[i] = rdmsrq(MSR_IA32_RTIT_ADDR0_B + i * 2);
 	}
 }
 
@@ -1280,7 +1280,7 @@ static void pt_guest_enter(struct vcpu_vmx *vmx)
 	 * GUEST_IA32_RTIT_CTL is already set in the VMCS.
 	 * Save host state before VM entry.
 	 */
-	rdmsrq(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
+	vmx->pt_desc.host.ctl = rdmsrq(MSR_IA32_RTIT_CTL);
 	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
 		wrmsrq(MSR_IA32_RTIT_CTL, 0);
 		pt_save_msr(&vmx->pt_desc.host, vmx->pt_desc.num_address_ranges);
@@ -1418,7 +1418,7 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 	++vmx->vcpu.stat.host_state_reload;
 
 #ifdef CONFIG_X86_64
-	rdmsrq(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
+	vmx->msr_guest_kernel_gs_base = rdmsrq(MSR_KERNEL_GS_BASE);
 #endif
 	if (host_state->ldt_sel || (host_state->gs_sel & 7)) {
 		vmx_load_ldt(host_state->ldt_sel);
@@ -2694,7 +2694,7 @@ static int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt, u32 msr, u32 *result)
 	struct msr vmx_msr;
 	u32 ctl = ctl_min | ctl_opt;
 
-	rdmsrq(msr, vmx_msr.q);
+	vmx_msr.q = rdmsrq(msr);
 
 	ctl &= vmx_msr.h;  /* bit == 0 in high word ==> must be zero */
 	ctl |= vmx_msr.l;  /* bit == 1 in low word  ==> must be one  */
@@ -2711,7 +2711,7 @@ static u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
 {
 	u64 allowed;
 
-	rdmsrq(msr, allowed);
+	allowed = rdmsrq(msr);
 
 	return  ctl_opt & allowed;
 }
@@ -2907,7 +2907,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		break;
 	}
 
-	rdmsrq(MSR_IA32_VMX_BASIC, basic_msr);
+	basic_msr = rdmsrq(MSR_IA32_VMX_BASIC);
 
 	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
 	if (vmx_basic_vmcs_size(basic_msr) > PAGE_SIZE)
@@ -2927,7 +2927,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	if (vmx_basic_vmcs_mem_type(basic_msr) != X86_MEMTYPE_WB)
 		return -EIO;
 
-	rdmsrq(MSR_IA32_VMX_MISC, misc_msr);
+	misc_msr = rdmsrq(MSR_IA32_VMX_MISC);
 
 	vmcs_conf->basic = basic_msr;
 	vmcs_conf->pin_based_exec_ctrl = _pin_based_exec_control;
@@ -4504,7 +4504,7 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 
 	vmcs_writel(HOST_RIP, (unsigned long)vmx_vmexit); /* 22.2.5 */
 
-	rdmsrq(MSR_IA32_SYSENTER_CS, val.q);
+	val.q = rdmsrq(MSR_IA32_SYSENTER_CS);
 	vmcs_write32(HOST_IA32_SYSENTER_CS, val.l);
 
 	/*
@@ -4516,11 +4516,11 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 	if (!IS_ENABLED(CONFIG_IA32_EMULATION) && !IS_ENABLED(CONFIG_X86_32))
 		vmcs_writel(HOST_IA32_SYSENTER_ESP, 0);
 
-	rdmsrq(MSR_IA32_SYSENTER_EIP, tmpl);
+	tmpl = rdmsrq(MSR_IA32_SYSENTER_EIP);
 	vmcs_writel(HOST_IA32_SYSENTER_EIP, tmpl);   /* 22.2.3 */
 
 	if (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_PAT) {
-		rdmsrq(MSR_IA32_CR_PAT, val.q);
+		val.q = rdmsrq(MSR_IA32_CR_PAT);
 		vmcs_write64(HOST_IA32_PAT, val.q);
 	}
 
@@ -7897,7 +7897,7 @@ static __init u64 vmx_get_perf_capabilities(void)
 		return 0;
 
 	if (boot_cpu_has(X86_FEATURE_PDCM))
-		rdmsrq(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
+		host_perf_cap = rdmsrq(MSR_IA32_PERF_CAPABILITIES);
 
 	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR) &&
 	    !enable_mediated_pmu) {
@@ -8545,7 +8545,7 @@ __init int vmx_hardware_setup(void)
 	vmx_setup_user_return_msrs();
 
 	if (boot_cpu_has(X86_FEATURE_MPX)) {
-		rdmsrq(MSR_IA32_BNDCFGS, host_bndcfgs);
+		host_bndcfgs = rdmsrq(MSR_IA32_BNDCFGS);
 		WARN_ONCE(host_bndcfgs, "BNDCFGS in host will be lost");
 	}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 32563a91fba9..a55336c4ebfc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7097,7 +7097,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	}
 
 	if (boot_cpu_has(X86_FEATURE_SHSTK) || boot_cpu_has(X86_FEATURE_IBT)) {
-		rdmsrq(MSR_IA32_S_CET, kvm_host.s_cet);
+		kvm_host.s_cet = rdmsrq(MSR_IA32_S_CET);
 		/*
 		 * Linux doesn't yet support supervisor shadow stacks (SSS), so
 		 * KVM doesn't save/restore the associated MSRs, i.e. KVM may
@@ -7129,7 +7129,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	}
 
 	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
-		rdmsrq(MSR_IA32_XSS, kvm_host.xss);
+		kvm_host.xss = rdmsrq(MSR_IA32_XSS);
 		kvm_caps.supported_xss = kvm_host.xss & KVM_SUPPORTED_XSS;
 	}
 
@@ -7141,7 +7141,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	kvm_init_pmu_capability(ops->pmu_ops);
 
 	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
-		rdmsrq(MSR_IA32_ARCH_CAPABILITIES, kvm_host.arch_capabilities);
+		kvm_host.arch_capabilities = rdmsrq(MSR_IA32_ARCH_CAPABILITIES);
 
 	WARN_ON_ONCE(kvm_nr_uret_msrs);
 
diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
index e03eeec55cfe..b9db2012a75e 100644
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -709,16 +709,16 @@ unsigned long insn_get_seg_base(struct pt_regs *regs, int seg_reg_idx)
 		unsigned long base;
 
 		if (seg_reg_idx == INAT_SEG_REG_FS) {
-			rdmsrq(MSR_FS_BASE, base);
+			base = rdmsrq(MSR_FS_BASE);
 		} else if (seg_reg_idx == INAT_SEG_REG_GS) {
 			/*
 			 * swapgs was called at the kernel entry point. Thus,
 			 * MSR_KERNEL_GS_BASE will have the user-space GS base.
 			 */
 			if (user_mode(regs))
-				rdmsrq(MSR_KERNEL_GS_BASE, base);
+				base = rdmsrq(MSR_KERNEL_GS_BASE);
 			else
-				rdmsrq(MSR_GS_BASE, base);
+				base = rdmsrq(MSR_GS_BASE);
 		} else {
 			base = 0;
 		}
diff --git a/arch/x86/lib/msr-smp.c b/arch/x86/lib/msr-smp.c
index 7b6cfc2c0970..ddff68050322 100644
--- a/arch/x86/lib/msr-smp.c
+++ b/arch/x86/lib/msr-smp.c
@@ -15,7 +15,7 @@ static void __rdmsr_on_cpu(void *info)
 	else
 		reg = &rv->reg;
 
-	rdmsrq(rv->msr_no, reg->q);
+	reg->q = rdmsrq(rv->msr_no);
 }
 
 static void __wrmsr_on_cpu(void *info)
diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
index cf94fb561310..114853c212ed 100644
--- a/arch/x86/mm/pat/memtype.c
+++ b/arch/x86/mm/pat/memtype.c
@@ -257,7 +257,7 @@ void __init pat_bp_init(void)
 	if (!cpu_feature_enabled(X86_FEATURE_PAT))
 		pat_disable("PAT not supported by the CPU.");
 	else
-		rdmsrq(MSR_IA32_CR_PAT, pat_msr_val);
+		pat_msr_val = rdmsrq(MSR_IA32_CR_PAT);
 
 	if (!pat_msr_val) {
 		pat_disable("PAT support disabled by the firmware.");
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 99b1727136c1..342371081f60 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -202,7 +202,7 @@ static int __init early_root_info_init(void)
 
 	/* need to take out [0, TOM) for RAM*/
 	address = MSR_K8_TOP_MEM1;
-	rdmsrq(address, val);
+	val = rdmsrq(address);
 	end = (val & 0xffffff800000ULL);
 	printk(KERN_INFO "TOM: %016llx aka %lldM\n", end, end>>20);
 	if (end < (1ULL<<32))
@@ -293,12 +293,12 @@ static int __init early_root_info_init(void)
 	/* need to take out [4G, TOM2) for RAM*/
 	/* SYS_CFG */
 	address = MSR_AMD64_SYSCFG;
-	rdmsrq(address, val);
+	val = rdmsrq(address);
 	/* TOP_MEM2 is enabled? */
 	if (val & (1<<21)) {
 		/* TOP_MEM2 */
 		address = MSR_K8_TOP_MEM2;
-		rdmsrq(address, val);
+		val = rdmsrq(address);
 		end = (val & 0xffffff800000ULL);
 		printk(KERN_INFO "TOM2: %016llx aka %lldM\n", end, end>>20);
 		subtract_range(range, RANGE_NUM, 1ULL<<32, end);
@@ -341,7 +341,7 @@ static int amd_bus_cpu_online(unsigned int cpu)
 {
 	u64 reg;
 
-	rdmsrq(MSR_AMD64_NB_CFG, reg);
+	reg = rdmsrq(MSR_AMD64_NB_CFG);
 	if (!(reg & ENABLE_CF8_EXT_CFG)) {
 		reg |= ENABLE_CF8_EXT_CFG;
 		wrmsrq(MSR_AMD64_NB_CFG, reg);
diff --git a/arch/x86/platform/olpc/olpc-xo1-rtc.c b/arch/x86/platform/olpc/olpc-xo1-rtc.c
index ee77d57bcab7..95dfd90b1f05 100644
--- a/arch/x86/platform/olpc/olpc-xo1-rtc.c
+++ b/arch/x86/platform/olpc/olpc-xo1-rtc.c
@@ -64,9 +64,9 @@ static int __init xo1_rtc_init(void)
 	of_node_put(node);
 
 	pr_info("olpc-xo1-rtc: Initializing OLPC XO-1 RTC\n");
-	rdmsrq(MSR_RTC_DOMA_OFFSET, rtc_info.rtc_day_alarm);
-	rdmsrq(MSR_RTC_MONA_OFFSET, rtc_info.rtc_mon_alarm);
-	rdmsrq(MSR_RTC_CEN_OFFSET, rtc_info.rtc_century);
+	rtc_info.rtc_day_alarm = rdmsrq(MSR_RTC_DOMA_OFFSET);
+	rtc_info.rtc_mon_alarm = rdmsrq(MSR_RTC_MONA_OFFSET);
+	rtc_info.rtc_century = rdmsrq(MSR_RTC_CEN_OFFSET);
 
 	r = platform_device_register(&xo1_rtc_device);
 	if (r)
diff --git a/arch/x86/platform/olpc/olpc-xo1-sci.c b/arch/x86/platform/olpc/olpc-xo1-sci.c
index 8b5b3626b559..d2b63a7c0fe6 100644
--- a/arch/x86/platform/olpc/olpc-xo1-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo1-sci.c
@@ -316,7 +316,7 @@ static int setup_sci_interrupt(struct platform_device *pdev)
 	u32 sts;
 	int r;
 
-	rdmsrq(0x51400020, msr);
+	msr = rdmsrq(0x51400020);
 	sci_irq = (msr >> 20) & 15;
 
 	if (sci_irq) {
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 702f30eaf9c4..f44ebe2fe099 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -45,7 +45,7 @@ static void msr_save_context(struct saved_context *ctxt)
 
 	while (msr < end) {
 		if (msr->valid)
-			rdmsrq(msr->info.msr_no, msr->info.reg.q);
+			msr->info.reg.q = rdmsrq(msr->info.msr_no);
 		msr++;
 	}
 }
@@ -111,12 +111,12 @@ static void __save_processor_state(struct saved_context *ctxt)
 	savesegment(ds, ctxt->ds);
 	savesegment(es, ctxt->es);
 
-	rdmsrq(MSR_FS_BASE, ctxt->fs_base);
-	rdmsrq(MSR_GS_BASE, ctxt->kernelmode_gs_base);
-	rdmsrq(MSR_KERNEL_GS_BASE, ctxt->usermode_gs_base);
+	ctxt->fs_base = rdmsrq(MSR_FS_BASE);
+	ctxt->kernelmode_gs_base = rdmsrq(MSR_GS_BASE);
+	ctxt->usermode_gs_base = rdmsrq(MSR_KERNEL_GS_BASE);
 	mtrr_save_fixed_ranges(NULL);
 
-	rdmsrq(MSR_EFER, ctxt->efer);
+	ctxt->efer = rdmsrq(MSR_EFER);
 #endif
 
 	/*
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 65110b2ee1a1..d97ec1b0bf91 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -147,7 +147,7 @@ static void __init setup_real_mode(void)
 	 * Some AMD processors will #GP(0) if EFER.LMA is set in WRMSR
 	 * so we need to mask it out.
 	 */
-	rdmsrq(MSR_EFER, efer);
+	efer = rdmsrq(MSR_EFER);
 	trampoline_header->efer = efer & ~EFER_LMA;
 
 	trampoline_header->start = (u64) secondary_startup_64;
diff --git a/arch/x86/virt/hw.c b/arch/x86/virt/hw.c
index a236447ac7a2..a0f5ecb5b946 100644
--- a/arch/x86/virt/hw.c
+++ b/arch/x86/virt/hw.c
@@ -178,7 +178,7 @@ static __init int __x86_vmx_init(void)
 	if (!cpu_feature_enabled(X86_FEATURE_VMX))
 		return -EOPNOTSUPP;
 
-	rdmsrq(MSR_IA32_VMX_BASIC, basic_msr);
+	basic_msr = rdmsrq(MSR_IA32_VMX_BASIC);
 
 	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
 	if (WARN_ON_ONCE(vmx_basic_vmcs_size(basic_msr) > PAGE_SIZE))
@@ -230,7 +230,7 @@ static int x86_svm_enable_virtualization_cpu(void)
 {
 	u64 efer;
 
-	rdmsrq(MSR_EFER, efer);
+	efer = rdmsrq(MSR_EFER);
 	if (efer & EFER_SVME)
 		return -EBUSY;
 
@@ -253,7 +253,7 @@ static int x86_svm_disable_virtualization_cpu(void)
 	r = 0;
 
 fault:
-	rdmsrq(MSR_EFER, efer);
+	efer = rdmsrq(MSR_EFER);
 	wrmsrq(MSR_EFER, efer & ~EFER_SVME);
 	return r;
 }
@@ -264,7 +264,7 @@ static void x86_svm_emergency_disable_virtualization_cpu(void)
 
 	virt_rebooting = true;
 
-	rdmsrq(MSR_EFER, efer);
+	efer = rdmsrq(MSR_EFER);
 	if (!(efer & EFER_SVME))
 		return;
 
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index bd70c4d0b774..816511de0d64 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -173,7 +173,7 @@ static void snp_enable(void *arg)
 	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return;
 
-	rdmsrq(MSR_AMD64_SYSCFG, val);
+	val = rdmsrq(MSR_AMD64_SYSCFG);
 
 	val |= MSR_AMD64_SYSCFG_SNP_EN;
 	val |= MSR_AMD64_SYSCFG_SNP_VMPL_EN;
@@ -277,7 +277,7 @@ static void clear_rmp(void)
 		return;
 
 	/* Clearing the RMP while SNP is enabled will cause an exception */
-	rdmsrq(MSR_AMD64_SYSCFG, val);
+	val = rdmsrq(MSR_AMD64_SYSCFG);
 	if (WARN_ON_ONCE(val & MSR_AMD64_SYSCFG_SNP_EN))
 		return;
 
@@ -542,7 +542,7 @@ int snp_prepare(void)
 	 * Check if SEV-SNP is already enabled, this can happen in case of
 	 * kexec boot.
 	 */
-	rdmsrq(MSR_AMD64_SYSCFG, val);
+	val = rdmsrq(MSR_AMD64_SYSCFG);
 	if (val & MSR_AMD64_SYSCFG_SNP_EN)
 		return 0;
 
@@ -582,7 +582,7 @@ void snp_shutdown(void)
 {
 	u64 syscfg;
 
-	rdmsrq(MSR_AMD64_SYSCFG, syscfg);
+	syscfg = rdmsrq(MSR_AMD64_SYSCFG);
 	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
 		return;
 
@@ -682,7 +682,7 @@ void snp_enable_rmpopt(void)
 	 * Per-CPU RMPOPT tables cover at most 2 TB.  Program each core's
 	 * RMPOPT_BASE with the start of RAM to optimize up to 2 TB.
 	 */
-	rdmsrq(MSR_AMD64_RMPOPT_BASE, base);
+	base = rdmsrq(MSR_AMD64_RMPOPT_BASE);
 	if (!(base & MSR_AMD64_RMPOPT_ENABLE))
 		for_each_cpu(cpu, cpu_primary_thread_mask)
 			wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE,
@@ -716,7 +716,7 @@ int __init snp_rmptable_init(void)
 	 * SnpEn set across shutdown), in which case snp_prepare() bails without
 	 * disabling CPU hotplug, so disable it here.
 	 */
-	rdmsrq(MSR_AMD64_SYSCFG, val);
+	val = rdmsrq(MSR_AMD64_SYSCFG);
 	if (val & MSR_AMD64_SYSCFG_SNP_EN)
 		cpu_hotplug_disable();
 
@@ -742,8 +742,8 @@ static bool probe_contiguous_rmptable_info(void)
 {
 	u64 rmp_sz, rmp_base, rmp_end;
 
-	rdmsrq(MSR_AMD64_RMP_BASE, rmp_base);
-	rdmsrq(MSR_AMD64_RMP_END, rmp_end);
+	rmp_base = rdmsrq(MSR_AMD64_RMP_BASE);
+	rmp_end = rdmsrq(MSR_AMD64_RMP_END);
 
 	if (!(rmp_base & RMP_ADDR_MASK) || !(rmp_end & RMP_ADDR_MASK)) {
 		pr_err("Memory for the RMP table has not been reserved by BIOS\n");
@@ -776,13 +776,13 @@ static bool probe_segmented_rmptable_info(void)
 	unsigned int eax, ebx, segment_shift, segment_shift_min, segment_shift_max;
 	u64 rmp_base, rmp_end;
 
-	rdmsrq(MSR_AMD64_RMP_BASE, rmp_base);
+	rmp_base = rdmsrq(MSR_AMD64_RMP_BASE);
 	if (!(rmp_base & RMP_ADDR_MASK)) {
 		pr_err("Memory for the RMP table has not been reserved by BIOS\n");
 		return false;
 	}
 
-	rdmsrq(MSR_AMD64_RMP_END, rmp_end);
+	rmp_end = rdmsrq(MSR_AMD64_RMP_END);
 	WARN_ONCE(rmp_end & RMP_ADDR_MASK,
 		  "Segmented RMP enabled but RMP_END MSR is non-zero\n");
 
@@ -818,7 +818,7 @@ static bool probe_segmented_rmptable_info(void)
 bool snp_probe_rmptable_info(void)
 {
 	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP)) {
-		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
+		rmp_cfg = rdmsrq(MSR_AMD64_RMP_CFG);
 
 		if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
 			if (probe_segmented_rmptable_info())
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 96ced0494b68..ab473c13a3dd 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1570,7 +1570,7 @@ static void __init check_tdx_erratum(void)
 	 * Some TDX-capable CPUs have an erratum where the current VMCS is
 	 * cleared after calling into P-SEAMLDR.
 	 */
-	rdmsrq(MSR_IA32_VMX_BASIC, basic_msr);
+	basic_msr = rdmsrq(MSR_IA32_VMX_BASIC);
 	if (!(basic_msr & VMX_BASIC_NO_SEAMRET_INVD_VMCS))
 		setup_force_cpu_bug(X86_BUG_SEAMRET_INVD_VMCS);
 }
diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index ba2f17e64321..b0e1152aa80e 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -56,7 +56,7 @@ static void xen_vcpu_notify_suspend(void *data)
 	tick_suspend_local();
 
 	if (xen_pv_domain() && boot_cpu_has(X86_FEATURE_SPEC_CTRL)) {
-		rdmsrq(MSR_IA32_SPEC_CTRL, tmp);
+		tmp = rdmsrq(MSR_IA32_SPEC_CTRL);
 		this_cpu_write(spec_ctrl, tmp);
 		wrmsrq(MSR_IA32_SPEC_CTRL, 0);
 	}
diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 9e25d6124efd..535a0f9dd2cf 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -296,7 +296,7 @@ static void amd_fixup_frequency(struct acpi_processor_px *px, int i)
 
 	if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10) ||
 	    boot_cpu_data.x86 == 0x11) {
-		rdmsrq(MSR_AMD_PSTATE_DEF_BASE + index, val.q);
+		val.q = rdmsrq(MSR_AMD_PSTATE_DEF_BASE + index);
 		/*
 		 * MSR C001_0064+:
 		 * Bit 63: PstateEn. Read-write. If set, the P-state is valid.
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index 512f9728224f..5ca17faa8e6e 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -110,7 +110,7 @@ static void cs5535_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	       pio_cmd_timings[cmdmode] | pio_timings[mode]);
 
 	/* Set the PIO "format 1" bit in the DMA timing register */
-	rdmsrq(ATAC_CH0D0_DMA + 2 * adev->devno, reg);
+	reg = rdmsrq(ATAC_CH0D0_DMA + 2 * adev->devno);
 	wrmsrq(ATAC_CH0D0_DMA + 2 * adev->devno, reg | 0x80000000UL);
 }
 
@@ -132,7 +132,7 @@ static void cs5535_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	u32 reg;
 	int mode = adev->dma_mode;
 
-	rdmsrq(ATAC_CH0D0_DMA + 2 * adev->devno, reg);
+	reg = rdmsrq(ATAC_CH0D0_DMA + 2 * adev->devno);
 	reg &= 0x80000000UL;
 	if (mode >= XFER_UDMA_0)
 		reg |= udma_timings[mode - XFER_UDMA_0];
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index 61d232a82b5e..eca97dce1e85 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -84,7 +84,7 @@ static int cs5536_read(struct pci_dev *pdev, int reg, u32 *val)
 {
 #ifdef MAYBE_USE_MSR
 	if (unlikely(use_msr)) {
-		rdmsrq(MSR_IDE_CFG + reg, *val);
+		*val = rdmsrq(MSR_IDE_CFG + reg);
 		return 0;
 	}
 #endif
diff --git a/drivers/char/agp/nvidia-agp.c b/drivers/char/agp/nvidia-agp.c
index 3e760bc00afa..f646f1854981 100644
--- a/drivers/char/agp/nvidia-agp.c
+++ b/drivers/char/agp/nvidia-agp.c
@@ -72,8 +72,8 @@ static int nvidia_init_iorr(u32 base, u32 size)
 	/* If not found, determine the uppermost available iorr */
 	free_iorr_addr = AMD_K7_NUM_IORR;
 	for (iorr_addr = 0; iorr_addr < AMD_K7_NUM_IORR; iorr_addr++) {
-		rdmsrq(IORR_BASE0 + 2 * iorr_addr, base_msr.q);
-		rdmsrq(IORR_MASK0 + 2 * iorr_addr, mask_msr.q);
+		base_msr.q = rdmsrq(IORR_BASE0 + 2 * iorr_addr);
+		mask_msr.q = rdmsrq(IORR_MASK0 + 2 * iorr_addr);
 
 		if ((base_msr.l & 0xfffff000) == (base & 0xfffff000))
 			break;
@@ -94,7 +94,7 @@ static int nvidia_init_iorr(u32 base, u32 size)
     wrmsrq(IORR_BASE0 + 2 * iorr_addr, base_msr.q);
     wrmsrq(IORR_MASK0 + 2 * iorr_addr, mask_msr.q);
 
-    rdmsrq(SYSCFG, sys_msr.q);
+    sys_msr.q = rdmsrq(SYSCFG);
     sys_msr.l |= 0x00100000;
     wrmsrq(SYSCFG, sys_msr.q);
 
diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
index b718e78d3c1c..a0a3488a6947 100644
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -151,7 +151,7 @@ static int via_rng_init(struct hwrng *rng)
 	 * does not say to write them as zero, so I make a guess that
 	 * we restore the values we find in the register.
 	 */
-	rdmsrq(MSR_VIA_RNG, val.q);
+	val.q = rdmsrq(MSR_VIA_RNG);
 
 	old_lo = val.l;
 	val.l &= ~(0x7f << VIA_STRFILT_CNT_SHIFT);
@@ -175,7 +175,7 @@ static int via_rng_init(struct hwrng *rng)
 
 	/* perhaps-unnecessary sanity check; remove after testing if
 	   unneeded */
-	rdmsrq(MSR_VIA_RNG, val.q);
+	val.q = rdmsrq(MSR_VIA_RNG);
 	if ((val.l & VIA_RNG_ENABLE) == 0) {
 		pr_err(PFX "cannot enable VIA C3 RNG, aborting\n");
 		return -ENODEV;
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 2e74a000cdc7..057d83ee8f44 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -110,7 +110,7 @@ static int boost_set_msr(bool enable)
 		return -EINVAL;
 	}
 
-	rdmsrq(msr_addr, val);
+	val = rdmsrq(msr_addr);
 
 	if (enable)
 		val &= ~msr_mask;
@@ -248,7 +248,7 @@ static u32 cpu_freq_read_intel(struct acpi_pct_register *not_used)
 {
 	u64 val;
 
-	rdmsrq(MSR_IA32_PERF_CTL, val);
+	val = rdmsrq(MSR_IA32_PERF_CTL);
 	return (u32)val;
 }
 
@@ -256,7 +256,7 @@ static void cpu_freq_write_intel(struct acpi_pct_register *not_used, u32 val)
 {
 	u64 msrval;
 
-	rdmsrq(MSR_IA32_PERF_CTL, msrval);
+	msrval = rdmsrq(MSR_IA32_PERF_CTL);
 	msrval = (msrval & ~(u64)INTEL_MSR_RANGE) | (val & INTEL_MSR_RANGE);
 	wrmsrq(MSR_IA32_PERF_CTL, msrval);
 }
@@ -265,7 +265,7 @@ static u32 cpu_freq_read_amd(struct acpi_pct_register *not_used)
 {
 	u64 val;
 
-	rdmsrq(MSR_AMD_PERF_CTL, val);
+	val = rdmsrq(MSR_AMD_PERF_CTL);
 	return (u32)val;
 }
 
diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 4bedfbfc18b6..9b50f57034a1 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -647,8 +647,8 @@ static inline bool amd_pstate_sample(struct amd_cpudata *cpudata)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	rdmsrq(MSR_IA32_APERF, aperf);
-	rdmsrq(MSR_IA32_MPERF, mperf);
+	aperf = rdmsrq(MSR_IA32_APERF);
+	mperf = rdmsrq(MSR_IA32_MPERF);
 	tsc = rdtsc();
 
 	if (cpudata->prev.mperf == mperf || cpudata->prev.tsc == tsc) {
diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index 54689ebadeb2..cc05494ac316 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -99,7 +99,7 @@ static unsigned int eps_get(unsigned int cpu)
 		return 0;
 
 	/* Return current frequency */
-	rdmsrq(MSR_IA32_PERF_STATUS, val);
+	val = rdmsrq(MSR_IA32_PERF_STATUS);
 	return centaur->fsb * ((val >> 8) & 0xff);
 }
 
@@ -111,11 +111,11 @@ static int eps_set_state(struct eps_cpu_data *centaur,
 	int i;
 
 	/* Wait while CPU is busy */
-	rdmsrq(MSR_IA32_PERF_STATUS, val);
+	val = rdmsrq(MSR_IA32_PERF_STATUS);
 	i = 0;
 	while (val & ((1 << 16) | (1 << 17))) {
 		udelay(16);
-		rdmsrq(MSR_IA32_PERF_STATUS, val);
+		val = rdmsrq(MSR_IA32_PERF_STATUS);
 		i++;
 		if (unlikely(i > 64)) {
 			return -ENODEV;
@@ -127,7 +127,7 @@ static int eps_set_state(struct eps_cpu_data *centaur,
 	i = 0;
 	do {
 		udelay(16);
-		rdmsrq(MSR_IA32_PERF_STATUS, val);
+		val = rdmsrq(MSR_IA32_PERF_STATUS);
 		i++;
 		if (unlikely(i > 64)) {
 			return -ENODEV;
@@ -139,7 +139,7 @@ static int eps_set_state(struct eps_cpu_data *centaur,
 	u8 current_multiplier, current_voltage;
 
 	/* Print voltage and multiplier */
-	rdmsrq(MSR_IA32_PERF_STATUS, val);
+	val = rdmsrq(MSR_IA32_PERF_STATUS);
 	current_voltage = val & 0xff;
 	pr_info("Current voltage = %dmV\n", current_voltage * 16 + 700);
 	current_multiplier = (val >> 8) & 0xff;
@@ -194,12 +194,12 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
 
 	switch (c->x86_model) {
 	case 10:
-		rdmsrq(0x1153, val);
+		val = rdmsrq(0x1153);
 		brand = (((val >> 2) ^ val) >> 18) & 3;
 		pr_cont("Model A ");
 		break;
 	case 13:
-		rdmsrq(0x1154, val);
+		val = rdmsrq(0x1154);
 		brand = (((val >> 4) ^ (val >> 2))) & 0x000000ff;
 		pr_cont("Model D ");
 		break;
@@ -223,12 +223,12 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
 		return -ENODEV;
 	}
 	/* Enable Enhanced PowerSaver */
-	rdmsrq(MSR_IA32_MISC_ENABLE, val);
+	val = rdmsrq(MSR_IA32_MISC_ENABLE);
 	if (!(val & MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP)) {
 		val |= MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP;
 		wrmsrq(MSR_IA32_MISC_ENABLE, val);
 		/* Can be locked at 0 */
-		rdmsrq(MSR_IA32_MISC_ENABLE, val);
+		val = rdmsrq(MSR_IA32_MISC_ENABLE);
 		if (!(val & MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP)) {
 			pr_info("Can't enable Enhanced PowerSaver\n");
 			return -ENODEV;
@@ -236,7 +236,7 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
 	}
 
 	/* Print voltage and multiplier */
-	rdmsrq(MSR_IA32_PERF_STATUS, val);
+	val = rdmsrq(MSR_IA32_PERF_STATUS);
 	current_voltage = val & 0xff;
 	pr_info("Current voltage = %dmV\n", current_voltage * 16 + 700);
 	current_multiplier = (val >> 8) & 0xff;
diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 17158cb25dd8..4681d0a51fac 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -560,7 +560,7 @@ static bool turbo_is_disabled(void)
 {
 	u64 misc_en;
 
-	rdmsrq(MSR_IA32_MISC_ENABLE, misc_en);
+	misc_en = rdmsrq(MSR_IA32_MISC_ENABLE);
 
 	return !!(misc_en & MSR_IA32_MISC_ENABLE_TURBO_DISABLE);
 }
@@ -1359,7 +1359,7 @@ static void set_power_ctl_ee_state(bool input)
 
 	guard(mutex)(&intel_pstate_driver_lock);
 
-	rdmsrq(MSR_IA32_POWER_CTL, power_ctl);
+	power_ctl = rdmsrq(MSR_IA32_POWER_CTL);
 	if (input) {
 		power_ctl &= ~BIT(MSR_IA32_POWER_CTL_BIT_EE);
 		power_ctl_ee_state = POWER_CTL_EE_ENABLE;
@@ -1736,7 +1736,7 @@ static ssize_t show_energy_efficiency(struct kobject *kobj, struct kobj_attribut
 	u64 power_ctl;
 	int enable;
 
-	rdmsrq(MSR_IA32_POWER_CTL, power_ctl);
+	power_ctl = rdmsrq(MSR_IA32_POWER_CTL);
 	enable = !!(power_ctl & BIT(MSR_IA32_POWER_CTL_BIT_EE));
 	return sprintf(buf, "%d\n", !enable);
 }
@@ -2030,7 +2030,7 @@ static int atom_get_min_pstate(int not_used)
 {
 	u64 value;
 
-	rdmsrq(MSR_ATOM_CORE_RATIOS, value);
+	value = rdmsrq(MSR_ATOM_CORE_RATIOS);
 	return (value >> 8) & 0x7F;
 }
 
@@ -2038,7 +2038,7 @@ static int atom_get_max_pstate(int not_used)
 {
 	u64 value;
 
-	rdmsrq(MSR_ATOM_CORE_RATIOS, value);
+	value = rdmsrq(MSR_ATOM_CORE_RATIOS);
 	return (value >> 16) & 0x7F;
 }
 
@@ -2046,7 +2046,7 @@ static int atom_get_turbo_pstate(int not_used)
 {
 	u64 value;
 
-	rdmsrq(MSR_ATOM_CORE_TURBO_RATIOS, value);
+	value = rdmsrq(MSR_ATOM_CORE_TURBO_RATIOS);
 	return value & 0x7F;
 }
 
@@ -2077,7 +2077,7 @@ static int silvermont_get_scaling(void)
 	static int silvermont_freq_table[] = {
 		83300, 100000, 133300, 116700, 80000};
 
-	rdmsrq(MSR_FSB_FREQ, value);
+	value = rdmsrq(MSR_FSB_FREQ);
 	i = value & 0x7;
 	WARN_ON(i > 4);
 
@@ -2093,7 +2093,7 @@ static int airmont_get_scaling(void)
 		83300, 100000, 133300, 116700, 80000,
 		93300, 90000, 88900, 87500};
 
-	rdmsrq(MSR_FSB_FREQ, value);
+	value = rdmsrq(MSR_FSB_FREQ);
 	i = value & 0xF;
 	WARN_ON(i > 8);
 
@@ -2104,7 +2104,7 @@ static void atom_get_vid(struct cpudata *cpudata)
 {
 	u64 value;
 
-	rdmsrq(MSR_ATOM_CORE_VIDS, value);
+	value = rdmsrq(MSR_ATOM_CORE_VIDS);
 	cpudata->vid.min = int_tofp((value >> 8) & 0x7f);
 	cpudata->vid.max = int_tofp((value >> 16) & 0x7f);
 	cpudata->vid.ratio = div_fp(
@@ -2112,7 +2112,7 @@ static void atom_get_vid(struct cpudata *cpudata)
 		int_tofp(cpudata->pstate.max_pstate -
 			cpudata->pstate.min_pstate));
 
-	rdmsrq(MSR_ATOM_CORE_TURBO_VIDS, value);
+	value = rdmsrq(MSR_ATOM_CORE_TURBO_VIDS);
 	cpudata->vid.turbo = value & 0x7f;
 }
 
@@ -2460,8 +2460,8 @@ static inline bool intel_pstate_sample(struct cpudata *cpu, u64 time)
 	u64 tsc;
 
 	local_irq_save(flags);
-	rdmsrq(MSR_IA32_APERF, aperf);
-	rdmsrq(MSR_IA32_MPERF, mperf);
+	aperf = rdmsrq(MSR_IA32_APERF);
+	mperf = rdmsrq(MSR_IA32_MPERF);
 	tsc = rdtsc();
 	if (cpu->prev_mperf == mperf || cpu->prev_tsc == tsc) {
 		local_irq_restore(flags);
@@ -3652,7 +3652,7 @@ static bool __init intel_pstate_platform_pwr_mgmt_exists(void)
 
 	id = x86_match_cpu(intel_pstate_cpu_oob_ids);
 	if (id) {
-		rdmsrq(MSR_MISC_PWR_MGMT, misc_pwr);
+		misc_pwr = rdmsrq(MSR_MISC_PWR_MGMT);
 		if (misc_pwr & BITMASK_OOB) {
 			pr_debug("Bit 8 or 18 in the MISC_PWR_MGMT MSR set\n");
 			pr_debug("P states are controlled in Out of Band mode by the firmware/hardware\n");
@@ -3708,7 +3708,7 @@ static bool intel_pstate_hwp_is_enabled(void)
 {
 	u64 value;
 
-	rdmsrq(MSR_PM_ENABLE, value);
+	value = rdmsrq(MSR_PM_ENABLE);
 	return !!(value & 0x1);
 }
 
diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index 4c2599264333..9bc0acc0ea69 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -121,7 +121,7 @@ static int longhaul_get_cpu_mult(void)
 	unsigned long invalue = 0;
 	u64 val;
 
-	rdmsrq(MSR_IA32_EBL_CR_POWERON, val);
+	val = rdmsrq(MSR_IA32_EBL_CR_POWERON);
 	invalue = (val & (1<<22|1<<23|1<<24|1<<25))>>22;
 	if (longhaul_version == TYPE_LONGHAUL_V2 ||
 	    longhaul_version == TYPE_POWERSAVER) {
@@ -137,7 +137,7 @@ static void do_longhaul1(unsigned int mults_index)
 {
 	union msr_bcr2 bcr2;
 
-	rdmsrq(MSR_VIA_BCR2, bcr2.val);
+	bcr2.val = rdmsrq(MSR_VIA_BCR2);
 	/* Enable software clock multiplier */
 	bcr2.bits.ESOFTBF = 1;
 	bcr2.bits.CLOCKMUL = mults_index & 0xff;
@@ -152,7 +152,7 @@ static void do_longhaul1(unsigned int mults_index)
 
 	/* Disable software clock multiplier */
 	local_irq_disable();
-	rdmsrq(MSR_VIA_BCR2, bcr2.val);
+	bcr2.val = rdmsrq(MSR_VIA_BCR2);
 	bcr2.bits.ESOFTBF = 0;
 	wrmsrq(MSR_VIA_BCR2, bcr2.val);
 }
@@ -165,7 +165,7 @@ static void do_powersaver(int cx_address, unsigned int mults_index,
 	union msr_longhaul longhaul;
 	u32 t;
 
-	rdmsrq(MSR_VIA_LONGHAUL, longhaul.val);
+	longhaul.val = rdmsrq(MSR_VIA_LONGHAUL);
 	/* Setup new frequency */
 	if (!revid_errata)
 		longhaul.bits.RevisionKey = longhaul.bits.RevisionID;
@@ -534,7 +534,7 @@ static void longhaul_setup_voltagescaling(void)
 	unsigned int j, speed, pos, kHz_step, numvscales;
 	int min_vid_speed;
 
-	rdmsrq(MSR_VIA_LONGHAUL, longhaul.val);
+	longhaul.val = rdmsrq(MSR_VIA_LONGHAUL);
 	if (!(longhaul.bits.RevisionID & 1)) {
 		pr_info("Voltage scaling not supported by CPU\n");
 		return;
@@ -836,7 +836,7 @@ static int longhaul_cpu_init(struct cpufreq_policy *policy)
 	}
 	/* Check Longhaul ver. 2 */
 	if (longhaul_version == TYPE_LONGHAUL_V2) {
-		rdmsrq(MSR_VIA_LONGHAUL, val);
+		val = rdmsrq(MSR_VIA_LONGHAUL);
 		if (val == 0)
 			/* Looks like MSR isn't present */
 			longhaul_version = TYPE_LONGHAUL_V1;
diff --git a/drivers/cpufreq/longrun.c b/drivers/cpufreq/longrun.c
index 82a7bb69c401..4b7e624ae1e5 100644
--- a/drivers/cpufreq/longrun.c
+++ b/drivers/cpufreq/longrun.c
@@ -37,14 +37,14 @@ static void longrun_get_policy(struct cpufreq_policy *policy)
 {
 	struct msr msr;
 
-	rdmsrq(MSR_TMTA_LONGRUN_FLAGS, msr.q);
+	msr.q = rdmsrq(MSR_TMTA_LONGRUN_FLAGS);
 	pr_debug("longrun flags are %x - %x\n", msr.l, msr.h);
 	if (msr.l & 0x01)
 		policy->policy = CPUFREQ_POLICY_PERFORMANCE;
 	else
 		policy->policy = CPUFREQ_POLICY_POWERSAVE;
 
-	rdmsrq(MSR_TMTA_LONGRUN_CTRL, msr.q);
+	msr.q = rdmsrq(MSR_TMTA_LONGRUN_CTRL);
 	pr_debug("longrun ctrl is %x - %x\n", msr.l, msr.h);
 	msr.l &= 0x0000007F;
 	msr.h &= 0x0000007F;
@@ -93,7 +93,7 @@ static int longrun_set_policy(struct cpufreq_policy *policy)
 		pctg_lo = pctg_hi;
 
 	/* performance or economy mode */
-	rdmsrq(MSR_TMTA_LONGRUN_FLAGS, msr.q);
+	msr.q = rdmsrq(MSR_TMTA_LONGRUN_FLAGS);
 	msr.l &= 0xFFFFFFFE;
 	switch (policy->policy) {
 	case CPUFREQ_POLICY_PERFORMANCE:
@@ -105,7 +105,7 @@ static int longrun_set_policy(struct cpufreq_policy *policy)
 	wrmsrq(MSR_TMTA_LONGRUN_FLAGS, msr.q);
 
 	/* lower and upper boundary */
-	rdmsrq(MSR_TMTA_LONGRUN_CTRL, msr.q);
+	msr.q = rdmsrq(MSR_TMTA_LONGRUN_CTRL);
 	msr.l &= 0xFFFFFF80;
 	msr.h &= 0xFFFFFF80;
 	msr.l |= pctg_lo;
@@ -177,16 +177,16 @@ static int longrun_determine_freqs(unsigned int *low_freq,
 		 * For maximum frequency, read out level zero.
 		 */
 		/* minimum */
-		rdmsrq(MSR_TMTA_LRTI_READOUT, msr.q);
+		msr.q = rdmsrq(MSR_TMTA_LRTI_READOUT);
 		msr.l = msr.h;
 		wrmsrq(MSR_TMTA_LRTI_READOUT, msr.q);
-		rdmsrq(MSR_TMTA_LRTI_VOLT_MHZ, msr.q);
+		msr.q = rdmsrq(MSR_TMTA_LRTI_VOLT_MHZ);
 		*low_freq = msr.l * 1000; /* to kHz */
 
 		/* maximum */
 		msr.l = 0;
 		wrmsrq(MSR_TMTA_LRTI_READOUT, msr.q);
-		rdmsrq(MSR_TMTA_LRTI_VOLT_MHZ, msr.q);
+		msr.q = rdmsrq(MSR_TMTA_LRTI_VOLT_MHZ);
 		*high_freq = msr.l * 1000; /* to kHz */
 
 		pr_debug("longrun table interface told %u - %u kHz\n",
@@ -203,7 +203,7 @@ static int longrun_determine_freqs(unsigned int *low_freq,
 	pr_debug("high frequency is %u kHz\n", *high_freq);
 
 	/* get current borders */
-	rdmsrq(MSR_TMTA_LONGRUN_CTRL, msr.q);
+	msr.q = rdmsrq(MSR_TMTA_LONGRUN_CTRL);
 	save.l = msr.l & 0x0000007F;
 	save.h = msr.h & 0x0000007F;
 
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index 6a930d7e6a5c..1df2a8f365a3 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -220,7 +220,7 @@ static void change_FID(int fid)
 {
 	union msr_fidvidctl fidvidctl;
 
-	rdmsrq(MSR_K7_FID_VID_CTL, fidvidctl.val);
+	fidvidctl.val = rdmsrq(MSR_K7_FID_VID_CTL);
 	if (fidvidctl.bits.FID != fid) {
 		fidvidctl.bits.SGTC = latency;
 		fidvidctl.bits.FID = fid;
@@ -235,7 +235,7 @@ static void change_VID(int vid)
 {
 	union msr_fidvidctl fidvidctl;
 
-	rdmsrq(MSR_K7_FID_VID_CTL, fidvidctl.val);
+	fidvidctl.val = rdmsrq(MSR_K7_FID_VID_CTL);
 	if (fidvidctl.bits.VID != vid) {
 		fidvidctl.bits.SGTC = latency;
 		fidvidctl.bits.VID = vid;
@@ -261,7 +261,7 @@ static int powernow_target(struct cpufreq_policy *policy, unsigned int index)
 	fid = powernow_table[index].driver_data & 0xFF;
 	vid = (powernow_table[index].driver_data & 0xFF00) >> 8;
 
-	rdmsrq(MSR_K7_FID_VID_STATUS, fidvidstatus.val);
+	fidvidstatus.val = rdmsrq(MSR_K7_FID_VID_STATUS);
 	cfid = fidvidstatus.bits.CFID;
 	freqs.old = fsb * fid_codes[cfid] / 10;
 
@@ -558,7 +558,7 @@ static unsigned int powernow_get(unsigned int cpu)
 
 	if (cpu)
 		return 0;
-	rdmsrq(MSR_K7_FID_VID_STATUS, fidvidstatus.val);
+	fidvidstatus.val = rdmsrq(MSR_K7_FID_VID_STATUS);
 	cfid = fidvidstatus.bits.CFID;
 
 	return fsb * fid_codes[cfid] / 10;
@@ -599,7 +599,7 @@ static int powernow_cpu_init(struct cpufreq_policy *policy)
 	if (policy->cpu != 0)
 		return -ENODEV;
 
-	rdmsrq(MSR_K7_FID_VID_STATUS, fidvidstatus.val);
+	fidvidstatus.val = rdmsrq(MSR_K7_FID_VID_STATUS);
 
 	recalibrate_cpu_khz();
 
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index c9bcc6f0ab7b..6097dc3e5a89 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -89,7 +89,7 @@ static int pending_bit_stuck(void)
 {
 	u64 msr;
 
-	rdmsrq(MSR_FIDVID_STATUS, msr);
+	msr = rdmsrq(MSR_FIDVID_STATUS);
 	return msr & MSR_S_LO_CHANGE_PENDING ? 1 : 0;
 }
 
@@ -107,7 +107,7 @@ static int query_current_values_with_pending_wait(struct powernow_k8_data *data)
 			pr_debug("detected change pending stuck\n");
 			return 1;
 		}
-		rdmsrq(MSR_FIDVID_STATUS, msr.q);
+		msr.q = rdmsrq(MSR_FIDVID_STATUS);
 	} while (msr.l & MSR_S_LO_CHANGE_PENDING);
 
 	data->currvid = msr.h & MSR_S_HI_CURRENT_VID;
@@ -134,7 +134,7 @@ static void fidvid_msr_init(void)
 	struct msr msr;
 	u8 fid, vid;
 
-	rdmsrq(MSR_FIDVID_STATUS, msr.q);
+	msr.q = rdmsrq(MSR_FIDVID_STATUS);
 	vid = msr.h & MSR_S_HI_CURRENT_VID;
 	fid = msr.l & MSR_S_LO_CURRENT_FID;
 	msr.l = fid | (vid << MSR_C_LO_VID_SHIFT);
@@ -293,7 +293,7 @@ static int core_voltage_pre_transition(struct powernow_k8_data *data,
 	if ((savefid < LO_FID_TABLE_TOP) && (reqfid < LO_FID_TABLE_TOP))
 		rvomult = 2;
 	rvosteps *= rvomult;
-	rdmsrq(MSR_FIDVID_STATUS, msr.q);
+	msr.q = rdmsrq(MSR_FIDVID_STATUS);
 	maxvid = 0x1f & (msr.h >> 16);
 	pr_debug("ph1 maxvid=0x%x\n", maxvid);
 	if (reqvid < maxvid) /* lower numbers are higher voltages */
diff --git a/drivers/cpufreq/speedstep-centrino.c b/drivers/cpufreq/speedstep-centrino.c
index de50fb367c6b..2e90b658bfc2 100644
--- a/drivers/cpufreq/speedstep-centrino.c
+++ b/drivers/cpufreq/speedstep-centrino.c
@@ -378,7 +378,7 @@ static int centrino_cpu_init(struct cpufreq_policy *policy)
 
 	/* Check to see if Enhanced SpeedStep is enabled, and try to
 	   enable it if not. */
-	rdmsrq(MSR_IA32_MISC_ENABLE, q);
+	q = rdmsrq(MSR_IA32_MISC_ENABLE);
 
 	if (!(q & MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP)) {
 		q |= MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP;
@@ -386,7 +386,7 @@ static int centrino_cpu_init(struct cpufreq_policy *policy)
 		wrmsrq(MSR_IA32_MISC_ENABLE, q);
 
 		/* check to see if it stuck */
-		rdmsrq(MSR_IA32_MISC_ENABLE, q);
+		q = rdmsrq(MSR_IA32_MISC_ENABLE);
 		if (!(q & MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP)) {
 			pr_info("couldn't enable Enhanced SpeedStep\n");
 			return -ENODEV;
diff --git a/drivers/cpufreq/speedstep-lib.c b/drivers/cpufreq/speedstep-lib.c
index 2afc3f177a29..188d459c7e2a 100644
--- a/drivers/cpufreq/speedstep-lib.c
+++ b/drivers/cpufreq/speedstep-lib.c
@@ -74,7 +74,7 @@ static unsigned int pentium3_get_frequency(enum speedstep_processor processor)
 	int i = 0, j = 0;
 
 	/* read MSR 0x2a - we only need the low 32 bits */
-	rdmsrq(MSR_IA32_EBL_CR_POWERON, msr.q);
+	msr.q = rdmsrq(MSR_IA32_EBL_CR_POWERON);
 	pr_debug("P3 - MSR_IA32_EBL_CR_POWERON: 0x%x 0x%x\n", msr.l, msr.h);
 	msr_tmp = msr_lo = msr.l;
 
@@ -112,7 +112,7 @@ static unsigned int pentiumM_get_frequency(void)
 	struct msr msr;
 	u32 msr_tmp;
 
-	rdmsrq(MSR_IA32_EBL_CR_POWERON, msr.q);
+	msr.q = rdmsrq(MSR_IA32_EBL_CR_POWERON);
 	pr_debug("PM - MSR_IA32_EBL_CR_POWERON: 0x%x 0x%x\n", msr.l, msr.h);
 
 	/* see table B-2 of 24547212.pdf */
@@ -136,7 +136,7 @@ static unsigned int pentium_core_get_frequency(void)
 	u32 msr_tmp;
 	int ret;
 
-	rdmsrq(MSR_FSB_FREQ, msr.q);
+	msr.q = rdmsrq(MSR_FSB_FREQ);
 	/* see table B-2 of 25366920.pdf */
 	switch (msr.l & 0x07) {
 	case 5:
@@ -161,7 +161,7 @@ static unsigned int pentium_core_get_frequency(void)
 		pr_err("PCORE - MSR_FSB_FREQ undefined value\n");
 	}
 
-	rdmsrq(MSR_IA32_EBL_CR_POWERON, msr.q);
+	msr.q = rdmsrq(MSR_IA32_EBL_CR_POWERON);
 	pr_debug("PCORE - MSR_IA32_EBL_CR_POWERON: 0x%x 0x%x\n",
 			msr.l, msr.h);
 
@@ -191,7 +191,7 @@ static unsigned int pentium4_get_frequency(void)
 	if (c->x86_model < 2)
 		return cpu_khz;
 
-	rdmsrq(0x2c, msr.q);
+	msr.q = rdmsrq(0x2c);
 
 	pr_debug("P4 - MSR_EBC_FREQUENCY_ID: 0x%x 0x%x\n", msr.l, msr.h);
 
@@ -348,7 +348,7 @@ enum speedstep_processor speedstep_detect_processor(void)
 
 		/* all mobile PIII Coppermines have FSB 100 MHz
 		 * ==> sort out a few desktop PIIIs. */
-		rdmsrq(MSR_IA32_EBL_CR_POWERON, msr.q);
+		msr.q = rdmsrq(MSR_IA32_EBL_CR_POWERON);
 		pr_debug("Coppermine: MSR_IA32_EBL_CR_POWERON is 0x%x, 0x%x\n",
 				msr.l, msr.h);
 		msr.l &= 0x00c0000;
@@ -361,7 +361,7 @@ enum speedstep_processor speedstep_detect_processor(void)
 		 * it has SpeedStep technology if either
 		 * bit 56 or 57 is set
 		 */
-		rdmsrq(MSR_IA32_PLATFORM_ID, msr.q);
+		msr.q = rdmsrq(MSR_IA32_PLATFORM_ID);
 		pr_debug("Coppermine: MSR_IA32_PLATFORM ID is 0x%x, 0x%x\n",
 				msr.l, msr.h);
 		if ((msr.h & (1<<18)) &&
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 0c0d11c72925..0c7a545c0db6 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2956,13 +2956,13 @@ static void dct_read_mc_regs(struct amd64_pvt *pvt)
 	 * Retrieve TOP_MEM and TOP_MEM2; no masking off of reserved bits since
 	 * those are Read-As-Zero.
 	 */
-	rdmsrq(MSR_K8_TOP_MEM1, pvt->top_mem);
+	pvt->top_mem = rdmsrq(MSR_K8_TOP_MEM1);
 	edac_dbg(0, "  TOP_MEM:  0x%016llx\n", pvt->top_mem);
 
 	/* Check first whether TOP_MEM2 is enabled: */
-	rdmsrq(MSR_AMD64_SYSCFG, msr_val);
+	msr_val = rdmsrq(MSR_AMD64_SYSCFG);
 	if (msr_val & BIT(21)) {
-		rdmsrq(MSR_K8_TOP_MEM2, pvt->top_mem2);
+		pvt->top_mem2 = rdmsrq(MSR_K8_TOP_MEM2);
 		edac_dbg(0, "  TOP_MEM2: 0x%016llx\n", pvt->top_mem2);
 	} else {
 		edac_dbg(0, "  TOP_MEM2 disabled\n");
diff --git a/drivers/edac/intel-bff.c b/drivers/edac/intel-bff.c
index adf2ec343129..3513cb8855ea 100644
--- a/drivers/edac/intel-bff.c
+++ b/drivers/edac/intel-bff.c
@@ -252,13 +252,13 @@ static int __init bff_init(void)
 
 	if (!cpu_feature_enabled(X86_FEATURE_MCA))
 		return -ENODEV;
-	rdmsrq(MSR_IA32_MCG_CAP, mcg_cap);
+	mcg_cap = rdmsrq(MSR_IA32_MCG_CAP);
 	if (!(mcg_cap & MCG_TES_P))
 		return -ENODEV;
 
 	if (!cpu_feature_enabled(X86_FEATURE_CORE_CAPABILITIES))
 		return -ENODEV;
-	rdmsrq(MSR_IA32_CORE_CAPS, core_caps);
+	core_caps = rdmsrq(MSR_IA32_CORE_CAPS);
 	if (!(core_caps & MSR_IA32_CORE_CAPS_BFF_RESET))
 		return -ENODEV;
 
diff --git a/drivers/gpio/gpio-cs5535.c b/drivers/gpio/gpio-cs5535.c
index a97ec7561889..e9cc577e94b7 100644
--- a/drivers/gpio/gpio-cs5535.c
+++ b/drivers/gpio/gpio-cs5535.c
@@ -148,7 +148,7 @@ int cs5535_gpio_set_irq(unsigned group, unsigned irq)
 	if (group > 7 || irq > 15)
 		return -EINVAL;
 
-	rdmsrq(MSR_PIC_ZSEL_HIGH, val.q);
+	val.q = rdmsrq(MSR_PIC_ZSEL_HIGH);
 
 	val.l &= ~(0xF << (group * 4));
 	val.l |= (irq & 0xF) << (group * 4);
diff --git a/drivers/hv/mshv_vtl_main.c b/drivers/hv/mshv_vtl_main.c
index d8225242c73f..25c88dbf3750 100644
--- a/drivers/hv/mshv_vtl_main.c
+++ b/drivers/hv/mshv_vtl_main.c
@@ -599,7 +599,7 @@ static int mshv_vtl_get_set_reg(struct hv_register_assoc *regs, bool set)
 			if (set)
 				wrmsrq(reg_table[i].msr_addr, *reg64);
 			else
-				rdmsrq(reg_table[i].msr_addr, *reg64);
+				*reg64 = rdmsrq(reg_table[i].msr_addr);
 		}
 		return 0;
 	}
diff --git a/drivers/hwmon/hwmon-vid.c b/drivers/hwmon/hwmon-vid.c
index dee42c163d92..cfb3a2975de4 100644
--- a/drivers/hwmon/hwmon-vid.c
+++ b/drivers/hwmon/hwmon-vid.c
@@ -243,10 +243,10 @@ static u8 get_via_model_d_vrm(void)
 		"C7-M", "C7", "Eden", "C7-D"
 	};
 
-	rdmsrq(0x198, msr);
+	msr = rdmsrq(0x198);
 	vid = (msr >> 32) & 0xff;
 
-	rdmsrq(0x1154, msr);
+	msr = rdmsrq(0x1154);
 	brand = ((msr >> 4) ^ (msr >> 2)) & 0x03;
 
 	if (vid > 0x3f) {
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index a045a384b949..c70efc7301a5 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -2123,35 +2123,35 @@ static void __init bxt_idle_state_table_update(void)
 	unsigned long long msr;
 	unsigned int usec;
 
-	rdmsrq(MSR_PKGC6_IRTL, msr);
+	msr = rdmsrq(MSR_PKGC6_IRTL);
 	usec = irtl_2_usec(msr);
 	if (usec) {
 		bxt_cstates[2].exit_latency = usec;
 		bxt_cstates[2].target_residency = usec;
 	}
 
-	rdmsrq(MSR_PKGC7_IRTL, msr);
+	msr = rdmsrq(MSR_PKGC7_IRTL);
 	usec = irtl_2_usec(msr);
 	if (usec) {
 		bxt_cstates[3].exit_latency = usec;
 		bxt_cstates[3].target_residency = usec;
 	}
 
-	rdmsrq(MSR_PKGC8_IRTL, msr);
+	msr = rdmsrq(MSR_PKGC8_IRTL);
 	usec = irtl_2_usec(msr);
 	if (usec) {
 		bxt_cstates[4].exit_latency = usec;
 		bxt_cstates[4].target_residency = usec;
 	}
 
-	rdmsrq(MSR_PKGC9_IRTL, msr);
+	msr = rdmsrq(MSR_PKGC9_IRTL);
 	usec = irtl_2_usec(msr);
 	if (usec) {
 		bxt_cstates[5].exit_latency = usec;
 		bxt_cstates[5].target_residency = usec;
 	}
 
-	rdmsrq(MSR_PKGC10_IRTL, msr);
+	msr = rdmsrq(MSR_PKGC10_IRTL);
 	usec = irtl_2_usec(msr);
 	if (usec) {
 		bxt_cstates[6].exit_latency = usec;
@@ -2179,7 +2179,7 @@ static void __init sklh_idle_state_table_update(void)
 	if ((mwait_substates & (0xF << 28)) == 0)
 		return;
 
-	rdmsrq(MSR_PKG_CST_CONFIG_CONTROL, msr);
+	msr = rdmsrq(MSR_PKG_CST_CONFIG_CONTROL);
 
 	/* PC10 is not enabled in PKG C-state limit */
 	if ((msr & 0xF) != 8)
@@ -2191,7 +2191,7 @@ static void __init sklh_idle_state_table_update(void)
 	/* if SGX is present */
 	if (ebx & (1 << 2)) {
 
-		rdmsrq(MSR_IA32_FEAT_CTL, msr);
+		msr = rdmsrq(MSR_IA32_FEAT_CTL);
 
 		/* if SGX is enabled */
 		if (msr & (1 << 18))
@@ -2211,7 +2211,7 @@ static bool __init skx_is_pc6_disabled(void)
 {
 	u64 msr;
 
-	rdmsrq(MSR_PKG_CST_CONFIG_CONTROL, msr);
+	msr = rdmsrq(MSR_PKG_CST_CONFIG_CONTROL);
 
 	/*
 	 * 000b: C0/C1 (no package C-state support)
@@ -2465,7 +2465,7 @@ static void auto_demotion_disable(void)
 {
 	unsigned long long msr_bits;
 
-	rdmsrq(MSR_PKG_CST_CONFIG_CONTROL, msr_bits);
+	msr_bits = rdmsrq(MSR_PKG_CST_CONFIG_CONTROL);
 	msr_bits &= ~auto_demotion_disable_flags;
 	wrmsrq(MSR_PKG_CST_CONFIG_CONTROL, msr_bits);
 }
@@ -2474,7 +2474,7 @@ static void c1e_promotion_enable(void)
 {
 	unsigned long long msr_bits;
 
-	rdmsrq(MSR_IA32_POWER_CTL, msr_bits);
+	msr_bits = rdmsrq(MSR_IA32_POWER_CTL);
 	msr_bits |= 0x2;
 	wrmsrq(MSR_IA32_POWER_CTL, msr_bits);
 }
@@ -2483,7 +2483,7 @@ static void c1e_promotion_disable(void)
 {
 	unsigned long long msr_bits;
 
-	rdmsrq(MSR_IA32_POWER_CTL, msr_bits);
+	msr_bits = rdmsrq(MSR_IA32_POWER_CTL);
 	msr_bits &= ~0x2;
 	wrmsrq(MSR_IA32_POWER_CTL, msr_bits);
 }
@@ -2552,7 +2552,7 @@ static void intel_c1_demotion_toggle(void *enable)
 {
 	unsigned long long msr_val;
 
-	rdmsrq(MSR_PKG_CST_CONFIG_CONTROL, msr_val);
+	msr_val = rdmsrq(MSR_PKG_CST_CONFIG_CONTROL);
 	/*
 	 * Enable/disable C1 undemotion along with C1 demotion, as this is the
 	 * most sensible configuration in general.
@@ -2592,7 +2592,7 @@ static ssize_t intel_c1_demotion_show(struct device *dev,
 	 * Read the MSR value for a CPU and assume it is the same for all CPUs. Any other
 	 * configuration would be a BIOS bug.
 	 */
-	rdmsrq(MSR_PKG_CST_CONFIG_CONTROL, msr_val);
+	msr_val = rdmsrq(MSR_PKG_CST_CONFIG_CONTROL);
 	return sysfs_emit(buf, "%d\n", !!(msr_val & NHM_C1_AUTO_DEMOTE));
 }
 static DEVICE_ATTR_RW(intel_c1_demotion);
diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
index 9abfc44f70f4..9006b59858ff 100644
--- a/drivers/misc/cs5535-mfgpt.c
+++ b/drivers/misc/cs5535-mfgpt.c
@@ -83,7 +83,7 @@ int cs5535_mfgpt_toggle_event(struct cs5535_mfgpt_timer *timer, int cmp,
 		return -EIO;
 	}
 
-	rdmsrq(msr, val.q);
+	val.q = rdmsrq(msr);
 
 	if (enable)
 		val.l |= mask;
@@ -114,7 +114,7 @@ int cs5535_mfgpt_set_irq(struct cs5535_mfgpt_timer *timer, int cmp, int *irq,
 	 * IRQ of the 1st. This can only happen if forcing an IRQ, calling this
 	 * with *irq==0 is safe. Currently there _are_ no 2 drivers.
 	 */
-	rdmsrq(MSR_PIC_ZSEL_LOW, zsel.q);
+	zsel.q = rdmsrq(MSR_PIC_ZSEL_LOW);
 	shift = ((cmp == MFGPT_CMP1 ? 0 : 4) + timer->nr % 4) * 4;
 	if (((zsel.l >> shift) & 0xF) == 2)
 		return -EIO;
@@ -128,7 +128,7 @@ int cs5535_mfgpt_set_irq(struct cs5535_mfgpt_timer *timer, int cmp, int *irq,
 	/* Can't use IRQ if it's 0 (=disabled), 2, or routed to LPC */
 	if (*irq < 1 || *irq == 2 || *irq > 15)
 		return -EIO;
-	rdmsrq(MSR_PIC_IRQM_LPC, lpc.q);
+	lpc.q = rdmsrq(MSR_PIC_IRQM_LPC);
 	if (lpc.l & (1 << *irq))
 		return -EIO;
 
diff --git a/drivers/mtd/nand/raw/cs553x_nand.c b/drivers/mtd/nand/raw/cs553x_nand.c
index 0b872b1e3b04..2ed13666b48f 100644
--- a/drivers/mtd/nand/raw/cs553x_nand.c
+++ b/drivers/mtd/nand/raw/cs553x_nand.c
@@ -351,20 +351,20 @@ static int __init cs553x_init(void)
 		return -ENXIO;
 
 	/* If it doesn't have the CS553[56], abort */
-	rdmsrq(MSR_DIVIL_GLD_CAP, val);
+	val = rdmsrq(MSR_DIVIL_GLD_CAP);
 	val &= ~0xFFULL;
 	if (val != CAP_CS5535 && val != CAP_CS5536)
 		return -ENXIO;
 
 	/* If it doesn't have the NAND controller enabled, abort */
-	rdmsrq(MSR_DIVIL_BALL_OPTS, val);
+	val = rdmsrq(MSR_DIVIL_BALL_OPTS);
 	if (val & PIN_OPT_IDE) {
 		pr_info("CS553x NAND controller: Flash I/O not enabled in MSR_DIVIL_BALL_OPTS.\n");
 		return -ENXIO;
 	}
 
 	for (i = 0; i < NR_CS553X_CONTROLLERS; i++) {
-		rdmsrq(MSR_DIVIL_LBAR_FLSH0 + i, val);
+		val = rdmsrq(MSR_DIVIL_LBAR_FLSH0 + i);
 
 		if ((val & (FLSH_LBAR_EN|FLSH_NOR_NAND)) == (FLSH_LBAR_EN|FLSH_NOR_NAND))
 			err = cs553x_init_one(i, !!(val & FLSH_MEM_IO), val & 0xFFFFFFFF);
diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index 50f1fdf7dfed..6320a0e45d38 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -129,7 +129,7 @@ static void copy_hashes_authenticate_chunks(struct work_struct *work)
 	msrs = ifs_get_test_msrs(dev);
 	/* run scan hash copy */
 	wrmsrq(msrs->copy_hashes, ifs_hash_ptr);
-	rdmsrq(msrs->copy_hashes_status, hashes_status.data);
+	hashes_status.data = rdmsrq(msrs->copy_hashes_status);
 
 	/* enumerate the scan image information */
 	num_chunks = hashes_status.num_chunks;
@@ -151,7 +151,7 @@ static void copy_hashes_authenticate_chunks(struct work_struct *work)
 		linear_addr |= i;
 
 		wrmsrq(msrs->copy_chunks, linear_addr);
-		rdmsrq(msrs->copy_chunks_status, chunk_status.data);
+		chunk_status.data = rdmsrq(msrs->copy_chunks_status);
 
 		ifsd->valid_chunks = chunk_status.valid_chunks;
 		err_code = chunk_status.error_code;
@@ -197,7 +197,7 @@ static int copy_hashes_authenticate_chunks_gen2(struct device *dev)
 
 	if (need_copy_scan_hashes(ifsd)) {
 		wrmsrq(msrs->copy_hashes, ifs_hash_ptr);
-		rdmsrq(msrs->copy_hashes_status, hashes_status.data);
+		hashes_status.data = rdmsrq(msrs->copy_hashes_status);
 
 		/* enumerate the scan image information */
 		chunk_size = hashes_status.chunk_size * SZ_1K;
@@ -218,7 +218,7 @@ static int copy_hashes_authenticate_chunks_gen2(struct device *dev)
 
 	if (ifsd->generation >= IFS_GEN_STRIDE_AWARE) {
 		wrmsrq(msrs->test_ctrl, INVALIDATE_STRIDE);
-		rdmsrq(msrs->copy_chunks_status, chunk_status.data);
+		chunk_status.data = rdmsrq(msrs->copy_chunks_status);
 		if (chunk_status.valid_chunks != 0) {
 			dev_err(dev, "Couldn't invalidate installed stride - %d\n",
 				chunk_status.valid_chunks);
@@ -241,7 +241,7 @@ static int copy_hashes_authenticate_chunks_gen2(struct device *dev)
 			local_irq_disable();
 			wrmsrq(msrs->copy_chunks, (u64)chunk_table);
 			local_irq_enable();
-			rdmsrq(msrs->copy_chunks_status, chunk_status.data);
+			chunk_status.data = rdmsrq(msrs->copy_chunks_status);
 			err_code = chunk_status.error_code;
 		} while (err_code == AUTH_INTERRUPTED_ERROR && --retry_count);
 
diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index dfc119d7354d..46e1ea944ce7 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -211,7 +211,7 @@ static int doscan(void *data)
 	 * are processed in a single pass) before it retires.
 	 */
 	wrmsrq(MSR_ACTIVATE_SCAN, params->activate->data);
-	rdmsrq(MSR_SCAN_STATUS, status.data);
+	status.data = rdmsrq(MSR_SCAN_STATUS);
 
 	trace_ifs_status(ifsd->cur_batch, start, stop, status.data);
 
@@ -324,7 +324,7 @@ static int do_array_test(void *data)
 	if (cpu == first) {
 		wrmsrq(MSR_ARRAY_BIST, command->data);
 		/* Pass back the result of the test */
-		rdmsrq(MSR_ARRAY_BIST, command->data);
+		command->data = rdmsrq(MSR_ARRAY_BIST);
 	}
 
 	return 0;
@@ -376,7 +376,7 @@ static int do_array_test_gen1(void *status)
 
 	if (cpu == first) {
 		wrmsrq(MSR_ARRAY_TRIGGER, ARRAY_GEN1_TEST_ALL_ARRAYS);
-		rdmsrq(MSR_ARRAY_STATUS, *((u64 *)status));
+		*((u64 *)status) = rdmsrq(MSR_ARRAY_STATUS);
 	}
 
 	return 0;
@@ -528,7 +528,7 @@ static int dosbaf(void *data)
 	 * during the "execution" of the WRMSR.
 	 */
 	wrmsrq(MSR_ACTIVATE_SBAF, run_params->activate->data);
-	rdmsrq(MSR_SBAF_STATUS, status.data);
+	status.data = rdmsrq(MSR_SBAF_STATUS);
 	trace_ifs_sbaf(ifsd->cur_batch, *run_params->activate, status);
 
 	/* Pass back the result of the test */
diff --git a/drivers/platform/x86/intel/pmc/cnp.c b/drivers/platform/x86/intel/pmc/cnp.c
index efea4e1ba52b..44979e680361 100644
--- a/drivers/platform/x86/intel/pmc/cnp.c
+++ b/drivers/platform/x86/intel/pmc/cnp.c
@@ -228,7 +228,7 @@ static void disable_c1_auto_demote(void *unused)
 	int cpunum = smp_processor_id();
 	u64 val;
 
-	rdmsrq(MSR_PKG_CST_CONFIG_CONTROL, val);
+	val = rdmsrq(MSR_PKG_CST_CONFIG_CONTROL);
 	per_cpu(pkg_cst_config, cpunum) = val;
 	val &= ~NHM_C1_AUTO_DEMOTE;
 	wrmsrq(MSR_PKG_CST_CONFIG_CONTROL, val);
diff --git a/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c b/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
index 22745b217c6f..909c9e25112d 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
@@ -40,7 +40,7 @@ static int isst_if_send_mbox_cmd(u8 command, u8 sub_command, u32 parameter,
 	/* Poll for rb bit == 0 */
 	retries = OS_MAILBOX_RETRY_COUNT;
 	do {
-		rdmsrq(MSR_OS_MAILBOX_INTERFACE, data);
+		data = rdmsrq(MSR_OS_MAILBOX_INTERFACE);
 		if (data & BIT_ULL(MSR_OS_MAILBOX_BUSY_BIT)) {
 			ret = -EBUSY;
 			continue;
@@ -65,7 +65,7 @@ static int isst_if_send_mbox_cmd(u8 command, u8 sub_command, u32 parameter,
 	/* Poll for rb bit == 0 */
 	retries = OS_MAILBOX_RETRY_COUNT;
 	do {
-		rdmsrq(MSR_OS_MAILBOX_INTERFACE, data);
+		data = rdmsrq(MSR_OS_MAILBOX_INTERFACE);
 		if (data & BIT_ULL(MSR_OS_MAILBOX_BUSY_BIT)) {
 			ret = -EBUSY;
 			continue;
@@ -75,7 +75,7 @@ static int isst_if_send_mbox_cmd(u8 command, u8 sub_command, u32 parameter,
 			return -ENXIO;
 
 		if (response_data) {
-			rdmsrq(MSR_OS_MAILBOX_DATA, data);
+			data = rdmsrq(MSR_OS_MAILBOX_DATA);
 			*response_data = data;
 		}
 		ret = 0;
diff --git a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
index bb0d0b8fc54a..57262a6afe8c 100644
--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -568,7 +568,7 @@ static bool disable_dynamic_sst_features(void)
 	if (!cpu_feature_enabled(X86_FEATURE_HWP))
 		return true;
 
-	rdmsrq(MSR_PM_ENABLE, value);
+	value = rdmsrq(MSR_PM_ENABLE);
 	return !(value & 0x1);
 }
 
diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index b1b2d9caba7b..79c07f23ba0b 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -370,7 +370,7 @@ static void ips_cpu_raise(struct ips_driver *ips)
 	if (!ips->cpu_turbo_enabled)
 		return;
 
-	rdmsrq(TURBO_POWER_CURRENT_LIMIT, turbo_override);
+	turbo_override = rdmsrq(TURBO_POWER_CURRENT_LIMIT);
 
 	cur_tdp_limit = turbo_override & TURBO_TDP_MASK;
 	new_tdp_limit = cur_tdp_limit + 8; /* 1W increase */
@@ -405,7 +405,7 @@ static void ips_cpu_lower(struct ips_driver *ips)
 	u64 turbo_override;
 	u16 cur_limit, new_limit;
 
-	rdmsrq(TURBO_POWER_CURRENT_LIMIT, turbo_override);
+	turbo_override = rdmsrq(TURBO_POWER_CURRENT_LIMIT);
 
 	cur_limit = turbo_override & TURBO_TDP_MASK;
 	new_limit = cur_limit - 8; /* 1W decrease */
@@ -437,7 +437,7 @@ static void do_enable_cpu_turbo(void *data)
 {
 	u64 perf_ctl;
 
-	rdmsrq(IA32_PERF_CTL, perf_ctl);
+	perf_ctl = rdmsrq(IA32_PERF_CTL);
 	if (perf_ctl & IA32_PERF_TURBO_DIS) {
 		perf_ctl &= ~IA32_PERF_TURBO_DIS;
 		wrmsrq(IA32_PERF_CTL, perf_ctl);
@@ -475,7 +475,7 @@ static void do_disable_cpu_turbo(void *data)
 {
 	u64 perf_ctl;
 
-	rdmsrq(IA32_PERF_CTL, perf_ctl);
+	perf_ctl = rdmsrq(IA32_PERF_CTL);
 	if (!(perf_ctl & IA32_PERF_TURBO_DIS)) {
 		perf_ctl |= IA32_PERF_TURBO_DIS;
 		wrmsrq(IA32_PERF_CTL, perf_ctl);
@@ -1215,7 +1215,7 @@ static int cpu_clamp_show(struct seq_file *m, void *data)
 	u64 turbo_override;
 	int tdp, tdc;
 
-	rdmsrq(TURBO_POWER_CURRENT_LIMIT, turbo_override);
+	turbo_override = rdmsrq(TURBO_POWER_CURRENT_LIMIT);
 
 	tdp = (int)(turbo_override & TURBO_TDP_MASK);
 	tdc = (int)((turbo_override & TURBO_TDC_MASK) >> TURBO_TDC_SHIFT);
@@ -1290,7 +1290,7 @@ static struct ips_mcp_limits *ips_detect_cpu(struct ips_driver *ips)
 		return NULL;
 	}
 
-	rdmsrq(IA32_MISC_ENABLE, misc_en);
+	misc_en = rdmsrq(IA32_MISC_ENABLE);
 	/*
 	 * If the turbo enable bit isn't set, we shouldn't try to enable/disable
 	 * turbo manually or we'll get an illegal MSR access, even though
@@ -1312,7 +1312,7 @@ static struct ips_mcp_limits *ips_detect_cpu(struct ips_driver *ips)
 		return NULL;
 	}
 
-	rdmsrq(TURBO_POWER_CURRENT_LIMIT, turbo_power);
+	turbo_power = rdmsrq(TURBO_POWER_CURRENT_LIMIT);
 	tdp = turbo_power & TURBO_TDP_MASK;
 
 	/* Sanity check TDP against CPU */
@@ -1496,7 +1496,7 @@ static int ips_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	 * Check PLATFORM_INFO MSR to make sure this chip is
 	 * turbo capable.
 	 */
-	rdmsrq(PLATFORM_INFO, platform_info);
+	platform_info = rdmsrq(PLATFORM_INFO);
 	if (!(platform_info & PLATFORM_TDP)) {
 		dev_err(&dev->dev, "platform indicates TDP override unavailable, aborting\n");
 		return -ENODEV;
@@ -1529,7 +1529,7 @@ static int ips_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	ips->mgta_val = thm_readw(THM_MGTA);
 
 	/* Save turbo limits & ratios */
-	rdmsrq(TURBO_POWER_CURRENT_LIMIT, ips->orig_turbo_limit);
+	ips->orig_turbo_limit = rdmsrq(TURBO_POWER_CURRENT_LIMIT);
 
 	ips_disable_cpu_turbo(ips);
 	ips->cpu_turbo_enabled = false;
@@ -1596,7 +1596,7 @@ static void ips_remove(struct pci_dev *dev)
 	if (ips->gpu_turbo_disable)
 		symbol_put(i915_gpu_turbo_disable);
 
-	rdmsrq(TURBO_POWER_CURRENT_LIMIT, turbo_override);
+	turbo_override = rdmsrq(TURBO_POWER_CURRENT_LIMIT);
 	turbo_override &= ~(TURBO_TDC_OVR_EN | TURBO_TDP_OVR_EN);
 	wrmsrq(TURBO_POWER_CURRENT_LIMIT, turbo_override);
 	wrmsrq(TURBO_POWER_CURRENT_LIMIT, ips->orig_turbo_limit);
diff --git a/drivers/powercap/intel_rapl_msr.c b/drivers/powercap/intel_rapl_msr.c
index d6686d03056a..e70f51dd14b9 100644
--- a/drivers/powercap/intel_rapl_msr.c
+++ b/drivers/powercap/intel_rapl_msr.c
@@ -176,7 +176,7 @@ static int rapl_msr_read_raw(int cpu, struct reg_action *ra, bool pmu_ctx)
 	 * from any CPU in the package.
 	 */
 	if (pmu_ctx) {
-		rdmsrq(ra->reg.msr, ra->value);
+		ra->value = rdmsrq(ra->reg.msr);
 		goto out;
 	}
 
diff --git a/drivers/thermal/intel/intel_hfi.c b/drivers/thermal/intel/intel_hfi.c
index 3273b8fe3d4d..6b2801aaa745 100644
--- a/drivers/thermal/intel/intel_hfi.c
+++ b/drivers/thermal/intel/intel_hfi.c
@@ -285,7 +285,7 @@ void intel_hfi_process_event(__u64 pkg_therm_status_msr_val)
 	if (!raw_spin_trylock(&hfi_instance->event_lock))
 		return;
 
-	rdmsrq(MSR_IA32_PACKAGE_THERM_STATUS, msr);
+	msr = rdmsrq(MSR_IA32_PACKAGE_THERM_STATUS);
 	hfi = msr & PACKAGE_THERM_STATUS_HFI_UPDATED;
 	if (!hfi) {
 		raw_spin_unlock(&hfi_instance->event_lock);
@@ -357,7 +357,7 @@ static void hfi_enable(void)
 {
 	u64 msr_val;
 
-	rdmsrq(MSR_IA32_HW_FEEDBACK_CONFIG, msr_val);
+	msr_val = rdmsrq(MSR_IA32_HW_FEEDBACK_CONFIG);
 	msr_val |= HW_FEEDBACK_CONFIG_HFI_ENABLE_BIT;
 	wrmsrq(MSR_IA32_HW_FEEDBACK_CONFIG, msr_val);
 }
@@ -378,7 +378,7 @@ static void hfi_disable(void)
 	u64 msr_val;
 	int i;
 
-	rdmsrq(MSR_IA32_HW_FEEDBACK_CONFIG, msr_val);
+	msr_val = rdmsrq(MSR_IA32_HW_FEEDBACK_CONFIG);
 	msr_val &= ~HW_FEEDBACK_CONFIG_HFI_ENABLE_BIT;
 	wrmsrq(MSR_IA32_HW_FEEDBACK_CONFIG, msr_val);
 
@@ -389,7 +389,7 @@ static void hfi_disable(void)
 	 * memory.
 	 */
 	for (i = 0; i < 2000; i++) {
-		rdmsrq(MSR_IA32_PACKAGE_THERM_STATUS, msr_val);
+		msr_val = rdmsrq(MSR_IA32_PACKAGE_THERM_STATUS);
 		if (msr_val & PACKAGE_THERM_STATUS_HFI_UPDATED)
 			break;
 
diff --git a/drivers/thermal/intel/therm_throt.c b/drivers/thermal/intel/therm_throt.c
index 4d4e81601d17..3ead57f45510 100644
--- a/drivers/thermal/intel/therm_throt.c
+++ b/drivers/thermal/intel/therm_throt.c
@@ -297,7 +297,7 @@ static void get_therm_status(int level, bool *proc_hot, u8 *temp)
 	else
 		msr = MSR_IA32_PACKAGE_THERM_STATUS;
 
-	rdmsrq(msr, msr_val);
+	msr_val = rdmsrq(msr);
 	if (msr_val & THERM_STATUS_PROCHOT_LOG)
 		*proc_hot = true;
 	else
@@ -543,7 +543,7 @@ static int check_directed_thermal_pkg_intr_ack(void)
 	 * Wait 15ms to be safe.
 	 */
 	do {
-		rdmsrq(MSR_IA32_PACKAGE_THERM_STATUS, msr_val);
+		msr_val = rdmsrq(MSR_IA32_PACKAGE_THERM_STATUS);
 		udelay(1);
 	} while (!(msr_val & PACKAGE_THERM_STATUS_DPTI_ACK) && --count);
 
@@ -561,7 +561,7 @@ static void config_directed_thermal_pkg_intr(void *info)
 	bool enable = *((bool *)info);
 	u64 msr_val;
 
-	rdmsrq(MSR_IA32_THERM_INTERRUPT, msr_val);
+	msr_val = rdmsrq(MSR_IA32_THERM_INTERRUPT);
 
 	if (enable)
 		msr_val |= THERM_INT_DPTI_ENABLE;
@@ -931,7 +931,7 @@ void intel_thermal_interrupt(void)
 	if (cpu_feature_enabled(X86_FEATURE_HWP))
 		notify_hwp_interrupt();
 
-	rdmsrq(MSR_IA32_THERM_STATUS, msr_val);
+	msr_val = rdmsrq(MSR_IA32_THERM_STATUS);
 
 	/* Check for violation of core thermal thresholds*/
 	notify_thresholds(msr_val);
@@ -946,7 +946,7 @@ void intel_thermal_interrupt(void)
 					CORE_LEVEL);
 
 	if (this_cpu_has(X86_FEATURE_PTS)) {
-		rdmsrq(MSR_IA32_PACKAGE_THERM_STATUS, msr_val);
+		msr_val = rdmsrq(MSR_IA32_PACKAGE_THERM_STATUS);
 		/* check violations of package thermal thresholds */
 		notify_package_thresholds(msr_val);
 		therm_throt_process(msr_val & PACKAGE_THERM_STATUS_PROCHOT,
@@ -1004,7 +1004,7 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	 * be some SMM goo which handles it, so we can't even put a handler
 	 * since it might be delivered via SMI already:
 	 */
-	rdmsrq(MSR_IA32_MISC_ENABLE, val.q);
+	val.q = rdmsrq(MSR_IA32_MISC_ENABLE);
 
 	val.h = lvtthmr_init;
 	/*
@@ -1030,7 +1030,7 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	/* early Pentium M models use different method for enabling TM2 */
 	if (cpu_has(c, X86_FEATURE_TM2)) {
 		if (c->x86 == 6 && (c->x86_model == 9 || c->x86_model == 13)) {
-			rdmsrq(MSR_THERM2_CTL, val.q);
+			val.q = rdmsrq(MSR_THERM2_CTL);
 			if (val.l & MSR_THERM2_CTL_TM_SELECT)
 				tm2 = 1;
 		} else if (val.l & MSR_IA32_MISC_ENABLE_TM2)
@@ -1044,7 +1044,7 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	thermal_intr_init_core_clear_mask();
 	thermal_intr_init_pkg_clear_mask();
 
-	rdmsrq(MSR_IA32_THERM_INTERRUPT, val.q);
+	val.q = rdmsrq(MSR_IA32_THERM_INTERRUPT);
 	if (cpu_has(c, X86_FEATURE_PLN) && !int_pln_enable) {
 		val.l |= THERM_INT_LOW_ENABLE | THERM_INT_HIGH_ENABLE;
 		val.l &= ~THERM_INT_PLN_ENABLE;
@@ -1056,7 +1056,7 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	wrmsrq(MSR_IA32_THERM_INTERRUPT, val.q);
 
 	if (cpu_has(c, X86_FEATURE_PTS)) {
-		rdmsrq(MSR_IA32_PACKAGE_THERM_INTERRUPT, val.q);
+		val.q = rdmsrq(MSR_IA32_PACKAGE_THERM_INTERRUPT);
 		if (cpu_has(c, X86_FEATURE_PLN) && !int_pln_enable) {
 			val.l |= PACKAGE_THERM_INT_LOW_ENABLE |
 				 PACKAGE_THERM_INT_HIGH_ENABLE;
@@ -1071,13 +1071,13 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 		wrmsrq(MSR_IA32_PACKAGE_THERM_INTERRUPT, val.q);
 
 		if (cpu_has(c, X86_FEATURE_HFI)) {
-			rdmsrq(MSR_IA32_PACKAGE_THERM_INTERRUPT, val.q);
+			val.q = rdmsrq(MSR_IA32_PACKAGE_THERM_INTERRUPT);
 			wrmsrq(MSR_IA32_PACKAGE_THERM_INTERRUPT,
 			       val.q | PACKAGE_THERM_INT_HFI_ENABLE);
 		}
 	}
 
-	rdmsrq(MSR_IA32_MISC_ENABLE, val.q);
+	val.q = rdmsrq(MSR_IA32_MISC_ENABLE);
 	wrmsrq(MSR_IA32_MISC_ENABLE, val.q | MSR_IA32_MISC_ENABLE_TM1);
 
 	pr_info_once("CPU0: Thermal monitoring enabled (%s)\n",
diff --git a/drivers/thermal/intel/x86_pkg_temp_thermal.c b/drivers/thermal/intel/x86_pkg_temp_thermal.c
index 43fd5bdf1d8d..11ca647802dc 100644
--- a/drivers/thermal/intel/x86_pkg_temp_thermal.c
+++ b/drivers/thermal/intel/x86_pkg_temp_thermal.c
@@ -187,7 +187,7 @@ static inline void enable_pkg_thres_interrupt(void)
 	u8 thres_0, thres_1;
 	struct msr val;
 
-	rdmsrq(MSR_IA32_PACKAGE_THERM_INTERRUPT, val.q);
+	val.q = rdmsrq(MSR_IA32_PACKAGE_THERM_INTERRUPT);
 	/* only enable/disable if it had valid threshold value */
 	thres_0 = (val.l & THERM_MASK_THRESHOLD0) >> THERM_SHIFT_THRESHOLD0;
 	thres_1 = (val.l & THERM_MASK_THRESHOLD1) >> THERM_SHIFT_THRESHOLD1;
@@ -203,7 +203,7 @@ static inline void disable_pkg_thres_interrupt(void)
 {
 	struct msr val;
 
-	rdmsrq(MSR_IA32_PACKAGE_THERM_INTERRUPT, val.q);
+	val.q = rdmsrq(MSR_IA32_PACKAGE_THERM_INTERRUPT);
 
 	val.l &= ~(THERM_INT_THRESHOLD0_ENABLE | THERM_INT_THRESHOLD1_ENABLE);
 	wrmsrq(MSR_IA32_PACKAGE_THERM_INTERRUPT, val.q);
@@ -356,7 +356,7 @@ static int pkg_temp_thermal_device_add(unsigned int cpu)
 		goto out_unregister_tz;
 
 	/* Store MSR value for package thermal interrupt, to restore at exit */
-	rdmsrq(MSR_IA32_PACKAGE_THERM_INTERRUPT, zonedev->msr_pkg_therm);
+	zonedev->msr_pkg_therm = rdmsrq(MSR_IA32_PACKAGE_THERM_INTERRUPT);
 
 	cpumask_set_cpu(cpu, &zonedev->cpumask);
 	raw_spin_lock_irq(&pkg_temp_lock);
diff --git a/drivers/video/fbdev/geode/display_gx.c b/drivers/video/fbdev/geode/display_gx.c
index b93aa21a1d2b..511cb7bf98e9 100644
--- a/drivers/video/fbdev/geode/display_gx.c
+++ b/drivers/video/fbdev/geode/display_gx.c
@@ -26,7 +26,7 @@ unsigned int gx_frame_buffer_size(void)
 		struct msr msr;
 
 		/* The number of pages is (PMAX - PMIN)+1 */
-		rdmsrq(MSR_GLIU_P2D_RO0, msr.q);
+		msr.q = rdmsrq(MSR_GLIU_P2D_RO0);
 
 		/* PMAX */
 		val = ((msr.h & 0xff) << 12) | ((msr.l & 0xfff00000) >> 20);
diff --git a/drivers/video/fbdev/geode/gxfb_core.c b/drivers/video/fbdev/geode/gxfb_core.c
index 8d69be7c9d31..e0a3447f2b1b 100644
--- a/drivers/video/fbdev/geode/gxfb_core.c
+++ b/drivers/video/fbdev/geode/gxfb_core.c
@@ -378,7 +378,7 @@ static int gxfb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* Figure out if this is a TFT or CRT part */
 
-	rdmsrq(MSR_GX_GLD_MSR_CONFIG, val);
+	val = rdmsrq(MSR_GX_GLD_MSR_CONFIG);
 
 	if ((val & MSR_GX_GLD_MSR_CONFIG_FP) == MSR_GX_GLD_MSR_CONFIG_FP)
 		par->enable_crt = 0;
diff --git a/drivers/video/fbdev/geode/lxfb_ops.c b/drivers/video/fbdev/geode/lxfb_ops.c
index f5f1134cae9a..980a782214a2 100644
--- a/drivers/video/fbdev/geode/lxfb_ops.c
+++ b/drivers/video/fbdev/geode/lxfb_ops.c
@@ -127,7 +127,7 @@ static void lx_set_dotpll(u32 pllval)
 	struct msr dotpll;
 	int i;
 
-	rdmsrq(MSR_GLCP_DOTPLL, dotpll.q);
+	dotpll.q = rdmsrq(MSR_GLCP_DOTPLL);
 
 	if ((dotpll.l & MSR_GLCP_DOTPLL_LOCK) && (dotpll.h == pllval))
 		return;
@@ -145,7 +145,7 @@ static void lx_set_dotpll(u32 pllval)
 	/* Now, loop for the lock bit */
 
 	for (i = 0; i < 1000; i++) {
-		rdmsrq(MSR_GLCP_DOTPLL, dotpll.q);
+		dotpll.q = rdmsrq(MSR_GLCP_DOTPLL);
 		if (dotpll.l & MSR_GLCP_DOTPLL_LOCK)
 			break;
 	}
@@ -316,7 +316,7 @@ unsigned int lx_framebuffer_size(void)
 		struct msr msr;
 
 		/* The number of pages is (PMAX - PMIN)+1 */
-		rdmsrq(MSR_GLIU_P2D_RO0, msr.q);
+		msr.q = rdmsrq(MSR_GLIU_P2D_RO0);
 
 		/* PMAX */
 		val = ((msr.h & 0xff) << 12) | ((msr.l & 0xfff00000) >> 20);
@@ -359,7 +359,7 @@ void lx_set_mode(struct fb_info *info)
 
 	/* Set output mode */
 
-	rdmsrq(MSR_LX_GLD_MSR_CONFIG, msrval);
+	msrval = rdmsrq(MSR_LX_GLD_MSR_CONFIG);
 	msrval &= ~MSR_LX_GLD_MSR_CONFIG_FMT;
 
 	if (par->output & OUTPUT_PANEL) {
@@ -420,7 +420,7 @@ void lx_set_mode(struct fb_info *info)
 
 	/* Set default watermark values */
 
-	rdmsrq(MSR_LX_SPARE_MSR, msrval);
+	msrval = rdmsrq(MSR_LX_SPARE_MSR);
 
 	msrval &= ~(MSR_LX_SPARE_MSR_DIS_CFIFO_HGO
 			| MSR_LX_SPARE_MSR_VFIFO_ARB_SEL
@@ -592,10 +592,10 @@ static void lx_save_regs(struct lxfb_par *par)
 	} while ((i & GP_BLT_STATUS_PB) || !(i & GP_BLT_STATUS_CE));
 
 	/* save MSRs */
-	rdmsrq(MSR_LX_MSR_PADSEL, par->msr.padsel);
-	rdmsrq(MSR_GLCP_DOTPLL, par->msr.dotpll);
-	rdmsrq(MSR_LX_GLD_MSR_CONFIG, par->msr.dfglcfg);
-	rdmsrq(MSR_LX_SPARE_MSR, par->msr.dcspare);
+	par->msr.padsel = rdmsrq(MSR_LX_MSR_PADSEL);
+	par->msr.dotpll = rdmsrq(MSR_GLCP_DOTPLL);
+	par->msr.dfglcfg = rdmsrq(MSR_LX_GLD_MSR_CONFIG);
+	par->msr.dcspare = rdmsrq(MSR_LX_SPARE_MSR);
 
 	write_dc(par, DC_UNLOCK, DC_UNLOCK_UNLOCK);
 
diff --git a/drivers/video/fbdev/geode/suspend_gx.c b/drivers/video/fbdev/geode/suspend_gx.c
index 6c0a526ee8a2..2fa20acba62e 100644
--- a/drivers/video/fbdev/geode/suspend_gx.c
+++ b/drivers/video/fbdev/geode/suspend_gx.c
@@ -21,8 +21,8 @@ static void gx_save_regs(struct gxfb_par *par)
 	} while (i & (GP_BLT_STATUS_BLT_PENDING | GP_BLT_STATUS_BLT_BUSY));
 
 	/* save MSRs */
-	rdmsrq(MSR_GX_MSR_PADSEL, par->msr.padsel);
-	rdmsrq(MSR_GLCP_DOTPLL, par->msr.dotpll);
+	par->msr.padsel = rdmsrq(MSR_GX_MSR_PADSEL);
+	par->msr.dotpll = rdmsrq(MSR_GLCP_DOTPLL);
 
 	write_dc(par, DC_UNLOCK, DC_UNLOCK_UNLOCK);
 
@@ -43,7 +43,7 @@ static void gx_set_dotpll(uint32_t dotpll_hi)
 	struct msr dotpll;
 	int i;
 
-	rdmsrq(MSR_GLCP_DOTPLL, dotpll.q);
+	dotpll.q = rdmsrq(MSR_GLCP_DOTPLL);
 	dotpll.l |= MSR_GLCP_DOTPLL_DOTRESET;
 	dotpll.l &= ~MSR_GLCP_DOTPLL_BYPASS;
 	dotpll.h = dotpll_hi;
@@ -51,7 +51,7 @@ static void gx_set_dotpll(uint32_t dotpll_hi)
 
 	/* wait for the PLL to lock */
 	for (i = 0; i < 200; i++) {
-		rdmsrq(MSR_GLCP_DOTPLL, dotpll.q);
+		dotpll.q = rdmsrq(MSR_GLCP_DOTPLL);
 		if (dotpll.l & MSR_GLCP_DOTPLL_LOCK)
 			break;
 		udelay(1);
diff --git a/drivers/video/fbdev/geode/video_gx.c b/drivers/video/fbdev/geode/video_gx.c
index 5717c3356949..b2cfadaf3ff8 100644
--- a/drivers/video/fbdev/geode/video_gx.c
+++ b/drivers/video/fbdev/geode/video_gx.c
@@ -142,8 +142,8 @@ void gx_set_dclk_frequency(struct fb_info *info)
 		}
 	}
 
-	rdmsrq(MSR_GLCP_SYS_RSTPLL, sys_rstpll);
-	rdmsrq(MSR_GLCP_DOTPLL, dotpll);
+	sys_rstpll = rdmsrq(MSR_GLCP_SYS_RSTPLL);
+	dotpll = rdmsrq(MSR_GLCP_DOTPLL);
 
 	/* Program new M, N and P. */
 	dotpll &= 0x00000000ffffffffull;
@@ -167,7 +167,7 @@ void gx_set_dclk_frequency(struct fb_info *info)
 
 	/* Wait for LOCK bit. */
 	do {
-		rdmsrq(MSR_GLCP_DOTPLL, dotpll);
+		dotpll = rdmsrq(MSR_GLCP_DOTPLL);
 	} while (timeout-- && !(dotpll & MSR_GLCP_DOTPLL_LOCK));
 }
 
@@ -180,7 +180,7 @@ gx_configure_tft(struct fb_info *info)
 
 	/* Set up the DF pad select MSR */
 
-	rdmsrq(MSR_GX_MSR_PADSEL, val);
+	val = rdmsrq(MSR_GX_MSR_PADSEL);
 	val &= ~MSR_GX_MSR_PADSEL_MASK;
 	val |= MSR_GX_MSR_PADSEL_TFT;
 	wrmsrq(MSR_GX_MSR_PADSEL, val);
diff --git a/include/linux/cs5535.h b/include/linux/cs5535.h
index 5ec2aca537bb..fef236cab7d8 100644
--- a/include/linux/cs5535.h
+++ b/include/linux/cs5535.h
@@ -51,7 +51,7 @@ static inline int cs5535_pic_unreqz_select_high(unsigned int group,
 {
 	struct msr val;
 
-	rdmsrq(MSR_PIC_ZSEL_HIGH, val.q);
+	val.q = rdmsrq(MSR_PIC_ZSEL_HIGH);
 	val.l &= ~(0xF << (group * 4));
 	val.l |= (irq & 0xF) << (group * 4);
 	wrmsrq(MSR_PIC_ZSEL_HIGH, val.q);
-- 
2.56.0

