Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D9F384CED
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 04:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787805858; cv=none; b=H/+qekAX7NH3Leu3wxt8YaR83gL3XzHor1o3K9Me67yxvXSqQtFrJtKVibiVIHQ91xyO52+eK+qXi+lffF8KfhQqJ+dKFMLuwFrmVMzCcpk2JWUDjGOTrb39Tyr1ME/7Cv9xznpUwjRthv/NXAMWxDF7Pt4VxWxwtwVK4tdshHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787805858; c=relaxed/simple;
	bh=BG/UofXnKnZywA2U6idAdD0E8cLR8YgD1/osdbD6xJM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OTEGU6zvkudHzwl7+eeEP4Uip1+hEvD+f/WjVYTe9NtCJwG7nXQrh6MKidPpS4rS/SKILRTbp+C56Ck14Xmgm5jHioU/nPO2VpILMs6lxmDqNldRMMqJwONZnaV1LaLKrvuNfvml0b+z3fZIgdA4O12JUlala6DVEIXEyU5oCAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=Qg++3+VR; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="Qg++3+VR"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc11a905ba5so1206514a12.2
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 21:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1787805856; x=1788410656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bH3KpUEF1vDMmsipPcGYKIha95WnlMC5Rfa8mpI/gkw=;
        b=Qg++3+VRB3GwRcPhEzxnXzBBrZeirDnmfdAq/22SdYsYCbCrXQ4cRKkikzFzK8Jg2f
         UvHXlKxcnCPMEPRuX/2hViv9T7vYpGCJrmDGI5s5wjJR+JmA32suaVTn+JsqUVC81vfk
         kFblRQAhPX6PTms9hmpmnsIsRARMooGaNIJcs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787805856; x=1788410656;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bH3KpUEF1vDMmsipPcGYKIha95WnlMC5Rfa8mpI/gkw=;
        b=jXoYUYqeQDsGk1WVyihyYvQfwJ/kBxI9jIqMFdFU7dgqHoVkT7PQ2W7etsBHDH21A/
         u+x+4h/PASk1LRzcLOoSSUUtJUjCRw9VPUYxteBj6MdsZcW0LbLGsnVPnk3FETxurPSl
         rz2IGhNzZfXS5HSuOl0BoL+oFZxTLVuqp+sGP+Q9zSBAkQzXDWa+SbeBQJTOX7Gxk80g
         nezniiiE3ZgdOheNV2+XrHeK02RoBWh67GLb7IEeEErP6o+EIoLvnRJpkIabU6nI6mUv
         F3TWDtHdwsbIZhaqlCwjpMFM41V2Q7BbTusS2pj3kjL5e0fIGkPcIhLxw+IQ92zkv3iJ
         2W6g==
X-Gm-Message-State: AFuF++mNqWTmsHqhEd9dav5NVn5IadtpJVZfEOfnTPJMILB9JM0C3faL
	ZHd/hX2t+vGbLTxhcPqpjeW4bPlST8gFYmdA+ctn48KPC6UtGtRaXGxmqId4k76pzAmue4/60Pc
	rWpUt
X-Gm-Gg: AR+sD10zE3LX6R+ZrsS1sjxbd2LHFKgVwmb7ZXPEU1Ny301AqBOdg1CuH+NyIon2cZt
	Bpf0AEYMfw/fTpVwZguefUqReSsT36iQhtq9UJ7OE/n9UzqSXe5fU00ORiIJ8vzyVuNrKW5QIBb
	nId4wL00s5dBErzmcCOsyCcH8mCntEIKRstzwMZh6g7Yc83Ik1cmYcr68csEEQbD5e4CDvPZpx0
	SXnGrWD0GResa794AyUqUOddA0+JGdnmhPokN5HlhH70odIbmvzHMVSb2mUYtWJql6obh+CqO0m
	DMfBeSpYAcsRWto4HftpPllA5a7vJ9w7BNf1vWSbr+9I9zcQd1G36ukc9zgRpwb/4V8sWtO4tXB
	pqroVSNCNEu1AxZ9u1m2WimHFCdDVlF27GBdMiprvMcp1h3BBqHzwSROtqn0o1oSao6/O7DuYpA
	IcsTC5O9uc2WVeA6qqxuTJT/VOJ0fmYn7HTtxAi1fwMgExc51ILflmoNkr8bq0ZR1Aq0XFADxao
	2cV8ppiI4YIAhhlp2J471YgLRMaCUKPHsWm9Q2D3IkKsA33LuNvNOmDQ+gzEL+8byp+sHudmEgy
	/AwkfgycvDV2aWymO9mLCs8KBvM2
X-Received: by 2002:a17:90a:d2c6:b0:38e:5c6:4db9 with SMTP id 98e67ed59e1d1-3966d3dafb9mr26072767a91.11.1787805855932;
        Wed, 26 Aug 2026 21:44:15 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3283d63bb23sm14554224eec.7.2026.08.26.21.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 21:44:15 -0700 (PDT)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: krzk@kernel.org,
	conor+dt@kernel.org,
	ruud.derwig@gf.com,
	rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	nazim.khan@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v23 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Thu, 27 Aug 2026 10:13:45 +0530
Message-Id: <20260827044349.826534-1-pavitrakumarm@vayavyalabs.com>
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

  v15->v16 changes:
   -Added fixes based on the reports by Sashiko

  v16->v17 changes:
   -Added fixes based on the reports by Sashiko

  v17->v18 changes:
   -Added fixes based on the reports by Sashiko

  v18->v19 changes:
   -Added fixes based on the reports by Sashiko

  v19->v20 changes:
   -Added fixes based on the reports by Sashiko

  v20->v21 changes:
   -Added fixes based on the reports by Sashiko

  v21->v22 changes:
   -Added fixes based on the reports by Sashiko

  v22->v23 changes:
   -Added fixes based on the reports by Sashiko

Pavitrakumar Managutte (4):
  dt-bindings: crypto: Document support for SPAcc
  crypto: spacc - Add SPAcc ahash support
  crypto: spacc - add spacc autodetect support
  crypto: spacc - Add SPAcc Kconfig and Makefile

 .../bindings/crypto/snps,dwc-spacc.yaml       |   50 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/dwc-spacc/Kconfig              |   65 +
 drivers/crypto/dwc-spacc/Makefile             |    7 +
 drivers/crypto/dwc-spacc/spacc_ahash.c        | 1030 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2554 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  861 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  322 +++
 drivers/crypto/dwc-spacc/spacc_device.h       |  242 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  350 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  118 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  325 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  665 +++++
 14 files changed, 6591 insertions(+)
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


base-commit: 7537036a2e6fe96f8ed82034f755c54714a0e417
--
2.25.1

