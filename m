Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2A9224AF7;
	Mon,  4 May 2026 16:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777913533; cv=none; b=gKuzQh/jakHL015/3+CQhrHQo9LFb4v+T0BaPSFgQ8S3UxyDp2HvW8WFRehPNVPo/1vMqrWxSw8XxD+xhUJgnFoVPIB7W3Fwu1V9KuQHnfaT43VbF1ytNkBLcZhI81UyEY9bk+G5Uc2hQavJuFNJWZjQdgH40AWOwNNXhSqnQ1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777913533; c=relaxed/simple;
	bh=Lv+TqzO/rGkX/kppshZNP2Od+4IjMGCBAoZI2YoaDfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkjF8+wQQPJVrIqBRSSKPH6A4NeEdIQWJ0vemQCzOMiflZoikLUZuJgTfjsY41qJcJnJHswmYhSHBBDr1myRDh8FXfdRwqxHW9j1ez9S9lUDemPbQjd/TL9lUPsJaR0vveEiNhbdl/D1MreoW2Et2PoiHr3vf38bU0XRGw8MJVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qEXxR1Kb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qEXxR1Kb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006BBC2BCF5;
	Mon,  4 May 2026 16:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777913533;
	bh=Lv+TqzO/rGkX/kppshZNP2Od+4IjMGCBAoZI2YoaDfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEXxR1Kb36bo9McYs/H4C1rw0lyFRvJVH7+nif1ofpW8zzQHVJejMywdMcsSt9a6Y
	 4xHb7x46gXGGvjTiwRPzT6h3ErQr/fP/ojC8QczE0E+6aWH3p36E3R1r2a/ovW3R5G
	 xDyJckeYxAVJRQuCa/hcJtW0ucrZ1w8We0+8XzljLkZQvK49Wj/l9H73S2LKmb+hSc
	 UKkWbHSrfKopq41hW08zUc60dS4cdV5JqCqMqX+TXqqH1gSmJwwbLJvOSn0ghExj0F
	 s+HlpP2PibH2x56eWY6I6i1ARcrG3xVbOdpMqUIhX6A+7KErshHuyVrzcW1RttHQUN
	 rzH8wn9LfazLw==
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
Subject: [PATCH v2 2/4] crypto/ccp: Do not initialize SNP for ioctl(SNP_COMMIT)
Date: Mon,  4 May 2026 10:51:45 -0600
Message-ID: <20260504165147.1615643-3-tycho@kernel.org>
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

The SNP_COMMIT command does not require the firmware to be in any
particular state. Skip initializing it if it was previously uninitialized.

The SEV-SNP firmware specification doc 56860 does not mention SNP_COMMIT in
Table 5 as a command that is allowed in the UNINIT state, but it is in fact
allowed and a future documentation update will reflect that.

Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
Reported-by: Sashiko
Assisted-by: Gemini:gemini-3.1-pro-preview
Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
CC: <stable@vger.kernel.org>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 6891b90bbb88..572f06368d4b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2437,24 +2437,13 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 
 static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
 {
-	struct sev_device *sev = psp_master->sev_data;
 	struct sev_data_snp_commit buf;
-	bool shutdown_required = false;
-	int ret, error;
-
-	if (!sev->snp_initialized) {
-		ret = snp_move_to_init_state(argp, &shutdown_required);
-		if (ret)
-			return ret;
-	}
+	int ret;
 
 	buf.len = sizeof(buf);
 
 	ret = __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
 
-	if (shutdown_required)
-		__sev_snp_shutdown_locked(&error, false);
-
 	return ret;
 }
 
-- 
2.54.0

