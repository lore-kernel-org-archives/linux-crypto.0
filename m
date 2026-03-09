Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C964346FA0;
	Mon,  9 Mar 2026 18:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079287; cv=none; b=Sk6vwKBHh+fojWleMlytI967Zb1PysrzZ/eIr/i+laOPFP4gb8EzBH5GAG25gnkasKOzSu7O7WhloK07iIWxsvzNNKs++jX8X0SJgp7C9B5SVDZO9MCnEUkNrpgJzW++2nWh5DriIthHxgbMcYLK3b2DK8cKqdRLF9MRO7z2uU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079287; c=relaxed/simple;
	bh=4Z1AlcExpcYxtxDtwE2OqAaS1Hmy/ko7Xoe4DEuuMnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3mpRdS/o5b3sTrVotujBknqxaFUvYMCCBocjbVttL0VkZsgwH6jRe/RhMyKMQDrWVdLIIwEAGkgvwtaLpnHstQ71YVTppj2ahJDywUg1dDb3Y8QwRbveFIcg7ujt65VtjfmH5KHrJF9yYPZV9IBzUIqO+FLlbVxbKXAZ92nwJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=th8gNFul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="th8gNFul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF19AC4CEF7;
	Mon,  9 Mar 2026 18:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773079287;
	bh=4Z1AlcExpcYxtxDtwE2OqAaS1Hmy/ko7Xoe4DEuuMnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=th8gNFuliiQwjJDlMsBwTM15Zs5b1XlEeTPw+pxn49nIXoxmfcOAVj4AryI4vuzpf
	 LdtPKhyX4wuTAk/AAw8lpAJ9ocymCSR30nTTqZucjPhRtMMUZHTmVmR9yBz5y8Zrii
	 CiR3UFSFFREzaXFW5Yor8H8pbR/zSb+EpjeZVbV7u+uvdkW/K+5G7vplCePMgJKpyj
	 MYPe5xyeBBn31b8WC0gfKf2ZSZT/lhnInkmN7eA4gONk289jI4yGOXbNm5W7oIWaai
	 pHUUROoXCQYOhvpU8QMJu7hplfuoLi7wJYXVigJb7za4Nw7EyjJXqjkOs8CKVC1WUv
	 LZfT5sI8Ic/og==
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
Subject: [PATCH v2 06/10] x86/snp, crypto: move SNP init to ccp driver
Date: Mon,  9 Mar 2026 12:00:48 -0600
Message-ID: <20260309180053.2389118-7-tycho@kernel.org>
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

Use the new snp_prepare_for_snp_init() to initialize SNP from the ccp
driver instead of at boot time. This means that SNP is not enabled unless
it is really going to be used (i.e. kvm_amd loads the ccp driver
automatically).

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/virt/svm/sev.c      | 2 --
 drivers/crypto/ccp/sev-dev.c | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 9d2cddbeaf21..28d240484453 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -543,8 +543,6 @@ int __init snp_rmptable_init(void)
 	if (!setup_rmptable())
 		return -ENOSYS;
 
-	snp_prepare_for_snp_init();
-
 	/*
 	 * Setting crash_kexec_post_notifiers to 'true' to ensure that SNP panic
 	 * notifier is invoked to do SNP IOMMU shutdown before kdump.
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 8b2dfc11289b..07c4736a1f0a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1373,6 +1373,8 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 		return -EOPNOTSUPP;
 	}
 
+	snp_prepare_for_snp_init();
+
 	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
 	on_each_cpu(snp_set_hsave_pa, NULL, 1);
 
-- 
2.53.0

