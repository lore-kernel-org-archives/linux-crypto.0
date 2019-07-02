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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53456C06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 293522082F
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 15:42:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qRw3sEy6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfGBPmm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 11:42:42 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:45833 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfGBPmm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 11:42:42 -0400
Received: by mail-ed1-f54.google.com with SMTP id a14so27717154edv.12
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 08:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ksYCsc0lRfHM828MeC22NSXrVVriqg78KyiC2mMDSvo=;
        b=qRw3sEy6w5+eoTCuFj0iAZ2AX4nZmc2ereXWgntyX1WiHO+uRMpBWXJqfNz0RcRMMI
         Uq4rQFEcDB08V0jhaPgtX3GdbBa3OuIRrb/pev1M3kH65QoT2j0BADsSGK2DPn+gTY5p
         uqMjOwLu3YO+Oh1ZuWNT8IFIUCT0+g9CKZnulDHmWs/cmo73FDMmYiQUlFlsPA77eP1z
         MnZfe7OJiMI7Y7EjALSRm4Hd4U7tsIF0/8WdhxHUTtk5tXS4/JVe3edokilyvJrrZmnj
         Bt6EdcOr7ptXZ633CtiOivKtMdw2QohYX02T92rx9zvgJUsMnDCZBkQJqRcNG+j3XxF+
         689Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ksYCsc0lRfHM828MeC22NSXrVVriqg78KyiC2mMDSvo=;
        b=T12wjYCsp9x3ct4kaNqfJ9bGmbSakmibSsMS87GklVcmO5ITwNAWQCnwHkDE43WOWi
         lf1XKVgFcyXuj/x9mBWcwVHEX2t3pqs+oHWLwKI/jk/FFlBc/gL6kzUV0AcEgY6qgJQP
         1uxR3SA8X651z5GrqqRKThzF+Wi6m2YqCCdw8uIrHeXkicPocTZm+5H/kCEbwfqxn2PF
         +wZylU7iODOuFBbFOmK8aD8x7UHQF1okr2fYKWFw9QQg4m9xrLaVci2ZYKEIj/VnDWtC
         Oscoz/2O77h7SewSfnPeOIoHco3zKK6QCDIqWPhiAdPLwcOvCjg9ntEWFLNnxmCPAPj2
         VnQA==
X-Gm-Message-State: APjAAAWpu9BHmZVfLUp6lx7CDoqnkGNqb3hMo4gw+fY9ZOevD07A/1ku
        spQoR65PWICOja0ud0jRHGnrGWLR
X-Google-Smtp-Source: APXvYqxa2FwlEALveUOXcWrbzZOVjFn8qfyu4hg1EtQEAZrmIUzHD+fNBgalnoSSVswbeBU+I/VBcA==
X-Received: by 2002:a50:a56a:: with SMTP id z39mr36960414edb.107.1562082159943;
        Tue, 02 Jul 2019 08:42:39 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id j11sm2341704ejr.69.2019.07.02.08.42.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 08:42:39 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@insidesecure.com>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 9/9] crypto: inside-secure - add support for 0 length HMAC messages
Date:   Tue,  2 Jul 2019 16:40:00 +0200
Message-Id: <1562078400-969-12-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>

