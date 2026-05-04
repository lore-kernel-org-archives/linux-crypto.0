Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7063E3D9C;
	Mon,  4 May 2026 16:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777913537; cv=none; b=oUeIdT4DTPtdiPmjaWeRSxM1mAb12Jk5uyHZO4a7gz4XGlZzDoey9BbB7KWCqUirBL3syx5supoRIgmhPY3ggwYRwj5GGF37Jd2I9dpUFYq48TQ8Z1oZCJUPcKyxk+t0SJ7ozsgB6TuKUs+fTJ+oqXqQ/AGGdNXdzCkdo3/hmQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777913537; c=relaxed/simple;
	bh=YgNEz2GgxfbZjC06CdBKMrFbR54U7WwWhBedkxltfjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbLsSjs4AkdbS/Cb8Boaqkw0rJYkh8YWFkrLCVVSNJ8abCCDjYT9Rb3L/LEaJvsaIz6M89PMbjKj0MH85arKzX8iGWia4lQG0nq6RXq/fJH/7LljdWLPDi2KuYQU3S62czHClRf56xVtlrhV3f20b9UYMW2tWfvVKYgl1JvBoLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kK0P+s/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kK0P+s/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DD9C2BCB8;
	Mon,  4 May 2026 16:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777913535;
	bh=YgNEz2GgxfbZjC06CdBKMrFbR54U7WwWhBedkxltfjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kK0P+s/luF5NmD6qMIJgQBr6wP4XN/hxoq4VOSBObtkUEqiUiivmMBOMpo/6pfulF
	 jw4mmZfQ6VyGkoBsFlinKUz1Izxy80OdUd6CyWlFCRYDbhuO0Cp3DImd1Ur0R6ivjk
	 bwdeFAo2wi9dQoPiELiz96IjCD3+KEN/FelQv11+XsW6yacuFLcXoCrOKtQy1q2Xnn
	 aaFdONApOJ+H/Hp5TICMnmvzSJmGYy/cT6qRgMz60qE/UwoFztYyM6BIoPdW3ZV3qH
	 t7LDDz/fELPmqmryXh73DyZwtur6h6HUlY2BHsFRpycfgoXqWqXwMjWTzBCEvU+96B
	 Ml5eWb68j8A7Q==
From: Tycho Andersen <tycho@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ashish Kalra <ashish.kalra@amd.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Brijesh Singh <brijesh.singh@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Dan Williams <dan.j.williams@intel.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 3/4] crypto/ccp: Do not initialize SNP for ioctl(SNP_VLEK_LOAD)
Date: Mon,  4 May 2026 10:51:46 -0600
Message-ID: <20260504165147.1615643-4-tycho@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504165147.1615643-1-tycho@kernel.org>
References: <20260504165147.1615643-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

Sashiko notes:

> if SEV initialization fails and KVM is actively running normal VMs, could a
> userspace process trigger this code path via /dev/sev ioctls (e.g.,
> SEV_PDH_GEN) and zero out MSR_VM_HSAVE_PA globally? Would the next VMRUN
> execution for an active VM trigger a general protection fault and crash the
> host?

The SEV firmware docs for SNP_VLEK_LOAD note:

> On SNP_SHUTDOWN, the VLEK is deleted.

That is, the initialization/shutdown wrapper here is pointless, because the
firmware immediately throws away the key anyway. Instead, refuse to do
anything if SNP has not been previously initialized.

This is an ABI break: before, this was a no-op and almost certainly a
mistake by userspace, and now it returns -ENODEV. ABI compatibility could be
maintained here by simply returning 0 in the check instead.

Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
Reported-by: Sashiko
Assisted-by: Gemini:gemini-3.1-pro-preview
Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
CC: <stable@vger.kernel.org>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 572f06368d4b..ad6c2525a305 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2481,9 +2481,8 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_snp_vlek_load input;
-	bool shutdown_required = false;
-	int ret, error;
 	void *blob;
+	int ret;
 
 	if (!argp->data)
 		return -EINVAL;
@@ -2491,6 +2490,9 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 	if (!writable)
 		return -EPERM;
 
+	if (!sev->snp_initialized)
+		return -ENODEV;
+
 	if (copy_from_user(&input, u64_to_user_ptr(argp->data), sizeof(input)))
 		return -EFAULT;
 
@@ -2504,18 +2506,7 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 
 	input.vlek_wrapped_address = __psp_pa(blob);
 
-	if (!sev->snp_initialized) {
-		ret = snp_move_to_init_state(argp, &shutdown_required);
-		if (ret)
-			goto cleanup;
-	}
-
 	ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
-
-	if (shutdown_required)
-		__sev_snp_shutdown_locked(&error, false);
-
-cleanup:
 	kfree(blob);
 
 	return ret;
-- 
2.54.0

