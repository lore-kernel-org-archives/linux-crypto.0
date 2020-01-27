Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E161C35248
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 16:57:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 302B4214AF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 16:57:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q1Mtlft6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgA0Q5k (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 11:57:40 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36305 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbgA0Q5I (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 11:57:08 -0500
Received: by mail-pl1-f196.google.com with SMTP id a6so3964531plm.3;
        Mon, 27 Jan 2020 08:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TcjeClmRH5R/km2Nzp0idBoWoVhmeZ5+erKgXpUxBBo=;
        b=Q1Mtlft6a4GSlcQtk4C4LnJ99CA+QFsHXr5JBozHH5iFzbtVMefOlsAH5dmjNQdK4o
         PQadM0OxOiJXWgs9yy0RXFeYcGfDroruZDrkxtR8K5Kio5OANuPCeu+ph8Foq/B+osG5
         TWVeDkU9d2CsVaX14ZAmUzt39n4uCsnWKQ5dTxfXVWQeHNq5GRy6XlvH2nal1g2dDMFz
         OvbwJbfkfMY1QWXA/q5juX8BBRO71y7WiFnUl3tcUbu0Fj/09Mq/5y7yv7q2oX+jmYS4
         6JXpFz45+UpQeq70Ltgz8ZmyBWFf1vYwLx6ymWRhe5aXXMsxNWaL7FWQc9sOrLkcRG3y
         WukA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TcjeClmRH5R/km2Nzp0idBoWoVhmeZ5+erKgXpUxBBo=;
        b=Sq5513e64hEmvWCqd7aUT7LMupt0MtNCLAvofIdmIgXWFbvaKEBxiONp2R14DSiAEG
         eFHB5ksCJGayGA+Y6BvaOT8rCYG/944yvmF5C57w2kDLs7yzOVpT4tUSI6VwH1Z00Rh/
         bYttsjXxM4GKW6D3TtfFKDra09Z0yEdzI7QLCQc5H5Sj1Ob5p1JqBnZEOe9o+X2aVAgO
         um8uJVACGrvgbfkMvvGG2tVLPLlF0+6/J5LjTsZqkQnPlJTO90Wc7UUfSeu79gzcC1Z1
         wV0ym8WsA0VZABtZn4+DOxyZJxvk6tYHvX5nIh9XrxsUW2Cjbbba5siwoLrX+E/dvban
         ah3g==
X-Gm-Message-State: APjAAAW3LIOp+fqTUFEys7FDkAmVYOnPwXU+1ycjz09hb8LgvRyV3vFA
        ujTtcaWb3ir7cHQ2kqxCuz4iB2aO
X-Google-Smtp-Source: APXvYqz+yLuw5NkGsIKVpT98QYpSDv6QGN953xt08HGy0A3KNseQFgaApXkUDTUi+1dDEoT/5aVYVw==
X-Received: by 2002:a17:902:8495:: with SMTP id c21mr18782308plo.279.1580144227787;
        Mon, 27 Jan 2020 08:57:07 -0800 (PST)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id u23sm16368642pfm.29.2020.01.27.08.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 08:57:06 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v7 2/9] crypto: caam - use struct hwrng's .init for initialization
Date:   Mon, 27 Jan 2020 08:56:39 -0800
Message-Id: <20200127165646.19806-3-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200127165646.19806-1-andrew.smirnov@gmail.com>
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Make caamrng code a bit more symmetric by moving initialization code
to .init hook of struct hwrng.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-imx@nxp.com
---
 drivers/crypto/caam/caamrng.c | 47 ++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index e8baacaabe07..1ce7fbd29e85 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -256,6 +256,7 @@ static void caam_cleanup(struct hwrng *rng)
 	}
 
 	rng_unmap_ctx(rng_ctx);
+	caam_jr_free(rng_ctx->jrdev);
 }
 
 static int caam_init_buf(struct caam_rng_ctx *ctx, int buf_id)
@@ -274,28 +275,43 @@ static int caam_init_buf(struct caam_rng_ctx *ctx, int buf_id)
 	return 0;
 }
 
-static int caam_init_rng(struct caam_rng_ctx *ctx, struct device *jrdev)
+static int caam_init(struct hwrng *rng)
 {
+	struct caam_rng_ctx *ctx = rng_ctx;
 	int err;
 
-	ctx->jrdev = jrdev;
+	ctx->jrdev = caam_jr_alloc();
+	err = PTR_ERR_OR_ZERO(ctx->jrdev);
+	if (err) {
+		pr_err("Job Ring Device allocation for transform failed\n");
+		return err;
+	}
 
 	err = rng_create_sh_desc(ctx);
 	if (err)
-		return err;
+		goto free_jrdev;
 
 	ctx->current_buf = 0;
 	ctx->cur_buf_idx = 0;
 
 	err = caam_init_buf(ctx, 0);
 	if (err)
-		return err;
+		goto free_jrdev;
+
+	err = caam_init_buf(ctx, 1);
+	if (err)
+		goto free_jrdev;
 
-	return caam_init_buf(ctx, 1);
+	return 0;
+
+free_jrdev:
+	caam_jr_free(ctx->jrdev);
+	return err;
 }
 
 static struct hwrng caam_rng = {
 	.name		= "rng-caam",
+	.init           = caam_init,
 	.cleanup	= caam_cleanup,
 	.read		= caam_read,
 };
@@ -305,14 +321,12 @@ void caam_rng_exit(void)
 	if (!init_done)
 		return;
 
-	caam_jr_free(rng_ctx->jrdev);
 	hwrng_unregister(&caam_rng);
 	kfree(rng_ctx);
 }
 
 int caam_rng_init(struct device *ctrldev)
 {
-	struct device *dev;
 	u32 rng_inst;
 	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
 	int err;
@@ -328,21 +342,11 @@ int caam_rng_init(struct device *ctrldev)
 	if (!rng_inst)
 		return 0;
 
-	dev = caam_jr_alloc();
-	if (IS_ERR(dev)) {
-		pr_err("Job Ring Device allocation for transform failed\n");
-		return PTR_ERR(dev);
-	}
 	rng_ctx = kmalloc(sizeof(*rng_ctx), GFP_DMA | GFP_KERNEL);
-	if (!rng_ctx) {
-		err = -ENOMEM;
-		goto free_caam_alloc;
-	}
-	err = caam_init_rng(rng_ctx, dev);
-	if (err)
-		goto free_rng_ctx;
+	if (!rng_ctx)
+		return -ENOMEM;
 
-	dev_info(dev, "registering rng-caam\n");
+	dev_info(ctrldev, "registering rng-caam\n");
 
 	err = hwrng_register(&caam_rng);
 	if (!err) {
@@ -350,9 +354,6 @@ int caam_rng_init(struct device *ctrldev)
 		return err;
 	}
 
-free_rng_ctx:
 	kfree(rng_ctx);
-free_caam_alloc:
-	caam_jr_free(dev);
 	return err;
 }
-- 
2.21.0

