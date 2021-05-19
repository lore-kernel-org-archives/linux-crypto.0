Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E53C433ED
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 06:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92A4D61355
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 06:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234889AbhESGEK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 May 2021 02:04:10 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3418 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbhESGEJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 May 2021 02:04:09 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FlMf95p6SzCt6b;
        Wed, 19 May 2021 14:00:01 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 14:02:48 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 14:02:47 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: remove leading spaces before tabs
Date:   Wed, 19 May 2021 13:59:44 +0800
Message-ID: <1621403984-40037-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There are a few leading spaces before tabs and remove it by running the
following commard:

	$ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'

At the same time, fix two warning by running checkpatch.pl:
	WARNING: suspect code indent for conditional statements (16, 16)
	WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 crypto/khazad.c |  2 +-
 crypto/wp512.c  | 40 +++++++++++++++++++---------------------
 2 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/crypto/khazad.c b/crypto/khazad.c
index 14ca7f1..f193399 100644
--- a/crypto/khazad.c
+++ b/crypto/khazad.c
@@ -819,7 +819,7 @@ static void khazad_crypt(const u64 roundKey[KHAZAD_ROUNDS + 1],
 			T6[(int)(state >>  8) & 0xff] ^
 			T7[(int)(state      ) & 0xff] ^
 			roundKey[r];
-    	}
+	}
 
 	state = (T0[(int)(state >> 56)       ] & 0xff00000000000000ULL) ^
 		(T1[(int)(state >> 48) & 0xff] & 0x00ff000000000000ULL) ^
diff --git a/crypto/wp512.c b/crypto/wp512.c
index feadc13..bf79fbb 100644
--- a/crypto/wp512.c
+++ b/crypto/wp512.c
@@ -1066,33 +1066,31 @@ static int wp512_final(struct shash_desc *desc, u8 *out)
 {
 	struct wp512_ctx *wctx = shash_desc_ctx(desc);
 	int i;
-   	u8 *buffer      = wctx->buffer;
-   	u8 *bitLength   = wctx->bitLength;
-   	int bufferBits  = wctx->bufferBits;
-   	int bufferPos   = wctx->bufferPos;
+	u8 *buffer      = wctx->buffer;
+	u8 *bitLength   = wctx->bitLength;
+	int bufferBits  = wctx->bufferBits;
+	int bufferPos   = wctx->bufferPos;
 	__be64 *digest  = (__be64 *)out;
 
-   	buffer[bufferPos] |= 0x80U >> (bufferBits & 7);
-   	bufferPos++;
-   	if (bufferPos > WP512_BLOCK_SIZE - WP512_LENGTHBYTES) {
-   		if (bufferPos < WP512_BLOCK_SIZE) {
-	   	memset(&buffer[bufferPos], 0, WP512_BLOCK_SIZE - bufferPos);
-   		}
-   		wp512_process_buffer(wctx);
-   		bufferPos = 0;
-   	}
-   	if (bufferPos < WP512_BLOCK_SIZE - WP512_LENGTHBYTES) {
-   		memset(&buffer[bufferPos], 0,
+	buffer[bufferPos] |= 0x80U >> (bufferBits & 7);
+	bufferPos++;
+	if (bufferPos > WP512_BLOCK_SIZE - WP512_LENGTHBYTES) {
+		if (bufferPos < WP512_BLOCK_SIZE)
+			memset(&buffer[bufferPos], 0, WP512_BLOCK_SIZE - bufferPos);
+		wp512_process_buffer(wctx);
+		bufferPos = 0;
+	}
+	if (bufferPos < WP512_BLOCK_SIZE - WP512_LENGTHBYTES)
+		memset(&buffer[bufferPos], 0,
 			  (WP512_BLOCK_SIZE - WP512_LENGTHBYTES) - bufferPos);
-   	}
-   	bufferPos = WP512_BLOCK_SIZE - WP512_LENGTHBYTES;
-   	memcpy(&buffer[WP512_BLOCK_SIZE - WP512_LENGTHBYTES],
+	bufferPos = WP512_BLOCK_SIZE - WP512_LENGTHBYTES;
+	memcpy(&buffer[WP512_BLOCK_SIZE - WP512_LENGTHBYTES],
 		   bitLength, WP512_LENGTHBYTES);
-   	wp512_process_buffer(wctx);
+	wp512_process_buffer(wctx);
 	for (i = 0; i < WP512_DIGEST_SIZE/8; i++)
 		digest[i] = cpu_to_be64(wctx->hash[i]);
-   	wctx->bufferBits   = bufferBits;
-   	wctx->bufferPos    = bufferPos;
+	wctx->bufferBits   = bufferBits;
+	wctx->bufferPos    = bufferPos;
 
 	return 0;
 }
-- 
2.8.1

