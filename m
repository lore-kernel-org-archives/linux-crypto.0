Return-Path: <SRS0=A9EK=CM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20340C433E9
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Sep 2020 14:51:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7A7820716
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Sep 2020 14:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgICOvu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Sep 2020 10:51:50 -0400
Received: from jptosegrel01.sonyericsson.com ([124.215.201.71]:11712 "EHLO
        JPTOSEGREL01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729210AbgICOPQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Sep 2020 10:15:16 -0400
From:   Peter Enderborg <peter.enderborg@sony.com>
To:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
CC:     Peter Enderborg <peter.enderborg@sony.com>
Subject: [PATCH] crypto: Mark tfm buffer as non leak.
Date:   Thu, 3 Sep 2020 15:40:07 +0200
Message-ID: <20200903134007.2769-1-peter.enderborg@sony.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-SEG-SpamProfiler-Analysis: v=2.3 cv=FfdJO626 c=1 sm=1 tr=0 a=fZcToFWbXLKijqHhjJ02CA==:117 a=reM5J-MqmosA:10 a=z6gsHLkEAAAA:8 a=L8t1L5anSuFvw26KRygA:9 a=d-OLMTCWyvARjPbQ-enb:22
X-SEG-SpamProfiler-Score: 0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When running kmemleak on this I got a lot of

unreferenced object 0xfffffff942d4ec00 (size 1024):
  comm "init", pid 1, jiffies 4294893619 (age 17475.864s)
  hex dump (first 32 bytes):
    38 1d cf bd 9e ff ff ff b8 37 8b bd 9e ff ff ff  8........7......
    78 38 8b bd 9e ff ff ff 10 00 00 00 00 00 00 00  x8..............
  backtrace:
    [<00000000c3c55a80>] __kmalloc+0x2cc/0x3b0
    [<00000000c599b091>] crypto_create_tfm+0x38/0xf0
    [<00000000d4516e51>] crypto_spawn_tfm2+0x58/0xa0
    [<000000001bab58aa>] cryptd_skcipher_init_tfm+0x1c/0x40
    [<0000000006748df3>] crypto_skcipher_init_tfm+0x158/0x1e0
    [<0000000017f3270c>] crypto_create_tfm+0x54/0xf0
    [<000000006af1de62>] crypto_alloc_tfm+0x88/0x198
    [<000000000d8e8c03>] crypto_alloc_skcipher+0x1c/0x28
    [<0000000085448a2a>] cryptd_alloc_skcipher+0x5c/0xb0
    [<000000003c48c083>] simd_skcipher_init+0x24/0x68
    [<0000000006748df3>] crypto_skcipher_init_tfm+0x158/0x1e0
    [<0000000017f3270c>] crypto_create_tfm+0x54/0xf0
    [<00000000d4516e51>] crypto_spawn_tfm2+0x58/0xa0
    [<00000000b5344705>] crypto_cts_init_tfm+0x1c/0x68
    [<0000000006748df3>] crypto_skcipher_init_tfm+0x158/0x1e0
    [<0000000017f3270c>] crypto_create_tfm+0x54/0xf0

This is caused by tfm = (struct crypto_tfm *)(mem + tfmsize);
that is keept instead of the allocated buffer in mem.
Reference counting is done on alg.

Signed-off-by: Peter Enderborg <peter.enderborg@sony.com>
---
 crypto/api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/api.c b/crypto/api.c
index ed08cbd5b9d3..1a9cb6852a56 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -21,6 +21,7 @@
 #include <linux/string.h>
 #include <linux/completion.h>
 #include "internal.h"
+#include <linux/kmemleak.h>
 
 LIST_HEAD(crypto_alg_list);
 EXPORT_SYMBOL_GPL(crypto_alg_list);
@@ -460,7 +461,7 @@ void *crypto_create_tfm_node(struct crypto_alg *alg,
 
 	if (!tfm->exit && alg->cra_init && (err = alg->cra_init(tfm)))
 		goto cra_init_failed;
-
+	kmemleak_not_leak(mem);
 	goto out;
 
 cra_init_failed:
-- 
2.17.1

