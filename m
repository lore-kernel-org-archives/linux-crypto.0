Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6085931691A;
	Tue, 24 Mar 2026 19:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774381320; cv=none; b=CqYw6njqZkmTN1thMkvqNO7KI2yu1tBnJBKao2PLsCof0xT8OLceFXyU/MHb6H2NJw75KUCVy5nDfu0775ZmGNd29dTcerg8R/xmfmVLroxaqoX7QXyHP0mMBajUIgNDkT7Diyak1F6/UzBHVPCI/+GOyaP9B09E58C9bSDS7kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774381320; c=relaxed/simple;
	bh=uSy52ecrsDgShw6jrs/tIu/591cJxNs1LYgkMzC/Poo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvxWDBBnFIYdaqR/+lXI0s/CKX4LYHYYta93jsz4i+9fxVdGhUr/uXnoRBPRb3o8B8LumrHR7JmRMY34McI3zRQgJWtv/SnCcJPh3rpaOYFZxoxIkg0OrfcB2h3x0WpfMeJu/wpKPF0Ly54iaxVnwAhtAzmdOQLTVGIJ1Ca+Ugk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J0ARYfPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J0ARYfPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA3FC2BC9E;
	Tue, 24 Mar 2026 19:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774381320;
	bh=uSy52ecrsDgShw6jrs/tIu/591cJxNs1LYgkMzC/Poo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0ARYfPeRqiCWFhOuCR+rL7WX6ci2gG+MOOBIlm36LY/j+00JDI/nuWjUz95zv+5V
	 z31zil8CWmEtrG3hU0KCL0/4da5fBlb7F2+zjc/SUhjweCew73XLV406lolQmlyElN
	 WX8xNpEcLcxchpkg/kwaUxWUgvpq57KGprjKARP9TcOCEEx1vzF09Kwd7RFo6j08Dy
	 A39UYNZH4Qw/xiGwYeabFVSriU1xW+OCxpeFOWJdHb6Nn+kb/L3JLMLz+KkRd3GiAV
	 vlxFZlzLn96+bfvRl8yeTfJDl3YMye6ymD8bvHS/trf0UrHDpHdZ1VWghSwb65e0lZ
	 6H9GuKTBiZchw==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shuah Khan <shuah@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kim Phillips <kim.phillips@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Nikunj A Dadhania <nikunj@amd.com>,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 1/5] crypto/ccp: hoist kernel part of SNP_PLATFORM_STATUS
Date: Tue, 24 Mar 2026 13:40:30 -0600
Message-ID: <20260324194034.1442133-2-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260324194034.1442133-1-tycho@kernel.org>
References: <20260324194034.1442133-1-tycho@kernel.org>
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
index aebf4dad545e..64fc402f58df 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2367,7 +2367,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	return ret;
 }
 
-static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
+static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
+					int *error)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_data_snp_addr buf;
@@ -2375,9 +2376,6 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 	void *data;
 	int ret;
 
-	if (!argp->data)
-		return -EINVAL;
-
 	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
 	if (!status_page)
 		return -ENOMEM;
@@ -2400,7 +2398,7 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 	}
 
 	buf.address = __psp_pa(data);
-	ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &argp->error);
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
 
 	if (sev->snp_initialized) {
 		/*
@@ -2415,15 +2413,32 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
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
2.53.0

