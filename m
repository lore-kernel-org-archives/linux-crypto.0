From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v2] crypto: testmgr - don't print info about missing test
 for gcm-aes-aesni
Date: Wed, 24 Jun 2015 09:01:30 -0700
Message-ID: <20150624160130.480.47360.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41468 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbbFXQCM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Jun 2015 12:02:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Don't print info about missing test for the internal
helper __driver-gcm-aes-aesni

changes in v2:
 - marked test as fips allowed

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/testmgr.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 975e1ea..d0a42bd 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2056,6 +2056,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "__driver-ecb-twofish-avx",
 		.test = alg_test_null,
 	}, {
+		.alg = "__driver-gcm-aes-aesni",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "__ghash-pclmulqdqni",
 		.test = alg_test_null,
 		.fips_allowed = 1,
