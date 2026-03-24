Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89813F54BB;
	Tue, 24 Mar 2026 16:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774368812; cv=none; b=RmXFuVimW2Owp2q2oPMYR3uCIRTPi5a25ZvCQwbsbGXA93etRLjPD4k8jSg2bYwbrVT1SRNozzRkdaiURshxRxkFXjTEPd7MWDDjC/zGSTw+u4IiVhP5TCRKWG7vd8dMbxULPCE4/c7948PTu8H9xhJfoa3lWIzqtIttYXSF8C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774368812; c=relaxed/simple;
	bh=3cZZYZRvIZviTOAmxWK7qO6OTUuqr5I4PTu25/M18vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mm14m32J1mppKa+CwTw7vS3JAPb2CwpbyR1qa7NTU2IY6HfZ8CTT/bmfLAXXIEQw2SUG9Puhv2PHBIffh0j5bRhxgmF5Edbt9jX1a9sOsSibilQvLBQGheWLtU7jtxBW6E/BZ1aVcSyeJHWURQvU/Z9TVaqbEy+naCxtOKR25TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=paRGGoji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="paRGGoji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23609C2BCB3;
	Tue, 24 Mar 2026 16:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774368812;
	bh=3cZZYZRvIZviTOAmxWK7qO6OTUuqr5I4PTu25/M18vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=paRGGojiKInjStp5ZiQBEvAlqrzdjN7DaviUrXTyt+pmPjr9q8IJofDVPrsg8SDHx
	 SC19cyt1iM50o+En9oQY5FroYG4LlULMvoZhucrM+NtOxTNqEweSF56hbFapbTj2Dq
	 2secjoCJqsTUe16IPEjYhMx0qMRWSVNP1qIE2TZcyIUOKLm5wcP3wz5MIxciCL7gp5
	 4qLrd//faAlMlmAH2N4WBf08VUIrQ96dtt9bXvNSjmZabAn8R3+NWC9oRBFxOFbRNm
	 4ungbO7VidTHoPYICDfAd+ok3Msvj8WU/AI4/esI6ugiJkG1QdUUEpKcQMLuwjdxlc
	 GSsktpch/WJWQ==
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
Subject: [PATCH v4 5/7] x86/sev, crypto/ccp: Move HSAVE_PA setup to arch/x86/
Date: Tue, 24 Mar 2026 10:12:59 -0600
Message-ID: <20260324161301.1353976-6-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260324161301.1353976-1-tycho@kernel.org>
References: <20260324161301.1353976-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

Now that there is snp_prepare() that indicates when the CCP driver wants to
prepare the architecture for SNP_INIT(_EX), move this architecture-specific
bit of code to a more sensible place.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/virt/svm/sev.c      | 8 ++++++++
 drivers/crypto/ccp/sev-dev.c | 8 --------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index bf0572c0c16e..d9e0eda7993f 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -506,6 +506,11 @@ static bool __init setup_rmptable(void)
 	return true;
 }
 
+static void clear_hsave_pa(void *arg)
+{
+	wrmsrq(MSR_VM_HSAVE_PA, 0);
+}
+
 void snp_prepare(void)
 {
 	u64 val;
@@ -527,6 +532,9 @@ void snp_prepare(void)
 	on_each_cpu(mfd_reconfigure, (void *)1, 1);
 
 	on_each_cpu(snp_enable, NULL, 1);
+
+	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
+	on_each_cpu(clear_hsave_pa, NULL, 1);
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 4915b0125e8d..47cb8fca4e6c 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1076,11 +1076,6 @@ static inline int __sev_do_init_locked(int *psp_ret)
 		return __sev_init_locked(psp_ret);
 }
 
-static void snp_set_hsave_pa(void *arg)
-{
-	wrmsrq(MSR_VM_HSAVE_PA, 0);
-}
-
 /* Hypervisor Fixed pages API interface */
 static void snp_hv_fixed_pages_state_update(struct sev_device *sev,
 					    enum snp_hv_fixed_pages_state page_state)
@@ -1375,9 +1370,6 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 
 	snp_prepare();
 
-	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
-	on_each_cpu(snp_set_hsave_pa, NULL, 1);
-
 	/*
 	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list
 	 * of system physical address ranges to convert into HV-fixed page
-- 
2.53.0

