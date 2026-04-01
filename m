Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853EC46AF25;
	Wed,  1 Apr 2026 14:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775054296; cv=none; b=cOAptxXzpLo1SJVHqFkfvqowRr6NKkEJXPhJQY9LKET4eu6gMZjoSYJUgAS11wyr+5/PcMr4zJ3pz8jYCquwQwBGmIxGDeTcH8cu0IE/ZSFAaHzrZ5t3yCD2AcsmtA/1D9vx+PbmQ1faFTFDqQsK7SVrQbDtgVAQMlq2P8qL7l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775054296; c=relaxed/simple;
	bh=/CV9TD4ima1utichAPZ1WHSsiCussnChxVXmIIQzfqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aa6JSZ9IFgnVQMlPbKaYsHCNTZvX4LaIc3XZYHKwFjGjOYhpgWFnHl6fxmrBi0ZxSHFiFl+fYz91bWpgdWGD0NUEVPU5pf9gPz/sm479H5SG2cwMJCGXcECm15joG0GFZI/WOzIyzBuCiNYMxjNSh0HRTtBqgr1JGl+N5BQIqE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ijIjcrfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ijIjcrfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC2DC2BCB5;
	Wed,  1 Apr 2026 14:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775054296;
	bh=/CV9TD4ima1utichAPZ1WHSsiCussnChxVXmIIQzfqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijIjcrfp2rkM0sjFug8/ftVKMa0S87BCaDwmCbz2YCPkl/+xbBeTcAINjs7yULA1C
	 M3ivYs6nW8tMo2FxEBAirRrU7u2fn8WuafKJw/LSsakC76dbo2Wpn5Q2J+9BlmClQZ
	 VSRu/R0ykAbAYD4AeOygDPzV0U4VtDsqxg+me5p4uV64TdqeAlx2P7AokwaaOMFRE5
	 c3izKO1xlD53CNyVf9V9X2CVObEfW7RO3kf6S5Zv6kxqCJrk4BcDPlLDTfSDkGmdt2
	 D2uQKG8F9ewCbceJ/dcnk14/AK8G2hZCduloLccXXQBJA0rJZdhprAXHuGv1lQiulM
	 IoMfqfiGY/S6w==
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
Subject: [PATCH v1 2/2] crypto/ccp: Skip SNP_INIT if preparation fails
Date: Wed,  1 Apr 2026 08:35:52 -0600
Message-ID: <20260401143552.3038979-3-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260401143552.3038979-1-tycho@kernel.org>
References: <20260401143552.3038979-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

During SNP_INIT, the firmware checks to see that the SNP enable bit is set
on all CPUs. If snp_prepare() failed because not all CPUs were online,
SNP_INIT will fail, so skip it.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 939fa8aa155c..1fc7ee432e28 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1374,7 +1374,10 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 		return -EOPNOTSUPP;
 	}
 
-	snp_prepare();
+	if (snp_prepare() < 0) {
+		dev_dbg(sev->dev, "SNP preparation failed, are all CPUs online?\n");
+		return -EOPNOTSUPP;
+	}
 
 	/*
 	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list
-- 
2.53.0

