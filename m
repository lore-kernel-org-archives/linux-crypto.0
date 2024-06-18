Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76A863AE
	for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2024 04:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718684883; cv=none; b=c3PDr0Noe4ogOu0dnU5SRczZC/G/+t8BoIBAVkLyCvi7DpU4fuYGYCs7X7kZV2fvO/X/4GeUMCXEJrn5PK6emPa0btypm3W2ZlfhWPSJ6C6Vacq/O2J5g4nuGfVEHCtQCvD2Bsn9CzyFJnrY3Dh7Cb1lRcjrO/bby9vM0ikCzE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718684883; c=relaxed/simple;
	bh=dKCCFJLtukO4/ELMCMMsJra81X9rNsSS0IubkINVr68=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IAmBsXLKVj3Bhu459NZtj+5miL2ZLn/hM1zGqZBFhaEWm5pStSTia2b25QyGhptrpcl5kct72wNWYau5NmlyqBefCva546xo8crtECHUJbAOC1Oc9+7jhC62sKdjTfOxMBFF4LcOdqtYtoGrENC2yRCed8mCPaf4D2hrghfhpyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=bcH10xVm; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="bcH10xVm"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7061d37dc9bso347361b3a.2
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 21:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1718684881; x=1719289681; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RWbIh7UDrk/DTCc0qLZPqr12LMvpVLEnRCaNwm7w8vs=;
        b=bcH10xVmu7i+uxpDa6U3e8lHGeaOha6B9SShS9YN2OaVOMDod05f0xpExbJZT7sKie
         FEwhbPU1+vkZeeWdCTXb0sVoJn1e7WJ96lwq5QP1vpYF9GlX5/xXS07qtasO/8f0OmVE
         tuszmEWKxBmtXS41z4kiNQ2wwOoEONAk3mcgU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718684881; x=1719289681;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RWbIh7UDrk/DTCc0qLZPqr12LMvpVLEnRCaNwm7w8vs=;
        b=XY3hqwCCkduG9+4NgF+6M8aTNiPe55WmvTWvOravpOhQhjaSmuGHxfhFckBLJ85O2H
         6McJ9lhKgzaBUVmK9QXGtjMxRuWirSzHWUv6G9Dcc07/YhUABqD9+E+jCmpZTWtTn38G
         9coUQl/AAUAa6m3a+lTCGiFfl03kuxMZwLXBP4TgCrE5ra/pXgr3S75CgaLA3+T2yKI0
         foysFmD2YeCgNOOJZALtPmPUeSLSWtyuKOk9l6VPHXLmEYbKl7AxQ4yZpT9apX0M+5Dd
         TqljGpvLg4ZCB7z0gP0MHHkneqNAp3vwpCIvIRR5TPcudag37uqoqh5jOgZLThvOgja4
         yJJw==
X-Forwarded-Encrypted: i=1; AJvYcCVOGHI0eP37c0UTGf2NBEyfvAoIoj+xQMvG5ODHPW4qWiUcEu8Q6vINIKJ0As2yhpUZMkhc+dpl8mAJIQQcf7oUhup+uuGB3PmuayuJ
X-Gm-Message-State: AOJu0Yy1tTdZgt7o9gSRCz+b+BYKHdjZQHv5tFV/e5YWMbjtdJeyNi5r
	tv8MI7hg/E9+4Qeide89cBKlPXCa1CY6ZE9LPKX7ZXfqoNcJEmKz1SVNy0exAWg=
X-Google-Smtp-Source: AGHT+IGy4RYSrtj0oaDay1FeeoQLQJozsvxpV7SjgTFANBHpNDln2BRsJYfV/RopDzufU0aNgOu/Eg==
X-Received: by 2002:a05:6a20:914b:b0:1b8:a3c5:3472 with SMTP id adf61e73a8af0-1bae7eadfddmr16025940637.26.1718684881057;
        Mon, 17 Jun 2024 21:28:01 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855f1770csm87912405ad.230.2024.06.17.21.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 21:28:00 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v4 0/7] Add SPAcc Crypto Driver Support
Date: Tue, 18 Jun 2024 09:57:43 +0530
Message-Id: <20240618042750.485720-1-pavitrakumarm@vayavyalabs.com>
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
 drivers/crypto/dwc-spacc/spacc_aead.c         | 1279 ++++++++
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  883 ++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2624 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  826 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  339 +++
 drivers/crypto/dwc-spacc/spacc_device.h       |  236 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  367 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  113 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  316 ++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  650 ++++
 drivers/crypto/dwc-spacc/spacc_skcipher.c     |  715 +++++
 17 files changed, 8499 insertions(+)
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

