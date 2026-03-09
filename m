Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9136D347FC4;
	Mon,  9 Mar 2026 18:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079289; cv=none; b=glSZ/TkH6cbA+sDt+aZMKMCd0DVjmLBiEPSJIWDBxWzkYuQq5o2bpNaVWjnp1c8ocD2GxUJ/B2qSxMouyi0aCuK2UyxUT0YrS/YnnrR+vp5e4B5IR49y2pz1xWofMLbx/2ShKG8cNefBbwqBiUtFrxDKkHwz8xaF1GlKVyBQ/8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079289; c=relaxed/simple;
	bh=8+eedZkuRiiEx+AHpOUJiKJ97lwbA6RpN02/poBXrwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/mVSmfZZ97SgyKAC4cLRkLwI8j9rCRE/8VG6eemS8SMBMV3TZcbCJNy/BYM8PUxmOFrYm+hR4t0I9yhC2RvQ3jRCvVqoxZVy3z1xUyRQPoWzXt14MRYN4AwVnCF2Jz7Jsjg2hEAuEJktDAAgL271fYmXVB1hASrXR0MbFhHhNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LWJzZqYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LWJzZqYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB17C2BCB0;
	Mon,  9 Mar 2026 18:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773079289;
	bh=8+eedZkuRiiEx+AHpOUJiKJ97lwbA6RpN02/poBXrwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWJzZqYkmkwM+e8qE0UHdB6Fjxft03Sq5NdnveJzD5yOqA+gwBeP6Bd5w6hRfqqKQ
	 sL9qI6ah+N5DDwCQSguWLieyjXk1kAUr5ZoW79egF5JPZF4nmvE3DoIY6QpWqc5Rax
	 MU0yxMgF1m2rUrMKlnsk7e8lgE8kKe+N07gf1toDtBVcVgOUjdOvzWWzhLJrDrRq/Q
	 2n4VlVoqKY45ywvCHlVHgcvQlgfkc5kjXO8TPeXIewoY4LzjH5UcZZb7Oh5vuEsOWZ
	 /yMSX+NHRkn2KI3Jm27n16DkITwLOVuaLFpurrL4u6UEDiup1hifRiFS/oGHkF5DtT
	 LAcPUiWng7ewA==
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
Subject: [PATCH v2 07/10] x86/snp, crypto: move HSAVE_PA setup to arch/
Date: Mon,  9 Mar 2026 12:00:49 -0600
Message-ID: <20260309180053.2389118-8-tycho@kernel.org>
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

Now that there is snp_prepare_for_snp_init() that indicates when the CCP
driver wants to prepare the architecture for SNP_INIT(_EX), move this
architecture-specific bit of code to a more sensible place.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/virt/svm/sev.c      | 8 ++++++++
 drivers/crypto/ccp/sev-dev.c | 8 --------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 28d240484453..cc10d059140d 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -503,6 +503,11 @@ static bool __init setup_rmptable(void)
 	return true;
 }
 
+static void snp_set_hsave_pa(void *arg)
+{
+	wrmsrq(MSR_VM_HSAVE_PA, 0);
+}
+
 void snp_prepare_for_snp_init(void)
 {
 	u64 val;
@@ -524,6 +529,9 @@ void snp_prepare_for_snp_init(void)
 	on_each_cpu(mfd_enable, NULL, 1);
 
 	on_each_cpu(snp_enable, NULL, 1);
+
+	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
+	on_each_cpu(snp_set_hsave_pa, NULL, 1);
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare_for_snp_init, "ccp");
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 07c4736a1f0a..b10104f243b9 100644
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
 
 	snp_prepare_for_snp_init();
 
-	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
-	on_each_cpu(snp_set_hsave_pa, NULL, 1);
-
 	/*
 	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list
 	 * of system physical address ranges to convert into HV-fixed page
-- 
2.53.0

