Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5155D332ED2
	for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 11:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761131983; cv=none; b=UyZatPBuSjsgi3kp4lhM2dN1m94VOjSBx1+LEeIrQK065Y6J43pZApWMFIgrE5ilL6tCmijcdvBtmDBDwFdnecJjhhPthLxb24o6rTyx3MPwFYj87vP98ulvcXLyeP74wVICqX6rcyHtpk2tnB55b40++125WuYVN2uhyupjV+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761131983; c=relaxed/simple;
	bh=d06wTerR1sR2T4EONqcyBchEQMucKU4Nk79E8aTrujQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=jVGmmyJOx8NqiOfFJVbcXkA+aavWzXmga4mBVIAaKmyXfIycknHoN6pHbxyDoNHqu6SIr06QsSYxVaf796/WJoaieEPzxqjUkrVq+fEvqlTt3gaYxTBX8WZpu5hA56/K7ujQYLmfoQ9Lx5+eEZUOcAxXnMhlmcOTZiLF6P2rTbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nPZeZczJ; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nPZeZczJ"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3f0ae439bc3so3585192f8f.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 04:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761131978; x=1761736778; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/T/x7HAWx7iB0lp5HpZ068PQTi7UotyqR4HqE7amHBc=;
        b=nPZeZczJtikRAEHnE4KEXQ3QzM8xdZMyL+IRgnKJPnSDaqHMF+LcOl4sylPHD8shoG
         XlnqkSWzhj9N61qsPc7VJdAbl/oBSi9ftvdh2Xxj8/JIQmoByvOLgc+zZ6jb+EDn1Dp6
         6Mj4KC4msO8XS6z/xP6ld7GR2r0KBW3SJw1473DfR5e6bgoMvlAI0H6ukP+3P4fq6FSQ
         iFdkFDgJgpAZ9BnY0hlsxl/F8WiYieoEydpYIf2PmkGjd8UWs0Q6847Qe7LJSTzZK5hZ
         xwbjA9aWFCKvmJ5X3kMG1lOBq+nsEEFG1ten2UZZal/rk8QYpA9Nyf09oJXRVsKT+dq2
         +RKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761131979; x=1761736779;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/T/x7HAWx7iB0lp5HpZ068PQTi7UotyqR4HqE7amHBc=;
        b=e+9gRJyXEYmZeN6lLX705W3ryCX6jlFUbVuUi3FsaWSUMtVBeQnuEJIimugS3aLFBy
         UCGXQ7y2DSllCf7nYDMUr+h6cH4BiMZUCKVIrTHu1FZYmBXfrri72P9+qE/9YMECk+bB
         fWaWZBsLcodOT1bxSWKT0auQZ31XYjaONMhJMRTswfAmZDhsgP8jcyfrF72mGsouCzKM
         JEZ26BxOY49DdjksJvCiQUxwCQdzzXGcB2e6QfqFmQ20RRsIya5f5e9FkDJQuli3rczp
         Y9MGaKzwo+3rI1xzUQnMYR1Lxh8qVl24bMDayTq1yYe24G7agPaS0ugMWObEQeBu4MW0
         NyGA==
X-Forwarded-Encrypted: i=1; AJvYcCUXZ1fJKw+28nDEqZ/P1lH1ZwdwsRZqmXsSsA/7tjFsYCXo33gIQvMsHQfUocdrZI1iM9W4M6XA5UBVQHw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6Fm27mkYL3ipfMO4inWGluwNdjSVNGZERsgV5c/aYLb3TfT6P
	2uUDe2LQsXdK/+TuZtnmBn7vaHi2rlXy/YIgW6gRNKPh2bcjohrdfgfLCWfnXRoVB1Y=
X-Gm-Gg: ASbGncv4tCQWMH7f9rYjoQyEFGhrINJqGAwB6gW5eKnkN/ZWx/aaaHEfjOHFt88Fwt0
	yhW+3DlgP/Gf/H+1ng3/qbEtXDy6i6vvH7r7Evvx8NQXk2xNtI+PRO5SRv+ihVQGk5+4an+YrJs
	3oEEGiztcieeKjPXepKHnaa/xy5JSM7j3RyES+ffnGqTUD7F7Vn8v4Mb3wcYbkFkLhFYz0zrAFc
	pFVxCh4BEa6LmApJPXVSDLph2r5/BnA1qrnthDvGawuQJj1lF5OS9APJf4oiwb0xOAUS9oRNmmU
	cgeZKZfaT71irV5uCIZnnUZGSYhlQEdHMIrMkebjT5S1KP2k1WoKQOZ6sLiWA7gon2LWqJHpLxY
	HXPpoTLgHYmeL1MKIStEQJlqE77bQ1oPixAIMO+BSrIU/uXkmMKCBvyx6Lymjntl4eZtf5+CHAN
	3ghwIfTdx//rpUrZ9GKFZuLfDe4mv4jOmciOzN/GdQv36JYqVBXD8g
