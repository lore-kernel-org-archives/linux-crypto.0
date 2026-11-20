Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795180476;
	b=CwXVCs6ILjoXYPdZMHaC/XAp6eKTCTZGPGfKtnBNIHU5Z4xtefjS/3Tymu3tER4lAiX2
	 c+F0u1htoY3Ro1ZVZMb+xMeEcAkrd+VgyVzU18PiaFUv1LV2VT4BR1WnPCShT2PBfOjW6
	 BU62Q7AG5XE8JWIuBZD02twmUDG4G+dAgDeGG8jg7cfEMlrmH8Lkubt4t3domAYaDZRAk
	 A3/WDCtpRPtdHJkGiqw8nj5Mwp9m9rP+YxgbKoAfGYmU+r5eQtzO1M0TuDmINtt7YRSaF
	 wDHbYP7a3m3ZZ5CljHDNBOOEs3dIbNJ3zmja9qnlqCi+l3YooOL8K2InQeO3cjqyeRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795180476;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=hjx74QNy+MSSsM7cOslayY0WHKegLjGzo68YRxpsEY8=;
	b=DluKX/GF9isavKKqtykuUEkitsh4hUECM3s1yaxMgDsUbxyvsWSgWhTs0j2Ymfiibyqm
	 nri5P+NQv+zVrHNR3Gm7TSoQIFg4c+JXeCTYXGikN9Y7Smg0zoIAEsW2RyErUDQdvFyEN
	 L1v3sECqfA/BgMGJe2+G0Kz5nVtbHdGP3N4rWGIYl2co9FDjSr5XS+IdQvbaxjfDnV1i9
	 MkcNGTGN0Kzr3vAPcLWA1b+nRJYr75XuCaj6YcT/IstRX4zaEXIEr4PzMjMhG5OO+2sSo
	 0ObIwwOaTSyf7gZx18toy9EJsEmXHXwtb+fXbYblMs86HfXaMtAAacodnyGkGkw+G3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=vayavyalabs.com;
	spf=pass smtp.mailfrom=vayavyalabs.com;
	dkim=pass header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=nn7eVHwe;
	arc=none smtp.remote-ip=74.125.82.172
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCBA606A325
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 13:14:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CCBA606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=nn7eVHwe
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-38431138772so1065302eec.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 05:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1795180474; x=1795785274; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hjx74QNy+MSSsM7cOslayY0WHKegLjGzo68YRxpsEY8=;
        b=nn7eVHweC7R5E4OUvSfI6YzB3MDRANV4gkrXAH2warTDTrW36vOXlgRkzAjkIzHRdE
         bIWYuBXD4xlmccodtq2NlbLynIrCkrcOpnVOQbANmHXv+/7oiBUKpCjdUG8n5/te1nCq
         87EWjHg+Wtv3SOravmSeqGmde1f/i8iGuBU4w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795180474; x=1795785274;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hjx74QNy+MSSsM7cOslayY0WHKegLjGzo68YRxpsEY8=;
        b=IzkKYuuOrrk7p3MArzSOWZJbIfphkTfTzb8exkFuZU9Pj7dEsRlE58fFBSHWE8wbhx
         qL/fn4BnoxAIb42BBmeTzOLTCHqh8oe0VbejWacp5UfFE8f79n1u/sTD+gFS9R2pGc5x
         CkfgFEZIJoPnAXzTQLXZVUJeFWZCpARkU9kMHjs/1iKoyKqNmkA58FZVDGbuMwA4UfJn
         pLvpt1vU1aLnXhneWRSJBxEpRCF3b2dpbEr3ZTD5KbRuDpwD4T9FI/0yy3F9Z/UVtI0r
         DhEWi/w9vn2TO0pLgeiuS36W5Zzn7+xisGw3Eb3b3sHFAuONjLeyo8Qc+l++f9KzjnVY
         dHeQ==
X-Gm-Message-State: APuU4Z9uprbweUnfqFO2cDC9KFOvJlOG9choJD89WJjPeJMt4Lsa4DsI
	/xyKddvOsA7yiIyTfPbSONCxC6UXAnCLPbg1oFwmR6/YZdeGhDNqPzXvirT1MTKr6Ygb6aVBJpK
	uCXaH
