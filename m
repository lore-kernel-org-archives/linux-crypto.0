Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C597B4908B0
	for <linux-crypto@vger.kernel.org>; Mon,  7 Sep 2026 15:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788796781; cv=none; b=LgtC1LVsLHCo9NgOd2z+zx2lzGsNsfBt7BhHg+ZQ4kKMxwN7n/mImEbF4V3dwrLJrGtJzKLLc7vW2I6ZQgySmkTE1iqqQS2AR/coNLEQnTVah0wTpu+CtIWL+z7mH5HfSIDlmBW6T6A9G2GJwCkxVkhqyt+8R5P+n6UfQMr8DGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788796781; c=relaxed/simple;
	bh=t0/rzonFEAqTS1HLjntV/Pjfyxpe8xidHcC8v31IYeM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Qfjx+th16E0+E5LxEdMODRaMTgY3hYsOZ6kAvIDAlYiNFkgDtpvbqOnAUeV4bVQCVLPg6vqwKp0JQ891jjBc70ad0MGazrTdq05AlczAu64m0dhWS7Sjcfm/Jy5Agk1Ezq/e01hfg6UGxIgit7sWA3LRzRZfxe6CTqQ/Tbq7lmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=gFv4FUiS; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="gFv4FUiS"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84e27035206so3384780b3a.3
        for <linux-crypto@vger.kernel.org>; Mon, 07 Sep 2026 08:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1788796779; x=1789401579; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mtwrm3BqA8h+ebttDaELP4dGL88AiY4oYSFyH/NhY7M=;
        b=gFv4FUiSBcAHPQvFnGF8erkWxEnoivU+9uC9B/5/Az932NPIn8ueA2LssXDbr18HHu
         Q5ezdj96S1BoFim8Rm35eTqiuPJtgFdxgmBkblLuEbjRsgeqS24OaxoBknIW0cgbkM9j
         IQI9f7d1eihN2zl4WPUFmPn2JmCQ0ehQgZ2Q0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788796779; x=1789401579;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mtwrm3BqA8h+ebttDaELP4dGL88AiY4oYSFyH/NhY7M=;
        b=GRZWpQ+qxgik+vexe8CvWgKiLkIxU2VW/KWKnDkd1sWz1r/Iv29P4dpIWYXaPbfXMl
         3XucqrUYldUOPFqaMBM4fOtJRa5JO7VajOtzLAQEr1Z7nIALxzGZdm0WEeVNiLTmjXD3
         crRiJ1pxSKanNyuyI4jgL/juTF9J0+EGWkAdSbv3tKBPiAVKbVQ/hKBF1yTH5VwkTVsv
         4seIdDFbAWunJNVuGqLAWjEYqyRQG7XnYBPl4JPu0Y/+YGuV1KOUdyh5XM3nacTF3eKz
         Q2NGtm38M4UFxm5dyq2hMTw2UbKYKDt66Tj87dx/XG8JRVkq+ecvt/p76lIS1aEKWvl6
         DzEg==
X-Gm-Message-State: AFuF++l3UEP5+oyNyZwkC+bQgT8FTy8I0mTPGOC1hGG9KIU1AeWElHAf
	1bX0MQFndqEzfc+m4t+kucnh0DvesRGDe90BXDiBOmRR/uxsh7p3hYfjcQG3q50uaMSeb7pyKaN
	8jkuT
X-Gm-Gg: AYBFou1gDRMT5VT/NA8iZBoeDuV2dIdVQgqvDyL5okw54quVSVPGRBaSLLNp7o0V+7k
	C0Ny4sUqY/8K2cZukUSRzk7ebo1l2sJQf7QK9Qa/h/boGJNkK3TYeAQE3HHBV3PTYegr8XN1zDZ
	oelO/uITXEuriVNkutSeySq8O7OTW+JqOeEXVSbhN3X51JxwWchvpspoEKaOCs1jRgS+BwxvLXE
	JS0PSyQjfScA8VgFNWqHNEOk45P1EFOczgrVKazgS1TCBmNyaXtc4fjU+QLKNQreZDEyr3GrV91
	eOKJJbIm6H7TakNinxyCRSDkg3Nhq2OWKlFw/ZkVAPWqaMBu+BfDWroK1uOk5QkZjXCnoDHpEky
	B0HUo+V8OZVQUGsotKOusqi46oiIBiZ0YlDhnaU/xphFnsPnv/D8KyBkzEKrmBQX1xsxGmr0+TT
	LHBWgJym/irWeOpQpYEhWUS/MNQbaJut2O7UaypWoHvXG7oQHsgo5KoWr1TqLdX895biGQdwhSP
	krjRIm5HwpdkT0KKbslEAqaxWIW6hpieVkOrBUNn+rfVnEy5MaNwnWJExwaYo4wv14QSs8lQYK3
	BbW7+K2JU/LTN/HVrgLzD0K5UblP
X-Received: by 2002:a05:6a21:e081:b0:3b4:61f:1fec with SMTP id adf61e73a8af0-3da39bb593dmr36027709637.2.1788796778953;
        Mon, 07 Sep 2026 08:59:38 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm46065613eec.16.2026.09.07.08.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 08:59:38 -0700 (PDT)
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
Subject: [PATCH v25 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Mon,  7 Sep 2026 21:29:12 +0530
Message-Id: <20260907155916.999153-1-pavitrakumarm@vayavyalabs.com>
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

  v22->v23 changes:
   -Added fixes based on the reports by Sashiko

  v23->v24 changes:
   -Added fixes based on the reports by Sashiko

  v24->v25 changes:
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
 drivers/crypto/dwc-spacc/spacc_ahash.c        | 1044 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2569 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  862 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  321 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  242 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  350 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  118 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  340 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  666 +++++
 14 files changed, 6636 insertions(+)
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


base-commit: 5358248961ae23f7253d010ddfde1cfd2556ce22
--
2.25.1

