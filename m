Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2647B20C00C;
	Fri, 16 Jan 2026 04:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768536705; cv=none; b=OUhHWJ7tYsIWiDFGZ4XtGqrx3dDWz+i/MW+e0Zul9Aab7pgXy/mxJ7/88kniNquik1l12Ry52+Ew21Ti78+CRiF10lE0isHU3VI+9iJXSrsxceYunKVbfXhkclhabb2A4sxkF/Rtnc+SbYllNauuVsPx5PwuqR5GHtUOF/nM+XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768536705; c=relaxed/simple;
	bh=UAJDt1T0vlGNz7HkqWbQxAw04DbXVh7U2RF0Gsjr5vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlcuysbyaK5s+3OHdusT8wvXnovL0jGdUogri+DHNg6LGv2fBMMUY6ea6ahqydwef/72xwhpSCp2XAFzD7YJyXN78sIjfekdqP+qqsMZcEGxHBnNrOXchRsTkt44qvvmuH3m4ILe2qOfoL9xty+8aAS871xsT2ryrtuKTbG6zWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jbKVgMUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jbKVgMUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65CEEC116C6;
	Fri, 16 Jan 2026 04:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768536704;
	bh=UAJDt1T0vlGNz7HkqWbQxAw04DbXVh7U2RF0Gsjr5vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbKVgMUFHLUbpQ7++TDP426KVooOIP6YK/g3KYO83qp6zfJXIxzZeF7826YCyoGU7
	 V9EJNEXyrIVVWFrs9eVmDgm+dk6RDDHq5qJCjPPQwO5OBh7YWehhJmz/M4fhX4DlB9
	 BSwn+nauqn9FGxEh3fBjq7NQBeFTp+EgWi58Du1oR4vj8ZwodyWXO9tNI3kHMYUCWB
	 dd+ZjKjSOAzd6JnEpAiq4BCS4nft3lvSHH2yA+fbypi64JoWBgFm5bQkkmefJN/DfJ
	 NV22gNfuEQ7sZ2PmEiVDsPZ9HXNmtNmyCs00h2YOxyeWXPX5w/aGYKG8nkHN+TQB22
	 c4GzVBICV7ZMg==
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
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Yijun Shen <Yijun.Shen@Dell.com>
Subject: [PATCH v6 2/5] crypto: ccp - Declare PSP dead if PSP_CMD_TEE_RING_INIT fails
Date: Thu, 15 Jan 2026 22:11:29 -0600
Message-ID: <20260116041132.153674-3-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260116041132.153674-1-superm1@kernel.org>
References: <20260116041132.153674-1-superm1@kernel.org>
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
Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
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

