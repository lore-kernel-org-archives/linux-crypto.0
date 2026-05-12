Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104023A16BE
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 22:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778625852; cv=none; b=mJbu4Mx1gcmyYfv7BaIjP191My2sw3j4cr7BXu4/XzvxBqJhL8jII87zi4xFfYDPxMOMbzYcRYc+mI4DNQjGqpRfByxT9aSIJEQEMxfPDwZKXTuJe6YXcg8qeRowYvG1WVZQbLiHODX1L7MyzUo8EvG1hG04Srv+ZrbW297IjvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778625852; c=relaxed/simple;
	bh=Iygz6kxtjgTJhJ/FVqNj8TG+65E7r4WPqcUg1cz3yPo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sJ1+Rc1DnN6pJjfHeC1boTIdeiJgMZF3ieCGZB+9FPpZd0YgS4AfCbRbNLlA6nvjjh6VhHui3m69b+3+b4Jo/nhtophgc1HL+vZ7spMy0QuhC7OUgVHMlzBZYAcjlgS6RvFG/EjecoKc28N2kItYe80e8DTTVGIGMlzDRaEi2kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yuzmrjs6; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yuzmrjs6"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48910865133so5132055e9.2
        for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 15:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778625847; x=1779230647; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cPxmplJASoE7i3DAWTstEUF/mwjYvLDna7DGnqxuUrc=;
        b=Yuzmrjs6S4iY60MHmjV3pbA+KA+ZqS6qzmqdgTm+tTJkcNIKUV6ACY7sH0zUX/A65F
         QWt1bodBI46dWhjssWSHomeBi8j8r9PaTHnkkSDDjliEpVLKnLwUsecdP4IFv4vA9mxg
         YPZu5t5j9M3GzRtBrPFVmzBddmrvwt13o0fxLat9Vl+AgJr6j/xTwI76ZINScRMjd7Ge
         KPUrJECgYyRg6YJTkvrGnhGHGkHMi8+OP36qgnRiWxF2m9YhfBYZQC8zfPI+bUYKRjaF
         PyBmspTOIgL3RJCk9J0Djv+O4AZBIruLRDB7BMU9h8+i/n6W+XffLpenSUvIH3HBiaq+
         LeLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778625847; x=1779230647;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cPxmplJASoE7i3DAWTstEUF/mwjYvLDna7DGnqxuUrc=;
        b=J9UrFwhZqbmOKWQZbp73PvvQeX5dggjzDIfO8A/uvNZ/OA7wu1nOZqv3GTQ0rf7w/3
         fRw/jFatIvwCkg7fzMmRDsxbjYVlT5ZzlmVS8kAzuJruaG2wjj8/Wd14uUoxk0I3xjgZ
         2yt2m9eg4hFfU9OM7h0ELvFnvwogz0pnBUgHCBGX0XYKqTB1TLfBLsUS8phZiq2n4zU3
         Lfob/td4IbptRcAvUAxlvA9XaNIE9bz7iFsM7M7bMiMte0txGD1tCbU1flIS3Uqv4jM4
         9OR/00ruotLoEBF34IwKO3Dm7Dl5g/blAz3BVPCBqMfOSQDLs8M5m3ExjIHWZYh9n2vl
         Zy6A==
X-Gm-Message-State: AOJu0YwJS7NneWDMfeuP47vb8/V5vgs0951y6qv2hmsnKOkoEm5DF0T1
	Y99PH8eB+Lpsi27qAwExseHjTbQ4UJnwfCLM6GB/DZPnYeW8+yMXbeE2
