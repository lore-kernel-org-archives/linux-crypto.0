Return-Path: <SRS0=9BFZ=XA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB45EC48BC7
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 13:59:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8E3520820
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Sep 2019 13:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731276AbfIEN7K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Sep 2019 09:59:10 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60636 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726968AbfIEN7K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Sep 2019 09:59:10 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1i5sHy-00012C-NZ; Thu, 05 Sep 2019 23:59:07 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 05 Sep 2019 23:59:02 +1000
Date:   Thu, 5 Sep 2019 23:59:02 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: inside-secure - Fix unused variable warning when
 CONFIG_PCI=n
Message-ID: <20190905135902.GA2312@gondor.apana.org.au>
References: <1567663273-6652-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190905130337.GA31119@gondor.apana.org.au>
 <MN2PR20MB2973E751CAEA963B3C43110ECABB0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB2973E751CAEA963B3C43110ECABB0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 05, 2019 at 01:55:54PM +0000, Pascal Van Leeuwen wrote:
>
> > > index e12a2a3..0f1a9dc 100644
> > > --- a/drivers/crypto/inside-secure/safexcel.c
> > > +++ b/drivers/crypto/inside-secure/safexcel.c
> > > @@ -1503,7 +1503,9 @@ void safexcel_pci_remove(struct pci_dev *pdev)
> > >
> > >  static int __init safexcel_init(void)
> > >  {
> > > +#if IS_ENABLED(CONFIG_PCI)
> > >  	int rc;
> > > +#endif
> > >
> > >  #if IS_ENABLED(CONFIG_OF)
> > >  		/* Register platform driver */
> > 
> > Shouldn't you check for errors for CONFIG_OF too?
>
> You are correct, the platform_driver_register can also return an error 
> code. So just fixing the compile warning was a bit short-sighted on my
> behalf.
> 
> I'll redo that patch.

While you're at it, please fix the strange indentation in that
function too.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
