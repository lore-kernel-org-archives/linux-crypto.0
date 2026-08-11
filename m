Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8877939E177
	for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 11:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786448074; cv=none; b=G0og16i20JFBxCuaydZ3eDntf2XeLqy7hoxIXGE1qLtOqMdCpLrUPG9OOvo/AOenN0B9IyrfRJ9Gd6Gi0rt42X6wBwuCWxmABiA2fgNzjtu5mQ9N0JNh48jd9gN8x2rWMbb/rZ3Nu6Bqf95n7sbuYbkNauWi1DOyK1+83I8BDR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786448074; c=relaxed/simple;
	bh=W9lQ2kPn3Ia7xWlya75pezlrs0li7+8kt49W6nKysE0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=M6O9L8cFLOX2u7guDWCdNZvKGSHB0fFPrFdivDAK4M0DVet7uZ4ffWKmLHM4NmIPXTE95rnKrNIyxDJivKpeH9gag0Ty97JPJZuEZmqqWvOUBt+g5UgGdVjwrRX3EvcTWSaKw3+n60bEoUhEefE+kYgAA/hkJDJsvGOmTBpPSeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=C0a7MFzl; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="C0a7MFzl"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38dd55ad76cso898196a91.1
        for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 04:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1786448073; x=1787052873; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KW4s/6Tk8cowyLPsGgWIeA3zdeLpXtV4H7MfVGaJwm0=;
        b=C0a7MFzl/j7Y24BfS+AGdDaPzYydVoR48Gl4sJK/y2fPO6eOEJmFE9C12j/IXoHGUi
         /G03poYKizz8SF90KmrBorfQAxKYzso2DIvK1FWcIfzjMvlzxyEoZDzNtSuVD/trufTq
         D/LHqx6kWxSxlXiKr5oBlpCQRi0y8qypYccKQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786448073; x=1787052873;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KW4s/6Tk8cowyLPsGgWIeA3zdeLpXtV4H7MfVGaJwm0=;
        b=QYDvky6UW618PqMeoMn+yuLogi/45fFJ4i7AXG9z6VQq5XjcYM2KTHUbhgOc2fAZk5
         QcBLibewldq7oT3/KZ9MS1oHZeE9iP/gpHhOKFaBT7Em3qJKYAHHmqG6Y2bqOweTAu2g
         cJ4qHmrl9GNOMp2WxImwI486i1hPel9b01BOUMlAOfMNJNrl0LSiKPtziYTMpTuwHKU3
         hHgokyMpllh7w6ur7RrgMctHA0GT6kCvic01zSoExQiGBkw0T+kZkcLIN4ZncsP0S6eF
         oPalDQGBSo5nGFrndyfLAey5c7KY2u32KHHPWWbXC++a7JkL9jhp4Mca2N97Q7InrY2G
         GRSQ==
X-Gm-Message-State: AOJu0Yw+iynO0wSomLEHseM/6MPNAQrERGYawNqAmBxTj4xW8Zd8tIfq
	WSP590udjOYtaSqbV7cesmxq1S9J7/ZNkm32KED2qDXJZyC4kHtoEPCCeNz4jlaDc1gw01TxcSX
	FhIQLEZQ=
X-Gm-Gg: AR+sD133NFTNBZF1FtRSd7koSROY9VGvhU2cRExgdSJVgk5QhzkOqPCWJI8lmzg4mXC
	7/NkLhYZwbD1xqG+fToDpghInmJrZVXgO6yq2afSUShlVNik4U0C6TEbJS/uJse7ZFJpp2xeVd5
	AN7FxP56pYldX8z4I7SHDWFYgr5STCXXaksejh66e1F4gx/N5CqU+z7IsrCEyjOFwHAW2k/zvsD
	f81iK9fEexjm5L9pZgp+Zne8/9hkHL3Eg9igtGnnzUAIOFlrpVi5ndVDRAs6ggNYTKGfc7JAiGv
	GHGs2hRrM+jP1YfI9eSMFCj7ju7hNZz97up4kGzZGcnWhoNitqwQ8460TqavSCGfQFg0PLdw7g1
	sejolmdHmeHmRYqq9ntunrfVK/RFoecSJvaLCQCG9pFcbCDxk3Yd53RGv1Tr09HUSMHu/4xiBtC
	Rs4xwjazs8pfJei6dUDhHhjaVavV2PgygaDMpqzocme3O/YHdZ/lBR9PkEsTfSdF0QecQexYprp
	FhaGDo+lD15CCfjxHDhAJeZIhLGtaJxXMfPi+edYwCwIBXuMfCcxf2KOn4PHeTd9WocJLUZZo8t
	gQ2PMExFEA9WuiWH5Hf6X4QOiT0P
X-Received: by 2002:a17:90b:3805:b0:38e:9784:dd47 with SMTP id 98e67ed59e1d1-392ed01a8b1mr1328642a91.1.1786448072789;
        Tue, 11 Aug 2026 04:34:32 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1412035e08dsm4983584c88.1.2026.08.11.04.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 04:34:31 -0700 (PDT)
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
Subject: [PATCH v21 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Tue, 11 Aug 2026 17:03:46 +0530
Message-Id: <20260811113350.632737-1-pavitrakumarm@vayavyalabs.com>
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
 drivers/crypto/dwc-spacc/spacc_core.c         | 2553 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  858 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  285 ++
 drivers/crypto/dwc-spacc/spacc_device.h       |  242 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  344 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  118 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  325 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  665 +++++
 14 files changed, 6539 insertions(+)
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

