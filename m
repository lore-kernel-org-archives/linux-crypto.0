Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D586E1AAE28
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 06:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773815471; cv=none; b=QVvihZ3z3WPP8lz8nLcezB+XboOduVR7CipS3T/pzQugH9DQ8x302S57c04V6fUcP2AE59O3CeqttP4nNKekINn/bYFqzvC5e0FCN5FbVkYBeJ2i2sJV7Qq10I29SjSfZzc9zb1vq/pgvSyNOkSp2lM71ThgR3c3VP9XmU7btKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773815471; c=relaxed/simple;
	bh=Gyksr/pyYGqVtevGjzu4MsGSzoHchdIRE+2F2pPtUXw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g0MK6M9+fwwxeSMXkZvzIhnexgYbcqUoVMIIJ+H32G7CQ6ODb9TSQ3STDQXI20PlrMpFKhno9cSi4dVV3tf1IWCvQ5TOYU//F6KVhM7K4mL5d++mp9qwxK/gzbdJ/x5Xfo0lu+PhbjATOyY1nzl/mcw3JaaQxEY0Vg+dHU3IzX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=XqRS9jIq; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="XqRS9jIq"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c739e680bebso205303a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 23:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1773815469; x=1774420269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ec9WQ6ngtqE4aJzEaoZ7GvRrgvhfaiK5DhkkbtIkfv8=;
        b=XqRS9jIqW0wFpPgZdqXEuuh/1xePLKQQOz7nld/epVdYtetohbI+YzTiBu97IP5t3L
         sKdMG9xL704LyEOLdV+BuUm+cjc6Uyh7ax8ShUMGIDBi5w8A8I0JcvJV/FDMFiMv5yls
         U+z/ClHt14CDFuOoFUAgDBs3A17SlU/Grgdak=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773815469; x=1774420269;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ec9WQ6ngtqE4aJzEaoZ7GvRrgvhfaiK5DhkkbtIkfv8=;
        b=alH9RUPn4gVaS14Kf35R+xoT1Mq/UnCjiAPRjpmpCrz8TrcfZwF1/XXJTQ5Q6h58Ra
         nPVKIxWnswg+EucrZz9k9YbTcYq2rkegoNeMkwDwfL9AfMpTd4GRdh2bHvB/0jcqcQD6
         8KjEwhX7MD6xYxsSOMMjYxQm43lyo3cTTA+P5CQJxMKHJ1UFoK061of2GFJmaO1qXMfk
         ZiQfo8gj6m7AjPHH+KFAYTmHEfh1rDoI4BD7OomNtay45LEXo9A9tupUSr67j0R5Bh0j
         tiErCo9s/TXYKW/FGeJnGDGfNow1xW/N8iHWqr0iFZxqj7CSLsAvsYBfToKNIG/Anvgh
         sxUA==
X-Gm-Message-State: AOJu0Yz4jXlsi5WujaW0tqtsJ+aXU9XCLSklguzN3sJESsUmmS3ipdLq
	IC+Rzk7jaBlbQxcNUyb4DidjViiQ+wfVtRYN1AbqELZj+I9y0rT21RBNlknSwlnD7uT3/sFinYo
	lamuG
X-Gm-Gg: ATEYQzyFoMVMYYoaxfawerlQeo6NN/Q2R9yYM3WnU+JnaaEKCmYMgesgMYjWeUZyfK6
	4RWADEgs/oEyYgT2zs03yzJ3qaBTM44msdmnTqAMs97TIb7y3V4xjMXQfzcZve0wyfI0JaPATRF
	67xtS703pRTWgeZgs+3dug8mevvmjCsWfF55Hfsf5nt8Ubn66GBr+wCf0OpjgcxxnC0QOPY4fmv
	c058LZjTZAahvfBdPesw/YPd2kHr8yBHoCZENeyXpOd3Rz4LKbT2qDARH4ObXH6yLGojlOxmGpy
	2/2rFqJCupO1PfkvwJEYQT+JrYss0L6jkA3ODw4h6oktbTPZ9ecO2xIVPlt7F+iWvXwTj03VNTc
	IutA/EHJpfyfwMuawSWymcgOIOzVc31I9Sk6KVh7D1TSg2UqtEqKSvM+dQeQEHs8+Lvf9qVqdrS
	3BYwpDgfqnIt//Tr7V2I9mZyNBdofFwgDM6F5r0ahUotvAwgLAjoTFgwD60dkZJtCU0gls+lSk5
	2zf/926Rscz0AFcdzFH7k/63C2jxIvOTCyo0njYNZCupg8D/S/x5J4+z8tPO/SLdcYLuaFd1/hY
	YQ==
X-Received: by 2002:a17:902:dace:b0:2b0:60dc:9a48 with SMTP id d9443c01a7336-2b06363f140mr61782845ad.14.1773815468981;
        Tue, 17 Mar 2026 23:31:08 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e5ef3d1sm13620235ad.38.2026.03.17.23.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 23:31:08 -0700 (PDT)
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
Subject: [PATCH v11 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Wed, 18 Mar 2026 12:00:08 +0530
Message-Id: <20260318063012.816060-1-pavitrakumarm@vayavyalabs.com>
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
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  886 ++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2413 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  827 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  276 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  236 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  374 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  114 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  328 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  610 +++++
 14 files changed, 6212 insertions(+)
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


base-commit: c708d3fad4217f23421b8496e231b0c5cee617a0
--
2.25.1

