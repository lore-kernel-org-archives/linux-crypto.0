Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99874C4167B
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Dec 2022 17:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238064AbiLNRUQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Dec 2022 12:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237720AbiLNRUL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Dec 2022 12:20:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BCE55B9
        for <linux-crypto@vger.kernel.org>; Wed, 14 Dec 2022 09:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE0C561B32
        for <linux-crypto@vger.kernel.org>; Wed, 14 Dec 2022 17:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D34BC433F2;
        Wed, 14 Dec 2022 17:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671038409;
        bh=so7vE7Er85eybGXgDTCj8RNjfkBSc2+LLSBsEGz/lEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehTPbxJtwUZ5KhxiNTGrGTisTxTldPaWBAARcueDCd6Kc69Tr2R2ECyToLCINxpES
         rodCwxIkRtXzrWlpsNCVmStNixEbE7TXNY5uMIDbFBup349QVHMxTnEuORQZAUsxCH
         5yqqqnFaK0rcjA4Ep2VCTHw+0LEEDp6KE7fRdUVBOqBcK2Oy2xHNbd1+YBTiQwNTYP
         hxX8eLrtAH8OGgE3qwR6+ibXPEdm5rzaS6JyxltJAPlal7woEuof8ZhqrJMt4oHnsx
         Kbacj9DF2lwhs7b5cnsIexAn9Yvo3VdQV/QmG9nPULA7Hx0kQOfAR3Wzfljr0dGFQn
         W1HXOQ7YzIEVg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 3/4] crypto: tcrypt - include larger key sizes in RFC4106 benchmark
Date:   Wed, 14 Dec 2022 18:19:56 +0100
Message-Id: <20221214171957.2833419-4-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221214171957.2833419-1-ardb@kernel.org>
References: <20221214171957.2833419-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2274; i=ardb@kernel.org; h=from:subject; bh=so7vE7Er85eybGXgDTCj8RNjfkBSc2+LLSBsEGz/lEM=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjmgW7PtpznfCDMZUwlrWuzE59njUy7ApXKvwFg9Ds oKMH9f6JAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY5oFuwAKCRDDTyI5ktmPJHQHDA CnPqxl9H69/LfnZIzbgVHqFFkSgcGVc4/83kjrnHD7NtJhESrOQo3PVFvkQi5ELAZipe302aRXexxu 8YC0IzL1HAO0t6qdLRk2F4kZZHjs1XWTNAiCECHIJo9LGAJ0W9S2B/Wu/XddLtkfVA8gvKHfxtZ0Y8 TpnbcClw5Bza4KnZUNsSPvR+1Uz4DTJdntCLYTshJatVUJ9EzCjIEytKGt0Qdo19MT/blg/J7Cab5Y f+Us2beEXPs9QkgLWCpJyANW+1p/Mc24nlEH4X0FtYgXTfVR2v2pw7o5jcXWenSQvZIejIyrXAI3NZ gGe9t134+fYMFCFWg9xIwViLs1pAsjdRidTd1xnrWeQ/BSZGJXmmwZn+S9lLreutNS290gnBismoO7 5lr4hHJLqUIROgl8XNHK2hw1tXYE6Z/fYB0j3cyKhEiLuEL9fWMXM0L0AqMNPxW80Rr2GX8cRE2PgG 58riYYV0NK2HaEQTnPCQZfc6EIQe4JVo7hWaunOCVwt0M=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

RFC4106 wraps AES in GCM mode, and can be used with larger key sizes
than 128/160 bits, just like AES itself. So add these to the tcrypt
recipe so they will be benchmarked as well.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/tcrypt.c | 8 ++++----
 crypto/tcrypt.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index a82679b576bb4381..1e4c7699801a6ffa 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2045,11 +2045,11 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 
 	case 211:
 		test_aead_speed("rfc4106(gcm(aes))", ENCRYPT, sec,
-				NULL, 0, 16, 16, aead_speed_template_20);
+				NULL, 0, 16, 16, aead_speed_template_20_28_36);
 		test_aead_speed("gcm(aes)", ENCRYPT, sec,
 				NULL, 0, 16, 8, speed_template_16_24_32);
 		test_aead_speed("rfc4106(gcm(aes))", DECRYPT, sec,
-				NULL, 0, 16, 16, aead_speed_template_20);
+				NULL, 0, 16, 16, aead_speed_template_20_28_36);
 		test_aead_speed("gcm(aes)", DECRYPT, sec,
 				NULL, 0, 16, 8, speed_template_16_24_32);
 		break;
@@ -2075,11 +2075,11 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 
 	case 215:
 		test_mb_aead_speed("rfc4106(gcm(aes))", ENCRYPT, sec, NULL,
-				   0, 16, 16, aead_speed_template_20, num_mb);
+				   0, 16, 16, aead_speed_template_20_28_36, num_mb);
 		test_mb_aead_speed("gcm(aes)", ENCRYPT, sec, NULL, 0, 16, 8,
 				   speed_template_16_24_32, num_mb);
 		test_mb_aead_speed("rfc4106(gcm(aes))", DECRYPT, sec, NULL,
-				   0, 16, 16, aead_speed_template_20, num_mb);
+				   0, 16, 16, aead_speed_template_20_28_36, num_mb);
 		test_mb_aead_speed("gcm(aes)", DECRYPT, sec, NULL, 0, 16, 8,
 				   speed_template_16_24_32, num_mb);
 		break;
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index 9f654677172afba7..96c843a24607105e 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -62,7 +62,7 @@ static u8 speed_template_32[] = {32, 0};
  * AEAD speed tests
  */
 static u8 aead_speed_template_19[] = {19, 0};
-static u8 aead_speed_template_20[] = {20, 0};
+static u8 aead_speed_template_20_28_36[] = {20, 28, 36, 0};
 static u8 aead_speed_template_36[] = {36, 0};
 
 /*
-- 
2.35.1

