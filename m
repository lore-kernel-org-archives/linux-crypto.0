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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E720C06511
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB7322082F
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:42:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p4OjKPNA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfGBPmk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 11:42:40 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38274 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfGBPmj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 11:42:39 -0400
Received: by mail-ed1-f67.google.com with SMTP id r12so27736648edo.5
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 08:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4KWC/IjonwZd7jT4z1zP7aqQ9l1rBusD06DEkMiGjbI=;
        b=p4OjKPNAGMQ/Y+hEX6f942kri1ZEC1BHGl9wF+KJC7F6UFVw1olkeVEqxOgO5PQiPt
         Az1LxUu0vns1VoF+9dsM/toiuBWGAZnXjMBcXvXEZ+ab1KP12I0FbZQDVV+xQqAOFugz
         piRCjiwE21nbHWZWXiKxMXR6/bbfMPKmneFiMdqcak4dLXRHYFrdhbEGQR1FAaic5ZI0
         N3YmkPAyWOs0a2lAlbVEGZZ7zY7Ny1PoXpPVAjGWfVSrqvZNbmZw2u4KuQ+VPgUh4FY5
         9Y2AZDxc7qztoWXwJZvQ4lvVDp3LJmk6W6506hQp6fBkfxIpKOTjdprmHJFwtHZbDuIo
         0KgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4KWC/IjonwZd7jT4z1zP7aqQ9l1rBusD06DEkMiGjbI=;
        b=q0KrIxnR0e6fS+k4ZnNeWE7Uo5YY2xpRPX7GlFlcBFE9uMy8hjbU/7bFX/URFVbzDI
         a1HwgHfRzGEE98DPDoqnJxH+RWQHX2wIk1a22m5QBCN9MSZYsg6wykGfg1nfEsdsz3PP
         2DOprRgpDu+M2EomJ0KC4CoUbdpR/bpnI42ImCo3wV0nHMi00f5skBft4EkJlUUgC8Rd
         LfUJLyFgc8cgh60FcRS6DBtNkX6iOWc2IC4rbgO/4osTwk90ySQgNmXC52Vp6/MPksob
         v/fBcnAFdOxXDOjLtTCRj4adytFz1GKv/GHw1xfHBeNMae/gn65mwtafNQzeWT1hRUCd
         H9jg==
X-Gm-Message-State: APjAAAWCDLslo2PFg305xolxZZiTsa/KLpO9fGuU3X6Uz3VqIyOlDS6g
        cxq8uRurIZ/7Zhsg1EtcsirIYojr
X-Google-Smtp-Source: APXvYqxq/mrnS9SOKktsd89fkO+smznNJy1qoYffSAd/AOPk29k/MCFQBllIQp/3FKKvdGVcjfG+Yw==
X-Received: by 2002:a17:906:9386:: with SMTP id l6mr28581646ejx.51.1562082158000;
        Tue, 02 Jul 2019 08:42:38 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id j11sm2341704ejr.69.2019.07.02.08.42.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:42:37 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 6/9] crypto: inside-secure: back out parts of earlier HMAC update workaround
Date:   Tue,  2 Jul 2019 16:39:57 +0200
Message-Id: <1562078400-969-9-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>

This patch backs out some changes done with commit 082ec2d48467 -
"add support for HMAC updates" as that update just works around the
issue for the basic tests by providing twice the amount of buffering,
but this does not solve the case of much larger data blocks such as
those performed by the extra tests.
This is in preparation of an actual solution in the next patch(es),
which does not actually require any extra buffering at all.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 32 +++++++++++-----------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 2c31536..19ac73c 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -41,11 +41,11 @@ struct safexcel_ahash_req {
 	u64 len[2];
 	u64 processed[2];
 
-	u8 cache[SHA512_BLOCK_SIZE << 1] __aligned(sizeof(u32));
+	u8 cache[SHA512_BLOCK_SIZE] __aligned(sizeof(u32));
 	dma_addr_t cache_dma;
 	unsigned int cache_sz;
 
-	u8 cache_next[SHA512_BLOCK_SIZE << 1] __aligned(sizeof(u32));
+	u8 cache_next[SHA512_BLOCK_SIZE] __aligned(sizeof(u32));
 };
 
 static inline u64 safexcel_queued_len(struct safexcel_ahash_req *req)
