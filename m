Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8241CC433ED
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 11:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D752610A1
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 11:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241591AbhETL1g (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 May 2021 07:27:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241797AbhETLZa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 May 2021 07:25:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A93CA6024A;
        Thu, 20 May 2021 10:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621507215;
        bh=DaMF7xS50T/cErXF4F9F0/PzUrKl+bhv7rTC35uT2SY=;
        h=From:To:Cc:Subject:Date:From;
        b=Fc2INZ9kn2Jzzr373aEu4ur0CSHJdlkTE31jyN0ccgLr/wR8+fCSCbvaAjVUG67xK
         SmrDvCyPeup51JDBGRzkdOFV2WqHzPU19fmQ+tSW1udeB/VFm1LHp8W7O2WE859ZwA
         s0AwG8Srp4W9h1kC/Xa/+4kdIkmnCedPgKleERESizNC3fTi984kmNo433dDCVv3H3
         N8Ok/HXuICZI+IwKjlo7NEsIByUmFiFjL0MQfiaGXqN2nXDPtLHbdJrRT1Iem+KokB
         yfNVRqkFkWOh2drP99cY/I03Z6hUBp1sQYkRnQxB3+YChZHogsF2S7ye7OIv9Gp6TO
         OfGMl7xzXJhzA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        pbrobinson@gmail.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: tcrypt - enable tests for xxhash and blake2
Date:   Thu, 20 May 2021 12:40:00 +0200
Message-Id: <20210520104000.47696-1-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fill some of the recently freed up slots in tcrypt with xxhash64 and
blake2b/blake2s, so we can easily benchmark their kernel implementations
from user space.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/tcrypt.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 6b7c158dc508..f8d06da78e4f 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1847,10 +1847,22 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		ret += tcrypt_test("cts(cbc(aes))");
 		break;
 
+        case 39:
+		ret += tcrypt_test("xxhash64");
+		break;
+
         case 40:
 		ret += tcrypt_test("rmd160");
 		break;
 
+	case 41:
+		ret += tcrypt_test("blake2s-256");
+		break;
+
+	case 42:
+		ret += tcrypt_test("blake2b-512");
+		break;
+
 	case 43:
 		ret += tcrypt_test("ecb(seed)");
 		break;
@@ -2356,10 +2368,22 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		test_hash_speed("sha224", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
+	case 314:
+		test_hash_speed("xxhash64", sec, generic_hash_speed_template);
+		if (mode > 300 && mode < 400) break;
+		fallthrough;
 	case 315:
 		test_hash_speed("rmd160", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
+	case 316:
+		test_hash_speed("blake2s-256", sec, generic_hash_speed_template);
+		if (mode > 300 && mode < 400) break;
+		fallthrough;
+	case 317:
+		test_hash_speed("blake2b-512", sec, generic_hash_speed_template);
+		if (mode > 300 && mode < 400) break;
+		fallthrough;
 	case 318:
 		klen = 16;
 		test_hash_speed("ghash", sec, generic_hash_speed_template);
@@ -2456,10 +2480,22 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		test_ahash_speed("sha224", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
+	case 414:
+		test_ahash_speed("xxhash64", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+		fallthrough;
 	case 415:
 		test_ahash_speed("rmd160", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
+	case 416:
+		test_ahash_speed("blake2s-256", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+		fallthrough;
+	case 417:
+		test_ahash_speed("blake2b-512", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+		fallthrough;
 	case 418:
 		test_ahash_speed("sha3-224", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
-- 
2.20.1

