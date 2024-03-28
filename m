Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E757B132805
	for <linux-crypto@vger.kernel.org>; Thu, 28 Mar 2024 18:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711650434; cv=none; b=j1DPJhV8qMyLCxpVa7IcnRjE/TFzziR1OeQofmUqvIsMppUTxlynarUrCZDyOoPWfUCYD2vSmFbyQEyHf2nfh8CMBpi4UqPMhrR0luFVtBozWs8OFOQMlwjDWFR8j9knK3CKZ8hb0DEq10G/eavLussoO/BJCXbztyIoNhsEGn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711650434; c=relaxed/simple;
	bh=yR3VIVzIm7J5DlRe3h9y8sO4VZfZwjLRaPB8+Bn9+kY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PvXpPVXwyuzoWijmOXUaRU3hZbzYmViOLqC1hKFp1XtRhnV+FIdaTQMfYbUYUXxdHK0bUmPnjYX35Aar0Cg0q4DjSlpfMAwuYT6xn9ZcHlfB2bH3HBFGGQbgKPsBDE707wQYj3lblXqLVslyaE25EHIVL+wgRsGlPn+GoEJP6vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=DObq9Uv2; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="DObq9Uv2"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1dff837d674so10606895ad.3
        for <linux-crypto@vger.kernel.org>; Thu, 28 Mar 2024 11:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1711650432; x=1712255232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UqlCZa15/EgDhJqRplHZCJq6k9U555sbwgZc/ouqfYE=;
        b=DObq9Uv2NiUPf3cdnIKtzudVR0PKK108u0mSD6SApBGBR5rDMjmsl5sIQFcvdkZAk6
         sDE4LP77X1dLlrOcgN9T1X9ahjxt6fv1rkjI1bRupzHUpHTRK0Yuqh96Ccc6CVJbSDG3
         /qqWFG/IEYtjFPDoys6PJJZt/FJA1o/I7cT6g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711650432; x=1712255232;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UqlCZa15/EgDhJqRplHZCJq6k9U555sbwgZc/ouqfYE=;
        b=Wc9KFaVXs/VrKXMisxFuEMcbLeSC1P7yb5VJICv8EzbZcXpZtXlpqswtVRQYexhAmr
         vGW2PoHMUNGXA3NXgXgrnFkRtjoa3pxk2V6e54hvfdJ2DtbI/t3uHsLat15SMAn636ne
         oKCpquf6NiNhgxUt1iPP3+UZqgz3VwexH6a2YWp989S3QgxQPsodDX3osLyT2zgx5o5G
         eLqMYgQ0oqteFi2c5vy3+6DqY2U6/+1Sqf5wbGSLorjEaCSSwSnGU+eNpBJkGh1zpZwq
         gp/47KNJMznuRQ2S0jDG4fS3JvxeMH/y+MN/5SLe4j6yzc76IYLkuvp8qLYxRdpQUa4w
         blNw==
X-Forwarded-Encrypted: i=1; AJvYcCXOWlafEw5BfUHjhG9HGWzg37G4SlMJKUy8oc/d9VLsa4HLUWX7KqqRbxUz5gZvY6RffwekqEJm7xJni7fJBe4Wiy2vI8sQpwmeT0Vx
X-Gm-Message-State: AOJu0YzZRQrdQcgxIO6d81u3WEGwFcS5at8t1DtpRLff5tij8D0WvmLq
	joXsn5v+PZ4OdN+C9rEgAxafb04rBWaok2CDY3pPiBfQVpMuG9Fx73H1/hmMFlE=
X-Google-Smtp-Source: AGHT+IELR26GDFv20Um5GW18RJ4NuK1Oy06CGuUdBW3WF6fnnyeXmrl3qYbfYq/AaWEBKXR2kPaebA==
X-Received: by 2002:a17:903:2c9:b0:1e2:875:f215 with SMTP id s9-20020a17090302c900b001e20875f215mr343600plk.30.1711650432130;
        Thu, 28 Mar 2024 11:27:12 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id i7-20020a170902c94700b001e223c9679asm846059pla.93.2024.03.28.11.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 11:27:11 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v1 0/4] Add spacc crypto driver support
Date: Thu, 28 Mar 2024 23:56:48 +0530
Message-Id: <20240328182652.3587727-1-pavitrakumarm@vayavyalabs.com>
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
- rfc8998(gcm(sm4))
- rfc7539(chacha20,poly1305)

cipher:
- cbc(sm4)
- ecb(sm4)
- ofb(sm4)
- cfb(sm4)
- ctr(sm4)
- cbc(aes)
- ecb(aes)
- ctr(aes)
- xts(aes)
- cts(cbc(aes))
- cbc(des)
- ecb(des)
- cbc(des3_ede)
- ecb(des3_ede)
- chacha20
- xts(sm4)
- cts(cbc(sm4))
- ecb(kasumi)
- f8(kasumi)
- snow3g_uea2
- cs1(cbc(aes))
- cs2(cbc(aes))
- cs1(cbc(sm4))
- cs2(cbc(sm4))
- f8(sm4)

hash:
- michael_mic
- sm3
- hmac(sm3)
- sha3-512
- sha3-384
- sha3-256
- sha3-224
- hmac(sha512)
- hmac(sha384)
- hmac(sha256)
- hmac(sha224)
- sha512
- sha384
- sha256
- sha224
- sha1
- hmac(sha1)
- md5
- hmac(md5)
- cmac(sm4)
- xcbc(aes)
- cmac(aes)
- xcbc(sm4) 
- sha512-224
- hmac(sha512-224)
- sha512-256
- hmac(sha512-256)
- mac(kasumi_f9)
- mac(snow3g)
- mac(zuc)
- sslmac(sha1)
- shake128
- shake256
- cshake128
- cshake256
- kcmac128
- kcmac256
- kcmacxof128
- kcmacxof256
- sslmac(md5)

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
 drivers/crypto/dwc-spacc/spacc_aead.c         | 1382 ++++++++
 drivers/crypto/dwc-spacc/spacc_ahash.c        | 1183 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2917 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  839 +++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  324 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  236 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  365 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  113 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  204 ++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  670 ++++
 drivers/crypto/dwc-spacc/spacc_skcipher.c     |  754 +++++
 17 files changed, 9138 insertions(+)
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


base-commit: 6a8dbd71a70620c42d4fa82509204ba18231f28d
-- 
2.25.1

