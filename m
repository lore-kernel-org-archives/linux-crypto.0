Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2DB0C282CE
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 09:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1EAE20850
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 09:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfDKJaz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 05:30:55 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:42948 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfDKJag (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 05:30:36 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEW2U-0004Ij-D0; Thu, 11 Apr 2019 17:30:34 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEW2T-0006sr-Gq; Thu, 11 Apr 2019 17:30:33 +0800
Date:   Thu, 11 Apr 2019 17:30:33 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 10/24] crypto: ccree - Forbid 2-key 3DES in FIPS mode
Message-ID: <20190411093033.gdnjdfd536f2vja4@gondor.apana.org.au>
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au>
 <E1hEVQI-0006mq-Kd@gondobar>
 <2919231.mFyek56I8j@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2919231.mFyek56I8j@tauon.chronox.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 11, 2019 at 11:27:54AM +0200, Stephan Mueller wrote:
> Am Donnerstag, 11. April 2019, 10:51:06 CEST schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.
> > 
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > ---
> > 
> >  drivers/crypto/ccree/cc_aead.c |   37 +++++++++++++++++++++++++++++++++++--
> > 1 file changed, 35 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
> > index a3527c00b29a..c5cde327cf1f 100644
> > --- a/drivers/crypto/ccree/cc_aead.c
> > +++ b/drivers/crypto/ccree/cc_aead.c
> > @@ -650,6 +650,39 @@ static int cc_aead_setkey(struct crypto_aead *tfm,
> > const u8 *key, return rc;
> >  }
> > 
> > +static int cc_des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
> > +			       unsigned int keylen)
> 
> This function looks very similar to des3_aead_setkey in the different caam 
> code changes.
> 
> Thus, wouldn't it be better to have common service function?

Sure, we can do that on top of this patch-series.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
