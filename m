Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792427124;
	b=Yy/I4VLpdZ67mMxzD7sQGrrrtRyfUztwNT0EvN6H8mJApeS6GVhC0jn3Uw9mwDgOfPLB
	 b5MPU3Hqvl+tiYepItFr2rvsICf28DfRcBJoDE+3j08yYTlUJVSD2kCwhSpQorTn1lSUx
	 i4Y6wJqSW3MDVZizW9zZqbr+URFphOxtDXQjby8LClDY7/ljKnE9aOZJ5INxFQ/Zh1UE6
	 xqAypUZowsM3tAOPQKq/va6n65J4ff6Z6/tWk8Fqk2JJhdwpu6UgTxMUakRESZ7kvyIMv
	 lIwvLe7HDK1D5SByfFij8TFeQ5Bk9Lloe38H/jRak78CWgKDPY1SNfqV4pzAQxJ21Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792427124;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=w9H0rQ/bpIYjY7pl4rx3zJBA5MOJkHqcSOXTUsmhAcA=;
	b=fQk1dmAc2CZ8Lxd/mDPNJbADjB7+pkjxzkdmV8g6fvqrCZtJLOoMIF/yu1VHbS8V3mwg
	 N1KyBzli7hjYmmiiT+mkQwD3F+z7C3lzjSrmqSYhywQn/R5NzL9ks6u/ewOVDRaZKI2hL
	 mAjCquTL/vXu+tmcgMsZWc1/wFeQ/dLvoh1+T71S8d0ja/49P53/pygucy6t1AfySQQF6
	 nbCVxu3C9Zjizck6Nf7QInwko8GGNlINwfaanBoKreUCKy6d5X6u0ldrB0mX/MdT1/d8r
	 c4Ozndpi/ZTn7Q1OcIVrTyVXDrSDmnw3I43uZthCbHAFGHD2ITylkjI7Q2TKIuijTzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=vayavyalabs.com;
	spf=pass smtp.mailfrom=vayavyalabs.com;
	dkim=pass header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=AxerQ0fD;
	arc=none smtp.remote-ip=74.125.82.174
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9AD606A333
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 16:25:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D9AD606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=AxerQ0fD
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-3514b90bb89so5928146eec.1
        for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 09:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1792427123; x=1793031923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w9H0rQ/bpIYjY7pl4rx3zJBA5MOJkHqcSOXTUsmhAcA=;
        b=AxerQ0fDr1DpVZ+eowOCL7I/S2heiZFv9ol7GtELItdxnyQcur/p24QsP8QKwAXTZC
         +nqRvtm4U19AJAO8xBiQ/vttXInKdigPulC+bcvYt1rFlv3UMxLSB3kADB7TpWv+YQ+l
         ZO7PWlQAaxK/4k8KSSnlTH4/qCNVW806y99lQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792427123; x=1793031923;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w9H0rQ/bpIYjY7pl4rx3zJBA5MOJkHqcSOXTUsmhAcA=;
        b=GCXkmID49atBNrqNJSodiedV8k+BmCKWGmkp74uLLsRUD+wYYh58peLAAllsAy0bTn
         S2aD5h6LZ1d9wUnDFN7zSgdFhVYcg8wd7InnaKJGziusQIpF3jzdCOCA0dMaldW3tIkd
         Sjb33HyPOFbrDfvWMhklWqg4+GiN4uwaSCgqnx8SmIumQoULAJOFandQVboOqXO5odqa
         fkA+WXMo+4LT8R2Y+npzeW5SdlTrbl01IGGCdjdgnAeJJSV9hhkURTEYMCb+nrsag3zx
         4jk2fUhbyBVJs3IO1gdd1CmC9EiNZUDa+eSnaPkzWVDoIsRfgeEzpHgF/ubEl3AngBAh
         qoxg==
X-Gm-Message-State: AFq9FYLWZzn1Ne1sdsT+gz9stiNvqunrERIJEeHOm6Ut130Ds3OBdkP6
	n4HkOO/gQdlH4ENumlyuklGmUPk8+0yVpt4UsLbKOY89CCtoe17zEO3JWs5ERyQb04I2OXRvhUW
	Ra+W4Zn8=
X-Gm-Gg: AYBFou3gNDUk/j2JnUo7rYvZx4XSk4SFaC54nOLtC97gNT+mkiP2nP3/8P5srVT5adG
	8abYLIFEjsdTJsf77qkkH3HmAmFhQFN1EHXyh53mr+JVECZiEFtuc4l/Nf/2PJK8sdi977C/tSv
	NEDcjblmy5ZCFLPKpXuZ0thPjKoFL2rcEeuP7MhK1oANT80BEVYqhz1Pmr8r42fv7GW4pcJKZhU
	mZjp/HTDYDvwlacTHZgj/WLgLvl6hERUe2gANVp0IJEoQCuQAHI9xuVzgOKSBJLCwhVVfA1DifL
	ZYnNFPQBVPtHUN1OG4syTJjmuQkROfNvGhZUJNO7FUw103ydU0oTUQ2Q4+JRr/oxB9cw889d1PC
	5VlMg+GjoKd9/HdGCkoyfYldv2EcTKxMuM2ck8sr5UnZFimBlBJt3k/3pmz1BuN3EfB4YoucA2k
	ZbxzL009Rzaj2Q673I0/F7McUJaryAtNf9Cpyj3ACTx+BTVJqkF5zQH/VEvPxmJxpEbnOuenK/E
	ZuzenvRZtDlAYF2rCumDcGtbK9pmHNYM1QfCgOgqEbm2R532VLMd7F07Jqsm74KN1FGbMmsSR/S
	a0yhq8VWQt1nrOfmX8lyU9ca7yE5BN2ghYHo2Q==
X-Received: by 2002:a05:693c:69c2:b0:356:23dd:3c72 with SMTP id 5a478bee46e88-3619ed116cbmr9937459eec.4.1792427122345;
        Mon, 19 Oct 2026 09:25:22 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360819bc569sm32218885eec.11.2026.10.19.09.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 09:25:21 -0700 (PDT)
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
Subject: [PATCH v26 0/4] crypto: spacc - Add SPAcc Crypto Driver
Date: Mon, 19 Oct 2026 21:54:53 +0530
Message-Id: <20261019162457.1000115-1-pavitrakumarm@vayavyalabs.com>
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
 drivers/crypto/dwc-spacc/spacc_ahash.c        |  827 ++++++
 drivers/crypto/dwc-spacc/spacc_core.c         | 2547 +++++++++++++++++
 drivers/crypto/dwc-spacc/spacc_core.h         |  863 ++++++
 drivers/crypto/dwc-spacc/spacc_device.c       |  326 +++
 drivers/crypto/dwc-spacc/spacc_device.h       |  182 ++
 drivers/crypto/dwc-spacc/spacc_hal.c          |  349 +++
 drivers/crypto/dwc-spacc/spacc_hal.h          |  113 +
 drivers/crypto/dwc-spacc/spacc_interrupt.c    |  360 +++
 drivers/crypto/dwc-spacc/spacc_manager.c      |  661 +++++
 14 files changed, 6352 insertions(+)
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

