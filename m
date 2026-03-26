Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9BB40626C;
	Thu, 26 Mar 2026 16:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774541501; cv=none; b=j4p5+pZs2Mku0poR+Ifj7zsOn3dzcL6n1YiJoGKA2DUXb7yYsQlRfNqaSKftJrzo01OOMq7850g7i1UE849jyNkG8o2+S65KuZZdz7GU5Ib0hfyh6r5itA1/NJvtcfqLfs+AEnVM2d8nfp2h+UwqqxvS7wFkKVQxBtoPcRUJ+ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774541501; c=relaxed/simple;
	bh=+najkdWSWP7zuFDM3vZV1wmB54wzAeTy8ezrdjjnV40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNEBNpXCfdLJA2BgNG7NaeSy7vorc5BaXEAMb6snZkOdCxuc+zrY5SomhYFsX3Fk2AohIZrvtaQSUtrmTefW8PE8QSmTRSlu7MhFcNOUIdpO/4iWZVp7wXw0VpoQRWFIDchFDNP6I2hsgYaQm+0++8jfAp8np5gLWEAMMxMtP6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cR7AptlM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cR7AptlM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D77DC19424;
	Thu, 26 Mar 2026 16:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774541500;
	bh=+najkdWSWP7zuFDM3vZV1wmB54wzAeTy8ezrdjjnV40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cR7AptlMRawMZhIB/q1LaOxA2xIiVbbayGVPcqKoCXuFgz3SfBdy8j/ZmLSiQhK0s
	 u9025qdXTbHtaAKjy6iVMgz8js1TUeIBk6VEp6u61VN1/w4bILl7ChD+uHTgwMVZuf
	 BuLoa7kCC8JhUwTwWGyj8ucxu29MrMy7hcFzTi2oSyzndDFr7TCqyEn35DRFvly+TF
	 2GRp1nx0J5IWkJec9/IOD4Bl3LR7SK04L1tr63428crZYHxyIMJvjcLf/k42DCsoB+
	 RQZRhWIZC5MeL84iKPLdsVPCrF+ynvIblwL7mvUsElRXkX/AAFf6ur9GfqSIWsriaL
	 QnVvxW0rcvb4A==
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
Subject: [PATCH v5 3/7] x86/sev: Create snp_shutdown()
Date: Thu, 26 Mar 2026 10:11:06 -0600
Message-ID: <20260326161110.1764303-4-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260326161110.1764303-1-tycho@kernel.org>
References: <20260326161110.1764303-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

After SNP_SHUTDOWN, two things should be done:

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
 arch/x86/virt/svm/sev.c    | 22 +++++++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 2140e26dec6c..09e605c85de4 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -662,6 +662,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
 	__snp_leak_pages(pfn, pages, true);
 }
 void snp_prepare(void);
+void snp_shutdown(void);
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_rmptable_init(void) { return -ENOSYS; }
@@ -679,6 +680,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
 static inline void snp_prepare(void) {}
+static inline void snp_shutdown(void) {}
 #endif
 
 #endif
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index ccec52952573..3b2273dca196 100644
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
@@ -523,13 +526,26 @@ void snp_prepare(void)
 	 * MtrrFixDramModEn is not shared between threads on a core,
 	 * therefore it must be set on all CPUs prior to enabling SNP.
 	 */
-	on_each_cpu(mfd_enable, NULL, 1);
+	on_each_cpu(mfd_reconfigure, (void *)1, 1);
 	on_each_cpu(snp_enable, NULL, 1);
 
 	cpus_read_unlock();
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
 
+void snp_shutdown(void)
+{
+	u64 syscfg;
+
+	rdmsrq(MSR_AMD64_SYSCFG, syscfg);
+	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
+		return;
+
+	clear_rmp();
+	on_each_cpu(mfd_reconfigure, NULL, 1);
+}
+EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
+
 /*
  * Do the necessary preparations which are verified by the firmware as
  * described in the SNP_INIT_EX firmware command description in the SNP
-- 
2.53.0

