From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH 2/3] crypto: testmgr - Add missing tests for internal sha256-mb implementation
Date: Wed, 26 Oct 2016 15:04:44 -0200
Message-ID: <1477501485-18371-3-git-send-email-marcelo.cerri@canonical.com>
References: <1477501485-18371-1-git-send-email-marcelo.cerri@canonical.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        Marcelo Cerri <marcelo.cerri@canonical.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:33676 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756595AbcJZRFj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2016 13:05:39 -0400
Received: by mail-ua0-f180.google.com with SMTP id 6so7570519uat.0
        for <linux-crypto@vger.kernel.org>; Wed, 26 Oct 2016 10:05:39 -0700 (PDT)
In-Reply-To: <1477501485-18371-1-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add null tests for the internal algorithm to avoid errors when running
in FIPS mode.

Signed-off-by: Marcelo Cerri <marcelo.cerri@canonical.com>
---
 crypto/testmgr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index d999373..58f903d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2309,6 +2309,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
+		.alg = "__intel_sha256-mb",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "ansi_cprng",
 		.test = alg_test_cprng,
 		.suite = {
@@ -3758,6 +3762,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
+		.alg = "mcryptd(__intel_sha256-mb)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "md4",
 		.test = alg_test_hash,
 		.suite = {
-- 
2.7.4
