Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB715266B46
	for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 04:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786423759; cv=none; b=CfDag2HcX0QHv3f8+hSAFvQvxLwvFCLW8ISMjRHRcPH5CGgnWIIBya3e3MLd7VB+o2o0gQu+4AbVmF3ZIYY6P4CxeepLwv6E2n3QsltHHQYhxWSAR0Q7qEnr1P6Y5YqUZhJ46aPhtTDCgEYHTXjcWIptNoUYHOxpxci53KKOR2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786423759; c=relaxed/simple;
	bh=ykCga1fStwIE/+EX+1ML4OvGTAsYwusJt2Kjwdfa+L8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oYpmP8s4/1QSnpm/R0ytKdqfvgEKu83ZkilwqNJ0JB8Jzq7fUdK8RoTgmhNbD57cPKXFAAqew05nSfH18O4WBRw7OY8TvZOxbInxYGwjlA5R1ecbMkzBQ/1/SqlzuFBvmm73nKcW11XYvlX4u7ooV7GD1HhWqlUpGbWsjhYX2WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lzTsZkZM; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lzTsZkZM"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cc891373e0so31819525ad.2
        for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 21:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786423758; x=1787028558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fmKjP9IjT2hrwlvsGyuoqviwfW/j7e2tW9dKMk7ti4s=;
        b=lzTsZkZM+xrz/ObnK2v4VxVIwW7QivcZRtVTgjd1fLPxxcklnhDLgfJTs6wqYxrqnX
         o4UbyHofQ405BsNDudFTjYR2wXfHo9d0oVHv3wDW+neYnti2o5YaHnhbNH2flVzHmcg0
         lYTjHBAymCWIGa6eJHRl3KYhss+JnCV70OAc57KoZxL7sOO+ylqDh+iq2HS28WdiZw0J
         QKndgPSHGJF9uk261lXu7sAu0LM8WxXjfpCF6oDgQxYvu30DB20fV9yEYL6/Wm5OjZl3
         4oi7zbXg3L356AAAJcvQYlmbpVKxAhuJ5wrJp1qalW39e8CfUUv/V77j5tcfdlnr/kFM
         LtDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786423758; x=1787028558;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fmKjP9IjT2hrwlvsGyuoqviwfW/j7e2tW9dKMk7ti4s=;
        b=rHPQ9F6szOjFaGEsHVq8q/rjRRJae9yfWRV/aEVDVMoaQssY9MkTx4VrIBEPshHw6d
         dM08mFKL6QC9mewcko0xzxkHUy1mz8TFkSM4Fofnwudr2slJIBrb8bbkVUB+esMmgnBW
         6pC6MCfD3TjGLof2MBQpI/v3mKY9iXNL3acV8s24+mbaXNNnHGKDMEfWhjjqK1t1bQDp
         LQqJlHrM5esb6o8snEG28hA98jDGadPSJhl0dKVfDK+V/tvGGVU7Ad5OENIq8I6IhiEk
         nS99+/4Tmhw37kgnCgr+URm2vqP+rTaaK/tMRmtcKzgcWDp0/4KgRX0S/9pYyd8MfIwF
         13vg==
X-Gm-Message-State: AOJu0YwpidKjNIFBcdvsIZbVkKnmSYATFDeTdKKL36F4HJcGaF7F5PYg
	Qmk5YzkiEyk+eTZKFfJYfMAtSxzgQ+EzTeEU/zldba2h22nF0S8ovXNY3G5uGg==
X-Gm-Gg: AR+sD111dLE/pU/XyUqNdc/oRkfptCtTBsHUQBiZ7BqdNVg5N+5dFIJmZgLEmYmL6Hy
	uXn3aG3bUoIDdpFsKs//oIpTv3D0mi7nThWy7fxIVjDom+s0JG8zhI+SPIpsTSNeXLFy9gU1xFu
	CKcqOIId5N8KSqmgv/3oRzFKZHGdhPEAr0iAnXVMMvkLtOjISMKD1ByG5xk61KBjgr0KXeY20bw
	Ocjtk5RrzN1rjtcxqBVPSLW/gn2lPjP5fVmKyf/SjqoNuwOZlrZ5hrdoY9mRP4dfl2tiQVSzdwE
	1z0UbB7Ou2g1uC2Flxab9rqJnRm3hwa5bzxpZOmSrzdEu/OaZCIkt9iWBFFhO/Q6bPekX7yx2H5
	C/8S9VvQuM23RGPWB9SZlqlyrVlDlQmZipGYBAtsBVyHAeJRaiIKGEAOdSc6CexQQ5S03k1pS6R
	J3JqvyKbrRsy6S2RWV0aggy2vit6aBvV+7plpGpSlWkl0EcbDozDaHak6Qr4uuez77BOn3fxfOo
	sq9sLLKdyI82IMzaIzlv1dUETzVBJjoi790Eo1t/YiOAEi8vHXs5/r4GalqJ6DASkg9IFHNFFGb
	cRoveK5tg9Kta9d9X/UQtmURbK8esznaH8uSwxcTVsMRQ6ixoA==
X-Received: by 2002:a17:903:1ac3:b0:2c9:b8b7:5d27 with SMTP id d9443c01a7336-2d317776218mr11372625ad.1.1786423758109;
        Mon, 10 Aug 2026 21:49:18 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3160cf975sm1344365ad.48.2026.08.10.21.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 21:49:17 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Heiko Stuebner <heiko@sntech.de>,
	linux-arm-kernel@lists.infradead.org (moderated list:ARM/Rockchip SoC support),
	linux-rockchip@lists.infradead.org (open list:ARM/Rockchip SoC support),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: rockchip: pass crypto_info to irq handler
Date: Mon, 10 Aug 2026 21:49:16 -0700
Message-ID: <20260811044916.160856-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The irq handler takes the platform device and calls
platform_get_drvdata() to recover the driver data.  Pass the
driver data directly as the devm_request_irq() argument instead,
dropping the platform_get_drvdata() call.

Assisted-by: opencode:deepseek-v4-flash-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 7cb1316b6f18..b2b629fffc05 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -163,7 +163,7 @@ static void rk_crypto_pm_exit(struct rk_crypto_info *rkdev)
 
 static irqreturn_t rk_crypto_irq_handle(int irq, void *dev_id)
 {
-	struct rk_crypto_info *dev  = platform_get_drvdata(dev_id);
+	struct rk_crypto_info *dev = dev_id;
 	u32 interrupt_status;
 
 	interrupt_status = CRYPTO_READ(dev, RK_CRYPTO_INTSTS);
@@ -363,7 +363,7 @@ static int rk_crypto_probe(struct platform_device *pdev)
 
 	err = devm_request_irq(&pdev->dev, crypto_info->irq,
 			       rk_crypto_irq_handle, IRQF_SHARED,
-			       "rk-crypto", pdev);
+			       "rk-crypto", crypto_info);
 
 	if (err)
 		goto err_crypto;
-- 
2.55.0

