Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512EC3563EB;
	Mon,  2 Mar 2026 19:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772478879; cv=none; b=ihO3/j5CBQpTXRxcyHd05K69ChfzxPpQlK9hWpP+qAG8rULZWeBrxKfu4MT1rvzzOCrlZdx8JhpTWnW164UaKidfpDZVU5sILjvL1ViClhjUTbKQVOU8RKLewbXEW8BIzV8fqJxCV/hI+2MvVESpyn+OgL4BSHLV6eJ+Ur8h4+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772478879; c=relaxed/simple;
	bh=2z0Z9xVg31c45Rdglcx0+GgzDD4kLyMnXSQlC9yF054=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxdWHEAQaV72E/5tX8VroL4pkiNqP30wGlIdGK04jNGqwRYh4WgREV890xFFDZx1glnWjuAcdmi8U+UAedKGxAy9uFbi0ZGAAD+T8G6lzKDHsOdQq49fXfv/EmHj5cOy3hfBgo3m4nb5bjCdsM49xH5HdKf2o372aCskMKy7a78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=puDxrI8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="puDxrI8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD49C4AF09;
	Mon,  2 Mar 2026 19:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772478876;
	bh=2z0Z9xVg31c45Rdglcx0+GgzDD4kLyMnXSQlC9yF054=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=puDxrI8Jx8JtkkcTEEBLGrhPcEZ3a5vy42q7zKCps9sOABqwVyEfEvONTmgcBe3mb
	 /8Ue20jQKXjG7cpn7/tuDgM/uVMQdT9l2gZv7IBgEvGiONhMsBmQVpB3TUFfSHTRxG
	 cZLFs32szMX/g0hd/ZHO9UCgpnZ+g5Y22LXiNQJDg150bVcwgaPZrFoVKJObmiyuS8
	 mReiZ2/QpBbVfHMcDTJo/D+iEzSpHbxPKx4qFo71XKrNXMIiU+p0DOZDELSc9qt93n
	 U39gJlYDWBN9MANxZEgcYia6WYZQq4i7B9bgT0RkhlYXdlUQ7UCd+sx/64Tnh8dbHD
	 oP2I4Z8mp8B7w==
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
Subject: [PATCH 03/11] x86/snp: Create a function to clear/zero the RMP
Date: Mon,  2 Mar 2026 12:13:26 -0700
Message-ID: <20260302191334.937981-4-tycho@kernel.org>
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

From: Tom Lendacky <thomas.lendacky@amd.com>

In prep for delayed SNP initialization and disablement on shutdown, create
a function, snp_clear_rmp(), that clears the RMP bookkeeping area and the
RMP entries.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 arch/x86/virt/svm/sev.c | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 232a385f11cb..e7fbbf1cdf8e 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -248,6 +248,32 @@ void __init snp_fixup_e820_tables(void)
 	}
 }
 
+static void snp_clear_rmp(void)
+{
+	unsigned int i;
+	u64 val;
+
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		return;
+
+	/* Clearing the RMP while SNP is enabled will cause an exception */
+	rdmsrq(MSR_AMD64_SYSCFG, val);
+	if (WARN_ON_ONCE(val & MSR_AMD64_SYSCFG_SNP_EN))
+		return;
+
+	memset(rmp_bookkeeping, 0, RMPTABLE_CPU_BOOKKEEPING_SZ);
+
+	for (i = 0; i < rst_max_index; i++) {
+		struct rmp_segment_desc *desc;
+
+		desc = rmp_segment_table[i];
+		if (!desc)
+			continue;
+
+		memset(desc->rmp_entry, 0, desc->size);
+	}
+}
+
 static bool __init alloc_rmp_segment_desc(u64 segment_pa, u64 segment_size, u64 pa)
 {
 	u64 rst_index, rmp_segment_size_max;
@@ -490,7 +516,6 @@ static bool __init setup_rmptable(void)
  */
 int __init snp_rmptable_init(void)
 {
-	unsigned int i;
 	u64 val;
 
 	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
@@ -510,19 +535,7 @@ int __init snp_rmptable_init(void)
 	if (val & MSR_AMD64_SYSCFG_SNP_EN)
 		goto skip_enable;
 
-	/* Zero out the RMP bookkeeping area */
-	memset(rmp_bookkeeping, 0, RMPTABLE_CPU_BOOKKEEPING_SZ);
-
-	/* Zero out the RMP entries */
-	for (i = 0; i < rst_max_index; i++) {
-		struct rmp_segment_desc *desc;
-
-		desc = rmp_segment_table[i];
-		if (!desc)
-			continue;
-
-		memset(desc->rmp_entry, 0, desc->size);
-	}
+	snp_clear_rmp();
 
 	/* Flush the caches to ensure that data is written before SNP is enabled. */
 	wbinvd_on_all_cpus();
-- 
2.53.0

