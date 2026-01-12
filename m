Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE9E303CA0;
	Mon, 12 Jan 2026 05:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768196208; cv=none; b=LSmYhp/JYU5Wp3PEc/mTXR3nFzgPregMb302seQH5X+Utrg8vEhQuMp08/bPkECBBEpIrB1Bw/iSe2nrswaMs91TbEBmAilDlfjgIr/GtezaTtIaYRb5J0I1mCPdYJxlwYy6LnIOS1+At7b2mCRliw1KChkn2Msqg488a6ptOj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768196208; c=relaxed/simple;
	bh=6MonPAQ8Qn8LGNrQyCCDnXQNntRRjzj0Iopo9N2EhaA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a9ZrBAbclHsoeZM6nrpPBOMv61yH7OgRIBxMPHk60725s6Hu+WqkfFwC4/mxBh9fhEEb6JrmHaAImli6RtUKgK7lG5hiW5HxIVwML1F+NpNfY2778GLsmTVpD8iXGeQI7kGCNzxLp3Lic1UaFd4vBSCk1bEpMj+nyBwFPN7hMNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fi6NslZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fi6NslZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A07C116D0;
	Mon, 12 Jan 2026 05:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768196207;
	bh=6MonPAQ8Qn8LGNrQyCCDnXQNntRRjzj0Iopo9N2EhaA=;
	h=From:To:Cc:Subject:Date:From;
	b=Fi6NslZDcGFcA6szmD9BW62L6jBr7caBdv5/19qT6loSiPXhRNYecrgncg2LJvCjy
	 qE1DYT83jne7OvSFsGqRbLANyK+nWFHuL1Y/DttEzUvuJDlyJwmWPxQfpgcQLOXOzG
	 GhWoDObvuMBJ1o67QHQ3VKd2jMxbIg4yW2ndzbTpC6W/riXfBAgvvaaBSM8NOwNGRM
	 8npEj6U1toScPByPedDmLpwpFM7x9OQsUUc09HBJLc6wkudOiMjqDl1fVVKg+jy2Gy
	 xBuzx7kFcd8GE/fgbFusKPB11I2fd8HsKktq7HtT+YesnU0u+U4xyXBpSzEF5EzP7I
	 /k+UQeoFVN19A==
From: "Mario Limonciello (AMD)" <superm1@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc: John Allen <john.allen@amd.com>,
	"David S . Miller" <davem@davemloft.net>,
	Hans de Goede <hansg@kernel.org>,
	linux-crypto@vger.kernel.org (open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER),
	platform-driver-x86@vger.kernel.org (open list:AMD PMF DRIVER),
	Lars Francke <lars.francke@gmail.com>,
	Yijun Shen <Yijun.Shen@dell.com>,
	Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>
Subject: [PATCH v5 0/5] Fixes for PMF and CCP drivers after S4
Date: Sun, 11 Jan 2026 23:36:05 -0600
Message-ID: <20260112053610.2566943-1-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Lars Francke reported that the PMF driver fails to work afer S4 with:
  ccp 0000:c3:00.2: tee: command 0x5 timed out, disabling PSP

This is because there is a TA loaded to the TEE environment that
is lost during S4.  The TEE rings need to be reinitialized and the
TA needs to be reloaded.

This series adds those flows to the PMF and CCP drivers.

v4->v5:
 * Fix error return value in psp_restore()
 * Fix retry loop in tee_init_ring()

Mario Limonciello (AMD) (4):
  crypto: ccp - Declare PSP dead if PSP_CMD_TEE_RING_INIT fails
  crypto: ccp - Add an S4 restore flow
  crypto: ccp - Factor out ring destroy handling to a helper
  crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when PSP_CMD_TEE_RING_INIT
    fails

Shyam Sundar S K (1):
  platform/x86/amd/pmf: Prevent TEE errors after hibernate

 drivers/crypto/ccp/psp-dev.c          | 11 +++++
 drivers/crypto/ccp/sp-dev.h           |  2 +
 drivers/crypto/ccp/sp-pci.c           | 24 ++++++++++-
 drivers/crypto/ccp/tee-dev.c          | 56 ++++++++++++++++++------
 drivers/crypto/ccp/tee-dev.h          |  1 +
 drivers/platform/x86/amd/pmf/core.c   | 62 ++++++++++++++++++++++++++-
 drivers/platform/x86/amd/pmf/pmf.h    | 10 +++++
 drivers/platform/x86/amd/pmf/tee-if.c | 12 ++----
 include/linux/psp.h                   |  1 +
 9 files changed, 156 insertions(+), 23 deletions(-)

-- 
2.43.0

