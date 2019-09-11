Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EBD8C5ACAE
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 15:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11E0A2085B
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 15:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbfIKPwX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 11:52:23 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:50663 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727581AbfIKPwX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 11:52:23 -0400
Received: from localhost (unknown [148.69.85.38])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 8B60610001A;
        Wed, 11 Sep 2019 15:52:20 +0000 (UTC)
Date:   Wed, 11 Sep 2019 16:52:19 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 1/3] crypto: inside-secure - Added support for basic SM3
 ahash
Message-ID: <20190911155219.GF5492@kwain>
References: <1568187671-8540-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1568187671-8540-2-git-send-email-pvanleeuwen@verimatrix.com>
 <20190911154055.GC5492@kwain>
 <MN2PR20MB2973F633782C5B9DC9E509CBCAB10@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MN2PR20MB2973F633782C5B9DC9E509CBCAB10@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 11, 2019 at 03:47:21PM +0000, Pascal Van Leeuwen wrote:
> > On Wed, Sep 11, 2019 at 09:41:09AM +0200, Pascal van Leeuwen wrote:
> > >  static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
> > > diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-
> > secure/safexcel.h
> > > index 282d59e..fc2aba2 100644
> > > --- a/drivers/crypto/inside-secure/safexcel.h
> > > +++ b/drivers/crypto/inside-secure/safexcel.h
> > > @@ -374,6 +374,7 @@ struct safexcel_context_record {
> > >  #define CONTEXT_CONTROL_CRYPTO_ALG_XCBC192	(0x2 << 23)
> > >  #define CONTEXT_CONTROL_CRYPTO_ALG_XCBC256	(0x3 << 23)
> > >  #define CONTEXT_CONTROL_CRYPTO_ALG_POLY1305	(0xf << 23)
> > > +#define CONTEXT_CONTROL_CRYPTO_ALG_SM3		(0x7 << 23)
> > 
> > Please order the definitions (0x7 before 0xf).
> > 
> While I generally agree with you that having them in order is
> nicer, the other already existing algorithms weren't in order
> either (i.e. SHA224 is 4 but comes before SHA256 which is 3, 
> same  for SHA384 and SHA512), hence I just appended at the 
> end of the list in the order I actually added them.
> 
> Do you want me to put them *all* in order? Because otherwise
> it doesn't make sense to make an exception for SM3.

Yes, that's a good point. I don't have a preference in this specific
case, so I'd say the better is to keep what was done before.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
