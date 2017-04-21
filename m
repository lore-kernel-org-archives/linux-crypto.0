From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] crypto: Allow ecb(cipher_null) in FIPS mode
Date: Fri, 21 Apr 2017 13:03:06 +0200
Message-ID: <20170421110306.3343-1-gmazyland@gmail.com>
Cc: Milan Broz <gmazyland@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35707 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1037893AbdDULDP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 07:03:15 -0400
Received: by mail-wm0-f68.google.com with SMTP id d79so4203471wmi.2
        for <linux-crypto@vger.kernel.org>; Fri, 21 Apr 2017 04:03:15 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The cipher_null is not a real cipher, FIPS mode should not restrict its use.

It is used for several tests (for example in cryptsetup testsuite) and also
temporarily for reencryption of not yet encrypted device in cryptsetup-reencrypt tool.

Problem is easily reproducible with
  cryptsetup benchmark -c null

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 crypto/testmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f9c378af3907..5075e4d982ee 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2875,6 +2875,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "ecb(cipher_null)",
 		.test = alg_test_null,
+		.fips_allowed = 1,
 	}, {
 		.alg = "ecb(des)",
 		.test = alg_test_skcipher,
-- 
2.11.0
