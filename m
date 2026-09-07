Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DBD470EA5;
	Mon,  7 Sep 2026 13:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788787403; cv=none; b=Q3FPXeAsqKCT7h0HIt0lh8wziAcroeSqG4lN9neHay01BBIxzM1QjecmSnliJcdRqA98rLo/sacuCnCjuwEetNUCbmS/HQL9FfvuNZYPQ+JywNXW9hpsFSkBp8Z/MCaZjMIpJQp7BK/NCmbo9+iCvB8RmOdSU6/7nZYdnDz2T3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788787403; c=relaxed/simple;
	bh=6/tZIjgYlPDCnA2gdyUwB+mS3j9cICGl6lRKZbJ6NW4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=WzGLjhDJPJaVtalyV0fZVcPdnF5e2RE4pOpLjyUUtd7F57XftfmDXBqTzag5NuRJVTiVcfvfjOy58JpREmJ28n9YD9lBjs9W4ijtAszfch1MS4QPgiqm50q1n2mHAToHG7FpBKAkm0ytg1pQFH6n8B33vqkmn44iPsAmgMh/ulM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=L2cRw5pc; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="L2cRw5pc"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 2A8074E41569;
	Mon,  7 Sep 2026 13:23:14 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id EBDEB60383;
	Mon,  7 Sep 2026 13:23:13 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id CB22B11C7AF23;
	Mon,  7 Sep 2026 15:23:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1788787392; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=I+ZtAvkf6k/wLeWcxjeg2Z2m4g05aYFAUCEjuKdkmqI=;
	b=L2cRw5pcQQJCl65O/jv2bqUsUCCsBPvxnajMOGMTOmNC+OyEOAUrQInoJauv3LyzSk8HXm
	47VnP/s2szCEMPgZe/8D1mLvPRrrEZbob8fKk9LuZL8ZKkFxmaFkKFvcnbaEvlwa3vQLaH
	bYrlycClijhLxp0oZMjrgsnBC8UpX8I2ujgsxvbHL15L/l5g73A2VBdtundT3nEeb3p3RR
	C++UvVKFVGC9PD//+pwkSQ2sNF++a1ExhBSvrYQBCwSiMxN86IO+ykW9aWRcj45Q/AGd4y
	2vJJc6OFOJQZy382BH9tMt0Rj8uOPUSGZL/c+qZaudfC41O4Ktjgsp+yPCpKPA==
From: Paul Louvel <paul.louvel@bootlin.com>
Subject: [PATCH v5 00/19] crypto: talitos - Driver cleanup
Date: Mon, 07 Sep 2026 15:22:34 +0200
Message-Id: <20260907-7-1-rc1_talitos_cleanup-v5-0-860f43cd7317@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/33QQW7DIBAF0KtYrEvlAWywV71HVVkDTFKqxE4Nt
 lpFuXuJHTWponT5peHNH44s0hgosrY4spHmEMPQ51A9Fcy9Y78lHnzOTJSiLiswXHPgo4Mu4S6
 kIXZuR9hPB94ICVgrEs0GWX59GGkTvhb59W3NcbIf5NKZu0yM9DnllWkdYxYjcTfs9yG1hbfGN
 hshtJGS9JndKIUVCEQgY7AWla3QG3ZbtS3WoqXidhjSLvRdxtNv60ius9M2N+MgoW7Il9p7186
 SnUu+h5iG8Xv5jRmWTqsnHh8+Ay+5s4C+dp5QNS+Xzc/5kkWdxVWqAR5LIkuICg1IR3Vj7yV5l
 bT4R5JZ0k4DCqu1M/JeUreSeCypLBnwQF6gbwD+SqfT6QeiwyKQQwIAAA==
X-Change-ID: 20260518-7-1-rc1_talitos_cleanup-9231a64e29fa
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788787387; l=7941;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=6/tZIjgYlPDCnA2gdyUwB+mS3j9cICGl6lRKZbJ6NW4=;
 b=umH84s/gA/99DS0hQPWM1Zz79JfjP0NPIoJg4WbOveln0zvQLWrHuXSeC6PPYI5ZnA90ZYRH9
 LIs0B3NOiukCFhbXQ3Q+p696EBlwwVByJg5pmTolui0ufPuL2jBU3AR
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

---
Paul Louvel (19):
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

 drivers/crypto/Kconfig                    |   38 +-
 drivers/crypto/Makefile                   |    2 +-
 drivers/crypto/talitos.c                  | 3640 -----------------------------
 drivers/crypto/talitos/Kconfig            |   36 +
 drivers/crypto/talitos/Makefile           |    3 +
 drivers/crypto/talitos/talitos-aead.c     |  680 ++++++
 drivers/crypto/talitos/talitos-hash.c     |  705 ++++++
 drivers/crypto/talitos/talitos-rng.c      |   93 +
 drivers/crypto/talitos/talitos-skcipher.c |  359 +++
 drivers/crypto/talitos/talitos.c          | 1337 +++++++++++
 drivers/crypto/{ => talitos}/talitos.h    |  316 ++-
 11 files changed, 3503 insertions(+), 3706 deletions(-)
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

