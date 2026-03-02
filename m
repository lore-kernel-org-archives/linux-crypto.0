Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BEF309F09;
	Mon,  2 Mar 2026 19:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772478894; cv=none; b=DMiroMaoBbO4+DBudXDWBPZ+daGIOg0L6BuN15eJzZC6QRHY1u3Pkc23CbioexdYe5tncKtmppIEhWUJO07t04450UnVjmqecxdaWH2Y5El1+hChs6jRXEOlyrR/+vrDLgHKIlfEEUFP59VwLZKH5MQFUYayBEmS45bwRVHSfKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772478894; c=relaxed/simple;
	bh=21Ry7jjWIzbqzER/hdAupJ4NZhWr92e6AyaCs3rFQlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcHB9QLebCTtg3bq1H5Bt8TxlWXqgsBhHI8vcKzqBSP9iO9LUFV8cXr5gFplbWu+VE5mtb6N8mYOXFTpJ6x/F/PUKBk0tM0rS4I5xcBM3iXdhkBCAQNXpFG3/paoP75gtWZATAqwjtcU53p/+aeK7R42pOJxjPNfxv0f/qMq3nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mz0UrFJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mz0UrFJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9113C2BC87;
	Mon,  2 Mar 2026 19:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772478894;
	bh=21Ry7jjWIzbqzER/hdAupJ4NZhWr92e6AyaCs3rFQlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mz0UrFJ8CfJpIQMb1hyfCwv0EAwfJboNF0nWpWKhkJh9L5/iWO92aMEa1DcSGF2KP
	 DSZMJYuGN+AQXFeZ9NaXf/FH2MS6KDPbrBt5TaLUF7qv8UnSrsqm5pCi6rP2qX/V1C
	 DycMuIlDzbG0tj6BEbUOIrdBH7bKq0+aXRX+gE0cNg1/KGv50NYaL9CF9Q4OwXn0qm
	 eaLCLdTry9nelMUUH3YTWXd5r6pQCZw0ECduUBOcos8ObuwqSNZ+UcNsSCsk+BiGuV
	 gwwRGOzrhOTI6f1XG4WydKndzE8nVS8xHiiJvA7I+R5cDNgB9B2ia0XgfhLnt1tK/x
	 9BxBk/x6W/lKQ==
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
Subject: [PATCH 10/11] crypto: ccp - implement SNP x86 shutdown
Date: Mon,  2 Mar 2026 12:13:33 -0700
Message-ID: <20260302191334.937981-11-tycho@kernel.org>
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

The SEV firmware has support to disable SNP during an SNP_SHUTDOWN_EX
command. Verify that this support is available and set the flag so that SNP
is disabled when it is not being used. In cases where SNP is disabled, skip
the call to amd_iommu_snp_disable(), as all of the IOMMU pages have already
been made shared.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 44 ++++++++++++++++++++++--------------
 include/linux/psp-sev.h      |  4 +++-
 2 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index ef45977b09b6..665fe0615b06 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2028,6 +2028,7 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	struct psp_device *psp = psp_master;
 	struct sev_device *sev;
 	struct sev_data_snp_shutdown_ex data;
+	u64 syscfg;
 	int ret;
 
 	if (!psp || !psp->sev_data)
@@ -2041,6 +2042,8 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	memset(&data, 0, sizeof(data));
 	data.len = sizeof(data);
 	data.iommu_snp_shutdown = 1;
+	if (sev->snp_feat_info_0.ecx & SNP_X86_SHUTDOWN_SUPPORTED)
+		data.x86_snp_shutdown = 1;
 
 	/*
 	 * If invoked during panic handling, local interrupts are disabled
@@ -2074,23 +2077,30 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
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
+	rdmsrq(MSR_AMD64_SYSCFG, syscfg);
+	if (data.x86_snp_shutdown &&
+	    !WARN_ON_ONCE(syscfg & MSR_AMD64_SYSCFG_SNP_EN)) {
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

