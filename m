Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD85C31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 08:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AF4F20C01
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 08:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405713AbfHIItf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 04:49:35 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39596 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405807AbfHIItf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 04:49:35 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E7A25DE97F0B4DB87FFE;
        Fri,  9 Aug 2019 16:49:33 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Fri, 9 Aug 2019
 16:49:25 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] crypto: streebog - remove two unused variables
Date:   Fri, 9 Aug 2019 16:49:05 +0800
Message-ID: <20190809084905.69444-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

crypto/streebog_generic.c:162:17: warning:
 Pi defined but not used [-Wunused-const-variable=]
crypto/streebog_generic.c:151:17: warning:
 Tau defined but not used [-Wunused-const-variable=]

They are never used, so can be removed.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 crypto/streebog_generic.c | 46 ----------------------------------------------
 1 file changed, 46 deletions(-)

diff --git a/crypto/streebog_generic.c b/crypto/streebog_generic.c
index 63663c3..dc625ff 100644
--- a/crypto/streebog_generic.c
+++ b/crypto/streebog_generic.c
@@ -148,52 +148,6 @@ static const struct streebog_uint512 C[12] = {
 	 } }
 };
 
-static const u8 Tau[64] = {
-	0,   8,  16,  24,  32,  40,  48,  56,
-	1,   9,  17,  25,  33,  41,  49,  57,
-	2,  10,  18,  26,  34,  42,  50,  58,
-	3,  11,  19,  27,  35,  43,  51,  59,
-	4,  12,  20,  28,  36,  44,  52,  60,
-	5,  13,  21,  29,  37,  45,  53,  61,
-	6,  14,  22,  30,  38,  46,  54,  62,
-	7,  15,  23,  31,  39,  47,  55,  63
-};
-
-static const u8 Pi[256] = {
-	252, 238, 221,  17, 207, 110,  49,  22,
-	251, 196, 250, 218,  35, 197,   4,  77,
-	233, 119, 240, 219, 147,  46, 153, 186,
-	 23,  54, 241, 187,  20, 205,  95, 193,
-	249,  24, 101,  90, 226,  92, 239,  33,
-	129,  28,  60,  66, 139,   1, 142,  79,
-	  5, 132,   2, 174, 227, 106, 143, 160,
-	  6,  11, 237, 152, 127, 212, 211,  31,
-	235,  52,  44,  81, 234, 200,  72, 171,
-	242,  42, 104, 162, 253,  58, 206, 204,
-	181, 112,  14,  86,   8,  12, 118,  18,
-	191, 114,  19,  71, 156, 183,  93, 135,
-	 21, 161, 150,  41,  16, 123, 154, 199,
-	243, 145, 120, 111, 157, 158, 178, 177,
-	 50, 117,  25,  61, 255,  53, 138, 126,
-	109,  84, 198, 128, 195, 189,  13,  87,
-	223, 245,  36, 169,  62, 168,  67, 201,
-	215, 121, 214, 246, 124,  34, 185,   3,
-	224,  15, 236, 222, 122, 148, 176, 188,
-	220, 232,  40,  80,  78,  51,  10,  74,
-	167, 151,  96, 115,  30,   0,  98,  68,
-	 26, 184,  56, 130, 100, 159,  38,  65,
-	173,  69,  70, 146,  39,  94,  85,  47,
-	140, 163, 165, 125, 105, 213, 149,  59,
-	  7,  88, 179,  64, 134, 172,  29, 247,
-	 48,  55, 107, 228, 136, 217, 231, 137,
-	225,  27, 131,  73,  76,  63, 248, 254,
-	141,  83, 170, 144, 202, 216, 133,  97,
-	 32, 113, 103, 164,  45,  43,   9,  91,
-	203, 155,  37, 208, 190, 229, 108,  82,
-	 89, 166, 116, 210, 230, 244, 180, 192,
-	209, 102, 175, 194,  57,  75,  99, 182
-};
-
 static const unsigned long long Ax[8][256] = {
 	{
 	0xd01f715b5c7ef8e6ULL, 0x16fa240980778325ULL, 0xa8a42e857ee049c8ULL,
-- 
2.7.4


