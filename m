From: Lee Nipper <lee.nipper@freescale.com>
Subject: [PATCH] crypto: ahash - fix ahash digest size
Date: Wed, 18 Feb 2009 16:49:39 -0600
Message-ID: <1234997380.362.495.camel@al08linux99>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:56054 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761657AbZBRWrK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Feb 2009 17:47:10 -0500
Received: from az33smr01.freescale.net (az33smr01.freescale.net [10.64.34.199])
	by az33egw02.freescale.net (8.14.3/az33egw02) with ESMTP id n1IMl8Al003498
	for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2009 15:47:08 -0700 (MST)
Received: from az33exm25.fsl.freescale.net (az33exm25.am.freescale.net [10.64.32.16])
	by az33smr01.freescale.net (8.13.1/8.13.0) with ESMTP id n1IMl8XQ003707
	for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2009 16:47:08 -0600 (CST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_ahash_show changed to use cra_ahash for digestsize reference.

Signed-off-by: Lee Nipper <lee.nipper@freescale.com>
---
Makes digestsize for an ahash to be shown correctly.
 crypto/ahash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index ba5292d..b2d1ee3 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -214,7 +214,7 @@ static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "async        : %s\n", alg->cra_flags & CRYPTO_ALG_ASYNC ?
 					     "yes" : "no");
 	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
-	seq_printf(m, "digestsize   : %u\n", alg->cra_hash.digestsize);
+	seq_printf(m, "digestsize   : %u\n", alg->cra_ahash.digestsize);
 }
 
 const struct crypto_type crypto_ahash_type = {
-- 
1.6.0.4


