Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F16C2D0C6
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 16:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6676B214AF
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 16:36:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XPTYMVZu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbfLKQgA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 11:36:00 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34939 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729522AbfLKQf7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 11:35:59 -0500
Received: by mail-wr1-f65.google.com with SMTP id g17so24759785wro.2
        for <linux-crypto@vger.kernel.org>; Wed, 11 Dec 2019 08:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nZKIGCg2nTl1Ul0c6BYVG+oIIW13Px0JgNscQ8/wdtI=;
        b=XPTYMVZu6ZZumapGWcZcB9eesRMIPb9iqUL/ehdutneob/Qg3DSIxrDDynB4gh7ZT+
         8d66ZnwyGhpacLwyGN469unKN+mgVKt9ln6iTkAN+kKHqNRkeNTPkXl1m/2lD0fU65jy
         sPCoNz/6yt3Xf84lQidLbDuDZCBp0pGtvQXeX7AcZ9o3AEQaYPmuVHMPwfZ1Q+A+PZnT
         7cNP3soXEeMuigotR8uYGaEwUQzRLcRnRBeyUqaiU6bW4aojrH97ammW/j7/1m646Lxt
         IrbBl39cAeqU9HD/AYF+E/29zugj8uaKBl/tg1LYXEs3Lo2IMopqC2du9NgJtym7W+jX
         txFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nZKIGCg2nTl1Ul0c6BYVG+oIIW13Px0JgNscQ8/wdtI=;
        b=kyFvRB2OL9/wTZWyEhxOkpFVG80ud4/DBXmTq6G0H3bJuV+YjLxtbW3rz0bprt0RDR
         ftPeFHpm9noHgluzzaGs1gFbwYW/uB/8JrJBHy5pgJelqFF2i1x6NLUZt8AqEtno3Pm+
         3vdI9+73vUvJTTTHVA2P+8BQTyeCfBtP8rFrFN9yOu39GXZvR0rEcdgFtz5/W5mzPSdV
         uWatoeGTeYygfoFlFHbZ1Bcos6P+qXsAWfteLrSnVSy1fmQqWKznAT2J7ISMKjBvWoz4
         Umo6ke93wQ4mA3vT2M2bz75V7xsOhGp3a+oHARAjWkGqxEI59E/Ojwv5/QC6II0DmEUs
         H0sw==
X-Gm-Message-State: APjAAAU107Ab690CA9992EgNv4s65DzErwYgV4EtJI5n7gj8Cqnkz3Ik
        m2pk84PgMQ88q3ebD4V4/icxO5+bri2LHA==
X-Google-Smtp-Source: APXvYqyKhCzGlpf6czrew1Vg3aEzJGZhHfCz1NZW+bjsDYtavRBSIA9OHMw8SG5ZMGo5ryWjm8UMMw==
X-Received: by 2002:adf:e6c5:: with SMTP id y5mr729257wrm.210.1576082158046;
        Wed, 11 Dec 2019 08:35:58 -0800 (PST)
Received: from localhost.localdomain.com ([31.149.181.161])
        by smtp.gmail.com with ESMTPSA id o19sm2162405wmc.18.2019.12.11.08.35.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Dec 2019 08:35:57 -0800 (PST)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@rambus.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, Pascal van Leeuwen <pvanleeuwen@rambus.com>
Subject: [PATCH 2/3] crypto: inside-secure - Fix hang case on EIP97 with zero length input data
Date:   Wed, 11 Dec 2019 17:32:36 +0100
Message-Id: <1576081957-5971-3-git-send-email-pvanleeuwen@rambus.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1576081957-5971-1-git-send-email-pvanleeuwen@rambus.com>
References: <1576081957-5971-1-git-send-email-pvanleeuwen@rambus.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The EIP97 hardware cannot handle zero length input data and will (usually)
hang when presented with this anyway. This patch converts any zero length
input to a 1 byte dummy input to prevent this hanging.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@rambus.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 40 ++++++++++++++------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index b76f5ab..db26166 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -782,16 +782,31 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,

 	memcpy(ctx->base.ctxr->data, ctx->key, ctx->key_len);

-	/* The EIP cannot deal with zero length input packets! */
-	if (totlen == 0)
-		totlen = 1;
+	if (!totlen) {
+		/*
+		 * The EIP97 cannot deal with zero length input packets!
+		 * So stuff a dummy command descriptor indicating a 1 byte
+		 * (dummy) input packet, using the context record as source.
+		 */
+		first_cdesc = safexcel_add_cdesc(priv, ring,
+						 1, 1, ctx->base.ctxr_dma,
+						 1, 1, ctx->base.ctxr_dma,
+						 &atoken);
+		if (IS_ERR(first_cdesc)) {
+			/* No space left in the command descriptor ring */
+			ret = PTR_ERR(first_cdesc);
+			goto cdesc_rollback;
+		}
+		n_cdesc = 1;
+		goto skip_cdesc;
+	}

 	/* command descriptors */
 	for_each_sg(src, sg, sreq->nr_src, i) {
 		int len = sg_dma_len(sg);

 		/* Do not overflow the request */
-		if (queued - len < 0)
+		if (queued < len)
 			len = queued;

 		cdesc = safexcel_add_cdesc(priv, ring, !n_cdesc,
@@ -803,27 +818,16 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 			ret = PTR_ERR(cdesc);
 			goto cdesc_rollback;
 		}
-		n_cdesc++;

-		if (n_cdesc == 1) {
+		if (!n_cdesc)
 			first_cdesc = cdesc;
-		}

+		n_cdesc++;
 		queued -= len;
 		if (!queued)
 			break;
 	}
-
-	if (unlikely(!n_cdesc)) {
-		/*
-		 * Special case: zero length input buffer.
-		 * The engine always needs the 1st command descriptor, however!
-		 */
-		first_cdesc = safexcel_add_cdesc(priv, ring, 1, 1, 0, 0, totlen,
-						 ctx->base.ctxr_dma, &atoken);
-		n_cdesc = 1;
-	}
-
+skip_cdesc:
 	/* Add context control words and token to first command descriptor */
 	safexcel_context_control(ctx, base, sreq, first_cdesc);
 	if (ctx->aead)
--
1.8.3.1
