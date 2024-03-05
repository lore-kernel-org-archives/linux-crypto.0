Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DB71EB26
	for <linux-crypto@vger.kernel.org>; Tue,  5 Mar 2024 11:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709638128; cv=none; b=d4o6uEFOE9uAo8sLx4CwRVRZ/FJOi15Iac8KEvNOJ8C5IfVTxWFjCYJo9zqWLAiXfbugdaJce2FQFdX87sLgqYn4x8cuu5Sgkbx3Tv2+FrLsO0Px4mmCudtaril9OglfpMHYgOlb8ZS6emdq14McEghb8Rt34OrXV78VXXAIg2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709638128; c=relaxed/simple;
	bh=b6EVTO1Vxh5dd9wGRnldDet8eea6VqgEccD2x6PoF3U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HVVGfXiEQqLjtZYzzBF7aYmE3FnUb1/oDlqpUDQmH2UKOgFi7+1l0snAo6XMg3Hisst5gij6MrvCZRVhDhiSsfKV/Pw7kDF9Z54eKME7kku49NZIxDHBUklPt7Ax0KdVKGeKf1guAQN+DFbF92L0mH4FfbKRZv7cHG19U/DHLrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=RKsauHYt; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="RKsauHYt"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dd178fc492so14325175ad.2
        for <linux-crypto@vger.kernel.org>; Tue, 05 Mar 2024 03:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1709638126; x=1710242926; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U8+eJthawqe0xv1RWdK7ALRR6NiynbO3Hvfa/Eyi31M=;
        b=RKsauHYtWnjXlPJw7vifH1S2fTkSQ26Gw3BmaknsWfInjEBhXJJxedBS7Zm24+tMxg
         o7fNwvcCmnZ9mhbMkmpu/wbnEliBpBZobmXXuzvqjQargQOZxmXhqhqJKQ5QtzABO3Yi
         uGSJXly9K97ywnKJwdLJ8L5ayts3BCdazTI34=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709638126; x=1710242926;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U8+eJthawqe0xv1RWdK7ALRR6NiynbO3Hvfa/Eyi31M=;
        b=jVlP59Ryk6xgqgPJuuh0fJKVGWAfj1UolbrTdvKCjtmiOsaTbbOBigKNUIjrvR18Qr
         IBHcLk5FDKpPspyHTbfnJT6OQlPGd3yG78XWn/3AzSwenlwjyr/FXSycolihHghUpNgz
         pncMPBeGoDdgqZDxZcxDLXGJ7F3oShTWDUJmgtZ8ITHqv2f92Qc1EAeKEYa06zx1QwoA
         VcSDNamzmplNUikWyoA2dFsP6AOPzTs5Y+XyboyIX3wWHNSH/m5aMxZSe/CVVuB2F/fw
         9LGc0EjA1HFTNLV0fcvby1j5TOmiN6qLuclHBFpqCpu5bne6lZ45m2ToliwqjNbh3X2p
         P7vA==
X-Forwarded-Encrypted: i=1; AJvYcCVmkQfaneW5CEmr+blX8j6O15w4or10mWuUaJSYEhjmMyulpgo2KSTrJWnUiwL0fufJm8lezSSBY7DenNLt/3CYA2PtzUUG6xL1e/jc
X-Gm-Message-State: AOJu0Yzf7nIwJcc5eNwTaOWc+bq2c5udHEJwmGWIhHV/Qaw+M9w2xZx9
	WYx5zdiyWgiOpdfR1hES4gsbC//c8C/X9gzJv+PEAYZVr+On0QNB63mXWRu4chs=
X-Google-Smtp-Source: AGHT+IGln51w2KoNgN8SOaLoDsGVLYLngMi2A+O5HOY+M20/+G0Pe0howuTbl8mg7LUL/WBTI+bVRg==
X-Received: by 2002:a17:902:650e:b0:1dc:c8b8:3c9b with SMTP id b14-20020a170902650e00b001dcc8b83c9bmr1535534plk.12.1709638126287;
        Tue, 05 Mar 2024 03:28:46 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id mp16-20020a170902fd1000b001db7e461d8asm10287212plb.130.2024.03.05.03.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 03:28:45 -0800 (PST)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH 0/4] Add spacc crypto driver support
Date: Tue,  5 Mar 2024 16:58:27 +0530
Message-Id: <20240305112831.3380896-1-pavitrakumarm@vayavyalabs.com>
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
 drivers/crypto/dwc-spacc/spacc_aead.c         | 1386 ++++++++
 drivers/crypto/dwc-spacc/spacc_ahash.c        | 1216 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 3046 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  833 +++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  323 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  236 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  365 ++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  113 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  205 ++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  670 ++++
 drivers/crypto/dwc-spacc/spacc_skcipher.c     |  781 +++++
 17 files changed, 9325 insertions(+)
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

-- 
2.25.1

