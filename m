Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361BA17334F
	for <linux-crypto@vger.kernel.org>; Wed,  3 Jul 2024 12:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720011011; cv=none; b=PmE2OyZ0fOn5U8hnNqv+KSRmJXgi2YNtu3ubAuncdK6YHHeyyJPkE1Oljr7rBgAUe/qJh0D9q5/vHymZR5s11t66KAsXnqkylKFLRonEhwSvJgLgdg0Ug9BQfubAI+Fqut2wR5syw6bQ2jday6V+i0utPUQIetlPhgeWYRGkw9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720011011; c=relaxed/simple;
	bh=TndIeG9G6FrdR/rn55DgwdEEotMupyiOMfJyv1C7ABM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=re4OaQ0fVqc66KkWogXKRlWu6KWdpdquR6sEwoatwph1pkapeQnLggjwK7R83rn3pgxYotw1YeGljMalLJDXRwv88RBCnTmCX6sD66rMyqBSqfpA72m24/d+Zm8ewmn0A0gMNnBBs53mXu35Aw7l2+Eofn+CwuTl5zaHvCfmtIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at; spf=pass smtp.mailfrom=sigma-star.at; dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b=uh4RLSLM; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b="uh4RLSLM"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-52d259dbe3cso5522774e87.0
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jul 2024 05:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1720011007; x=1720615807; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RmBlGZ7JugDA6yCRv+tI74EPUOAWuL4mr31Z/ZqddMo=;
        b=uh4RLSLMkLUZb38cEz7FXZZYBgPP2DP2hWpMstl9PZ6xMO9AtOo4cADN1DRVbS1rAh
         apR68pR9MUV6c+jci7iSyHGpYUYarSBoGF8vOTh0EOZe6UhAtzU+u2gG9x/Dr02u4wH/
         VFw//liUiuckO9NEXwereCQUQnWUbm3z0chV6hs4QBiLiMkGdlMeTAC1bfmGoJCseEUA
         S5badRyA99f35rLbFJYWQpBo/oT3HRfIgnA46gAQmZwQWjU8iis0LNn5ZMSvo23cLMUe
         VS2Q4yeZEsvw7nH3wAkKYRi+PIdvhVLktdgmikhfqIV80SFjzPJClbmXu6lq97pb2YVA
         Q0ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720011007; x=1720615807;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RmBlGZ7JugDA6yCRv+tI74EPUOAWuL4mr31Z/ZqddMo=;
        b=wd/DMcSTNLj63Kp1VZoVGBxpWgcmj5YRXQBjYgksBB9YqHuZ2wVHFVNrSwJkuP5rmh
         50eOwrTTMYU+zK3FVBfPVQnpp43OPbkWOK8oEIytdNCd+Fa9UPpx/a3hP3FK4CBxz97N
         n4cbAz7yd/LZlnmiuHloFcnVnsmbFjwc+T12q9ng9U0Xstnjji2mJWILSohCeDBrJQ8M
         7EReFTPaX+2J8gCQOfMgLP6cpo8MHDemJkmyPlfH89aRMFuZuWZBh5aEOMJ4Mf1N9Yix
         BLZLyCWTOBbXxTeZVKgx+7vVd7p0sDaLm9c8kHfxybuiDLVkjV3TKgR6ta2qbH3fuPjF
         kHlg==
X-Forwarded-Encrypted: i=1; AJvYcCVctzOZ4sOkvjS/yc3J02VAgHO6ykySLm/TU0FoxOf+0MIwwm4sr3iDCMmShxHIaRT6xwS9wAGzcQKL+L2eplZxZp+cP6CInCK5k/mr
X-Gm-Message-State: AOJu0YwjpwZq8pAZE18ZNga9fggW+JPYvr4Lc8AoglPq7yGgghU61sZf
	kUDVjU3cZy7QtzNxSzjsCq4YkNoBghqDI15dx/G7ITqJr7KI/Bm9UG2uhOocA9Y=
X-Google-Smtp-Source: AGHT+IHlez9j3K0WoeC3XHS+M7qci4/FmMVRo4FxFL3Nd1FA6LeH36IAKdcQ67uBJOsYRMIHSlMkyw==
X-Received: by 2002:a05:6512:b11:b0:52c:7f12:61d1 with SMTP id 2adb3069b0e04-52e82643bdemr8858443e87.1.1720011006993;
        Wed, 03 Jul 2024 05:50:06 -0700 (PDT)
Received: from localhost ([82.150.214.1])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4256b0971d2sm236399635e9.31.2024.07.03.05.50.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jul 2024 05:50:06 -0700 (PDT)
From: David Gstir <david@sigma-star.at>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	David Oberhollenzer <david.oberhollenzer@sigma-star.at>,
	Richard Weinberger <richard@nod.at>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>,
	linux-crypto@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	sigma star Kernel Team <upstream+dcp@sigma-star.at>,
	David Gstir <david@sigma-star.at>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] crypto: mxs-dcp: Ensure payload is zero when using key slot
Date: Wed,  3 Jul 2024 14:49:58 +0200
Message-ID: <20240703124958.45898-1-david@sigma-star.at>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We could leak stack memory through the payload field when running
AES with a key from one of the hardware's key slots. Fix this by
ensuring the payload field is set to 0 in such cases.

This does not affect the common use case when the key is supplied
from main memory via the descriptor payload.

Signed-off-by: David Gstir <david@sigma-star.at>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202405270146.Y9tPoil8-lkp@intel.com/
Fixes: 3d16af0b4cfa ("crypto: mxs-dcp: Add support for hardware-bound keys")
---
 drivers/crypto/mxs-dcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 057d73c370b7..c82775dbb557 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -225,7 +225,8 @@ static int mxs_dcp_start_dma(struct dcp_async_ctx *actx)
 static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
 			   struct skcipher_request *req, int init)
 {
-	dma_addr_t key_phys, src_phys, dst_phys;
+	dma_addr_t key_phys = 0;
+	dma_addr_t src_phys, dst_phys;
 	struct dcp *sdcp = global_sdcp;
 	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
 	struct dcp_aes_req_ctx *rctx = skcipher_request_ctx(req);
-- 
2.35.3

