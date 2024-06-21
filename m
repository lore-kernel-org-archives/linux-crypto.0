Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B1316C6A8
	for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2024 08:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718958076; cv=none; b=NhhACvS2cqGaiiJQtPg7I14Dl+RougoZr13NLD12KZNuW2cJoukkiNRQn5ByyTdRe1BaVOpu64Ycix1X3I8Xk+uQQwqV1kDd5dZVA8Lsn8DOb9Wl5C8/UsZZt/hHhSHjnJmPXWF8bGZnDwJSEblXtZNVDwNfvX/DK/g3wHZstHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718958076; c=relaxed/simple;
	bh=AZMW9Nu2DPjLgFXSzhp5Sme8UNShKiAJQRD+JkJrGpg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bpK2syjDkM2PaEh6BZm9WE6Ou0yq4GAvWFYKfhKTCq7lyiTltml4vnOd3l7ghrBWXG81oTM7YDa13VLRFjmJiEuA1xvPo7ANORXqenMeU22BQ57nZ5EDdOo3zCRmpT9MSscjsxVWtwSrAZUoN3yaiHhz5OYc9gBVEiPLdKtQf48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=Tw/nZ+Iy; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="Tw/nZ+Iy"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1f9b52ef481so15877575ad.1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2024 01:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1718958074; x=1719562874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hc944UNN7f50PN3TB8+9mucd9oay64prolyLQ6dOTms=;
        b=Tw/nZ+Iy6SOcKePx9V/Mqb2BgQ9cXZvOuRdjpiF/qC2ffxt2Bq3USslvFIqEMmYFno
         HVnB7w+Gb8dZ476m9RdvtaYzY6Wa021DbX+o7qDwjU3od92/p40ezNc3A8nEvl9Slbb8
         C7NaHA6j5UIslxadgW4b8Q7MRIIxiAYLGUes8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718958074; x=1719562874;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hc944UNN7f50PN3TB8+9mucd9oay64prolyLQ6dOTms=;
        b=nVfIJV2MR4ec57RPTADRC1ODsuUCWzELmU3vBGVS/Kv3jLz7SDJG4YM3XjP+hI/uoW
         us8Act5SWf6GOE3P2sA4A5/Geq0KVLOt6dFxIPyKqinvtszS37Q9OvXl829CTVpe+BgL
         H1Xuw141nw1NQhk0p9JTqFQjgXiH5srtPHULNrpeuwD/G0l00QKgsdklOxIyzKs3VUQz
         WnK5wEc/BH9LUfMRE5R0zl2DWZTp2PXruUzz6B4DnTssWyXQsbWfiEPVguToVtYovJTy
         V0Ca71lgIn5gI/9//D/E7ONtotnjeSMR/Kv+WwRGdhn7XX0MxqKD86A0nrX6t9uEWwPT
         LzlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXj8rKGcKXGWHtxNe7l43XPJzHp0nzJH2eIfo3YBLhkAoqM2GiRurVcD2v2bvOXxjRCHiVJdwnkN6JNK5oRcwAhi5RwIjH7/nsFxyr0
X-Gm-Message-State: AOJu0YzqAAWhSb/283vVCd0QrJJZoeSSVYvwr3tsweXpqAPBFy7QKF3V
	DCrcusai1j1v9rMPDZSXgDLWVEA6Gw2jFYjjVacA7I3KCfnCHisEPDLNQ6S2UaI=
X-Google-Smtp-Source: AGHT+IHUJU8CYeyGQtVmNv/mwqMlQh+ABaUBR7JpvjiHvXHAcjoQKfUZgd09zRcxcqjp5uZTQqyIdg==
X-Received: by 2002:a17:902:d2d1:b0:1f9:f217:83d with SMTP id d9443c01a7336-1f9f2170c01mr7159075ad.2.1718958074298;
        Fri, 21 Jun 2024 01:21:14 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb3c5c97sm8673555ad.125.2024.06.21.01.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 01:21:13 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v5 0/7] Add SPAcc Crypto Driver Support
Date: Fri, 21 Jun 2024 13:50:46 +0530
Message-Id: <20240621082053.638952-1-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the driver for SPAcc(Security Protocol Accelerator), which is a
crypto acceleration IP from Synopsys. The SPAcc supports many cipher,
hash, aead algorithms and various modes.The driver currently supports
below,

aead:
- ccm(sm4)
- ccm(aes)
- gcm(sm4)
- gcm(aes)
- rfc7539(chacha20,poly1305)

cipher:
- cbc(sm4)
- ecb(sm4)
- ctr(sm4)
- xts(sm4)
- cts(cbc(sm4))
- cbc(aes)
- ecb(aes)
- xts(aes)
- cts(cbc(aes))
- ctr(aes)
- chacha20
- ecb(des)
- cbc(des)
- ecb(des3_ede)
- cbc(des3_ede)

hash:
- cmac(aes)
- xcbc(aes)
- cmac(sm4)
- xcbc(sm4) 
- hmac(md5)
- md5
- hmac(sha1)
- sha1
- sha224
- sha256
- sha384
- sha512
- hmac(sha224)
- hmac(sha256)
- hmac(sha384)
- hmac(sha512)
- sha3-224
- sha3-256
- sha3-384
- sha3-512
- hmac(sm3)
- sm3
- michael_mic

Pavitrakumar M (7):
  Add SPAcc Skcipher support
  Enable SPAcc AUTODETECT
  Add SPAcc ahash support
  Add SPAcc aead support
  Add SPAcc Kconfig and Makefile
  Add SPAcc dts overlay
  Enable Driver compilation in crypto Kconfig and Makefile

 arch/arm64/boot/dts/xilinx/Makefile           |    3 +
 .../arm64/boot/dts/xilinx/snps-dwc-spacc.dtso |   35 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/dwc-spacc/Kconfig              |   95 +
 drivers/crypto/dwc-spacc/Makefile             |   16 +
 drivers/crypto/dwc-spacc/spacc_aead.c         | 1273 ++++++++
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  862 ++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2623 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  826 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  340 +++
 drivers/crypto/dwc-spacc/spacc_device.h       |  234 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  367 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  114 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  316 ++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  650 ++++
 drivers/crypto/dwc-spacc/spacc_skcipher.c     |  715 +++++
 17 files changed, 8471 insertions(+)
 create mode 100644 arch/arm64/boot/dts/xilinx/snps-dwc-spacc.dtso
 create mode 100644 drivers/crypto/dwc-spacc/Kconfig
 create mode 100644 drivers/crypto/dwc-spacc/Makefile
 create mode 100755 drivers/crypto/dwc-spacc/spacc_aead.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_skcipher.c


base-commit: 1dcf865d3bf5bff45e93cb2410911b3428dacb78
-- 
2.25.1

