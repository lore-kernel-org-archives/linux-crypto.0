Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 385EAC49ED6
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 15:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 157BC2089F
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 15:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfIKPpT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 11:45:19 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:59831 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728266AbfIKPpS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 11:45:18 -0400
X-Originating-IP: 148.69.85.38
Received: from localhost (unknown [148.69.85.38])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 7C78A6000F;
        Wed, 11 Sep 2019 15:45:15 +0000 (UTC)
Date:   Wed, 11 Sep 2019 16:45:14 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 2/2] crypto: inside-secure - Add support for the
 Chacha20-Poly1305 AEAD
Message-ID: <20190911154514.GE5492@kwain>
References: <1568126293-4039-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1568126293-4039-3-git-send-email-pvanleeuwen@verimatrix.com>
 <20190911152947.GB5492@kwain>
 <MN2PR20MB297364B0CA33E6B03041D9DECAB10@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MN2PR20MB297364B0CA33E6B03041D9DECAB10@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 11, 2019 at 03:37:25PM +0000, Pascal Van Leeuwen wrote:
> > On Tue, Sep 10, 2019 at 04:38:13PM +0200, Pascal van Leeuwen wrote:
> > > @@ -43,8 +44,8 @@ struct safexcel_cipher_ctx {
> > >
> > >  	u32 mode;
> > >  	enum safexcel_cipher_alg alg;
> > > -	bool aead;
> > > -	int  xcm; /* 0=authenc, 1=GCM, 2 reserved for CCM */
> > > +	char aead; /* !=0=AEAD, 2=IPSec ESP AEAD */
> > > +	char xcm;  /* 0=authenc, 1=GCM, 2 reserved for CCM */
> > 
> > You could use an u8 instead. It also seems the aead comment has an
> > issue, I'll let you check that.
> > 
> I don't see what's wrong with the comment though?
> Anything unequal to 0 is AEAD, with value 2 being the ESP variant.

OK, that wasn't clear to me when I first read it. Maybe you could say
that 1: AEAD, 2: IPsec ESP AEAD; and then of course the check of this
value being > 0 would mean it's one of the two.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
