From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 2/6] DRBG: Fix format string for debugging statements
Date: Sun, 06 Jul 2014 02:24:03 +0200
Message-ID: <10113803.ZGav7NrUuW@myon.chronox.de>
References: <2266932.bfVPMOTOeI@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: joe@perches.com, dan.carpenter@oracle.com,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	fengguang.wu@intel.com, Randy Dunlap <rdunlap@infradead.org>,
	linux-crypto@vger.kernel.org, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Rafael Aquini <aquini@redhat.com>,
	aris@redhat.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58220 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbaGFAmL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Jul 2014 20:42:11 -0400
Received: from myon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S253> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Sun, 6 Jul 2014 02:40:54 +0200
In-Reply-To: <2266932.bfVPMOTOeI@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The initial format strings caused warnings on several architectures. The
updated format strings now match the variable types.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
CC: Joe Perches <joe@perches.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index cce915b..c9b4c49 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1106,7 +1106,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 
 	/* 9.1 / 9.2 / 9.3.1 step 3 */
 	if (pers && pers->len > (drbg_max_addtl(drbg))) {
-		pr_devel("DRBG: personalization string too long %lu\n",
+		pr_devel("DRBG: personalization string too long %zu\n",
 			 pers->len);
 		return -EINVAL;
 	}
@@ -1984,7 +1984,7 @@ static int __init drbg_init(void)
 
 	if (ARRAY_SIZE(drbg_cores) * 2 > ARRAY_SIZE(drbg_algs)) {
 		pr_info("DRBG: Cannot register all DRBG types"
-			"(slots needed: %lu, slots available: %lu)\n",
+			"(slots needed: %zu, slots available: %zu)\n",
 			ARRAY_SIZE(drbg_cores) * 2, ARRAY_SIZE(drbg_algs));
 		return ret;
 	}
-- 
1.9.3
