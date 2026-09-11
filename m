Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F23037DEA2
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 14:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138041; cv=none; b=e2Rjx3dxff0gmYYUyOAxHSL2c3xKiQvkarQnOspTY9uR5yzcFNeNBVpDY3fiBDFdGMvXO0FU99qshLGSGhXXPXnYJQGD0oOAL8yXjTF+nOi7olMNM+aj3zFX9V3yLIZ6YZvKNDLC9ZC1payrOpXUukOBBZ7Wl2WtVf50s+mT7gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138041; c=relaxed/simple;
	bh=EOE0s7qJFK2MKJG007c+RD21gWRMCgKsjpIAFEfYs6Y=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ofeZUzOX4JHbrjg3zfGoiHxqxgPuvyS6bg4IBpszMu068GludkJHun9mI6QIgb4tgAVXh3vwQHQM11VI8sEDw41E65sk5jiJmwtSD3l9XXsORI+lxp94VEZL10fwpTYyJeHD91ioEcfeD+lodG6QhcvO/HsP8O6cfYrTk+YPmyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=rSBkZcp0; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="rSBkZcp0"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 942714E401EF;
	Fri, 11 Sep 2026 14:47:16 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 6837F601DE;
	Fri, 11 Sep 2026 14:47:16 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DC09011C7AFA5;
	Fri, 11 Sep 2026 16:47:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789138035; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=Ubqa7IwAwQIarmLSD0RSgMy2LcVHRHavKEquDkrruK0=;
	b=rSBkZcp0A8uHU/USPAyDKc9aOmUlGSz+ZbtAvaKJpiphE768IqQtVomMF1Gg6QNr/vGrrw
	wiq7A8YP13S0j2TW1FlQ+iJKxx0CJF7zOkhPTIqoqnkG0IURN0FQjP/rE4iG445H6LxmzU
	wZpn3UQWTgBmByPEEthPt/alclZLRgaZG/+/s5fGxAZkTw2lmFU2BRdmiHfHgatpaUyvYF
	Usjy0w7T8050tpTpDE+3GQjH9PZvYp13AZpPxLDBiZYnLRB0C6SrSEwkEu6Gk41N9pg1a9
	be6jg4SieHPb5CkS4t1jcXDqgxko8Yp8jIPt6W8jvy8NUDTKyCGU+ydZpcaj6A==
From: Paul Louvel <paul.louvel@bootlin.com>
Subject: [PATCH v6 00/19] crypto: talitos - Driver cleanup
Date: Fri, 11 Sep 2026 16:46:17 +0200
Message-Id: <20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqDMBBA0avIrDuQTmnEXqUUielERyRKJkpBv
 HvTunyL/3dQTsIKj2qHxJuozLHAXirwg4s9o7yLgQxZ01wN1njD5KnNbpI8a+sndnFdkGu2Dd2
 7YAJBqZfEQT7/8/N1WtduZJ9/OziOL12crwJ7AAAA
X-Change-ID: 20260910-7-3-rc2_talitos_cleanup-e7e6925bf0f2
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789138028; l=7705;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=EOE0s7qJFK2MKJG007c+RD21gWRMCgKsjpIAFEfYs6Y=;
 b=HZIYRWjHPzzws1VZ+2tQum6/4qDAm5F0r+RBe2NKtcA7CesNuZzHCqZuujohr2r66x7vP5hdG
 7eMI9zPdvSRAFmMv0IFo50ubA9Xg9kalFucjQ0UAkq0lFmYUcOvb0sH
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
 drivers/crypto/talitos.c                  | 3635 -----------------------------
 drivers/crypto/talitos/Kconfig            |   36 +
 drivers/crypto/talitos/Makefile           |    3 +
 drivers/crypto/talitos/talitos-aead.c     |  680 ++++++
 drivers/crypto/talitos/talitos-hash.c     |  705 ++++++
 drivers/crypto/talitos/talitos-rng.c      |   93 +
 drivers/crypto/talitos/talitos-skcipher.c |  359 +++
 drivers/crypto/talitos/talitos.c          | 1335 +++++++++++
 drivers/crypto/{ => talitos}/talitos.h    |  316 ++-
 11 files changed, 3501 insertions(+), 3701 deletions(-)
---
base-commit: 317cdd0bb81c505ac42700258732e551c4f75a53
change-id: 20260910-7-3-rc2_talitos_cleanup-e7e6925bf0f2

Best regards,
--  
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

