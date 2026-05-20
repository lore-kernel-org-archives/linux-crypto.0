Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA84331A48
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 15:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779292632; cv=none; b=WbC2DPULVCgJyMq77m04Sng8PaFEm1nDVjlCRZGbCKpFyjmvngNd+Ntujyb4II01hNg4QlT0W67KABRtmndaQq06CO5QzVeDAVhKfnIDSfmXhcACCcrCCQlACuHGyfyVi1IjHleAyIFZzdbuTpIzuu7OGG0Ambeuoqjrze3QeNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779292632; c=relaxed/simple;
	bh=MDuCqjxEvtSz1a5joUgErWDDffdjqGelBHkZFN1Bm+g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Xkeben1zxHonuIjEInC5OosCofw96cbOf1ZEztGpaTPJ7zH2vSEWPQSjv2berRix0jQnUNR22UGqzOsRGduXzNG7gYslG5+vi/C8kISiM9dKRMCY2UGb5ZyNwZkZ7Wv8SGtEBLVUvX7RneIDufN389TjctPSRNboEURtXcNjV5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DhhJy7Y0; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DhhJy7Y0"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488ac04e13dso4569435e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 08:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779292628; x=1779897428; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sTdz/Q/V1ezxHBxxkTwCW/MFW2KhgBZJoQk8ObwQ99w=;
        b=DhhJy7Y0nZbyms4mNdOmbgN6msrgmcKH2UpqRLmuXFrnjvgKaeyCc8+K9muED5Tm1z
         CgIeyhuGq0GQ3nwDxn4Fiu0dVSQgim7SX9/0QSzO6oN4Lbh3Np01KpsxdfJxBwuWK0xu
         CDzwASBkqj5U9DzlaO4peY4DHPAl6swcHXGbEsapxnMOsxj814Qay+KMKpjBv25h31mC
         fj8gl6oN1q94AfbrT1WhhFEa1ajoC3nPqoex7R7KwDnVphK1NiY76I6ZaBvs3T75H/kD
         K1Ho5+clrrGlhxV1UTEniV+AkixnT3EJ+U9EEJ/vuMMU1td4Mxeh7RiXdY98X1Ioc4wO
         10tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779292628; x=1779897428;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sTdz/Q/V1ezxHBxxkTwCW/MFW2KhgBZJoQk8ObwQ99w=;
        b=b/ZkErcmJ8JxBUaOZeZoD1fyxjfIF7/ANU2iz58Z9RBkqJpzIXjUr0Ol27sUKKy6hB
         Ig9p70zzUSMFGt8pnN8GxP8TEGVzLwTNroYHl9PmzGHCSDp9jjBljU/zJ1PH86yNAzGB
         wt6LbpyS/JvEki3Ra4e0RhRd1Spa1qkraiRva5dEjdER60kmr3Zb/8WRjS5AJBcRdpJA
         kcMrGkVj5tKFP98D6qcL+E0mw7689FrF0Ex/cAAhUnrYnNjMW3h2pXL/Dzm8JXgZOmhy
         gcSicliKYVPPeGceG9+48tLmvXg1Fj5uJuEJqUVGn28M136+4FZ1PsGUdBIHHxATSMrX
         oAJQ==
X-Gm-Message-State: AOJu0Yz75EfAqyMCfJOrk4m4gbH67dO1i1A8kpo500FhUes9Chb+wCXE
	EWvF1p0gcEcrM5GZ9Ppo4lzUhcT7vCsDlK2/jeO4+GBeUNPXH9qDJ4vl
X-Gm-Gg: Acq92OEysjDgNnIbHsSjitTqVEcbEwsyVfF2FmKUJ6Xf2A55+X4a0oQHGrjvf2jPvH3
	PU3ziTYSCQe0Jfv3jnOzSNqJC77wuox2I8vqXd/IdemDCCdkHyJrm2hBq/LO8DjMmPGXPqP0o0o
	Owf8ox7iee8Ixi0SCDbfgxmUc4OLGw6pftI5tTmaiSuBLQ/t/TtM+0qnmTZNE4tERj/mm8ZYgqf
	NOGivLqg4REoMMguUF3sbI9GV1IfISx+Gc3/5wPFcdC0sJtZPvGABfkyflc4tp36isw3zUEqumd
	UciieT5f7Hzj8hMk9msBqnUNDy4RnRPQr3PWajyXyuzH4seB4kzvm05z7L4X1BcTXb169bI7obr
	sJHKkq49PAIXcSlQn0H0XmJGoiifhX2KyTlJz/wdhOdQX6GTKlkzTHSC6SLVq1US7XFx/Ov5wH6
	tzKRckwiE/dBte4IXqmYKXkCxAcWr9NjcV6tW9taMcb9N40CNxlyODlJmvqjvZHqw=
