Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F607C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 08:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68C19214DA
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 08:18:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ScQFT3IF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388293AbfDRIR6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 04:17:58 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51744 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388279AbfDRIRy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 04:17:54 -0400
Received: by mail-wm1-f66.google.com with SMTP id 4so1728852wmf.1;
        Thu, 18 Apr 2019 01:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z5FqXHUkkOxiPqY9isBq9yK5Qx1B2t+uIrpEWzqHhn4=;
        b=ScQFT3IFvQa3euQsJP1/Jz+BGtaJxiOW7DbwNa0GEW0uzJdXZjsVsr1ixuuH+SDaof
         C3Nlzbc13LL7Z6bDjxnnceYseWsGmSGaKuVBmfTnCTsp5tm1TrPtTSruQIRKFPJFFpCL
         yCJEGWXHfNbvUEOzMnnTYF7box5TzYUHuZL2itCwVP7NWbVUUBab1aNxQK9uwLBJpKxF
         pyNbKowIkgsmzRaYpMP3J8XRL3+QvYX74O+trtA//jC81NVb6i2TqC7Jtqe9xtDij4lt
         YpfxXiwQ1ieUgyC30tX5zTCFsbTkfxqjrVcnRCvkyZdfjXKbV5u5Fj1T+e/pF7l5jgYV
         zkfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z5FqXHUkkOxiPqY9isBq9yK5Qx1B2t+uIrpEWzqHhn4=;
        b=atiwMCFbjjHFPJjkvrvyrO7b5vNHp4j2cUJkm2w12ZrmzNBk5dzqxtR3SEBljmbbVN
         0MsjV0+TRQIuuPzcmRqUaCxxCC0/USKBpyBcvLDpUc7jT3FQrpS9wCV81dkun7MEs1XZ
         m0TWv+VSYUx0KccNGd5zJTjFnJPRo3/YnEP2CXjg3pvOJ2vyN8XPxWwJtOYLupJLx63E
         b0WTjoSuM5KM5ljANiBpC7JLbmCvuU6aGYBOySJGJn01b4lZ9Ydf6D9pLeEGknHdTYXo
         TKRJ3D57MA+N3irwm8zDIKE9zNJhJpNLOyEA/mybuKH4HhZtyaL8KttXofaMixN/eEHK
         cRFw==
X-Gm-Message-State: APjAAAXx5evgNzYs+YtqeINWAsz8VWMXUHzcVcvM/pYf++j4tJiDIGSg
        P8cEU7+JU04l1rrODcnR8Xw=
X-Google-Smtp-Source: APXvYqxOJJGqvqm8GMhlQeF9XODmg5oHOxr6NI3SDMdQJl+Z8fVYcMK2cP6yM7YiAKz9TiRU4RLGxw==
X-Received: by 2002:a1c:4602:: with SMTP id t2mr1991850wma.120.1555575472351;
        Thu, 18 Apr 2019 01:17:52 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id w11sm2350619wre.15.2019.04.18.01.17.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 01:17:51 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        maxime.ripard@bootlin.com, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        ebiggers@kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 3/4] crypto: sun4i-ss: Fix invalid calculation of hash end
Date:   Thu, 18 Apr 2019 10:17:34 +0200
Message-Id: <20190418081735.19002-4-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418081735.19002-1-clabbe.montjoie@gmail.com>
References: <20190418081735.19002-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When nbytes < 4, end is wronlgy set to a negative value which, due to
uint, is then interpreted to a large value leading to a deadlock in the
following code.

This patch fix this problem.

Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index a4b5ff2b72f8..f6936bb3b7be 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -240,7 +240,10 @@ static int sun4i_hash(struct ahash_request *areq)
 		}
 	} else {
 		/* Since we have the flag final, we can go up to modulo 4 */
-		end = ((areq->nbytes + op->len) / 4) * 4 - op->len;
+		if (areq->nbytes < 4)
+			end = 0;
+		else
+			end = ((areq->nbytes + op->len) / 4) * 4 - op->len;
 	}
 
 	/* TODO if SGlen % 4 and !op->len then DMA */
-- 
2.21.0

