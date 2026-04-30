Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E7B46AF0F;
	Thu, 30 Apr 2026 16:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777565282; cv=none; b=ZlUrt/mPBFm/KllIG3ni5a/oRlf5tKywbHhwxy6ftMCJ/7P0PayoWKl7/0kjm8P5iS0R+R/jLvtDStpklblwHgaJq/rodK4Cjcs7XwFXJy5eNouSoFMFeYcQexCKpUInHwUedGo7msv01QLHmf4jnEG4N3QTWl/tGVoZW04eOlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777565282; c=relaxed/simple;
	bh=C1WWXsx7zxzzTYAeVl8gjACb9XsYo205RN3A//xC6lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGT9a1nwsIDfrNSJtjyJkLM7XZSbzFpiNV0XMMTHkffQneG7iOuaR7LL8Rn4y8ghr55t4KJwVi0QvG28RnzgtSZCGIhAzfg6c0TTWPdqjCiCi83q8t562bRr15R2Lgt3ODcC546AtJQkyw9G+tnbLdTi4RhTnF98c37lJtABlsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r9xLpc7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r9xLpc7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCB7C2BCB8;
	Thu, 30 Apr 2026 16:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777565281;
	bh=C1WWXsx7zxzzTYAeVl8gjACb9XsYo205RN3A//xC6lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9xLpc7T2ZNdfl+T2mHWYSBVgG4JOYXPrFkU7lIh2jyP5srd/R/TD0xKgwSSb5M/l
	 c4raRkiEMZGrCsUbPbLKGWkpQ4uc0Yny+y8oZQwfmTeegPFGIkcc8Rp6He03dNhtCz
	 Khl4BpUKhVQfv+tbzQj4LBVl1Swesh7CJKFQoT1MIY4ZkBHfo09648OigdkWBGrQtH
	 ja0Vpzv9crsVPRXPCEsV2kdFaVMbuuAHY+5ekBdfmSHn72b6zlb6ZUGek70inMVf/+
	 Vuf6/PIy1WvALsdS7sYHbXJok+9MPQaUHK3irUu6Y6mEaYSRnclYSySasY3xAktC6c
	 gxy76oUYqtduw==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Kim Phillips <kim.phillips@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Pratik R. Sampat" <prsampat@amd.com>,
	Michael Roth <michael.roth@amd.com>
Subject: [RFC v1 1/6] crypto/ccp: Hoist kernel part of SNP_PLATFORM_STATUS
Date: Thu, 30 Apr 2026 10:07:11 -0600
Message-ID: <20260430160716.1120553-2-tycho@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430160716.1120553-1-tycho@kernel.org>
References: <20260430160716.1120553-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

...to its own function. This way it can be used when the kernel needs
access to the platform status regardless of the INIT state of the firmware.

No functional change intended.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index d1e9e0ac63b6..22bc4ef27a63 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2381,7 +2381,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	return ret;
 }
 
-static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
+static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
+					int *error)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_data_snp_addr buf;
@@ -2389,9 +2390,6 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 	void *data;
 	int ret;
 
-	if (!argp->data)
-		return -EINVAL;
-
 	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
 	if (!status_page)
 		return -ENOMEM;
@@ -2414,7 +2412,7 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 	}
 
 	buf.address = __psp_pa(data);
-	ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &argp->error);
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
 
 	if (sev->snp_initialized) {
 		/*
@@ -2429,15 +2427,32 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 	if (ret)
 		goto cleanup;
 
-	if (copy_to_user((void __user *)argp->data, data,
-			 sizeof(struct sev_user_data_snp_status)))
-		ret = -EFAULT;
+	memcpy(status, data, sizeof(*status));
 
 cleanup:
 	__free_pages(status_page, 0);
 	return ret;
 }
 
+static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_snp_status status;
+	int ret;
+
+	if (!argp->data)
+		return -EINVAL;
+
+	ret = __sev_do_snp_platform_status(&status, &argp->error);
+	if (ret < 0)
+		return ret;
+
+	if (copy_to_user((void __user *)argp->data, &status,
+			 sizeof(struct sev_user_data_snp_status)))
+		ret = -EFAULT;
+
+	return ret;
+}
+
 static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
 {
 	struct sev_device *sev = psp_master->sev_data;
-- 
2.54.0

