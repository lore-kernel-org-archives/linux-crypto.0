Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03EC2D8DA2;
	Tue, 24 Jun 2025 13:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773208; cv=none; b=tRLXvOwnQe5XNDyUuP35nOrpaPjZpOMGjpzoE8oSytv+G/XWsnQgK6SnruRwP5k5Z4kMLVA3rQ4hVZeYRLdEnFaheq4s5QZvBfHxz7us0R1KdbmqdhkS5I6NO0sT8NW9tXRGZ00pP/jsMpnjQpd3j/W5TsItiD43FnBUB2UkJeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773208; c=relaxed/simple;
	bh=O97Ln5N0GE+w8ramqsXYdDKHxux0qmPTKKCEYIPlU34=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BOXrPM5mrcD/UcTE99NQZprz3yHKzwGoWtSEWBY4SaKdTctsdPEQA+/ASrJv3O7CXG2lCEPqx9WfnQXJqAxmIUOlNhQrroX+/FJPVcx614n5W0bYYs/SoUncuzmBE8bnVrWLSnrOKtCYW+w/mAE1PqA6k91gA6y5ksbJELwcC8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DlpiO4Ml; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DlpiO4Ml"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-553e5df44f8so3905893e87.3;
        Tue, 24 Jun 2025 06:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773205; x=1751378005; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XWyKqDRaj51cI2d9ZzQFXmmLXwANXVcxLCbwmNM9YJ8=;
        b=DlpiO4MljML6tdxyoTo8g8BI7W/UOGoCVZvvOVTaT2/KW0wYzVE7LRLRB/HCrK0AT3
         ZQu33pcp4vo6oXEbo5/G3O0SKvKQ5alREXyKWjxGwz3xhiKCsEBL72FKsWhVdb3phdaJ
         5M6jX1F68VwL0SKnfl0L8mDpm6adh5+oCYlUz3c0S/MtSGqQCxTX5q6Zm+t9/KE24lvO
         sRsGaNxT9mb3eDvoNG7dPwIm0tbcDOLXRqhIFHPo8n8/u2/19dJ5r3utnUYVgpx8cq0H
         +zrafwJTqb0uwSk75C1fhj+bZZ14pIZOJYL7PbsKr+h5ZR8YDtpog3vUQkaTn5+gXi8g
         6RPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773205; x=1751378005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XWyKqDRaj51cI2d9ZzQFXmmLXwANXVcxLCbwmNM9YJ8=;
        b=j28X7XlkoG8BoT1EwLg4ePUsN2oM2f9RqVJfmePCjek7gdJH1ok8sxlP7pkqJeFf9f
         IdKaNHkyMkJ6hLecBNlKCJfliBtfds9hVTTxYdCi5+UnVtrV9rDg/R+8h8IsGUVQqxTM
         LK+lFMh+dhg55q1l/QosB0zJrKnpf3B8k1BD+5u3h0MU8YOaDWa7JEdTyttDoaFl1sCV
         7SkF5q2obm/vpxNlBgAoYjVkVc7/9qYoryn0dx2T9nNHaB7iw1GSZ3LikPevh3Y4Y3ur
         46eXWDBoXXTXKk9mIiFS9Wyvp43zTYcf8/HnI69coXTJxLNWlezRPzjGsDNB2yApdx1k
         fdOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUABgsUb/679QlUayrKaF34g+mNu+H9YQxh2UZogCyRPc87ZXxoCTSqzZ47AY+sulH6L53NIeTkhagx@vger.kernel.org, AJvYcCUL+Qgb4taLKpFEZdu/a9THD3VhF+fdYiNXPRyiRYtk+EHdMubQKY52oRMeOkTMHkDm6nOHJNM1VPrR1G+o@vger.kernel.org
X-Gm-Message-State: AOJu0Yxlk+21SX4sJEqNSOz0JwiY3dkK3VNuJNGtmA3pPAtx+6oGOTIk
	BVDclOB4kmNzA6Phlhho9HHaKV4t5HWNQ+LMJzRoL7aKLoc89DMkTtmS
X-Gm-Gg: ASbGncsjNhd7I8hLpMOTOyv5qqayauf+aZSdTI4o0VHr7q0al6BERwvXEUXmINbymST
	WxlQBK86YdXLbmQHShq2Evf+VtzdL1GHWS9y8ZfCyZczN6ZcvsZAaNG2eJGBVAJKJgChb4NoCFz
	IkcN0DsUhLqxWDQv6xh8ZNLEZFwEpxAe2pEeStammCbD7PHs3Cj9j3NADuGDawnhtu4sReB7AFn
	nwEX0edj4hYWyAxuFm6wJLCF0ZvVOY7jt7P+fOuzsmR8MGM/QCj0kCbfhaeAvyauhd60YWbbKRW
	3m9HCWmapIR8Sa291u04Y3TUODDCIfj3xHNejoPZANcb5R6FWLxg8pldSx9+8kyrMvgTqirsP3n
	HHFweYAtkcPGvhFm+Pcinb2WnvzYMALubZnJNF6behihMTsRctBAGVrZ33iY5uQ==
X-Google-Smtp-Source: AGHT+IEJvcOuq37NSz1A0GUoBspEw+mXdhxdzcKnz3FUYzZ9sVh+6FGPluYMU10kI6uMB14c3FylCQ==
X-Received: by 2002:a05:6512:3b24:b0:553:2a6a:884b with SMTP id 2adb3069b0e04-553e3bb5176mr4787344e87.23.1750773204755;
        Tue, 24 Jun 2025 06:53:24 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:53:24 -0700 (PDT)
From: Alexey Romanov <romanov.alexey2000@gmail.com>
To: neil.armstrong@linaro.org,
	clabbe@baylibre.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	khilman@baylibre.com,
	jbrunet@baylibre.com,
	martin.blumenstingl@googlemail.com
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v12 14/22] crypto: amlogic - Add support for AXG-series
Date: Tue, 24 Jun 2025 16:52:06 +0300
Message-Id: <20250624135214.1355051-15-romanov.alexey2000@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
References: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tested via tcrypt module and with custom tests.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 6529ae24b75f..9452f05d2f10 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -290,6 +290,14 @@ static const struct meson_pdata meson_g12a_pdata = {
 	.support_192bit_key = false,
 };
 
+static const struct meson_pdata meson_axg_pdata = {
+	.descs_reg = 0x0,
+	.status_reg = 0x8,
+	.setup_desc_cnt = 3,
+	.hasher_supported = true,
+	.support_192bit_key = true,
+};
+
 static const struct of_device_id meson_crypto_of_match_table[] = {
 	{
 		.compatible = "amlogic,gxl-crypto",
@@ -299,6 +307,10 @@ static const struct of_device_id meson_crypto_of_match_table[] = {
 		.compatible = "amlogic,g12a-crypto",
 		.data = &meson_g12a_pdata,
 	},
+	{
+		.compatible = "amlogic,axg-crypto",
+		.data = &meson_axg_pdata,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, meson_crypto_of_match_table);
-- 
2.34.1

