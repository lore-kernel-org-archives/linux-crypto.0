Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FE9C5ACAE
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 15:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFD76206A5
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 15:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfIKPVL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 11:21:11 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:52965 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfIKPVL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 11:21:11 -0400
X-Originating-IP: 148.69.85.38
Received: from localhost (unknown [148.69.85.38])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 9F8A9240008;
        Wed, 11 Sep 2019 15:21:08 +0000 (UTC)
Date:   Wed, 11 Sep 2019 16:21:07 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] crypto: inside-secure - Added support for the
 CHACHA20 skcipher
Message-ID: <20190911152107.GA5492@kwain>
References: <1568126293-4039-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1568126293-4039-2-git-send-email-pvanleeuwen@verimatrix.com>
 <20190910173246.GA14055@kwain>
 <MN2PR20MB297383846FB390299EFEA0C3CAB60@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MN2PR20MB297383846FB390299EFEA0C3CAB60@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Pascal,

On Tue, Sep 10, 2019 at 06:58:18PM +0000, Pascal Van Leeuwen wrote:
> > On Tue, Sep 10, 2019 at 04:38:12PM +0200, Pascal van Leeuwen wrote:
> > > @@ -112,7 +123,7 @@ static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx, u8
> > *iv,
> > >  			block_sz = DES3_EDE_BLOCK_SIZE;
> > >  			cdesc->control_data.options |= EIP197_OPTION_2_TOKEN_IV_CMD;
> > >  			break;
> > > -		case SAFEXCEL_AES:
> > > +		default: /* case SAFEXCEL_AES */
> > 
> > Can't you keep an explicit case here?
> > 
> If I do that, the compiler will complain about SAFEXCEL_CHACHA20 not
> being covered. And Chacha20 won't even make it this far, so it doesn't
> make much sense to add that to the switch.
> 
> I suppose an explicit case plus an empty default would be an alternative?
> But I figured the comment should suffice to remind anyone working on that
> switch statement what it should really do. I'm fine with either approach.

Yes, please use an explicit case and an empty default.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
