Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F132FDC38
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 11:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771501309; cv=none; b=Clo0j60tX37BnofeZ01DXn2BaqTeVZ2NJ+76mAi0fGICJYFM3STbEaEqF4iO0qUzsWJQvVHwTmJIIx05jQgXF6NFAxlEDbL3Ovwszugr2IPYhb+kWNTnwkxjpW32W6rIlaRC2FPgba2Va7p1Lo+c6zN0DzFXq6uXMp3FgkuUE+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771501309; c=relaxed/simple;
	bh=8/1jiS/unXwFeTtKZ5GFPZK5+wQAryhDKIuhlJdlgeg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=biMqXZxYKhqp3JfKHOBy7RI3+97GiTYsbE7YPOW30KINQw5He8r5VFCt/Y+cHDO7k7/fns90xKCv4e9Tj08jnjxhSkRvZPP//6O2xNISKS5yDgyN6awXLos0hrLDS3+We+H6R/0y0F+9vwA6pykqOcxSlLsmzkJtOyRTIeOAlZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=jv/kogkW; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="jv/kogkW"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-35480b0827bso530877a91.0
        for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 03:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1771501308; x=1772106108; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xYarPc7OYpRPJwKoVkXKgM17kbatz0FH5pjUD5pGv5c=;
        b=jv/kogkWZxfBCVSnvrmHoy6wpCfezRdD3a7jXz1MBettzJjyHBzWER+9Os4PRQh/44
         lxfhkcfnAL7EMMHNCxqP9WjCAq0dXLvCMKYBAs4CMdWyCGsW1WgMgvesXd76b37b9aqj
         bQjrRtKWY0ZFlR45BYFmQJ+IWWEhR0M8xKTzg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771501308; x=1772106108;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xYarPc7OYpRPJwKoVkXKgM17kbatz0FH5pjUD5pGv5c=;
        b=XbCf00TKJ9c38NE8wGIfSnRJbUip74a7cZuUYL+sGEmTWzFDWFUwVUgG3hx5bPu4Zn
         jWw5ztSwXdVPowEQA2jUQomT//5fS43Swvw5SzvJCaiIHGlLW4KbcSrSmFCde9SCyxgH
         SGp5fcW69WRFvlt4I2MC+qKGDJb5qW3zTtA93D6UzPlSunSQsETdFqJnKwCvPLUZdeNo
         Ne748FUhX7B6kwdZLwTD8r0HR0AVnv9jbLBOsx62Wbx+M8Eoj5tAuObC6DB4t2tcLfBc
         1tLUoIM2O/SaeGrfCm4IPcKKy7I4anY/mIzAmAyUhpJ4x2Zn05UuP6WefCkQgRG9W+hC
         cZfA==
X-Gm-Message-State: AOJu0YxPZ46THFR/9fr2Rng/6Ydk1c+Li0gERjHCJghpbrZrbHnGsQ6K
	t/SnU5K3Y63oPyhgH2UXdC0JNNHoZKjv0EKlqqxAR/S6jNvARFZ9cmpIR2Jr4hh16ihb2JhiT/1
	8Jazy
X-Gm-Gg: AZuq6aLKgnYqgdW+ydmiyi+3Q8tTNtLtsxu6IZBzloamOu3dsMhmhAQjzALGX5mbN3X
	yyDshAAyP+xH/HhmQWFSujsm7cWhmxqCvpCNXcP0eNRgu86o8rWxfNjwymyepfGLRWuede+fKWW
	vCnyvN2hdnwDx06MTtoaAXQqXaJguULRppOApvzZbtAqPIvrtUUA+zVvhfoT3ZHzrn4QwTsS9MS
	cSA9yKQLwxHdHKLnK/UZSD+7VbvhmiM1BHubB1PL/Nz4uqUf8Hl7mE5lxhkAUe+42iDCU7y5ObO
	BtFHNd0yGh5PkqjORFAircTs0Oc7vpMqxhuHdMWfuH2VKZYUoEfF6vH3kEoY8Vzi7jxyDaTZOtV
	jAA3r5NORKTe44GCkrBHcx0piD9SqoJOoIZHY2whrqKD07ZPGDB2ZIJubE95RUnd0W4tlipE71s
	RTmB07Nu1HpO8qIP7LYGQZxIb5Rt5t29EnqQ34kqqSeOerpihU00wcn2mMyX0o35+yOxaoXCQ/a
	PZB85jD5g41RHm6grN7/5r5NEtJFcydgKdQESSte8cKtCOfvF/XtHd5HPkjQgj/3PY=
X-Received: by 2002:a17:90a:e706:b0:354:7e46:4a8e with SMTP id 98e67ed59e1d1-3589851f189mr1576547a91.7.1771501307803;
        Thu, 19 Feb 2026 03:41:47 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm27442358a91.2.2026.02.19.03.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 03:41:47 -0800 (PST)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: krzk+dt@kernel.org,
	conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v10 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Thu, 19 Feb 2026 17:11:26 +0530
Message-Id: <20260219114130.779720-1-pavitrakumarm@vayavyalabs.com>
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

Pavitrakumar Managutte (4):
  dt-bindings: crypto: Document support for SPAcc
  crypto: spacc - Add SPAcc ahash support
  Add SPAcc AUTODETECT Support
  crypto: spacc - Add SPAcc Kconfig and Makefile

 .../bindings/crypto/snps,dwc-spacc.yaml       |   50 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/dwc-spacc/Kconfig              |   88 +
 drivers/crypto/dwc-spacc/Makefile             |    8 +
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  918 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2413 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  827 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  276 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  236 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  374 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  114 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  328 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  610 +++++
 14 files changed, 6244 insertions(+)
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


base-commit: 0ce90934c0a6baac053029ad28566536ae50d604
--
2.25.1

