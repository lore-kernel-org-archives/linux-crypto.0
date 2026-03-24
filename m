Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355543A16B8;
	Tue, 24 Mar 2026 16:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774368810; cv=none; b=u7t9F/doL6X9wBecM+YZhiN24/ph+P2QICTd2KoU/XZDGynueW3T82UrHFsYQ2qw0kgAKMA3vZC8wdgLJaSkJdKfDrWc5o9GirbMfXqVVtYs0PQB8O32mj17npm+oEB2HVx9rJBTN0XagIe34iYBUvH7OdYxKJkpu68oeazFCUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774368810; c=relaxed/simple;
	bh=/DSTUWVnPkfvvVMvjC8FfRHDmY8DNaX4fQM22D2eQE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEE4K+tmSEbyL71CB77oTKqH1xvebIBeXBgeX1za+jZ7O0r6sJQgQd88WqkRXPWvjzVH0vnTGcrv2G8i79B/tvhEwF59e0RQ41QBOeKB/2xt+M8FADEY3ZMvepHc19got1VJvTpcTp3LJ/ZJk94lGIJBnb/Rh0G7OMKS45PPZJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ek7OAuA0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ek7OAuA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98099C19424;
	Tue, 24 Mar 2026 16:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774368809;
	bh=/DSTUWVnPkfvvVMvjC8FfRHDmY8DNaX4fQM22D2eQE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ek7OAuA0lbwD0xbkoCN8LTJzkgUqQBNmCrwGQLrJhH4gnsde9uCwsMCGpPVkt+mhz
	 SsHh1TuGuv/D4GvMtFUeMNPWAK/iAKwqvJpY1WrZuyG5m4pboslNeSjziKy7On64QQ
	 mr8akn0gClVnRFIVNPBtNymE19sXjVJb006lFSnYkVCzgHUr3DgTAii5eSjzesW5jz
	 MkYGZ1oSuFIVKkEQOpaJlq2zJ4XH/FoxYrTUwZuL4n18HGdf3nwQqy0n4Cjen0GOj0
	 h++uxM25wDd3jUaTsqegVRNBxfev2jQQ1W4xt9DspzTCfFw9WcE3MxH7M/SYyp5jex
	 8MqzDIcO4exFg==
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
Subject: [PATCH v4 4/7] x86/sev, crypto/ccp: Move SNP init to ccp driver
Date: Tue, 24 Mar 2026 10:12:58 -0600
Message-ID: <20260324161301.1353976-5-tycho@kernel.org>
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

Use the new snp_prepare() to initialize SNP from the ccp driver instead of
at boot time. This means that SNP is not enabled unless it is really going
to be used (i.e. kvm_amd loads the ccp driver automatically).

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/virt/svm/sev.c      | 2 --
 drivers/crypto/ccp/sev-dev.c | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index bcb791a56053..bf0572c0c16e 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -559,8 +559,6 @@ int __init snp_rmptable_init(void)
 	if (!setup_rmptable())
 		return -ENOSYS;
 
-	snp_prepare();
-
 	/*
 	 * Setting crash_kexec_post_notifiers to 'true' to ensure that SNP panic
 	 * notifier is invoked to do SNP IOMMU shutdown before kdump.
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index aebf4dad545e..4915b0125e8d 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1373,6 +1373,8 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 		return -EOPNOTSUPP;
 	}
 
+	snp_prepare();
+
 	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
 	on_each_cpu(snp_set_hsave_pa, NULL, 1);
 
-- 
2.53.0

