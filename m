Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793019751;
	b=HDy544LZNNR7TwcC4mLQzyh37UvJeJSp3HDccg2AdQHWYIgveNdXkAdxlF8/40s87adl
	 FR4NBf9XtWDFhjJm9D4X/jyhAt3E5p+uEdhShKpOSevoNvMMT507xf8mlVZyxx7pM0moF
	 bAz+45JhKZHBB4wiL58EvlmKxrLTBkd+f4wcY9ps16G3ZA2k74BdPVOg4M4igEQHe7lj7
	 UW5ral5jLr/2P5IYAJCqPIFdrSnDO0DL7kM2Z4v3vvDKYf8tLcuPSAsi4HKCWGD8f5UWU
	 6Biq25PqvUFZJGm/UAusdzjKqd2ymiOIj9xezw41ZZ2bXhtOPmH1tGm/Qfxd4ucbtDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793019751;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:
	 X-Spamd-Result:X-Spam-Score;
	bh=VgucDQGlpzyRpthc04g7/oRg6NX1oBAdxDc/UgjwdQw=;
	b=PrVX+rPfO5cvX8uSbs9VvHef0iXUvBT3d0ou7UxsQsVGYcu0SFSQ4vOpC4v9zSfv9Wlk
	 QFleIYfpe34F+gemZmSuv2SeIjvczxl8S1VOd1pm8tgyckCX1apjhvAkDM3HfbcdvdRnI
	 5d8MaKhDs2iBzNdN6aWDW/CMIflF1hGjgInNVarGFjPP9uDV6+21o5sc4MoRHRa8/xvQ4
	 Y0ZlVy+ERQnz5syxvxHT8sr5nF167MiVRLjBv6PbbaTpTAyuf74CQRE7VsTg1F+jJhPvj
	 nGnbilhPllwaXhG45KFr8SJIOKpIO21AfVajztxqlA254MWNckKnfKe6DXLE++oX3zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=JJ17nvYM;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=JJ17nvYM;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADFF606A325;
	Mon, 26 Oct 2026 13:02:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4ADFF606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=JJ17nvYM;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=JJ17nvYM
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 491121F461;
	Mon, 26 Oct 2026 13:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793019748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VgucDQGlpzyRpthc04g7/oRg6NX1oBAdxDc/UgjwdQw=;
	b=JJ17nvYMH3Y9kIckqy6Y5tJHT+fxv7TDUxcVfKccWHoD50mqQbH+hNM2c2hvMMjr/kBmMY
	oXpu9UOTuwrkToNMxTLQys1MhXYd4kAzwIqHxFz3hF3W+PS7xhIKY4h/VKbLYDyripnlMG
	GSL+hGu0ouKDyR1+nDCWhv1EumU3ogE=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793019748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VgucDQGlpzyRpthc04g7/oRg6NX1oBAdxDc/UgjwdQw=;
	b=JJ17nvYMH3Y9kIckqy6Y5tJHT+fxv7TDUxcVfKccWHoD50mqQbH+hNM2c2hvMMjr/kBmMY
	oXpu9UOTuwrkToNMxTLQys1MhXYd4kAzwIqHxFz3hF3W+PS7xhIKY4h/VKbLYDyripnlMG
	GSL+hGu0ouKDyR1+nDCWhv1EumU3ogE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E928313408;
	Mon, 26 Oct 2026 13:02:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4jNRLWFP32puWgAAD6G6ig
	(envelope-from <jgross@suse.com>); Mon, 26 Oct 2026 13:02:25 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	virtualization@lists.linux.dev,
	linux-ide@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-fbdev@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	platform-driver-x86@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	David Airlie <airlied@redhat.com>,
	Helge Deller <deller@gmx.de>,
	linux-geode@lists.infradead.org,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
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
	Viresh Kumar <viresh.kumar@linaro.org>,
	Huang Rui <ray.huang@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Perry Yuan <perry.yuan@amd.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
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
	xen-devel@lists.xenproject.org