X-Received: by 2002:a05:600c:4f8f:b0:486:f634:f2e with SMTP id 5b1f17b1804b1-48fe66423e1mr168095645e9.4.1779292628000;
        Wed, 20 May 2026 08:57:08 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe79ce3sm137216715e9.31.2026.05.20.08.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 08:57:06 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	tudor.ambarus@linaro.org,
	ardb@kernel.org,
	linusw@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH v3 00/12] crypto: atmel - introduce shared i2c core client management and capability-based selection framework
Date: Wed, 20 May 2026 15:56:51 +0000
Message-Id: <20260520155703.23018-1-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series introduces a staged refactoring of the Atmel crypto I2C
drivers in preparation for a shared core-based architecture. The goal is to
consolidate I2C client management and selection logic into a common
atmel-i2c core driver while keeping ECC (ECDH) and SHA204A client drivers
functionally separate but interoperating through shared infrastructure.

The series moves existing ECC-specific client tracking into a shared
management structure, relocates allocation and selection logic, and
introduces capability-based filtering for hardware selection. This allows
individual crypto drivers to request hardware clients based on supported
features while still benefiting from a unified least-loaded selection
strategy.

Subsequent patches extend this base by:
- migrating client management fully into the core driver,
- introducing explicit capability advertisement by each hardware client,
- updating ECC and SHA204A drivers to participate in capability-aware allocation,
- and cleaning up probe/remove paths to ensure consistent lifecycle handling.

No functional behavioral changes are intended at this stage beyond internal
refactoring and preparation for future feature expansion. The series is
designed to preserve existing crypto functionality while gradually
centralizing shared logic in the atmel-i2c core layer, reducing duplication
and improving maintainability across all Atmel crypto drivers.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
v2 -> v3:
- sashiko feedback[2]
- ecc: reorder setting ready flag in probe()
- i2c: unconditionally call flush in unregister client function, to avoid UAF for multiple devices
- i2c: fixed a sleep-in-atomic bug by moving atmel_i2c_flush_queue() outside the spin_lock section
- sha204a: reorder calls in remove() avoid UAF flagged risk
- sha204a: rephrase commit messages
[2] https://sashiko.dev/#/patchset/20260519204803.17034-1-l.rubusch%40gmail.com

v1 -> v2:
- going over Sashiko feedback[1]
- rephrasing commit messages and titles
- fix: introduce a ready/state flag to address the UAF risk
- fix: add kpp lock and refcnt to impede overwriting global driver struct
- fix: explicitely clearing rng cached buffer in return branch
- unregistering ready state by dedicated function
- reorder Atmel ECC related things and atmel I2C at beginning
- reorder Atmel SHA204a related things behind introduction of cap
- patches dropped: NULL checks in remove functions
- changed to EXPORT_SYMBOL_GPL
- additionally to alloc hw client also migrate freeing it to core driver
[1] https://sashiko.dev/#/patchset/20260517180639.9657-1-l.rubusch%40gmail.com
---
Lothar Rubusch (12):
  crypto: atmel-ecc - rename driver_data before moving it into atmel-i2c
  crypto: atmel-ecc - fix use after free situation
  crypto: atmel-ecc - fix multi-device kpp registration
  crypto: atmel - rename atmel_ecc_driver_data to atmel_i2c_client_mgmt
  crypto: atmel-i2c - move client management instance into core
  crypto: atmel-i2c - introduce shared teardown helpers and fix queue
    flush
  crypto: atmel-ecc - switch to module_i2c_driver
  crypto: atmel-i2c - move shared client allocation logic to core
  crypto: atmel-i2c - implement capability-based client selection
  crypto: atmel-sha204a - integrate into core management tracking
  crypto: atmel-sha204a - fix heap info leak on I2C transfer failure
  crypto: atmel-sha204a - switch to module_i2c_driver

 drivers/crypto/atmel-ecc.c     | 133 ++++++++++-----------------------
 drivers/crypto/atmel-i2c.c     |  76 +++++++++++++++++++
 drivers/crypto/atmel-i2c.h     |  17 ++++-
 drivers/crypto/atmel-sha204a.c |  51 ++++++++-----
 4 files changed, 166 insertions(+), 111 deletions(-)


base-commit: 6c9dddeb582fde005360f4fe02c760d45ca05fb5
-- 
2.39.5

