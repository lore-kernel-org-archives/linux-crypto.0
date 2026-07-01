Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3944C4ADD8C
	for <linux-crypto@vger.kernel.org>; Wed,  1 Jul 2026 12:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782909099; cv=none; b=KulEsbl0EzFWvkgTyJdsFjRZJ4DYswmwcHSagcef2eORimlZDkCTjKqn/U1PJbrrJpaGCYH5ValXqzXRd9C3wr6IrfsaG9ARmq8njYig9Bv1JVbtof2prJbfjxUQ4pJExyVf4W3HzIWJsU+oqoQ8lZv6HQnEevxsOjrWt9GxQzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782909099; c=relaxed/simple;
	bh=eFH/sjnt4IEYz5mhll8WepPz7x2qr9e2I1hac3rv1iY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nn7lyWqAwa/Bp4mrIpUpYogvnBEc29aGsWS/MIdXMl7vpHs/yvpu1tMzyRWWxil+GvW6nCax6vsOevARl455GNgUkgDY+rjBvttYgu4sEo1JAfyPNw9itki/iW6exqBbJ5qOfvbka91FF4vrpRYMI3Fue7fPynqW8ek6gtP3EI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=l954fuF1; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="l954fuF1"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-30c965eab27so609249eec.0
        for <linux-crypto@vger.kernel.org>; Wed, 01 Jul 2026 05:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1782909097; x=1783513897; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0OJMmZXivl0437Eltoxt1oS/HCivx4gHSaPKhSGtPQo=;
        b=l954fuF1cBmqZsb8N75YHfaXNFtv1TCUezPLIkubHp7H9Oy7UhZ4nTBGIIbzQRUu0s
         0T43vKGas/CCnU6R/H9lYWUuQ/zq03zvN2oOPgOqwYC/HXZG/FRaogsxSNA87s3aCoo+
         g49VQXEjVqfBnfplBgfKBqGt5DDL2Wcg8YxAM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782909097; x=1783513897;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0OJMmZXivl0437Eltoxt1oS/HCivx4gHSaPKhSGtPQo=;
        b=CqRW4RF2XmANh0SCz/tpfVTCkKIR7MbV8gO/1rrAI1NS8jMJul4nllEny5tRiZj9fU
         Bf5aZR0Htpu039u6GKuJIBVBQ+5NuNnehQ57/nU6feMGLxjosbDW1vInK51n7DD+fgyf
         WJ/cLdGkArZ186R74CyH65yvTCYjnQeOz1x1p9mf2FlfLD+TaKBKFftozytN82upIh1M
         TWTwMFlu0sjPtvApaFWhR5jxrZaUl31AXnSvjrumgwAJFF2RKfRTmbXOmz5Y/FzWLJhr
         6fsDd++jTvTKU0RovlcKrK2CLm9ibLHpPlbfXjyw0Me9JsWkoTgWYkxJXzgNZV7+N1ia
         mOWA==
X-Gm-Message-State: AOJu0YzH4hn3WJhr8vMtEVu/HYZN74dpgAuWjiLnqgRnA3lFZd0IpDVk
	E5wwYk45kYtypdLYWDbRixAoJnUoAsb8Z0rcnE5e39OVcqpU5X8HmPlR2MZSDzoKiKdTqz2qcnN
	bMOY/
X-Gm-Gg: AfdE7clHUhGEUsF5aCW5W3pVerGixc0TGPwKI52PiYkK6dR5QAq8kl68txLnZKdzoN8
	SSvbxaYc4pHcPtrl9wiLAhr3la8HrSdpWhAXDobH4GmPyPTEaYfJRUsUCgtWwgGhaXCEij+1zOr
	NeDs2Uh/QBAn0osdyCcbi4oLmxN9o5GROZt692o+R4wF1BpT8VBcOxzcW//5IiqXM0z4BAZ+Tiv
	oxetlfBqn276yQBhgMl2GXUCyzeJy2gu9Dz5OriHHuBaLpl2ayaUt3/0w/u5U9NulSgQViwsgKQ
	3FNNbR9oWrErGgt3BOGY6Iq967OD4D0DTUs/6pvuhsfG3gUrKh6D6jkjKnB7at4M9MJ1+sEhvlw
	1yft7QD0+quixb286gu9daaCuoaCn7IdXHqGtr7X/gIBMIWm6i/ECMYaPoqjp4yOqG8yIUZ2aDE
	QmwUxRsF2koSVXr+Pf4rhRnoq6am3gDm1BPKTikFgLRQwydIQqLDD77Zn6lwES1ruOS1a2pXh9E
	PXLBPnwLuokOKSU47iSzBCZgw5hrwRKHBrv9ywvlQOw4x5Kx9O6oO6i
X-Received: by 2002:a05:693c:2286:b0:30c:d60:a879 with SMTP id 5a478bee46e88-30eff329b8amr1942342eec.35.1782909097097;
        Wed, 01 Jul 2026 05:31:37 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30ee2cd21bcsm40776402eec.0.2026.07.01.05.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 05:31:36 -0700 (PDT)
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
Subject: [PATCH v15 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Wed,  1 Jul 2026 17:59:37 +0530
Message-Id: <20260701122941.2149121-1-pavitrakumarm@vayavyalabs.com>
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

  v12->v13 chnages:
   - Removed all the sleep function from setkey function
   - Added shash implemntation for aes algorthims

  v13->v14 chnages:
   -Added fixes based on the reports by Sashiko
   -Removed the spacc_is_mode_keysize_supported call from do_one_request

  v14->v15 chnages:
   -Added fixes based on the reports by Sashiko on 19/jun/2026
   -Fixed styling in the Kconfig

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
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  929 ++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2532 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  853 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  286 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  241 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  371 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  114 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  328 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  612 ++++
 14 files changed, 6409 insertions(+)
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


base-commit: 6ea0ce3a19f9c37a014099e2b0a46b27fa164564
--
2.25.1

