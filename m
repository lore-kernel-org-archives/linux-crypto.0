Return-Path: <SRS0=eAV2=DZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 521ECC433DF
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Oct 2020 22:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 047F622272
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Oct 2020 22:29:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MR1QcRmC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbgJRW3R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Oct 2020 18:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgJRW3R (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Oct 2020 18:29:17 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A65C061755
        for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2020 15:29:16 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id j17so8606946ilr.2
        for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2020 15:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=YfRvs1HtjPaz+MrbBnNrMwf8BzmCOHPeo2Mo2In9yD0=;
        b=MR1QcRmCBrD6A3bSeH2DJnk5vNZNKxZvi4gu7DsdI+6kl14CBz8JoHnzt8HsT++ZeX
         Azx/2Sc3K3I2GE9LHtebt8r3APRpIk/dqKItGn6LS/aM5S5ydYJ2xF7Bk4CLi+jjcHDv
         vU6uJZKHbKCreMOCRqBlbfrWE94j43aje2BcJygWWuxw0tyZUxDzhfEd35Az1DSA0eTB
         VxUkyXQ9ZahGc+4xDx9PgWRUGEcB32fF8eB1tMOLZ5mgXCh7f73ncy+ZNYXcMPehlbUN
         qzFullCrKQhwby1jy3ZkhD4sY7HO6mImwB1zid9ziebraVh9s8nmg0n52HakNTf9OLz0
         3LZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=YfRvs1HtjPaz+MrbBnNrMwf8BzmCOHPeo2Mo2In9yD0=;
        b=WEyWvn73qrTNcoEQU3SkNSYweodI3kbGVNe1ghKvNE5SrH7vrl3mKoDkz27UJW0Rij
         ij1AlNcwblvKUFC6oEwNv6LKx79dNppDF8kU0aCtmq7ipQA8LHd3TpmXqKwe2hsG7i98
         xWBJPWexOAEU6isjpd/rMTgELUqWZO4iehLdj166UsyVrl0hwcfKITMWEU6FORjw99VD
         k9KqsIxNLTUx5VnKtnFO9BFpSFukRpNkofIJo8A2cIKHv1b3nKSEUTwszPvt5BaH8nDZ
         4TEyGWw7Tw2Rt9TdJHkaAOSJfdxjD8AuLY6Z3kHFWcSCrF1jGx/HI86ZtK9KF0RwHyFL
         flUQ==
X-Gm-Message-State: AOAM5324C8LxrwrBzUJoVUyRFMzVITNz4xb3OD/RPanaGXjN25SwtA7F
        N2MEEa5bzfc0f/fZEsFFabI=
X-Google-Smtp-Source: ABdhPJxwtwaDbsVjSlrOEkOHZlxeqerQ2uNADYED44vo44iqsK8cd3JnNeqWr7wR/6Jpv+UZncjE4A==
X-Received: by 2002:a05:6e02:d07:: with SMTP id g7mr8683790ilj.7.1603060156175;
        Sun, 18 Oct 2020 15:29:16 -0700 (PDT)
Received: from fedora-thirty-three ([184.170.253.80])
        by smtp.gmail.com with ESMTPSA id t12sm8710772ilh.18.2020.10.18.15.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 15:29:15 -0700 (PDT)
Date:   Sun, 18 Oct 2020 18:29:12 -0400
From:   Nigel Christian <nigel.l.christian@gmail.com>
To:     mpm@selenic.com, herbert@gondor.apana.org.au,
        yuehaibing@huawei.com, hadar.gat@arm.com, martin@kaiser.cx,
        arnd@arndb.de
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH] hwrng: imx-rngc - platform_get_irq() already prints an error
Message-ID: <20201018222912.GA90387@fedora-thirty-three>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There is no need to call the dev_err() function directly to print
a custom message when handling an error from platform_get_irq()
as it prints the appropriate message in the event of a failure.
Change suggested via coccicheck report.

Signed-off-by: Nigel Christian <nigel.l.christian@gmail.com>
---
 drivers/char/hw_random/imx-rngc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
index 61c844baf26e..69f13ff1bbec 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -253,7 +253,6 @@ static int imx_rngc_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq <= 0) {
-		dev_err(&pdev->dev, "Couldn't get irq %d\n", irq);
 		return irq;
 	}
 
-- 
2.28.0

