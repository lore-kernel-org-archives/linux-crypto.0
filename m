Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0152650257F
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 13:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897128; cv=none; b=mHpqlrBVSifi0bzjZvSqTJB5fpfeEGiKS6cLrP1bftAbUj45uQVhYadfdyhxKfZyGQBi1ZegS7xHgjnL/2lb/VijtFfITRJNPwJFeGAZEqQ98a1oCyJOTordD5+SX9vZWyDG65ZTghG56a00dDFdKs+aLc162pDYnTDe3dM34CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897128; c=relaxed/simple;
	bh=VJ/p1/7rKfCajgKeueCgjHv9fe+zUyC2xYOqd03nQk0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ROe+tXbE+yUFwzUffXNClLl22yvwjWC90fMsXNACqVTybSjQW3Pno69RD4sAW3b7npZ3edJb9BC9L0cClWsi2jos8AZRQBFrzqIshEAZQVCeGNyGiY6KWvSuU491VtgqEu2GwBgOp4+aP5w9mvn539yLSJMPNphtWwkbkxteZ/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=vGsGxqqO; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="vGsGxqqO"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id ADF67C653F1;
	Tue, 13 Oct 2026 13:12:58 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 25BE960362;
	Tue, 13 Oct 2026 13:12:03 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E3BE811D71396;
	Tue, 13 Oct 2026 15:11:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1791897118; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=T1L9Pp1Yu61OOw84yuUn9MhzP49KeAFbS8sbaOGj3hI=;
	b=vGsGxqqOUU0E6/+5qkR4oZLiFr8c/pQ4yUTd8cd0Bs4ScUSz6oU9xCWi6vr2wCw2rDKizd
	XrFuASKFsPRCnB0iz697M6K8JdmioHiFMyb6On6yO7SyrpQ4WJBmPFt5H8jsZA0K00u67i
	+JJUIhXGh6CHDiCbbkvsCVEgHF6mfP3QsFraxf5OCXUioyNARc0NykCrFjbNrZwMauU45Q
	pp2VfjaRk6tvUnEZXSnvTUOPNAe3/oT/luSUhNt86gWMKnLoUURTHm7sstHaZO+M0ByYQm
	4EiZkHPNGFGyOPxBtca1yM406f9978fb7RQvKjmDy/qxO6a4z8sFTpmZAYRZ3A==
From: Paul Louvel <paul.louvel@bootlin.com>
Subject: [PATCH v8 00/20] crypto: talitos - Driver cleanup
Date: Tue, 13 Oct 2026 15:11:26 +0200
Message-Id: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WN0Q6CIBhGX8VxHQ1RIbrqPVpzSD9JM3GArOZ89
 8TWVhdenu37zpmQB2fAo2M2IQfReGP7BQ67DKlW9jfA5rowooQyInKCOS6wU7QOsjPB+lp1IPt
 xwMCBCVo1mmiKlvfgQJvnaj5fPuzH5g4qJF1atMYH615rOrK0+1byzUpkmOCS5pUuSq4El6fG2
 tCZfq/sA6VO5D8mWmyb+GISsqwoy7Uigv+b5nl+A3D4dTccAQAA
X-Change-ID: 20260910-7-3-rc2_talitos_cleanup-e7e6925bf0f2
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791897108; l=10637;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=VJ/p1/7rKfCajgKeueCgjHv9fe+zUyC2xYOqd03nQk0=;
 b=44Fhl74L3h+p5rFpQJ3bL4CNp65gPMvcO8jLY9hd6bJYxIVXyYUZ/oAhRdhMj1U6PpusorPtv
 xrqSGKqxhgJBk/xVtXWolzvY1BlItP2T2FnzNQoSjn+5CxoLZYaKyh0
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

The Freescale Integrated Security Engine (SEC) aka "Talitos" driver
implementation is a monolithic ~3800-line file that mixes SEC1 and SEC2
hardware variants with hash, skcipher, aead and hwrng algorithm.

This series reorganises the driver to improve readability and
maintainability:

- Split the driver into a dedicated directory with separate files for
  hash, skcipher, aead, and hwrng implementations.

- Modernise the crypto API usage: adopt {init,exit}_tfm (deprecated
  cra_init/cra_exit), use CRYPTO_AHASH_ALG_BLOCK_ONLY to eliminate
  manual partial-block buffering, and use macros to deduplicate
  algorithm definitions.

- Introduce a is_sec1() helper to get rid of is_sec1 variables /
  parameters.

- Define descriptor/pointer structures for each hardware version,
  instead of using a single structure and anonymous union.

