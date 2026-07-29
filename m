Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C194279FD
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 10:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785320814; cv=none; b=PeWeFKbVFvf9J+YX9kRwJt4zJ+0JHG7WoYno4zZ6eIRdZG6Jzu1eHGYCgQLwb2SAdyidRwowqn+eGQGwzqfD9Ah/SbamrVZphtYhcCUiw8rOiG+IC6KB264Kgt+qjnpiol8pOaWf0ZccllYJx6t7XgR1zgRd2mGftgoLtAsIuq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785320814; c=relaxed/simple;
	bh=CygJ8T4Zb7XQcQUADszHxMX7rpY4dYAVC5v2dsy5VpQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mKAZ9g0BKdG1AheXTkdU8miYHuZb0frDJUF0COlEW3Dzt2Ajr45fnTo077+bzfF8MyY49+3qI4xbIUAPI8ZSvGn1V6ZCQcwlNNCDh0mexmrEGQcSsYCNQfVY8W8arTQ1Es5OwD+DfKdQ7ooTQz8/J442zu+bWUDMatxcuy4pVw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=SD151rD/; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="SD151rD/"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c9d1fff21edso430713a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jul 2026 03:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1785320812; x=1785925612; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4xKoJRB4NEHLYh+2Y3EmCp7IEodO8atnxKBQr+cph94=;
        b=SD151rD/8nSJlEEu8b7A+U5985VBFumEwxBn2flvIJVokBLCt1MZvrGPiW4QVVtTh/
         l3LcCHStTN7DQA9KZtjx2sKhOqyDk/tO6fUMQbWPI7LuIxwojcpf95Q/1xy8z80quBW1
         81OKkcfOaYmIv7Gdi0s3MkeLmvGHsY1C1NceM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785320812; x=1785925612;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4xKoJRB4NEHLYh+2Y3EmCp7IEodO8atnxKBQr+cph94=;
        b=ryRUmBoVbtGPbgJi4FYQmBgkOpNOBs/A4nmZoAJN63WbhFDNGlRyUrxZE8YN5aNae3
         V+6OkYOppQAB7Xa28KV9UzynmmOJQp4rxlplF1aktYtAMQ7scWB8Wpb/QLR9Gc05JvWl
         s4oRxOg3lDeeAYRKZBAgeJHAYMDjT/CNqcZTQbs7lO4MYEVGW94LpEec6Pgq82Ach1kA
         nlXnSgEVZDql+cNWq6zLQd8glkUvHCUYmHuhl6ok03RgOjOr6r09kKsUouC81Uj8mZVx
         EqMVmV9Bk6oubzD2E3alRiCoorMbojU+/dYX++9xW55HlMf2yHma3in19A14k3N1CNie
         v+/A==
X-Gm-Message-State: AOJu0YzVSKyDWKccWvrmI8mGpglovh/HahZ8Hk2uTwg57mCckxDDIR4X
	UMKbEK9POt3UJvJ0umlg1sOrk8kqD1bsONWKO4oYGKm+lRwn+0o0ZJXlb/emcDtnJ8OpM99DCYX
	/AQcx7G0=
X-Gm-Gg: AR+sD10tMiS5aOU9l4GTSRW5yeBfX+HH/eIjbGvycmm/dEVZDNC/iqNUGWrNSHFp9/E
	zRODSV2Es5j5b/8mgG6PKuSBcq7jQ2HSzfADyHo/QamW3W/N2eP1gXNU4ub92xnPP63haXZZltm
	5s7GXlRpX9s0M+vqgoj/6l5IEMDoeplWeowWCqjHI+jNKUxdR3ym3E65PmY9zBUadKdUOmMccdf
	jlDRtYq/TiznZiDxcG2SZWxTCtF9um3j7HZ8oRR4spaupTOo2x9ajmd4NJOtbVpeH3IN1Ubl2NU
	MOLDMyWnO9daiudJOmyZGdWv2PXhU+FxoS9+jBzHZ8WhINWpgcwjqmNh0tp478KKDeMoCSwhmcd
	gCDvpQO48OA5ggeDZTyW3WVtw2tviC528+T1GmUkYfbQ+xdHk6EO1psLqo/bWVAV3bh0qmCtkeZ
	/0IgZ/zyvU1NeoYKjOEdFsjRD9ocOpgmHQ1bbxAcHbSoF1Te5PZo9FisE9GdKQ/EFS4a/lS87uG
	hdxw48xHSgJVNBICufmhDDPb+hrhC21QxrFf8soWbCytwsWaTyf42a6jn4CQWGHRaiPSTsGtt1h
	z1gSAcd37x1JBbq+sKmMn8MO8a7b
X-Received: by 2002:a05:6a20:748c:b0:3b4:5c70:ca3e with SMTP id adf61e73a8af0-3c8ab0e16d6mr7808703637.25.1785320812201;
        Wed, 29 Jul 2026 03:26:52 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504b15f77sm9238958eec.4.2026.07.29.03.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 03:26:50 -0700 (PDT)
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
Subject: [PATCH v19 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Wed, 29 Jul 2026 15:55:43 +0530
Message-Id: <20260729102547.159890-1-pavitrakumarm@vayavyalabs.com>
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

Pavitrakumar Managutte (4):
  dt-bindings: crypto: Document support for SPAcc
  crypto: spacc - Add SPAcc ahash support
  crypto: spacc - Add SPAcc AUTODETECT Support
  crypto: spacc - Add SPAcc Kconfig and Makefile

 .../bindings/crypto/snps,dwc-spacc.yaml       |   50 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/dwc-spacc/Kconfig              |   82 +
 drivers/crypto/dwc-spacc/Makefile             |    7 +
 drivers/crypto/dwc-spacc/spacc_ahash.c        | 1001 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2561 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  857 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  288 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  242 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  344 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  118 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  324 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  665 +++++
 14 files changed, 6541 insertions(+)
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


base-commit: 1163a476a568f6c0f852d469c8e4c5a5f805adac
--
2.25.1

