Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DBF40FDA4;
	Thu, 26 Mar 2026 16:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774541511; cv=none; b=kZpbPiYMBFi8ikgjonTx9MJXzR1m+2RzoQWjmP16x427DKOKpBTNALFtOJzVOvTDxL1RtlvOPAmW7psRxlukA7Oas2ML2sEEg/tqXK+shFj9uWB0yIywK4XrxEqL4FCySDyKNmMnbg7fuF7Fp0whhCo0lqFHQ5QLQgoVo5cHnw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774541511; c=relaxed/simple;
	bh=mf7bLNEda1Tj+dC56foTRX9C+4x8Hkt0HqdruR97d9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8jDONglesDCN1HyOfj7Mu6wF6QsDIIipyDSJ3Dek96EOqdyeK+jSglWP3pfegVXZ6u/oRJ2GygE7uxvcV/H2Uapph/xHl8UUNCbYgDYmkofsa4QnR3FV8qUmxoXMYajLz+3+ankiQor1iWz5XQ3mVn0CX3kHsEAQe2xru6jZFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mnWd1g0m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mnWd1g0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A301FC116C6;
	Thu, 26 Mar 2026 16:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774541511;
	bh=mf7bLNEda1Tj+dC56foTRX9C+4x8Hkt0HqdruR97d9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnWd1g0mBCtx8IGY3Up4KJlV/r8ah/AKIJvAKCOaywsLwigymZ/JUwe/ppp1tZwud
	 3y4FxT99kLtT7use9VriqP+napId/GuwVDBjgqJJad1n7HdsMwZ5fgcpfET5SzzKcj
	 /82oSV+qGcOnjIZ7S1zzKFss2T/GKdIJ/APJ+79RuZONuNqyPlLRO7Ao5bEI/Lir6E
	 gX7+gisvQxkF9C6pcO3m0TQlgtv6qCJnsyMsqPmk8aslDs+9kCgENfXAQdKxxy3Hb/
	 JjKhAwcsogwQyQYHbxOz2L0uqfZ2vccQNZBXW54qA/vyCfUu6xaFIayJvYyUGo++0F
	 p8qb1wZ8lbsig==
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
Subject: [PATCH v5 7/7] crypto/ccp: Update HV_FIXED page states to allow freeing of memory
Date: Thu, 26 Mar 2026 10:11:10 -0600
Message-ID: <20260326161110.1764303-8-tycho@kernel.org>
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

From: Tom Lendacky <thomas.lendacky@amd.com>

After SNP is disabled, any pages allocated as HV_FIXED can now be freed.
Update the page state of these pages and the snp_leak_hv_fixed_pages()
function to free pages on SNP_SHUTDOWN.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/ccp/sev-dev.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 366303ff6466..939fa8aa155c 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1219,7 +1219,7 @@ static void snp_add_hv_fixed_pages(struct sev_device *sev, struct sev_data_range
 
 static void snp_leak_hv_fixed_pages(void)
 {
-	struct snp_hv_fixed_pages_entry *entry;
+	struct snp_hv_fixed_pages_entry *entry, *nentry;
 
 	/* List is protected by sev_cmd_mutex */
 	lockdep_assert_held(&sev_cmd_mutex);
@@ -1227,10 +1227,16 @@ static void snp_leak_hv_fixed_pages(void)
 	if (list_empty(&snp_hv_fixed_pages))
 		return;
 
-	list_for_each_entry(entry, &snp_hv_fixed_pages, list)
-		if (entry->page_state == HV_FIXED)
+	list_for_each_entry_safe(entry, nentry, &snp_hv_fixed_pages, list) {
+		if (entry->free && entry->page_state != HV_FIXED)
+			__free_pages(entry->page, entry->order);
+		else
 			__snp_leak_pages(page_to_pfn(entry->page),
 					 1 << entry->order, false);
+
+		list_del(&entry->list);
+		kfree(entry);
+	}
 }
 
 bool sev_is_snp_ciphertext_hiding_supported(void)
@@ -2077,6 +2083,7 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	if (data.x86_snp_shutdown) {
 		if (!panic)
 			snp_shutdown();
+		snp_hv_fixed_pages_state_update(sev, ALLOCATED);
 	} else {
 		/*
 		 * SNP_SHUTDOWN_EX with IOMMU_SNP_SHUTDOWN set to 1 disables SNP
-- 
2.53.0