Subject: [PATCH v5 00/12] x86/msr: Drop 32-bit MSR interfaces
Date: Mon, 26 Oct 2026 14:02:11 +0100
Message-ID: <20261026130223.773129-1-jgross@suse.com>
X-Mailer: git-send-email 2.56.0
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-10.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,kernel.org,redhat.com,alien8.de,linux.intel.com,zytor.com,broadcom.com,gmx.de,lists.infradead.org,selenic.com,gondor.apana.org.au,infradead.org,arm.com,google.com,intel.com,linaro.org,microsoft.com,hygon.cn,amd.com,zhaoxin.com,oracle.com,roeck-us.net,gmail.com,arndb.de,linuxfoundation.org,bootlin.com,nod.at,ti.com,lists.xenproject.org];
	R_RATELIMIT(0.00)[to_ip_from(RLbixyxwsf3a5i7e4ez64ejni4)];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCPT_COUNT_GT_50(0.00)[93];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -10.80

For accessing the MSR registers on the local CPU, there are 2 types of
interfaces: the "modern" 64-bit ones (rdmsrq() etc.) and the 32-bit
ones (rdmsr() etc.) which are using the upper and lower 32-bit halves
of the 64-bit wide MSR register values.

The 32-bit interfaces are not optimal for 3 reasons:

- They are based on primitives using 64-bit sized values anyway.

- Modern x86 CPUs have added support for MSR access instructions using
  an immediate value instead of a register for addressing the MSR,
  while the value is in a 64-bit register.

- rdmsr() is a macro storing the upper and lower 32-bit halves in
  variables specified as macro parameters. This is obscuring variable
  assignment through a macro. Additionally rdmsrq() is mimicking this
  pattern by being a macro, too, with the target variable specified as
  a parameter as well.

For those reasons drop the 32-bit interfaces for accessing the x86 MSR
registers completely and only use the 64-bit variants.

This allows to switch all "high-level" MSR access macros to inline
functions in the end.

This series will be used as the base for further reorganisation of the
MSR access functions, especially for completely inlining the MSR
access instructions even with paravirtualization being active.

Based on kernel 7.4 as of 2026-10-26.

IMHO at least patches 2 and 3 should be applied rather sooner than later
in order to avoid new instances of the 32-bit variants of the *_safe()
functions creeping in again.

Changes in V2:
- dropped already applied patches
- added patch 1
- rebased

Changes in V3:
- small fixes in patches 4 and 13
- rebased

Changes in V4:
- rebased

Changes in V5:
- patch 9 of V4 has been applied
- rebased

