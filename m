Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880D32F4A
	for <linux-crypto@vger.kernel.org>; Fri, 12 Apr 2024 03:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712894051; cv=none; b=N7Uxmb+SeVfaGZXoNSAHe5xxFd5Q5aADWgG4sP45t3lheKL8Cq8PazSZD8QLkZPq3upkJZb97E9n++xoYzQ8opXFcWZitNsmxIakFw46o7n+URrfFlW8lmFX2tP95akVDdbARH3+UL3PD359+xtEtjqV7OoOdwvdFND2RQRHa6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712894051; c=relaxed/simple;
	bh=84hF/B8CJYse8GHHb1/JCrIHXFTauiU95qbIcvm0NY0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JuacllnqcLY60kNQAuBL4VNrItwEuUpNX5zE7StNlJxViRk9+Y4a+xYFSXiW+QDXjRh4W9whe1UfJCVDz0jMmIfwRUY6QN6/agCclPj8/S4UnUHNuulUoY+7MLSssiHk2C086nJOoPLYc+RZuYwjGZO49BjrxYSpoD7LqTNxk+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=FTNx4j+1; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="FTNx4j+1"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6eb5887f225so372599a34.2
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2024 20:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1712894048; x=1713498848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f+qcBjtKskhqiyPDNHdpTTq5TN4KLl5kYMMFq6O09pg=;
        b=FTNx4j+1pxF2VYixFX1rbumWwSq8TIh+Mxjva2wIwWFJwwaKokcmO2fqPKOQfp70yj
         Et+tnJNIhFDmkWf/IHFZG9rjou93CgO7jc/vWEKTV6zeYyAGlR0XMtxSO9AZESQhm4K3
         qIYXxDJRPmBIORyHlj1eXkC8Xf7onpk8FI0CI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712894048; x=1713498848;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f+qcBjtKskhqiyPDNHdpTTq5TN4KLl5kYMMFq6O09pg=;
        b=Ks7eLXU/kv/hjB5UDmo5GxMEkkNvdQ9ODNVqrdpefJqsGsy07QEmHJxFnHPZiZ6ho0
         WqDGQ+3QtR8ISAHuBt77rNCwcL+p7LTQiaaQqvsV++V7aN1mb2zzr8wVmelBCJdVc1o1
         jvt08BNs9mFn8xz7URc70yFFci/7NY7TaIMzLj3YJU+cbxF7AlCdzDMwsia9WoqHWR7G
         cqJtk+VJIY5Xn9jzKIi84OSVzGhDIN4TVA67KtCEy8MWgtjhaqXkD3AMXADZkBPDgt/Z
         NMQ1OiGnYOoA/BM0Cp2YL4+VycFPb/8ii/7nNWViInWXG44UY9xxqObd6iL/kvJqYEqC
         A5aQ==
X-Forwarded-Encrypted: i=1; AJvYcCWoiEvtKmRQ4PKznm4UOiJlElrOC2WwkUS0opPnhG/INfzbVc5QoGWP0joIwkKJlHjNGNPPYq2mWPD/O4BYXb/Hix6ntpmGmPHZb21m
X-Gm-Message-State: AOJu0YylfT/caw3PWSAimCA/PeR/Wf2pflgiLqYWRBNiiORUpNsruHXP
	6wvLGJVnvUbccMMyjj0KEopKR9jCIUdOrrvmt7bJ1SkTC4OFSHeE/dm540aDkQs=
X-Google-Smtp-Source: AGHT+IGAgcnGOpzZXwIA16P9DcjcRudQLtLtr4mWNbodosNpA1ZRFlB2ZX6d3/H+uEKRy+yHcjb7jg==
X-Received: by 2002:a9d:4e8b:0:b0:6e9:f439:24f6 with SMTP id v11-20020a9d4e8b000000b006e9f43924f6mr1612207otk.20.1712894048623;
        Thu, 11 Apr 2024 20:54:08 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id a193-20020a6390ca000000b005dc120fa3b2sm1842910pge.18.2024.04.11.20.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 20:54:07 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v2 0/4] Add spacc crypto driver support
Date: Fri, 12 Apr 2024 09:23:38 +0530
Message-Id: <20240412035342.1233930-1-pavitrakumarm@vayavyalabs.com>
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

Pavitrakumar M (4):
  Add SPAcc driver to Linux kernel
  Add SPACC Kconfig and Makefile
  Add SPAcc dts overlay
  Enable Driver compilation in crypto Kconfig and Makefile file

 arch/arm64/boot/dts/xilinx/Makefile           |    3 +
 .../arm64/boot/dts/xilinx/snps-dwc-spacc.dtso |   35 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/dwc-spacc/Kconfig              |   95 +
 drivers/crypto/dwc-spacc/Makefile             |   16 +
 drivers/crypto/dwc-spacc/spacc_aead.c         | 1317 ++++++++
 drivers/crypto/dwc-spacc/spacc_ahash.c        | 1171 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2910 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  839 +++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  324 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  236 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  365 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  113 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  204 ++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  670 ++++
 drivers/crypto/dwc-spacc/spacc_skcipher.c     |  720 ++++
 17 files changed, 9020 insertions(+)
 create mode 100644 arch/arm64/boot/dts/xilinx/snps-dwc-spacc.dtso
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


base-commit: 4ad27a8be9dbefd4820da0f60da879d512b2f659
-- 
2.25.1

