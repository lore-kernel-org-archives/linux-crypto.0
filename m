Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034123161B5
	for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 17:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765473364; cv=none; b=lDsrgHVMh1ECNzKbTMA3rV2J5Xpjr43CQQMNDkWhWpQ/YBou24DqNi/N4Il+XGZcAYWyqV/mGIVo2yecp1iqptT/QdHDS/sI+NR+RL/Qp8NnFY9K3q4SB3NRvgwjxRzqCmlBud+l4DXyngMrb95JXx2L6ZQSrXlaZo+ACCDkIBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765473364; c=relaxed/simple;
	bh=9/MWuHZltbfrljfghNMjsFGbpJYDdAIf/qKdNwaHWyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ne0TSkt4CW90jZ8JrJqxED/NEh7SdwL3FAScrGfHu08pbUXOHpPdmRZnBnl7OuIKNK4GLtu36RLJFbCa0wFvGOlObE8+3O9vm4Nkl81pWCWcDyM8x4Q84wMcPnXV95KYNc9LAgYqpZ7xFZh1xSRS5as1aqbQU9/EZjOQTiqiT/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=gdrL7IIc; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="gdrL7IIc"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-42e2e3c3a83so177005f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 09:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1765473359; x=1766078159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I4l2h6ylecBmmb2NFGzo9KVhF/u4WxGR1OPEqHGghSQ=;
        b=gdrL7IIcidOpr5xYgEdPCULyHIwZL9xLmvlYt6Arnkhx+CQH7SXWRQWsAnUs3V/PSv
         FkkD7KsXJfAmMIkJILTionY53sn8jYQO45CKuHGwPoKIX9CMtaOiYRzdFTXauES33Mo8
         T51CInjnhD5zdEN8gqhEQtBxHk4W/mGyqqdXCF+1Ex6vqZfdt6ajBJC6pUHoba8Fm2nV
         VbQhNYakG8LWalF/5qCnTLIjeHqkRDb75biC1CGt0jx+YkowovjIr8dpuHX5SaC2BLI/
         THtYO9AUW4nUCVwCNfOxuDkWiikFIit08KjxybeRyTqe8DoiQPK1HqOBCetOG6dX5EZn
         G4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765473359; x=1766078159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I4l2h6ylecBmmb2NFGzo9KVhF/u4WxGR1OPEqHGghSQ=;
        b=FjgPaRYVyYjBJxuN2sABfhkDFVsb51sgz+MCwH5ACQo7kqd2qPu8bscejoqH0Vd3++
         07dAHS9ruLY10hF6mZUaBKyWXlV9opHvl29ck205NNLUqVZhF2KENLMl7SHwW6z9x911
         LMc9J0QuOSzxm/DylCaqp/E2ftI+Ej88cZCAgGOECNX8IZBNdF8O0hJtIaWWigRVqtmp
         2akdjqZKaAeq7z6QE0a0oXdCaHES8Ut5vLlZCMUX8DuWCT4LX4KhFXSMRTB+jr3ayDdu
         PbjARson2s+gvi3pxPew8Hp3updsAlHxW6obz57y0MKINC8osKb9cHoyOnMnuVffz4Ff
         AeJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUr3y7qRViDTcazvEofs/GIWiwBPwUfP/cJgILETmVNDjMBOkLz+CM2CjFp4jDoxL0sWgycqH52uqkk/w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+/cCW4XM3MhJWG0sjkLHyQkKIyX075gt4aIv/eGEMKi/cwMBU
	D/pZHOG93KJqpjoAoakbG3GZaw7tYOSK//1qWKU4nBS9ZdS0IambF2Mev0+OQjK3VR0=
X-Gm-Gg: AY/fxX7ElP6aZq2iKVzf8t82XU4rwHfSxhkbpjPAougfiSjNDVfUimnzMq3Bn1SxacE
	YbZR0Qs7kS21HIInPU+9U5xHmYC7xq0bfD/k1dBAoajNET58wQ0dt7nVze5WVSCuVa53i+8Bh/2
	oqENCL2eG7exxPGxaDuyXqbtTpZKd66Nc35At5Kua8KtSfnxGCvoggdYxMb5ecKOgXAjVyp3IFc
	PRnXlL+K0lrbnoUZJJBbd29mmMjbYAlLOAqy1DKlBb7Zk9ReLD8iDSCsk8MygSJRBkk7UsE6Equ
	xweY3yMNeea7RwMDA1uiVeWdD/rgMNWHY+jMrawZypTPD1uebgQipkIG22ceP5YlDJVBGULm7AM
	YJQLDClMnkqmciPwOcKIJIkQCRDy3enIxwnJgJ+NkrO2SVx7MNjCbaX089zl1IFWpOhkjOVVGwQ
	VFvjMxkKYmOe3vRzQdAeG45VAncir3qX6+4ob9Az1aPP/2lgX1FpeTStzSSEwI62FijiQ4x1i7+
	H0=
