Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7A8C4649E
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 15:50:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FE2A2184C
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 15:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbfGEPuv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 11:50:51 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:53381 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728168AbfGEPuv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 11:50:51 -0400
Received: from localhost (lfbn-1-2078-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 199DD100002;
        Fri,  5 Jul 2019 15:50:43 +0000 (UTC)
Date:   Fri, 5 Jul 2019 17:50:41 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Subject: Re: [PATCH 2/9] crypto: inside-secure - silently return -EINVAL for
 input error cases
Message-ID: <20190705155041.GI3926@kwain>
References: <1562078400-969-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1562078400-969-5-git-send-email-pvanleeuwen@verimatrix.com>
 <20190705143624.GF3926@kwain>
 <MN2PR20MB2973EA3AB4B166A95AA3DF6DCAF50@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MN2PR20MB2973EA3AB4B166A95AA3DF6DCAF50@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 05, 2019 at 02:43:16PM +0000, Pascal Van Leeuwen wrote:
> > From: Antoine Tenart <antoine.tenart@bootlin.com>
> > On Tue, Jul 02, 2019 at 04:39:53PM +0200, Pascal van Leeuwen wrote:
> > > From: Pascal van Leeuwen <pvanleeuwen@insidesecure.com>
> > 
> > > +	if (rdesc->descriptor_overflow)
> > > +		dev_err(priv->dev, "Descriptor overflow detected");
> > > +
> > > +	if (rdesc->buffer_overflow)
> > > +		dev_err(priv->dev, "Buffer overflow detected");
> > 
> > You're not returning an error here, is there a reason for that?
> > 
> I guess the reason for that would be that it's a driver internal error, but the
> result may still be just fine ... so I do want testmgr to continue its checks.
> These should really only fire during driver development, see answer below.
> 
> > I also remember having issues when adding those checks a while ago, Did
> > you see any of those two error messages when using the crypto engine?
> > 
> Only during development when I implemented things not fully correctly.

OK, that makes sense.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
