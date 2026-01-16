Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9276020C00C;
	Fri, 16 Jan 2026 04:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768536701; cv=none; b=g2sTDG46YykG81q40tziV0jy1dGxTQ/fMj7XDNk6IvE0LMZHEhqOE8zu0yi9/rbaOtDd4sTqXiYmVphNzGwUyUH06t4XLnaG6x62RL51UXRWN8/6dbVCmB7rpc0dlFhhgs9L18RZ5UCI2mNcK951HM/omZMrOSHWmu7rZKSjNAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768536701; c=relaxed/simple;
	bh=ZqnRJGrpiH1f2hzAoTldvi9iPJA9v+Ll4EkFKq/32ac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HNhz1PtP+DK8LYAuYPPcnx10m2uieH2f0YIKmIVV+W3G/J9+H/0P1koNh07RMbgMYDG7YPNoiEJQiZPk3KqlOYf4zqD+iEF5gChZGY3ECdqNZF2pVG/glRTawmpkramWpD3PeZugvVDPDomPT4EDgYykzN9NZtAerLggSbXwiPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dgrn5XY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dgrn5XY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBB0C116C6;
	Fri, 16 Jan 2026 04:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768536701;
	bh=ZqnRJGrpiH1f2hzAoTldvi9iPJA9v+Ll4EkFKq/32ac=;
	h=From:To:Cc:Subject:Date:From;
	b=dgrn5XY+GgiO4sogvXtY4C9vx+1VpdFDLlh3ZQsBzxIsvL+LW0MG91RUKNsBPn8qB
	 OIj3hi/Q0+Lg4LsKupBQ8rtNDuXGSJ77UDCyFEKAVduTlIFa6cfucLDJzqmCrQYyFj
	 ynRFxahHbecpvCaN7lACUq5PTc+pitm5msYv1bDFHu71dOeUQlaotpWNNDGTwm/GbG
	 OXe6bvyiFSHIo6E89SBgFTxcJ2l2a1ilzqFbGe9v1cIrduBBieEL9fYnYoDLsCtqR1
	 GmBvxbW1sMKfXeh3Zo+SkfHXv5KqnRnb2C3TGK5p/bBiZEh19r4iZErqL1Sa4nvX/j
	 0BoSOKXiqphtQ==
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
Subject: [PATCH v6 0/5] Fixes for PMF and CCP drivers after S4
Date: Thu, 15 Jan 2026 22:11:27 -0600
Message-ID: <20260116041132.153674-1-superm1@kernel.org>
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

v5->v6:
 * Fix Tom's feedback on patch 3/5

Mario Limonciello (AMD) (4):
  crypto: ccp - Declare PSP dead if PSP_CMD_TEE_RING_INIT fails
  crypto: ccp - Add an S4 restore flow
  crypto: ccp - Factor out ring destroy handling to a helper
  crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when PSP_CMD_TEE_RING_INIT
    fails

Shyam Sundar S K (1):
  platform/x86/amd/pmf: Prevent TEE errors after hibernate

 drivers/crypto/ccp/psp-dev.c          | 11 +++++
 drivers/crypto/ccp/sp-dev.c           | 12 ++++++
 drivers/crypto/ccp/sp-dev.h           |  3 ++
 drivers/crypto/ccp/sp-pci.c           | 16 ++++++-
 drivers/crypto/ccp/tee-dev.c          | 56 ++++++++++++++++++------
 drivers/crypto/ccp/tee-dev.h          |  1 +
 drivers/platform/x86/amd/pmf/core.c   | 62 ++++++++++++++++++++++++++-
 drivers/platform/x86/amd/pmf/pmf.h    | 10 +++++
 drivers/platform/x86/amd/pmf/tee-if.c | 12 ++----
 include/linux/psp.h                   |  1 +
 10 files changed, 161 insertions(+), 23 deletions(-)

-- 
2.43.0

