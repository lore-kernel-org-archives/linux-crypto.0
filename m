Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2C734B408;
	Mon,  9 Mar 2026 18:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079292; cv=none; b=g+urN8aBOXCcc1/4jHMTOCH6fk/vVtQsm5K7V7r+gNCcnbIJMk003guCxG43rohgSyR5k8ESSTq5LSBIA2YYMe2HN5xu8wfvw+lsNtUzV2n4twyc7GSQC93Hqt7OF9MMfCtTOrXTDglzUgs0ctjbIJPrlktLSFM4zMcZVEVMm3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079292; c=relaxed/simple;
	bh=SeTaaMFQof9ylHh0W6XyzL5ZnPxEAQuaJ3T/0ofB0aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnI5WzzKoUKceoutIPJj8xPL98w0Rw7RVCg3wiedizHGu6puh6q4YJQBpoUXq6eelaXz3T0Sy2jcMeBW3iAXwwg/r94UPVhQguSYYTNiJUZ+p65JRsPQ+dqI4Vqn3yhctmBdDN11cHi2e5ZfFsnVjDEi+ATtic/aSt+oI9sWyAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=smVrMKUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="smVrMKUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB12C2BCB0;
	Mon,  9 Mar 2026 18:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773079292;
	bh=SeTaaMFQof9ylHh0W6XyzL5ZnPxEAQuaJ3T/0ofB0aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smVrMKUVN0lv2Q6yFzcheFrz1I5M+nE6Z4fzD414kurXUXrFvyH6mtiCF2HAuqD46
	 4pO2hzR58CaIfHOGygpTI6jTdiPOgmZOTRuJgshhgoyD1+1QwYJ2oXZRBLoGL0AFe4
	 D64VwcQ8DrbcphUB4ZrUGqdlZhJJ+fJ7mRLJkgthlxZRbMCTvxpA+9DBz62StS3EoQ
	 OA076eC5a5wqNzR235RpaQOzbpjQpq7khC4Gy1RdZ4ujiMVdAtdbOE7u/iF/kwPj1z
	 ovRF8v7FizUio/29hWRmNPwiBujqixN2sapqhSxnbejgxJyLpbcnk+PoYdA4//oEBo
	 B8y/solY6Hfag==
From: Tycho Andersen <tycho@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kim Phillips <kim.phillips@amd.com>,
	Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH v2 08/10] x86/snp: create snp_x86_shutdown()
Date: Mon,  9 Mar 2026 12:00:50 -0600
Message-ID: <20260309180053.2389118-9-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260309180053.2389118-1-tycho@kernel.org>
References: <20260306153846.GKaar1Bg_1EKm17tXJ@fat_crate.local>
 <20260309180053.2389118-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

After SNP_SHUTDOWN, two architecture-level things should be done:

1. clear the RMP table
2. disable MFDM to prevent the FW_WARN in k8_check_syscfg_dram_mod_en() in
   the event of a kexec

Create and export to the CCP driver a function that does them.

Also change the MFDM helper to allow for disabling the bit, since the SNP
x86 shutdown path needs to disable MFDM. The comment for
k8_check_syscfg_dram_mod_en() notes, the "BIOS" is supposed clear it, or
the kernel in the case of module unload and shutdown followed by kexec.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev.h |  2 ++
 arch/x86/virt/svm/sev.c    | 23 ++++++++++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 0bcd89d4fe90..36d2b1ea19c0 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -662,6 +662,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 	__snp_leak_pages(pfn, pages, true);
 }
 void snp_prepare_for_snp_init(void);
+void snp_x86_shutdown(void);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_rmptable_init(void) { return -ENOSYS; }
@@ -679,6 +680,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
 static inline void snp_prepare_for_snp_init(void) {}
+static inline void snp_x86_shutdown(void) {}
 #endif
 
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index cc10d059140d..321f3c004fbc 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -132,12 +132,15 @@ static unsigned long snp_nr_leaked_pages;
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
-static void mfd_enable(void *arg)
+static void mfd_reconfigure(void *arg)
 {
 	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return;
 
-	msr_set_bit(MSR_AMD64_SYSCFG, MSR_AMD64_SYSCFG_MFDM_BIT);
+	if (arg)
+		msr_set_bit(MSR_AMD64_SYSCFG, MSR_AMD64_SYSCFG_MFDM_BIT);
+	else
+		msr_clear_bit(MSR_AMD64_SYSCFG, MSR_AMD64_SYSCFG_MFDM_BIT);
 }
 
 static void snp_enable(void *arg)
@@ -526,7 +529,7 @@ void snp_prepare_for_snp_init(void)
 	 * MtrrFixDramModEn is not shared between threads on a core,
 	 * therefore it must be set on all CPUs prior to enabling SNP.
 	 */
-	on_each_cpu(mfd_enable, NULL, 1);
+	on_each_cpu(mfd_reconfigure, (void *)1, 1);
 
 	on_each_cpu(snp_enable, NULL, 1);
 
@@ -535,6 +538,20 @@ void snp_prepare_for_snp_init(void)
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare_for_snp_init, "ccp");
 
+void snp_x86_shutdown(void)
+{
+	u64 syscfg;
+
+	rdmsrq(MSR_AMD64_SYSCFG, syscfg);
+
+	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
+		return;
+
+	snp_clear_rmp();
+	on_each_cpu(mfd_reconfigure, 0, 1);
+}
+EXPORT_SYMBOL_FOR_MODULES(snp_x86_shutdown, "ccp");
+
 /*
  * Do the necessary preparations which are verified by the firmware as
  * described in the SNP_INIT_EX firmware command description in the SNP
-- 
2.53.0

