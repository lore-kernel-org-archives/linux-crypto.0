Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FEF3E7146;
	Mon,  2 Mar 2026 19:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772478889; cv=none; b=q/FNOmBL06itnF/ao2r/A15NADnlqDBAK9cllT9v2kJ2K7UAabFsD7Asoj7iHk4WrzTTg8scM9gpaQWyE1+1ej/ESeivdcyyHd/Ts49QCYUKBSmhHEC1K6kGdKZfAfNCXDkQhEfQcEBnmkdGTWRgdChNV9tQSPpfvnBTFJgz0uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772478889; c=relaxed/simple;
	bh=qAQttDEXuNN5uevUynuFwNEoZIIiao4qqyUzO8+IfTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkxkHgjwADDfhsa/Akv/F8PLiDml9L4pJ392pymqMY4wrbMAMGHDnRtNXYgzAU4Cl7Ssc1OF2u9/4nrtjnL1jyARNSqTtLZQfVhHKIxZBGxnDBxq8izKeLlnfjRkSBB+nelb5WsZJvyWSGQcbLtWrl+74llFYWFbmFEIIYaal/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BT74g3Av; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BT74g3Av"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED95C19423;
	Mon,  2 Mar 2026 19:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772478889;
	bh=qAQttDEXuNN5uevUynuFwNEoZIIiao4qqyUzO8+IfTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BT74g3AvvTBZdWue2nx3S10fGYbGqF7ZTO+PVZ3YMYF6yosRS8zrbCIyBQlIhojK4
	 uDsDRp2uoAVmQC0BD/4/sZm2wvmsUKHIQ2LlLEG2sWdbOxL1CmvzirW64pDWVhakUt
	 r05VXWDKaDNFh+GySBBlMcNKwSUQehv8CwrRDMwv9g1cIF8LGw33or3KJmfOHXplar
	 RD6SrMGKdmMf5+d5HC6IP9gpJy8nfuZ9gZvzSUV5ae3H6IjtFpfvnvl5QHbQccweh9
	 gyGu7fajujQOWlEP7Dj39C1Xm/xzohibTh3GZDIB2ByFTrxE4xSQV0YlcNjERDMi5j
	 bkq1keD3IlxsA==
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
Subject: [PATCH 08/11] x86/snp: allow disabling MFDM
Date: Mon,  2 Mar 2026 12:13:31 -0700
Message-ID: <20260302191334.937981-9-tycho@kernel.org>
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

The SNP x86 shutdown path needs to disable MFDM, since as the comment for
k8_check_syscfg_dram_mod_en(), the "BIOS" is supposed clear it, or the
kernel in the case of module unload and shutdown followed by kexec.

Change this helper to allow for disabling it.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 arch/x86/virt/svm/sev.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 53bc0c7f2c50..cf984b8f4493 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -132,7 +132,7 @@ static unsigned long snp_nr_leaked_pages;
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
-static void mfd_enable(void *arg)
+static void mfd_reconfigure(void *arg)
 {
 	u64 val;
 
@@ -141,7 +141,10 @@ static void mfd_enable(void *arg)
 
 	rdmsrq(MSR_AMD64_SYSCFG, val);
 
-	val |= MSR_AMD64_SYSCFG_MFDM;
+	if (arg)
+		val |= MSR_AMD64_SYSCFG_MFDM;
+	else
+		val &= ~MSR_AMD64_SYSCFG_MFDM;
 
 	wrmsrq(MSR_AMD64_SYSCFG, val);
 }
@@ -532,7 +535,7 @@ void snp_prepare_for_snp_init(void)
 	 * MtrrFixDramModEn is not shared between threads on a core,
 	 * therefore it must be set on all CPUs prior to enabling SNP.
 	 */
-	on_each_cpu(mfd_enable, NULL, 1);
+	on_each_cpu(mfd_reconfigure, (void *)1, 1);
 
 	on_each_cpu(snp_enable, NULL, 1);
 
-- 
2.53.0

