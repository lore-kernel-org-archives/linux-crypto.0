Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B687740FD8F;
	Thu, 26 Mar 2026 16:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774541508; cv=none; b=Bch2x2WxsmYWJpraiIVRNgKd4Gs10NceFFtK0Mw2cv2RLiSYOBufAe4FZjjtoweyXiQc5tQ6wVcxgaiX8bKx7uYfuRi3/VNbApK2ITfKsXM4I+FBKPBQrIGmY2iggnVlwaLa5oDVtojpf/vXaJyJIGqifBcVXTAfzobwC8+PZuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774541508; c=relaxed/simple;
	bh=EFFPAkfKUBUtv+l4cFHBmfeFlJDbrj3N6cEEBH5VfVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYZgpS3ds/ScXxSh4PZ8rhMmMkwU9b0sXzLmJNp9rRJdFxTg1sf+141xZDNnCGsCPPMZj+UfjzmTE2biZZX+8B6G1qoVZhZi8b4fANumbzxcdkJygyXGA9uzaAcvJi5q4JSzSeg0MFspZpSYnBaqCykJ6+sCvGMdimEQMVRdIus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oYExnnwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oYExnnwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1877BC19424;
	Thu, 26 Mar 2026 16:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774541508;
	bh=EFFPAkfKUBUtv+l4cFHBmfeFlJDbrj3N6cEEBH5VfVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYExnnwzqRmwNl+Gso8mO+PCM85uFGhunEva0fxS+UbvJiiFccpiKui5DSDCAxzsd
	 yuj6Sdk72w0M0Boj/JOM1bzwGe+utX5RErsOQUuAeeQ2hQAEAoUkcK5Un061Rub2MO
	 TcYhpaIphY64tI7pblLRB8PctBxIMV0SIhAZgV3bL/p3XVFaaAmqHKI0r5u955T1SM
	 gQncMF/NSVAVhobKHZ0slFGelkW1sm83qco5kArrpYCfZ01NFOG5EoP8TaQKARIfDw
	 lJz9RjARGNgZYa9PmoXi7vZujD9lKRAxypQcGY24yKJPdbtz1JZRLBlFc6m1dPm5wj
	 Vm8arv1skBytQ==
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
Subject: [PATCH v5 6/7] crypto/ccp: Implement SNP x86 shutdown
Date: Thu, 26 Mar 2026 10:11:09 -0600
Message-ID: <20260326161110.1764303-7-tycho@kernel.org>
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

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

The SEV firmware has support to disable SNP during an SNP_SHUTDOWN_EX
command. Verify that this support is available and set the flag so that SNP
is disabled when it is not being used. In cases where SNP is disabled, skip
the call to amd_iommu_snp_disable(), as all of the IOMMU pages have already
been made shared. Also skip the panic case, since snp_shutdown() does
IPIs.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/ccp/sev-dev.c | 41 +++++++++++++++++++++---------------
 include/linux/psp-sev.h      |  5 ++++-
 2 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 47cb8fca4e6c..366303ff6466 100644
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
+			snp_shutdown();
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
index 69ffa4b4d1fa..d5099a2baca5 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -829,12 +829,14 @@ struct sev_data_range_list {
  *
  * @len: length of the command buffer read by the PSP
  * @iommu_snp_shutdown: Disable enforcement of SNP in the IOMMU
+ * @x86_snp_shutdown: Disable SNP on all cores
  * @rsvd1: reserved
  */
 struct sev_data_snp_shutdown_ex {
 	u32 len;
 	u32 iommu_snp_shutdown:1;
-	u32 rsvd1:31;
+	u32 x86_snp_shutdown:1;
+	u32 rsvd1:30;
 } __packed;
 
 /**
@@ -891,6 +893,7 @@ struct snp_feature_info {
 } __packed;
 
 /* Feature bits in ECX */
+#define SNP_X86_SHUTDOWN_SUPPORTED		BIT(1)
 #define SNP_RAPL_DISABLE_SUPPORTED		BIT(2)
 #define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
 #define SNP_AES_256_XTS_POLICY_SUPPORTED	BIT(4)
-- 
2.53.0

