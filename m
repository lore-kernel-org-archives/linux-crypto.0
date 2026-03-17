Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF1B315D49;
	Tue, 17 Mar 2026 16:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773764605; cv=none; b=s3BnRCUoKYCy3aG5nB4MWKR42ae2nnO6CYOzTijZFu2WllojW55qovlWBOvtXpqwfgM9lFYwUqHRHhyQfrZ1eNOOfuKQJcrhqysscNQoxjIo7krzF+rsk+UjU5CNhzIS1vTB5rZT69UELc+8+nfGSmf1ps8IgT2Ll32t8XcEnSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773764605; c=relaxed/simple;
	bh=LTvMOHz8M1itT3zsBfeKdK/QodsxREQ0/QYy8N4j50o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oisF4VyTtZ4JvJoQ7kqW3LUUr+82uUupUk2O+mWu5OhRnsK1XAtPNSJCyMaffpEy8TGBGSV1dTEYNlUTjm+1CImf2rb+N4eesrwMc76JL6qvlebpXu/kt8IPFA9aun5oejXlSD/IXJBI7ZQkBjwtKEEVBXgEq4yGrzcN28GmsKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LQJFcbKp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LQJFcbKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B012FC2BCAF;
	Tue, 17 Mar 2026 16:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773764604;
	bh=LTvMOHz8M1itT3zsBfeKdK/QodsxREQ0/QYy8N4j50o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQJFcbKpxev2YH/BRuscFtU9+wN90LoTng7ZXqILsW2wT9lC+oUMTbSb+Jan2yP8f
	 0jqI6DGBCcklfz8S9oxjWs9ZzjUYf7T6g4xjM+xa69Rnyg1r07mV2phrxTczui5pB0
	 IM8KERoxUxe01nh+3R7C6FWi6yzoWTj3uU2ZhkeAzAnWROgRj7vIrTJuHjJ/c+fnUQ
	 7E17No9AY3DFqu0eV+D0SWHWx+oPUiuVL7rad7jon9km5hCT7q85E/SWxxt4PJALr7
	 qx0EfJN5Uai3lTllMKUWtyrANXpiqSF9uFsjvmw6KtLxri9DK9VGqH3qQw66HbALIw
	 Mi0AMt52WdyZA==
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
Subject: [PATCH v3 4/7] x86/snp, crypto: move SNP init to ccp driver
Date: Tue, 17 Mar 2026 10:21:54 -0600
Message-ID: <20260317162157.150842-5-tycho@kernel.org>
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
index 85091d663f18..b73ea987c69c 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -560,8 +560,6 @@ int __init snp_rmptable_init(void)
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

