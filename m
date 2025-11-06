Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1E9265606
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 16:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762446729; cv=none; b=VjbkoBbULquU/fd2thmLxgX/MiyyulMMugpPK5KsAU+LdhQCk4pZP8oVxAe3nowGgIITbnZMSARsmOjPhtd7L9hiztiXqckhIzrpBDuX0McuidAOeaWgQTSalGhhEbBNjw+LWq2v7Ks4+EO/Lgw7AOoXrdizo34YiSkr0GBv8rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762446729; c=relaxed/simple;
	bh=xg80kiqnHSCNXwJUc4z9P8NCrVmVT83uMX9FIiKX5sA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qb9ehrW0TMPyE7KDnQBB2393e9U36WWRucrA7eO83kMuIB9hvf2d3ko6YRZH8wWIGDjlaFf6P4aaRjMM9vgbl/d2bg3gj1ckFxql+98YKStobqlNL3UCdO3/TYZGHqEvHIPPyxXKZmLv4MG+yLEteCvfYKyqut0RgHGd0M7Smco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hGShMMSA; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hGShMMSA"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b727cce8d21so15155566b.2
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 08:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762446725; x=1763051525; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WTiuGCaVTAiVJKKKlWqCv6SA9W0CyzxAyfEzvBxFcPU=;
        b=hGShMMSAaAaG1/1AZsqqiUJjg2IvHEFDo6E7qV8JEtI2qjU5rc34NkA76ON+aY+/0H
         veLLAi4aCbxhlC+hRMu0ASbj1+FHoV7nmYZjE67PO+Gvk3wkQlatKpRqEKV39IO9OWrS
         JKFKfYtqcf7aEw0qW40nAVbD8Oevf1gMbpim9STj9qOggkxRRhFLc2ZhEa8sEKchQQo5
         DLhEJgUUKGSZZHpTfsdIL0HFQlM9nEVI2DSYeNt1kPyHGOy9KvGZMYKHkm2hY3+EgZHx
         fECfiJFpf7kbKKZi03NIgIIgCZ9l2DoNbu35fbKLEXLPhvrHW3nICyQZr/XP7NzqKZbd
         Z4rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762446725; x=1763051525;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WTiuGCaVTAiVJKKKlWqCv6SA9W0CyzxAyfEzvBxFcPU=;
        b=nz4Kr03N7byKliI7hMovMZ6JDqd8SwsKoCeCpUNKuNmX3Fy5ZsyQx6CK6omaQ1XCW2
         TybrcU3XpWbcUTwocRR6GbaGW3lriHnlHUwzWRvBw7koNciFOZqJ2h+SuFAeXPzbmZEp
         bR2yR0Qyk+vdKTJ5ehs0qU6oM7LAO9wvmAtVACokVIhIqsgQbS0cUOYQyv+O+nBO0D5/
         k2LVFbaqHnyhUyXDUcE0pLzyFTEwYy7y59LUTh5cirsdAzEf/QxgwVBZXibWQrJZniMk
         WANQGQu3cIYS8QUEOr+sMLeJHGENTHDOu5Ew2okRaYmydayOpommkLHPGcpLQfSRdM+8
         Y+Uw==
X-Gm-Message-State: AOJu0Yw5Sh6soiMFr7ZWdvMt1//DrRZ8zaT5u+2SS66t80l+7RbPAY0H
	2eKsRb4hjaNKdMgwzCH1OmnZvAo3+2yJM3Q6dmjmnwx5UOh1uf/NxBPZrJcBRgN2PtA=
X-Gm-Gg: ASbGncvkvt/bMShhdsGensnkf0w4O2N+5YE+zLO/yySCLef02lkoIRp/EwKF2PJ5rrN
	jhN/INiqMoBNeJXupvEYWLVlHeqWOR6yW+zX2inr6t/fpNqmglXM1+vL6PUBCMGMi/S4mzwJrGr
	ktZdxvXbyBALHfUUYFgkplvPK8rONcWe5r4HVp3g0eocYDEtfwtkzoFjYYfoiOju0iP0gA9WjLD
	5gjeWj/BKJXltQ5pmlybke4mK9rspfbqYk3auvGoDMI3HgfSimWPaBJjf2sfymkpAD7zfwQed5O
	mpaQF+C38JecdJbGefr7wQSji9EzZglHVcakDSVgkQAIvkwz0xeEI17PEhCnSh7xL4UrlGOh19C
	/AD1TE/BX4f46Eyd5xELuo28bYNXzxdeOd0RX0MMtJ84IIxhg4c5Ne3A2ML9QoUh1EvewkzN+3A
	ng0a+iBgqksQEXC0I/
