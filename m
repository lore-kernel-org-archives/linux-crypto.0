Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6ECA311583
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 06:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776321948; cv=none; b=hdPCbQQUp5oKv4460i8XYFdfcYC9UFCVgIm+v9dhYc/mugqsVii9o1okrHVieHEhhn/uWKWT8FAT4B/OkXvs3O5NU72fp5iHHXeSeybwRDML2l5lC6nQrFaDoMayWB9OxA6GzKJ1Ljfc3ksD0saBw4qzQmmYuEqhcxNnsvkTTdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776321948; c=relaxed/simple;
	bh=PbOnSLZWBAyVcNMu/AhcZRSVAOCw0r9ngQOGkfUzMLc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KrY2gwVbCZ5MX0Z04trtOeBAU/G3s1i2j1Yo4GYnsbyO9YXoiHwB9ZLwgdayBZeGnejmJ2lCVyH6gV4iKPr6uHJeIWTEUnLA12DEL3XcZqSM3EroMvXva4tSl+heXM2SCuhUI5/8Wd72g4aCV2zILV8KE1O6ecyfuSdD0b34t68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=A3J0v8te; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="A3J0v8te"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-82f0884bcfaso4627837b3a.1
        for <linux-crypto@vger.kernel.org>; Wed, 15 Apr 2026 23:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1776321946; x=1776926746; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ETlvtUX+0FPRBZxLSk8shJgqAbKJALECN2qNkjM8IZE=;
        b=A3J0v8teATozxZFG+jCsqISgyR6Y2Wqz8AICQfW4g/rHrTcvt1LUG6vMLTtEdRZEzS
         SS55Kh1U0Q2JXa8wKlVHferBzI4GVrHQjsYE7flX6nJXfAsyH+hIkwGVd9gUL0IWwwG6
         ZxwiHQ/ablQiKrCpqBEuxbkNCWE9mQBKGynZo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776321946; x=1776926746;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ETlvtUX+0FPRBZxLSk8shJgqAbKJALECN2qNkjM8IZE=;
        b=iLvTCcpqxlo4VpZhIcDQUgy8id8qTP7HqAWLW39CbwUh+09Mt5mWEwIEfGQsXqMRkR
         HjW+19WgaAFhnPVjhfFdzYotOctQUkP31tS1JkqRCilIPbPAVx71gqyd8ru6S6zbPK9y
         zDabjCtMR+LdVstQQLaJmo3N46Zl3dwqZhM8QAzNnYyNyevbtBZTKq2FVJUPQdRZevNa
         /mm6cUEI3yRU/mmsc6F6Zi5sikNwqZbhPuloINAkBmGvMj5Mhb4icqvWhrfUeFIaLW/i
         HnLo998PONNQ0qWO1OvKH4aBE3qjQUvv//0nC1sRuWuiBiqNDskvcMUyKQkrYL5ywdo2
         firg==
X-Gm-Message-State: AOJu0Yz7bp/qAS6pMqwjtsfYoeRGjOYMSkvJCIX5ExjMU5FinMwgXjH7
	lfBnXg52JVO76WCTBJqdLWV75wjSufBz/2P56MQ23nekHQ6bNTe/6BfHjECJO1xxIqvfo0+0QLt
	5VjJ2wSs=
X-Gm-Gg: AeBDiet3Rf4WjaVQ1FATv5tDwW4QlyI2OmE7heZjBjMlSyzC/1RYPh6l84WRbLBdgST
	xLsSigVS5CvradVQK/S20GdsxWJDIc0Owam0dxT14vbls/Choh4g1IvUmbhfkTeGl+LBuZzwH9W
	TzTI2eD7d74ORye82ydp1NzT/M6vKQQOyqhQIiuKmP3+8tghXy7sCvcHRkEqUzH1JNRLQoZhyxo
	KP2mm5n0cNH4zBbLn1SyLQ+ChVhsuDDjS43dYBGJfXUqH4JHA0v/8NtqHQ2N0A1094Y948TEbSX
	kqetJwJTY5EGuSW+lQb4kipaVUsOpgExrTwpC0vGFsOen17bSw3qHLRRxGNE6LzxUpQGV3fZXVz
	hE2nd+dGWBRsBRTp7ZEcOGgIAEvxclqNXI6mNut7AAYlT1Bw49dCyOP29i2QQ5BLcqrS+VgCM8e
	kvhT1ST4eBa6iIDdVNSdc2EAr2SI/IuTPxagGp8fCGEQX0+h2Q6yE6vsXSLCw4Fxpr5zIxbm5qV
	HQWniaSWWncsowpsWw/rNsA6uKiA68c67x+UlC/rydRp0zElldAEkMlreIzObBuBEI=