X-Google-Smtp-Source: AGHT+IHznnkl74xT2z8JC40wM/v7wIF0q/FLhgvdfq6Hs39to3yRCTNdr19bDlPbZFNrY6LaQx6MyQ==
X-Received: by 2002:a05:6000:4308:b0:42b:2c53:3aa8 with SMTP id ffacd0b85a97d-42fa3af8df1mr6951355f8f.37.1765473359065;
        Thu, 11 Dec 2025 09:15:59 -0800 (PST)
Received: from localhost (p200300f65f006608b66517f2bd017279.dip0.t-ipconnect.de. [2003:f6:5f00:6608:b665:17f2:bd01:7279])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-42fa8a702a1sm7588863f8f.13.2025.12.11.09.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 09:15:58 -0800 (PST)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Jens Wiklander <jens.wiklander@linaro.org>,
	Sumit Garg <sumit.garg@kernel.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: op-tee@lists.trustedfirmware.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 05/17] hwrng: optee - Make use of tee bus methods
Date: Thu, 11 Dec 2025 18:14:59 +0100
Message-ID:  <83301effbb923117122f5f076edbfdad1f947386.1765472125.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1765472125.git.u.kleine-koenig@baylibre.com>
References: <cover.1765472125.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1830; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=9/MWuHZltbfrljfghNMjsFGbpJYDdAIf/qKdNwaHWyQ=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBpOvwglYVLSe7x2hJUzJuiko+CB65bc9zowSFvy IrqbvBxWmWJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCaTr8IAAKCRCPgPtYfRL+ TjUkB/0RRiOrgJTBYNMrNgeZXzR7aDDF6ecj9C1B+6tXZ7EDmvu8w1XfWPampNGADTlFFns02Y2 LcJ0fjr5W8rEgvvRvmeDkmqIlZDW1J7Z9k0ShbGUoFVmleBaweG7398LO15X4tX3jJcOBzM94+f CfiOZAwcVz/lm2J3pH1msmxQJRWnmsB4T2q1dcBBMcwK+fH38MUrcB9sQ0VujUDfH4GGttfGC0B tIGIcWaG0JZeEBzxS3WiBsIiiZBFQeYyMtV5HaGpas8QjbvkfSJlACbwShtObNGb5zbOpskW+qR rZZE6YursT3IFX7j7pUMcFZthadnRzFHjaS0aAf/8pw+LVJe
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The tee bus got dedicated callbacks for probe and remove.
Make use of these. This fixes a runtime warning about the driver needing
to be converted to the bus methods.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
---
 drivers/char/hw_random/optee-rng.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
index 6ee748c0cf57..5a3fa0b38497 100644
--- a/drivers/char/hw_random/optee-rng.c
+++ b/drivers/char/hw_random/optee-rng.c
@@ -211,9 +211,9 @@ static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
 		return 0;
 }
 
-static int optee_rng_probe(struct device *dev)
+static int optee_rng_probe(struct tee_client_device *rng_device)
 {
-	struct tee_client_device *rng_device = to_tee_client_device(dev);
+	struct device *dev = &rng_device->dev;
 	int ret = 0, err = -ENODEV;
 	struct tee_ioctl_open_session_arg sess_arg;
 
@@ -261,12 +261,10 @@ static int optee_rng_probe(struct device *dev)
 	return err;
 }
 
-static int optee_rng_remove(struct device *dev)
+static void optee_rng_remove(struct tee_client_device *tee_dev)
 {
 	tee_client_close_session(pvt_data.ctx, pvt_data.session_id);
 	tee_client_close_context(pvt_data.ctx);
-
-	return 0;
 }
 
 static const struct tee_client_device_id optee_rng_id_table[] = {
@@ -278,11 +276,11 @@ static const struct tee_client_device_id optee_rng_id_table[] = {
 MODULE_DEVICE_TABLE(tee, optee_rng_id_table);
 
 static struct tee_client_driver optee_rng_driver = {
+	.probe		= optee_rng_probe,
+	.remove		= optee_rng_remove,
 	.id_table	= optee_rng_id_table,
 	.driver		= {
 		.name		= DRIVER_NAME,
-		.probe		= optee_rng_probe,
-		.remove		= optee_rng_remove,
 	},
 };
 
-- 
2.47.3

