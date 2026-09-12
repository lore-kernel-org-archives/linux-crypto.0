Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D670A35C6A7
	for <linux-crypto@vger.kernel.org>; Sat, 12 Sep 2026 14:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224093; cv=none; b=aCZLV6pu2627FD+Socv123Q8oSTf75H8Q+xyBqZC43HNnq0qpVPN3AxJ3O7DarXW4XE5j9Xc+83k6WOrIBModu0ugX1uSCENto2RgtOWux533P+F2xPGaKlJMlEUWWkGhrc7lOsbOos0d77WqpsiK2373ifhsUfhhsWg7nrLskI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224093; c=relaxed/simple;
	bh=jJUwvssp7BgAozkd0V89n4c6un4uRRFWxtfNl6AYC6g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uz39yM2/TgT52TGLMa1uep79IWa24T2pjwBrZLz1cXXNjDVZHrUF9S4mejvZrddVmoUeNhJy8QLzIiHupE1Y/oIsRj85ObJbWd1XFI8ECIMMSjtT7asYN1+fe2yW3a9xl3Nokzjm75YOrqzh9OjO1wWrRlNj3rDx8TlUsOum2Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nQ/rLwO4; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nQ/rLwO4"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccafb752so753897a91.0
        for <linux-crypto@vger.kernel.org>; Sat, 12 Sep 2026 07:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789224088; x=1789828888; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iIsKkBRVqKHVlP9edUOYmG2b5QsoU5qyf6y8sJGrYtM=;
        b=nQ/rLwO43nAkQ9uAZK9C0K0P+lmIPrA9Y50Ghd+6vzT2l6dtVZzxA9bidBPftsb2a1
         QfpvaQBFddJ/mo8HKUxIhRltiqhZYKI6MxDF7aCUR8uHDU0VAkpqxudhlaUQjQe2mM70
         bO6Sli5m7RsEhB12bgDJSjobxDeVHMm/4QAII3beruf88NnV5j89VWo5aXAWpy+v10vh
         L6GihFzxHlzNiWU/l59EVkQiuOAJr0Sw2aXgEyzKcAyFzJbBKGKnzsmSFbL20oqaO7bC
         D5/aIvS6p8Y0QcuRaDH+KOw/emot6O76mZzv5+l8L5aExBx2dTpXl+nM9XMpJQWmmYmh
         LYsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789224088; x=1789828888;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iIsKkBRVqKHVlP9edUOYmG2b5QsoU5qyf6y8sJGrYtM=;
        b=gGA1Cf8EIEbfcnfXpheDE6cDyDO/t0gMgERIenNeOZg8IOCloeEKyqkvseA8gnIPtg
         wt0C+jVXz/bto/E/yj4waKaY35LsRX3TP4NrhbLWMoeTrNDuvfzlFD2iVzgbnf4C7Bm6
         C1gLjqlbGDa84eInQp0tJYvAwwQ2oEg9iFpHGjA7Opolko2S7FqaEbbteI/93/zZEIh0
         83JAUrFzWlMYwi4dZGlcjYLK0e5lfMFTT4OZWhjD2WLxEEHZL/JWDUFjToVrneOkeLit
         gzx2B57SgqIDJEbW/bkxMhmozOW3m0ljPORqU5DcGi27eXxcnbjRa0i9/d1nBha850jQ
         5vew==
X-Forwarded-Encrypted: i=1; AKwUvBwBsE09Cr5o/idAXemDf41o1fUCDT9lnq2raYrsvm+qIbXSG/kOeb8w/IO8JJtF/wpa5JSpIh+JhLwefG0=@vger.kernel.org
X-Gm-Message-State: AFuF++lmEO8dDSh/75L11aQWsMMT2lPEbIYtYWm94JCZhldEg5Y6qJIc
	0reyMka72QDZinBUn4901jGU+JFWatOhP95aF38lpu/KlLrnxcXnr1U6
X-Gm-Gg: AYBFou0g3XM+c3hqzsToPr+hVR2WOUXCok10+4pOotCMRNmuADfvoWErO/4oCaCzPQ2
	yfLidBaqKrt0MgSqjk75jtssrQtV2dL5A9RC1C+vKnbozVpKrrtFHt40oehU2IK077yciw1nM43
	HsNXcHeFkVBe3RKACPSsyuzF16H05qoSD0y2Jap0V9pvfcNGcaYO7wbRpF9eYTuHxjW8ieH5aYv
	jRMKVqwwbRNkU5VQPRjAw0EeHlM6NOlWt4rkj/3dPSm1usWOHut4dlng96zbAejHunHAUTox+/u
	TyO/WsJykwgQ6IqvTIAaumiX5XmL5QsYZ1xYPUtXfPbIdgWeoHiE/cOmLgNiX1jjBMe6nq3yN3L
	RjWFqOFlRGPZlCl42tbqAGVxAo93It1scbMfAaAf76OZemNae+u8cjj+rK3HS18kTL5kehlqoj0
	d3OiWM0miAVgSpaeL73nOiTsJ5ZOl1sSc9CfSG3BYRyrUrZrgISkqbkg==
X-Received: by 2002:a17:90b:548f:b0:392:b509:b1a5 with SMTP id 98e67ed59e1d1-39d9c1db3d4mr16333966a91.14.1789224087801;
        Sat, 12 Sep 2026 07:41:27 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1002::de93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d98e60484sm10380257a91.4.2026.09.12.07.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 07:41:27 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: omap-des: fix crypto engine cleanup
Date: Sat, 12 Sep 2026 22:41:16 +0800
Message-ID: <20260912144116.993932-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

omap_des_probe() allocates and starts a crypto engine, but the remove
path does not call the matching crypto_engine_exit(). The probe failure
path already performs this cleanup.

crypto_engine_alloc_init() creates a kthread worker for processing
requests. Without crypto_engine_exit() during driver removal, the
worker is left running after the device is removed.

Call crypto_engine_exit() after unregistering the algorithms and before
tearing down the remaining request handling resources. This stops the
engine and destroys its worker.

This issue was found by manual code inspection.

Fixes: f1b77aaca85a ("crypto: omap-des - Integrate with the crypto engine framework")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/crypto/omap-des.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 3b7104cb4487..4b5a8d13f505 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -1082,6 +1082,8 @@ static void omap_des_remove(struct platform_device *pdev)
 
 	omap_des_unregister_algs(dd->pdata);
 
+	crypto_engine_exit(dd->engine);
+
 	cancel_work_sync(&dd->done_task);
 	omap_des_dma_cleanup(dd);
 	pm_runtime_disable(dd->dev);
-- 
2.43.0

