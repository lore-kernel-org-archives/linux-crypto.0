Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA2728A3EF;
	Thu, 11 Dec 2025 21:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765488532; cv=none; b=Yi3UnV2zDg9cvpIjmwkyDBRFINjWVnJXhiLWnw3bK5YXdz8nBpzTsimE5FEWDs+NIr1mY8fzkhrEVbA6wMGvQD9girJtUSckqAkJouACa59i32lgeVSdcJBesJR707cfMIieBQHLVaEaOsWfPOVoHDwTPZ7HVxTweuA0iTbSI0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765488532; c=relaxed/simple;
	bh=PyARrAzeTkmGVQbY5K6Zr6uXOneX9azX8mlSs06pY0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=afgLmJIMU80EGmjQmPi6RZyBVjawDvDN4brNIIa0pfsHv1CZdF/BNL706f8UeRMcNXUV5XWowNz5kIbMHHO8gzSzyiTGgU8x2RFTktc+ufwWakizWO3h1D+94mSQ9mAIhVF7Nix6YFANrJS8Y8EVHilEU5oE/rr9DjOmojZYYrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s7/Y9Umm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s7/Y9Umm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED3EC4CEF7;
	Thu, 11 Dec 2025 21:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765488531;
	bh=PyARrAzeTkmGVQbY5K6Zr6uXOneX9azX8mlSs06pY0Y=;
	h=From:To:Cc:Subject:Date:From;
	b=s7/Y9Umme4JgAqAhqqX/8M+k7YXNI+sJ5HYTUImrX+2Y3NbLVs1J5ARGT6ApGqwBJ
	 9J1wI3CudN8P02IdfJ8+X3viDgKU7SKbm7yhPxRsVTROg2pjoyK/VXcjVXKCUWQFxV
	 LyzgdhLy5kVW48uLhxAoPoqGdmJwPVB1rkFXkalCBRzSvXz+l/h1oIgroZKLv0Vt2l
	 gPJe58RwkSKUFsgKfF+dia5VYu7qqucQwe9Rk7KDIGVPfy2BG5C5MRNeKMzdQxV351
	 RY2bbhe+CGD14j5DOc+r/BYrdIhOs1y+nlUhByCEgijRwkl28VCw0gKP2zgEJcz6j4
	 0YBZsi0pWaSxA==
From: "Mario Limonciello (AMD)" <superm1@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: John Allen <john.allen@amd.com>,
	"David S . Miller" <davem@davemloft.net>,
	Hans de Goede <hansg@kernel.org>,
	linux-crypto@vger.kernel.org (open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER),
	platform-driver-x86@vger.kernel.org (open list:AMD PMF DRIVER),
	Lars Francke <lars.francke@gmail.com>,
	Mario Limonciello <superm1@kernel.org>
Subject: [PATCH v2 0/4] Fixes for PMF and CCP drivers after S4
Date: Thu, 11 Dec 2025 15:28:43 -0600
Message-ID: <20251211212847.11980-1-superm1@kernel.org>
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

---
v2:
 * Fixes for potential race conditions in hibernate resume
 * Fix for error handling if tee ring is never destroyed
 * Fixes for dead PSP (which can lead to hangs)
 * Fixes for LKP robot reported issues

Mario Limonciello (AMD) (3):
  crypto: ccp - Declare PSP dead if PSP_CMD_TEE_RING_INIT fails
  crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when PSP_CMD_TEE_RING_INIT
    fails
  crypto: ccp - Add an S4 restore flow

Shyam Sundar S K (1):
  platform/x86/amd/pmf: Prevent TEE errors after hibernate

 drivers/crypto/ccp/sp-dev.c           | 13 ++++++
 drivers/crypto/ccp/sp-dev.h           |  1 +
 drivers/crypto/ccp/sp-pci.c           | 16 ++++++-
 drivers/crypto/ccp/tee-dev.c          | 17 ++++++++
 drivers/crypto/ccp/tee-dev.h          |  6 +++
 drivers/platform/x86/amd/pmf/core.c   | 62 ++++++++++++++++++++++++++-
 drivers/platform/x86/amd/pmf/pmf.h    | 10 +++++
 drivers/platform/x86/amd/pmf/tee-if.c | 12 ++----
 8 files changed, 126 insertions(+), 11 deletions(-)

-- 
2.51.2

