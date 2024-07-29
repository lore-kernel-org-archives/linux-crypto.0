Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941B8383
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jul 2024 04:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722226450; cv=none; b=karRm/BspvnBvidFh9tSV7gI+aePef9CRZ/fIAZr8+rIHGNMWLby+TRx/RpVzkWBtCOf0YU7tt+7niJpb/Mu18GCBquXA8dBM9NDxONAElta/2z07AeAVzwTlFCwLsRbWjNzdDwauVFUtJSOmjZEKfQ01ybUSxbxv4ZJGRJHHS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722226450; c=relaxed/simple;
	bh=SpxOodriAt8pygwXrCcGB4+zI6ITDIQ5VffOarc0Mi0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=F6vlsX43XdeWf2tjKdYb7/dWE1b4GysuI6viX4obrPf+Kh9TEP9yXlnq7ncTC3RXnIkQ1wrdS0eYJy5aegXkq7Ef9AJe/5LNQ3miL4QbEJ8YZOMQtuWjxkVCRoSs6USuG1ejQXWJ7y8IDzLIYk8Fup75jdGz9g1mJEC75u69/l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=Om2bSs90; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="Om2bSs90"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-70aec66c936so1929172b3a.0
        for <linux-crypto@vger.kernel.org>; Sun, 28 Jul 2024 21:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1722226448; x=1722831248; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Yr8deGs1Mu7r8ai0WD8/oX4wNI5gRnCQ9i/CZDWoC0I=;
        b=Om2bSs90S7LjdHU8/0DKG0GKlTOEX4NF/OK5SbxaPiqWLzhOVvOTi7PNiFLsglTvjH
         kx4tMZF+GIysl2nXGiatSpiBfIR8PGFiGlTPdOvZNCk/hHBX3SOoQ7K93U527ZvWd90a
         hh78YjBVmpvnSv03cKXAJ/O9wj9TCyovdawvA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722226448; x=1722831248;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yr8deGs1Mu7r8ai0WD8/oX4wNI5gRnCQ9i/CZDWoC0I=;
        b=oLENmyTaKYDCrVzV7FN+Mj2JVM8QCrCwORUSJ3WZekm5d9T6hYAD248JoxAZDGmxBI
         0snHvoQAROEku4H96DOTi81YIh7p6ekoyi7JHt7XNLU93cC1RxzQGrGte3WX2O1dkIDE
         JN4TqJlEqH4OUWCOclcWry8y3LaMaSbPVoUzbkRLqwsrR3gbCxUoYqJXD/+fZq3Qt3ZK
         qKuHyS0mAufRk8sd+Pm1AjZjpTZm9sUVT766xf4OnDWwqHS9sAq6cmP/0uTraIcL1XGX
         0mofPSHcasLlcg94DnzZKn+N/kL9FvynIZRaCFdEqndkOB5UVE1awFnlQnAwVNZ53d5R
         LpXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPmIKql2iCpmKv1tjX3GyoG9Qhq7RuM3VmpxjSIYyV2NykJthy8i/Uhk3xVSRzCprsQK68/X/0PwlrubbcoCcDYqtQGbLSb3ese2ah
X-Gm-Message-State: AOJu0YyRVN3TsTUs3tLNdQmCOtcVrdOfJ+6sBN+RJQeSstphXrJHmML6
	AMCq1BeNxG1tJ42GIBZmqDBp8wO/F4ipGlkdBsIaZ0QxMlrg39T06UqnOX/jANI=
X-Google-Smtp-Source: AGHT+IE8mIV9QjfYaaK9q96rgeo1JIumWJtqANVoCIJxRxqqcV7LEDtrCl+zT11JC4CZNI4ciRnemA==
X-Received: by 2002:aa7:88c5:0:b0:70d:262e:7279 with SMTP id d2e1a72fcca58-70ecea01412mr5485621b3a.3.1722226447673;
        Sun, 28 Jul 2024 21:14:07 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead71228dsm5932141b3a.47.2024.07.28.21.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jul 2024 21:14:07 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v7 0/6] Add SPAcc Crypto Driver Support
Date: Mon, 29 Jul 2024 09:43:44 +0530
Message-Id: <20240729041350.380633-1-pavitrakumarm@vayavyalabs.com>
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

Pavitrakumar M (6):
  Add SPAcc Skcipher support
  Enable SPAcc AUTODETECT
  Add SPAcc ahash support
  Add SPAcc aead support
  Add SPAcc Kconfig and Makefile
  Enable Driver compilation in crypto Kconfig and Makefile

 drivers/crypto/Kconfig                     |    1 +
 drivers/crypto/Makefile                    |    1 +
 drivers/crypto/dwc-spacc/Kconfig           |   95 +
 drivers/crypto/dwc-spacc/Makefile          |   16 +
 drivers/crypto/dwc-spacc/spacc_aead.c      | 1260 ++++++++++
 drivers/crypto/dwc-spacc/spacc_ahash.c     |  914 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c      | 2512 ++++++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h      |  826 +++++++
 drivers/crypto/dwc-spacc/spacc_device.c    |  340 +++
 drivers/crypto/dwc-spacc/spacc_device.h    |  231 ++
 drivers/crypto/dwc-spacc/spacc_hal.c       |  367 +++
 drivers/crypto/dwc-spacc/spacc_hal.h       |  114 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c |  316 +++
 drivers/crypto/dwc-spacc/spacc_manager.c   |  650 +++++
 drivers/crypto/dwc-spacc/spacc_skcipher.c  |  712 ++++++
 15 files changed, 8355 insertions(+)
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


base-commit: 95c0f5c3b8bb7acdc5c4f04bc6a7d3f40d319e9e
-- 
2.25.1

