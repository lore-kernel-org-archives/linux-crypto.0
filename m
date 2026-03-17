Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A89531619D;
	Tue, 17 Mar 2026 16:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773764602; cv=none; b=m3/8sBE08UQqfQb2uwQS3Ombl3H9T4VaGpBWIKiFxXo1T47j7S+SSOWNklAbbErTQmD4qYUWX9Hy+jQEvEBMgcvMSxm56+y7WSmPdGTCMAb4ykSRnvzaSIToS5M2gdMLh1Llv+9oVHWdXvtluuepv4JDFrPSp1XO7NIAkDbyADY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773764602; c=relaxed/simple;
	bh=XU6lMFg6u5MrLH5FDokrBVqlq/G8SBUCZxzvGtE3k+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCicByVgumaZxeTh+CYDv3nAu1ssmAv7W+wakXX3kfVLEJdj8c5VJkgGFrQg1A1hn9uJJkS1xO6wNdyUtRpZ3Z9puDqy9iSOrh8bcVVtnnS2ryBGiOIvjOHekyGg1xk2LKvNL4y7G4lK53l11Xnyf4do/Z/f9Pby7w0vlT7+xL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qeVygaj+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qeVygaj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DFDC4CEF7;
	Tue, 17 Mar 2026 16:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773764602;
	bh=XU6lMFg6u5MrLH5FDokrBVqlq/G8SBUCZxzvGtE3k+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qeVygaj+LyUrVZcCyNdagGKreopjTZn7S4GYPQjfdoSxcoQI5WgMYzmRYWOtHz1I7
	 I20vhufey8HADCDgVI0lgI8RB4Cq0EC4jXb9vTqYl/+riahxt68+AzWkKQtej/ISto
	 AFn+8xLrcHN0U9uKaF91OpHWCtVLQ99bWpjNhLO56TDyXucuseTKgPpITunjFslEFc
	 asoRi4J1h6eEupL1fGteCjAq+BzBL2fdzubCNof4ePGeFtS8+Y3LeUpJvNb48yb5l0
	 6C5VKza3f/2ChsyXfCZrxp8gqT0ReKRbmt1LOnDzRgWH26cZduI2SwP5vBFhOJJEQg
	 6Qq41P61o/Wfw==
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
	linux-crypto@vger.kernel.org,
	"Tycho Andersen (AMD)" <tycho@kernel.org>
Subject: [PATCH v3 3/7] x86/snp: create snp_x86_shutdown()
Date: Tue, 17 Mar 2026 10:21:53 -0600
Message-ID: <20260317162157.150842-4-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162157.150842-1-tycho@kernel.org>
References: <20260317162157.150842-1-tycho@kernel.org>
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
index 88cb4a548701..85091d663f18 100644
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
@@ -521,12 +524,26 @@ void snp_prepare_for_snp_init(void)
 	 * MtrrFixDramModEn is not shared between threads on a core,
 	 * therefore it must be set on all CPUs prior to enabling SNP.
 	 */
-	on_each_cpu(mfd_enable, NULL, 1);
+	on_each_cpu(mfd_reconfigure, (void *)1, 1);
 
 	on_each_cpu(snp_enable, NULL, 1);
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
+	clear_rmp();
+	on_each_cpu(mfd_reconfigure, 0, 1);
+}
+EXPORT_SYMBOL_FOR_MODULES(snp_x86_shutdown, "ccp");
+
 /*
  * Do the necessary preparations which are verified by the firmware as
  * described in the SNP_INIT_EX firmware command description in the SNP
-- 
2.53.0

