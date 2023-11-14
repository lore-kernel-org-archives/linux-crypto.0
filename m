Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE58CC2C5
	for <linux-crypto@vger.kernel.org>; Tue, 14 Nov 2023 05:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="Kw18bmOw"
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B59019B
	for <linux-crypto@vger.kernel.org>; Mon, 13 Nov 2023 21:05:37 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1cc5b705769so47396895ad.0
        for <linux-crypto@vger.kernel.org>; Mon, 13 Nov 2023 21:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1699938337; x=1700543137; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KeJZ0BkEz890tOtEJnUzJU6ocGohii4ZisT86ZKWgxs=;
        b=Kw18bmOw3jdXFZzsGms3CZbK6kEM2TC3sOyPNT1ZYTJ7H1RehSdPj2KbGMQQolk9mn
         khr74OZ9OAVBcZIcds+ej5aDVUbfVl+cbCPIljgKYox9ATF7pEWUIfneVY7ab+cXlya2
         0shdwg0amXjrwsjZq0OhETod1M5wPdYhwZClg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699938337; x=1700543137;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KeJZ0BkEz890tOtEJnUzJU6ocGohii4ZisT86ZKWgxs=;
        b=LaDlyzKbDIvftnCbIT02Jni3XjfSGoPmiKaAJdCAuNDiEk97rX1zJjboE/bOMuN0cX
         SxUfP/F1A/ihCXLvzhnU45UrjwqygERPM++8pvyq16SVGIE9wrdbx9/MNzdZj59ZjqKV
         2gzSDHvRoIm+lheUdNJv/V/VZoHcFZRIuTRpeD200xlZvzj8h6tXphSsp29rZKDHphua
         ZzjCN2vmrajcJveCMMD0vjZqL3skprwbYV/WM6ubGbC4KlqnDgJbuE7r2a2bu5T4EJWn
         fErrrJcADruu5IyMt4C06LsmcfEgT1N13Yq/HilSpNcgwRvLEuZEQ/AnKX4PjmFfIGKh
         5VTQ==
X-Gm-Message-State: AOJu0YyoRPvQ7Ff8Nyc1p8LpiJa14ZRrJlO56jtS38DyJvHq2cxJUNWo
	LhenjIOK32Car+xux4YHOgzw9g==
X-Google-Smtp-Source: AGHT+IG5gf04tmYjJYh8HrL2WBHITMcCDj+KVIbAoWxkB4aBytCegzLO89WqJa4PD9/a52MS/92iTQ==
X-Received: by 2002:a17:902:bd41:b0:1cc:4fbe:9271 with SMTP id b1-20020a170902bd4100b001cc4fbe9271mr1340916plx.22.1699938336864;
        Mon, 13 Nov 2023 21:05:36 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id a20-20020a170902ee9400b001b896686c78sm4910131pld.66.2023.11.13.21.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 21:05:36 -0800 (PST)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: manjunath.hadli@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH 0/4] Add crypto spacc driver to support cipher, hash and aead
Date: Tue, 14 Nov 2023 10:35:21 +0530
Message-Id: <20231114050525.471854-1-pavitrakumarm@vayavyalabs.com>
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
hash and aead algorithms and various modes.The driver currently supports
below modes

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
  Add SPACC driver to Linux kernel
  Add SPACC Kconfig and Makefile
  Add SPAcc dts overlay
  Enable Driver compilation in crypto Kconfig and Makefile file

 arch/arm64/boot/dts/xilinx/Makefile           |    3 +
 .../arm64/boot/dts/xilinx/snps-dwc-spacc.dtso |   35 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/dwc-spacc/Kconfig              |   95 +
 drivers/crypto/dwc-spacc/Makefile             |   16 +
 drivers/crypto/dwc-spacc/spacc_aead.c         | 1352 ++++++++
 drivers/crypto/dwc-spacc/spacc_ahash.c        | 1241 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 3044 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  821 +++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  322 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  238 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  390 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  113 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  216 ++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  707 ++++
 drivers/crypto/dwc-spacc/spacc_skcipher.c     |  629 ++++
 17 files changed, 9224 insertions(+)
 create mode 100644 arch/arm64/boot/dts/xilinx/snps-dwc-spacc.dtso
 create mode 100644 drivers/crypto/dwc-spacc/Kconfig
 create mode 100644 drivers/crypto/dwc-spacc/Makefile
 create mode 100755 drivers/crypto/dwc-spacc/spacc_aead.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
 create mode 100755 drivers/crypto/dwc-spacc/spacc_core.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
 create mode 100755 drivers/crypto/dwc-spacc/spacc_device.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
 create mode 100755 drivers/crypto/dwc-spacc/spacc_hal.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_skcipher.c

-- 
2.25.1

