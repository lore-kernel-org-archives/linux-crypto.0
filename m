Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D32762FF
	for <linux-crypto@vger.kernel.org>; Fri, 26 Apr 2024 04:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714105586; cv=none; b=flpuumFhOce2T12xCBrjKnm8glhzqDivB/PBj5sJx7xgJ4CuezKcsmdb2fhaQN1XdpHjG4TfZlK/TBTdhM5/L/DfOKWHMz6cWDPoBOY0N3kyORVzWlJizMxvXS+oMe4ippd8yboVpu2zFh/NBqBNul2Y8wtZGvGUV8Jl8VPL4gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714105586; c=relaxed/simple;
	bh=lutB1/wwYYMTxXZVaY+C+pIQxyYavoblmUe3HMIKxrg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pjEVhtaOcg8DkvZ0ytDGsTwl3QXKy7P2JEaQSqWAA2/M5Lj/mvoMut8Xzj3tvF5cbcP5rs/v1SBlaIzlLvUCUSM6Wc/4OGzjg5tYxb4gPcUOnKvYwJkkQ4Cz001RPp+hymxwXrfwWcTfKrHNqcsWK06HoEcUyvqp6yeXcLE9XMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=SbxdkkCn; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="SbxdkkCn"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6ed9fc77bbfso1439892b3a.1
        for <linux-crypto@vger.kernel.org>; Thu, 25 Apr 2024 21:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1714105584; x=1714710384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sg1IY7LIsigEpacAJYRDZDWh7gFgsDiXvFG9rkyQa1E=;
        b=SbxdkkCndbmlJpWjYahF0PTuCegopPTkANkVXk8B3AH/XWvteIJcl2ckUj9G6zIUy5
         PBfXr3HRKmoEGhi1dNAzw1+M34aU+38dZDkKQb08K3m/xCdmMRGO8Gogxc/9smQcsy6/
         Z154sHNeQd6k8D/DVsWZwnEb+CJEqdfpm+Guk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714105584; x=1714710384;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sg1IY7LIsigEpacAJYRDZDWh7gFgsDiXvFG9rkyQa1E=;
        b=pT9eE8A0gXK9XN8hQcL9I0ZdEyjf89alZf7KJQTgDHWy/wWb30nVXaxilYCwwPOP7R
         q98fjj8I2TO+RoijkqpkU0hGLgXUFxI6l5lUHUp7O+p5XoDUYAigDeOfiVuZlMUFH959
         LA9x5Mdre2ZTHIpWSN3FHS6oROSpTMSu7FbnuRdYE2tyPnookW11xrlTYLkHHdmMOOA2
         3Us3bIzou1RiMOtQ7y2nCm6hGaBhcXgtiOnDnW5W64k76xaX7VgxExUVHjjRudc6dMvH
         1Il2oDesyq+nIMn6/k/og5LnJj75YXA91ZnG6jHz6zVitjvNxukYt0cpUviFFgdET+R/
         MP4A==
X-Forwarded-Encrypted: i=1; AJvYcCVJsTNvKs2xFLNGkswK0f0jukc8R03OJTwNtXpPqEgXBJOs7MKu4lReke9rF+O6hiEL6+9e2qxa9b5fQLI0l8ROIyj3oaitcsM0o6Su
X-Gm-Message-State: AOJu0YzKssN203kNR2KuhTLwxzfeOy7lPCyX+55ZYb2CVjyZ7FWvPEFL
	eNPIl18A71X9jYrOVdJ4UEx0mw/4DpRXqM86fVaugfF8diK/6pubCszTEnVltO8=
X-Google-Smtp-Source: AGHT+IFZOUr2R+ltKzy+HseMjbftK1/QaH921A6Uyf9oC4dNK0fBFVzJG8MNl3XY7jyQ/MzFPpcNkw==
X-Received: by 2002:a05:6a20:4c84:b0:1ac:6762:e62f with SMTP id fq4-20020a056a204c8400b001ac6762e62fmr1364516pzb.35.1714105584106;
        Thu, 25 Apr 2024 21:26:24 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id t12-20020a17090a5d8c00b002a474e2d7d8sm15500291pji.15.2024.04.25.21.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 21:26:23 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v3 0/7] Add SPAcc crypto driver support
Date: Fri, 26 Apr 2024 09:55:37 +0530
Message-Id: <20240426042544.3545690-1-pavitrakumarm@vayavyalabs.com>
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
  Add SPAcc node zynqmp dts
  Enable Driver compilation in crypto Kconfig and Makefile

 arch/arm64/boot/dts/xilinx/zynqmp.dtsi     |   10 +
 drivers/crypto/Kconfig                     |    9 +-
 drivers/crypto/Makefile                    |    2 +-
 drivers/crypto/dwc-spacc/Kconfig           |   95 +
 drivers/crypto/dwc-spacc/Makefile          |   16 +
 drivers/crypto/dwc-spacc/spacc_aead.c      | 1313 ++++++++++
 drivers/crypto/dwc-spacc/spacc_ahash.c     | 1292 ++++++++++
 drivers/crypto/dwc-spacc/spacc_core.c      | 2671 ++++++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h      |  834 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c    |  342 +++
 drivers/crypto/dwc-spacc/spacc_device.h    |  237 ++
 drivers/crypto/dwc-spacc/spacc_hal.c       |  365 +++
 drivers/crypto/dwc-spacc/spacc_hal.h       |  113 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c |  324 +++
 drivers/crypto/dwc-spacc/spacc_manager.c   |  670 +++++
 drivers/crypto/dwc-spacc/spacc_skcipher.c  |  720 ++++++
 16 files changed, 9004 insertions(+), 9 deletions(-)
 create mode 100644 drivers/crypto/dwc-spacc/Kconfig
 create mode 100644 drivers/crypto/dwc-spacc/Makefile
 create mode 100644 drivers/crypto/dwc-spacc/spacc_aead.c
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


base-commit: 543ea178fbfadeaf79e15766ac989f3351349f02
-- 
2.25.1

