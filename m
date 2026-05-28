Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D502D39EF2A
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 09:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959363; cv=none; b=JdBL2emO+lZMXTKYjPJ39cnOnhZjUrDmrc1qKAPtI0q1HsZkVFbVEmYIc/fgJzf3p2Up5AJiM6m2Yw5FwK4RDl08nmN28+1Eq4IuTLIYyClsRQbUNdeWFXb5jZcuCMetB877PZzTpb4VR4zOnediMy3VETHGaAfgPzT0Ki/KwUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959363; c=relaxed/simple;
	bh=Qg35VnKR+yeiqLVcXImLUlEfa3huI2wAL13bmSWF0ig=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=t2kCtcJnJIWNxTEEbWAGiMs5Xv/ptD5w7fP3F5Lq1spIiqzUNme5vrmitZ1GyJ4AqhTXMwWM12leHBLT5GqfRMP2vUqkMS7KTQ9OZE29IEPXItQPDhH2XuKCqWX+gpt+RGSvJ27RcPgE62U1JmF18pc0cqU4pN4Vs2gJOJfBV40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=qMNGZS0g; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="qMNGZS0g"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 298241A36FC;
	Thu, 28 May 2026 09:09:18 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id E635960495;
	Thu, 28 May 2026 09:09:17 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0C40410888508;
	Thu, 28 May 2026 11:09:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959357; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=dIQTh7JvbFjjKYumguQcjN0HHC3JAU8L3VHuBNTHH7E=;
	b=qMNGZS0gVt0cQ7H8AiZn72scID9oz+fJHgVwAIpTOPs0tlOnb5WtfEHuW78iDeMrDkk5Xg
	dD5Him8+nBmcvqDjLzuKlGRMN9sOmlX1J02VZVqm2SAqDhCVwvxu90Z/DwWomY7BphgUA8
	ViBFrAponSfQVSmwABrHFrnb5bZv8MzENw2I80bbdQUCI2W+/kJt8cYEqVzbubzs2D96Dg
	9MS9sZxc4t4bxn2CrozYOEQt+qRWrXe3Y1NgIEiDvoBUZ8ba3+1e/R1lQq3kDcwVA9xt91
	ZW+0y+lBBdIINtolzLanOCg4i7i+kN00stppUiGiSmIUbbvYQ868IkiHXKhffA==
From: Paul Louvel <paul.louvel@bootlin.com>
Subject: [PATCH 00/29] crypto: talitos - Driver cleanup
Date: Thu, 28 May 2026 11:08:13 +0200
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/02O3YrCMBBGX6XMtYFO0p+0ryJSJsnUjdTGTVJZE
 N9941ZkLw98c+Y8IHH0nGCsHhD57pMPawE8VGC/aD2z8K4wyFp2dYta9AJFtDhlWnwOabIL07r
 dxCAVUtewHGaCcn2LPPufP/PxtHPazIVtfunei8jfW3mZ9xkYSixsuF59HitntBlmKXutFPcv7
 dw01KIkQtaaOtmalpyG/6ljtYfWjTAh5MWvU5HnT3ViO5ntXMoEKuwGdnXvnB3vCk7P5y8mBe6
 ADgEAAA==
X-Change-ID: 20260518-7-1-rc1_talitos_cleanup-9231a64e29fa
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=6001;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=Qg35VnKR+yeiqLVcXImLUlEfa3huI2wAL13bmSWF0ig=;
 b=PmsJf/DfUjuFpBpjyThMuUQBzNNrlcXB0niqym6bUqr474jIoMzuO1K2HQhHcPW1AS6d8rXV/
 OtNKD5i7bi1BGIkiT10yiHX8ojBgtkxnRnQhv4eIK56NVIiddQQFbYg
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

The Freescale Integrated Security Engine (SEC) aka "Talitos" driver
implementation is a monolithic ~3800-line file that mixes SEC1 and SEC2
hardware variants with hash, skcipher, aead and hwrng algorithm.

This series reorganises the driver to improve readability and
maintainability.
One of the main motivation for this series is to eleminate all the
conditionals around the has_ftr_sec1(). Some checks still remains in
crypto algorithm implementation at the end of the series.

Patch 1 adds the CRYPTO_AHASH_ALG_BLOCK_ONLY flag for the ahash
implementation to eliminate manual partial-block buffering.

Driver reorganisation (patches 2-9):

  Move the driver into a dedicated directory, split the different crypto
  implementation into dedicated translation units.

Algorithm definition cleanup (patches 10-17):

  Remove algorithm property mutations from the registration loop, delete
  the now-unused priority field in struct talitos_alg_template, and
  convert hash, skcipher and aead to the type-specific init_tfm/exit_tfm
  API, replacing the deprecated cra_init/cra_exit fields.

  Use preprocessor macros to deduplicate the hash, skcipher and aead
  algorithm definitions.

