Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11662165F1A;
	Sun, 14 Dec 2025 19:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765739546; cv=none; b=nPQNO8g9LFUy6ofT3Uf9WG9qjQQOsEqXHkNHlJVAh5QkSDcMzsZYUbXhPWj8lfmQxqkejnZRsxOIqogXVs49zWvgDOo+FSG/zOXhwq6yo3GCLZmH0k7eXJX4dAuVJd6ynEqgVH20GFo5i4ixfbBuk3Bf5PwNHXM28hMm+YYoM6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765739546; c=relaxed/simple;
	bh=IAQzh06sRwdhM/8acTHpVp3L7m1ZytIqQlZV5dp3Nng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyEM5UtWYAAQDHHnX8kYirUp0Uc+qAWbnv0Op9+6KQcfTPhbQI3qQPzWhYVvE68OXPCSewmAqFVioXC9nd875x4spjk22CeN9d151Auea5Zexyb1jG3sgiDGmdYpy3VOZieWVbWPabOGwveBIVWJgvt+5cdP9vB4pAbhOXAuXtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V5TD9IMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V5TD9IMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E8CC4CEF1;
	Sun, 14 Dec 2025 19:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765739545;
	bh=IAQzh06sRwdhM/8acTHpVp3L7m1ZytIqQlZV5dp3Nng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5TD9IMo1pbenerhd5Ef66LRq0KOM/Y0wPpuMBrnTtjZBHjDkpjMXnT5hQa2Gvdg3
	 vtX5lcx/b9lKtdWpDg7IDRXDXkrgz2DG380EH0xyzD4BsPtfOr6H1sOUSw+3mI5R5S
	 DF5jqs+kaRvzt7asXKMDp5KZ1HO6/ynhTRlHRLDFImUh3Tjic0mXBJuJbjUsjA+G6h
	 3h4tQlBBgbzlVy3iYp9nkfOMWARi40g1pRLUze2sQPkHyvLTWEPw+Zl9+1fMRdXhem
	 nDkAmsoa/ox4pKjZvMHg/RSQo91sDn/tVMwtKpSB3XD3PGZtXR8pWHCWsBUMU71nBH
	 uo79Va2o++KtA==
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
Subject: [PATCH v3 2/5] crypto: ccp - Declare PSP dead if PSP_CMD_TEE_RING_INIT fails
Date: Sun, 14 Dec 2025 13:12:10 -0600
Message-ID: <20251214191213.154021-3-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251214191213.154021-1-superm1@kernel.org>
References: <20251214191213.154021-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tee_init_ring() only declares PSP dead if the command times out.
If there is any other failure it is still considered fatal though.
Set psp_dead for other failures as well.

Fixes: 949a0c8dd3c2 ("crypto: ccp - Move direct access to some PSP registers out of TEE")
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
---
 drivers/crypto/ccp/tee-dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 5e1d80724678d..af881daa5855b 100644
--- a/drivers/crypto/ccp/tee-dev.c
+++ b/drivers/crypto/ccp/tee-dev.c
@@ -125,6 +125,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
 		dev_err(tee->dev, "tee: ring init command failed (%#010lx)\n",
 			FIELD_GET(PSP_CMDRESP_STS, reg));
 		tee_free_ring(tee);
+		psp_dead = true;
 		ret = -EIO;
 	}
 
-- 
2.43.0

