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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04FAEC433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0EFF23341
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 09:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgLGJCP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgLGJCP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 04:02:15 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6AFC0613D0
        for <linux-crypto@vger.kernel.org>; Mon,  7 Dec 2020 01:01:38 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id p4so3296167pfg.0
        for <linux-crypto@vger.kernel.org>; Mon, 07 Dec 2020 01:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TNGOSyD9pvSkFWvUcTJ6vgncpYFYELUqqTXdTgopIzw=;
        b=YqEgtCO1VCHtD+TPIaRKXJ6nBtvUPhRnW/tZPf/a0BgypZWAHgfVxRoTim5JqfLihs
         UL2bYIdD5/vDeoMGHtIle8YMfNtVnVPxEm5E83GR8sO1N4xi1Cwdn+R/WNTk7ERdTX/1
         Dn0qiCtN7JioHWCQPTVKhylS21nJx/gLtzAHDjB9j2Amnb/QhmVPM3iQioP4PL6tCAvy
         0X5d8A7XoL9ZVXHuYOP9AgGpJUDgYpf27HByfom2KBC6V14EfD+DlKu2qHtuicN18F1L
         DVKcy4cQdn8WzfzslL2yKwAo7lC9Rl7bh5JA5FylJKOeO/GT0d3iTiaEM1u+YDm6y8FP
         xNqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TNGOSyD9pvSkFWvUcTJ6vgncpYFYELUqqTXdTgopIzw=;
        b=nJQiqrKru2etzx6kPVjmiljOMcW5LnLNMoES5xa7Gw9Kep4P+A/npSgbJ7YehIfPpJ
         ND9rT+h5vRPfMb/Y3nH0UPMEdkNeOAOdHU5Dijs5idzWHXOp45Un/2bC9nMe/J4Z986F
         JpzFAWImxfDwHF/X0RxEqDS68Hls75ntS5oys0yN2p8kN/GXmH27OIpNXlWX89IeUKWH
         uxmC1nTAKzhe2gMwk+ffug05cCmphmV7Buhuzj/WGxiXKCjoR8waZcaq0QfJHAVw2I8K
         m0o7MC+UYo2slvdqSSxCs9D6FZ9hY+Tq85XRzJduA+5sPuPFoHGEKYOmto9xm+ZNYCv/
         OJzQ==
X-Gm-Message-State: AOAM532Y2GV4+ArLIlHecbdbDhxyMHT9yCxMTjXdFtJb5wYGfz7tT7Gb
        HDNmz1e6tmFy70DzMTqEihw=
X-Google-Smtp-Source: ABdhPJzH1NILmg8DaeKOl+ffgiDfnXwTRLvgsjb1J+cmX1q14iDLXGQW0UtcBx1ObaHchTs716peTQ==
X-Received: by 2002:aa7:82c1:0:b029:19e:3672:50ca with SMTP id f1-20020aa782c10000b029019e367250camr685546pfn.12.1607331697836;
        Mon, 07 Dec 2020 01:01:37 -0800 (PST)
Received: from localhost.localdomain ([49.207.208.18])
        by smtp.gmail.com with ESMTPSA id w200sm11325029pfc.14.2020.12.07.01.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 01:01:37 -0800 (PST)
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
Subject: [RESEND 17/19] crypto: s5p: convert tasklets to use new tasklet_setup() API
Date:   Mon,  7 Dec 2020 14:29:29 +0530
Message-Id: <20201207085931.661267-18-allen.lkml@gmail.com>
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
 drivers/crypto/s5p-sss.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 88a6c853ffd7..81d5222d5e63 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -1444,9 +1444,9 @@ static int s5p_hash_handle_queue(struct s5p_aes_dev *dd,
  * s5p_hash_tasklet_cb() - hash tasklet
  * @data:	ptr to s5p_aes_dev
  */
-static void s5p_hash_tasklet_cb(unsigned long data)
+static void s5p_hash_tasklet_cb(struct tasklet_struct *t)
 {
-	struct s5p_aes_dev *dd = (struct s5p_aes_dev *)data;
+	struct s5p_aes_dev *dd = from_tasklet(dd, t, hash_tasklet);
 
 	if (!test_bit(HASH_FLAGS_BUSY, &dd->hash_flags)) {
 		s5p_hash_handle_queue(dd, NULL);
@@ -1974,9 +1974,9 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 	s5p_aes_complete(req, err);
 }
 
-static void s5p_tasklet_cb(unsigned long data)
+static void s5p_tasklet_cb(struct tasklet_struct *t)
 {
-	struct s5p_aes_dev *dev = (struct s5p_aes_dev *)data;
+	struct s5p_aes_dev *dev = from_tasklet(dev, t, tasklet);
 	struct crypto_async_request *async_req, *backlog;
 	struct s5p_aes_reqctx *reqctx;
 	unsigned long flags;
@@ -2257,7 +2257,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, pdata);
 	s5p_dev = pdata;
 
-	tasklet_init(&pdata->tasklet, s5p_tasklet_cb, (unsigned long)pdata);
+	tasklet_setup(&pdata->tasklet, s5p_tasklet_cb);
 	crypto_init_queue(&pdata->queue, CRYPTO_QUEUE_LEN);
 
 	for (i = 0; i < ARRAY_SIZE(algs); i++) {
@@ -2267,8 +2267,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	}
 
 	if (pdata->use_hash) {
-		tasklet_init(&pdata->hash_tasklet, s5p_hash_tasklet_cb,
-			     (unsigned long)pdata);
+		tasklet_setup(&pdata->hash_tasklet, s5p_hash_tasklet_cb);
 		crypto_init_queue(&pdata->hash_queue, SSS_HASH_QUEUE_LENGTH);
 
 		for (hash_i = 0; hash_i < ARRAY_SIZE(algs_sha1_md5_sha256);
-- 
2.25.1

