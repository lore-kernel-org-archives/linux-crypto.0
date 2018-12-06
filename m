Return-Path: <SRS0=k6po=OP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728758AbeLFEyj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Dec 2018 23:54:39 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Cc: linux-crypto@vger.kernel.org
Subject: [PATCH] dm verity: log the hash algorithm implementation
Date: Wed,  5 Dec 2018 20:54:13 -0800
Message-Id: <20181206045413.32531-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Log the hash algorithm's driver name when a dm-verity target is created.
This will help people determine whether the expected implementation is
being used.  It can make an enormous difference; e.g., SHA-256 on ARM
can be 8x faster with the crypto extensions than without.  It can also
be useful to know if an implementation using an external crypto
accelerator is being used instead of a software implementation.

Example message:

[   35.281945] device-mapper: verity: sha256 using implementation "sha256-ce"

We've already found the similar message in fs/crypto/keyinfo.c to be
very useful.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-target.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index fc65f0dedf7f..f4c31ffaa88e 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1040,6 +1040,15 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		v->tfm = NULL;
 		goto bad;
 	}
+
+	/*
+	 * dm-verity performance can vary greatly depending on which hash
+	 * algorithm implementation is used.  Help people debug performance
+	 * problems by logging the ->cra_driver_name.
+	 */
+	DMINFO("%s using implementation \"%s\"", v->alg_name,
+	       crypto_hash_alg_common(v->tfm)->base.cra_driver_name);
+
 	v->digest_size = crypto_ahash_digestsize(v->tfm);
 	if ((1 << v->hash_dev_block_bits) < v->digest_size * 2) {
 		ti->error = "Digest size too big";
-- 
2.19.2
