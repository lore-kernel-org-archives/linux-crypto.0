Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794662806;
	b=AwA0U83ey1HMunjk1HM3o1YEkVhviWUVOt2QB7umZN0bx5JXh0Va3l6dx2G40GRqic0A
	 X5T2u+ap/YWavDliHuy+gvk7t0oy0s7DzqjiSmP7L4BgywysVJAy0UVHiVEPyeZvqg5xX
	 J4BfElS6boMZQF85lxW69DH0FT5M1wENZfF1kj3/W3qAi2fra5oJ/48gJ6TM3GSupcBhY
	 QHKVYPxhFSM7ili9dZVY92vyxrozCbQbWGZTtOMi3U83W5ZMiTcocFy7GkSigpUg7/7J7
	 EBUbN8LX6iemxot1AFNwY5nYPZ+53S02spFOtEYE+xKK3uEGnEIJ+GyYM2ayWfEI3Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794662806;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=wkqW+5Euu+lzjmS0CVjZUfm8oW70hhcplY06jZYK+zQ=;
	b=0hyllnxaSjwnZU3Te/4fx6wpM3wbN9xgIkCY0wDGlf9Lo9JXHypoyvIQTMAqGc0TdAa2
	 GbQ79Jxpyegy27pWRtNU3a2n3GhEp8CqOY2pFdbGrenvv2jgMywYViTQzINhXnC5RhIQY
	 bAa8bf4X8swdckHjwmNLLWSCCN7d1c9VzsW4nggoLgNeZPkPnUbJBJOMGaXbCPaY3M36T
	 WIcXdoI/j8y89fv5lg96BTI6NuinEAQHEs8DscLc+3yEo1Y/gQLCUgob6H0TTLSwBDTKT
	 1tIWYW7XoF1R4k24KvI/uQegm19p34N7aAzGKGKjE2nh1OYILUOYi6gWq+kBw5NV6LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=vayavyalabs.com;
	spf=pass smtp.mailfrom=vayavyalabs.com;
	dkim=pass header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b="DXvWpG/o";
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFFA606A327
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 13:26:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EFFA606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=DXvWpG/o
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-3791619605cso3938030eec.0
        for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 05:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1794662805; x=1795267605; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wkqW+5Euu+lzjmS0CVjZUfm8oW70hhcplY06jZYK+zQ=;
        b=DXvWpG/oi4wZHGq45MBwFoLCM2dRdgJaaGbx+niU5qz2fELPtPIzb2o/zug4Qph0q3
         Y1hGesWjxXf6WCfY/jtXWuB1Ik/nKYEUpK/yKWma1EP6bsCHY9uWymcN8mUvmO5sQlom
         /A3XLK4z56oRaIRBImH3XVE8366GUMA0rShTU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794662805; x=1795267605;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wkqW+5Euu+lzjmS0CVjZUfm8oW70hhcplY06jZYK+zQ=;
        b=zbeZjg1F8g48nECap6wxjfJCcJprboGT74RNtrc5RprSayz7ugoEFYx3YY3JEP6gDZ
         hkuCrkasW3eM3OUBrSZX4bRmH6bNugEeanRIV0USFAGAbq+kCsVa1oUV7fj1NzAWnSFw
         KCFi9qCEYHQ01nqUTHTcJPeaqO78kM0Z6lvl0jM2LzT5bwsMn7UuepPBqmWdLb7kZ9g3
         au7u3MhNXv6tKuEgAHbQ10CqpPReIhldn4izzaDCQhx2EkTMPHTrAJsYFfEYPU8nV1wQ
         IH4uP4F9Pv+Q8mPTr74JcdnMjB7tXfkcEuFz1oNMBzFyIr45e5ZtMBDEH1UkKu8Lg+ID
         1KoQ==
X-Gm-Message-State: APuU4Z+i4cJPrAv+DY77NY8JSehX1rhk6Ujz5aVJ5dgKd1GP6hSyQE8x
	QeR19nSSI3gGkmFNLaId/Tz1u9eFRxQtB1a+cwFcPRdx2GpYe+rcps1sGYYNeyKB+pXyd/LVuNT
	pEo1h
X-Gm-Gg: AYBFou0ULm68UYUG2rqc/Xveu0Hm8/yRe67tT5+KJPh1JkWiSZgzUJgg6E7z87L9hR0
	hxujSmG46s/L6Yg5N/N8cglXAX3rOfuVE2gBTCdUNUNNjC2Vi6xASMnTCe7O9612fObYhv9Evte
	l0S9tOb5Z/LhUhoo+D+/EcW0wp3EaWPkjiD4LLfS3skCgHmM8q7wJJpkDKZywlZZTQIlUkhK8ip
	6MNbqKN8vFJvLkopduoZUb/Rq1sCwbX/FYIQdax1ZLKBlaQR98WRQo85rUyYjB92tgB7rBT+efT
	AuPpU/n2WvoZRerNkMhtqrhD/2ug3VPrUbwqAp1qB31PrYJNxCy8KqOV1kpQp2eLp9iaWvohJLW
	dprzYegWil/dJCQ8Xrup/FvOozY04Wpf9rm8w8Yt1cqiFlcQOQ9ClMvfaovTDTrcUQUeldTyuWX
	aP48H6J/S5eVEco+SvgSModXXMGUBjHjpu68h6QBvpRzdZTTUgGAqIZyx85C9CaZ7p6at9tVr1u
	T8cB7sOV6BtOVoIqisLfbf11gt3OGme3+7YllUZrCjLX4lH7zW6pvuNwtxWpe5qn7P9Px6tuYAh
	NY/xCopcZLzDq9xd9bXRhu9b06d/GH4HV9anN2E0zDmjboYAcVGXA6XSIGRqT/I6psqaH5trOnm
	2LkXOfcVmcXh7zy3TH8at+i8pvHFU7sgbjj4cMMcLaOCLNLJlH/EjY13rHSwgMwtWEN6q
X-Received: by 2002:a05:701b:4508:20b0:163:c5eb:d42f with SMTP id a92af1059eb24-1b503060401mr5705261c88.5.1794662804586;
        Sat, 14 Nov 2026 05:26:44 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50319e381sm15712003c88.12.2026.11.14.05.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 05:26:43 -0800 (PST)
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
Subject: [PATCH v28 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Sat, 14 Nov 2026 18:56:18 +0530
Message-Id: <20261114132622.690129-1-pavitrakumarm@vayavyalabs.com>
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
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  803 ++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2540 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  862 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  340 +++
 drivers/crypto/dwc-spacc/spacc_device.h       |  178 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  349 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  113 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  366 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  657 +++++
 14 files changed, 6331 insertions(+)
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


base-commit: 8ba9044ff0bf4a5789216496019fad614eeafd45
--
2.25.1

