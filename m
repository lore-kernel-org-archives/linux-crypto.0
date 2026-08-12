Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3526B41D234
	for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2026 17:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786557057; cv=none; b=JIynwF8KPJymlnZj2KezAzPqOnZyxgw8eW451xYvSnjiogWs9kefDXtqxMWs1OKa0CrbAxYVyYheKwtaxGa5/fYKVIjmEXMftQ1k6bpd+HHZTsCGIiAqeZyj61URpCQmq8FzlyQ5vZr3ojmCqEtZeUUm37/S316Xvz0zcxMNXzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786557057; c=relaxed/simple;
	bh=LYIybXT/A0uaqpcRo0vdSMiljxqc25gCsD62rIW6xO4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kpboHHqpIMjNMHPDvARHnbn+0j3cdPNdfrpDfeUNN/N4BIbHTT2ETuh9oC+btAUWv057ZitIjPWTTyZCjHVMghJi1ACv4rZVDNpQbv8UPAkr7qOqGVLFA5b1sCmvOugDU+VQ30DsRITiDN97JWIuyb1eCeC3Xd/pEptCdxkDARI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=K1QnUpzn; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="K1QnUpzn"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cb5b8572b70so1494635a12.2
        for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2026 10:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1786557054; x=1787161854; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+ibuzEPrLozk3S2guDQCpsa0Zmqwbs5provsHgkwyYM=;
        b=K1QnUpznZoQ4HAVhwLbaKbgxHZ5Sq4zfX2iYaMjpRaGrSXwbxSQbFo7sip/+hHVkmf
         HxmKgpNlSrjKq5BT8NuszQBq+mMPp/k8tQEQhQ0XrXT8CR3DPKCF5T46r6fXvKWcrsNA
         FHTQIYbtKvC2Hfv7BNJife+4msZ3dzYwp45Qo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786557054; x=1787161854;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+ibuzEPrLozk3S2guDQCpsa0Zmqwbs5provsHgkwyYM=;
        b=OeEtPDkHZHBXoHxYu+sKj/3J6XwaN+iNxUure151jSsrq078cEEpWIqe5Ujauvjzze
         CdrKeqk+Fn2XTb/xAm5vr9PPmKvSs6lpDRIFypHkDRVBTv75ZQlgIvMJ1YEPalQH6YZh
         tBuQUYkJOHdyc16lYSi5jVB6JtpcQfSSAxpRZoO8d5lEtrQXVpeKXyrYAm4zSEYtlvHa
         ekY+oZ6MupeWFXzhkqM9BhK7wzZBw6Md0Ec8s0BSrIO7qD96DSGcg3FB1vCwJBdbxdvC
         fkvJ0W5gRCiNf8n1qHhLxKn2ZD3bM3ckVufsKyOX/KJxyjyczlMKE1M4d6iTSj2th9LQ
         +Ypw==
X-Gm-Message-State: AOJu0YxpkseV46Mr6fnVbs3bZkkSjotni/hB3txpIXpzV8czn1qJ4KPe
	JBGF22IbpWY2oKRSuL6VhUw+/4SePpygwXqQCdyi8JfjBEtpYHq3COdP3KdYdF+1aUMhOCzrvP3
	wu9Z+BU8=
X-Gm-Gg: AR+sD13xzh+9lysDH7GLgETvI7Hpc+J/A9mci91bRicMltHkWHFJ/icRF0aUlsxD3f6
	1ujSovwT3oU81KdRQCeFyawI1qusBr4b4wQDQQ4+CARJvv5J1sBi717ixQjUzZNyt/9Laydwuyz
	CSd/TbKckbUMDXrMr5fii/fkvjz4ykquOjbvDOpvaC4wC6PS6b30tgt8z09Pecr3SJHK6c44/Qz
	N/o3v/CiV60gg/fEWwL8EmRLB89yyHZQZoIZ+aUBChX0oSPmyJ3bvg0IiHMStqHQo5f8HKqKBx/
	DiSfvKZiFsZOnx6DpJAIhN5HnOL66PYVESJILrWi8LLPivYmPGuMAdklv6bhXgBHInIIVlcXR63
	HBCLyslFfAoODfSNkDJu1+BURW4Bg8DwMo6IheQH1lAsYjHDC9aASlSNkWAyrqraiYpspSnlXbn
	optD/bBPV9/KDQERjnGckH6GuWNn6AZx1wXBhxJqSRUF5VoeBwzWpk2zWX0vGJkj8IYBFahN50v
	1rvUfy727d29Yxn8BGHhHoiw+aGiwxcbwnydobcLaOVAH2kUnd5yjDaCcUDdNR0kaCpZ77uhV+u
	RME9Z+4Gdvj5w28KW7AVRsnHeQoN
X-Received: by 2002:a05:6a21:2d8b:b0:3cb:b3fc:510f with SMTP id adf61e73a8af0-3cc552de999mr198773637.24.1786557054513;
        Wed, 12 Aug 2026 10:50:54 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141245540fesm18482258c88.9.2026.08.12.10.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 10:50:52 -0700 (PDT)
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
Subject: [PATCH v22 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Wed, 12 Aug 2026 23:20:16 +0530
Message-Id: <20260812175020.666558-1-pavitrakumarm@vayavyalabs.com>
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
 drivers/crypto/dwc-spacc/spacc_ahash.c        | 1025 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2544 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  858 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  289 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  242 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  344 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  118 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  325 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  665 +++++
 14 files changed, 6534 insertions(+)
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


base-commit: 68554337b4aa63d8299edd58f5059d8470bc721b
--
2.25.1

