Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793194114;
	b=FYKr87UDOMWh9MiZYVPxhPQQiBqnjj7li0M4x2een7T4WP7QLtWIrVB8SgjR8sYOLV+S
	 bwm2lWMVGQ1gxcsOEc0sPOAAqom1p3UtQRwXIUKjGVRh26/C9pMyoyQovOnO7XFj1gtCM
	 aKjLdEBgEqeR/x4Ybtgl3sXG0o9BaGXBwkdFQV0HVj4wZJl+dWdRjIZY0wt8DgECkbeC9
	 gySAJfLlg2T1LciTj/uhnhvya3XXZwIjLQyGEF4HvdHtS2Mj2DAfstgxCPGdHDbjxH/Os
	 dxwLoOb4uSJOOxwq3KTvgoUEdL7bzoxvVCMPJ4mqwLKd+Cu9S600sgy5dIipE8XvHxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793194114;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/qtnZvOuU8MhlvJHegjHxSWlFaXlL/NnoXGGQM+IOGA=;
	b=YN8FUZ9LHokPMyUpGvuJit2qAts3TXphjAPKqSOkh8TM7znjiZfrvBXETLk0lFiu22Zk
	 j+4V/G6Vm8pznp2ejYS584iHr7ZghoX44IBgmEWqtMwcIr71A9DGguz6ya6g52/WAokQN
	 QeGZbNCm59dSi3RNBqOif2nNK6XguYv77Ey8JUwM/OenWptk5h2U8TivDk5wmQg+FEH4y
	 Xw6Cf5dix75BHa5uHMAAxHE2M0UrtkquSjfkLSOghT1t5WQz//qCUEOUrmgpOXZ9h2fJh
	 4hSiaMRq+oOM2wZIeW2Bs7Vfbqcb7ZLTakJq0bUpPzYZo1tnTGcz8QAFKLyGQATxYlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jr1r+QIH;
	arc=none smtp.remote-ip=209.85.221.174
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E90606A323
	for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 13:28:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3E90606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jr1r+QIH
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5ec3561ad43so593410e0c.0
        for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 06:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793194113; x=1793798913; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/qtnZvOuU8MhlvJHegjHxSWlFaXlL/NnoXGGQM+IOGA=;
        b=jr1r+QIH9SF8KtcfX9BXZIHaTISyWChxSbxtk2nQq/HpZxq55eiafMQmivcjOYIsn7
         h2qTJ6u26kwNCEpWvOqoCy6eXKsRJUtjuvajaCzMcFb9JBIp1tzPDOU62NwP1fpm/Ct5
         M+zBG07CeU+BBuL/0F8Y08csE5QigbGYSElY4VEUohVPJz/qtmyNASR9EC12577NET5s
         eMEzhI+f9wQLdSDxiqHdX6Qw7dpIHdd+Q14xV77sYfPNv2zJgRY12MtqLg0zOzu4hZsT
         CXMAKNko1WX759zarCC5VWO5mf1uOdDt+/b0lA3rulT4dM0LcCWJQ2tYIb0sMtlmFcYu
         iM6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793194113; x=1793798913;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/qtnZvOuU8MhlvJHegjHxSWlFaXlL/NnoXGGQM+IOGA=;
        b=1RBPXiZogNxk7Y784t7Mp15Hq6g8UrE1XgmYowKRMcLv7FJI2eDrO32+/A3EHJtaHQ
         PVsY6e/fLZLfcF7PMQ/JaLpdULoCddZMP3NvRTU8o3lWP69p3bAkvhVQZekoZVZCtutr
         9KJpv4jLrXuTNQexdqhHtabrXdqpZyBSDQI351W9UpGBcQyT7G+/Bl4STkm247ElhI4P
         mv8CQY7JfwRtilbC7r+RcpatxrYu2zxihze7K+h4SJ4rKCgY9zSLobCrWyv9B1osZ3za
         +z4M8uoN0r6cHjJcW0osP64McoELvSNjV6LFMrNUaQAmomlrL38x8qceLo5YbozAFG8I
         3YOw==
X-Forwarded-Encrypted: i=1; AKwUvBxBIEo+X5bLxDwuFqumOLqdobJIySd/5rcwzGhnjZjsjqdUyLC6LMyqJTYgWhln2yKK8YObvJ8Z3zzjbm4=@vger.kernel.org
X-Gm-Message-State: AFq9FYKmjCPOBpuTmK+KIxot1HMbdhbfAxMDISG8ufD21i0znPhKNSF6
	S3VKIzqct9aeoj5iQ3JbcjmgByuEEuCmXF/ikIEpCjeQoquKbVLw2jul