No functional changes are intended except for patch 1.

This series depends on the "crypto: talitos - bug fixes" series :
https://patch.msgid.link/20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-0-c98d7589b942@bootlin.com

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
Changes in v8:
- Patch 1: not addressing this Sashiko issue.
  I had no problem while testing, and [0] "When this flag is cleared to
  manually pad the message, it appears to completely disable the
  hardware's HMAC outer hash (opad) execution." is an hallucination.
  There is no such statement in the reference manual, nor the
  programming manual (AN2912).

- Patch 6: fixed regression while moving hash implementation.

- Patch 16 & 17: not addressing this Sashiko issue.
  There cannot be a SEC1 and SEC2 hardware engine in a single SoC. And
  it will not happen anytime, this line of SoC is more than 20 years
  old. Also stated in v7 changelog.

- Patch 18: removed __packed attribute. It does not serve any purpose
  outside of semantic, and can indeed force the compiler to issue less
  efficient memory access.

- Link to v7: https://patch.msgid.link/20260923-7-3-rc2_talitos_cleanup-v7-0-9a45261fc097@bootlin.com

[0]: https://sashiko.dev/#/patchset/20260923-7-3-rc2_talitos_cleanup-v7-0-9a45261fc097%40bootlin.com?part=1

Changes in v7:
- Patch 1: instead of using DESC_HDR_MODE0_MDEU_MD5 to detect if we are
  using the MD5 hash, use crypto_ahash_digestsize() instead.
  Flagged by Sashiko.

  Increment req_ctx->message_size before submitting the descriptor to
  the hw. Decrement if it fails.
  Flagged by Sashiko.

- Patch 2: rename the main driver file to talitos-core.c. That way, the
  module is still named talitos.
  Flagged by Sashiko.

- Patch 4: instantiate t_alg->dev before registering the algorithm to
  the core.
  Flagged by Sashiko, seems plausible but never had a panic when
  executing crypto selftests.

Added a patch adding an entry in the MAINTAINERS file for this driver.

Sashiko reviews dismissed:

[1], 1: If this is an issue, it is an existing issue because
the driver used devm_kzalloc() to allocate an instance of struct
talitos_crypto_alg.
Second, how should a driver knows that it should keep this memory
because a tfm instance is still alive ? For me, the only fix would be to
use kzalloc() and then never free it, which is not acceptable.

[2], [3]: A kernel configuration that selects both version is possible,
but a SoC featuring both hardware version of the crypto engine is not
possible and not described in any device tree. Freescale MPCxxxx SoC
family is more than 15+ years old.

- Link to v6: https://patch.msgid.link/20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a@bootlin.com

[1]: https://sashiko.dev/#/patchset/20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a%40bootlin.com?part=6

[2]: https://sashiko.dev/#/patchset/20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a%40bootlin.com?part=16

[3]: https://sashiko.dev/#/patchset/20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a%40bootlin.com?part=18

Changes in v6:

- v5 could not be applied by Sashiko because I forgot re-parenting this
  series with a newer release.

- Link to v5:
  https://patch.msgid.link/20260507-bootlin_test-7-1-rc1_sec_bugfix-v3-0-c98d7589b942@bootlin.com

Changes in v5:
- Patch 1: compute the SEC1 software padding length in little endian for
  MD5. Update message_size only once the hardware has accepted the
  request, so a failed submission no longer updates the message length.
  A note on Sashiko third comment [1]:

  - If the current digest operation errors out because the driver
    returned -EAGAIN, it indeed clears the partial block buffer in the
    core with CRYPTO_AHASH_ALG_BLOCK_ONLY.

    Looking at how the API handles it, it means for me that the entire
    digest operation must be restarted, not just the current chunk of
    data currently being processed with .update() or .finup(). In this
    case, no need to keep the partial block buffer.

    If I am mistaken, how should this be handled?

- Patch 4: rename the module target to crypto-talitos to remove the
  circular dependency in the Makefile.

- Patch 5: make __map_single_talitos_ptr() static inline to avoid
  unused-function warnings.

- Patches 6, 7 and 8: register algorithms from a copy of the templates
  instead of modifying the global arrays. Make the algorithm template
  arrays const.

- Patch 12: keep the "hmac-<hash>-talitos" driver names in the hash
  macros.

- Patches 12/13/14: added a driver_name parameter to the algorithm
  macros. The driver name is built from driver_name"-talitos" instead
  of name"-talitos", so the old dash separated format survives
  ("cbc-aes-talitos" rather than "cbc(aes)-talitos"). Sashiko flagged
  this in the v4 review as a userspace ABI break.

