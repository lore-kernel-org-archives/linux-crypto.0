Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BC62D9EC4;
	Tue, 24 Jun 2025 13:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773209; cv=none; b=Rf2es8FgNjKpJhg7d9zEhRNXxlivkcqKyoJzdJkMT9SUsv+6kwjol4AxALCYQ1cKz6OCCZquYAPxLfox0f1iD42dqLA4WRp2QzckNURqpocIZeI5SvOpdZkH98A/aey+x60M5S/TNEA8ndSn3EL61HOWjToZssuCtepYmnfIAT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773209; c=relaxed/simple;
	bh=fSeZdx7/xTUHYwFlQuI2HrbMiEC0GcM6M74lWmTnauU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lyJhPOABhN8YIVpqC2XT/vriDk/lFEMYRlSqkIfI7RhreuVGdiLYIi4MYMu4GYXsnwTO1/JYODbw+NL3bE+NUh/0/ANFyig0A8PDKOFuLbokjlUrsydP9GEf8q3MhaHZyVRK+32lV+aW5Ac0lv1SYkAxIX5BysYZhgOaqW7+b7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DOvU708c; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DOvU708c"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-32b78b5aa39so56401611fa.1;
        Tue, 24 Jun 2025 06:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773206; x=1751378006; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2wX4W0I+7Z0KtrMiti+/n9dziiQ8RSkVplIT9xlgIJQ=;
        b=DOvU708cadQzHMmA/2FERTjXsziTEnKYhD7iqkBqiajvBmgLH8mNY/7mc6LM2e/GTb
         goBDBXD02mVmX+StH0PrikktzoJXlvHnyQ5R7rHKgpY5EJOZJIlky+s3SddgwoDBjibB
         guZu/bzH2/ptctMMGH/8ILTP+H5H+YHJiLnDKxUW4iqa/mp4RLEzC0tzEvHbw6OOPYt0
         vOpu8H17NSVzmuqOZlOFQInFUidantI+XK1/S93jSVMJSkWPSUfnnjtV0Q3r6mJYmYop
         NVJjAnLD0rmzABpqLfRG7DfDqaM2T5IY9aViTXXCvxUhqcC2XLl6nSPaEC8xYuzxt2Gb
         eDJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773206; x=1751378006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2wX4W0I+7Z0KtrMiti+/n9dziiQ8RSkVplIT9xlgIJQ=;
        b=j+o9vScIYkyphIoSYTYGwnieNsUTPqVmkJlyUq5ELK6KotFzoU7qodnCK0xkqvgjDR
         TMCyCw55JGPW9nIrNH69wgBAPFK1JexgGOYZbqXnAZee6vCCc4n8NNnJ/GMrhuFhVfYI
         D4LhJ8Wh9/7SCpc8a7wBU9OeeHlRYiXuaZL2tqQcBAVh1cL4ikp2YyV6I5yJI+DGZrwQ
         goE2UVf2kO+JQoEOTNQV56/Pid0d6o+u8O4a+GBLX+AcagwDikbf8C42n8pW6+ao/qiX
         iML3VRj+sAgCWpoP+rIiozHUG9QGVjCTtHoqmxTI/ogKMBTz/LfL5/nFdpRkTCKHmJ8t
         QWCg==
X-Forwarded-Encrypted: i=1; AJvYcCXjTwVioZ6jz80s4PKa3dWYAOt1+Car1XU4dEoyl48mo1NhWZQs7PLGp2dDGNgkGYQLcb6Cn3HdTkgm5U+a@vger.kernel.org, AJvYcCXmt5A8VmD2HDgqTezBRo1C1OM6eRT+fUZ/gr9qPMoaYQoMtqhBO4T9+EFhYfpdSVVnAeX7B5HScPa3@vger.kernel.org
X-Gm-Message-State: AOJu0YwvalkqVvygCQIJpv5cYPLtn2amI1yq3zGKMeUUGVvJcyQIhui7
	9l1hFcLPV52rftRJbbw8ZYSmSpiYpYuc+R16LmHHLgt40MopnRZbaboQ
X-Gm-Gg: ASbGncvBZgjTd8v0oSKPQ6gLy8YLUdV9THSkByrArlo1nLBHhyeVRd2PA2Yd0ayemDS
	SU22lTVk/J9bCG2i/jEK0olV1eXEezpbfAbUYapM+lXtgeD1M5LOPSuUjDT6JZeYfpGsfAhL4Xp
	z72tDHmFt6aVPAomhvQGVWT1kCBBqX4JJKzCHC2PyHYf7QUVNlF+zzSaACnRcsG5GG7XHQBj0F7
	4ZyHEaI4mWqJaN4ynzGjTnG+AAyF3vQFaohlALTxTb2ROh04PX/j22dyG1gBFEa7SUy7gMYb9YP
	GtSaoMWIThCruu6hqNdGjyPmRaEJSJhDbsq85QFFuFNHjIHk/ooJ+OlN1ICxWCSPG6c6GLnxOt3
	2XnJD+wDjlwUwhIwNTmYCAlbdk5h/jEgqIcuxEHS+WwxpXjxfoqvGrDN/hUie0Q==
X-Google-Smtp-Source: AGHT+IEQJZnJ9VZ+SzWrpy1cDVFBdhya8UkwmDkT4ryLdnwY06/Wc9BOqbcHUd4bE5urYlG3ueC5CA==
X-Received: by 2002:a05:6512:3f27:b0:553:1f90:cca4 with SMTP id 2adb3069b0e04-553e3bb2933mr4766415e87.13.1750773205840;
        Tue, 24 Jun 2025 06:53:25 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:53:25 -0700 (PDT)
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
Subject: [PATCH v12 15/22] crypto: amlogic - Add support for A1-series
Date: Tue, 24 Jun 2025 16:52:07 +0300
Message-Id: <20250624135214.1355051-16-romanov.alexey2000@gmail.com>
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

This platform data also can be used for S4 as fallback.
Tested via tcrypt module and with custom tests.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 9452f05d2f10..55a35697c0d7 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -298,6 +298,14 @@ static const struct meson_pdata meson_axg_pdata = {
 	.support_192bit_key = true,
 };
 
+static const struct meson_pdata meson_a1_pdata = {
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
@@ -311,6 +319,14 @@ static const struct of_device_id meson_crypto_of_match_table[] = {
 		.compatible = "amlogic,axg-crypto",
 		.data = &meson_axg_pdata,
 	},
+	{
+		.compatible = "amlogic,a1-crypto",
+		.data = &meson_a1_pdata,
+	},
+	{
+		.compatible = "amlogic,s4-crypto",
+		.data = &meson_a1_pdata,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, meson_crypto_of_match_table);
-- 
2.34.1

