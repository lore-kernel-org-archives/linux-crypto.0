Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0581130EF89;
	Mon, 12 Jan 2026 05:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768196215; cv=none; b=FBbopzJbmofgXrFeA3wHrtZ9QNrOgCi3ziKUYkbw20o0VtaTmR+jhCcRFH7Inxt2sfThpt+tTpx++MIcPmqiABhy1IFWt+Kt6V37J59lqCx0WtRwwNfL8uACArwvl9e1rsrVteyJjg+HBETsbSeNnR/A24AxqeFt2ZbljpZURmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768196215; c=relaxed/simple;
	bh=UAJDt1T0vlGNz7HkqWbQxAw04DbXVh7U2RF0Gsjr5vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEQkfF2p1TJNcNl/Q+YsNB30RpdvBcQWe4330i70OMbe6H5Jl2BqcLPCdZbbd4vd3PtH6kmlcP90P+FCigSupvfFKD6d/2jRnjBrkLt66fLDfX5chilOtI8uGYfa2ppkjwI44nb60aYfnaPX1kMzSH+8zb67IfU+ekhDW9PRUso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SfX4edku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SfX4edku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA95DC19422;
	Mon, 12 Jan 2026 05:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768196214;
	bh=UAJDt1T0vlGNz7HkqWbQxAw04DbXVh7U2RF0Gsjr5vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SfX4edku6Wj/5YH0s6kbTMlk3ixDcLmxbwa6OJhr0u4fdWqBAudV7llURxpzDlil9
	 3FptKzepGXyOlH+y97jCnDFj2RzYjdtepDfdlW+TbYYVGHOzyyP0okT1TTLhdtxlWf
	 mdrQ3Xe9fnTjyLNaFDeE4h2Vu/1hGn6uIWD3GWiu/uejbmHLYX/phHp2NJMR+B6SYp
	 TS/3qeBwzw91fNM2gHKJXckE+MjPHD39F3LlPwqWAQ/193K9WrG6lxwpyKHzmXl4xz
	 THfzrrcfnE3vNicfQPmsLw2o3H4QTeNkK9RYe+0m0F60zIlSbpqBlXh3/L+w+UOhG1
	 xjKZ+bkR1PvDw==
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
Subject: [PATCH v5 2/5] crypto: ccp - Declare PSP dead if PSP_CMD_TEE_RING_INIT fails
Date: Sun, 11 Jan 2026 23:36:07 -0600
Message-ID: <20260112053610.2566943-3-superm1@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260112053610.2566943-1-superm1@kernel.org>
References: <20260112053610.2566943-1-superm1@kernel.org>
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

