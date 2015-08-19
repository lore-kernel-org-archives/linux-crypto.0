From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: cmac - allow usage in FIPS mode
Date: Wed, 19 Aug 2015 08:42:07 +0200
Message-ID: <2773400.HYW9KrTIf6@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48130 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbbHSGmL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Aug 2015 02:42:11 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

CMAC is an approved cipher in FIPS 140-2. The patch allows the use
of CMAC with TDES and AES in FIPS mode.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/testmgr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index d0a42bd..a865ea9 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2476,6 +2476,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "cmac(aes)",
+		.fips_allowed = 1,
 		.test = alg_test_hash,
 		.suite = {
 			.hash = {
@@ -2485,6 +2486,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "cmac(des3_ede)",
+		.fips_allowed = 1,
 		.test = alg_test_hash,
 		.suite = {
 			.hash = {
-- 
2.1.0
