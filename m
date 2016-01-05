From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: ANSI X9.31 DRNG is not allowed in FIPS 140-2
Date: Tue, 05 Jan 2016 13:12:21 +0100
Message-ID: <2027518.YhRjo0CQ2K@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:41378 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbcAEMMZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Jan 2016 07:12:25 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As per update of the FIPS 140-2 Annex C supported by SP800-131A, the
ANSI X9.31 DRNG is not an allowed cipher in FIPS mode any more.

CC: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/testmgr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ae8c57fd..5c0963d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2081,7 +2081,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "ansi_cprng",
 		.test = alg_test_cprng,
-		.fips_allowed = 1,
 		.suite = {
 			.cprng = {
 				.vecs = ansi_cprng_aes_tv_template,
-- 
2.5.0
