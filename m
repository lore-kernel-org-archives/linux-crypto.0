From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] ansi_cprng: enforce key != seed in fips mode
Date: Thu,  3 Nov 2011 16:24:45 -0400
Message-ID: <1320351885-28555-1-git-send-email-jarod@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	Stephan Mueller <smueller@atsec.com>,
	Steve Grubb <sgrubb@redhat.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab1KCUZH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Nov 2011 16:25:07 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Apparently, NIST is tightening up its requirements for FIPS validation
with respect to RNGs. Its always been required that in fips mode, the
ansi cprng not be fed key and seed material that was identical, but
they're now interpreting FIPS 140-2, section AS07.09 as requiring that
the implementation itself must enforce the requirement. Easy fix, we
just do a memcmp of key and seed in fips_cprng_reset and call it a day.

CC: Neil Horman <nhorman@tuxdriver.com>
CC: Stephan Mueller <smueller@atsec.com>
CC: Steve Grubb <sgrubb@redhat.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 crypto/ansi_cprng.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index ffa0245..a7fdcb4 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -414,10 +414,15 @@ static int fips_cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
 static int fips_cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 {
 	u8 rdata[DEFAULT_BLK_SZ];
+	u8 *key = seed + DEFAULT_BLK_SZ;
 	int rc;
 
 	struct prng_context *prng = crypto_rng_ctx(tfm);
 
+	/* fips strictly requires seed != key */
+	if (!memcmp(seed, key, DEFAULT_PRNG_KSZ))
+		return -EINVAL;
+
 	rc = cprng_reset(tfm, seed, slen);
 
 	if (!rc)
-- 
1.7.1
