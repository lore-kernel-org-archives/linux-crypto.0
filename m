Return-Path: <SRS0=z7PZ=EE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C3EC56201
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Oct 2020 00:53:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DB44208C3
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Oct 2020 00:53:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G2vDIVHW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgJ2AxM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Oct 2020 20:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgJ2AwV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Oct 2020 20:52:21 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5DAC0613CF;
        Wed, 28 Oct 2020 17:52:21 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id u62so1564985iod.8;
        Wed, 28 Oct 2020 17:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=qYfouXO8KCaYN4zQ36HTIQpNGijmRLMWaq601lgAgNU=;
        b=G2vDIVHWR7/IySHEfb2dLNbCkBqSEU5VvJPZJRUp/kBh6zWjJfcvZQTwD5bQcrVpyj
         Lgu+oF51MHKub9m/z5fVoCaqEKrNRX3xwQZjygoSPFi2pCex2hHIrsYOyUlc9OM1ShKV
         sIJLBedc4BovIGspIoi2hqzmO2iF+G49bbyR7PnRVWUX2CUWRorq4Mn1rPiNMUTAuyLS
         6EsrhHnMZ7ka+rJbM47rmiHwKbvTI3YFcjPsrKppesVyX47nHLFDJL+ymF9xnk+G8Lk6
         znxTNvg7a7V9mx1E6gfw8djo1TWbJSE+Ala0MPFZGKadfWG+LJ72Npd0qjS6BkfDzb76
         vSHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=qYfouXO8KCaYN4zQ36HTIQpNGijmRLMWaq601lgAgNU=;
        b=cjYDYwkTdzseqnr4gUrcMIfTMoGKIS4Kk6h3ZD9XMnzdNnfBKXfKA46oJrWaUU3XkH
         uxtOiwe2B0NagDRm+EtMkWYnconiTFHDNpj8GAi6+7bGUw8r2hdAFqTopmVAUcc8NxSA
         FukvlsmWSetbfnR5bsinsz6v6lFFmjghjLAN7cw/1SPS1Da1NbcZRHAvrygZBoVQE/se
         O1otKDz0dnPTVj3R3PTli0Fbe+bXmtqrdBK7gaoidyymZbcHsWj6+T6VBH2hBU9NraDL
         iiUZm8h7/rxkmNff29+8tD9zqGZ4BManEHOfYv78lNphT1nAWv+UT/RHURqRDooFlbPl
         CIow==
X-Gm-Message-State: AOAM53130jStcOnVwLM5pRLOal5ddPGdLXVgvlxnrpgAeKL6csa6ZUDm
        SjFaS2v4qykNWzvjrbVJ0EU=
X-Google-Smtp-Source: ABdhPJyJf1tSyGy80LhBfMuk+K/qeOqKhP54ePbdXLX+pW7phQWZckMRKslk5bWBBhJ6e0DrKDx4Hg==
X-Received: by 2002:a5e:930d:: with SMTP id k13mr1593676iom.33.1603932740730;
        Wed, 28 Oct 2020 17:52:20 -0700 (PDT)
Received: from fedora-project ([185.240.246.172])
        by smtp.gmail.com with ESMTPSA id r14sm1026454ilc.78.2020.10.28.17.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 17:52:20 -0700 (PDT)
Date:   Wed, 28 Oct 2020 20:52:17 -0400
From:   Nigel Christian <nigel.l.christian@gmail.com>
To:     dan.carpenter@oracle.com, martin@kaiser.cx
Cc:     mpm@selenic.com, herbert@gondor.apana.org.au, shawnguo@kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
        linux-imx@nxp.com, linux-crypto@vger.kernel.org,
        prasannatsmkumar@gmail.com, m.felsch@pengutronix.de,
        kernel-janitors@vger.kernel.org
Subject: [PATCH resend] hwrng: imx-rngc - irq already prints an error
Message-ID: <20201029005217.GA28008@fedora-project>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Clean up the check for irq. dev_err() is superfluous as
platform_get_irq() already prints an error. Check for zero
would indicate a bug. Remove curly braces to conform to
styling requirements.
Signed-off-by: Nigel Christian <nigel.l.christian@gmail.com>
---
 drivers/char/hw_random/imx-rngc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
index 61c844baf26e..b05d676ca814 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -252,10 +252,8 @@ static int imx_rngc_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0) {
-		dev_err(&pdev->dev, "Couldn't get irq %d\n", irq);
+	if (irq < 0)
 		return irq;
-	}
 
 	ret = clk_prepare_enable(rngc->clk);
 	if (ret)
-- 
2.28.0

