Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF70368942;
	Thu, 11 Jun 2026 07:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781163407; cv=none; b=u1H2jf5HWD00bX40L1lcMGCwJ+dPk3/Lt9JqVLGUFDe1/oceUjTfzAgNkkzpysgcMDCzOOYrYRx3FKP1z/16B1UiT14wtuP2NaJmBHyCFZ1K4gDKVoSX/X8xZIMVDY78BCmRu9Zcz4795WaI/q3g4lDoRQ1vCRtBRQt+QMNQc/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781163407; c=relaxed/simple;
	bh=45mA4XoHbVDMLCYsFGSDlEsmkzVdocVt46n2mVtkeGc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Itt2OTkHl1cPrd8BlyMBU2FH7KYliJkp9UvmuOlJHqf6NQ2Exyp9KmtTOeyHoH8plyYSMXucajdShe9a9QuA99bE3XQZG3uaL7iyq4AW9aHk/qPsBZkX1mMP2TL5FQHHDB6K2PDMEHE02PdHV4t0BFBgZUJqPxUIdZ5Rf+HOWqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=J7MRpvM1; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="J7MRpvM1"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 9FA7B4E42DF5;
	Thu, 11 Jun 2026 07:36:43 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 73E8F5FF03;
	Thu, 11 Jun 2026 07:36:43 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1195E106B98A2;
	Thu, 11 Jun 2026 09:36:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1781163402; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=nVMWlVGnvGK9dFz65T+Gr4iwONiDyFcs+A/j17EAPiE=;
	b=J7MRpvM1pwy924YnunDUSOR5AquWku30534yoH2YIYwJKMSKsfyZKUnGu8ywhWUh4u+Ibt
	AT8UZQZWndL2U8bhvZ3adGiPbATTrziZPKBM6Bkb0u4s5ppGEnkWXQlHFT5gmzFti/egE5
	/Y3v5oI2Qpnd2vUD+/SA6MQgoPvUoETlJddOPNWIAos1J5tqn5modf/J9ryY2vK9hF8+rt
	YaopdVVxQgVK+ZHwiMtJLk1ot44d7v1jsIDa/u5BzrU0hyI10/hvzZ/rYK+YZLDdvws1SU
	DqrOP8d6fcChm1teFNunRZbKKJznTgeRAY1iUZoz9B8mCbxmfZ7LlPx9BzIe4w==
From: Paul Louvel <paul.louvel@bootlin.com>
Subject: [PATCH v2 00/19] crypto: talitos - Driver cleanup
Date: Thu, 11 Jun 2026 09:35:54 +0200
Message-Id: <20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WQy26DMBBFfwV5XVeMeRlW/Y8qQmN7SFwRnNoGN
 Yr49xiIqm66vNKdM2fmwQJ5S4F12YN5WmywbkpBvGVMX3A6E7cmZSZyUecVSN5w4F5DH3G00YV
 ej4TTfOOtKADrkkQ7IEvTN0+D/dnJn6cjh1l9kY4b7tXw9D2nlfGoMYWBuHbXq41dZpRU7SBEI
 4uCmg07lCVWIBCBpMRaVKpCI9lf1WS+i+YlV87F0U59gsdf60C6V/M5mXEooG7J5I0xulsKtkl
 ebIjO3/dvLLA7HTzx/+EL8JxrBWhqbQjL9uO1+T1dwk7ruj4BP4YvWGUBAAA=
X-Change-ID: 20260518-7-1-rc1_talitos_cleanup-9231a64e29fa
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781163398; l=4812;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=45mA4XoHbVDMLCYsFGSDlEsmkzVdocVt46n2mVtkeGc=;
 b=Ht+7vRLFCyelrnAB1dqFJnLWnbeV5yQKMsuTV1F6M25PZxeaMuLGg4jvtWmGeeTIFxxhjmkGI
 /7jjhw+X2p4B3zuUeoEOLZaTGTMTDv4KyYc9zbOmOHqHbt5dgq64y9V
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
Changes in v2:
- Fixed compilation warnings and errors.
- Instead of using ops to dispatch SEC1/SEC2 variants, keep the small
  helpers, and introduce is_sec1() inline function that can use static
  key branching in case both hardware version are compiled.
- Dropped the SEC1/SEC2 function variants inside the core driver file.
- Reworded the cover letter for clarity.
- Link to v1: https://patch.msgid.link/20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com

To: Herbert Xu <herbert@gondor.apana.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

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
      crypto: talitos/hash - Use macro for algorithm definitions
      crypto: talitos/skcipher - Use macro for algorithm definitions
      crypto: talitos/aead - Use macro for algorithm definitions
      crypto: talitos - Remove alg settings in talitos_register_common()
      crypto: talitos - Introduce is_sec1() helper with static key support
      crypto: talitos - Replace has_ftr_sec1() with is_sec1() static key helper
      crypto: talitos - Introduce per-SEC-version descriptor and pointer structures
      crypto: talitos - Remove TALITOS_DESC_SIZE macro

 drivers/crypto/Kconfig                    |   38 +-
 drivers/crypto/Makefile                   |    2 +-
 drivers/crypto/talitos.c                  | 3640 -----------------------------
 drivers/crypto/talitos/Kconfig            |   36 +
 drivers/crypto/talitos/Makefile           |    3 +
 drivers/crypto/talitos/talitos-aead.c     |  657 ++++++
 drivers/crypto/talitos/talitos-hash.c     |  691 ++++++
 drivers/crypto/talitos/talitos-rng.c      |   93 +
 drivers/crypto/talitos/talitos-skcipher.c |  356 +++
 drivers/crypto/talitos/talitos.c          | 1337 +++++++++++
 drivers/crypto/{ => talitos}/talitos.h    |  316 ++-
 11 files changed, 3463 insertions(+), 3706 deletions(-)
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