X-Google-Smtp-Source: AGHT+IGv86ynL42pHYdUKBw9RuU6yCngSbjdQh4SHsDnbLpVSdE137PiVhtffxXXGOOfiMwcQOf4Gg==
X-Received: by 2002:a05:6000:24c9:b0:426:d549:5861 with SMTP id ffacd0b85a97d-42704e029bcmr15217601f8f.42.1761131978148;
        Wed, 22 Oct 2025 04:19:38 -0700 (PDT)
Received: from ta2.c.googlers.com (213.53.77.34.bc.googleusercontent.com. [34.77.53.213])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f009a78csm24820692f8f.26.2025.10.22.04.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 04:19:37 -0700 (PDT)
From: Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 0/2] hwrng: exynos: enable GS101 TRNG support
Date: Wed, 22 Oct 2025 11:19:34 +0000
Message-Id: <20251022-gs101-trng-v1-0-8817e2d7a6fc@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAMa9+GgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1NDAyMj3fRiQwND3ZKivHRdU5Mkc6CYoYWJkYkSUENBUWpaZgXYsOjY2lo
 ANfjsVVwAAAA=
X-Change-ID: 20251022-gs101-trng-54b710218424
To: =?utf-8?q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Peter Griffin <peter.griffin@linaro.org>, 
 =?utf-8?q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>, semen.protsenko@linaro.org, 
 willmcvicker@google.com, kernel-team@android.com, 
 linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Tudor Ambarus <tudor.ambarus@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761131977; l=2271;
 i=tudor.ambarus@linaro.org; s=20241212; h=from:subject:message-id;
 bh=d06wTerR1sR2T4EONqcyBchEQMucKU4Nk79E8aTrujQ=;
 b=IayhEy+ddWFifvTeb3lqukHgT/sBVfIIGHwKHkGUx79QsEmrV9yt+ClYCAmmEUlOhpghFHU3G
 ur6VZXs4GzcCQwFr/ye1jOP0bndyBkeKexTNX8yhHUO+6Cu2vG0XAR7
X-Developer-Key: i=tudor.ambarus@linaro.org; a=ed25519;
 pk=uQzE0NXo3dIjeowMTOPCpIiPHEz12IA/MbyzrZVh9WI=

Hi,

I propose the bindings to go through the Samsung tree as well so that we
can match the compatible with the schema when pulling the DT patch.

Thanks!
ta

---
Enable GS101 TRNG support. It works well with the current Exynos850 TRNG
support. Tested on pixel 6 like this:

10141400.rng

1+0 records in
1+0 records out
100000 bytes (100 kB, 98 KiB) copied, 2.03619 s, 49.1 kB/s

rngtest 6.17
...
rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 1000
rngtest: FIPS 140-2 failures: 0
rngtest: FIPS 140-2(2001-10-10) Monobit: 0
rngtest: FIPS 140-2(2001-10-10) Poker: 0
rngtest: FIPS 140-2(2001-10-10) Runs: 0
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=380.570; avg=385.422; max=386.964)Kibits/s
rngtest: FIPS tests speed: (min=75.092; avg=81.784; max=84.771)Mibits/s
rngtest: Program run time: 50908949 microseconds

To: Łukasz Stelmach <l.stelmach@samsung.com>
To: Olivia Mackall <olivia@selenic.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
To: Rob Herring <robh@kernel.org>
To: Krzysztof Kozlowski <krzk+dt@kernel.org>
To: Conor Dooley <conor+dt@kernel.org>
To: Alim Akhtar <alim.akhtar@samsung.com>
To: Peter Griffin <peter.griffin@linaro.org>
To: André Draszik <andre.draszik@linaro.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: semen.protsenko@linaro.org
Cc: willmcvicker@google.com
Cc: kernel-team@android.com
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>

---
Tudor Ambarus (2):
      dt-bindings: rng: add google,gs101-trng compatible
      arm64: dts: exynos: gs101: add TRNG node

 .../devicetree/bindings/rng/samsung,exynos5250-trng.yaml       | 10 +++++++---
 arch/arm64/boot/dts/exynos/google/gs101.dtsi                   |  9 +++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)
---
base-commit: 8ebc2add3e2d076adc5cc3e8c9bef268f7f1cb31
change-id: 20251022-gs101-trng-54b710218424

Best regards,
-- 
Tudor Ambarus <tudor.ambarus@linaro.org>

