Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97B92C3277;
	Tue, 24 Jun 2025 13:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773206; cv=none; b=tRRYFE5tRIpOnR/OI/OmIMAVUjieGMEFQR20J42XULJuuwGqlAlYhNrEaKrR29FpEAnS5mZXJv7UAGGc+pZ78Tq5PDZjnDrbTYgO28kNxaWhF8arrryK2O0kwsSr4wqSYqmAs79vt2ZE5qqBrO9GBtjyMtvhPaakoU+PYcVXebA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773206; c=relaxed/simple;
	bh=0oyw5pqYxd62fT5Atb6DVLtHT4tQtNtHm9yrqGoR9H0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WLZP5/ijzCQoAV9If3ruECBiEGXSQQeiOMSsdWWEK5XQO5Q4dECpuGcZ+iTt9HppH6tuRVSG53x8LJDppctqlGTaglJDAkyYOCvAm0MDVTyir/QgA1WTgJtpKgN6kLPqEI8YKsTBFiC6BvIv31pryaacHSjuG+lTt3GG0L38T+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QHRgHmqd; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QHRgHmqd"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-553d52cb80dso5671335e87.1;
        Tue, 24 Jun 2025 06:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773203; x=1751378003; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s+MqIOFNRJ3iFcWe2+ZNr4wPLX6LJuQAzvpwDCjIk/I=;
        b=QHRgHmqdY/H/W3lmW3o9skrkJjvI0hyFGVrE6wVxag8sJtiT1J9YuIT0g1eAx1QgAt
         J0qHC/F+MmsBiXf2g/rynYKezLkhvJE/Hz5nhW8ie0xyD+ISBZpss0O4ldrXLXDiLuzC
         gacTgx/F4UlT1FwYYWza+5zDaULH5l5WOLqESdRs3KpB8nSylH9eBIFL8rLoSvWtmQB2
         i1OqVp3N2MQdVvHsQdW+5/HKpsSd+4HVbzxaC3vslqsaxR04QCEZbzyREUuQPZSDqig0
         R01Vlirj7Am/NIBlG4Nr4L040G/ciXtNvrO0Fw6XamUpeh+f577IZvKjUMvHZVMptRJN
         Rhow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773203; x=1751378003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s+MqIOFNRJ3iFcWe2+ZNr4wPLX6LJuQAzvpwDCjIk/I=;
        b=JL07IjULOB3k/6K7rSbh9L4UFSXZjcugEtySpKzDlBYnDG6BN+heY+YajiDFS6WP5f
         TsuHpxYZhl3mlWWVUq8zPZYm8PSaO8sld1pUgn+UMXB6kQB5X7+TuDalNTvm+/RoeBHN
         nIrp3TGMqBIGIjCwRn4EcDwelaql3aR4m6PHCg0KHbkjDt9CpBaSY3Zqd5bS05cqufDs
         LR8z92G3oZ88g+AhVtRQJtg1OUeHy4rK2qz8ikuB/qSw3lmelp+KZps54aEF3ovHYhmP
         qVEJ3t1sZtz8Y/F+ntJZq81I/ZdC4rA8w3wVWUD/9ty7GySTRSCqglQoV+qjh2inhgss
         GSFw==
X-Forwarded-Encrypted: i=1; AJvYcCU3bv5eBjCcu7yrTnYYC9RdvTzj4Jzh4zpfrEit0fPjErMuXHTQRyxiHjsf7hI/rzwoJI/yIW/DvgxAdJGO@vger.kernel.org, AJvYcCUiPPp+xdojJVp5I26yfTamZmPqHs1DvlavcH9uN+gK4zeF4Ze2LLVOer/DhJ65wj18Iae2l0cXkuUs@vger.kernel.org
X-Gm-Message-State: AOJu0YxJXIPtt5jMM9L3l3mqmLkVtUciyly7FJpBWdCpeRvLLLal2jtu
	ejHu84Z8ANRH58eYEjHgEDI5HVA/L/p528bS/gDUj68u0FsqVCQ3mmmx
X-Gm-Gg: ASbGnctH6elRiOj3ixsjBOKE0Fj4q6YtdEG7GsdcT8ugdPLfG3vhMgybbdk0/In/aNM
	gZPf4li4MWBoUh63tjWVTwggZwdQZgOb2XJrWrKWzNbRrOkhv/jeGACBr+r/7/0qP0Z4f96DoCV
	KKAfoijO6DU/C6o23dwo3BfCcbjaoKqP04F5wUloW8PjXcvz6p0gCjgcIIoarf9dusDbXbFlZqR
	wUfnkXUzrSe2yercYX4hxVcUtjecPxjSG/Lk4MEzKoRN1lyQnHEfdSmqglLIY0iJo2wGMcjS9Pk
	8hLj32KGNwqiIWjBplS0IesNhc/o5hl3VD3sBAIIqmwX4OtmGl67wes44PH3VmoNggouIkumZ04
	aoO+RSzC1HfQwa0bRdZlhGxgyYqzXmSK3OZkgzIHB9u6MayBnJ43wODLayhdWow==
X-Google-Smtp-Source: AGHT+IEG3Nmxe5EPT7OWfXxcoBanx3ekkm42DOccYSN8J0OD87zwEToOOU3f+GyCigT3lhowCdOmDg==
X-Received: by 2002:a05:6512:2395:b0:553:2308:1ac5 with SMTP id 2adb3069b0e04-554f5c817e2mr1016483e87.4.1750773202777;
        Tue, 24 Jun 2025 06:53:22 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:53:22 -0700 (PDT)
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
Subject: [PATCH v12 13/22] crypto: amlogic - Add support for G12-series
Date: Tue, 24 Jun 2025 16:52:05 +0300
Message-Id: <20250624135214.1355051-14-romanov.alexey2000@gmail.com>
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
index 0f4b3db85031..6529ae24b75f 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -282,11 +282,23 @@ static const struct meson_pdata meson_gxl_pdata = {
 	.support_192bit_key = true,
 };
 
+static const struct meson_pdata meson_g12a_pdata = {
+	.descs_reg = 0x0,
+	.status_reg = 0x8,
+	.setup_desc_cnt = 1,
+	.hasher_supported = true,
+	.support_192bit_key = false,
+};
+
 static const struct of_device_id meson_crypto_of_match_table[] = {
 	{
 		.compatible = "amlogic,gxl-crypto",
 		.data = &meson_gxl_pdata,
 	},
+	{
+		.compatible = "amlogic,g12a-crypto",
+		.data = &meson_g12a_pdata,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, meson_crypto_of_match_table);
-- 
2.34.1

