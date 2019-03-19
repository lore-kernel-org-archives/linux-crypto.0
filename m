Return-Path: <SRS0=OEQJ=RW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA91C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Mar 2019 13:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4983F2085A
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Mar 2019 13:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfCSN4O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Mar 2019 09:56:14 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34338 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726612AbfCSN4N (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Mar 2019 09:56:13 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BF1103A20C294E252168;
        Tue, 19 Mar 2019 21:56:08 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.408.0; Tue, 19 Mar 2019
 21:56:01 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <rrichter@cavium.com>, <jglauber@cavium.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] crypto: zip - Make some functions static
Date:   Tue, 19 Mar 2019 21:55:07 +0800
Message-ID: <20190319135507.18764-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fix following sparse warnings:

drivers/crypto/cavium/zip/zip_crypto.c:72:5: warning: symbol 'zip_ctx_init' was not declared. Should it be static?
drivers/crypto/cavium/zip/zip_crypto.c:110:6: warning: symbol 'zip_ctx_exit' was not declared. Should it be static?
drivers/crypto/cavium/zip/zip_crypto.c:122:5: warning: symbol 'zip_compress' was not declared. Should it be static?
drivers/crypto/cavium/zip/zip_crypto.c:158:5: warning: symbol 'zip_decompress' was not declared. Should it be static?

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/cavium/zip/zip_crypto.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/cavium/zip/zip_crypto.c b/drivers/crypto/cavium/zip/zip_crypto.c
index b92b6e7..4985bc8 100644
--- a/drivers/crypto/cavium/zip/zip_crypto.c
+++ b/drivers/crypto/cavium/zip/zip_crypto.c
@@ -69,7 +69,7 @@ static void zip_static_init_zip_ops(struct zip_operation *zip_ops,
 	zip_ops->csum	      = 1; /* Adler checksum desired */
 }
 
-int zip_ctx_init(struct zip_kernel_ctx *zip_ctx, int lzs_flag)
+static int zip_ctx_init(struct zip_kernel_ctx *zip_ctx, int lzs_flag)
 {
 	struct zip_operation  *comp_ctx   = &zip_ctx->zip_comp;
 	struct zip_operation  *decomp_ctx = &zip_ctx->zip_decomp;
@@ -107,7 +107,7 @@ int zip_ctx_init(struct zip_kernel_ctx *zip_ctx, int lzs_flag)
 	return -ENOMEM;
 }
 
-void zip_ctx_exit(struct zip_kernel_ctx *zip_ctx)
+static void zip_ctx_exit(struct zip_kernel_ctx *zip_ctx)
 {
 	struct zip_operation  *comp_ctx   = &zip_ctx->zip_comp;
 	struct zip_operation  *dec_ctx = &zip_ctx->zip_decomp;
@@ -119,7 +119,7 @@ void zip_ctx_exit(struct zip_kernel_ctx *zip_ctx)
 	zip_data_buf_free(dec_ctx->output, MAX_OUTPUT_BUFFER_SIZE);
 }
 
-int zip_compress(const u8 *src, unsigned int slen,
+static int zip_compress(const u8 *src, unsigned int slen,
 		 u8 *dst, unsigned int *dlen,
 		 struct zip_kernel_ctx *zip_ctx)
 {
@@ -155,7 +155,7 @@ int zip_compress(const u8 *src, unsigned int slen,
 	return ret;
 }
 
-int zip_decompress(const u8 *src, unsigned int slen,
+static int zip_decompress(const u8 *src, unsigned int slen,
 		   u8 *dst, unsigned int *dlen,
 		   struct zip_kernel_ctx *zip_ctx)
 {
-- 
2.7.4


