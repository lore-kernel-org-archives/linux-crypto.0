Return-Path: <SRS0=ZwPv=5N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=DATE_IN_PAST_96_XX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8717C2D0E5
	for <linux-crypto@archiver.kernel.org>; Sat, 28 Mar 2020 16:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98E48206F6
	for <linux-crypto@archiver.kernel.org>; Sat, 28 Mar 2020 16:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbgC1QnX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Mar 2020 12:43:23 -0400
Received: from mx.sdf.org ([205.166.94.20]:50208 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727401AbgC1QnU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Mar 2020 12:43:20 -0400
Received: from sdf.org (IDENT:lkml@sdf.lonestar.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 02SGhC9q026662
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Sat, 28 Mar 2020 16:43:12 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 02SGhCt7025631;
        Sat, 28 Mar 2020 16:43:12 GMT
Message-Id: <202003281643.02SGhCt7025631@sdf.org>
From:   George Spelvin <lkml@sdf.org>
Date:   Fri, 29 Nov 2019 15:24:22 -0500
Subject: [RFC PATCH v1 14/50] crypto/testmgr.c: use prandom_u32_max() &
 prandom_bytes()
To:     linux-kernel@vger.kernel.org, lkml@sdf.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

...in a couple of places where they're appropriate.

There are many other places where successive code blocks make calls
like prandom_u32() % 2 followed immediately by prandom_u32() % 4.
This could be easily written to use three bits of one call, but
at some cost in clarity and obvious-correctness, which is more
important that efficiency in self-test code.

Signed-off-by: George Spelvin <lkml@sdf.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
---
 crypto/testmgr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index e8f21f7348a48..bc9252768bdba 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -770,7 +770,7 @@ static void mutate_buffer(u8 *buf, size_t count)
 	if (prandom_u32() % 4 == 0) {
 		num_flips = min_t(size_t, 1 << (prandom_u32() % 8), count * 8);
 		for (i = 0; i < num_flips; i++) {
-			pos = prandom_u32() % (count * 8);
+			pos = prandom_u32_max(count * 8);
 			buf[pos / 8] ^= 1 << (pos % 8);
 		}
 	}
@@ -821,8 +821,7 @@ static void generate_random_bytes(u8 *buf, size_t count)
 		break;
 	default:
 		/* Fully random bytes */
-		for (i = 0; i < count; i++)
-			buf[i] = (u8)prandom_u32();
+		prandom_bytes(buf, count);
 	}
 }
 
-- 
2.26.0