X-Google-Smtp-Source: AGHT+IFJFC9RL8ABDmFdtdRmcZ3Dy1rT+k2Sx6X6okxkxPVdsUhn4dsPyGeIOTfuz4qNIhn0Sy5VQw==
X-Received: by 2002:a17:907:1c93:b0:b5f:d4db:731 with SMTP id a640c23a62f3a-b728b816db9mr234127466b.0.1762446724660;
        Thu, 06 Nov 2025 08:32:04 -0800 (PST)
Received: from [127.0.1.1] ([178.197.219.123])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7289682544sm249625566b.53.2025.11.06.08.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 08:32:04 -0800 (PST)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Thu, 06 Nov 2025 17:31:53 +0100
Subject: [PATCH 1/6] hwrng: bcm2835 - Move MODULE_DEVICE_TABLE() to table
 definition
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251106-crypto-of-match-v1-1-36b26cd35cff@linaro.org>
References: <20251106-crypto-of-match-v1-0-36b26cd35cff@linaro.org>
In-Reply-To: <20251106-crypto-of-match-v1-0-36b26cd35cff@linaro.org>
To: Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Florian Fainelli <florian.fainelli@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Ray Jui <rjui@broadcom.com>, Scott Branden <sbranden@broadcom.com>, 
 Jesper Nilsson <jesper.nilsson@axis.com>, 
 Lars Persson <lars.persson@axis.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
 Srujana Challa <schalla@marvell.com>, 
 Bharat Bhushan <bbhushan2@marvell.com>
Cc: linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@axis.com, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1159;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=xg80kiqnHSCNXwJUc4z9P8NCrVmVT83uMX9FIiKX5sA=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBpDM17upx0MRGUBjQ/tdX5Rem+B0vFDSLjscqjV
 RxcfXdfCVqJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCaQzNewAKCRDBN2bmhouD
 12mjEACNaUET4bG8Ms53cjywxTlnDVDM4fOiiJTV0eNuYz+yQxopkwfslu+z+XpGpp2onkBRQNN
 q6OdnMGXee/pVh49eofDDW+dZ/hGQ6yL89U8WIzM6s3/c56dxppov1yJMj5LlrMSHeU0FF77mDs
 U0fsPQtPxjj9Wm6ScwPdr6iIyR+P+7WonOVJI7J5Tw05cY8deLC67d5YTsjFSg5JtsWYPfRD62K
 IthSFNol6ep5g5H5GzxLzVwQq6CsSmh/cYQZcbf9uLpVLxcUxveU7cKj/vNwmiachL7KlYmKA8+
 y4ZNmA2Fp5TlE/SiLb19tVsvNlO4W+EyucS9aiAtSpXMsWoLJvUe3gxQJf9kzdAzCZEUHk2DxtQ
 Coeth0TfNVAhAvo7HTRETnMR+96s/zYAfIGYVXy9Uj/sFMLH0Gnm2fZMLPNdxr5UXACsytnPiE5
 i9sYVtdf3iMxuwwgEeKozPJOnBn6vEdC0qQCSBl6/GwLdZ4FlcSnS/s3a6TQGzlUm+vRdJdKHOg
 aOpfw67z5/6anqIQqofjgdxNboUQUxnK052bwK1+8DhvW+NJzdmgZDzU69XLO+TOtyEA5oXLWS/
 5tBcJIwCkATSjUWVfT49f/FAop4Xw3oCBAh+KkVWLRkvN8+lc6wJ2N9NELiXOG/Ez3sTmWOBG33
 uEcbGns5V48mkVg==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

Convention is to place MODULE_DEVICE_TABLE() immediately after
definition of the affected table, so one can easily spot missing such.
There is on the other hand no benefits of putting MODULE_DEVICE_TABLE()
far away.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/char/hw_random/bcm2835-rng.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index aa2b135e3ee2..0b67cfd15b11 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -138,6 +138,7 @@ static const struct of_device_id bcm2835_rng_of_match[] = {
 	{ .compatible = "brcm,bcm6368-rng"},
 	{},
 };
+MODULE_DEVICE_TABLE(of, bcm2835_rng_of_match);
 
 static int bcm2835_rng_probe(struct platform_device *pdev)
 {
@@ -191,8 +192,6 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 	return err;
 }
 
-MODULE_DEVICE_TABLE(of, bcm2835_rng_of_match);
-
 static const struct platform_device_id bcm2835_rng_devtype[] = {
 	{ .name = "bcm2835-rng" },
 	{ .name = "bcm63xx-rng" },

-- 
2.48.1

