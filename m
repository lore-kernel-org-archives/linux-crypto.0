Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DD731D74C
	for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 12:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771419505; cv=none; b=paE5Srh5p+06YKQvtji+n9Dcn0kaUtLK8ncs13zzuZHrQxr/e4jkFzitpFgivSa+YA+RlD4qn0nJLvFy6E3nES7GQ31LOc0hGL5CSaL8c78UwRaMzM464lNki6+jZmcysJ4eGeMU3zsmyR2DD1dazhjQ7a1yN7Z+3PLtkkMLL64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771419505; c=relaxed/simple;
	bh=gK+KKgFUzxlhMCj0LxpVCcUd1vgulONckUl7eS0o5HA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=natnTkHy00pHAY8HbDPtZ6QEX0gNBqODwwDp/zAC+1ambNmcJowumCs32FiAg9rtbgtRkTU/Ywm0MiayngZP9A6+rbhb+TjEB9rkB7JRmif2zbPvMrUIfz2dPRJaGmYKIJrmqHDRFdS/2F+plfgQ1YM3OdH76uDSGKVjezoCmro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=Uf0ndIWA; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="Uf0ndIWA"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-824ac5d28f9so3957808b3a.0
        for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 04:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1771419504; x=1772024304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7hVAT/5QVZwmXo9pGmQ4y2dfzJ/j9Y3HMmbHC2KkWxM=;
        b=Uf0ndIWAYlogFAclWxjepvOswL54Xro0QYg+0/nLU+ZmKeOuvck6vWg55WXouJ5mTS
         E6Sd8hZobGCM1gM3mpr9MkxW5D+mNYphC3l9J0TFLw1ZlMDEfaDkq4SFXjFULx6bMQc+
         x611nuP72pShJm4U/+eHqO+jztswZnrNE+eqg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771419504; x=1772024304;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7hVAT/5QVZwmXo9pGmQ4y2dfzJ/j9Y3HMmbHC2KkWxM=;
        b=Bp+zC+3JOq8n1lUBBAC3YGEaN6ZpMVZUlVlBpIEQW4Rq9k7OU077qAIe8xnfimOBAg
         VXVUXFheEqhztoL44wYU/AOopWGQCNbfEgKNbin3WiF7JyG/2y9icHDVbiffStM9QVx0
         Hcxsrix+9Dilcg1IlFsqBKOBvsaSaWXzTIMHOVcpRA9e5+3keJ4dleHvxN7wVQ0iIMs8
         0gF71NVdOBgr0q/L9a0VPK5gNJbIh16VEStNuqzG7yGRg9jh5a1mp9MyWtmIlkHuGC3Q
         N/zITCZr156FSObpfwDitqAkOdneN3UdGQUvAyqSqqAbviKeNHUkFB37orCAARKrQpze
         JNtA==
X-Gm-Message-State: AOJu0YxdeYizV2AbjENIv8CpOw3xYgvvD8cRAdjsGAqLAQ+brTxfZw2t
	WWwEZGTuORUHW8hgsLV9+62YtcpR1LIfxVYgZrNQZei5ob51kQgDY8PIdXFNuUiu+7lT8qSPWTf
	1FBggz+s=
X-Gm-Gg: AZuq6aJdN758jz+VpZsbug96QEmOSBXDwYlJfn9N1rwuEw4nr32cgBwYTgbBBSdcfZU
	+fTGBkHrTaFP+4WykwH/F5SHF6EslcE5/DMbPVsigO5wA196i1uigGGE3TfBEagU8svp4TDc66B
	mBXy/S/f1/oobUltOjSLa5BIB0cGDXxW21Jxc/BQ+spZlVr3uoTPYRJUUPj8j9UhC0n4nHAJePE
	K9haIhCsUAjGpRc2l/SD8O+l6xgCyfGsJUHKi7uwRCH4buOPfN5wMTb9p4iamMw7k2IxV6PdYjv
	Vit2dW/W2Vv3I2ckdIkqpxDNd3FnSdbR0TM2wRbzTRgEiQ11NH7WrScCpbl9jlGwG+pLiIsRfm/
	SYEKjbB4iNgFw8+OA5jmjzcphiEzq6qZzEc/Esrpu5jmyNVdTin3SImsk6dm9QLD0LH4raqIHBI
	bF3lbVmcEq1OKFm1lKqNYqGpxM3eptcfSq79E4brIaRdJYJfNgPjURRlzy1IYYRxJQWxOhb0YPC
	lwWq/822GQYRfIuQZDZRbceBvssbDCBveOduSp0n9pzC0+RMTBnysoDhpI1ruw4Vvw=
X-Received: by 2002:a05:6a00:189f:b0:81e:e0dc:6d00 with SMTP id d2e1a72fcca58-824d96287b0mr13137301b3a.58.1771419503709;
        Wed, 18 Feb 2026 04:58:23 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6a2afeesm19227464b3a.2.2026.02.18.04.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 04:58:23 -0800 (PST)
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
Subject: [PATCH v9 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Wed, 18 Feb 2026 18:28:01 +0530
Message-Id: <20260218125805.615525-1-pavitrakumarm@vayavyalabs.com>
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
   - Fixed synchronization issues in the digest request path

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
 drivers/crypto/dwc-spacc/spacc_core.c         | 2411 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  827 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  275 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  236 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  374 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  114 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  325 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  610 +++++
 14 files changed, 6238 insertions(+)
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

