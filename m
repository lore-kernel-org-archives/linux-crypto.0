Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147CB407108;
	Thu, 26 Mar 2026 16:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774541506; cv=none; b=nDDQgdS8Wo0CIMreVt4ntbYKp+aDiv963SoKC9V1goZsU8g+IIVWQMPjw7G4SKXMTTAQgw9ivW0B7YQOh7l7TMnkfAWgw1q5OOkUFDAIT1y1mEfCcOM3sy47nHCKGbi4otQe8PXDyfmqErcTbMYdoIR0/gJ3bnswghn4psoSPeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774541506; c=relaxed/simple;
	bh=Y8lmvB8JuPNmOUIJcK/6y91AUkEo+TDbAeG0+ZHYKIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlR2CM8ctnxM+B0RwRlSbUkElj9F8K0itOigEqdAJtDmVW4tSv7c2qf+QXfu9GtTPF3ob2lmWPAy4lS7t3LNwiShRdC44EBfi6WIFRAKPrQjN1iCfNRrn7g33D6UbAGAeCJ9qkF6tOi5Sj+3LSWCmba3+3P8Vcdg2UHNVjUSpZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IS5PXkve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IS5PXkve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA5CC19423;
	Thu, 26 Mar 2026 16:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774541505;
	bh=Y8lmvB8JuPNmOUIJcK/6y91AUkEo+TDbAeG0+ZHYKIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IS5PXkvedNuyqMcDROOqrUvd7LBMdxwxA7Qz/Zk5uehPDTeTGh0ok+vmUJgyGGFj0
	 v61GMuMpHkw7sPu3PigRfMFn2FvyqqEm8QfiAgNlSgHOoQphqqBk1MYER63pxDm6yg
	 d5i/z/QhyVU9BbLmBG5askd/CtpjlxUii8W3ARaH06oRVwzTSJDpNrRXx4uxZG+jze
	 CjqCpmOTJKTERyqnKeMdEteyqFUuRVLShYMpi8P9KC1s3AMFS2at3FifOBHkJbPkWy
	 /v2xdw6Xn0a2+d+321seHzwB2Ap6XZFU2enBscF5t3kTJju1CFIxc3SD0NQgyl7f2x
	 IEjI3nCOcnFdQ==
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
Subject: [PATCH v5 5/7] x86/sev, crypto/ccp: Move HSAVE_PA setup to arch/x86/
Date: Thu, 26 Mar 2026 10:11:08 -0600
Message-ID: <20260326161110.1764303-6-tycho@kernel.org>
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

Now that there is snp_prepare() that indicates when the CCP driver wants to
prepare the architecture for SNP_INIT(_EX), move this architecture-specific
bit of code to a more sensible place.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/virt/svm/sev.c      | 7 +++++++
 drivers/crypto/ccp/sev-dev.c | 8 --------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 423fe77cc70f..e658f84acea1 100644
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
@@ -529,6 +534,8 @@ void snp_prepare(void)
 	on_each_cpu(mfd_reconfigure, (void *)1, 1);
 	on_each_cpu(snp_enable, NULL, 1);
 
+	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
+	on_each_cpu(clear_hsave_pa, NULL, 1);
 	cpus_read_unlock();
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

