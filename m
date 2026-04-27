Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F233D646C;
	Mon, 27 Apr 2026 16:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306545; cv=none; b=BA6lXoQOMd+dxvYoXE9l5NtEEiONyeXKB5yau8Yz+upxuudD0CGde1gvStH78wGbG7xaUAwZnD8zcqpJtTLP8pdfCoyo/f9g7TMKKVJ2NbEoXpTWF4ayQT3GhR6aB3Hq9OgVI3yHIJ9VDhxsRgLB6KwvKwn20obmN+bja/jDjuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306545; c=relaxed/simple;
	bh=3jamtsGYAbH++td68bEeRovzkP04ihwgbfd/GpwYtQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvR650u1Mtgu5PkBlZPP6WPKh03VswghIoio0Bp0MayYT9omfQ9z4SQqw0azrxryA9hb90367aff5p5oSfN4tOxjvStduiybu3Q42t2toHJju5dv1MoyNhyhRBP56hHsaNJWa6C5AME9s32ArNmRpnrx6+Ihe9kbedrC/O1Lg4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FzSy2Cdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FzSy2Cdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E4DC2BCB7;
	Mon, 27 Apr 2026 16:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777306545;
	bh=3jamtsGYAbH++td68bEeRovzkP04ihwgbfd/GpwYtQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzSy2CdvNvnm7lfZO4ezO6oX1XZZ4jq6zbYmev5cMBoVk3XM+IEmRkWuL4BB63rD6
	 LDww26458PVKbNG4OqxtSLC1pWnVkz/N8Nn9Q93eJ6IwOeS4tTRUPr9C+L+T4qzhyM
	 JM3pwIC6qykKxmTCyaOvy+fTZg0Hh9xUbVXtUqXzOFVWWKvMUUYOWlUH6+ItrHNX56
	 m6GyhSu1ZUhXpsar25XRyF/p1Qkx86MWzaMph5ifHGymSM1JAbt7J1v+pNlz8xl/rv
	 BUaK20OiLPJ6oIsledonorniqWTiZc4mZxXRXnhGgfX5+cEUA6C/HSnFZoYJI9n7I2
	 VGYl/GA1H9wnA==
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
Subject: [PATCH v1 4/4] crypto/ccp: Do not initialize SNP for ioctl(SNP_CONFIG)
Date: Mon, 27 Apr 2026 10:15:07 -0600
Message-ID: <20260427161507.32686-5-tycho@kernel.org>
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
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 33 ++++-----------------------------
 1 file changed, 4 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e8c3ac6d989a..5b113908a4f9 100644
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
+		return -EINVAL;
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
2.53.0

