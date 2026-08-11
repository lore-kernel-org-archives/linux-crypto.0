Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01662472B8
	for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 04:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786422844; cv=none; b=DleINFjNpQrPRcrhsEovMRhaUYfvLq2nKxZ5HEXgIUTCBQ/bWVfYvTo59JZ/yjmawFELgjiRoJ5jLbvNSDDKaPgH3+aUFlhQHJDYG2CO0d3jgD8MG4//0knI50XNdtPeOFMM7EazucRfLyB97XDD2Wd3ZozZH1GMpMb1gJsP0HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786422844; c=relaxed/simple;
	bh=ZLd3J8PVEgNl+BzJCfVDHPTgZH7fT2L0z1Tal1ZxU9o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=udcNgLqdrKqhEM04nNxSIMHtu7yrsige1QryYbLWGliPGM9bTwaE2tYXCnqR7j4I7emY8/bTbfHGguO+C5neRVq8PjR4akJJTx7IvLPWY62FE2k9ba4Mb2JGplA4yzIpwGA7p6zIuTXwoaVHgyOQ7oDxJnHhbLjfThEmuJ9shgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U5tpE7tj; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U5tpE7tj"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-39266382df6so2833046a91.3
        for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 21:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786422841; x=1787027641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8x8MJGnJddsyIz1e4nFOatZ7XGejclv30uKfFBgm2PI=;
        b=U5tpE7tjyLpw/c+5WcXk8XQVuckyjXAW0B0YaiRGRXYNwZHlchLJijojmem46axHWH
         b+Bq2Bqnshekd06XeDnNiDGMcWOXKTecwpm9UQ8eb5SotcaHDp/Ql1jlH8025DKz0BwI
         OkttdpTWWDKlGnJIAziBR++Px4l6n5QQL8uZH02dARTY+iaeJoZGdoXicuX7TZYXdZ+H
         PQPg7pgHuZ0WpBrpgnNgRQSerXItAFJQOOoe/t8yL4A+nlaD3VhQh/eP7hxcLRkLpm31
         tzxKQNiNOo7PRoFtKjjcesBh9DD7yqrkqvFtQr/zDTfIliAUo7lHN6Vfy9D0mAlRdoj1
         mD3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786422841; x=1787027641;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8x8MJGnJddsyIz1e4nFOatZ7XGejclv30uKfFBgm2PI=;
        b=Td2p1OvcTjSvsBMTr+5SQrdue7yNrtcItJhCJzj/dB/1o2Ov7Wrf7i5wjaBQ7ohMYs
         nAol8u8BMBUE05VmPMbOsYNl4NfZtPE8B1NX3O+ALHzUABKNkVhqGNGVsa0EadSRUOkq
         AIi+aJY+tDXw4uRo5hWQJ9zptLdADrEWD+EJ9MeRfxyteJZa9ksc4CzGVyHx+SqujGf4
         pmTN751fy5bzzuGGMSKydZLWN4Cf6NBXoo0ZKhofFB7Wn8AiGcLHP/Q6O+XYGNKKoIBm
         JCl3qinifAn7k7Hkp8sjDzXo7oIonjXfNBiCnX9SttLXkW95UduCHtz4xaV9cZRJ7LFm
         GNiQ==
X-Gm-Message-State: AOJu0Yxu4VSrdNvVUcoajkcWeMUGa30wH8co7cjOqpdkSOFNxA2lWT7/
	YMqilxmVPvWe3YiNALMcCzbdES9zM6d1GYcI/2vK1Agdju4564f71yS/C5rpQQ==
X-Gm-Gg: AR+sD10kh6ISkZbKwKjoaJ700LAaJza4cGS5dL0ToGS2/DFETlUAP+ENbbT2Hi+IZVM
	tsMCh62pKzfs2RraSSOQvEmcybkLB+49t1SOISP1Aax79LYsSIqfwXyBHvmwiY86iZfysofST2/
	l778wSbUVnx00dtw/a9hNaMxJmyqMmYEF74/HR9qGT0Y23WQ1rfodPClaRd/EDFy1uPMl/9tp0O
	f3ty2aJ5Dqvs9wZ1sqKn22fOHKMBj4zL0LWTErEl2dJ/6m07pZ+SauLs/QAIBkmvNfne1rWt250
	Yhz3hJ2K+TN4HagTLBBpg1qBNUIytfoyTW5jjufmN3dwSvUvgaxY/SmRTZrfQEpg0s4hveadJTj
	WaJKmlxYkZemFas6cshuq3NKytpuSs4EOrv9Bm+dCWM0cvcoZEqjU167iG9fVynzMYg8idNPk8m
	y+6ov8d/145Vdlb6JW4LTyQPtN+IZ5rzydz6BEqgC3iFUdR6TQhZGOODFUgtaqVevY3AfyiPtFJ
	sAC7qNTiyf1fY+zRsFYDlIIEU2yE7FfWEgTgpco8fDugQ2RHogUgFHH7QtybTCouB4DaWa2M2tf
	k/BPbUt5lplIVESN4t0kswGgxozwNrc4+L0xUg==
X-Received: by 2002:a17:90b:3d89:b0:392:c80b:8eff with SMTP id 98e67ed59e1d1-392ec59c589mr647621a91.11.1786422840848;
        Mon, 10 Aug 2026 21:34:00 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392d537d905sm1823331a91.14.2026.08.10.21.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 21:34:00 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-samsung-soc@vger.kernel.org (open list:SAMSUNG S5P Security SubSystem (SSS) DRIVER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: s5p-sss: pass s5p_aes_dev to irq handler
Date: Mon, 10 Aug 2026 21:33:58 -0700
Message-ID: <20260811043358.136042-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The threaded irq handler takes the platform device and calls
platform_get_drvdata() to recover the driver data.  Pass the driver
data directly as the devm_request_threaded_irq() argument instead,
dropping the platform_get_drvdata() call.

Assisted-by: opencode:deepseek-v4-flash-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/s5p-sss.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index bdda7b39af85..f20c02e9d646 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -638,8 +638,7 @@ static int s5p_hash_rx(struct s5p_aes_dev *dev)
 
 static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 {
-	struct platform_device *pdev = dev_id;
-	struct s5p_aes_dev *dev = platform_get_drvdata(pdev);
+	struct s5p_aes_dev *dev = dev_id;
 	struct skcipher_request *req;
 	int err_dma_tx = 0;
 	int err_dma_rx = 0;
@@ -2221,7 +2220,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	}
 	err = devm_request_threaded_irq(dev, pdata->irq_fc, NULL,
 					s5p_aes_interrupt, IRQF_ONESHOT,
-					pdev->name, pdev);
+					pdev->name, pdata);
 	if (err < 0) {
 		dev_warn(dev, "feed control interrupt is not available.\n");
 		goto err_irq;
-- 
2.55.0

