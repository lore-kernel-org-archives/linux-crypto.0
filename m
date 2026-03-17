Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3897312837;
	Tue, 17 Mar 2026 16:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773764597; cv=none; b=W9zGQiwQ7gFWy+ytUsi93/wPfnKTTqqyh43c5NzdaDnpChuSoAesnrKoUzQMwv/pkQgBp2ZGaBkdNrwauOggXyRPrvBBNiX2bPh0APqIgKnWisOxS7YSA6F/yWN84ZQ343LeD71yogPu1VjCbHEJQQDeRS97+++fpGzZDB/K9+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773764597; c=relaxed/simple;
	bh=q3LEwBb48yBUwAP/JStffirx0olu9s+cHwEqdRIrL1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0W1oR2n1gBc1+uDIr5bA/+VZPjomowGANEj03UD7Ko249qrB/2C5xtYZ38xf2R+9vKkdjo4c+4YALbnLEzBLmO/brcNfwvAutJg329xdcBiAK2V8EtM+YySb21bVipkeepIMl4W7tCb7ti12i2O21VdzjFSnnpsz3NFJ24Ojpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oKHKocuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oKHKocuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D23DC19424;
	Tue, 17 Mar 2026 16:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773764597;
	bh=q3LEwBb48yBUwAP/JStffirx0olu9s+cHwEqdRIrL1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKHKocuSm6iSTQ9qKQBPFGQQaWXV2krpuRnmLUtuBtzbcrfgL0n+3I/utcv2Fn23Z
	 invniLBcyYfTrnl7d3fLXMuo21YViIxu0bCk3bhcgBDinnE0EL4u8N/FQs96+sDoOj
	 l0cJK4Pt2rrfesirbvBNIRBRB35GfcSKBcO5Kq6tzKGlQAFz9Mgok3v2UWbAb9XPXo
	 xzLKy3XCy15GxMIEHSQ0WluCXvwIjHaiibkLSvrsIENORLQCngJJlD1a3r7vtSOHRR
	 pVfKHWVxxqA9Exuw7yXcimUkWvJ3issoxtTPlebWREc/7rJSFL6If3QIM0r7Oifu01
	 aJ2EvPhJ2G+JA==
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
Subject: [PATCH v3 1/7] x86/snp: Create a function to clear/zero the RMP
Date: Tue, 17 Mar 2026 10:21:51 -0600
Message-ID: <20260317162157.150842-2-tycho@kernel.org>
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

From: Tom Lendacky <thomas.lendacky@amd.com>

In preparation for delayed SNP initialization and disablement on shutdown,
create a function, clear_rmp(), that clears the RMP bookkeeping area
and the RMP entries.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 arch/x86/virt/svm/sev.c | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index e35fac0a8a3d..025606969823 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -242,6 +242,32 @@ void __init snp_fixup_e820_tables(void)
 	}
 }
 
+static void clear_rmp(void)
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
@@ -484,7 +510,6 @@ static bool __init setup_rmptable(void)
  */
 int __init snp_rmptable_init(void)
 {
-	unsigned int i;
 	u64 val;
 
 	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
@@ -504,19 +529,7 @@ int __init snp_rmptable_init(void)
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
+	clear_rmp();
 
 	/* MtrrFixDramModEn must be enabled on all the CPUs prior to enabling SNP. */
 	on_each_cpu(mfd_enable, NULL, 1);
-- 
2.53.0

