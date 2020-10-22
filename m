Return-Path: <SRS0=kAoH=D5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E17A0C388F7
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Oct 2020 20:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94F6F24655
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Oct 2020 20:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371831AbgJVUkZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Oct 2020 16:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371812AbgJVUkX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Oct 2020 16:40:23 -0400
X-Greylist: delayed 1383 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 22 Oct 2020 13:40:23 PDT
Received: from viti.kaiser.cx (viti.kaiser.cx [IPv6:2a01:238:43fe:e600:cd0c:bd4a:7a3:8e9f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87310C0613CE
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2020 13:40:23 -0700 (PDT)
Received: from martin by viti.kaiser.cx with local (Exim 4.89)
        (envelope-from <martin@viti.kaiser.cx>)
        id 1kVh0n-0003eP-EN; Thu, 22 Oct 2020 22:16:37 +0200
Date:   Thu, 22 Oct 2020 22:16:37 +0200
From:   Martin Kaiser <martin@kaiser.cx>
To:     Nigel Christian <nigel.l.christian@gmail.com>
Cc:     mpm@selenic.com, herbert@gondor.apana.org.au,
        yuehaibing@huawei.com, hadar.gat@arm.com, arnd@arndb.de,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] hwrng: imx-rngc - platform_get_irq() already prints an
 error
Message-ID: <20201022201637.w26kfecc553mqx6g@viti.kaiser.cx>
References: <20201018222912.GA90387@fedora-thirty-three>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201018222912.GA90387@fedora-thirty-three>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: Martin Kaiser <martin@viti.kaiser.cx>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thus wrote Nigel Christian (nigel.l.christian@gmail.com):

> There is no need to call the dev_err() function directly to print
> a custom message when handling an error from platform_get_irq()
> as it prints the appropriate message in the event of a failure.
> Change suggested via coccicheck report.

> Signed-off-by: Nigel Christian <nigel.l.christian@gmail.com>
> ---
>  drivers/char/hw_random/imx-rngc.c | 1 -
>  1 file changed, 1 deletion(-)

> diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
> index 61c844baf26e..69f13ff1bbec 100644
> --- a/drivers/char/hw_random/imx-rngc.c
> +++ b/drivers/char/hw_random/imx-rngc.c
> @@ -253,7 +253,6 @@ static int imx_rngc_probe(struct platform_device *pdev)

>  	irq = platform_get_irq(pdev, 0);
>  	if (irq <= 0) {
> -		dev_err(&pdev->dev, "Couldn't get irq %d\n", irq);
>  		return irq;
>  	}

Looks good to me. This suppresses the error message if platform_get_irq
returns -EPROBE_DEFER, which makes more sense than the current code.

Reviewed-by: Martin Kaiser <martin@kaiser.cx>
