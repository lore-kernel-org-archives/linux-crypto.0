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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC9EC2BB3F
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6FCE2333D
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgLGJB3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbgLGJB2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 04:01:28 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDC0C0613D3
        for <linux-crypto@vger.kernel.org>; Mon,  7 Dec 2020 01:00:51 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id o4so8357936pgj.0
        for <linux-crypto@vger.kernel.org>; Mon, 07 Dec 2020 01:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dhlnry4NnWxGfU7xyG9jOMoMfechIl8tc2kpnH7quI8=;
        b=HWvL63nCN8ED8T6DxDhlhWlHgtWg7KFc7i0RCZvQxLOuQrpUqpmds8R9bbMtD/oCbc
         8Vvj8BS5QpTHWyllnu8a3mEZPMndy5X3OETUZZaU5DIXKdbtAtPLGSVIlZSA/xR5v3kW
         xohI3/qB3Pje9bN4Ax/UhYNNqNd69E5UmWPHJFN6Zw7Y+zxqVhvb5NOJcB0OFqmf3Oer
         0P9fH4rZMnSBXmRNUZqNoYEeSj7wIblB9lOpV5OyRRwlpIoW0zUcO+KblZYK2SnHPObh
         UfHLYMjVik69zBhGQk71wY/4kT5zDMCcjb+PFnDw2xgXQlAS9Ma8sjSl6OyqngzJ0OL+
         3ZAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dhlnry4NnWxGfU7xyG9jOMoMfechIl8tc2kpnH7quI8=;
        b=Hpk5VEI4PzDKWtU8g8cR9e4oMys0ERLR8R+Wfs9u3IeoYhlI0CMgFCQY30oHqybBJj
         xtn6A3RnY8QqL6BimEfWHc9MlrnQmvbaluCePcOYk0NBQUEsgaTRKFPpBzgPNA3iKCE6
         kc9VBcbTmOmq2QJGWtZS33ik6S59p8wVvhrADfp0wcowcoXX6ojokRdrfdWMS3Xh/KH3
         QjF1y7wnhhOwsGL7cryQcL3xfsz11k/eE72Pah3H0Sd3/IpwdMbg7+lrImfsFKnTuHzQ
         NsJwJJLKlz+2sMz3qHaXuqG9H7jl1nKfeajxXsjN93/RmOe+SwjErZBI7JWnFw9G48iZ
         orxA==
X-Gm-Message-State: AOAM532O0rJy2nhxnLWaDAb7bac+UJ5L6Jq4ZcjOs7trxbk4z9ilkeJS
        aMhVi1kY2az8+v81YrCE/SA=
X-Google-Smtp-Source: ABdhPJzQKTaKN8Fro8IbUDB9hYbWvk4LqdE55HMO2Tqe6hADg851Ewa9z7B/T7NAT1VkD8HZmkuqCQ==
X-Received: by 2002:aa7:8387:0:b029:19d:a8db:81a8 with SMTP id u7-20020aa783870000b029019da8db81a8mr14891061pfm.66.1607331651366;
        Mon, 07 Dec 2020 01:00:51 -0800 (PST)
Received: from localhost.localdomain ([49.207.208.18])
        by smtp.gmail.com with ESMTPSA id w200sm11325029pfc.14.2020.12.07.01.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:00:50 -0800 (PST)
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
Subject: [RESEND 10/19] crypto: ixp4xx: convert tasklets to use new tasklet_setup() API
Date:   Mon,  7 Dec 2020 14:29:22 +0530
Message-Id: <20201207085931.661267-11-allen.lkml@gmail.com>
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
 drivers/crypto/ixp4xx_crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 276012e7c482..de6b51d030d4 100644
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

