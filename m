Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74904332EBB;
	Mon,  2 Mar 2026 19:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772478879; cv=none; b=Hc0NM3B6yG4hWLuX9DpamMds3fyOTpDFxTguK3+Dean8YNqzjik9uxkYtwKZtelES4gNl5+KTebkTogd8Ibodlyvgr/+L4Xkk2yAqSWCiFVcY618+SVxDJ69SZDQsUOR7R1d87++4jO2qXRijmPt6zVq2kvsq53sDw5CjMe53fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772478879; c=relaxed/simple;
	bh=QefM6wT7TMbEzCC+rnX/XKIAXqXoIDMmEo0TgMSkPQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhL9i51SjAtIKfCnxNFNsWVmHvNcf9PM/Cj3nVKbY315+3yCW9CF5SBZN4/fzDFEqSuovFZGjBy/HlXdB/Wtx0NImPuY8hDoE3s4gQDh6o6HHDDDY+FbH5yrkPhC2FDhfjfSYcv7oBOcxVGKvFdhXAbM7dHEXuwx5YytiaQwNdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WW8NAKCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WW8NAKCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A84AC19423;
	Mon,  2 Mar 2026 19:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772478879;
	bh=QefM6wT7TMbEzCC+rnX/XKIAXqXoIDMmEo0TgMSkPQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WW8NAKCr19V1kjv0+BjUuKouHv5b9GXGFFIY+D0X3kRWz+v9uYAEQkCuDQEGAC9SX
	 lAaWffaSMLGoyZPLp9SUADYGeArODqjtycgQLudxxRe2U4sNJlwbK23SbnlIhBjAtb
	 8ksXDbgAXmnYy36/dRflHK5pR/B8vWwBpG8fGgS2/bvc4xDRY9XwLhSDUBcYmMK6Fh
	 MuHX53xTTt6ahDE8xEB63UddASELagagMlU9RUTChSFhsjteDLuTXnkK3inI2s5lBN
	 Sr6Zy+lcExokGn+qNNtAnszctBtQLothQunkaW3ixSucheT3P8BClA7uFBDWQHUqfV
	 pOO7P8rAhXA9Q==
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
Subject: [PATCH 04/11] x86/snp: drop WBINVD before setting SNPEn
Date: Mon,  2 Mar 2026 12:13:27 -0700
Message-ID: <20260302191334.937981-5-tycho@kernel.org>
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

WBINVD is required before SNP_INIT(_EX), but not before setting SNPEn,
since the ccp driver already does its own WBINVD before SNP_INIT (and this
one would be too early for that anyway...).

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 arch/x86/virt/svm/sev.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index e7fbbf1cdf8e..258e67ba7415 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -537,9 +537,6 @@ int __init snp_rmptable_init(void)
 
 	snp_clear_rmp();
 
-	/* Flush the caches to ensure that data is written before SNP is enabled. */
-	wbinvd_on_all_cpus();
-
 	/* MtrrFixDramModEn must be enabled on all the CPUs prior to enabling SNP. */
 	on_each_cpu(mfd_enable, NULL, 1);
 
-- 
2.53.0

