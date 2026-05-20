Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB97434F479
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 07:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779260578; cv=none; b=mQdBM2JlBSo/FzC4V7GKMyeD9mgSeNv67S+0AlGGnA2UGZllkI53l7SmPhmqnd5i9475vGsF2Zkv2j0xJyHc/u3RvCz57Smy7C4NkNrq4uJuQ85WMvKNL4qXloFpzWhW/x+xPPtRWjxyoa+MIHg7nYc1K0bOlV31O3BhmCEPVIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779260578; c=relaxed/simple;
	bh=jB7E5nfjNPtmgBpSkbD9Y+IVyJMEV8LErgJMc6V5lTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mXlkzzSNxE3g4iTE7INyy4GZhc/pB3Xqu5OmiFqn6zsWwdYvKbhKU7FwO3RQkr5yzKSQf8E8scswluiN5VHPH+vjZzvrWzhH6OIppaqIkVY86S7cuS8ANtAwFd3ZLNkHogaJPxuqoL1ei5uMY+nT4ZK2NithtSYl32ZUwzLkbT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=FW9zyL2T; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="FW9zyL2T"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bcceb394417so573399866b.0
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 00:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1779260575; x=1779865375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=10VZpdTCBx/M0y2pbEw8ZF+QedK7xIucV3ceY52PauQ=;
        b=FW9zyL2TAYX5sNv8UeDDibwjUmSMruRciOeMrTSq9uwN4umsQgW9sdKp/NLVro3SwT
         FZJ3tCOWT/GZGhDeKpF/7U+QuldePeZeVxXGq60x19v7uvfAFzqRU2owDBxW/kEPcMm1
         exeLi3cQx64qQM83FmJ+jf00u849O7f0Y5ojaOvNv8tlCKrLpsjw5MNcg/CEAhUav3sy
         h3fbQHJJksC/EYleWE4qZLYANTJhCpjp/uadbFi/FaylX6K8w64wP96WEWz2Ism1hctk
         /qsr8g+bGrPk4/9ZcR+Xjgh4K0e96wZDenJkMsRGAli0R3KwIVOWgg0rlea4M79CqMX4
         rC9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779260575; x=1779865375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=10VZpdTCBx/M0y2pbEw8ZF+QedK7xIucV3ceY52PauQ=;
        b=HqUq0/9eP6WFIXObnfCwQQBSoKCdmkNcKQg5FtvQuIwd+ywcDzSivpncrgCiQcIXR6
         oupgvbsISDael+gUcOyihlJTB+Fks8P9XWdy4PprlKaXdmMfqhfvzGeQdMrT+9ng7Caq
         DktxBH20fZte9pxSxp99WIWXJBeoiScNZXDD7h9NUUjktHiM2rUfQALIrdp8OVAKk4Ms
         Mct5pxmhU5mrEkr2WbuJYe36F5Vj/fTIeOd7k0Ge+MQ8F7Gna56KPEGCcB+fbTwV/Dw4
         JooFZ5x6QNvgnKgKAMaqdGztMJdQw//W+fJBYvxq7JHQSkddr4RV55nZLKT1HkvWprzH
         xg+w==
X-Forwarded-Encrypted: i=1; AFNElJ9iktAdQfJ8R89mDrE9HPv7wzAQlrzksPTOi05xGoM1+aPJ9zWG8jKBzWSuK+ow+4wvWS88u0QWN7BE2FY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrBtdVRRf+ZGziW/J9FjivhNbgQzqh1YuCdnzewyhEXSVyT9hU
	xWPb8QYBLtptC34rNU1/rt7finDMThJ7x7Gz5BFx/XuVvvSyDxQbycNSpz82Av9jAXU=
