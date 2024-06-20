Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FDE14387C
	for <linux-crypto@vger.kernel.org>; Thu, 20 Jun 2024 23:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718925223; cv=none; b=saEw52WoyZdYeYrtftQXZswvx5iFqBwvpKkDUfWjen8OUFc6EcjaE9YsOzIcRyDoBnFTrqzjNczx+jXRKGy0If8L9KUkMREkuEl3J72idJfgiE6zmmNbT0UCxPa3IDeVLf8khhrtaKxV1QsPT4Cbk/ciGXc8KqtT76pveBnisB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718925223; c=relaxed/simple;
	bh=7FK5A+P6y84XNMixDpkIf7uj9kSH1cgpl+CxUYDO8Vk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=fJoGBBpgaELrvbZqyj9l3H8El/Qt6CCoEK7GBUfvTJLV3i6vRyR71N05HAavNQ+SBxLeGyxx3NOAG6PB7MTLSE9VY8n3/FltRdPV43jE+iti/DYNQTt8n73Ai87xzYxBk3HeImAWfpQ2uyIwp9k8WHS4N3cpRmD/jdZsdPomhxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dq2OSXcn; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dq2OSXcn"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6fa0edb64bdso740133a34.1
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jun 2024 16:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718925220; x=1719530020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NpwkSv9KEC+Z0xSBroaOsC+eSM7dr3lxu3/BMAtc54s=;
        b=dq2OSXcnAbDwSQT+YWK/8VTgpWCzgPwNPi4RJoVl+6cYnxnZ7tNu5OL8SNTqs+S+0+
         cIVDPm9GDNsALkx2L0yK+C49F4d4XaPUlJ9+Gko25ClWCjhlgCUd8VEcyBJ+58zQShJH
         qexLCMeXuDo5jIAVoRoXKzgwmHbiR6T/O6VAYhPkD6fq5wKm5deUP+88TSlurt/CMXyv
         exDTki1ol7kc8dlWo33sjdiPJx5AEzWzkMBDORF1plUoQEk9nxIgE40y7F8nHm1Quajq
         JU7Lx2bXj4nV+xmvX0FC30zIcAecC0mDA181CKKiYsknKXySiYvoEJcAjvEOrYwyHJfg
         F92g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718925220; x=1719530020;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NpwkSv9KEC+Z0xSBroaOsC+eSM7dr3lxu3/BMAtc54s=;
        b=WfcdglEjK04z+bXWElX/ijPXYyIXTu0aL+ItHXAFSvgUZdHlgV9fA5xBRL4i+/tC6U
         h02etjRFayRHKvN3eSymfFFIllKMEwr/4l/IwV/oIMONXBoaC2Q/id+L0tFzzLYzzUEe
         6C6HV3PQ5EzINXfnexpyYD83o7z8vGTy/dmJb2J9Jw+Z+dT0gZijOMDY5J4apeFJ/HXn
         mtWpFtMkx1zN2SdZ7iyHttYqgvgCcQIC/5tGPGGnYpfwpptXzmgXLIAGwO1X3t3X8C24
         1vOIBetkAT2en+9VqeXt6DfUasZ5sy7++nllXdrY4xZhGnmjfA9EnXW3kmL/hc9+WyBO
         7XHw==
X-Forwarded-Encrypted: i=1; AJvYcCULDlwe3mDYPY8fAnd5jvP2HjTS2qD9YMNWTB+0YCTYflnLW/JQcR+5Bc11aveKkpowsbjerwnorkyYk2EgswNjyZEc1cjhhj/u65bt
X-Gm-Message-State: AOJu0YyR554/DB7Z4mBcTN/niplgSegECiNNBH5oBBq3VRCosXAfJ0Tt
	Xn7qaf9IoczZ2StgwkOoPsOXBWVyBK75/mKd6LaUuVxg13m5Km4ChYQSf3G8NeM=
X-Google-Smtp-Source: AGHT+IEzPzN/aMnfj5b73omu5ib7OPwkka1Y2/64FBGQsxHICvhZtCMGfoJmvMptfycgLlXfEvq8pw==
X-Received: by 2002:a9d:6510:0:b0:6fd:6240:9dba with SMTP id 46e09a7af769-70074ebf134mr6416843a34.16.1718925219979;
        Thu, 20 Jun 2024 16:13:39 -0700 (PDT)
Received: from localhost ([136.62.192.75])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7009c5df34fsm89509a34.3.2024.06.20.16.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 16:13:39 -0700 (PDT)
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
Subject: [PATCH v3 0/6] hwrng: exynos: Add support for Exynos850
Date: Thu, 20 Jun 2024 18:13:33 -0500
Message-Id: <20240620231339.1574-1-semen.protsenko@linaro.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

SMC commands added in this series require LDFW (Loadable Firmware) to be
loaded by the bootloader. In case of E850-96 board, at the moment only
the LittleKernel based bootloader [1] is able to load LDFW. It is
expected to be added into U-Boot port soon as well. See [2] for more
details.

[1] https://gitlab.com/Linaro/96boards/e850-96/lk
[2] https://docs.u-boot.org/en/latest/board/samsung/e850-96.html

Changes in v3:
  - Rebased on top of the most recent linux-next
  - Removed dts patch (7/7) from the series, as suggested by Krzysztof
  - Addressed all review comments for v2 series

Changes in v2:
  - Removed the patch for renaming the dt-bindings doc file
  - Added the patch for using devm_clk_get_enabled() to get the clock
  - Addressed all review comments for v1 series

Sam Protsenko (6):
  dt-bindings: rng: Add Exynos850 support to exynos-trng
  hwrng: exynos: Improve coding style
  hwrng: exynos: Use devm_clk_get_enabled() to get the clock
  hwrng: exynos: Implement bus clock control
  hwrng: exynos: Add SMC based TRNG operation
  hwrng: exynos: Enable Exynos850 support

 .../bindings/rng/samsung,exynos5250-trng.yaml |  40 +++-
 drivers/char/hw_random/exynos-trng.c          | 225 +++++++++++++-----
 2 files changed, 206 insertions(+), 59 deletions(-)

-- 
2.39.2

