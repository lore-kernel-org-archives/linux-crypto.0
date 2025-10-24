Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8490132142E
	for <linux-crypto@vger.kernel.org>; Fri, 24 Oct 2025 17:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761328678; cv=none; b=qHBplq6MUwp3lUYxVlT/jA2vQfmNUUPYV+pwHU4BV9xb/B9hQRMhIJ5oShjld5CqRTuVMjN3m8vDeo7nAvxWJfPi6+znawEpBSZhOojftfjB5v6w/DbeHLkP1CPaTR0X8inj7CS6M+X6G8fu7BYEIw/XjI0F/rH4P5HQVeCZKGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761328678; c=relaxed/simple;
	bh=4HcI+xQ04cvm8dfroX/1IFzvrIibcJujgddriqoyOAg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=rngy/jjdoNQFZQoRIbT5iyrtoa04ralrYCC0rIkjZc9uKyghnU/hDuI71+0yLJ7yelyM/8Dip1ln6Ut6BEvUE1vFBF4BRc7X92C3eU8Mr+nP/kxnW3SPsTecnEh7+XlU685mIOuJ/hTWjlJoqNdJNB6EyPsx8t0vnSWS2B2HvKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wo5RmMXh; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wo5RmMXh"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-46e6a6a5e42so13380675e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 24 Oct 2025 10:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761328675; x=1761933475; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E1Cw/0qGeG89S4JPfX/kPvD9bz7ebzHdRsAEGAL5psg=;
        b=wo5RmMXhGirjWbcfDk95a5SwqEp8Elq/3tjafFUekltCDs315Ab9rLFExrNavUAPWk
         VJXwzDb+r4WN5i0POvw9CGpL98cAM/BS65GxneVaP48xaHfdAEaHXdJT4jQVjSb6kaNG
         87ndUlLjy4/Qg79FTcjlIjET5L4ERDyFB/lOWC+SK2d1W3r95ds1m9hYTFx+6EvUhdO5
         xmnLfl1GkAE69h95OHWSB2QAN+VD8nBN3DiPk0oHUREDs7Xew74gHFEfAY3AH+o1fGpe
         iKdfIM+i+pR/0NVz5eUTss8185RMRz9auFjiwqxktv2mtWjvWK6h71jIe9spldh2k9qF
         HaAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761328675; x=1761933475;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E1Cw/0qGeG89S4JPfX/kPvD9bz7ebzHdRsAEGAL5psg=;
        b=J2Il9kFKPtU+GMd0kF6GC9L9bFMlpIPYPr5/4zvhpk1ha5Nzx63cC/dvlZOuhWxzvF
         k95TaErlf+aLvh71IahraBJeDCI2//ylJuNBGPOGncuyUkxiTSYsltaes5+cqtwSeoD1
         xa+aztgCRhxewG7zXbRM8+jiRZXn/WIUrNmFJyuP4oP90FS1z8bj4y5jkBoDLHspkG0T
         g82LrDhSY8zxhisrP8+vFujONq04v/SAMAtiOIx8tFGbdQQUdKSGvfsvBzRt1mY8zTbY
         IVJk6acL9p+SJEAxdsBbob8fVmpCD7/FIr6S4dMr20A/CkZ3TQ8yXBfbyywUAxG9dLMx
         A06Q==
X-Forwarded-Encrypted: i=1; AJvYcCXwSiQBLfDszg8uRDlrGfKCFneu2LYgVq7ASOeoTKuGxjjLyT+3/erkLx3Kvo6ph6bhEOS9uaj4MR7xBrE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPsyhaoZ96qY3suo2c3dfKZ0KXFoKRFMOLs3TnptZu2jnF5BhP
	AXLb8kHFEJQT9siwxjj/YL++ElS0uuHI08GEiEOySSlwg4UR0rTGRA1pgahQKyGozCY=
