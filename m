From: Marcus Meissner <meissner@suse.de>
Subject: [PATCH] crypto: fips: allow more ipsec related methods
Date: Tue,  9 Feb 2016 10:32:37 +0100
Message-ID: <1455010357-1295-1-git-send-email-meissner@suse.de>
Cc: Marcus Meissner <meissner@suse.de>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbcBIJcm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2016 04:32:42 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

IPSEC for aes-ctr requests:

	authenc(digest_null,rfc3686(ctr(aes)))

which can be used in FIPS mode.

rfc3686(ctr(aes)) is already allowed for FIPS usage.

I also allowed "digest_null" for FIPS usage.

Signed-off-by: Marcus Meissner <meissner@suse.de>
---
 crypto/testmgr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 190a290..6ad8ba2 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2089,6 +2089,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "authenc(digest_null,rfc3686(ctr(aes)))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "authenc(hmac(md5),ecb(cipher_null))",
 		.test = alg_test_aead,
 		.suite = {
@@ -2768,6 +2772,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "digest_null",
 		.test = alg_test_null,
+		.fips_allowed = 1,
 	}, {
 		.alg = "drbg_nopr_ctr_aes128",
 		.test = alg_test_drbg,
-- 
2.1.4
