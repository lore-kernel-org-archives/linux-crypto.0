Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F7035AC32;
	Mon, 27 Apr 2026 16:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306540; cv=none; b=tw4qCbGMemAlWaIM8vuYkn1tpJr/RN3Z5dlZ2/gCPmKXDuMDwp3On+3kX4KJVntNQT3vQeDLLokBznjq348dpDWL6Z2Yhz52nQ9U4yZBIW/vuloGfbKQgM3exi1JOj7SssHnkaQtCHnfN2ffyud1YpKmzYUhTViXFaMEP2dLDFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306540; c=relaxed/simple;
	bh=J8ZpFzOkrsE8Rd7KjjR9PYZ6e8XG2Q66HZDH5fx2iCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6kWHx1V01Ov+ZL5xdpKbOEP+vl6L6hnQWYgL/g/D6JweI6eob+wB/8/ZAFoNzwb212KTU+Y9amV4a+mqhWFEmcRkzFlF85gebRjESBCCYMj0XUJNmStySumtWDSDgjILRDOkh9aVbiJzzEkgib7EIAH4NZRP25tvANlgT6tJVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hBI5jAAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hBI5jAAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F4EC2BCB7;
	Mon, 27 Apr 2026 16:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777306540;
	bh=J8ZpFzOkrsE8Rd7KjjR9PYZ6e8XG2Q66HZDH5fx2iCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hBI5jAALSlMPavCbUQXjYh5nzq/fVLi2HxP6f07Qa+sg05+vgr4bqMZfagyaLZFuy
	 iGhDAPhR6WR+/awmWaEOZnhCFIutZRIIbvbdydLWvQd3sAruK3wgF8E+CkM/XxILyL
	 KXbeA9PtUGG/nA6CgktXyHVAs83r1p26r7pGmuOFg1m1tkYN6wvN0B54MRh/gPC84V
	 Vzp/oKm21F9CgZ0W96n+mKD7RcnsxaHHvAYigsh7zc6TWKpm+URwGWvbYYz3H/jEfM
	 aU5wcTyO/d3mXfev7pkFzrWyWXeUn689nLRPSXfktUo9Om/h/paF7JEmleaF9PWgYT
	 sVZtH9LVHfySg==
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
Subject: [PATCH v1 1/4] crypto/ccp: Do not initialize SNP for SEV ioctls
Date: Mon, 27 Apr 2026 10:15:04 -0600
Message-ID: <20260427161507.32686-2-tycho@kernel.org>
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

sev_move_to_init_state() is called for ioctls requiring only SEV firmware:
SEV_PEK_GEN, SEV_PDH_GEN, SEV_PEK_CSR, SEV_PEK_CERT_IMPORT, and
SEV_PDH_CERT_EXPORT. After the firmware command, it does SEV_SHUTDOWN on
the SEV firmware. Since these commands do not require SNP to be
initialized, skip it by calling __sev_platform_init_locked() which only
initializes the SEV firmware. This way SNP is not Initialized at all, and
HSAVE_PA is not cleared.

The previous code saved any SEV initialization firmware error to
init_args.error and then threw it away and hardcoded the return value of
INVALID_PLATFORM_STATE regardless of the real firmware error. This patch
changes it to surface the underlying error, which is hopefully both more
useful and doesn't cause any problems.

Note that it is still safe to call __sev_firmware_shutdown() directly: it
calls __sev_snp_shutdown_locked(), which skips SNP shutdown if SNP was not
initialized.

Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
Reported-by: Sashiko
Assisted-by: Gemini:gemini-3.1-pro-preview
Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index d1e9e0ac63b6..6891b90bbb88 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1716,14 +1716,11 @@ static int sev_get_platform_state(int *state, int *error)
 
 static int sev_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_required)
 {
-	struct sev_platform_init_args init_args = {0};
 	int rc;
 
-	rc = _sev_platform_init_locked(&init_args);
-	if (rc) {
-		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
+	rc = __sev_platform_init_locked(&argp->error);
+	if (rc)
 		return rc;
-	}
 
 	*shutdown_required = true;
 
-- 
2.53.0

