Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF86C43381
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3EB620872
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554062766;
	bh=Jh8j4zjiReptQsFK+NxyfGkFFOLBP05AU5lo/XXKvZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=azXTlzcctZp6ebCxC3oLwvn17K6PdphK1mBaECnGkFws+GIHOd94+nKss1kpa4OwZ
	 w4sIa7IT3Y/1kldzOBV7cGvW/ELMqifB0WERm6kPgAjZMgnX3n2WT9nm82G6pyFFKI
	 920Gu/SZhjPUcVBaFDBGvWPyD8xrxMo34fHLdPKA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731467AbfCaUGD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 Mar 2019 16:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731444AbfCaUF7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Mar 2019 16:05:59 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4113C218A1;
        Sun, 31 Mar 2019 20:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554062758;
        bh=Jh8j4zjiReptQsFK+NxyfGkFFOLBP05AU5lo/XXKvZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBmSX47IFMjiFni5iBSksinOPjfrd8AefXh7tOd3GNk92+F717lH5ra/PvPAyIb25
         iSoEcpwpycGQHy7pQDIuBSrFrnZIxciNM2YKKKgpF80ZpPHzhq+/m1aS/+tWSLnwFI
         U2O36UrhnjE0YQsLsWGGUWzi+3Iof8+cmAVDMLWU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Vitaly Chikunov <vt@altlinux.org>
Subject: [RFC/RFT PATCH 09/18] crypto: streebog - fix unaligned memory accesses
Date:   Sun, 31 Mar 2019 13:04:19 -0700
Message-Id: <20190331200428.26597-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190331200428.26597-1-ebiggers@kernel.org>
References: <20190331200428.26597-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Don't cast the data buffer directly to streebog_uint512, as this
violates alignment rules.

Fixes: fe18957e8e87 ("crypto: streebog - add Streebog hash function")
Cc: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/streebog_generic.c | 25 +++++++++++++------------
 include/crypto/streebog.h |  5 ++++-
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/crypto/streebog_generic.c b/crypto/streebog_generic.c
index 5a2eafed9c29f..b82fc3d79aa15 100644
--- a/crypto/streebog_generic.c
+++ b/crypto/streebog_generic.c
@@ -996,7 +996,7 @@ static void streebog_add512(const struct streebog_uint512 *x,
 
 static void streebog_g(struct streebog_uint512 *h,
 		       const struct streebog_uint512 *N,
-		       const u8 *m)
+		       const struct streebog_uint512 *m)
 {
 	struct streebog_uint512 Ki, data;
 	unsigned int i;
@@ -1005,7 +1005,7 @@ static void streebog_g(struct streebog_uint512 *h,
 
 	/* Starting E() */
 	Ki = data;
-	streebog_xlps(&Ki, (const struct streebog_uint512 *)&m[0], &data);
+	streebog_xlps(&Ki, m, &data);
 
 	for (i = 0; i < 11; i++)
 		streebog_round(i, &Ki, &data);
@@ -1015,16 +1015,19 @@ static void streebog_g(struct streebog_uint512 *h,
 	/* E() done */
 
 	streebog_xor(&data, h, &data);
-	streebog_xor(&data, (const struct streebog_uint512 *)&m[0], h);
+	streebog_xor(&data, m, h);
 }
 
 static void streebog_stage2(struct streebog_state *ctx, const u8 *data)
 {
-	streebog_g(&ctx->h, &ctx->N, data);
+	struct streebog_uint512 m;
+
+	memcpy(&m, data, sizeof(m));
+
+	streebog_g(&ctx->h, &ctx->N, &m);
 
 	streebog_add512(&ctx->N, &buffer512, &ctx->N);
-	streebog_add512(&ctx->Sigma, (const struct streebog_uint512 *)data,
-			&ctx->Sigma);
+	streebog_add512(&ctx->Sigma, &m, &ctx->Sigma);
 }
 
 static void streebog_stage3(struct streebog_state *ctx)
@@ -1034,13 +1037,11 @@ static void streebog_stage3(struct streebog_state *ctx)
 	buf.qword[0] = cpu_to_le64(ctx->fillsize << 3);
 	streebog_pad(ctx);
 
-	streebog_g(&ctx->h, &ctx->N, (const u8 *)&ctx->buffer);
+	streebog_g(&ctx->h, &ctx->N, &ctx->m);
 	streebog_add512(&ctx->N, &buf, &ctx->N);
-	streebog_add512(&ctx->Sigma,
-			(const struct streebog_uint512 *)&ctx->buffer[0],
-			&ctx->Sigma);
-	streebog_g(&ctx->h, &buffer0, (const u8 *)&ctx->N);
-	streebog_g(&ctx->h, &buffer0, (const u8 *)&ctx->Sigma);
+	streebog_add512(&ctx->Sigma, &ctx->m, &ctx->Sigma);
+	streebog_g(&ctx->h, &buffer0, &ctx->N);
+	streebog_g(&ctx->h, &buffer0, &ctx->Sigma);
 	memcpy(&ctx->hash, &ctx->h, sizeof(struct streebog_uint512));
 }
 
diff --git a/include/crypto/streebog.h b/include/crypto/streebog.h
index 856e32af86574..cae1b4a019713 100644
--- a/include/crypto/streebog.h
+++ b/include/crypto/streebog.h
@@ -23,7 +23,10 @@ struct streebog_uint512 {
 };
 
 struct streebog_state {
-	u8 buffer[STREEBOG_BLOCK_SIZE];
+	union {
+		u8 buffer[STREEBOG_BLOCK_SIZE];
+		struct streebog_uint512 m;
+	};
 	struct streebog_uint512 hash;
 	struct streebog_uint512 h;
 	struct streebog_uint512 N;
-- 
2.21.0

