Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7ECAC06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A11B62082F
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:42:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dsdkxMXH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfGBPml (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 11:42:41 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39043 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfGBPmk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 11:42:40 -0400
Received: by mail-ed1-f68.google.com with SMTP id m10so27719954edv.6
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 08:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=v4Rxu1A+78Ts/V3yzOob0NVn6nELjpibAO7STZnzKFw=;
        b=dsdkxMXH0mGPhwwEW4/I8SZTZfPCPTCStjyBNVlG/LTcSpQAwi4c7/d+AhvTEKPrIi
         qO1dUphBYre+IZRy3hzFlHYmy3RoszaAIHNBHZE3Hg9LgwKp4AJHly4sFnvHImWPTnhI
         azczg0VWqWveXFJNFtOj/Sc9Q3fwyP+wXUisiCG3r5tdaPUtzc+ZH2J8Ykq7gO3GcE4A
         qNQqUiKv5ZrimnMkXNol7ZnqhI1AS/bTaQ7QO9oAY71YQc77/4Rp6Bs63uSsuPx+giDe
         450SnRVcSJoOKUCPC+exIfuiEiYedSdKq/bn1bXDQ0bO1EfzIHSpyhpTjb1jtOGYeQrN
         SWXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=v4Rxu1A+78Ts/V3yzOob0NVn6nELjpibAO7STZnzKFw=;
        b=lEqTZA8O3jsSPqVqGyUCW8Mjpg0JX7wvNeWNxG0A/G1yCmeNUAFlNhhSkgRYBACUJ0
         fCXYGkyNa1VhcvlkF3qCJ3jClTwOW3Y/ylTZXXkUl+R5QP4O9DhG+mCKhjYqu6SlCIpS
         yEOl+RDgNPxidY9LVbxPLT329SsV+eT0fY3aQtNvkUkjRBjuaX1vygxy9r+LeqKpi8jp
         JGe5/2EjD2I6tGo8wTR1xyrykFqsTT2v4EbEaNYCuwLCuyf6DqobWFRWcZ/CJ6MXpNFg
         P0wPrr1W2E9+SzJLXQTbNnkGxFrqwlpzYNFJ4dLDFud53XXzcTzX+3dytjY7H5zrfqJW
         qUQw==
X-Gm-Message-State: APjAAAWu/RTLo486j+/eECn/7oB5wGPHyMQAeDPi3cteb3kRo1JwsQca
        1Uc31WJ9DUnrvF/TcFA1LyaP86At
X-Google-Smtp-Source: APXvYqzJL6ZX5i8lcK0QC9rJgV7o5r9hIDgF0ZOuvdTPvATUb+83odqIKx9lLLwr4zXq6qS6oNkFhA==
X-Received: by 2002:a50:ac4a:: with SMTP id w10mr36721719edc.33.1562082158592;
        Tue, 02 Jul 2019 08:42:38 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id j11sm2341704ejr.69.2019.07.02.08.42.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:42:38 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 7/9] crypto: inside-secure - let HW deal with initial hash digest
Date:   Tue,  2 Jul 2019 16:39:58 +0200
Message-Id: <1562078400-969-10-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>

The driver was loading the initial digest for hash operations into
the hardware explicitly, but this is not needed as the hardware can
handle that by itself, which is more efficient and avoids any context
record coherence issues.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 71 +++-------------------------
 1 file changed, 6 insertions(+), 65 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 19ac73c..1b62608 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -641,8 +641,12 @@ static int safexcel_ahash_final(struct ahash_request *areq)
 	req->last_req = true;
 	req->finish = true;
 
