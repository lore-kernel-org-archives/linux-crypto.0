Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8ED5C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 02:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6657161A43
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 02:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhCZCVu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Mar 2021 22:21:50 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:57676 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231643AbhCZCVa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Mar 2021 22:21:30 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UTKgvox_1616725288;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UTKgvox_1616725288)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 26 Mar 2021 10:21:28 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Eric Biggers <ebiggers@google.com>,
        Mimi Zohar <zohar@linux.ibm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH] crypto: sm3 - use the more precise type u32 instead of unsigned int
Date:   Fri, 26 Mar 2021 10:21:28 +0800
Message-Id: <20210326022128.71727-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In the process of calculating the hash, use the more accurate type
'u32' instead of the original 'unsigned int' to avoid ambiguity.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 crypto/sm3_generic.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/sm3_generic.c b/crypto/sm3_generic.c
index 193c4584bd00..562e96f92f64 100644
--- a/crypto/sm3_generic.c
+++ b/crypto/sm3_generic.c
@@ -36,17 +36,17 @@ static inline u32 p1(u32 x)
 	return x ^ rol32(x, 15) ^ rol32(x, 23);
 }
 
-static inline u32 ff(unsigned int n, u32 a, u32 b, u32 c)
+static inline u32 ff(u32 n, u32 a, u32 b, u32 c)
 {
 	return (n < 16) ? (a ^ b ^ c) : ((a & b) | (a & c) | (b & c));
 }
 
-static inline u32 gg(unsigned int n, u32 e, u32 f, u32 g)
+static inline u32 gg(u32 n, u32 e, u32 f, u32 g)
 {
 	return (n < 16) ? (e ^ f ^ g) : ((e & f) | ((~e) & g));
 }
 
-static inline u32 t(unsigned int n)
+static inline u32 t(u32 n)
 {
 	return (n < 16) ? SM3_T1 : SM3_T2;
 }
@@ -54,7 +54,7 @@ static inline u32 t(unsigned int n)
 static void sm3_expand(u32 *t, u32 *w, u32 *wt)
 {
 	int i;
-	unsigned int tmp;
+	u32 tmp;
 
 	/* load the input */
 	for (i = 0; i <= 15; i++)
@@ -123,8 +123,8 @@ static void sm3_compress(u32 *w, u32 *wt, u32 *m)
 
 static void sm3_transform(struct sm3_state *sst, u8 const *src)
 {
-	unsigned int w[68];
-	unsigned int wt[64];
+	u32 w[68];
+	u32 wt[64];
 
 	sm3_expand((u32 *)src, w, wt);
 	sm3_compress(w, wt, sst->state);
-- 
2.19.1.3.ge56e4f7