SEC1/SEC2 ops abstraction (patches 18-27):

  Introduce struct talitos_ops, split SEC1/SEC2-specific
  code into separate function variants, and replace runtime is_sec1
  conditionals with indirect calls through the ops table.

  Export common channel and error handling routines, and move SEC1 and
  SEC2 ops into dedicated translation units.

  Introduce struct talitos_ptr_ops to abstract SEC1/SEC2 pointer
  helpers behind per-SEC-version ops, then remove the now-unused
  global pointer helper functions.

  Introduce per-SEC-version descriptor structures and ops.

Patch 28 cleans up the includes in the core driver file now that all
crypto implementation code has been moved out.

Patch 29 removes a now-useless macro.

No functional changes are intended for patches 2-29.

This series depends on the "crypto: talitos - bug fixes" series :
https://patch.msgid.link/20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-0-c98d7589b942@bootlin.com

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
Paul Louvel (29):
      crypto: talitos/hash - Use CRYPTO_AHASH_BLOCK_ONLY API
      crypto: talitos - Move driver into dedicated directory
      crypto: talitos - Add missing includes to driver header file
      crypto: talitos/hwrng - Move into separate file
      crypto: talitos - Prepare crypto implementation file splitting
      crypto: talitos - Introduce registration helper
      crypto: talitos/hash - Move into separate file
      crypto: talitos/skcipher - Move into separate file
      crypto: talitos/aead - Move into separate file
      crypto: talitos - Remove alg settings in talitos_register_common()
      crypto: talitos - Remove unused priority field in struct talitos_alg_template
      crypto: talitos/hash - Convert to init_tfm/exit_tfm type-specific API
      crypto: talitos/skcipher - Convert to init/exit type-specific API
      crypto: talitos/aead - Convert to init/exit type-specific API
      crypto: talitos/hash - Use macro for algorithm definitions
      crypto: talitos/skcipher - Use macro for algorithm definitions
      crypto: talitos/aead - Use macro for algorithm definitions
      crypto: talitos - Split SEC1/SEC2 code into separate function variants
      crypto: talitos - Introduce struct talitos_ops
      crypto: talitos - Replace SEC1/SEC2 conditionals with ops dispatch
      crypto: talitos - Export common channel and error handling routines
      crypto: talitos - Move SEC1 ops into talitos-sec1.c
      crypto: talitos - Move SEC2 ops into talitos-sec2.c
      crypto: talitos - Introduce per-SEC-version pointer helper ops
      crypto: talitos - Dispatch pointer helpers through ptr_ops
      crypto: talitos - Remove now-unused global pointer helpers
      crypto: talitos - Introduce per-SEC-version descriptor structures and ops
      crypto: talitos - Clean up includes in core driver file
      crypto: talitos - Remove TALITOS_DESC_SIZE macro

 drivers/crypto/Kconfig                    |   38 +-
 drivers/crypto/Makefile                   |    2 +-
 drivers/crypto/talitos.c                  | 3640 -----------------------------
 drivers/crypto/talitos/Kconfig            |   36 +
 drivers/crypto/talitos/Makefile           |    6 +
 drivers/crypto/talitos/talitos-aead.c     |  677 ++++++
 drivers/crypto/talitos/talitos-hash.c     |  711 ++++++
 drivers/crypto/talitos/talitos-rng.c      |   93 +
 drivers/crypto/talitos/talitos-sec1.c     |  374 +++
 drivers/crypto/talitos/talitos-sec2.c     |  404 ++++
 drivers/crypto/talitos/talitos-skcipher.c |  364 +++
 drivers/crypto/talitos/talitos.c          |  917 ++++++++
 drivers/crypto/{ => talitos}/talitos.h    |  255 +-
 13 files changed, 3810 insertions(+), 3707 deletions(-)
---
base-commit: db8b9f227833e729faf44a512aa1e88a625b5ad8
change-id: 20260518-7-1-rc1_talitos_cleanup-9231a64e29fa
prerequisite-change-id: 20260504-bootlin_test-7-1-rc1_sec_bugfix-13169ed07ddc:v3
prerequisite-patch-id: 7b364911e4b8d1c1033eb14e67ed24dac6a4bc13
prerequisite-patch-id: 2c1cd7fdd003d9a116a697efa25d1716d548389f
prerequisite-patch-id: b12bdbf565747609e0cfe0609a42cf69b5d816a1
prerequisite-patch-id: 72cb2bc0fc2a48a5a029b049c199f4c86085cf04
prerequisite-patch-id: 5f1f5ad6add760161bd48875df48c0893aa12613
prerequisite-patch-id: 934931086968229434d15a2f2358aeb7e6975a1d
prerequisite-patch-id: 8a0b4828fc0690e0c841bc9adcc6568bb522e0e8
prerequisite-patch-id: 1d870f32e7dbf9a8bd3b8979558544107693e0f4
prerequisite-patch-id: 758c18d7c9fabb14bd90df62e5e8a62a6f880db4
prerequisite-patch-id: ce6e9e585f8edc1861ae6bb8fbdd836c20cbd290
prerequisite-patch-id: 9446dc03e442ea81c5f5b39e802e01b37da29971

Best regards,
--  
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

