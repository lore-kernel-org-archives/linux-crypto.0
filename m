Return-Path: <SRS0=XUD9=VU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B7EC76188
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 07:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C383322ADF
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Jul 2019 07:20:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c1pXgPiA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388257AbfGWHUw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Jul 2019 03:20:52 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42538 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388231AbfGWHUw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jul 2019 03:20:52 -0400
Received: by mail-pl1-f196.google.com with SMTP id ay6so20271222plb.9;
        Tue, 23 Jul 2019 00:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4QWiA/u7FUkm/LP2+FlraH63gXlLRpOie6WBL+YDZks=;
        b=c1pXgPiAsMw1pk8bFK3PwA0hqGMc/sMpkQtw/FfggkERlGIWgPpZNFo/K4CSzw6hd6
         +zz+DO4Bq011chyUgykYBW/IkBssKoYBjfFVYC1kredHk5WX1FmXs4DosE7MK1cerlGI
         wTU/dMy0KoS0rzhw4w/nFiiJwC7JNEC327bqEGrJQZrAfrJ39cs+2rQfU8ylPvzRK+QM
         4afzpXrveZ3d9936OCfAJ7mRhYxKy9xZ5/Hp7WkO3w2hErwZqOUlEFaB14Lpv38NYXfO
         ZmQrd3mvX4gDwemKPKlxatRA0adWdrPQj/WycIIHZ+lLp6QJM0e6dVYom7AHafUlUbqD
         oG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4QWiA/u7FUkm/LP2+FlraH63gXlLRpOie6WBL+YDZks=;
        b=NU0DVI8X+fBCb6xmvj3tVT4YzjmjBL7DbUIBw5AJl1iqajJPvF2kPu+eHVU0XdJ+r6
         izZYNLLSg4iaZyGRhLMZokIZnUY1FwCNOHyBcgWa4JQjE7Fu86yEsUjee7dKNLGIqE1A
         cPM3ipIBV1DG5RTQL0t241dfKC5oteVkOYYqcppweKR1plRbhN3jt86DoxY4qGRUBkQV
         emd+wh76ZHTXVYuvUqfq+bwZPtoiiTq1a3qXFv9mxaHBgLBgciLesVw7VtG+0cAzPii1
         mDlAZ63jHeCoKkSNf8iSZS33jQwVYqJK4mo2Niv3cKOdQLQ2wCmE5/NS5M74OCo+ttqw
         kiXw==
X-Gm-Message-State: APjAAAWmJUzj2TS/MO57pOlAtmhXDE2gPcMQ5m6bXQjhfd/AMzc+oA09
        ciFajWIuSk8xeZCyOJEuP9eRmIezMNo=
X-Google-Smtp-Source: APXvYqwTihw8jhNsCmpI+cCen8+lZlsATFxXbsy6cUIM8VdRumBC1BtQZh3JMcofrWyj/ptB6zC+fQ==
X-Received: by 2002:a17:902:a9ca:: with SMTP id b10mr5633876plr.69.1563866451938;
        Tue, 23 Jul 2019 00:20:51 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id v18sm34217115pgl.87.2019.07.23.00.20.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 00:20:51 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] crypto: atmel-sha204a: Use device-managed registration API
Date:   Tue, 23 Jul 2019 15:19:36 +0800
Message-Id: <20190723071934.12528-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use devm_hwrng_register to get rid of manual
unregistration.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/crypto/atmel-sha204a.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index ea0d2068ea4f..c96c14e7dab1 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -109,7 +109,7 @@ static int atmel_sha204a_probe(struct i2c_client *client,
 	i2c_priv->hwrng.read = atmel_sha204a_rng_read;
 	i2c_priv->hwrng.quality = 1024;
 
-	ret = hwrng_register(&i2c_priv->hwrng);
+	ret = devm_hwrng_register(&client->dev, &i2c_priv->hwrng);
 	if (ret)
 		dev_warn(&client->dev, "failed to register RNG (%d)\n", ret);
 
@@ -127,7 +127,6 @@ static int atmel_sha204a_remove(struct i2c_client *client)
 
 	if (i2c_priv->hwrng.priv)
 		kfree((void *)i2c_priv->hwrng.priv);
-	hwrng_unregister(&i2c_priv->hwrng);
 
 	return 0;
 }
-- 
2.20.1

