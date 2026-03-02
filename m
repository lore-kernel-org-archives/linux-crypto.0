Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99913EBF0B;
	Mon,  2 Mar 2026 19:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772478891; cv=none; b=eAQyIIOPQWcO+L2hMtmtt1IvFTHUqO9EXJ2Ndf2WyjHvRfBueY3rpnehN04FrnVP72LT5PKudBHMmmR15vYxKHFzMg5t1znNDVziYT++vzyKkTqVcdobNgVkmrp770NgXpDwBVTazmpoXgbfz+NOYOSparxH/6qmNTQL8p7fdvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772478891; c=relaxed/simple;
	bh=S7O9Pwkij2Awxqvl2IdvidJkvTEayDKdMv2IpZS7iJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6mvYha9ZVBJbqWiSfKP555LcsWYyyVPZgnJ07h7QIZX16Z7VPIKIOgTDFPGXsn0cC5Fj7WEHK+TI2521TJPf+EJ7VCsR637WmSVNg3EB8HSMAdOqhXoJwFENC5e+Uqcin0bwjRDpIpbLpWCuYQ4CcLs5pW2vWcv6c9hz1ITtpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P8wneOhP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P8wneOhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0C6C19423;
	Mon,  2 Mar 2026 19:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772478891;
	bh=S7O9Pwkij2Awxqvl2IdvidJkvTEayDKdMv2IpZS7iJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8wneOhP+zXAuZCvpw9yuabiGrOyLiz9dBMW4cZ+pPFFC3g1eO5um/M7eDfN8k0nX
	 v+9kx8TjQxnexlfcSeoY1wjHgywzuHGXYhg2QXS/AD0Fgwck9mqahHVvSGoJB46smR
	 tMPcFv/LbG0Pmo9qB7atsSoN4ZbC33yjk50fdxflRzUb8K3Ys0hrUqP52lWdt+mXWz
	 eovC/3H7BgYN4Q4HaF3xpkmUm06jOHIdfLgBHf0UyrxinmI0rrZiUTdhyJ67pMhjV/
	 ph8l7g/quWv1dWl8RXx+6WFZ8T3/axHh6bF8BL3781idPvcxqNEW7zItS6SWodetB7
	 fbtwMIxVt19Tw==
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
Subject: [PATCH 09/11] x86/snp: create snp_x86_shutdown()
Date: Mon,  2 Mar 2026 12:13:32 -0700
Message-ID: <20260302191334.937981-10-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302191334.937981-1-tycho@kernel.org>
References: <20260302191334.937981-1-tycho@kernel.org>
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

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 arch/x86/include/asm/sev.h | 2 ++
 arch/x86/virt/svm/sev.c    | 7 +++++++
 2 files changed, 9 insertions(+)

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
index cf984b8f4493..0524fc77b44d 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -544,6 +544,13 @@ void snp_prepare_for_snp_init(void)
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare_for_snp_init, "ccp");
 
+void snp_x86_shutdown(void)
+{
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

