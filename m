Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154AC34FF76;
	Mon, 27 Apr 2026 16:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306544; cv=none; b=EyLiuvHBXh+iJdx2i1N7Lsr898An5eqAd8/443tyY37cWSIOfU4RsCBxTmZtYVpz/9Ihd2vLhmJN6LLEoVlKh/pOmqwEC9A4XB5LO32L/4cTXNQlCETXtfabFAPJUAcj/pJmkAUuTINsYUMaqMQE+4HjRBWPVpYEt/7BFQhWDJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306544; c=relaxed/simple;
	bh=k+ixcJknwre6q34CCiMJgH6/hhzle1sP7nNkFejXdIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Le9VLN8IXcoEJ/OeJkYypoBDYE57QrRnJ4mPuBJTj2cd30ePXGVVvj75/RxLpACU7dpPA4cEyLqsheZtJh4EDTqVOTEWs2OShQCmytH6QOOKhnG5OTSrh7r1P20QtyIlfk6ID24Z+kK0D6s2virjGLfO08EPcFxjoH/FXsclcpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L8RaBZ45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L8RaBZ45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6911CC19425;
	Mon, 27 Apr 2026 16:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777306543;
	bh=k+ixcJknwre6q34CCiMJgH6/hhzle1sP7nNkFejXdIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8RaBZ45vGuJIwmxBP/QaEd1eueqdRRieonal3/6gLibdHDxQWen7k6ceyawFdVMO
	 EbrsdyYi/2qh+s1TwFO3LOtA53hE/aneQ3WzUM1xPWdQhVDclXd+oaNBRf4kfdfIQa
	 yXw83ebV2n1YrEKGJOFfk+0y3p7sZy7ZXpZT7rMT0gpM4oTIasp9Wsnnsv8cqtgnUq
	 Svd+PQT4o3E/HsXNCnNR1gD5OVlcSLkwVNTrjDCUkjgCumUnzvcD+Kun9qj+RdC7Vx
	 pu/qYsgX1mVYF8Ei1WEbNru2Ua38GI67CkzZWT2eCDBqNy63q6mvtenJLyaGin51kw
	 Y9Cf2YPAgrg4Q==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Borislav Petkov <bp@alien8.de>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>
Subject: [PATCH v1 3/4] crypto/ccp: Do not initialize SNP for ioctl(SNP_VLEK_LOAD)
Date: Mon, 27 Apr 2026 10:15:06 -0600
Message-ID: <20260427161507.32686-4-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260427161507.32686-1-tycho@kernel.org>
References: <20260427161507.32686-1-tycho@kernel.org>
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

Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
Reported-by: Sashiko
Assisted-by: Gemini:gemini-3.1-pro-preview
Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 572f06368d4b..e8c3ac6d989a 100644
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
@@ -2497,6 +2496,9 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 	if (input.len != sizeof(input) || input.vlek_wrapped_version != 0)
 		return -EINVAL;
 
+	if (!sev->snp_initialized)
+		return -EINVAL;
+
 	blob = psp_copy_user_blob(input.vlek_wrapped_address,
 				  sizeof(struct sev_user_data_snp_wrapped_vlek_hashstick));
 	if (IS_ERR(blob))
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
2.53.0

