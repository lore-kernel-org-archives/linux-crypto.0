Return-Path: <SRS0=R0fc=5X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD6AC2BA16
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Apr 2020 05:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1911020747
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Apr 2020 05:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgDGFRr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Apr 2020 01:17:47 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53450 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbgDGFRr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Apr 2020 01:17:47 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jLgcK-0001xa-Kc; Tue, 07 Apr 2020 15:17:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 07 Apr 2020 15:17:44 +1000
Date:   Tue, 7 Apr 2020 15:17:44 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: crypto: algboss - Avoid spurious modprobe on LOADED
Message-ID: <20200407051744.GA13037@gondor.apana.org.au>
References: <20200407030003.GA12687@gondor.apana.org.au>
 <20200407045835.GA102437@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407045835.GA102437@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 06, 2020 at 09:58:35PM -0700, Eric Biggers wrote:
>
> Needs a Fixes tag?
> 
> Fixes: dd8b083f9a5e ("crypto: api - Introduce notifier for new crypto algorithms")
> Cc: <stable@vger.kernel.org> # v4.20+

Ah thanks, I had thought this was an ancient bug and therefore
the fixes wouldn't have been that useful.  The fact that it is
a recent introduction means that we definitely should have the
tags.

> > diff --git a/crypto/algboss.c b/crypto/algboss.c
> > index 527b44d0af21..01feb8234053 100644
> > --- a/crypto/algboss.c
> > +++ b/crypto/algboss.c
> > @@ -275,7 +275,7 @@ static int cryptomgr_notify(struct notifier_block *this, unsigned long msg,
> >  	case CRYPTO_MSG_ALG_REGISTER:
> >  		return cryptomgr_schedule_test(data);
> >  	case CRYPTO_MSG_ALG_LOADED:
> > -		break;
> > +		return NOTIFY_OK;
> >  	}
> >  
> >  	return NOTIFY_DONE;
> 
> It's hard to remember the difference between NOTIFY_OK and NOTIFY_DONE.  Isn't
> it wrong to call request_module() in the first place for a message that
> "cryptomgr" doesn't care about?  Wouldn't the following make more sense?:

Good point.  Yes we can and should do that here.  Can you post
a patch for this please?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
