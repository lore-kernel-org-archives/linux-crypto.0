Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DBA369967
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 07:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773818321; cv=none; b=O35g/yK7Yl4JL8B11twknBGNe3MSrtX/EO3FerEGGHyKILa8hs2apGdCK9jg5bpbeXbH3Vv4QM8qQ8yITMK3NTmNKrB1YlG99DgF39/CcLX7n/HPtXcncwng7yZwSba5qvXLs38m1gVL8QQJRPkq/fvyajsHd54/CQeJkBdQnIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773818321; c=relaxed/simple;
	bh=Gyksr/pyYGqVtevGjzu4MsGSzoHchdIRE+2F2pPtUXw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EqZDCNRLDBnsTe7r4/A/ULAJafF4Upkqcgz047JcMG0wL+s5ZmhQDEgZFjsHAKR75NMQ13SgwW2mG6C/NiiHl3doiDDF+fHAEPETQd7ia39dRiaigl+lbanQoBj76VoFvmreyoVo2qJOwWlFnlG9ibuFgfrfG8qSI+CEPNn4Iz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=od09iqYh; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="od09iqYh"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82a67ce6969so636421b3a.1
        for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 00:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1773818320; x=1774423120; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ec9WQ6ngtqE4aJzEaoZ7GvRrgvhfaiK5DhkkbtIkfv8=;
        b=od09iqYh0pvALEjCFMKphtUFE8Ijw72RqIR5EZu2XDgA1KAX1gk/0GN+VkWlvw3U68
         GOln6XTl2VZhHBkMA5CZuW8EDOFsFe/jfGHn95Ul73jJ3QsThzVTevGXKDYcwpj9Ii3h
         Q8Pcn+2omv8Mx7iqSFk8hwVo64/z513KdSNqo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773818320; x=1774423120;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ec9WQ6ngtqE4aJzEaoZ7GvRrgvhfaiK5DhkkbtIkfv8=;
        b=bq9S3iP3KsUMkriz4KG2ijlSz+mbe4Y1hum/rkREwqsbOacuickh8brwK5/dYEua1l
         A4998f5pwyFR9rvtsMa1eWxLrFU4Q+k6ViO1FJQ5c7tZO4ih3e8ZuUpfUiN9sVAtQXvD
         o4Us9MGJ3etEyORlossJ7ULJDyVM5rE79dSAVZjySbGQihF00tC3AwGks5agS+bZOSLm
         WzuTLhF29h/lmkjtVJHbuc2zedlnfAzfcFqNIzDT15C96ddtdcTsF6+JkhS5WB77CQpz
         FkCcY+eKyemBfUq8OCciLySwrB6nnA/8gHcKj7UTLXn6j3eCAXmBc5xyi22mt5GwdXte
         rI6w==
X-Gm-Message-State: AOJu0YxqN8PoAcW+HWt7ut6Axed2DE4CLgoZz/sD9iyXnLSdZUG52X7j
	5h0Lw5mpiHFou3c7RiVg4AWzjLJqeqKWMGpIYeLla0yPCAqtmk+keSjmkKBPGhZCr5BMkpjYoH2
	UV9Gp
X-Gm-Gg: ATEYQzxBhrW0wleoYOIyjNege+5BGIeCAUGdhFBQ1kxk0A+epXInORsDPFopGWMt2YM
	qua21NKQ1JEjtl27sV9QKyMWhD869B2bViMPvLQ5K6UdAa/p//HDqz1cVTACJymWIhkzWnqiEy1
	HZa3ReeFtYjcua3FGI32kzsu43hHAl8wy0L7nGP5OQYnIIqAUB/lFJ4YsbP7MLijfawuCqgKfuf
	iwLEZs2crz5NnJicHY6b8QlZot1i3X6fVlt/Qa5HRH0Uu6wvFH1aqhx9+aYYWhTwXhqIzWNF6kG
	O6jFEbc30UepMlMIAIf25/mc2+W3Uy0rU8r5Rfg6EFonGuKk7LJo/GklMLtIL53+VWfEWgh5J0V
	T/QfSgfI6Su5vRvddL73Boq0rQW7aOTyGI1vCK/4bv+Xui+5VblHA20J4wYETOnCLHMp07KGWm2
	kYUSrtIUkbKmm2pQjj5BfbDKYRZua+KSITUvC2Jqpwdy0JgWMMMT0UiRhRdfJSA8h1lXMUaJC6t
	woA7FxIUu3rH96KaOTkyLbkSpWXYZRKNrj+TUhQApnseX3nW1ayr0m/3xfdzvt8HDU=
X-Received: by 2002:a05:6a00:1da6:b0:82a:6461:6d15 with SMTP id d2e1a72fcca58-82a6aee5104mr2047087b3a.46.1773818319581;
        Wed, 18 Mar 2026 00:18:39 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a6bee89d5sm1613669b3a.51.2026.03.18.00.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 00:18:39 -0700 (PDT)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v11 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Wed, 18 Mar 2026 12:48:04 +0530
Message-Id: <20260318071808.817074-1-pavitrakumarm@vayavyalabs.com>
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