X-Gm-Gg: Acq92OG6zwJ1SDRRqFk8Et4ViWA0EGcmojoUbxefgTKH2sxr4llx2cVdZC2yXNHPC7+
	pPsxZqGvYZZS5tBhqQsV7UDfw4BUJwW4xErnhM/yHvU7prfEcuJatBtpu60PTr2/WfRTcfpCAP1
	84aRLpZlzDKQUjLwFWjCClXUhR5LLzTVtyVVXkTynFlg9ZX5adpAPOc8DUtEVTe62LbA744Q6kC
	SdlJajvtslNGx3guH4/rVlR5Zy0unsmYohL+igF4+V2j45BOw7sQLYxl5o/Ndzfwz0gpRwn8V2+
	tMGRL+r22EePEALgBD/UUrTDsYgCKM6QYgnWvIClDlLcVdUE24+Rx9FLX9VyiFuZvIVbUSGUzI4
	6hLq1/gtn+qikpozBicjfeFwsHrAZUxTXfdgaY4YC1WmKeTHKV3DMwR+XQlAJGoiFxDz8hnbHJF
	6cjKKTNwaSnakoQ3iT56+jYa/YANbkoql5nIjkf/rKAX1Dy26/FEms+PZ2JLG40DSfuVRThm17O
	aVCuoL+IMTDRAs=
X-Received: by 2002:a17:907:c291:b0:bd5:ca8:768c with SMTP id a640c23a62f3a-bd517964d14mr1300026266b.31.1779260575045;
        Wed, 20 May 2026 00:02:55 -0700 (PDT)
Received: from localhost (p200300f65f47db04a02ef40d8e5825ac.dip0.t-ipconnect.de. [2003:f6:5f47:db04:a02e:f40d:8e58:25ac])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-45d9ec3ac86sm51087688f8f.14.2026.05.20.00.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 00:02:54 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] crypto: atmel-sha204a - Drop of_device_id data
Date: Wed, 20 May 2026 09:01:28 +0200
Message-ID:  <d0fc3069860f9e31122c1af635a1114dd2c443cf.1779260113.git.u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1779260113.git.u.kleine-koenig@baylibre.com>
References: <cover.1779260113.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1047; i=u.kleine-koenig@baylibre.com; h=from:subject:message-id; bh=jB7E5nfjNPtmgBpSkbD9Y+IVyJMEV8LErgJMc6V5lTA=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBqDVxKJT3P658b+AS5o357PwTRM/ZiEOXWRVVRa gzrJzVSyLSJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCag1cSgAKCRCPgPtYfRL+ TiZNB/9Q31kJQFrjfCwVGdjfkoNE/8MqM5OOgAbGQhEDrYEKSvCs/sTRxvNP+7wqgFQ3e6E7Nj2 05VgDTkBMiCExqVsmiflBdvnQZa5ws4iJl1dcTr3aVNyqY1n0HnFH7ixShNLLZD56ydC80dgucR KTEAz0SyNF7PCOdTZFgBUrRLkXDpxlfsIgaDvOA38URNj5xaPMcCb2tPIE07XYeuNRGBPgbAHDi SaoJgvuTK5D1HeUCYbELQz7FqzS9TOWIzFz9ERc08QsdStx3sQCvMs8l5/4rEy2L4GuaIPMbQLi CWwXraR/VDj7lLl+9bJt2R0kp2/n2yry90HqezorqIaD/O1C
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

The driver binds to i2c devices only and thus in the absence of an
assignment for .data in the of_device_id array i2c_get_match_data()
falls back to .driver_data from the i2c_device_id array. So only provide
&atsha204_quality once to reduce duplication.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
---
 drivers/crypto/atmel-sha204a.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 6e6ac4770416..f17e1f6af1a3 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -208,8 +208,8 @@ static void atmel_sha204a_remove(struct i2c_client *client)
 }
 
 static const struct of_device_id atmel_sha204a_dt_ids[] = {
-	{ .compatible = "atmel,atsha204", .data = &atsha204_quality },
-	{ .compatible = "atmel,atsha204a", },
+	{ .compatible = "atmel,atsha204" },
+	{ .compatible = "atmel,atsha204a" },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, atmel_sha204a_dt_ids);
-- 
2.47.3

