Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD355165F1A;
	Sun, 14 Dec 2025 19:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765739543; cv=none; b=H5Dvaia8EImqMI5lzzicfEu5UEgux2UvbtknSilBqSzsgADiCCKH5Z1n6jracT9tPdL8Sw9c6vdy2TszBxnb7GBx1kO8YyTPgTjQZ1ZoGGVgrPzrU0lxnLja7FmTkyJcKCikcyqW6fuD+Uv5eOfJT6rydD6f61p0EKT66S9CUN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765739543; c=relaxed/simple;
	bh=r5igGSgMWDPKabel7aAz5KoMsvL/mHphrFIf5hcM+rs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EqUYrtOvKodoep8KdQKjx/vG1zpucEHRJh+luB2Sk8xpmwicT8vOX5S/JDivIlwBqqa+PGwl7lzwVix+ihmkdTEOSbUcA6oj8iwrvajsLpzXZ07CWGVdp/zezxT+6wAW9bOgyc2KFb2UKdJpddWWlWkvsV0Ck8D+2sspMnMq/1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gPJge65/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gPJge65/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4164EC4CEF1;
	Sun, 14 Dec 2025 19:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765739542;
	bh=r5igGSgMWDPKabel7aAz5KoMsvL/mHphrFIf5hcM+rs=;
	h=From:To:Cc:Subject:Date:From;
	b=gPJge65/uJ5ZPl9ibr4B4TtAVpZ/6qMvJNL59K+M1aDL2fO9VAyiYXYxiHRZB7WTj
	 qGpDFkEpWaNDELmI/9vcxwk5KmMxsYEDDeKogT4DnJhTyjgUZ8Lb+oX+owtcOs3cL9
	 b7KggEHuSw+91xHpE4v14AyJWnA7ySmE2GdBVInbkec56t101hWl4DrUampXwqXbRD
	 PojQZOqMwVgI2Xld9iI6a7+1E20+AaoiZVZKBuw5JHhpwxT21X1bWTxntkxTSxTj/j
	 L05AG0Wb8maTrk8GuIKVAPKu2tn06ulz0Ar+1FzDQX7FXlj5+MXSx0J5Ee0OPu66Hp
	 9RQNwR9gtb3Zw==
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
	"Mario Limonciello (AMD)" <superm1@kernel.org>
Subject: [PATCH v3 0/5] Fixes for PMF and CCP drivers after S4
Date: Sun, 14 Dec 2025 13:12:08 -0600
Message-ID: <20251214191213.154021-1-superm1@kernel.org>
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

Mario Limonciello (AMD) (4):
  crypto: ccp - Declare PSP dead if PSP_CMD_TEE_RING_INIT fails
  crypto: ccp - Add an S4 restore flow
  crypto: ccp - Factor out ring destroy handling to a helper
  crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when PSP_CMD_TEE_RING_INIT
    fails

Shyam Sundar S K (1):
  platform/x86/amd/pmf: Prevent TEE errors after hibernate

 drivers/crypto/ccp/psp-dev.c          | 15 +++++++
 drivers/crypto/ccp/sp-dev.h           |  2 +
 drivers/crypto/ccp/sp-pci.c           | 24 ++++++++++-
 drivers/crypto/ccp/tee-dev.c          | 54 +++++++++++++++++------
 drivers/crypto/ccp/tee-dev.h          |  1 +
 drivers/platform/x86/amd/pmf/core.c   | 62 ++++++++++++++++++++++++++-
 drivers/platform/x86/amd/pmf/pmf.h    | 10 +++++
 drivers/platform/x86/amd/pmf/tee-if.c | 12 ++----
 include/linux/psp.h                   |  2 +
 9 files changed, 159 insertions(+), 23 deletions(-)

-- 
2.43.0

