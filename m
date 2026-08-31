Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1613FE67B
	for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2026 12:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788179496; cv=none; b=ZAjy5lZgkQBtaj7rhCaRLeAJVNs6+W/f8etQxkHb0iRLUCJBoCu6xqRr6i7lP6+ZhtkbRU3xCZp54tTYik1tHiYVrLbsHadO8UNn4qthoTgLHyFm4G9Prt5Mo52eZ/N2Q1c5pbH8+2mOL6Qz66d+A+CjtjBuILzoKpTmMZWhRQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788179496; c=relaxed/simple;
	bh=bQLkDoeHgVKzs9K4FBqwtFlqF821xXrlMYXK9/455wE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Lwt7kBR5v47Xpx/8MlaUIPC/oJiJZVObaEhHpw2AsManFkqc5EecrDMi/VBZZL7lVTWW+IzUhmzrTxM9yJ9TUVTmiWf+aNwES0vdMuGAbcs889/PIXaXTHMQLHMkahVAwYFIjchLJ6DcIPsv/G5cfjXRHAzmNRJS5dZX/tOED6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=c2JSelNw; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="c2JSelNw"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c9e7391839cso3634282a12.0
        for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2026 05:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1788179494; x=1788784294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XSKQ66Trwq8vGmU+ivSCq/hAWDRhHGrboRlF9WbB/Ks=;
        b=c2JSelNwrh0z0NErJ0XAt2DCusl2LgoEr5/j9bH8jlTgc5vGr3n9h/m7feTRgo/J9Q
         4Gm7+TMZjDzE15D69HauHjKz6arV0K7XWFBr6mUWBI6Aro6je6AgyQARpLenISUy5hl3
         GAXoD4dZnPoAgi3OI+jy1F7cgvGvJn2RI4In0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788179494; x=1788784294;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XSKQ66Trwq8vGmU+ivSCq/hAWDRhHGrboRlF9WbB/Ks=;
        b=iWoaFxSDtZW+PJgVWUseZTvNYBZgiGBvRh/tu/cz9jeDKO1UAy87Fjv1rD1Xy3ME/F
         KTe36Ni6LgC4zBIQbH5sgVmyKhOEwzeln7lZ9tmqNJ3BN9+am+lMuukELtLQAVlb6ZXU
         ZesHRKy/rjpk90vqvq7MJpC2qA2LFW//v3RVzXo16qDpkQ6+LV8i+naHu1pcLZHDwpSF
         TXuLQqeTDxlL3nIMBLwg3Vq4NWNScHLSQSk72YlClsOkML4mIIMYJHwmZ+6Cnz+WdrzJ
         vj/qmI1za2WriDslJaQlVwuo0TP22YroVBEeSltOo5IHC/mKaOhDdxfS0EXglDZo4onT
         BcUw==
X-Gm-Message-State: AFuF++kN8Fm8OOZxVsdSWZ5WugvpAVUXYfQRmVFqbc1B5Dci5rGylw7T
	z48hFEA16x1oq7fhuNeOiQo7PEfGt2DVkSuXeIcgX0Rez6ufPslb8SVS7rAl2rgUJO/2sgCzLsH
	JbGx9
X-Gm-Gg: AYBFou3ETvjRGPOfSYIpfM7DCLBDHcJBIkU/OlTB5m5GaNH2y9IaClk6z39ZcRNvZ5Y
	LNT/5Dm5PWMfLxT+fYcPiyYQwhYPjySmhaymFI4iA8cjpaJ+971dxnw0njFOOkZdmE6JoNHLddh
	6CA+cqy4CtZnUqHecbawNegiFMuzAow6VRnoTcv2Sg8jIvl7e9y238/VuSltFWHly0q2DjZwiZi
	2jT56W858A0r2Rb+LsttQf16jjRSBlT+ibye6dGrVAIGnfC5TxLUTj1x05Qri69cKSzbcPZYIUc
	QZqXAtskFDPWx35ZtqL+BCZEPxme9Q8/dM9Niw0/rHeXKulXLe14+IR+MDNCSq69YVo+zI0gy5f
	7wVd3XnpJfmoqNchxOCop+TuXarK9mPZWe9mOnADdchHXE2T++OxfdQCJibEWVeGxEjITKP2dy5
	s9p6xWs5Rjmksj82nTznqw6uMP9GDwyNssRBkJWPB3kHWRsznrwLBtu0vMaathROEPXn7WW3T46
	yYgwFJIT8db8Kjoa4QtYDBeXx/yA2VK5bKbmUjK6TEY1Znmo8JbdPb+9pA0PXxVy2wA+4rq8npm
	pzVi1N1MF+IulgApi50f9n8O2AHgfZbI03EQYHk=
X-Received: by 2002:a17:90b:2b90:b0:38a:c3f:3b87 with SMTP id 98e67ed59e1d1-396d0fce294mr43253087a91.12.1788179494384;
        Mon, 31 Aug 2026 05:31:34 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-142e0d38207sm27470376c88.5.2026.08.31.05.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 05:31:33 -0700 (PDT)
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
Subject: [PATCH v24 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Mon, 31 Aug 2026 18:01:09 +0530
Message-Id: <20260831123113.870832-1-pavitrakumarm@vayavyalabs.com>
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
 drivers/crypto/dwc-spacc/spacc_ahash.c        | 1043 +++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2569 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  862 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  322 +++
 drivers/crypto/dwc-spacc/spacc_device.h       |  242 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  350 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  118 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  334 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  666 +++++
 14 files changed, 6630 insertions(+)
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


base-commit: 7537036a2e6fe96f8ed82034f755c54714a0e417
--
2.25.1

