Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BA334D3B1;
	Mon,  9 Mar 2026 18:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773079294; cv=none; b=GCUjmHiw4CMvKeAnGPAOEkrTMW14/8OzQWT0nJa4/rvhJ78ahXrtKTG/Ez/kFvJdedzH2k5Nt0J+amxPJ5WvxUOZF8vZyD8SDZeKDaWnQPxuwu00qVC3t+57wqjbSbIE4VrxaT8KPokHyJAM8i7579pikf05ncNn4nX7e+ASapQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773079294; c=relaxed/simple;
	bh=+CVA3mASejU0tJVdTlEmr5PknhwxAcNa6ZiN8WZxJf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqYrIm0bxMGkwzhZI2atDh9/3xIvuFSqLsJotMYfkdW/Wk6PuwTYUlsgjH3sN3u1tMdot6HokMvaAjj3pW83XSjVLtg+Sd6suN9ufcGKfiR7w6z6rO3KvNVTzV7UvuhZEAhguUAl8+KjvycVLzPzWDmgzp7EhyOQ3wDxFqFp40k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P9SwTU4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P9SwTU4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552A4C2BCAF;
	Mon,  9 Mar 2026 18:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773079294;
	bh=+CVA3mASejU0tJVdTlEmr5PknhwxAcNa6ZiN8WZxJf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9SwTU4Me5kUa/H1ZRG32HJzmK22L4v1dr739dL5BEwrOxpzCVu701NVlmrg5j3jt
	 UPnjtGotWGlznL1k5Tao+MmcGYaSNZpqzaiey/qWldQVYUqltPsV7V8DkXFUrobTw+
	 uVlcHze1IolCklJciox/B4wtsKNZX31AuhpODzhGc9rKkTH45BhlysYU6J5tQn7/Eb
	 sWmnc47NspAueshDzE8CBd+ntNkqAznOby4IogAqd7ZZolOVoW3qqArcru7OAbmr1h
	 oKJQA6X2wxgx53wyxkmzJxXXhdD/56MHNCK8NdvbylUKTATqoJKrKhM9HaPhyfjte1
	 8+tcpYS4kdUQw==
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
Subject: [PATCH v2 09/10] crypto: ccp - implement SNP x86 shutdown
Date: Mon,  9 Mar 2026 12:00:51 -0600
Message-ID: <20260309180053.2389118-10-tycho@kernel.org>
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

The SEV firmware has support to disable SNP during an SNP_SHUTDOWN_EX
command. Verify that this support is available and set the flag so that SNP
is disabled when it is not being used. In cases where SNP is disabled, skip
the call to amd_iommu_snp_disable(), as all of the IOMMU pages have already
been made shared. Also skip the panic case, since snp_x86_shutdown() does
IPIs.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 41 +++++++++++++++++++++---------------
 include/linux/psp-sev.h      |  4 +++-
 2 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index b10104f243b9..be6f3720e929 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2039,6 +2039,8 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	memset(&data, 0, sizeof(data));
 	data.len = sizeof(data);
 	data.iommu_snp_shutdown = 1;
+	if (sev->snp_feat_info_0.ecx & SNP_X86_SHUTDOWN_SUPPORTED)
+		data.x86_snp_shutdown = 1;
 
 	/*
 	 * If invoked during panic handling, local interrupts are disabled
@@ -2072,23 +2074,28 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 		return ret;
 	}
 
-	/*
-	 * SNP_SHUTDOWN_EX with IOMMU_SNP_SHUTDOWN set to 1 disables SNP
-	 * enforcement by the IOMMU and also transitions all pages
-	 * associated with the IOMMU to the Reclaim state.
-	 * Firmware was transitioning the IOMMU pages to Hypervisor state
-	 * before version 1.53. But, accounting for the number of assigned
-	 * 4kB pages in a 2M page was done incorrectly by not transitioning
-	 * to the Reclaim state. This resulted in RMP #PF when later accessing
-	 * the 2M page containing those pages during kexec boot. Hence, the
-	 * firmware now transitions these pages to Reclaim state and hypervisor
-	 * needs to transition these pages to shared state. SNP Firmware
-	 * version 1.53 and above are needed for kexec boot.
-	 */
-	ret = amd_iommu_snp_disable();
-	if (ret) {
-		dev_err(sev->dev, "SNP IOMMU shutdown failed\n");
-		return ret;
+	if (data.x86_snp_shutdown) {
+		if (!panic)
+			snp_x86_shutdown();
+	} else {
+		/*
+		 * SNP_SHUTDOWN_EX with IOMMU_SNP_SHUTDOWN set to 1 disables SNP
+		 * enforcement by the IOMMU and also transitions all pages
+		 * associated with the IOMMU to the Reclaim state.
+		 * Firmware was transitioning the IOMMU pages to Hypervisor state
+		 * before version 1.53. But, accounting for the number of assigned
+		 * 4kB pages in a 2M page was done incorrectly by not transitioning
+		 * to the Reclaim state. This resulted in RMP #PF when later accessing
+		 * the 2M page containing those pages during kexec boot. Hence, the
+		 * firmware now transitions these pages to Reclaim state and hypervisor
+		 * needs to transition these pages to shared state. SNP Firmware
+		 * version 1.53 and above are needed for kexec boot.
+		 */
+		ret = amd_iommu_snp_disable();
+		if (ret) {
+			dev_err(sev->dev, "SNP IOMMU shutdown failed\n");
+			return ret;
+		}
 	}
 
 	snp_leak_hv_fixed_pages();
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 69ffa4b4d1fa..2adb990189c1 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -834,7 +834,8 @@ struct sev_data_range_list {
 struct sev_data_snp_shutdown_ex {
 	u32 len;
 	u32 iommu_snp_shutdown:1;
-	u32 rsvd1:31;
+	u32 x86_snp_shutdown:1;
+	u32 rsvd1:30;
 } __packed;
 
 /**
@@ -891,6 +892,7 @@ struct snp_feature_info {
 } __packed;
 
 /* Feature bits in ECX */
+#define SNP_X86_SHUTDOWN_SUPPORTED		BIT(1)
 #define SNP_RAPL_DISABLE_SUPPORTED		BIT(2)
 #define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
 #define SNP_AES_256_XTS_POLICY_SUPPORTED	BIT(4)
-- 
2.53.0

