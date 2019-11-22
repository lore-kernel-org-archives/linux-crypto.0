Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D31DC432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 08:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27B2320708
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 08:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKVIzf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 03:55:35 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:45594 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbfKVIzf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 03:55:35 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iY4ij-00006J-Er; Fri, 22 Nov 2019 16:55:17 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iY4ie-00050h-Ik; Fri, 22 Nov 2019 16:55:12 +0800
Date:   Fri, 22 Nov 2019 16:55:12 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     Jamie Iles <jamie@jamieiles.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: picoxcell: add missed tasklet_kill
Message-ID: <20191122085512.m75tjfa3valqfgyv@gondor.apana.org.au>
References: <20191115023116.7070-1-hslester96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115023116.7070-1-hslester96@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 15, 2019 at 10:31:16AM +0800, Chuhong Yuan wrote:
> This driver forgets to kill tasklet when probe fails and remove.
> Add the calls to fix it.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Yes this driver does look buggy but I think your patch isn't
enough.

> diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
> index 3cbefb41b099..8d7c6bb2876e 100644
> --- a/drivers/crypto/picoxcell_crypto.c
> +++ b/drivers/crypto/picoxcell_crypto.c
> @@ -1755,6 +1755,7 @@ static int spacc_probe(struct platform_device *pdev)
>  	if (!ret)
>  		return 0;
>  
> +	tasklet_kill(&engine->complete);

The tasklet is schedule by the IRQ handler so you should not kill
it until the IRQ handler has been unregistered.

This driver is also buggy because it registers the IRQ handler
before initialising the tasklet.  You must always be prepared for
spurious IRQs.  IOW, as soon as you register the IRQ handler you
must be prepared for it to be called.

> @@ -1771,6 +1772,7 @@ static int spacc_remove(struct platform_device *pdev)
>  	struct spacc_alg *alg, *next;
>  	struct spacc_engine *engine = platform_get_drvdata(pdev);
>  
> +	tasklet_kill(&engine->complete);

Ditto.

However, the IRQ handler is registered through devm which makes it
hard to kill the tasklet after unregistering it.  We should probably
convert it to a normal request_irq so we can control how it's
unregistered.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
