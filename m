Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E79A47DF98
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 12:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784808146; cv=none; b=W9lzlCqgFMVGaCBNvaskjbhF2MU6D10OlARF+JhgP8mmIPFWklZjApGxRUnAIsPe8uoUGLuPU3ywRxfUUc7OXrZOjWpmU4E5RJRHG4WkI5a115UeAEmI9EI0jvPYt1WA4C7vPsV1fzr+mEnkbsTQl4GLUlZvnLuz282tdZsUKUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784808146; c=relaxed/simple;
	bh=M082/Bc0PcIsg800ItldjwxHDJ1EKUes5ps1OYryoO4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=akxZP/zRRrn6sHnzVEK+MkvQf5AKOsA+XaD6kiRleHFsyuXvNZZaa5e1F1nhap5ETku6nL1hgBLEnvymz5H+nXXRgwl6PEu3tl6Xicjf06CsmdxHX1ErXLzr7lKryWvlCQZ94q7l4SBezehzDas92JQX074/sZ31HShjEcKKTRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=KvucOJ1A; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="KvucOJ1A"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-ca913a601fbso380509a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 05:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1784808135; x=1785412935; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1Hf/MAzl+A5kzBUy+aPzvdYE3FXYA0Gg6VzRMyoLwnA=;
        b=KvucOJ1ABD8Ojm7J/bdI4f4hp2ovPaf83nT+Sw5/CHJwlzuJBJaXDakAb//NIZHMsX
         H4ouEM0HMCXkyKUOGP+KW9pJWJzIziTG68vgpJ/K/nnoIE8+ksmIP/cGM5X4zl+G3fNk
         uKoQUPSeo1GVJVOW8KlmS/abCJu/y3e7yuxKU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784808135; x=1785412935;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1Hf/MAzl+A5kzBUy+aPzvdYE3FXYA0Gg6VzRMyoLwnA=;
        b=kLQe5Pd4v05EB/MsBsE8ZLjgiY1V6T9rfBmzLCpa7aqpX16ipLE1Dry3MBWKvK6vVi
         WNJ4wtBI2/r6DHd17bE6hcAtXGd8s6jvHwJ9/Sb6y8ZatskT5HbZxiZAr7Hy1YWbhEja
         nf+l6iiY0odRrvsGjlTP3O6NoocvBbstcb0FP6zA8s3pJTOgT8ovWXLTjh5HjKb5rW42
         ED0kP93xH05U1RntR7PGB1Yozqeg3SQi0V2l1ZJXeste+iUiz3Vmw9ocOEqJ6KPWft52
         oU7UEa29WOgdvLJNRBLZyRzaPXHEHiqgB8eq72IfOPxlxcibbmLKKfAq90RJh4TMmELb
         jpnw==
X-Gm-Message-State: AOJu0YzGcQlpBClAC9nXkOyaxlKW00/b2M9mV3SVCsCn1BnHBM5+a1LW
	5IdyyXRHMHnuze4I/ysoQ4H/LaSuyOMy/tZ9zA/m7NcV/3tCQAnDCNwZS1ujXn/5UULXVOheW5m
	Q2Bu7ex0=
X-Gm-Gg: AR+sD11Zm/wwhLSlIxpJ5yBl+mYF8D0SMjBn+lxjXK0ozzk5w8v8bGK7d/Tb9x6uqhP
	NnIeb4TMrvSjZeSZyal2EaoAp91Ua+eXr0m96EkAkqL32vULqW/KDkn4b0faLjffTUrvYSMVyQa
	bhPVsAD5sGXZQG3VRrpJdYnMMG4nP6AZ9wBDNSHN4p9ZFf2dNJzCQfFFO2GmatqZFFOFQCmrZ8r
	AA96XkLl9mB9zxkxsQyjNkuHm9hxoYg9bSpBA1eI9uWb5lZnaKNp44wyaVkjiJb6Kb2eR6a3uwI
	QQ07mBhLRk9pFFBoHPHI7rb6/vgYVEmcnG6I6qUS94HhDHiCeHuYzc/oqwq4QK9BbKQmDtmpmX9
	aJakVKwUh6G448LCH+6AlbZgR+DWkSP7F3wG4lHgpL/HuaKO3oq8Wds2by8TZ8Ixhx0ChiDog+O
	1tNI+hyF58ZAigld+ORrQEC/v1HK2qgKQmNUHXp2BWI/CBAwFMz7WyABlqIjSmNhqJ1d5mpS/sM
	5tMY5uxwoV/yxNdCUFs13WSOA03ynEqLhWNDIJKZbSuOeBAXYXDEuPi
X-Received: by 2002:a05:6a21:610f:b0:3c3:ac9c:9a6e with SMTP id adf61e73a8af0-3c44b2ae3bemr3089856637.68.1784808134651;
        Thu, 23 Jul 2026 05:02:14 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147df06864sm19359125eec.15.2026.07.23.05.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 05:02:13 -0700 (PDT)
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
Subject: [PATCH v18 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Thu, 23 Jul 2026 17:31:52 +0530
Message-Id: <20260723120156.285270-1-pavitrakumarm@vayavyalabs.com>
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

Pavitrakumar Managutte (4):
  dt-bindings: crypto: Document support for SPAcc
  crypto: spacc - Add SPAcc ahash support
  crypto: spacc - Add SPAcc AUTODETECT Support
  crypto: spacc - Add SPAcc Kconfig and Makefile

 .../bindings/crypto/snps,dwc-spacc.yaml       |   50 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/dwc-spacc/Kconfig              |   83 +
 drivers/crypto/dwc-spacc/Makefile             |    6 +
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  990 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2554 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  857 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  284 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  242 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  344 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  119 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  330 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  665 +++++
 14 files changed, 6526 insertions(+)
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


base-commit: df373d39c6f038d176af303ae72f02c7c70b953d
--
2.25.1

