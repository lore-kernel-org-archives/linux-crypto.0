Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8263B3F99ED
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jul 2026 12:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783428833; cv=none; b=WLAULYLyTHjnEeKJTitxrcBYdWaUzsLfRswhoUiPShRbr+wr63odSTHDs4YxGmRkEQKVFkrQU+0w/HiH1ctylMl5uzB+uSk6K1MjP31myty+NSx8GZ9qCfW1HKw/n/L1WmGEFvQVwLaTRruyhgJcvCngniQtF55a20jpHsawxyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783428833; c=relaxed/simple;
	bh=TtlRd6av43xWr0OSRZ67ub9qAuhFOW7oSsbbFqq32RU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oBhbGIWJINBCNjBje9GnMExTl8Q885HEdg03QXANE71As5z2uLdtsQ0N+dQXUh3lhv52j8D+3b7QGg23iQIP+JxGljKruT1Z3qgd342LnOSYXeBtj47+lnelg2w1uGG2tdJS37ZknxzN2Tl/PbXre2wwbbLpq+7Hfia0erH4EIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=ku+jmE8P; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="ku+jmE8P"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso3321641a91.3
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jul 2026 05:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1783428831; x=1784033631; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DkaFB1lX+WNiI+Ftr/9ULdZic6GxfO7x0K9dBqqL3LM=;
        b=ku+jmE8P6Yg9TQaVfsViJ/n3pxpO0ccdBba27zbz/1B10mujbu0R8Dez4XsLk4d4k/
         d9Kg+jNWFWG06X5Jk1j9oFe5+xMl3Kqm506kmGKxKvfnj0+tjVwK7Itt/Pc6vpiroW9C
         WUQDmrExlQppoHcgohpVaCMpfKIgewaah+/uA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783428831; x=1784033631;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DkaFB1lX+WNiI+Ftr/9ULdZic6GxfO7x0K9dBqqL3LM=;
        b=C6q7OYcZFHY8BaCoBFWEjTvQo9RF/MKoitZrAR2P5C5p3K6Ef269yizdAzj3tqsKWt
         2L56fHpW5YkIQ1XmUq0icSOTx4vjd+pN1nNfxTezoFv1gGiz5FtcnAgPbZeFkU6vpLXJ
         0kIcU79wgUO2Li0IJ0kODQZuhMiHF13IZRtgOLfOItykEuvl8P7uIDkqv55yqRul5v/7
         qZwbfZFM51o/NOj2Ev9VFh4fcTK0+jvX7c1bm5Mp3lYbgIoyHnJv820jrrwVeeDJhuE5
         O25gwgv1mLLJckgGLnhOEUpDU8AQu2t0xYYUJttxZ3dbrQ7B5p8zGzaSlbs+fUD8rzPh
         dyYw==
X-Gm-Message-State: AOJu0Ywez0ukfdHzBY5p96xsHEtT1V9xQE0AplrA2OCieQHu19/5ZFvh
	pShu6OoNoIZ+EiGx9AyPaPMdLuD4RrryzNiFaJjJlX5+9uVlbyeeVsxtYrtYajkm6ocjUCQ3Zgr
	m6/QG
X-Gm-Gg: AfdE7cmGEgmJZNIOXg6S6yDw6D98pdnK/pXwSlBAYoYAAiO3XWg98TN44OZlASwFHsS
	t+DurP9ujW+uErDQTi2Jbua2dAnlATD/+u2ZLDAGx5v0+oqlgtsne1OkXzlz2sZlU8P6xgT6hYf
	s2pG/R03C9/QtrPmPkCDgdUbogJ94ujq6TXu0Aoii+DPpI+WNlz4DeBe+PasEv1Epj59O+ID1qZ
	5+9hFFzIfN0YFl4emNNrPTAEYiYIVLW9A0cxP0k0+Yy//8K/M0ewX+ZBsezntFpYH3VQVF5rm+Q
	Z8ifUNxXql18YCt84/wgGVCMZy3hatsfAU8R6GDw1yvtyCMM4iQOTLAcrKfse0F7hdukUA1wJTo
	lH+unkA4N2bWd/+82q8evm8lBq2PoaSTBaohjvGQOHuTNu2n/bxh6M7ZRHcT5xvg0O6eoqsF0/O
	uEcJjVYQgdVbC8W2XYAAldthU2BMUa6OvpuLE6H6cVLUNjIlJTDDdqNbNieRXkTxzArmuSSTLlp
	/5DYj27xPfVFtxi8e25WXUlLz4+/bNsyhOLwLQglUwWNTfqYZTImwhf
X-Received: by 2002:a05:6300:6186:b0:3bf:6c08:2841 with SMTP id adf61e73a8af0-3c08eebab41mr6159349637.48.1783428830820;
        Tue, 07 Jul 2026 05:53:50 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b659fa13bsm7945671c88.15.2026.07.07.05.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 05:53:49 -0700 (PDT)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: krzk@kernel.org,
	conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com,
	rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v16 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Tue,  7 Jul 2026 18:23:07 +0530
Message-Id: <20260707125311.2398031-1-pavitrakumarm@vayavyalabs.com>
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

  v12->v13 changes:
   - Removed all the sleep function from setkey function
   - Added shash implemntation for aes algorthims

  v13->v14 changes:
   -Added fixes based on the reports by Sashiko
   -Removed the spacc_is_mode_keysize_supported call from do_one_request

  v14->v15 changes:
   -Added fixes based on the reports by Sashiko on 19/jun/2026
   -Fixed styling in the Kconfig

  v14->v15 changes:
   -Added fixes based on the reports by Sashiko

Pavitrakumar Managutte (4):
  dt-bindings: crypto: Document support for SPAcc
  crypto: spacc - Add SPAcc ahash support
  crypto: spacc - Add SPAcc AUTODETECT Support
  crypto: spacc - Add SPAcc Kconfig and Makefile

 .../bindings/crypto/snps,dwc-spacc.yaml       |   50 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/dwc-spacc/Kconfig              |   83 +
 drivers/crypto/dwc-spacc/Makefile             |    8 +
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  981 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2553 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  859 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  293 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  242 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  385 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  113 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  328 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  653 +++++
 14 files changed, 6550 insertions(+)
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


base-commit: e264401ce4776a288524e5b87593d4d864147115
--
2.25.1