X-Gm-Gg: ASbGncteVxhDoA46tX7MXOc0in8KYYX+65QAvQmt+4fEYgVmfK6/PNJV4RHljvILXJN
	VaOiwGJD1cJEn5Vb3fxUhtSIuKZzc4/XV6WWIR5sGvCg308bXA8n1ACH/ux6abFIpQCMosamEsQ
	yl+8D7E2tVErdSZS5IMaMRQ9yM2E1riP2iQv6Tz/pbjOKYzqXI4irXl4SsxaFRqECmmoe+HVNp1
	PoqxXOoTlwHqckNKEw48okvSgLzKigFsgsUEpCgsRPoXz34mArDrpN02VSVSdsItzWVOnSw3W9i
	vzRb3H2osRpJVgVQYgv4UfCJPEE2tYMy6DECrNdqNLJEQkYWe6eEuRK2UDlb0rM8KglonlGPOyS
	fB9oY/NGD4ZFQajJT9R2NILPFT01LoVE3uxDbOJw36rdFuA3aubyPvE283+AU+K4lN0LT5xJzS3
	qfl8UKtO+Y3tU2OCirfYxXBVIIO4PcQhhvl83t8k9pCe4Mw91rOppH5sMMMAg6F36jm9uUpVzxk
	g==
X-Google-Smtp-Source: AGHT+IFQHKbKmCiA6JRzajPPEiW4bwewZWSGp564qjJA3Umx3RZWFZ3rplEvY0S0p6BMt+4hblU9Nw==
X-Received: by 2002:a05:600c:468d:b0:471:95a:60b1 with SMTP id 5b1f17b1804b1-475d2ed6e11mr39293175e9.32.1761328674816;
        Fri, 24 Oct 2025 10:57:54 -0700 (PDT)
Received: from ta2.c.googlers.com (213.53.77.34.bc.googleusercontent.com. [34.77.53.213])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475cad4c81dsm104062465e9.0.2025.10.24.10.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 10:57:54 -0700 (PDT)
From: Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH v3 0/2] hwrng: exynos: enable GS101 TRNG support
Date: Fri, 24 Oct 2025 17:57:33 +0000
Message-Id: <20251024-gs101-trng-v3-0-5d3403738f39@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAA6++2gC/22MQQqDMBAAvyJ7bkp2jTX01H+UHqLGGChJ2UhoE
 f/e6KlCjzMws0Cy7G2Ca7UA2+yTj6FAfaqgn0xwVvihMJCkBiWRcAklipmDE43q2uJQK1JQghf
 b0b/32f1RePJpjvzZ3xk3+3eTUUihNbaWhtZcxv729MFwPEd2sH0y/bbq0FJpe+o6jTXRYNShX
 df1C+e9l5fhAAAA
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
 linux-kernel@vger.kernel.org, Tudor Ambarus <tudor.ambarus@linaro.org>, 
 Krzysztof Kozlowski <krzk@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761328674; l=2729;
 i=tudor.ambarus@linaro.org; s=20241212; h=from:subject:message-id;
 bh=4HcI+xQ04cvm8dfroX/1IFzvrIibcJujgddriqoyOAg=;
 b=PbJqPExUQ4Ee5g5cWPlkn1RWrSJoYIEeJgqcOA1Db2BPtLcVch9Uka1kmOFbzR99vIa+3lscT
 drwax3OOUNVD0O56U4RWU3E3zl342R3GljuOYX1mWVzwYZfNnIcDZnH
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

cat /sys/devices/virtual/misc/hw_random/rng_current
10141400.rng

dd if=/dev/hwrng bs=100000 count=1 > /dev/null
1+0 records in
1+0 records out
100000 bytes (100 kB, 98 KiB) copied, 2.03619 s, 49.1 kB/s

rngtest -c 1000 < /dev/hwrng
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
Changes in v3:
- dt-bindings: put 'power-domains' prop in alphabetic order
- Link to v2: https://lore.kernel.org/r/20251024-gs101-trng-v2-0-c2bb81322da4@linaro.org

Changes in v2:
- dt-bindings: add power-domains. Collect R-b.
- Link to v1: https://lore.kernel.org/r/20251022-gs101-trng-v1-0-8817e2d7a6fc@linaro.org

---
Tudor Ambarus (2):
      dt-bindings: rng: add google,gs101-trng compatible
      arm64: dts: exynos: gs101: add TRNG node

 .../devicetree/bindings/rng/samsung,exynos5250-trng.yaml    | 13 ++++++++++---
 arch/arm64/boot/dts/exynos/google/gs101.dtsi                |  9 +++++++++
 2 files changed, 19 insertions(+), 3 deletions(-)
---
base-commit: 73f7017e663620a616171cc80d62504a624dc4de
change-id: 20251022-gs101-trng-54b710218424

Best regards,
-- 
Tudor Ambarus <tudor.ambarus@linaro.org>

