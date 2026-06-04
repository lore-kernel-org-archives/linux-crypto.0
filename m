Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6AA3358B9
	for <linux-crypto@vger.kernel.org>; Thu,  4 Jun 2026 16:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780591986; cv=none; b=TzCJW4/KZE4cKogVh/EHGTyBCdZJJpgDiuC7yMKh89Bk3+nQ3ulNGiDUVPK9FQ0JT9OTpnb431ulTEV5cF8CuqQLF7yvj2KvbnodcxZSQcJ9JWuyrdiHkUZwsLXzkzkzg05gnSiD/hHS53ejiWc/sfjRp+CfjDCFgpduO8GH/j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780591986; c=relaxed/simple;
	bh=DujpzWHuCpkRquiGMIckVgEimX8F463Lhioff0jElbc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KJAFDMxNxfCcFg/toBnNGGrQsnq21mJriYdTb4VC1SqD1ji6pzQ5XyqZjcL5I8H4V7ttE8bKUSju3hfXRrNN2+/iTFENMxcy1/gZidU1MVqcxeRa8sijW08pFCAYllICJMSh3cbymU+j/YyRfcKtSNDzAy+HhSGC0/kMnYHotRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=meaHmGA7; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="meaHmGA7"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-36d5fd50d20so582018a91.1
        for <linux-crypto@vger.kernel.org>; Thu, 04 Jun 2026 09:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1780591983; x=1781196783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eJ5R9P1dnmg3IyG7KfWqJbZp8cv4vMhVOrqa2zxuQyk=;
        b=meaHmGA7Pm8KFL9PEVz1l4RZ4Afi5ruuqZyn1a/Q+jLfhCmZ9mqNbUmoM/nlV7hzVJ
         K8ute/hYiOod1nYDqE0TEeb7+KtQX8ebakD5JvpZUFhsbxCT6Hxo1K8jANRZBf/3cEic
         D6MM8SDZGOENniPTyHiYVDb4VJkvcnCzySzqs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780591983; x=1781196783;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eJ5R9P1dnmg3IyG7KfWqJbZp8cv4vMhVOrqa2zxuQyk=;
        b=NtH+B8OyzrxwT0or93RoR8Ueq8RuVvjOQZJbmldChY1EXE7snw9JRDS77Ri8HCcIY1
         eNg1ehPXxLGP7Q6L4N/iUrvNAq9AO4GcyWHjDCOzZOb/vQoF6F4eAwC9eS4Yht/o9YUD
         +IeQvAMw29RhPRTNtc/k5N80BPhAWUVVswE3QxOzDLskbQaqO1yfcV+AAYlUXfvKGfIm
         NR3/eTpELVpa8tJQNkRKOIr+peEJCrppkgk5o6BDUHK6AJMHsZIxm/5sGdIzgz/Au1DI
         KqXGqLxjO4H0+Z16jziRhoBVYIoM5/Dr4gXB4S1uDQaOJABOeURxpuJ/yE74Dl7ApUuP
         TD4g==
X-Gm-Message-State: AOJu0YzTyJTEewifbrGzfKJobS86vIRfrBiOVsrtvBlS96kzoJT/U1Pk
	4LJ7z1sv+wN1gQ4HcsKsTNauAxle7zvMaOJ66hw9YtoPvT4pPIsazcjs/3804RSp8oWAEt5Tje4
	rpG9w
X-Gm-Gg: Acq92OGjthV/mBsyF02B/5EqDNEbNcYOXm/Nh9mE203NIWtmgFdjd4JOwzhvAYXGoHa
	qEtKsBukeQzZs6v5+S8m6uZUUu6Fnd5YPIUlEhDeKAZF4L1K/ehZeXqb99L7j53twCW1iBkSUqo
	Jw7f2bDqkpwk6Hpj3na1Sm3vGbeHslRDODe4M4SaaVqiwIIh1fC0P9kshtwCDNingZYuoAmdG7A
	Jb/iifKcDofE0gnYyG/6FFewvQVim12Cevy8hXijJU5cQkqTLptfSZ5WrjKtI+Xo+Ofao2mc0O7
	yB7/3uUKZRcbLFchN1r6miXx8+N38ltr0clma9YIG7NIz8zdn4Le3oQvnVTeu0ned0kWylvnTp+
	jFtsBUPelETj/A48ljh9yvtrAJFPw6bZd2F/peJyi5ZapuUO4G2O5HYLTD4jxulh6EPC6Bgqplp
	dY790sjGTJ6fvH+ZEqchLjD8MFYPY2Z0SADWpARt0dU7AyE9/Axkev1gq4DzXZl3PA4fbgTRvLL
	rcGHpXCU/GjwZh0Pv4KSenVTf7AIJhgWf+Ac9nLFioxhrjA2Q/ZAgUvJ5KDY1GPLW9pUYbBOdNM
	UmtOPzfKLZN4
X-Received: by 2002:a17:90b:48c5:b0:369:73a:326a with SMTP id 98e67ed59e1d1-36e33bb9468mr9959531a91.13.1780591983198;
        Thu, 04 Jun 2026 09:53:03 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f711e7b53sm3689229a91.14.2026.06.04.09.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 09:53:01 -0700 (PDT)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com,
	rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v13 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Thu,  4 Jun 2026 22:22:06 +0530
Message-Id: <20260604165210.1141842-1-pavitrakumarm@vayavyalabs.com>
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

  v11->v12 changes:
   - Removed do_shash() and switched to lib/crypto API in spacc_hash_setkey
   - Dropped support for SM3 algorithm
   - Improved multi-device safety by encapsulating handling within priv
   - Added memzero_explicit() in sensitive paths
   - Minor code cleanups and style fixes
   - Algorithm registration cleanups

   v12->v13 chnages:
    - Removed all the sleep function from setkey function
    - Added shash implemntation for aes algorthims

Pavitrakumar Managutte (4):
  dt-bindings: crypto: Document support for SPAcc
  crypto: spacc - Add SPAcc ahash support
  crypto: spacc - Add SPAcc AUTODETECT Support
  crypto: spacc - Add SPAcc Kconfig and Makefile

 .../bindings/crypto/snps,dwc-spacc.yaml       |   50 +
 drivers/crypto/Kconfig                        |    1 +
 drivers/crypto/Makefile                       |    1 +
 drivers/crypto/dwc-spacc/Kconfig              |   88 +
 drivers/crypto/dwc-spacc/Makefile             |    8 +
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  897 ++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2413 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  838 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  275 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  237 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  374 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  114 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  329 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  611 +++++
 14 files changed, 6236 insertions(+)
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


base-commit: 5624ea54f3ba5c83d2e5503411a31a8be0278c1e
--
2.25.1