X-Gm-Gg: Acq92OHfUr7bsDKxBFX1Tnqegdl427RWne2U3OieayCw6DoSJ+Z2JKrWHlXtNb2949w
	069wPZavjU/4O/Wx+fB3/9EbcWhHYcHnNg28LMrOadgFAVUAa3FN2XY6P359VShmKy9uSDZkw9g
	Nldf3HR+T5/vJtEBFiqOoOoZxebl+JsRlgdXpUrONdGJKImAN3h1M8qwe+clLCMbFLpW0OHeMXw
	ZnPq20z3bWevv9/Iq4gQ27+DTMcjgNp0YxMLBKgSnIhrDyzegcNdVL7eNwkajJwa7D1ix23j3/J
	5NW8tGBZnCIA7j4lA00/UWEAPzK6lJ5slFAdZvbFGVruBpfWqjWHdRFbXjcyKbF197eCzZXwHeG
	2MniAE/vwegqW6aTlFvmIKQa14QJ9/JoYLZC5pCWNaoooGXZx8o9Vq0LdVkEoffs7fBAOAKymiY
	al3Q+R9VJ+foXOtA9VPmKJkOZolEcm+VLLyPTWYr+ueWNH4S8ivvU9uoa/k8PjXwc=
X-Received: by 2002:a05:600c:c4b7:b0:48a:6848:527 with SMTP id 5b1f17b1804b1-48fc9a4e9f5mr4178665e9.7.1778625847438;
        Tue, 12 May 2026 15:44:07 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fce385ea5sm3194025e9.14.2026.05.12.15.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 15:44:07 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH 00/12] crypto: atmel - refactor common i2c support and add SHA256 ahash support
Date: Tue, 12 May 2026 22:43:37 +0000
Message-Id: <20260512224349.64621-1-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series restructures the Atmel secure element drivers around a
shared atmel-i2c core and adds SHA256 ahash support for ATSHA204A and
ECC based devices.

The existing drivers duplicated substantial parts of the transport,
RNG, EEPROM and device management logic. This series consolidates the
common functionality into the shared i2c core and converts the client
drivers to capability based allocation.

The series also introduces per-device timing configuration through
match data, moves sanity checks and RNG handling into the core driver,
updates workqueue handling and cleans up internal constants and helper
definitions.

The final patch adds SHA256 ahash support using the hardware SHA engine
provided by the devices.

ATSHA204A devices require software-side SHA256 padding according to
FIPS 180-4, while newer ECC devices provide a dedicated SHA final
command and perform padding internally in hardware.

Supporting the SHA engine also requires changes to the command
transport path. SHA operations must execute as a strict uninterrupted
sequence consisting of SHA INIT, one or more SHA COMPUTE commands and,
for ECC devices, a terminating SHA FINAL command. The device loses its
internal SHA state if it enters sleep mode or if unrelated commands
are interleaved during the transaction.

To satisfy these hardware requirements, the send/receive path is split
into a low-level transfer helper and a higher-level wrapper managing
wakeup, sleep and locking. SHA operations keep the device awake and
hold the i2c lock for the full duration of the hashing transaction.

The series has been tested on ATSHA204A and ATECC508A devices.
Tests are ongoing/pending on ATECC608A and ATECC608B.
---
Lothar Rubusch (12):
  crypto: atmel - introduce shared I2C client management
  crypto: atmel - move capability-based client allocation into i2c core
  crypto: atmel - remove obsolete CONFIG_OF guard
  crypto: atmel - add per-device timing and match-data driven
    configuration
  crypto: atmel - move RNG support into common i2c core
  crypto: atmel - move EEPROM access support into common i2c core
  crypto: atmel - expose CONFIG zone through sysfs
  crypto: atmel - move device sanity check to core driver
  crypto: atmel - check client data in remove callbacks
  crypto: atmel - update workqueue flags and add flush on exit
  crypto: atmel - refactor and localize driver constants
  crypto: atmel - add SHA256 ahash support

 drivers/crypto/atmel-ecc.c     | 252 +++++++-----
 drivers/crypto/atmel-i2c.c     | 679 +++++++++++++++++++++++++++++----
 drivers/crypto/atmel-i2c.h     | 180 +++++----
 drivers/crypto/atmel-sha204a.c | 284 +++++++-------
 4 files changed, 1010 insertions(+), 385 deletions(-)

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>

base-commit: f7dd32c5179d7755de18e21d5674b08f9e5cb180
-- 
2.53.0

