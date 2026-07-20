Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482CD3F58E5
	for <linux-crypto@vger.kernel.org>; Mon, 20 Jul 2026 11:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784547508; cv=none; b=KJpek55zCUAJmgQDCfSnY60R8V5bmGmRcB1DBBAia8oT2788GsP+QVfLLwAEgO3Dsz9EQM8iJhS7XBnxDscb0pPAoMI0yAZZUA7VW6HfXaKY+Fjoaff7TGYAm7ItqTGcrEjQzb0498nbSC1KpEJ4/QpePpcCwy4Bp6qJ600bPvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784547508; c=relaxed/simple;
	bh=WHSX0CiXkmAHlQDT2B33HSFixaqi64HAtBstuM2LpZk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MDRNPmwUMt4wdCVDqa+yw+DG0BkKZOdHQZ/VYwVWJrP+kBGZgXr7SzvbbA3Gi42HCDAQD+3IaCvVszzASAxRv/EkTG8QLoJ0vc095kX8F2tvOm+GhdnWiMWAzJsaj6bL9erkGV5631fZesoYYAQH2+CRLsuybZt0q8+MdaA6SrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=ozau4HFu; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="ozau4HFu"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84864086bfeso10558839b3a.1
        for <linux-crypto@vger.kernel.org>; Mon, 20 Jul 2026 04:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1784547502; x=1785152302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CkSnkD30rPlcP9a4liEy5/m8D9pofUFEEKFpFec/ecY=;
        b=ozau4HFuMzxpYz7BuroeKK5kRMUp5KVe5KCS6EUZS/GKs5wwcEsRhkGW4DcrRL1oQL
         Jywi3msklwhjSg0Vbl+bf3IaBrCt0rEr2ty5zBEnwns0kdjIHQLKJe0BZXfJlYUcA+Uv
         fUEY93YKIXXCxrq/pu1ftzJ9OC7dldwPHEcOE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784547502; x=1785152302;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CkSnkD30rPlcP9a4liEy5/m8D9pofUFEEKFpFec/ecY=;
        b=r630spIBxZkLmlfbHedJg3kOwV67CylFikPtonhCsU6VeNFfmI92QN2MRHzjwvVVwF
         DFxfgmtHV/YifKVKXem1zSXkX4i5a8ZIQao0wEoZPKUDix2Ls1dpgCHP6ff4PLCQjPXH
         gWeDnRNWhrFUjtxATWJBtTEyiNnSCt+Zpd0iCcuEA6k3j3G3GEuiqtgljy1ymGgdXAZh
         gJzHG6isjDp7SR/GKycIPIif7R94BysJM2TOrKbhM4sIrlprdHldp3ipShOCqsekB/Bx
         K3ID7lr74gY8JJ786QEEAvqnvXdhetfOUi6JnfK5Q/zWBcdfj1eHkMG7B0GfKiYlfoeu
         X7Tg==
X-Gm-Message-State: AOJu0Yyj8HPTNPwkiGqkj6CtZQNfz1gfzHnLAEuAuzD/dY5PwTwCvpmz
	3TpxGKklfXs4rkJEN0xWkB1pKraOPGMzKQStaBsu7Fg1eUfsh5szjIhfokzYFQhNw78vDo6BjPB
	NAOMjBRE=
X-Gm-Gg: AfdE7cnhD6Ady7KE9TqHaOQAsleTa/fVKtyg9jZeH/bxNjfR4gfDCntb9iY64W4ikvT
	eVx9D6QXRzEQW8iUX7x+TVD0NGE5qWmnoApO/HFjuYu3OaotMgWKucZDjIfkqFAmkZot/ZDhum+
	9QUGK/Op871KiVaTMrOwm0dk1W9i1BQAt1ZN0kBVx9/Eyp61T+BQ3ZoftU/HmqjFe9W1qOXW3z/
	mNR1SBmbVASiQn1jJy+N3HF9WTxeoE6acgZplEyrN0z/JsKvfgTn/34rEXwDRbsjM+gvBzQ6on4
	opruX3Oa3plGlw9dx+ovs3aKxFi88+JrZzVDfYiT/mnzso5Gj3l3DTNuIl+kmscXCfWtdjOCahR
	rakCTOAp7IhL1JLPXkJkBQ10qOUHMejb0oN3y5Do1JeAoq7LP0h50sAiHj9I2O+iUftsNSpN3Wx
	/tRfeLcgZisADJSJ+tLBQ+ziAagc3HYXai25IAn7B4fOi9Wou1P5BYuzjXH2So5hcI+/kHzJQTO
	nI9HnIpRrxYzle6QvBP/pGvVh+331eQEsTJfdOMTnxZCw==
X-Received: by 2002:a05:6a21:9206:b0:3c3:791e:5e18 with SMTP id adf61e73a8af0-3c3ad5d4f04mr15063028637.7.1784547502473;
        Mon, 20 Jul 2026 04:38:22 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1dde81sm61824393eec.21.2026.07.20.04.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 04:38:22 -0700 (PDT)
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
Subject: [PATCH v17 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Mon, 20 Jul 2026 17:07:36 +0530
Message-Id: <20260720113740.64960-1-pavitrakumarm@vayavyalabs.com>
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
 drivers/crypto/dwc-spacc/spacc_core.c         | 2551 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  857 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  284 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  242 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  344 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  119 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  330 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  649 +++++
 14 files changed, 6507 insertions(+)
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