@@ -89,9 +89,6 @@ static void safexcel_context_control(struct safexcel_ahash_ctx *ctx,
 	cdesc->control_data.control0 |= ctx->alg;
 	cdesc->control_data.control0 |= req->digest;
 
-	if (!req->finish)
-		cdesc->control_data.control0 |= CONTEXT_CONTROL_NO_FINISH_HASH;
-
 	if (req->digest == CONTEXT_CONTROL_DIGEST_PRECOMPUTED) {
 		if (req->processed[0] || req->processed[1]) {
 			if (ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_MD5)
@@ -110,6 +107,9 @@ static void safexcel_context_control(struct safexcel_ahash_ctx *ctx,
 			cdesc->control_data.control0 |= CONTEXT_CONTROL_RESTART_HASH;
 		}
 
+		if (!req->finish)
+			cdesc->control_data.control0 |= CONTEXT_CONTROL_NO_FINISH_HASH;
+
 		/*
 		 * Copy the input digest if needed, and setup the context
 		 * fields. Do this now as we need it to setup the first command
@@ -216,8 +216,6 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 	u64 queued, len, cache_len, cache_max;
 
 	cache_max = crypto_ahash_blocksize(ahash);
-	if (req->digest == CONTEXT_CONTROL_DIGEST_HMAC)
-		cache_max <<= 1;
 
 	queued = len = safexcel_queued_len(req);
 	if (queued <= cache_max)
@@ -229,17 +227,13 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 		/* If this is not the last request and the queued data does not
 		 * fit into full blocks, cache it for the next send() call.
 		 */
-		extra = queued & (crypto_ahash_blocksize(ahash) - 1);
-
-		if (req->digest == CONTEXT_CONTROL_DIGEST_HMAC &&
-		    extra < crypto_ahash_blocksize(ahash))
-			extra += crypto_ahash_blocksize(ahash);
+		extra = queued & (cache_max - 1);
 
 		/* If this is not the last request and the queued data
 		 * is a multiple of a block, cache the last one for now.
 		 */
 		if (!extra)
-			extra = crypto_ahash_blocksize(ahash);
+			extra = cache_max;
 
 		sg_pcopy_to_buffer(areq->src, sg_nents(areq->src),
 				   req->cache_next, extra,
@@ -247,6 +241,12 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 
 		queued -= extra;
 		len -= extra;
+
+		if (!queued) {
+			*commands = 0;
+			*results = 0;
+			return 0;
+		}
 	}
 
 	/* Add a command descriptor for the cached data, if any */
@@ -613,8 +613,6 @@ static int safexcel_ahash_update(struct ahash_request *areq)
 		req->len[1]++;
 
 	cache_max = crypto_ahash_blocksize(ahash);
-	if (req->digest == CONTEXT_CONTROL_DIGEST_HMAC)
-		cache_max <<= 1;
 
 	safexcel_ahash_cache(areq, cache_max);
 
@@ -689,8 +687,6 @@ static int safexcel_ahash_export(struct ahash_request *areq, void *out)
 	u32 cache_sz;
 
 	cache_sz = crypto_ahash_blocksize(ahash);
-	if (req->digest == CONTEXT_CONTROL_DIGEST_HMAC)
-		cache_sz <<= 1;
 
 	export->len[0] = req->len[0];
 	export->len[1] = req->len[1];
@@ -718,8 +714,6 @@ static int safexcel_ahash_import(struct ahash_request *areq, const void *in)
 		return ret;
 
 	cache_sz = crypto_ahash_blocksize(ahash);
-	if (req->digest == CONTEXT_CONTROL_DIGEST_HMAC)
-		cache_sz <<= 1;
 
 	req->len[0] = export->len[0];
 	req->len[1] = export->len[1];
-- 
1.8.3.1

