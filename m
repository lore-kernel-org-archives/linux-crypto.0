Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12E23E2751;
	Wed, 22 Jul 2026 08:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710474; cv=none; b=nGa6VvG0HPlZnsQxUbF0sPMZ6pP/gGtxnngF8wNsbv0UCB5qnWh8xKl1NN6CbipIODXMo30ZdtGV87uOAK986UuuhOMffqd61DqtDRs5/jhB5tnGmaItn1+EJhyXEopLVrGn96IdLj21z+g8BYF5AdJHqloCObCY0a5R6AoAu8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710474; c=relaxed/simple;
	bh=CSB/EU6/q2GTyUYMKuYf+xPog0VCyfl+LunNPgpIMeE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Dq6J9NwqoSnLtOMalV9EZYNC1aj3/zOiEgDYuuac8ow28sD3XzgYhHNTltKuwRLZoD1eMLUGkgGtleqBrGACzU9pL4LB2FYnjkDJAm2MGXUn4x3741LWoUsJHB8+v4N0O16cz9r6Q53ma55/dBeHIedfdsmTijHHO/YUxixebCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=j4YrEMRd; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="j4YrEMRd"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 600C71A1151;
	Wed, 22 Jul 2026 08:54:28 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 26DEF60388;
	Wed, 22 Jul 2026 08:54:28 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id AA9C311BD18BC;
	Wed, 22 Jul 2026 10:54:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784710467; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=nsQBpSf9/RR9P2P+9RQkmWgkWn30X2o27Koyh66z4u8=;
	b=j4YrEMRdIOWv3lE2iExcQtzXDC8GsN9k0aqf/Wlrz4/CxK1ZzafSEVrfBMkmQTxU28IakK
	ZJDqBHGQAj5JiUkjSBBRdfsVzcWe0koUIo1MR1/JiHBI26xP7jIe+w+2d8HrSswULJfEe7
	7V0lBtByFOeZJYYyNvjxJR1OLbDsBYb91hTH5SUL+zKjhLfUvUM4KucpMf3NiRcYCFVYHy
	rwLMYdlHJvU4QtTp8CQh8kjHza9qhYChcEieFldGbbpiLCGBOPlGOC7CfMi/Um91Whaali
	K9pjZ0ZE26WhFI9AATzsfpPI5Q08cIH1OWkDKUJ+9+ixlMmKDMT9HDgyMTV64A==
From: Paul Louvel <paul.louvel@bootlin.com>
Subject: [PATCH v4 00/19] crypto: talitos - Driver cleanup
Date: Wed, 22 Jul 2026 10:53:44 +0200
Message-Id: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/33Q0U7DIBQG4FdpuBbTA7TQXvkexjQHON0wWzsLb
 TTL3l3WLk5j9PJPDt/5D2cWaQoUWVuc2URLiGEcclAPBXN7HHbEg8+ZiVLUZQWGaw58ctAlPIQ
 0xs4dCIf5xBshAWtFoumR5denifrwvsrPL1uOs30ll67cbWKitzmvTNsYsxiJu/F4DKktvDW26
 YXQRkrSV7ZXCisQiEDGYC0qW6E37HvVttiKlorbcUyHMHQZT1+tI7nOzrvcjIOEuiFfau9du0h
 2LbkPMY3Tx/obC6ydNk/8ffgCvOTOAvraeULVPN02P+ZLVnURd6kG+FsSWUJUaEA6qhv7W5J3S
 Yt/JJkl7TSgsFo7I39Kl8vlE7zgE8r5AQAA
X-Change-ID: 20260518-7-1-rc1_talitos_cleanup-9231a64e29fa
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784710463; l=6122;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=CSB/EU6/q2GTyUYMKuYf+xPog0VCyfl+LunNPgpIMeE=;
 b=pCm5+D1ACLdHDyiCvrGwirKtmcsKqff3+qfOVN9HJ8bTf7PyJi/JtplZ9gPPGgpg8w+XOrZ/A
 FOJygeqZ8Y7CXqETPkR0zN0rN03b/heo27yfahKElCrMfMXhOoIvVnt
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
 drivers/crypto/talitos/talitos-hash.c     |  697 ++++++
 drivers/crypto/talitos/talitos-rng.c      |   93 +
 drivers/crypto/talitos/talitos-skcipher.c |  356 +++
 drivers/crypto/talitos/talitos.c          | 1337 +++++++++++
 drivers/crypto/{ => talitos}/talitos.h    |  316 ++-
 11 files changed, 3469 insertions(+), 3706 deletions(-)
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

