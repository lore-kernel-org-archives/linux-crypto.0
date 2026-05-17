Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AEC3C65E0
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 18:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779041209; cv=none; b=LHYatiq4jt1PxUkpcA/+e45fmJ7mEIiPyI6Nmpj8ekE4UOAspnuoVKt03K7USMEDQ/z+rzjvxZcVpGPm/amA56ujPkA1f40JYq24G8fhbXnLoJeVb/BHSpUCQlOZA8YzmqJAtuSBwekPrDWJ34QrzvHgakOGssd6EmoT3bHjA+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779041209; c=relaxed/simple;
	bh=h/vtjMHzD4t+FG2j/4bmopuwuQgvFiTTjWjTuMoE22U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cL3p81+j8K5kmK4z7mkJyThfTi9z5V5IxinkuxkKWIjtaMh5BMiy4aHMCym1zBTaH+0cKp+NsIcVkBH946c0/MAbhf1m3CEo0gAvCRIfZWu3tY12fOZqcktCUIw0AixSI/nug/K+7p9m7dBxNwxDyYFSQeBHO1Z1sl74bJ8AkFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kU+FsNGx; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kU+FsNGx"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-44b7e8b65faso30295f8f.1
        for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 11:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779041206; x=1779646006; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7qtD1lVmPgyK77uEJjECTLE482mHgEl/XesnKafKF8U=;
        b=kU+FsNGx3cVHfMPry3feE1weOpKP74BJlwIi0Fc0xa4ZA7LKoDRinsZSJmc2H1FR1I
         hY2Fq1xw5lce2/Qtg2jtBjRAAJ2l66pKM37bkPQh2JLP2G2NEEut/+1bQTpsG39KzVE3
         Ulz2AA2HJ5xo5uXhS0tgj4mqGz7J4spr2OSXC8LBGp49lBVUJpLt++204+/YWKVzekLx
         feX2NMyUaj9TWn5aLQHdu1o+vTZOM4D1deFMgjbBklYPwFCwrt1W5cVd0Ft+3lXj/30D
         pKeW80Dbg9d6hmsdrki26kQ5OxrIQYkvE8KdWNAxGN+xRXK5z7V85Eh5Z8lmv9YKkQ36
         dvHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779041206; x=1779646006;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7qtD1lVmPgyK77uEJjECTLE482mHgEl/XesnKafKF8U=;
        b=KUndh4u6PEKSUsNtUqjJOCLu2OQWbxhejLZmQRJ5vHgNJSyFZqCC94w3aPx8sWjsJW
         PG1ub0rKTjd8O+GQ2qWk/E436MYGSWG1lVOrL38Uj7YHWAZJRqlkQhLrJGrzkvVDsmGB
         6Bvmfk1QyOtUmgyu8cRugrYhJMWyR0d9Qw2Uy7kllP+bn4/N2JkRHktundB31BkEhylg
         aLzdUL260U/CdycMy8bleZKLtDJH++eC6PAwTSPzSwVYQm70Lde8HhGb8Iv+ErMpDbPG
         Kzay3L7bvdwwU+BN4xs3vKWBP4yEkxrEhrIDZJBIN0U33xxFmdLeGiVlTMLOpMTEnbah
         85fw==
X-Gm-Message-State: AOJu0Yxjk+rwecoR2ja2vzibVCnePHcGoI4Z1+7xiJvyt+7kROQdAWuX
	+FcaAlPoitMtB5uNvk850HkVK/uq0TRNOL7BU1dQ3cPkw6zgYypZN8eo
X-Gm-Gg: Acq92OF+zOLMYX+y4WTPXb23qsNKUjrPbaiZiS2wi1PY9Axv3z4xUrlq6z+AFP0Ejdq
	bUtDUjNIg1rIWw6D9+mIwtZRhjfzcA3MlxZqluHVUhAR792PLwdPrXh6UGZ0hoM5LIahiM7qT08
	bKwziMFN3Kj33TaYM2PJZVbdchRDvmvA1XDZMfTS+HYfMlz+uHtIGh558rw9qlzlHoOPtJPDY5e
	T55afy0qkc/kTi0+Xk2Fn8XxqktxxKwHAK5FdUAbZ8OZDws9Y0rZ4OuGL0Alk83fPuU1cxqpI+Z
	aQakqBoH+kkd7MIexmywElhzIX6FI6KvyQAmtlekH+GLBUH7olXX/ariA54VrqT4efGAUKpVVmH
	9Au57ahDF5gQWLqrvJbjBrTcsMdykIYwuZIVNS2gvkZzdE+/bSGMjh1KJJolqOG1pCThjUE1ZJl
	/r26FKkkNTVFEZT6nbJd1vjhc38I9VLXNkuoZVjkhmEfgoW9AvUwfM/lnWB8OMpiY=
X-Received: by 2002:a05:6000:2709:b0:44a:ba79:f039 with SMTP id ffacd0b85a97d-45e5c613c1cmr5692426f8f.8.1779041205587;
        Sun, 17 May 2026 11:06:45 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm31766775f8f.34.2026.05.17.11.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 11:06:45 -0700 (PDT)
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
Subject: [PATCH 00/12] crypto: atmel - introduce shared i2c core client management and capability-based selection framework
Date: Sun, 17 May 2026 18:06:26 +0000
Message-Id: <20260517180639.9657-1-l.rubusch@gmail.com>
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
Lothar Rubusch (12):
  crypto: atmel-ecc - rename driver_data before moving it into atmel-i2c
  crypto: atmel - rename atmel_ecc_driver_data to atmel_i2c_client_mgmt
  crypto: atmel - move i2c client management instance into core driver
  crypto: atmel-ecc - simplify probe error handling
  crypto: atmel - factor out i2c client unregistration helper
  crypto: atmel-sha204a - add i2c hw client list and improve probe error
    handling
  crypto: atmel-sha204a - switch to module_i2c_driver
  crypto: atmel-ecc - switch to module_i2c_driver
  crypto: atmel-ecc - simplify remove path and relax busy handling
  crypto: atmel-sha204a - guard remove path against missing client data
  crypto: atmel - move i2c client selection to core driver
  crypto: atmel - add capability-based I2C client selection

 drivers/crypto/atmel-ecc.c     | 98 ++++++++--------------------------
 drivers/crypto/atmel-i2c.c     | 54 +++++++++++++++++++
 drivers/crypto/atmel-i2c.h     | 12 ++++-
 drivers/crypto/atmel-sha204a.c | 44 +++++++++------
 4 files changed, 115 insertions(+), 93 deletions(-)


base-commit: 6c9dddeb582fde005360f4fe02c760d45ca05fb5
-- 
2.53.0

