Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC7CBC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Sep 2022 05:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiI3F5O (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Sep 2022 01:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiI3F4z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Sep 2022 01:56:55 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3992D1FD8AF
        for <linux-crypto@vger.kernel.org>; Thu, 29 Sep 2022 22:56:49 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oe90W-00A4qx-Np; Fri, 30 Sep 2022 15:56:21 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Sep 2022 13:56:20 +0800
Date:   Fri, 30 Sep 2022 13:56:20 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     shangxiaojing <shangxiaojing@huawei.com>
Cc:     Neal Liu <neal_liu@aspeedtech.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "andrew@aj.id.au" <andrew@aj.id.au>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -next] crypto: aspeed - Remove redundant dev_err call
Message-ID: <YzaFBPVtJT4hMCvw@gondor.apana.org.au>
References: <20220923100159.15705-1-shangxiaojing@huawei.com>
 <HK0PR06MB320294D6E2A61F85F4276EE780519@HK0PR06MB3202.apcprd06.prod.outlook.com>
 <afde3f5c-32e4-6b89-8d6b-1f4f5a7744c4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afde3f5c-32e4-6b89-8d6b-1f4f5a7744c4@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 23, 2022 at 08:26:21PM +0800, shangxiaojing wrote:
> 
> On 2022/9/23 18:15, Neal Liu wrote:
> > > devm_ioremap_resource() prints error message in itself. Remove the dev_err
> > > call to avoid redundant error message.
> > > 
> > > Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> > > ---
> > >   drivers/crypto/aspeed/aspeed-hace.c | 4 +---
> > >   1 file changed, 1 insertion(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/crypto/aspeed/aspeed-hace.c
> > > b/drivers/crypto/aspeed/aspeed-hace.c
> > > index 3f880aafb6a2..e05c32c31842 100644
> > > --- a/drivers/crypto/aspeed/aspeed-hace.c
> > > +++ b/drivers/crypto/aspeed/aspeed-hace.c
> > > @@ -123,10 +123,8 @@ static int aspeed_hace_probe(struct platform_device
> > > *pdev)
> > >   	platform_set_drvdata(pdev, hace_dev);
> > > 
> > >   	hace_dev->regs = devm_ioremap_resource(&pdev->dev, res);
> > > -	if (IS_ERR(hace_dev->regs)) {
> > > -		dev_err(&pdev->dev, "Failed to map resources\n");
> > > +	if (IS_ERR(hace_dev->regs))
> > >   		return PTR_ERR(hace_dev->regs);
> > > -	}
> > > 
> > >   	/* Get irq number and register it */
> > >   	hace_dev->irq = platform_get_irq(pdev, 0);
> > > --
> > > 2.17.1
> > Similar patch just be proposed few days ago.
> > https://patchwork.kernel.org/project/linux-crypto/patch/20220920032118.6440-1-yuehaibing@huawei.com/
> 
> sorry, pls ignore mine.

Actually I think these two patches are different and both can be
applied.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