X-Gm-Gg: AYBFou2a3mEpUeFVu0WYtAlQElK0RHV/Dk0Pjh78SlGsNX3ZQ6LIpmxPjiMcJDIdU2n
	HiV71UZ2Z96VTwfiVoleeQtPndYYjQuqyOHmcia6lSIvX7jAWfesmqKhEqPwqN6aolLvACUy/OG
	7t9SyzHkxZJzLGQsy19Ml/2Vavsb1xqDHdsUy04NwNg2YGC0PAvIM/URp+IgFmzVugMNrV6jaCT
	T5+ZMHor/OKt5rclGeBuzGWK+dE+kZy0jTd/F8h3HePJEy0OAcmuoYz02h5hYB0NkXT1p8YMvQi
	U87U3HzxiaGIQRKmLnXW41WRpR3qF484ZJpoK65omsMhl8soSRrAgRacZrFW0z2FFvprqDNOLUt
	1Mjl8B9sIIq/c85eyLN4lWiOLA+Pg94uQCbHPdfpLynERtT3aqd6KbCXLNby2bSdVzrxBR8Nqib
	WKKIk6l1fIjMKZYStJFiEvhL/lv+egyxAYv9FjdyBj58VzXAmvA3lXEihc0S5f32VLf27XQWlR+
	DkOUUl8WxevCOtF2EkGhLEiaToRkLJKC/oMIaM/sYVyayzLjIeEdE8H5vnq8QMxI0xK4M/cOqna
	lUTCFObPMmAeA2DbWAzSQHJqLG42ehSZ+JQ4s982K3Hy3KeA+c2Vmr+iY3mbHZE1M42YmJY5qGg
	avxcmgSwWYWu5isCvFiqDKaE=
X-Received: by 2002:a05:6122:c93:b0:5ea:c37b:450 with SMTP id 71dfb90a1353d-5ec4cc5343cmr1027395e0c.20.1793194112610;
        Wed, 28 Oct 2026 06:28:32 -0700 (PDT)
Received: from fabio-X870-EAGLE-WIFI7.tail2bb604.ts.net ([2804:1b3:a801:e068:c468:5e04:829b:4378])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec4f99442fsm1720000e0c.15.2026.10.28.06.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 06:28:31 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: herbert@gondor.apana.org.au
Cc: horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	sahil.malhotra@nxp.com,
	gaurav.jain@nxp.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fabio Estevam <festevam@nabladev.com>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: caam: jr: Use dedicated shutdown callback
Date: Wed, 28 Oct 2026 10:28:25 -0300
Message-ID: <20261028132825.657546-1-festevam@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fabio Estevam <festevam@nabladev.com>

The CAAM job ring platform driver uses caam_jr_remove() as its
shutdown callback.

The remove path refuses to shut down a job ring while crypto
consumers still hold references to it. This is necessary during
driver unbinding, but causes the following warning on reboot:

caam_jr 30903000.jr: Device is busy; consumers might start to crash

Unlike driver removal, system shutdown does not require
unregistering crypto algorithms or releasing driver resources.

Introduce a dedicated platform shutdown callback that shuts down
the hardware job ring without checking consumer references.

Keep the reference checks and algorithm unregistration in the
remove path.

Tested on a i.MX8MP custom-board.

Cc: stable@vger.kernel.org 
Fixes: c007e720989e ("crypto: caam/jr - add .shutdown hook")
Signed-off-by: Fabio Estevam <festevam@nabladev.com>
---
 drivers/crypto/caam/jr.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index cf725a6ac0fb..75be668b74b8 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -178,6 +178,15 @@ static int caam_jr_shutdown(struct device *dev)
 	return ret;
 }
 
+static void caam_jr_platform_shutdown(struct platform_device *pdev)
+{
+	int ret;
+
+	ret = caam_jr_shutdown(&pdev->dev);
+	if (ret)
+		dev_err(&pdev->dev, "Failed to shut down job ring: %d\n", ret);
+}
+
 static void caam_jr_remove(struct platform_device *pdev)
 {
 	int ret;
@@ -812,7 +821,7 @@ static struct platform_driver caam_jr_driver = {
 	},
 	.probe       = caam_jr_probe,
 	.remove      = caam_jr_remove,
-	.shutdown    = caam_jr_remove,
+	.shutdown    = caam_jr_platform_shutdown,
 };
 
 static int __init jr_driver_init(void)
-- 
2.43.0

