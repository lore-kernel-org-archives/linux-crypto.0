Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB47E338925;
	Mon,  9 Mar 2026 18:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079277; cv=none; b=VaIPt9YdeG+8iXt3WFCIhedYbiYyoXUYtll20+vZ0p4BxiEq7vJwQkzzTxlm3mAh9GyP9E6YKJfoio4AnF8Enwc83CPs3/KfITgs9ICoOjfxRAlCOufKEmoskux+vzCURyiSAU4jnjOsM8uYyOQxY1K2l88GLGyMGtHPrkAFomw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079277; c=relaxed/simple;
	bh=u+Ieq1hHAY0K9hAW/Ho9/Yc9TVLd1TvPaORi0TZc1rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gETv8drpyaoJ0TaoZ/CMfMzLADaa7KmEtwNhtCACLRy8FPvQ7dxbpCCi3Bz4fW3CuFZMItvY+0gJkENtGj1+gEG8/eucnQ/uylxPPPLQN9ZW5V6GGe5Y3zVdKqeWZ1PwmyhIsxsdejF7DuDdDCi7BmPLno4B4RHPuRxQuGZj3zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jzsgwZBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jzsgwZBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4105AC4CEF7;
	Mon,  9 Mar 2026 18:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773079277;
	bh=u+Ieq1hHAY0K9hAW/Ho9/Yc9TVLd1TvPaORi0TZc1rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzsgwZBd7KHMXkDD4Bs2O+vIQrPQgw8rksERaPa0CI3EBYK0Y6r55Pj4Dv0/GCEBg
	 gOwkps6MlTRqCzoDxCNBJkCDAlzOWu03hxi59E8BGG8Rwye2xlAPe/RXwRIlAXS3q9
	 jl7sJj4CSPu83OSM3I/+y+Qh33K87nGXw0jyamDXRiOtRF7o86LqpVHeDsk79Plflw
	 w2NEQTK3k5gaqDWu8O8USf4l3DjIZE7J0D19M5uG/GQwS03kdQ6AOTVo+2rA31m7U2
	 +0UEdaa2DZTOuq2sIbyhWrs+lnIe5UAKuyq6aUk1Ix1rY1+PjMthIdm23D51iKmjW8
	 PnTxiHEGoiWbg==
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
Subject: [PATCH v2 02/10] x86/snp: drop WBINVD before setting SNPEn
Date: Mon,  9 Mar 2026 12:00:44 -0600
Message-ID: <20260309180053.2389118-3-tycho@kernel.org>
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

WBINVD is required before SNP_INIT(_EX), but not before setting SNPEn,
since the ccp driver already does its own WBINVD before SNP_INIT (and this
one would be too early for that anyway...).

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/virt/svm/sev.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index f404c609582c..5e07f103c271 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -524,9 +524,6 @@ int __init snp_rmptable_init(void)
 		memset(desc->rmp_entry, 0, desc->size);
 	}
 
-	/* Flush the caches to ensure that data is written before SNP is enabled. */
-	wbinvd_on_all_cpus();
-
 	/* MtrrFixDramModEn must be enabled on all the CPUs prior to enabling SNP. */
 	on_each_cpu(mfd_enable, NULL, 1);
 
-- 
2.53.0