X-Gm-Gg: AYBFou15CbGolCtYl0UFkCBDEitdZhnwo2/yHuKE2qJzfSGuhmJy+brWAIN2x7f0oUy
	HS+IYbn6PGSd4ZPzTozo9lGIBcpSaDEn51wAEpTlMXVXWxLoriypywVypkETnoiUtjOIfJM8hmE
	rMkiahAMz6bKc08xTILrw7+HMmoyAkOENyIURJm/REWRNlAUtlXoNKjKs0gKMachwVK76Yhp3y4
	5iGLVemDplOfLy6JtxV9pUUFP/PgKV2R7N8jKUxzJrCP+VEXt0e2qVR+wUkKs+rmeXghXiJ19/N
	WLeVh0BdtFmMwv7eYBx9Y0EuZEZONeuLABLghmt0zqYtmglobIeMKVRajR5o0HPg/rx4wXZdrp0
	r5Fyfl4Jvx4GbEEEvelMK/QEAHA9zENWcZr//ol5QoCcgJL8zMERwes37eopfoEfPwJYBPHbqGy
	yj8xUY69D2MHbLjnKBS5cb27so+5fKNynCr2RzPo42IIEwNK3o4uapm2QB778eNqxQ6wZVov4+g
	KnTDZ2QC27VN2iCVqYUsyFOCvvBEWvR2tyGOMiLNTGbN2qUjOAqsGu22rS7v0RxXhL9WOB6NG7X
	LB60CdUTIaBS9zAhjtIHY+7asl1pSQL+cacsqy6+eZf0iJ9OgktvPFyLH33+vndl7KIqlW9KukJ
	8q25peIKqjvdjlg5GsAXu+1TXEKczkiefuwKpacvCWfYBjsjPO0EV1GA9KcvkN7xialg0zWhalZ
	a3gmKg7GkCGVTxJg==
X-Received: by 2002:a05:7300:e60c:b0:386:636f:c25e with SMTP id 5a478bee46e88-386636fc6f9mr1060801eec.12.1795180474513;
        Fri, 20 Nov 2026 05:14:34 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385677c349csm8900527eec.22.2026.11.20.05.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 05:14:34 -0800 (PST)
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
Subject: [PATCH v31 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Fri, 20 Nov 2026 18:44:00 +0530
Message-Id: <20261120131404.976959-1-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the driver for SPAcc(Security Protocol Accelerator), which is a
crypto acceleration IP from Synopsys. The SPAcc supports multiple ciphers,
hashes and AEAD algorithms with various modes. The driver currently supports
below

hash:
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

  v23->v24 changes:
   -Added fixes based on the reports by Sashiko

  v24->v25 changes:
   -Added fixes based on the reports by Sashiko

  v25->v26 changes:
   -Added fixes based on the reports by Sashiko
   -Removed the additional fallback
   -Added the CRYPTO_AHASH_ALG_BLOCK_ONLY flag to the cra_flags
   -Minor code cleanups and style fixes

  v26->v27 changes:
   -Added fixes based on the reports by Sashiko

  v27->v28 changes:
   -Added fixes based on the reports by Sashiko

  v28->v29 changes:
   - Resent with patch 2/4 regenerated; v28 2/4 had a corrupt hunk
     header and failed to apply. No functional changes from v28.

  v29->v30 changes:
    -Added fixes based on the reports by Sashiko

  v30->v31 changes:
    -Added fixe based on the reports by Sashiko

Pavitrakumar Managutte (4):
  dt-bindings: crypto: Document support for SPAcc
  crypto: spacc - Add SPAcc ahash support
  crypto: spacc - add spacc autodetect support
  crypto: spacc - Add SPAcc Kconfig and Makefile

 .../bindings/crypto/snps,dwc-spacc.yaml       |   50 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/dwc-spacc/Kconfig              |   64 +
 drivers/crypto/dwc-spacc/Makefile             |    7 +
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  806 ++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2407 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  861 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  340 +++
 drivers/crypto/dwc-spacc/spacc_device.h       |  178 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  349 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  113 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  365 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  641 +++++
 14 files changed, 6183 insertions(+)
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


base-commit: 04cd6899aaaeeab82afb97e58eb8619fde35b47d
--
2.25.1

