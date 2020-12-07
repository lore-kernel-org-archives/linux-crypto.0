Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DF43C433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F03A623357
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgLGJBP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbgLGJBP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 04:01:15 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AE7C0613D1
        for <linux-crypto@vger.kernel.org>; Mon,  7 Dec 2020 01:00:38 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id f9so8576531pfc.11
        for <linux-crypto@vger.kernel.org>; Mon, 07 Dec 2020 01:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x5of+eu/O3/72kx5fP37UL1yWIpLxGlDGOGpwCqEig8=;
        b=UhgUXmmm5hHsgzg4VLk67KHbXam/G6cZDancgohIojsxIWWPAWR0P9S7hK12P9gGOs
         J3oqtih7OkDfpy5gC8enW7MOGfGMvMq8c7ip0JJstLv7NESWzxPgWNa5VhLpYkBWmzRx
         xP/hcITLH04H7A0+MSGfF1JIT4/CDFK+CT1JHa+fiOtAzC8s0OONZQoJMwwxQ0Yg2f7r
         SU7xXVODeVFDNtPK1sxK7OXmDPc2tW3lhPIMH5EoIGqy6qUCBe0Fz7nmU/0TjiIIymWU
         dLf6E8cWdcxEFRTbJINPHFcqLKoJRehVUYUqCL9TwL96LYG5HsVo+5jKItSb0PXrzB4S
         FcwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x5of+eu/O3/72kx5fP37UL1yWIpLxGlDGOGpwCqEig8=;
        b=kca0MOmbxVWFI9Pm3cIfDLVm+D4hWAcB5bgTUrOpf4zMWEfZDJixIHcXFGjsMUmgAD
         6uZTciY4X8zeZoBEfoCq7ELxz5JNrSKupuQENssuqoRHAQ+ohUMLzFlRn2yVT1z9P4A4
         w1JPcHQgOgxbBqfaenp5Ah+PeOQIc8Wn/0raKbef7z66NPqhs8rYD4FLuJGpDWB27v/x
         1IYv6Y5iBScrTvbJCyD7uidamqg0c5T5aLINtHKb/5OglmipUMxFZ4FZN3fDRg6CC+EQ
         xk0mrDXKUyQmsqntEIVN0vnSLz9MBdVBuEyl/x/zJ99Jb9nUtd1RNDteVm08SZXnYVgS
         LRFw==
X-Gm-Message-State: AOAM532AcBDF6Y6cM6MaUHbNtDTTCi+NWObUXX6RXkaDrc+2WHm7Brbo
        0wao+Y5N7ZAslGRAZCqrrP8=
X-Google-Smtp-Source: ABdhPJwN5u7DYmVUOjez2U/vkXdRn/aVPRTzLc6jlYV+LNOMmhQ3kUhuqqifsajpV54rZHQXxcUA/w==
X-Received: by 2002:a62:6003:0:b029:18c:796f:de1b with SMTP id u3-20020a6260030000b029018c796fde1bmr15040891pfb.23.1607331638094;
        Mon, 07 Dec 2020 01:00:38 -0800 (PST)
Received: from localhost.localdomain ([49.207.208.18])
        by smtp.gmail.com with ESMTPSA id w200sm11325029pfc.14.2020.12.07.01.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:00:37 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, bbrezillon@kernel.org,
        arno@natisbad.org, schalla@marvell.com, matthias.bgg@gmail.com,
        heiko@sntech.de, krzk@kernel.org, vz@mleia.com,
        k.konieczny@samsung.com, linux-crypto@vger.kernel.org,
        Allen Pais <apais@microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND 08/19] crypto: hifn_795x: convert tasklets to use new tasklet_setup() API
Date:   Mon,  7 Dec 2020 14:29:20 +0530
Message-Id: <20201207085931.661267-9-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201207085931.661267-1-allen.lkml@gmail.com>
References: <20201207085931.661267-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@microsoft.com>
---
 drivers/crypto/hifn_795x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 7e7a8f01ea6b..47f7bb43477e 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2445,9 +2445,9 @@ static int hifn_register_alg(struct hifn_device *dev)
 	return err;
 }
 
-static void hifn_tasklet_callback(unsigned long data)
+static void hifn_tasklet_callback(struct tasklet_struct *t)
 {
-	struct hifn_device *dev = (struct hifn_device *)data;
+	struct hifn_device *dev = from_tasklet(dev, t, tasklet);
 
 	/*
 	 * This is ok to call this without lock being held,
@@ -2533,7 +2533,7 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_drvdata(pdev, dev);
 
-	tasklet_init(&dev->tasklet, hifn_tasklet_callback, (unsigned long)dev);
+	tasklet_setup(&dev->tasklet, hifn_tasklet_callback);
 
 	crypto_init_queue(&dev->queue, 1);
 
-- 
2.25.1

