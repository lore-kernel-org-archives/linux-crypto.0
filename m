Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D8128A3EF;
	Thu, 11 Dec 2025 21:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765488534; cv=none; b=Fn95sg5adazd6UxYEmR2RDActJNrGr9ks5Rul1AzV4uzkkUapdLtsjvMTbEQpXq43tCx7u9lfGokMLGnCYH2THNat+msMpo1rpce3YyFA8O4o5TBTEE+k2hRTXhdK5l/BeWttbnDvki/+8YWLXAtKFYuqxNd5MjrU0Zp3d0D3i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765488534; c=relaxed/simple;
	bh=BfmxHXrTLLvGXiDXvCazfC8W8nFpHW9Rlo98zD5ZWxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCl8bRlHUxS7yk+wED1SP8EaAgUZdyVnt0Z34xMAYbHryusZYZS1Y7UCHJyB+3tBBdL1nyfxIJ8s41TIaVmxY99Sw145KIcpgd/SPerkcLgA5ooptv5XN/4EoiOiZ2llbWumui5XnJ+pfhUYgFYSNhLOm0sFNQ1PXwYUZ81StJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K9iw/suV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K9iw/suV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58558C16AAE;
	Thu, 11 Dec 2025 21:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765488534;
	bh=BfmxHXrTLLvGXiDXvCazfC8W8nFpHW9Rlo98zD5ZWxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9iw/suVztebAT++IYRbuh5v72PuZtl4hqf467V2B7KK49hPIbdHLcWV2TyuDb2LZ
	 MtSC9IsP9oaHdWuXS380kpwm7QMIGHtAg0QkijHjHaP86Ge07aU59gGrRx00mB9h/9
	 N8mJBTbOfYvsrxbE9F92v0K6R/Pc0qB19xFrotJZU2yIpkHTcMBZjn6eyJy6GY12fs
	 EIpmfurYUa3gN59x2umU7IkXn/duk3Ug5ZE4sgAiwHUKMH+qQc2l4ycNnrfWU62CsB
	 QaXlHY/9VSiRn8ndTkF1HBYCer5HAUx9yV+8g5vItFsPMF1ELzc/7OcBbGY6BwzkXT
	 gsDfuJnVbMkbw==
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
Subject: [PATCH v2 2/4] crypto: ccp - Declare PSP dead if PSP_CMD_TEE_RING_INIT fails
Date: Thu, 11 Dec 2025 15:28:45 -0600
Message-ID: <20251211212847.11980-3-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251211212847.11980-1-superm1@kernel.org>
References: <20251211212847.11980-1-superm1@kernel.org>
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

Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
---
 drivers/crypto/ccp/tee-dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
index 5e1d80724678..af881daa5855 100644
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
2.51.2

