Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D29C433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 14:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4356F2089E
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 14:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbfG3OJL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 10:09:11 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34549 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728769AbfG3OJL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 10:09:11 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 981BC6000D;
        Tue, 30 Jul 2019 14:09:07 +0000 (UTC)
Date:   Tue, 30 Jul 2019 16:09:07 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 1/3] crypto: inside-secure - add support for
 authenc(hmac(sha1),cbc(des3_ede))
Message-ID: <20190730140907.GH3108@kwain>
References: <1562309364-942-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1562309364-942-2-git-send-email-pvanleeuwen@verimatrix.com>
 <20190726121938.GC3235@kwain>
 <MN2PR20MB2973B64FD27EA16A6FADBAFBCAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB297366400B400A2BD77A0BCFCADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MN2PR20MB297366400B400A2BD77A0BCFCADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 30, 2019 at 02:01:46PM +0000, Pascal Van Leeuwen wrote:
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf Of
> > Pascal Van Leeuwen
> > Sent: Friday, July 26, 2019 2:57 PM
> > To: Antoine Tenart <antoine.tenart@bootlin.com>; Pascal van Leeuwen <pascalvanl@gmail.com>
> > Cc: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; davem@davemloft.net
> > Subject: RE: [PATCH 1/3] crypto: inside-secure - add support for
> > authenc(hmac(sha1),cbc(des3_ede))
> > 
> > > > +	.alg.aead = {
> > > > +		.setkey = safexcel_aead_setkey,
> > > > +		.encrypt = safexcel_aead_encrypt_3des,
> > > > +		.decrypt = safexcel_aead_decrypt_3des,
> > > > +		.ivsize = DES3_EDE_BLOCK_SIZE,
> > > > +		.maxauthsize = SHA1_DIGEST_SIZE,
> > > > +		.base = {
> > > > +			.cra_name = "authenc(hmac(sha1),cbc(des3_ede))",
> > > > +			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-des3_ede",
> > >
> > > You could drop "_ede" here, or s/_/-/.
> > >
> > Agree the underscore should not be there.
> > Our HW does not support any other form of 3DES so EDE doesn't
> > really add much here, therefore I will just remove "_ede" entirely.
> >
> Actually, while looking into fixing this, I noticed that this 
> naming style is actually consistent with the already existing
> 3des ecb and cbc ciphersuites, e.g.: "safexcel-cbc-des3_ebe",
> so for consistency I would then suggest keeping it (or 
> change the other 2 3des references at the same time, but I
> don't know if that would break any legacy dependency).

Good catch :) As you said, you should keep it this way then.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
