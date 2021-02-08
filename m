Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B06C433E6
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80BF164EA4
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbhBHJt4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbhBHJrH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:47:07 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E934EC061222;
        Mon,  8 Feb 2021 01:44:36 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id e9so7527425plh.3;
        Mon, 08 Feb 2021 01:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1e1njK4JCLyF4BWRntmeMNLMXKX/535/WykRDF+9nqU=;
        b=V60zBhDDKDyHGPs3l5Z/FEcXvggs0/y0/S3lqRHr2zmHjQS5aocVuc5EQTP7NYwf8V
         emSAIhOh+J3YhF5Np4egOml+nmRofHygmP+V1/878PhcRt6sDf+MGKFv+kALL+A6/ytn
         AAw8tX11q57/Qcc5rD/UjNXFftUhLrhxIHlKFfFY6fpBY+EgJNonzcLJNIMy2TAFzur/
         KMo+/+YrxTv5JnJTXkCsQ13IVQis3qIyDgbnC326kGTER+Z7L/6VQmgNJZuYlRIIbcHm
         de5gpfsEqkDDCfPWWb6z08c4m3OCF+tTAOnZmo3d6Xx4tkNTy5tqkE9KCksp/up7H0+i
         rD5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1e1njK4JCLyF4BWRntmeMNLMXKX/535/WykRDF+9nqU=;
        b=CqeeSY3grMeHIxHr0ldG0Swv7Ponbb2Xy/PYUg9E9atuaRI1RDGV6pc9bAPfLFiqJN
         aKN8gUjXj2YFN/GZ0o7kZBuUEzaYEveaoX6PBiFp7czTZvK82lyZQvhFc+YJvsLP1d2X
         Wdq8QQm4+NXWRF1HTf0AWaiOcSN2hSOnbui8Frj7OZEnhGwrfnTpZTXP7VNMKjCvxizR
         hBCrZoekmQnrGgX0eLRfN0W8uX0huOco0v3WUqcIHdXgIfsAqSuWcVcT0BNigwcpoxxd
         iU1oLTJ3C6EPo9zLHGn9Y/t4R9jD65CeYt97cUAuY3WOieNXC5Vbw5DvoDJXXgcOErpQ
         hnXg==
X-Gm-Message-State: AOAM532LKxdSOhzxhn6LL2eYzIqT6Ogf1J+UZPmYc3FLjV0xkPmEh6vp
        g1EVlYlzAKOXLO/17KQLbvU=
X-Google-Smtp-Source: ABdhPJw5BDa3V6c/6RuuDbGvAOFRLIuR73+gdTWbAW4RznovNSmaJg8Zh+xf+cWxn0BQqCcUaf+okA==
X-Received: by 2002:a17:902:d113:b029:e2:86e9:c1ee with SMTP id w19-20020a170902d113b02900e286e9c1eemr15482631plw.42.1612777476582;
        Mon, 08 Feb 2021 01:44:36 -0800 (PST)
Received: from localhost.localdomain ([49.207.205.214])
        by smtp.gmail.com with ESMTPSA id k69sm12208958pfd.4.2021.02.08.01.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 01:44:36 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, gcherian@marvell.com,
        thomas.lendacky@amd.com, john.allen@amd.com, gilad@benyossef.com,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        matthias.bgg@gmail.com, jamie@jamieiles.com,
        giovanni.cabiddu@intel.com, heiko@sntech.de, krzk@kernel.org,
        vz@mleia.com, k.konieczny@samsung.com,
        linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
        qat-linux@intel.com, linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v5 10/19] crypto: ixp4xx: convert tasklets to use new tasklet_setup() API
Date:   Mon,  8 Feb 2021 15:12:29 +0530
Message-Id: <20210208094238.571015-11-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210208094238.571015-1-allen.lkml@gmail.com>
References: <20210208094238.571015-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/crypto/ixp4xx_crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 8b0f17fc09fb..b783ab58d718 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -414,7 +414,7 @@ static void irqhandler(void *_unused)
 	tasklet_schedule(&crypto_done_tasklet);
 }
 
-static void crypto_done_action(unsigned long arg)
+static void crypto_done_action(struct tasklet_struct *unused)
 {
 	int i;
 
@@ -497,7 +497,7 @@ static int init_ixp_crypto(struct device *dev)
 		goto err;
 	}
 	qmgr_set_irq(RECV_QID, QUEUE_IRQ_SRC_NOT_EMPTY, irqhandler, NULL);
-	tasklet_init(&crypto_done_tasklet, crypto_done_action, 0);
+	tasklet_setup(&crypto_done_tasklet, crypto_done_action);
 
 	qmgr_enable_irq(RECV_QID);
 	return 0;
-- 
2.25.1

