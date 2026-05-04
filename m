Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2E33E3C70;
	Mon,  4 May 2026 16:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777913532; cv=none; b=Ft/W6FjMJjLrG0XCT9mCsKV5nnSESIVSbCLH7oq/u+Xz+72YOaN31N2DvaeppKPPyMNoOuUTvKgLq89uubKLR0NU6RXonNyatwjT73RjohhLSRKDv7ZYYSNgFZLc0V9I1K5yOC9ZHIuPyqt9TFWxbFZJJGywU61myDuLbzEfHwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777913532; c=relaxed/simple;
	bh=HM4Br/QU/g7NoeMZmnTUdN191ndbVU+zKKGtXB13CoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJVKXdUQmjGbrDJ95yLIek/NMmdNVghfE8CrBoYMuPPCusaOruXTvGhuKvRaj444rVVjaNj4au3yXwBY7N/85JAjpEeHbvxajGihSMFm0Gl1nuJd/NeqxCrWO0EaY4Y2aXqWp0FUF2bpObyFQruu1q/Xd+gMhxd4gnGHsPtvsNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uHamJ/8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uHamJ/8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B57CC2BCF4;
	Mon,  4 May 2026 16:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777913531;
	bh=HM4Br/QU/g7NoeMZmnTUdN191ndbVU+zKKGtXB13CoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uHamJ/8tqsKHEQud6yGtQP0kwVTKrDuf7sutK8SebaIwuDnCJ3zJsWyoyh6LmZF+6
	 hSq7F2yH0hrCnwiiRU0qtQioGjttWad4Ec8x16fgk0pUXTCGToqIsacUUSoIIXln0r
	 oUDBZW/QrqT0Kh6xWHzB/wk0lRzwcL3KFnTE0iPWmDxLSr+pMeMk9EP0em9Tj3h8OO
	 16C2kg4/CaMmAxPn/Zk6Ulj3oa36tMKz1dJbbHbKxiJE47GwKUlE8qowKS/HUNaV/t
	 RH3wkEqZRsc0jSWYZlXDQcVd+muqscImDUc07VGjx0Gx0C2u1Spc5s14Ph/YTS+UDb
	 u4DeYJPjlHdVw==
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
Subject: [PATCH v2 1/4] crypto/ccp: Do not initialize SNP for SEV ioctls
Date: Mon,  4 May 2026 10:51:44 -0600
Message-ID: <20260504165147.1615643-2-tycho@kernel.org>
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
CC: <stable@vger.kernel.org>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
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
2.54.0

