Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A374326923;
	Tue, 17 Mar 2026 16:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773764610; cv=none; b=SRqzufP6Db0amXelKW7kuW0k+X0xKa+yQjh6O+qNJBA+2h/Y54HDxUPALEWbVeu5ShE56P4zfS5nVlbdmbK5z+7LxDiHrf1KHWavT5HSC9aCUgcPxrwR26wnOCQNXdHV7ccB/t65po14G75IlxNU6T8n23SOyb0/+3gprinuXQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773764610; c=relaxed/simple;
	bh=+CVA3mASejU0tJVdTlEmr5PknhwxAcNa6ZiN8WZxJf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sH5PHSrG1TgB8H/LGSggw/HLyXdridjcmIEhoM1PxB+ZkmKYUsjxSBkj74BFjYXIxJeTNz6Q+j/PH+0EPzx6EsrqBC7nYZJjUus/0OUxwzTj5dlnDJwKbQy1CYiGLzg6mIYwOM2kJwwvquAetc75s1NxKUfAD4f7k1gQ0av49KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QZc1YSFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QZc1YSFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B673CC4CEF7;
	Tue, 17 Mar 2026 16:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773764610;
	bh=+CVA3mASejU0tJVdTlEmr5PknhwxAcNa6ZiN8WZxJf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZc1YSFLF9cqfibLIbuN/CLkc2Kroxgu/+tcpMOqpS8RKJbI1KhwaKln4vpVUNXaN
	 zpCcYCrx8+6hgIXMllLX+WTLVrrwJCuucozYhQsJ1l+Mz6Fq9UVKEUs1W7foktiJNS
	 XodeAM0ykx1Ut/WPE2GYKTn8DYgbxkC/KcJW6khQ9GuJMjrU2sxXp5Be+nk4eZG6NT
	 22kJ5P15PoXhx6KfmkaJqfJYN2sEk6JZ7K7UVuwV5ATSfq5JfHUzbegVpesjkC5iN4
	 4IhcW4FXkmWHxYVYtWyfHCLG7SEQJWCCmvvBIxz56dWsvj8mY3NTfl+NugMrhEBMqE
	 jlK3Pg9Ij0+Ag==
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
Subject: [PATCH v3 6/7] crypto: ccp - implement SNP x86 shutdown
Date: Tue, 17 Mar 2026 10:21:56 -0600
Message-ID: <20260317162157.150842-7-tycho@kernel.org>
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