Juergen Gross (12):
  x86/cpu: Fix coding style violation
  x86/msr: Remove wrmsr_safe()
  x86/msr: Remove rdmsr_safe()
  drivers/ata: Stop using 32-bit MSR interfaces
  agp/nvidia: Stop using 32-bit MSR interfaces
  fbdev/geode: Stop using 32-bit MSR interfaces
  hw_random/via-rng: Stop using 32-bit MSR interfaces
  drivers/gpio: Stop using 32-bit MSR interfaces
  x86/msr: Remove wrmsr()
  x86/msr: Remove rdmsr()
  treewide: convert rdmsrq() from a macro to an inline function
  x86/msr: Simplify some rdmsrq() use cases

 arch/x86/coco/sev/core.c                      |  2 +-
 arch/x86/events/amd/brs.c                     |  4 +-
 arch/x86/events/amd/core.c                    |  8 +--
 arch/x86/events/amd/ibs.c                     | 18 +++----
 arch/x86/events/amd/lbr.c                     | 16 ++----
 arch/x86/events/amd/power.c                   |  8 +--
 arch/x86/events/amd/uncore.c                  |  4 +-
 arch/x86/events/core.c                        | 20 ++++----
 arch/x86/events/intel/core.c                  | 15 ++----
 arch/x86/events/intel/cstate.c                |  5 +-
 arch/x86/events/intel/ds.c                    |  2 +-
 arch/x86/events/intel/knc.c                   | 10 ++--
 arch/x86/events/intel/lbr.c                   | 25 +++-------
 arch/x86/events/intel/p4.c                    |  6 +--
 arch/x86/events/intel/p6.c                    |  4 +-
 arch/x86/events/intel/pt.c                    | 12 ++---
 arch/x86/events/intel/uncore.c                |  6 +--
 arch/x86/events/intel/uncore_nhmex.c          |  4 +-
 arch/x86/events/intel/uncore_snb.c            |  2 +-
 arch/x86/events/intel/uncore_snbep.c          |  6 +--
 arch/x86/events/msr.c                         |  2 +-
 arch/x86/events/perf_event.h                  |  6 +--
 arch/x86/events/rapl.c                        |  6 +--
 arch/x86/events/zhaoxin/core.c                | 10 ++--
 arch/x86/hyperv/hv_apic.c                     |  9 ++--
 arch/x86/hyperv/hv_init.c                     | 26 +++++-----
 arch/x86/hyperv/hv_spinlock.c                 |  2 +-
 arch/x86/include/asm/apic.h                   |  7 +--
 arch/x86/include/asm/debugreg.h               |  6 +--
 arch/x86/include/asm/fsgsbase.h               |  2 +-
 arch/x86/include/asm/kvm_host.h               | 10 ----
 arch/x86/include/asm/msr.h                    | 39 ++-------------
 arch/x86/include/asm/paravirt.h               | 26 +---------
 arch/x86/kernel/apic/apic.c                   | 14 +++---
 arch/x86/kernel/apic/apic_numachip.c          |  6 +--
 arch/x86/kernel/cet.c                         |  2 +-
 arch/x86/kernel/cpu/amd.c                     | 14 +++---
 arch/x86/kernel/cpu/aperfmperf.c              |  8 +--
 arch/x86/kernel/cpu/bugs.c                    | 12 ++---
 arch/x86/kernel/cpu/bus_lock.c                |  8 +--
 arch/x86/kernel/cpu/centaur.c                 |  8 +--
 arch/x86/kernel/cpu/common.c                  | 12 ++---
 arch/x86/kernel/cpu/feat_ctl.c                |  4 +-
 arch/x86/kernel/cpu/hygon.c                   |  4 +-
 arch/x86/kernel/cpu/intel.c                   |  6 +--
 arch/x86/kernel/cpu/intel_epb.c               |  4 +-
 arch/x86/kernel/cpu/mce/amd.c                 |  4 +-
 arch/x86/kernel/cpu/mce/core.c                |  8 +--
 arch/x86/kernel/cpu/mce/inject.c              |  2 +-
 arch/x86/kernel/cpu/mce/intel.c               | 18 +++----
 arch/x86/kernel/cpu/mce/p5.c                  |  8 +--
 arch/x86/kernel/cpu/mce/winchip.c             |  2 +-
 arch/x86/kernel/cpu/microcode/intel.c         |  2 +-
 arch/x86/kernel/cpu/mshyperv.c                |  6 +--
 arch/x86/kernel/cpu/mtrr/amd.c                |  4 +-
 arch/x86/kernel/cpu/mtrr/cleanup.c            |  4 +-
 arch/x86/kernel/cpu/mtrr/generic.c            | 32 ++++++------
 arch/x86/kernel/cpu/mtrr/mtrr.c               |  2 +-
 arch/x86/kernel/cpu/resctrl/core.c            |  2 +-
 arch/x86/kernel/cpu/resctrl/monitor.c         |  4 +-
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c     |  4 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c        |  2 +-
 arch/x86/kernel/cpu/topology.c                |  2 +-
 arch/x86/kernel/cpu/topology_amd.c            |  4 +-
 arch/x86/kernel/cpu/transmeta.c               |  8 +--
 arch/x86/kernel/cpu/tsx.c                     | 10 ++--
 arch/x86/kernel/cpu/umwait.c                  |  2 +-
 arch/x86/kernel/cpu/zhaoxin.c                 |  4 +-
 arch/x86/kernel/fpu/core.c                    |  2 +-
 arch/x86/kernel/hpet.c                        |  2 +-
 arch/x86/kernel/kvm.c                         |  2 +-
 arch/x86/kernel/mmconf-fam10h_64.c            |  6 +--
 arch/x86/kernel/process.c                     |  4 +-
 arch/x86/kernel/process_64.c                  | 14 +++---
 arch/x86/kernel/shstk.c                       |  8 +--
 arch/x86/kernel/traps.c                       |  4 +-
 arch/x86/kernel/tsc.c                         |  2 +-
 arch/x86/kernel/tsc_msr.c                     |  6 +--
 arch/x86/kernel/tsc_sync.c                    |  6 +--
 arch/x86/kvm/msrs.c                           |  2 +-
 arch/x86/kvm/svm/pmu.c                        |  4 +-
 arch/x86/kvm/svm/svm.c                        |  6 +--
 arch/x86/kvm/vmx/main.c                       |  2 +-
 arch/x86/kvm/vmx/nested.c                     |  4 +-
 arch/x86/kvm/vmx/pmu_intel.c                  |  8 +--
 arch/x86/kvm/vmx/sgx.c                        |  6 +--
 arch/x86/kvm/vmx/tdx.c                        |  2 +-
 arch/x86/kvm/vmx/vmx.c                        | 40 +++++++--------
 arch/x86/kvm/x86.c                            |  6 +--
 arch/x86/lib/insn-eval.c                      |  6 +--
 arch/x86/lib/msr-smp.c                        |  2 +-
 arch/x86/mm/pat/memtype.c                     |  2 +-
 arch/x86/pci/amd_bus.c                        |  8 +--
 arch/x86/platform/olpc/olpc-xo1-rtc.c         |  6 +--
 arch/x86/platform/olpc/olpc-xo1-sci.c         |  2 +-
 arch/x86/power/cpu.c                          | 10 ++--
 arch/x86/realmode/init.c                      |  2 +-
 arch/x86/virt/hw.c                            |  8 +--
 arch/x86/virt/svm/sev.c                       | 22 ++++----
 arch/x86/virt/vmx/tdx/tdx.c                   |  2 +-
 arch/x86/xen/suspend.c                        |  2 +-
 drivers/acpi/processor_perflib.c              |  2 +-
 drivers/ata/pata_cs5535.c                     | 24 ++++-----
 drivers/ata/pata_cs5536.c                     | 17 +++----
 drivers/char/agp/nvidia-agp.c                 | 32 ++++++------
 drivers/char/hw_random/via-rng.c              | 29 +++++------
 drivers/cpufreq/acpi-cpufreq.c                |  8 +--
 drivers/cpufreq/amd-pstate.c                  |  4 +-
 drivers/cpufreq/e_powersaver.c                | 20 ++++----
 drivers/cpufreq/intel_pstate.c                | 28 +++++------
 drivers/cpufreq/longhaul.c                    | 12 ++---
 drivers/cpufreq/longrun.c                     | 16 +++---
 drivers/cpufreq/powernow-k7.c                 | 10 ++--
 drivers/cpufreq/powernow-k8.c                 |  8 +--
 drivers/cpufreq/speedstep-centrino.c          |  4 +-
 drivers/cpufreq/speedstep-lib.c               | 14 +++---
 drivers/edac/amd64_edac.c                     |  6 +--
 drivers/edac/intel-bff.c                      |  4 +-
 drivers/gpio/gpio-cs5535.c                    | 10 ++--
 drivers/hv/mshv_vtl_main.c                    |  2 +-
 drivers/hwmon/hwmon-vid.c                     |  4 +-
 drivers/idle/intel_idle.c                     | 26 +++++-----
 drivers/misc/cs5535-mfgpt.c                   |  6 +--
 drivers/mtd/nand/raw/cs553x_nand.c            |  6 +--
 drivers/platform/x86/intel/ifs/load.c         | 10 ++--
 drivers/platform/x86/intel/ifs/runtest.c      |  8 +--
 drivers/platform/x86/intel/pmc/cnp.c          |  2 +-
 .../intel/speed_select_if/isst_if_mbox_msr.c  |  6 +--
 .../intel/speed_select_if/isst_tpmi_core.c    |  2 +-
 drivers/platform/x86/intel_ips.c              | 20 ++++----
 drivers/powercap/intel_rapl_msr.c             |  2 +-
 drivers/thermal/intel/intel_hfi.c             |  8 +--
 drivers/thermal/intel/therm_throt.c           | 22 ++++----
 drivers/thermal/intel/x86_pkg_temp_thermal.c  |  6 +--
 drivers/video/fbdev/geode/display_gx.c        |  8 +--
 drivers/video/fbdev/geode/gxfb_core.c         |  2 +-
 drivers/video/fbdev/geode/lxfb_ops.c          | 50 +++++++++----------
 drivers/video/fbdev/geode/suspend_gx.c        | 24 +++++----
 drivers/video/fbdev/geode/video_gx.c          |  8 +--
 include/linux/cs5535.h                        | 10 ++--
 140 files changed, 567 insertions(+), 685 deletions(-)

-- 
2.56.0

