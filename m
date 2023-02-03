Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A317C61DA4
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Feb 2023 01:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjBCBwa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Feb 2023 20:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjBCBw3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2023 20:52:29 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEF5889A0;
        Thu,  2 Feb 2023 17:52:28 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pNlFB-006zOy-QO; Fri, 03 Feb 2023 09:52:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Feb 2023 09:52:01 +0800
Date:   Fri, 3 Feb 2023 09:52:01 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dhananjay Phadke <dphadke@linux.microsoft.com>
Cc:     Neal Liu <neal_liu@aspeedtech.com>, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-aspeed@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 -next] crypto: aspeed: fix type warnings
Message-ID: <Y9xowUpO+Y7M0hho@gondor.apana.org.au>
References: <20230202070345.191514-1-neal_liu@aspeedtech.com>
 <e2dd4a02-12cb-de5e-4b64-9d6a4a1ad316@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2dd4a02-12cb-de5e-4b64-9d6a4a1ad316@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 02, 2023 at 05:36:05PM -0800, Dhananjay Phadke wrote:
>
> > diff --git a/drivers/crypto/aspeed/aspeed-acry.c b/drivers/crypto/aspeed/aspeed-acry.c
> > index 164c524015f0..f2429e699d14 100644
> > --- a/drivers/crypto/aspeed/aspeed-acry.c
> > +++ b/drivers/crypto/aspeed/aspeed-acry.c
> > @@ -252,7 +252,7 @@ static int aspeed_acry_rsa_ctx_copy(struct aspeed_acry_dev *acry_dev, void *buf,
> >   				    enum aspeed_rsa_key_mode mode)
> >   {
> >   	const u8 *src = xbuf;
> > -	u32 *dw_buf = (u32 *)buf;
> > +	__le32 *dw_buf = (__le32 *)buf;
> 
> All callers are passing acry_dev->buf_addr as buf, can just change that type
> to __le32 * and deref here directly?

As buf is already void *, the cast can simply be removed.
> 
> >   	int nbits, ndw;
> >   	int i, j, idx;
> >   	u32 data = 0;
> > @@ -302,7 +302,7 @@ static int aspeed_acry_rsa_ctx_copy(struct aspeed_acry_dev *acry_dev, void *buf,
> >   static int aspeed_acry_rsa_transfer(struct aspeed_acry_dev *acry_dev)
> >   {
> >   	struct akcipher_request *req = acry_dev->req;
> > -	u8 *sram_buffer = (u8 *)acry_dev->acry_sram;
> > +	u8 __iomem *sram_buffer = (u8 __iomem *)acry_dev->acry_sram;
> 
> u8 cast seems unnecessary, readb takes (void *) and using "+ data_idx"
> offset below anyway.

Either way a cast is unnecessary as (void __iomem *) converts to
(u8 __iomem *) just fine.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
