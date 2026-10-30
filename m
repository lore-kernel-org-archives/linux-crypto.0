Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793381149;
	b=UWn/is6eipjpHhJLeZZWk245H5f+gb/0/KDJ1i0Z0PFmEfPpehO6hB+cramtz7J4jZOX
	 yU5s77aHfRhwOe6gkUikr28mwnKmmRn1PPm6hc0osREiEb4tVla9fqKQMfKw7zg/sc1J+
	 q7rTDpZEorX5R4y8ODOl5GiCWXsor9dhvT8mPSx22zyY8ce9p4MqajwVnrmUgUwfWHWMf
	 yU+VhaaXIrmrzHtSTxuYLK3jA5ZqfB9RFTqxp5piNuu3dgjQhqG4jnQYw/j+v076ebpfG
	 kcDIAYKiO3eFJ3duFz3U1nlO/ghryxxx802sOOoyW+zPsuAVlwDSx7hX9UcEauDbChQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793381149;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=bY23m8oqDMUYdoZaW6EqRfZm2SbktefieM9kXqauMu0=;
	b=VDzQaSFhl4vuaYMlvcQ48r5vGsmFIqioL9X5igNnok8USy8atqwWTbgUg86GKWSmX9bY
	 phoZ/Vj/8TOYXRjhE3U3tcvlYe7+LbJp1SFxwQUhu4W6+Vuo9HGOemZqawsxCzQ7M9726
	 1b2Vng2zxwnfQhAdkfZz87EuS7EfVz1fOp1fEauGN8WRwhihdGKclto47yiJJ3jdeDBYX
	 eDvOxKlfNYqVYeL4rnntWu6aQhHe1R4zE287uhC3igC+BbsV86WZ7EkbLTOonhU0PNiKl
	 Ygmqd5z2DJE8p8UERE+I1Beo7jlVoc6TNWYeONbh20PAeqW4fxpVht89mm+Q4uSVZ4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=vayavyalabs.com;
	spf=pass smtp.mailfrom=vayavyalabs.com;
	dkim=pass header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b="VDDEhvd/";
	arc=none smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CEF606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 17:25:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47CEF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=VDDEhvd/
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso1696603eec.0
        for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 10:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1793381148; x=1793985948; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bY23m8oqDMUYdoZaW6EqRfZm2SbktefieM9kXqauMu0=;
        b=VDDEhvd/OMVT2NQ/bXA4lOCUDTfvdWv8l3EpL/XQ7ARxVAtvqXO69ETX1uM535cm0u
         57GatGEjcRGU9ri2ol17wIEkPXYpcgKnmj1X2/xXV5ZA94ur4grRYrxp5tlviq7+d3Ny
         1FET43C/FJqiTEXHjTkmwRhnaAjh49nTtWW3U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793381148; x=1793985948;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bY23m8oqDMUYdoZaW6EqRfZm2SbktefieM9kXqauMu0=;
        b=SMHYbD+ATeo1lZex+zw70nBJ3U3ThH9LIAEoeFNKwJDHAmdJPA2tnBPbKXoM451959
         PqIm689H/pLlUQLtNxXBjDzrWkAjzaK7lcEB+z6+8xF/squCRaDVGEzxlXuj3NJS6HoW
         a7bK+lfgK4QOolMMrpu86Uap+nTG7fvEuXvjx4k3odBQ+oDfBXDDATofHVn1HdxB3XqN
         nuhnqwWP7e3BRXLjWF0z+NckpEVIAqJ5cgULnkazkUy7vxIWAm7Na7ksoeb4Ob3IDK5p
         1YvxRZSAkN1TxVHg9HmKcCTk6D/e2Ir+OzXyDGUyXMw+Fa6feNTb30nKW6JB8tRsonDh
         /SDw==
X-Gm-Message-State: AFq9FYIXImUHVt5CgKtFUiCZHqqlA7+6GODW9gCLxTPn2rWzj1r9qfxh
	+nFqHxvxygrG1taf9spFJFyWw3HTZDzbK8SFnXpkcoIO3VVXD7uDaKZJYAlxeX2YRATDFww1Hq8
	qn4PH
X-Gm-Gg: AYBFou291ws3W++v2qFJJnW0x8bhySmhffem4MyqnrJhdubnUqQ8K3/wuxGUNsi7aIg
	znN57V+WpFYugjyQh3r0wSBfN202NCIw0BDY+pSu0V+JSkaHEDFvmqLjsP25Az+EPiAXiD1SMRK
	j+YvrKXZiucOQWd/Gi7vUFPqpj/drwd1N2ZOS5txBqyTZbJ5TXS2oQyqXXpKtrRbWldoyluOaHt
	ESGsfsmyrt6Rkh8Ogd3mVBDRUG0QIhM1mbaetBmeSctoPSRTcwMmZEnP55TbOv7OqGyT5e3dy6d
	tUkkQKkO/A3j3Q7okNanQ9fj1/ngtYwCfgjmIjbpNJiSTsf8U98LHd9G4NrT6vKgGbYJ7saYiKf
	N0wD1n0vmSKTP8KyzQqI0BtP0Nn1z+xEYbzqOfTnVIU5IuzS5qLJ8MDGRoFW+AVRBr6wf95LtC4
	nmOn3eacrkvpH+jwdjEGSINe8ljnreO0rkS/eoDmO2TqmEbdzNUV2Ws1266PNIEvysW7v2FbXvj
	HXnSK4CCs2gG715glMn0HVTsAXix1FONUtJ4E9xZKZbD0nV5j28dMN8plTPGsJd8QLR0pICQ+N8
	ms2cX+iK28uD8IZJnSEmgRYns4pMS5jwSMMacfklqmS0/kSI7fXzjryGHd+iEX1IfPQNyWrwSMh
	cFwTOvaZdb8rmW32d2JvVVEmjqtF2egIHqm7i1q31goMBOna29JwDNmyiLDMGBo5VvpfJ
X-Received: by 2002:a05:7301:4b10:b0:35c:85fa:5a61 with SMTP id 5a478bee46e88-36a424940d9mr4335669eec.38.1793381148108;
        Fri, 30 Oct 2026 10:25:48 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428ecb61sm7641152eec.10.2026.10.30.10.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 10:25:47 -0700 (PDT)
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
Subject: [PATCH v27 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Fri, 30 Oct 2026 22:54:52 +0530
Message-Id: <20261030172456.274744-1-pavitrakumarm@vayavyalabs.com>
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
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  857 ++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2529 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  863 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  324 +++
 drivers/crypto/dwc-spacc/spacc_device.h       |  181 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  349 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  113 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  360 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  657 +++++
 14 files changed, 6356 insertions(+)
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


base-commit: 178aff4cf425b3fc51ff09c571fa1bfbc1eb8ea4
--
2.25.1