-	/* If we have an overall 0 length request */
-	if (!req->len[0] && !req->len[1] && !areq->nbytes) {
+	if (unlikely(!req->len[0] && !req->len[1] && !areq->nbytes)) {
+		/*
+		 * If we have an overall 0 length *hash* request:
+		 * The HW cannot do 0 length hash, so we provide the correct
+		 * result directly here.
+		 */
 		if (ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_MD5)
 			memcpy(areq->result, md5_zero_message_hash,
 			       MD5_DIGEST_SIZE);
@@ -751,12 +755,6 @@ static int safexcel_sha1_init(struct ahash_request *areq)
 
 	memset(req, 0, sizeof(*req));
 
-	req->state[0] = SHA1_H0;
-	req->state[1] = SHA1_H1;
-	req->state[2] = SHA1_H2;
-	req->state[3] = SHA1_H3;
-	req->state[4] = SHA1_H4;
-
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA1;
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
 	req->state_sz = SHA1_DIGEST_SIZE;
@@ -1063,15 +1061,6 @@ static int safexcel_sha256_init(struct ahash_request *areq)
 
 	memset(req, 0, sizeof(*req));
 
-	req->state[0] = SHA256_H0;
-	req->state[1] = SHA256_H1;
-	req->state[2] = SHA256_H2;
-	req->state[3] = SHA256_H3;
-	req->state[4] = SHA256_H4;
-	req->state[5] = SHA256_H5;
-	req->state[6] = SHA256_H6;
-	req->state[7] = SHA256_H7;
-
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA256;
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
 	req->state_sz = SHA256_DIGEST_SIZE;
@@ -1125,15 +1114,6 @@ static int safexcel_sha224_init(struct ahash_request *areq)
 
 	memset(req, 0, sizeof(*req));
 
-	req->state[0] = SHA224_H0;
-	req->state[1] = SHA224_H1;
-	req->state[2] = SHA224_H2;
-	req->state[3] = SHA224_H3;
-	req->state[4] = SHA224_H4;
-	req->state[5] = SHA224_H5;
-	req->state[6] = SHA224_H6;
-	req->state[7] = SHA224_H7;
-
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA224;
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
 	req->state_sz = SHA256_DIGEST_SIZE;
@@ -1299,23 +1279,6 @@ static int safexcel_sha512_init(struct ahash_request *areq)
 
 	memset(req, 0, sizeof(*req));
 
-	req->state[0] = lower_32_bits(SHA512_H0);
-	req->state[1] = upper_32_bits(SHA512_H0);
-	req->state[2] = lower_32_bits(SHA512_H1);
-	req->state[3] = upper_32_bits(SHA512_H1);
-	req->state[4] = lower_32_bits(SHA512_H2);
-	req->state[5] = upper_32_bits(SHA512_H2);
-	req->state[6] = lower_32_bits(SHA512_H3);
-	req->state[7] = upper_32_bits(SHA512_H3);
-	req->state[8] = lower_32_bits(SHA512_H4);
-	req->state[9] = upper_32_bits(SHA512_H4);
-	req->state[10] = lower_32_bits(SHA512_H5);
-	req->state[11] = upper_32_bits(SHA512_H5);
-	req->state[12] = lower_32_bits(SHA512_H6);
-	req->state[13] = upper_32_bits(SHA512_H6);
-	req->state[14] = lower_32_bits(SHA512_H7);
-	req->state[15] = upper_32_bits(SHA512_H7);
-
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA512;
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
 	req->state_sz = SHA512_DIGEST_SIZE;
@@ -1369,23 +1332,6 @@ static int safexcel_sha384_init(struct ahash_request *areq)
 
 	memset(req, 0, sizeof(*req));
 
-	req->state[0] = lower_32_bits(SHA384_H0);
-	req->state[1] = upper_32_bits(SHA384_H0);
-	req->state[2] = lower_32_bits(SHA384_H1);
-	req->state[3] = upper_32_bits(SHA384_H1);
-	req->state[4] = lower_32_bits(SHA384_H2);
-	req->state[5] = upper_32_bits(SHA384_H2);
-	req->state[6] = lower_32_bits(SHA384_H3);
-	req->state[7] = upper_32_bits(SHA384_H3);
-	req->state[8] = lower_32_bits(SHA384_H4);
-	req->state[9] = upper_32_bits(SHA384_H4);
-	req->state[10] = lower_32_bits(SHA384_H5);
-	req->state[11] = upper_32_bits(SHA384_H5);
-	req->state[12] = lower_32_bits(SHA384_H6);
-	req->state[13] = upper_32_bits(SHA384_H6);
-	req->state[14] = lower_32_bits(SHA384_H7);
-	req->state[15] = upper_32_bits(SHA384_H7);
-
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_SHA384;
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
 	req->state_sz = SHA512_DIGEST_SIZE;
@@ -1551,11 +1497,6 @@ static int safexcel_md5_init(struct ahash_request *areq)
 
 	memset(req, 0, sizeof(*req));
 
-	req->state[0] = MD5_H0;
-	req->state[1] = MD5_H1;
-	req->state[2] = MD5_H2;
-	req->state[3] = MD5_H3;
-
 	ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_MD5;
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
 	req->state_sz = MD5_DIGEST_SIZE;
-- 
1.8.3.1

