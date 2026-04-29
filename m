Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47FF376BEA;
	Wed, 29 Apr 2026 15:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777478285; cv=none; b=B0CPdmSao5GkzEkO8PJ5F6oSud8RaJbk+PVSPiTxNM+X4AK6ppSQNLhPnU3OdfrLF+urKwoH4uEZj6FLRoOwforq/Rqgs83EK06Upi2D1jS7xmA9A3z8wxQyq/XRJFCa4OhGA8kORa0AO9ikvP6Xh15ky17XEPkeBMju8tgBAp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777478285; c=relaxed/simple;
	bh=dRieb9wR9+B8lfqubmuN/EBwyY9hHYQkXPyQr0qDHEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFEx4WGNl+ROZ8uf/NNiZvYsS/qZuBgLz4Xnjt+OF3I0JSjopKpZJt+jxCGPOxeKIwAsJV8OyGprIrnwpa62D15Ktoge/rg2Mri2sWmM1N9+5b4mpSgxqZ6cuYPEbIdbrAm8gkuZ4JikUAKLufM9HtnFy4GzbDZlsbaCisTf7x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oc+MlubW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oc+MlubW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EB3C2BCC7;
	Wed, 29 Apr 2026 15:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777478285;
	bh=dRieb9wR9+B8lfqubmuN/EBwyY9hHYQkXPyQr0qDHEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oc+MlubWhwjGTAjX4H+jcqwScbsVLrM15g2wCqVbiqdAqiJsotueRBhehYlER/V5w
	 15JZ9I5taiHqW7DpBEcxHcy7HfdSeunNPyO6DN4kYoCRA5U8ZtgKug5JDuPOA3V62v
	 f5nBamEfYAkU+OYfeP+j9aMDAJJgdq0lsVG4x0x8gb69hn9rTLyytL/2U11914TdFt
	 iwPaPcI1ddcR1BXZBbWozUYJs6C2A6pZo8nJNQmI83y0SJAwFHvEmQbYfUrZoO1Jd8
	 hTk0lFWdf1tAIefFQYeKLYfimdXXNHDiYcLmpnAabciXe0C2nsbC52JfyUJa1bg1+Z
	 fR8DTfoX5I5gg==
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
	"David S. Miller" <davem@davemloft.net>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Ahmed S. Darwish" <darwi@linutronix.de>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH v4 1/2] x86/sev: Do not initialize SNP if missing CPUs
Date: Wed, 29 Apr 2026 09:56:35 -0600
Message-ID: <20260429155636.540040-2-tycho@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260429155636.540040-1-tycho@kernel.org>
References: <20260429155636.540040-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

The SEV firmware checks that the SNP enable bit is set on each CPU during
SNP initialization, and will fail if it is not. If there are some CPUs
offline, they will not run the setup functions, so SNP initialization will
always fail.

Skip the IPIs in this case and return an error so that the CCP driver can
skip the SNP_INIT that will fail. Also print the CPU masks as a breadcrumb
so people can figure out what happened.

Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev.h |  4 ++--
 arch/x86/virt/svm/sev.c    | 18 ++++++++++++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 09e605c85de4..594cfa19cbd4 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -661,7 +661,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 {
 	__snp_leak_pages(pfn, pages, true);
 }
-void snp_prepare(void);
+int snp_prepare(void);
 void snp_shutdown(void);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
@@ -679,7 +679,7 @@ static inline void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp)
 static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
-static inline void snp_prepare(void) {}
+static inline int snp_prepare(void) { return -ENODEV; }
 static inline void snp_shutdown(void) {}
 #endif
 
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 41f76f15caa1..8bcdce98f6dc 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -511,8 +511,9 @@ static void clear_hsave_pa(void *arg)
 	wrmsrq(MSR_VM_HSAVE_PA, 0);
 }
 
-void snp_prepare(void)
+int snp_prepare(void)
 {
+	int ret;
 	u64 val;
 
 	/*
@@ -521,12 +522,20 @@ void snp_prepare(void)
 	 */
 	rdmsrq(MSR_AMD64_SYSCFG, val);
 	if (val & MSR_AMD64_SYSCFG_SNP_EN)
-		return;
+		return 0;
 
 	clear_rmp();
 
 	cpus_read_lock();
 
+	if (!cpumask_equal(cpu_online_mask, cpu_present_mask)) {
+		ret = -EOPNOTSUPP;
+		pr_warn("SNP init failed: not all CPUs online. (%*pbl online <-> %*pbl present masks).\n",
+			cpumask_pr_args(cpu_online_mask),
+			cpumask_pr_args(cpu_present_mask));
+		goto unlock;
+	}
+
 	/*
 	 * MtrrFixDramModEn is not shared between threads on a core,
 	 * therefore it must be set on all CPUs prior to enabling SNP.
@@ -537,7 +546,12 @@ void snp_prepare(void)
 	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
 	on_each_cpu(clear_hsave_pa, NULL, 1);
 
+	ret = 0;
+
+unlock:
 	cpus_read_unlock();
+
+	return ret;
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
 
-- 
2.54.0

