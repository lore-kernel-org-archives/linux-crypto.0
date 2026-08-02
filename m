Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4BA25B090
	for <linux-crypto@vger.kernel.org>; Sun,  2 Aug 2026 22:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785709391; cv=none; b=VjGfuaButntWqA94mxDFx7o7RSePUQmb0kQ3ZCbkwAxqSZq1JSHpMDpe3KBAAY26ypMu7BgidR85ZmyLomw9IJdJfAcmNdW2emv7HDjwZ7iVX+XsKA3m6Z/Fc+l8XgA9IPFVjj+QvLzmWo7ce+2i1wsTX9joi/+/orkguX2YKDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785709391; c=relaxed/simple;
	bh=k/PWOQgo1p4Yp1h5/yZGB51G2UQvJK1mFc6oQmkpaxM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bWzKOtwFcUEGE7/hWCPyswz3gFbfo1mBgQGI+5Mw9pLYiAhwj2AVCH9PDh5tiQ7aYPoi3/Dr5ZG/aJigK2ItqQ7LxQi6Zs3dtUx+xLNwI1WIUb30xHTfOn/FuRQN1Vnr69AackJ0IRGJ6RvWFwt065Bn/hOdV5qCmqg29zbjiik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sRfACfKi; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sRfACfKi"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c2a818fc4so16210031cf.2
        for <linux-crypto@vger.kernel.org>; Sun, 02 Aug 2026 15:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785709389; x=1786314189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=K+YpikDeGg3PaK1+XecbhoXs6xNS16wdVuw+OggeHyc=;
        b=sRfACfKiKm7bcvKniB6pPlh1WSURAQoXATW8CfMD3ns4FoGgtO4yppEJx2SUIkBBmO
         ho5zdGccfBz1jkM1ss698f6nRgDM8mhpjzIgC7Sa1j00oBVDlfnzSWeo8UKDMSyXVlOe
         u7i7X4VfX0+QIi2SaAv8PlEVNCIBLw4gzJmLTQpaPN8I/4eqfj+CidYDLimEJj5YdrJI
         dfhJI4BppFDGCdKT7LVDR2SDvfaO8PJxtmVfMh0wIuJkYqKsgD+w+MHwnb3HG0BXxDuc
         fuxgd1f9lriNvRDYaxKiWb3orEpEphCdnQ1Reis1gaFmeOm2dL7G2+3G4mG2rJ/gjSxJ
         0SUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785709389; x=1786314189;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K+YpikDeGg3PaK1+XecbhoXs6xNS16wdVuw+OggeHyc=;
        b=RMaKRJzcSq2MKFcKOO5QDHYWgGtMqstHYmP4p9uIPPyQKCIkAussBKiavcW3mJ0rhM
         f5wdOu25Kg3dvr8QR0DoDYDRl6yS1AFr1N06Hoaoyb1dYY9pdpBCj4hFaG24h3Tm0GW1
         kaMpdRqTGxgcGPw64kDoXzjZ8jj8A9oarKCA+ew+JP3mB20ULtg0oAygL+M5+O25MEZo
         vx/xhObEkzfC6gMtbsXqOMRWri9Z9u8PAXECkZjpTfApjZfIfmcLx+Z+L7udc+h9pgmW
         +IibRf2axuHezkYrQw86vMYUQjcoiht3GiS57lZH44n8bHOyar7/xHn35HbtGenJ1tMk
         absg==
X-Forwarded-Encrypted: i=1; AHgh+RrJMyTRgFc6KenWRAALbyc0i1MmmEIMPttGXTDrDTrVACkJyUpvnjEY3bH9WaLLlORsKBXUXWVx66g0noc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyuw4i8meWGIqZ0Gimg5L4W00sSHaBkUikfM8qfi0sLGbUwh7MA
	OahLKmWc2uuPFRkYq2/fPfjBfmaVqmwEtR4SDo+a6mEROlkDAh5uIWZnpicdIoPlDK0=
X-Gm-Gg: AR+sD10h8htUz+5T+1BU6pOqlAf737BHkhh3OFm9jMizqy03QmB9FXvIjQCzbZUiC7d
	DJmi+4LDKoMcV3jtHmgTpo6I+ExqiVf7IXpJEcz7jcOj1EZKE0ePeFieLoLQWlXIc6qMy0vx9gr
	Ic4f4GjKuDf7GqBVdNtqzi8/wEaKDf2ClV3JHwmUOJOQCgaBnD74hpUcswYpwzJb2YeuZkPUo9C
	gmU0+kjs8OomaERsPxo/odUsg/aJpC73YBy/huaZ6ULA2Mf2UnmbfbgfLy08BsJxgDKIaG/cN2l
	XZ3nPRVIhWlFrDHzSQJuVbk5j99+jY+L09O2xLL+EPGzdFBQhsEdhL+A1fN2POXNmuU/ul/cmJf
	K2agAcgMPBpT7fco0kO0frvXxtcI4lRv39kVH7IQbhPFliwXEHjnZy5zWHWzM4v4rUjghl4gKa1
	ixLFQqkzhMVmwwttypSw9+gW9U6ShtDx8CV1ttoMsfylLYOIH5nGw4upcvNoug+6VDe+tGsiugf
	pLwEMptTBLuqInCs55NODmCJE06Ka4kPe32nL4VBhdhyM+R8aCrcgsfa47OWTw=
X-Received: by 2002:a05:622a:2612:b0:517:642c:8196 with SMTP id d75a77b69052e-52b566db0admr173984281cf.12.1785709389063;
        Sun, 02 Aug 2026 15:23:09 -0700 (PDT)
Received: from i4-gl-tmk5904.ad.psu.edu ([130.203.156.186])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908434a250csm61249026d6.13.2026.08.02.15.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 15:23:08 -0700 (PDT)
From: Yuho Choi <dbgh9129@gmail.com>
To: olivia@selenic.com,
	herbert@gondor.apana.org.au,
	Frank.Li@nxp.com,
	s.hauer@pengutronix.de
Cc: kernel@pengutronix.de,
	festevam@gmail.com,
	linux-crypto@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	dakr@kernel.org,
	o-takashi@sakamocchi.jp,
	bhelgaas@google.com,
	Yuho Choi <dbgh9129@gmail.com>
Subject: [PATCH v1] hwrng: imx-rngc: Disable clock on registration failure
Date: Sun,  2 Aug 2026 18:22:59 -0400
Message-ID: <20260802222259.577200-1-dbgh9129@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RNGC clock is enabled manually before runtime PM is configured. If
devm_hwrng_register() fails, probe returns without disabling the clock.
The devm_pm_runtime_enable() cleanup only disables runtime PM and does not
call imx_rngc_suspend().

Disable the clock before returning from this failure path.

Fixes: 7a96a64e8689 ("hwrng: imx-rngc - add runtime pm")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
---
 drivers/char/hw_random/imx-rngc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
index 28c56c2d1bf6..a2db26d7f790 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -313,8 +313,10 @@ static int __init imx_rngc_probe(struct platform_device *pdev)
 	devm_pm_runtime_enable(&pdev->dev);
 
 	ret = devm_hwrng_register(&pdev->dev, &rngc->rng);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(rngc->clk);
 		return dev_err_probe(&pdev->dev, ret, "hwrng registration failed\n");
+	}
 
 	dev_info(&pdev->dev,
 		"Freescale RNG%c registered (HW revision %d.%02d)\n",
-- 
2.43.0