- Patch 15: move before the macro conversion patches, and set the
  properties that do not depend on runtime features in the templates.
  This patch is now patch 12 in the series.

- Link to v4:
  https://patch.msgid.link/20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com

Changes in v4:
- The modification I did in v3 in PATCH 1 was incomplete. message_size
  was not initialized in ahash_init(), and not incremented in
  ahash_process_req().
- Link to v3: https://patch.msgid.link/20260721-7-1-rc1_talitos_cleanup-v3-0-7c71a2b77c83@bootlin.com

Changes in v3:
- Upon Herbert's remark on FINAL_NONZERO flag not working with algorithms
  like md5, I removed the flag entirely for all algorithms.
  Only the SEC1 revision is buggy when sending 0 byte descriptor
  : the hardware yield an error. On the SEC2, this bug is not present
  and can accept zero byte descriptor if the hardware auto-pad.
  This bug is mitigated for SEC1 with software padding in
  talitos_handle_buggy_hash().
  It had to be slightly change in PATCH 1 because of the removal of
  FINAL_NONZERO : the message length in bits was always zero. Now, a
  zero byte request can happen after a handful of non-zero byte
  requests.
  Keep track of the message length in the request context, and put the
  message length in bits as a 64-bit big endian integer at the end of
  the padding.
  Allocate a buffer per ahash request instead of using a static buffer,
  since it is now written to.
- Link to v2: https://patch.msgid.link/20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com

Changes in v2:
- Fixed compilation warnings and errors.
- Instead of using ops to dispatch SEC1/SEC2 variants, keep the small
  helpers, and introduce is_sec1() inline function that can use static
  key branching in case both hardware version are compiled.
- Dropped the SEC1/SEC2 function variants inside the core driver file.
- Reworded the cover letter for clarity.
- Link to v1: https://patch.msgid.link/20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com

References:

[1]: https://sashiko.dev/#/patchset/20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911%40bootlin.com?part=1

To: Herbert Xu <herbert@gondor.apana.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>

---
Paul Louvel (20):
      crypto: talitos/hash - Use CRYPTO_AHASH_BLOCK_ONLY API
      crypto: talitos - Move driver into dedicated directory
      crypto: talitos - Add missing includes to driver header file
      crypto: talitos/hwrng - Move into separate file
      crypto: talitos - Prepare crypto implementation file splitting
      crypto: talitos/hash - Move into separate file
      crypto: talitos/skcipher - Move into separate file
      crypto: talitos/aead - Move into separate file
      crypto: talitos/hash - Convert to {init,exit}_tfm type-specific API
      crypto: talitos/skcipher - Convert to {init,exit}_tfm type-specific API
      crypto: talitos/aead - Convert to {init,exit}_tfm type-specific API
      crypto: talitos - Remove alg settings in talitos_register_common()
      crypto: talitos/hash - Use macro for algorithm definitions
      crypto: talitos/skcipher - Use macro for algorithm definitions
      crypto: talitos/aead - Use macro for algorithm definitions
      crypto: talitos - Introduce is_sec1() helper with static key support
      crypto: talitos - Replace has_ftr_sec1() with is_sec1() static key helper
      crypto: talitos - Introduce per-SEC-version descriptor and pointer structures
      crypto: talitos - Remove TALITOS_DESC_SIZE macro
      MAINTAINERS: add entry for talitos driver

 MAINTAINERS                               |    6 +
 drivers/crypto/Kconfig                    |   38 +-
 drivers/crypto/Makefile                   |    2 +-
 drivers/crypto/talitos.c                  | 3646 -----------------------------
 drivers/crypto/talitos/Kconfig            |   36 +
 drivers/crypto/talitos/Makefile           |    3 +
 drivers/crypto/talitos/talitos-aead.c     |  680 ++++++
 drivers/crypto/talitos/talitos-core.c     | 1345 +++++++++++
 drivers/crypto/talitos/talitos-hash.c     |  710 ++++++
 drivers/crypto/talitos/talitos-rng.c      |   93 +
 drivers/crypto/talitos/talitos-skcipher.c |  359 +++
 drivers/crypto/{ => talitos}/talitos.h    |  316 ++-
 12 files changed, 3522 insertions(+), 3712 deletions(-)
---
base-commit: d8ede9a01d5e01d6c75103d29cc5490243d059de
change-id: 20260910-7-3-rc2_talitos_cleanup-e7e6925bf0f2

Best regards,
--  
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

