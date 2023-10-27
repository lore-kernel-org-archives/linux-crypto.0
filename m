Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FEBC25B48
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Oct 2023 19:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbjJ0TwU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Oct 2023 15:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjJ0TwT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2023 15:52:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A047EAB
        for <linux-crypto@vger.kernel.org>; Fri, 27 Oct 2023 12:52:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB57C433C7;
        Fri, 27 Oct 2023 19:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698436337;
        bh=8yKr+tz4ztxLGa3IXX/YMCWKdEGkvWudWR15X5M/ae4=;
        h=From:To:Cc:Subject:Date:From;
        b=r2ncYPeDxwSfKLZiWiAf8s6ov9zsViArBuTJwrCeaJ9b9gQr+m1Anhme+XM605A1P
         ele39AbZjiXQ2uHdmuarEgE6KNQqtv0XXkONMumN0ykLwaTFBUj24aO5F2wKXKq2KU
         XdrGbOwR6IuK/ymcQWhvwhJfbnnkzrVj2618a7+fUyjlY+Ad6G6BAf4YnnLM3oTjlL
         eIYCdPSabZyRmmjpzpYY6KPPpkap/QCvI/16vqio0LbxwLlaPfAFHJ25sZzoRT5kEH
         sMF8nddhDc+EYxAa8K32MJCFrBkwaAPNDLRY6aV8PeMY1uHtCFiv14x2K/+rXZXFST
         tSorvIL3Qadyg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Subject: [PATCH] crypto: testmgr - move pkcs1pad(rsa,sha3-*) to correct place
Date:   Fri, 27 Oct 2023 12:52:06 -0700
Message-ID: <20231027195206.46643-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

alg_test_descs[] needs to be in sorted order, since it is used for
binary search.  This fixes the following boot-time warning:

    testmgr: alg_test_descs entries in wrong order: 'pkcs1pad(rsa,sha512)' before 'pkcs1pad(rsa,sha3-256)'

Fixes: ee62afb9d02d ("crypto: rsa-pkcs1pad - Add FIPS 202 SHA-3 support")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 1dc93bf608d4..15c7a3011269 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5450,37 +5450,37 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
 		.alg = "pkcs1pad(rsa,sha256)",
 		.test = alg_test_akcipher,
 		.fips_allowed = 1,
 		.suite = {
 			.akcipher = __VECS(pkcs1pad_rsa_tv_template)
 		}
 	}, {
-		.alg = "pkcs1pad(rsa,sha384)",
+		.alg = "pkcs1pad(rsa,sha3-256)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
-		.alg = "pkcs1pad(rsa,sha512)",
+		.alg = "pkcs1pad(rsa,sha3-384)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
-		.alg = "pkcs1pad(rsa,sha3-256)",
+		.alg = "pkcs1pad(rsa,sha3-512)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
-		.alg = "pkcs1pad(rsa,sha3-384)",
+		.alg = "pkcs1pad(rsa,sha384)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
-		.alg = "pkcs1pad(rsa,sha3-512)",
+		.alg = "pkcs1pad(rsa,sha512)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
 		.alg = "poly1305",
 		.test = alg_test_hash,
 		.suite = {
 			.hash = __VECS(poly1305_tv_template)
 		}
 	}, {
 		.alg = "polyval",

base-commit: f2b88bab69c86d4dab2bfd25a0e741d7df411f7a
-- 
2.42.0

