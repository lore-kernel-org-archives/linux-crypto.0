Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E59C433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Nov 2021 15:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238146AbhKUPNn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Nov 2021 10:13:43 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.166]:30301 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238079AbhKUPNn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Nov 2021 10:13:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637507435;
    s=strato-dkim-0002; d=chronox.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=wzpWfad9MQHD8XWgAPCkdf/w3QawLnqSHewaE+fuUVU=;
    b=Rns2aOxw+nlfoYRFu3YirwHvX9/rz/46iJfKaNhYpFGyH3mmb9iaNkALVrhZPh/17U
    NwZB9P9CGjzpLpUcHZn8YFM9hDiiv+QHOJiB7AcnpomlGxoCVDsD41xm63wCoSLYL7si
    YsZGp1XiziYLeO8lP3Tbufakck76hVG59ekC2oY5MvuRGYq//IVEff0iyDA2Ge07a1DG
    VkTIDczHO/yWE3AOwIkUEzg9vBsJfUsMceJrghPjN6r6uZkmgOZc73ITnkkEtrolUymQ
    CN4Oxt8VEBozTvyIlgl/o6wKj9DpbeIDtSU8/aUtmiSSwQ/rWNzgKtPAXk07GxXLLXpm
    DvuA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbJvSfE+K2"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.34.5 DYNA|AUTH)
    with ESMTPSA id U02dfbxALFAY3KB
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 21 Nov 2021 16:10:34 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: TDES - disallow in FIPS mode
Date:   Sun, 21 Nov 2021 16:10:33 +0100
Message-ID: <5322078.rdbgypaU67@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Dec 31 2023 NIST sunsets TDES for FIPS use. To prevent FIPS
validations to be completed in the future to be affected by the TDES
sunsetting, disallow TDES already now. Otherwise a FIPS validation would
need to be "touched again" end 2023 to handle TDES accordingly.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/testmgr.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 58eee8eab4bf..5831d4bbc64f 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4193,7 +4193,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha1),cbc(des3_ede))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = __VECS(hmac_sha1_des3_ede_cbc_tv_temp)
 		}
@@ -4220,7 +4219,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha224),cbc(des3_ede))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = __VECS(hmac_sha224_des3_ede_cbc_tv_temp)
 		}
@@ -4240,7 +4238,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha256),cbc(des3_ede))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = __VECS(hmac_sha256_des3_ede_cbc_tv_temp)
 		}
@@ -4261,7 +4258,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha384),cbc(des3_ede))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = __VECS(hmac_sha384_des3_ede_cbc_tv_temp)
 		}
@@ -4289,7 +4285,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha512),cbc(des3_ede))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = __VECS(hmac_sha512_des3_ede_cbc_tv_temp)
 		}
@@ -4399,7 +4394,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "cbc(des3_ede)",
 		.test = alg_test_skcipher,
-		.fips_allowed = 1,
 		.suite = {
 			.cipher = __VECS(des3_ede_cbc_tv_template)
 		},
@@ -4505,7 +4499,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "cmac(des3_ede)",
-		.fips_allowed = 1,
 		.test = alg_test_hash,
 		.suite = {
 			.hash = __VECS(des3_ede_cmac64_tv_template)
@@ -4580,7 +4573,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "ctr(des3_ede)",
 		.test = alg_test_skcipher,
-		.fips_allowed = 1,
 		.suite = {
 			.cipher = __VECS(des3_ede_ctr_tv_template)
 		}
@@ -4846,7 +4838,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "ecb(des3_ede)",
 		.test = alg_test_skcipher,
-		.fips_allowed = 1,
 		.suite = {
 			.cipher = __VECS(des3_ede_tv_template)
 		}
-- 
2.33.1




