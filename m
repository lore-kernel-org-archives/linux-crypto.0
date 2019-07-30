Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8CDFC0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 20:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 787A820693
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 20:18:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r8dUP1oL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387417AbfG3USo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 16:18:44 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40485 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387414AbfG3USo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 16:18:44 -0400
Received: by mail-pg1-f193.google.com with SMTP id w10so30637581pgj.7
        for <linux-crypto@vger.kernel.org>; Tue, 30 Jul 2019 13:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OThpbHHUC3Uzer47hD7L3j/FRmubmQM25l1ctW+M5BU=;
        b=r8dUP1oLoX0rI48nRr1wJzR/hiT/S/F2zl9Bq+7xNScYAqfJx8N3acI3fd/F8rohVa
         GXDj71uXTTj2xTlKFLwVcf6xa8TbbPYVWd8rCCL2gXHooMQM+/OR4GpDKKfZPmdj7cxd
         WIAnWQFero52o3ektOrPJFRzte1MaZobdhlpCz8F2QsuRogS/uqKLcWtICfDyTXRF4W2
         VcyXIGBJgyRIcmONu3tKMwiDG7fa5pxs4motMKoFwH7ZBu6MARvmKRR/siAHqTbiDl5X
         rTIFtdvXX4i6PDi7SHuySl9gZGIl6gO6MztR2nwWiS3ev78DY0Q1iDKB/yQpoj58S/W7
         u0vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OThpbHHUC3Uzer47hD7L3j/FRmubmQM25l1ctW+M5BU=;
        b=c098bsEEWC3JBwZem8O6BHGkcw2WIctzUG74j8jiniVmhrkZA+IfD9UOI5vJTukirI
         /gUyGr5u3youaqNp+BoJM9NdwhlmkhwGCKwMz3h4P3nB4Kpds22n48FdYx6Z02CmRR8b
         td9AQv5VfdTTd+AGNkwP4y2MrtAmMG3wwE+m2IgFQnY7xW5aDs8IJvg0fJptE7MVXwx+
         3fAGSFpceeDkZ/lPElTRNmsqHLFVSqqxURLRU2CYGKsEL5fMJe+xPTA1VpJltX7ocHpN
         0A3TTX8H7xUProLGIisk0ISNO9ESqc7S2ghsDIOE2ZvEvujGMuT6TyOlW9cdZVLhj/05
         Owmg==
X-Gm-Message-State: APjAAAWLM71d1w8FsHOjt4RfJGPaDeRETfuwIlTTSpiMNpwo4psBH9eM
        ArdPu+5o1oC15d9V0r6lqoxVuA==
X-Google-Smtp-Source: APXvYqxh/tNnp9+tld9wqh2Cu0/n1bKdqZM8RfjA/twu6mGeoX6zASIEKY4T3A6kpX6RGOBRkA8vNQ==
X-Received: by 2002:a62:3c3:: with SMTP id 186mr43545291pfd.21.1564517923708;
        Tue, 30 Jul 2019 13:18:43 -0700 (PDT)
Received: from localhost.localdomain ([49.207.49.136])
        by smtp.gmail.com with ESMTPSA id r75sm88113177pfc.18.2019.07.30.13.18.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 30 Jul 2019 13:18:42 -0700 (PDT)
From:   Amit Pundir <amit.pundir@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>, Wen Yang <wen.yang99@zte.com.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Armijn Hemel <armijn@tjaldur.nl>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH for-4.14.y 3/3] crypto: crypto4xx - fix a potential double free in ppc4xx_trng_probe
Date:   Wed, 31 Jul 2019 01:48:33 +0530
Message-Id: <1564517913-17164-3-git-send-email-amit.pundir@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564517913-17164-1-git-send-email-amit.pundir@linaro.org>
References: <1564517913-17164-1-git-send-email-amit.pundir@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>

commit 95566aa75cd6b3b404502c06f66956b5481194b3 upstream.

There is a possible double free issue in ppc4xx_trng_probe():

85:	dev->trng_base = of_iomap(trng, 0);
86:	of_node_put(trng);          ---> released here
87:	if (!dev->trng_base)
88:		goto err_out;
...
110:	ierr_out:
111:		of_node_put(trng);  ---> double released here
...

This issue was detected by using the Coccinelle software.
We fix it by removing the unnecessary of_node_put().

Fixes: 5343e674f32f ("crypto4xx: integrate ppc4xx-rng into crypto4xx")
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: <stable@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Allison Randal <allison@lohutok.net>
Cc: Armijn Hemel <armijn@tjaldur.nl>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
Cleanly apply on 4.9.y as well.

 drivers/crypto/amcc/crypto4xx_trng.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/amcc/crypto4xx_trng.c b/drivers/crypto/amcc/crypto4xx_trng.c
index 368c5599515e..a194ee0ddbb6 100644
--- a/drivers/crypto/amcc/crypto4xx_trng.c
+++ b/drivers/crypto/amcc/crypto4xx_trng.c
@@ -111,7 +111,6 @@ void ppc4xx_trng_probe(struct crypto4xx_core_device *core_dev)
 	return;
 
 err_out:
-	of_node_put(trng);
 	iounmap(dev->trng_base);
 	kfree(rng);
 	dev->trng_base = NULL;
-- 
2.7.4