X-Received: by 2002:a05:6a00:94f7:b0:82a:79b8:2049 with SMTP id d2e1a72fcca58-82f0c30f5b4mr26672467b3a.25.1776321945858;
        Wed, 15 Apr 2026 23:45:45 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f67418a47sm4107066b3a.48.2026.04.15.23.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 23:45:45 -0700 (PDT)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v12 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Thu, 16 Apr 2026 12:14:47 +0530
Message-Id: <20260416064451.99886-1-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the driver for SPAcc(Security Protocol Accelerator), which is a
crypto acceleration IP from Synopsys. The SPAcc supports multiple ciphers,
hashes and AEAD algorithms with various modes. The driver currently supports
below

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

changelog:
  v1->v2 changes:
    - Added local_bh_disable() and local_bh_enable() for the below calls.
      a. for ciphers skcipher_request_complete()
      b. for aead aead_request_complete()
      c. for hash ahash_request_complete()
    - dt-bindings updates
      a. removed snps,vspacc-priority and made it into config option
      b. renamed snps,spacc-wdtimer to snps,spacc-internal-counter
      c. Added description to all properties
    - Updated corresponding dt-binding changes to code

  v2->v3 changes:
    - cra_init and cra_exit replaced with init_tfm and exit_tfm for hashes.
    - removed mutex_lock/unlock for spacc_skcipher_fallback call
    - dt-bindings updates
     a. updated SOC related information
     b. renamed compatible string as per SOC
   - Updated corresponding dt-binding changes to code

  v3->v4 changes:
   - removed snps,vspacc-id from the dt-bindings
   - removed mutex_lock from ciphers
   - replaced magic numbers with macros
   - removed sw_fb variable from struct mode_tab and associated code from the
     hashes
   - polling code is replaced by wait_event_interruptible

  v4->v5 changes:
   - Updated to register with the crypto-engine
   - Used semaphore to manage SPAcc device hardware context pool
   - This patchset supports Hashes only
   - Dropping the support for Ciphers and AEADs in this patchset
   - Added Reviewed-by tag on the Device tree patch since it was reviewed on
     v4 patch by Krzysztof Kozlowski and Rob Herring (Arm)

  v5->v6 changes:
   - Removed CRYPTO_DEV_SPACC_CIPHER and CRYPTO_DEV_SPACC_AEAD Kconfig options,
     since the cipher and aead support is not part of this patchset
   - Dropped spacc_skcipher.o and spacc_aead.o from Makefile to fix build errors
     reported by kernel test robot
   - Added Reported-by and Closes tags as suggested

  v6->v7 changes:
   - Fixed build error reported by Kernel test robot
   - Added Reported-by and Closes tags as suggested

  v7->v8 changes:
   - Fixed misleading comment: Clarified that only HMAC key pre-processing
     is done in software, while the actual HMAC operation is performed by
     hardware
   - Simplified do_shash() function signature by removing unused parameters
   - Updated all do_shash() call sites to use new simplified signature
   - Fixed commit message formatting by adding "crypto: spacc - <subject>" to
     all patches
   - used __free() for scope based resource management

  v8->v9 changes:
   - Updated the software fallback implementation to use HASH_FBREQ_ON_STACK
   - Corrected dynamic allocation of statesize and reqsize in init_tfm
   - Fixed synchronization issues in the digest request

  v9->v10 changes:
   - Fixed unused variable warning

  v10->v11 changes:
   - Removed the redundant crypto_alloc_ahash in the init_tfm function
   - Removed the redundant crypto_free_ahash in exit_tfm function
   - Removed the redundant crypto_ahash_setkey call in setkey function

  v11->v12 changes:
   - Removed do_shash() and switched to lib/crypto API in spacc_hash_setkey
   - Dropped support for SM3 algorithm
   - Improved multi-device safety by encapsulating handling within priv
   - Added memzero_explicit() in sensitive paths
   - Minor code cleanups and style fixes
   - Algorithm registration cleanups

Pavitrakumar Managutte (4):
  dt-bindings: crypto: Document support for SPAcc
  crypto: spacc - Add SPAcc ahash support
  crypto: spacc - Add SPAcc AUTODETECT Support
  crypto: spacc - Add SPAcc Kconfig and Makefile

 .../bindings/crypto/snps,dwc-spacc.yaml       |   50 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/dwc-spacc/Kconfig              |   88 +
 drivers/crypto/dwc-spacc/Makefile             |    8 +
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  821 ++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2413 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  838 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  275 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  236 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  374 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  114 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  328 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  610 +++++
 14 files changed, 6157 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
 create mode 100644 drivers/crypto/dwc-spacc/Kconfig
 create mode 100644 drivers/crypto/dwc-spacc/Makefile
 create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
 create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
 create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c


base-commit: 8879a3c110cb8ca5a69c937643f226697aa551d9
--
2.25.1

