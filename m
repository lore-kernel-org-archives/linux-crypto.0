Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9D93E3C69;
	Mon,  4 May 2026 16:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777913538; cv=none; b=brm1pGoWvAJhe397SIVPugQ5E4A3X8xZ8cOuzEu6M9fENZmPPi2fWBzhrxUhaVKFO5joMGdaA8AlVsYD2cLTCEG6p7Kh6TGuoU47nLGGDZknyMpdst25aCL9gMyiOUZ8KhQmkozLmZYxuL4GBtKIR3k0HBV9FOaQzJW2xOSYfwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777913538; c=relaxed/simple;
	bh=Fw7svH/liofO4kK7H0XxtvP07i4I2IoOHIbSEEO2pUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yx1DYlVd3RdRy9txe5JDFTGqLLx+mv2cN/hAeDbYnpNiKFSIIDvNkVXViShU7MF7eEqyQKjMIps2pZCoKyeeXyIIDHiCI+Rl5i5POhUazpfGh8FRBBn6xE73qnivApepYzjXZA9qx11cyBmEyAjZYBDYHDojfcYUrrbAgjuzWQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YIC7msaE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YIC7msaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970AEC2BCC4;
	Mon,  4 May 2026 16:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777913537;
	bh=Fw7svH/liofO4kK7H0XxtvP07i4I2IoOHIbSEEO2pUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIC7msaEJqzjuUdGOvWonpjck6LcAUPwDpqJWnKoYPnAbQOUNyK80/4bRbAXFhpND
	 0gbhYkeZOH6sWURLwUEVd5yUnEfV73sobDXdIgNZ0bcxFEmoCVaQuei0gr9eZKF32Z
	 Th6kiYIwYPW/jVLI+meNn5K09EjMxzkOarXvuS2uZr1fYnyL6TihgZivmiYmW+bc/o
	 bdWYllnEpgiiPBHb5X2vI3hzSJzvf4HVq4V1Y4G03Ne+iw2WUpgBy5O7g/M/EECt1S
	 ZFTtqUEvFXVYGhIredWFkyEJ+q1WRD6cFqR/iKgyXubGTCjpi0yhF2vRL+0cE2K6pI
	 9zfWur7PNCazA==
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
Subject: [PATCH v2 4/4] crypto/ccp: Do not initialize SNP for ioctl(SNP_CONFIG)
Date: Mon,  4 May 2026 10:51:47 -0600
Message-ID: <20260504165147.1615643-5-tycho@kernel.org>
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

Refuse to re-try initialization if SNP is not already initialized for
SNP_CONFIG.

This is technically an ABI break: before if SNP initialization failed it
could be transparently retriggered by this ioctl, and if no VMs were
running, everything worked fine. Hopefully this is enough of a corner case
that nobody will notice, but someone does, there are a few options:

* do something like symbol_get() for kvm and refuse to initialize if KVM is
  loaded
* check each cpu's HSAVE_PA for non-zero data before re-initializing
* once initialization has failed, continue to refuse to initialize until
  the ccp module is unloaded

Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
Reported-by: Sashiko
Assisted-by: Gemini:gemini-3.1-pro-preview
Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
CC: <stable@vger.kernel.org>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 33 ++++-----------------------------
 1 file changed, 4 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index ad6c2525a305..7c4dd57fabb9 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1727,21 +1727,6 @@ static int sev_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_req
 	return 0;
 }
 
-static int snp_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_required)
-{
-	int error, rc;
-
-	rc = __sev_snp_init_locked(&error, 0);
-	if (rc) {
-		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
-		return rc;
-	}
-
-	*shutdown_required = true;
-
-	return 0;
-}
-
 static int sev_ioctl_do_reset(struct sev_issue_cmd *argp, bool writable)
 {
 	int state, rc;
@@ -2451,8 +2436,6 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_snp_config config;
-	bool shutdown_required = false;
-	int ret, error;
 
 	if (!argp->data)
 		return -EINVAL;
@@ -2460,21 +2443,13 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
 	if (!writable)
 		return -EPERM;
 
+	if (!sev->snp_initialized)
+		return -ENODEV;
+
 	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
 		return -EFAULT;
 
-	if (!sev->snp_initialized) {
-		ret = snp_move_to_init_state(argp, &shutdown_required);
-		if (ret)
-			return ret;
-	}
-
-	ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
-
-	if (shutdown_required)
-		__sev_snp_shutdown_locked(&error, false);
-
-	return ret;
+	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
 }
 
 static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
-- 
2.54.0

