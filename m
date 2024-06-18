Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8228716D32D
	for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 20:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718743527; cv=none; b=JNwBA1r/xFCiMnmNVIcnUuGJYPhbANzTHzil2hVpiC70JNGjJhPyjn8W7wQbKalXqgEa06sG9W/fvOH/XtrnfTOFeaP2htn6252OpiMhLVAdORAmTsgWbcAouyCpnTtEMEoRLPPwqP8ch2IKtnU9Orv4JQu912BmtUNKHKrXqP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718743527; c=relaxed/simple;
	bh=z1UyjqdAyG0LPVZ5wG40NVLSXp+qn3yQzxOTXQ/gFjQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=X2lYbBiavZSv2dzvw4raaCMNYpqZMIxcUi2N8F66b2i/yJrJ2xqTrlGiOb0YBfrSFl9mf4AmUSKGKwQaTgtGdPUwHPckE+azkIjY4PRlXfeNdyaQh8rdNzPp/63K5AiFrqVRcz/SSV9raYF2vr1xulGZDaJtSrklYgSzASjX258=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Rg9FeT+7; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Rg9FeT+7"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-259884ef4ddso408136fac.2
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 13:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718743524; x=1719348324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JhcEpUixYW1NlD8vTPxrTj/5Uvw5ZqhDNkVhL4sqgko=;
        b=Rg9FeT+7RruPCgAHq/kcseEtTwCRg78pmXU9nPUAJh4ywffkhonr/P9vH3AAUlh8Qv
         E/+5aYnHmE5xOsXDQHGXQTn9O3JY47upIx8KoffVuVOoxIHwekD+gm2Cowvi2tjfdfnB
         rnkaxx/ngGJAfQxPDMFXPB4xucTMzJXr7K7xxQ97Ruwvre2G6QpUMtbAMIe+6UVuHGcM
         1KYF2SJi4Xl5VLMtu8Wxh7SbNabisyEB4TttxI3nmJ5wv2sMrikbmvgf/R1OvoNTgugh
         x1xI590/yyYO9USFG/zQ25x2Aad007vQgu9KSzGVLomfaPZy3a5TAlCIQdqELGdQdsJ5
         USkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718743524; x=1719348324;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JhcEpUixYW1NlD8vTPxrTj/5Uvw5ZqhDNkVhL4sqgko=;
        b=UHSbuoKqad7iKopfuclIzWAVAg9t65HKKW1Zq0Q9+Zb7wr0+4KbiktWiq2/dSXgF4U
         rX3lSdfIgH1BEQt30TP5ljAGBqOYRTmfXfvydurX6t/7egaAbOvmJSJ6s5c/el1ec+84
         hCt+MzM79VyTk6r+iebtv4nVneF8ZqhUOWIcvTBmg5ZB9JJs1MW0ZXS6Evw4RuunA0I/
         5VsLSdgX2oShPossBXEPec1S0T45O1uSCiUfL1ItVzW+1EHBOBevIFFvKn2q1HQGxJFh
         PVI8FSHfFnDuJEU2zEv+7cQ6SCMoByDzhQO55yK0a6umwkqh9K3hx1f5pUL5RVpXPE+H
         EPSA==
X-Forwarded-Encrypted: i=1; AJvYcCWn6CpUKbjlaFfxV9YxlIDLjlmMlWYb4pvaRNUSiZ53uGbM3lVGIfIPSKXj+XAgNbIUkhxZ7XGPPDkqRNPtb87gZmSif9/8OHZP1Yzu
X-Gm-Message-State: AOJu0Yyyvcxtk8WdUIEx2xJnD9OXIZ8GW4T7BuSJB5M51LyinSYveN+3
	asvh7leVRfoiy8L9aEQx1+Q4gYOnXiWE5z72Fdz319nHqSKSH5chEhthGBWATlw=
X-Google-Smtp-Source: AGHT+IF2pnET8e+kKpto1cAvMwXd1n2tX30Z+TpufXJVT8R7Pig00Ik8aCpU+HEcP1N7AhulSTEWpw==
X-Received: by 2002:a05:6870:7013:b0:254:a778:6fbd with SMTP id 586e51a60fabf-25c94901c85mr1114518fac.6.1718743524442;
        Tue, 18 Jun 2024 13:45:24 -0700 (PDT)
Received: from localhost ([136.62.192.75])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6fb5b1f57a1sm1971383a34.46.2024.06.18.13.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 13:45:24 -0700 (PDT)
From: Sam Protsenko <semen.protsenko@linaro.org>
To: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: Anand Moon <linux.amoon@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] hwrng: exynos: Add support for Exynos850
Date: Tue, 18 Jun 2024 15:45:16 -0500
Message-Id: <20240618204523.9563-1-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Exynos850 has True Random Number Generator (TRNG) block which is very
similar to Exynos5250 for which the driver already exists
(exynos-trng.c). There are two differences though:
  1. Additional SSS PCLK clock has to be enabled to make TRNG registers
     accessible.
  2. All SSS registers (including TRNG area) are protected with
     TrustZone and can only be accessed from EL3 monitor. So the
     corresponding SMC calls have to be used instead to interact with
     TRNG block.

This patch series enables TRNG support on Exynos850 SoC. It was tested
on the E850-96 board running Debian rootfs like this:

    8<-------------------------------------------------------------->8
    # cat /sys/devices/virtual/misc/hw_random/rng_current
    12081400.rng

    # dd if=/dev/hwrng bs=100000 count=1 > /dev/null
    ...
    122KB/s

    # apt install rng-tools5
    # rngtest -c 1000 < /dev/hwrng
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
    rngtest: input channel speed: (min=941.855; avg=965.515;
             max=968.236)Kibits/s
    rngtest: FIPS tests speed: (min=49.542; avg=52.886;
             max=53.577)Mibits/s
    rngtest: Program run time: 20590194 microseconds
    8<-------------------------------------------------------------->8

Changes in v2:
  - Removed the patch for renaming the dt-bindings doc file
  - Added the patch for using devm_clk_get_enabled() to get the clock
  - Addressed all review comments for v1 series

Sam Protsenko (7):
  dt-bindings: rng: Add Exynos850 support to exynos-trng
  hwrng: exynos: Improve coding style
  hwrng: exynos: Use devm_clk_get_enabled() to get the clock
  hwrng: exynos: Implement bus clock control
  hwrng: exynos: Add SMC based TRNG operation
  hwrng: exynos: Enable Exynos850 support
  arm64: dts: exynos850: Enable TRNG

 .../bindings/rng/samsung,exynos5250-trng.yaml |  40 +++-
 arch/arm64/boot/dts/exynos/exynos850.dtsi     |   8 +
 drivers/char/hw_random/exynos-trng.c          | 216 +++++++++++++-----
 3 files changed, 206 insertions(+), 58 deletions(-)

-- 
2.39.2