This patch adds support for the specific corner case of performing HMAC
on an empty string (i.e. payload length is zero). This solves the last
failing cryptomgr extratests for HMAC.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 47 ++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 59ec7dc..bdbaea9 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -29,6 +29,8 @@ struct safexcel_ahash_req {
 	bool finish;
 	bool hmac;
 	bool needs_inv;
+	bool hmac_zlen;
+	bool len_is_le;
 
 	int nents;
 	dma_addr_t result_dma;
@@ -117,7 +119,7 @@ static void safexcel_context_control(struct safexcel_ahash_ctx *ctx,
 	if (req->finish) {
 		/* Compute digest count for hash/HMAC finish operations */
 		if ((req->digest == CONTEXT_CONTROL_DIGEST_PRECOMPUTED) ||
-		    req->processed[1] ||
+		    req->hmac_zlen || req->processed[1] ||
 		    (req->processed[0] != req->block_sz)) {
 			count = req->processed[0] / EIP197_COUNTER_BLOCK_SIZE;
 			count += ((0x100000000ULL / EIP197_COUNTER_BLOCK_SIZE) *
@@ -136,6 +138,8 @@ static void safexcel_context_control(struct safexcel_ahash_ctx *ctx,
 		}
 
 		if ((req->digest == CONTEXT_CONTROL_DIGEST_PRECOMPUTED) ||
+		    /* Special case: zero length HMAC */
+		    req->hmac_zlen ||
 		    /* PE HW < 4.4 cannot do HMAC continue, fake using hash */
 		    ((req->processed[1] ||
 		      (req->processed[0] != req->block_sz)))) {
@@ -144,11 +148,18 @@ static void safexcel_context_control(struct safexcel_ahash_ctx *ctx,
 				CONTEXT_CONTROL_SIZE((req->state_sz >> 2) + 1) |
 				CONTEXT_CONTROL_TYPE_HASH_OUT |
 				CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
+			/* For zero-len HMAC, don't finalize, already padded! */
+			if (req->hmac_zlen)
+				cdesc->control_data.control0 |=
+					CONTEXT_CONTROL_NO_FINISH_HASH;
 			cdesc->control_data.control1 |=
 				CONTEXT_CONTROL_DIGEST_CNT;
 			ctx->base.ctxr->data[req->state_sz >> 2] =
 				cpu_to_le32(count);
 			req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
+
+			/* Clear zero-length HMAC flag for next operation! */
+			req->hmac_zlen = false;
 		} else { /* HMAC */
 			/* Need outer digest for HMAC finalization */
 			memcpy(ctx->base.ctxr->data + (req->state_sz >> 2),
@@ -701,8 +712,37 @@ static int safexcel_ahash_final(struct ahash_request *areq)
 	} else if (unlikely(req->hmac && !req->len[1] &&
 			    (req->len[0] == req->block_sz) &&
 			    !areq->nbytes)) {
-		/* TODO: add support for zero length HMAC */
-		return 0;
+		/*
+		 * If we have an overall 0 length *HMAC* request:
+		 * For HMAC, we need to finalize the inner digest
+		 * and then perform the outer hash.
+		 */
+
+		/* generate pad block in the cache */
+		/* start with a hash block of all zeroes */
+		memset(req->cache, 0, req->block_sz);
+		/* set the first byte to 0x80 to 'append a 1 bit' */
+		req->cache[0] = 0x80;
+		/* add the length in bits in the last 2 bytes */
+		if (req->len_is_le) {
+			/* Little endian length word (e.g. MD5) */
+			req->cache[req->block_sz-8] = (req->block_sz << 3) &
+						      255;
+			req->cache[req->block_sz-7] = (req->block_sz >> 5);
+		} else {
+			/* Big endian length word (e.g. any SHA) */
+			req->cache[req->block_sz-2] = (req->block_sz >> 5);
+			req->cache[req->block_sz-1] = (req->block_sz << 3) &
+						      255;
+		}
+
+		req->len[0] += req->block_sz; /* plus 1 hash block */
+
+		/* Set special zero-length HMAC flag */
+		req->hmac_zlen = true;
+
+		/* Finalize HMAC */
+		req->digest = CONTEXT_CONTROL_DIGEST_HMAC;
 	} else if (req->hmac) {
 		/* Finalize HMAC */
 		req->digest = CONTEXT_CONTROL_DIGEST_HMAC;
@@ -1656,6 +1696,7 @@ static int safexcel_hmac_md5_init(struct ahash_request *areq)
 	req->digest = CONTEXT_CONTROL_DIGEST_PRECOMPUTED;
 	req->state_sz = MD5_DIGEST_SIZE;
 	req->block_sz = MD5_HMAC_BLOCK_SIZE;
+	req->len_is_le = true; /* MD5 is little endian! ... */
 	req->hmac = true;
 
 	return 0;
-- 
1.8.3.1

