Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BF51B4244;
	Tue,  6 Jan 2026 04:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767675282; cv=none; b=ZGVLnFzPuWTBqBu4ecgkBo/eHth+p3WZsbcjhHOZbiG1USx7mSwbt3JbthMFQWWtRYM8FK+3bNZjyLAjWtf0EEKwYlnW0Q8y4aWwAMsf+8D+92OIJMytfV2xJ+4MBBIwxl8A9GCQ8EFz+Fbyr2yc1B6FYiM7ZTw3NbYGUDXWcKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767675282; c=relaxed/simple;
	bh=NUp1BqF5K1T32b9heXyb92Y9SNKgE8RV9k8D4IlBt+0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bm0k74pO3b+HQnUdTBrz6ER2DklWI/noh0pXx4vhy5rLsl2F74krGp+Cv2BL137eO/80KZXQ0/YIEXGbxjw9bA/O2MfqhuktPGSecKPIRwxlEH2MWXZKM0LmeZmL6MvPFwW+jCx0poBCSWrnzN226D88FzDzg4P3FLYFrWHM3jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S0gp7TXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S0gp7TXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54406C116C6;
	Tue,  6 Jan 2026 04:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767675281;
	bh=NUp1BqF5K1T32b9heXyb92Y9SNKgE8RV9k8D4IlBt+0=;
	h=From:To:Cc:Subject:Date:From;
	b=S0gp7TXz7fQJSb4yWro0RMVV7jWNBpWr85BoqpE93/k7HWQyC2FtNEDPhyOuHSAqY
	 LtsY9jMygcq5kjPualPx+8pPnnQHrwF29R6rpwYtAQKb+GFZXyXqj1FJCP+GFzkq7Q
	 iBZWDE8P6sAqv5HNY1tfmTMEbbwC5ir2GvgQwRxrLZIptVy1dEfKPa6eXMEK5dNlJp
	 XrNXEO1i1E22AJYBriof2Zk+T1SnUbN4Zoz7c4heZKL4HSE9kzyhcVIR3QuaFCqAo0
	 UrctpW5LIStgeRCAfdYsQQRJNKtqsWTT/Ca/CbM1GVxznNlVMThjnoAG0GShu5xC8i
	 YhlXJ1O22G3qA==
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
Subject: [PATCH v4 0/5] Fixes for PMF and CCP drivers after S4
Date: Mon,  5 Jan 2026 22:54:18 -0600
Message-ID: <20260106045423.55190-1-superm1@kernel.org>
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

 drivers/crypto/ccp/psp-dev.c          | 11 +++++
 drivers/crypto/ccp/sp-dev.h           |  2 +
 drivers/crypto/ccp/sp-pci.c           | 24 ++++++++++-
 drivers/crypto/ccp/tee-dev.c          | 54 +++++++++++++++++------
 drivers/crypto/ccp/tee-dev.h          |  1 +
 drivers/platform/x86/amd/pmf/core.c   | 62 ++++++++++++++++++++++++++-
 drivers/platform/x86/amd/pmf/pmf.h    | 10 +++++
 drivers/platform/x86/amd/pmf/tee-if.c | 12 ++----
 include/linux/psp.h                   |  1 +
 9 files changed, 154 insertions(+), 23 deletions(-)

-- 
2.43.0

