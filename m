Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62C9372AAE;
	Wed, 19 Nov 2025 20:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763585992; cv=none; b=jHCPya0221J965AuIgIJHEUsHhRAUFpb66r6bu/VAQdCG+UX8LL9UtZLapA4VfTHbk2pm5xCUSJnSf2W7/T2oQNruFb1td6Wo3XzWLbbEaVibKzsjEP6J49L26eFkRQL8Lc+eLcVSSSNvBu+DbY1tF26EVO2KnykT/xcICtDeIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763585992; c=relaxed/simple;
	bh=a+xAmjMW/FZQJF/Qo9/dEFUK1+W3RtZLD+iGETemTJw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m34o15wUjlexNrOROpVFl/eRiiQ6eDZSw9oKygAT+uJZq/ciTYoyvoeDuL1P4nHaySo9pdspPo6uH9UF0fvwsBZLvKrR7qExavi1MVhxdL/1yAKs1hNJhiOyS9kgadVWIMnbpyXm1vfBuXSoPC0f8lrv0oU7HQbdPVwSNyB4MGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G1UcVEJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G1UcVEJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6054AC4CEF5;
	Wed, 19 Nov 2025 20:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763585992;
	bh=a+xAmjMW/FZQJF/Qo9/dEFUK1+W3RtZLD+iGETemTJw=;
	h=From:To:Cc:Subject:Date:From;
	b=G1UcVEJAtoCbWvltGxZOVh+Bh4MBAODy8av/4GWZppmEjmNEAVzx0p2z01yxBCjEw
	 eMqaLeq2BfjXmhBSKSbbUWwJOEG5HJNUF6gYn3T7BN4z2gPUUPFl3o6Cw3TC7xOQXo
	 Xr2TToP2f8VEm1X9SiYAQ06FUSD7aZpR9aABfVn2PtMjShG92lHlfWTd3XTGcfKq/y
	 rrwCAGVNuZTQfzyBqa60mAT9DZLSfsIIDAhyQht//Dgqy/mmnqQhUcrlLvUZvr/Pe7
	 P/3HOsmrX0id+Nu2o0D10fBI9dwsmFxbUiOXQRKOZQTN0bsTwf2EVjSL6NPPSKZHBC
	 mpDJ6ysGoZLoA==
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
	"Mario Limonciello (AMD)" <superm1@kernel.org>
Subject: [PATCH 0/2] Fixes for PMF driver after S4
Date: Wed, 19 Nov 2025 14:59:40 -0600
Message-ID: <20251119205942.3411155-1-superm1@kernel.org>
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

This series adds those flows.

Note:
I validated this on top of 6.18-rc6.  I could reproduce Lars'
original issue on a Strix laptop and then confirmed that after
applying these two patches that PMF continues to work after resume.
I ran a handful of S4 cycles, module unload tests and reboot tests.

Mario Limonciello (AMD) (1):
  crypto: ccp - Add an S4 restore flow

Shyam Sundar S K (1):
  platform/x86/amd/pmf: Prevent TEE errors after hibernate

 drivers/crypto/ccp/sp-dev.c           | 13 ++++++
 drivers/crypto/ccp/sp-dev.h           |  1 +
 drivers/crypto/ccp/sp-pci.c           | 16 ++++++-
 drivers/crypto/ccp/tee-dev.c          |  6 +++
 drivers/crypto/ccp/tee-dev.h          |  1 +
 drivers/platform/x86/amd/pmf/core.c   | 62 ++++++++++++++++++++++++++-
 drivers/platform/x86/amd/pmf/pmf.h    | 10 +++++
 drivers/platform/x86/amd/pmf/tee-if.c | 12 ++----
 8 files changed, 110 insertions(+), 11 deletions(-)

-- 
2.43.0

