Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CAA5C004D4
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Jan 2023 09:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjASJ6X (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Jan 2023 04:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbjASJ6L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Jan 2023 04:58:11 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0531F6C556
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jan 2023 01:58:00 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pIRgD-001hed-8l; Thu, 19 Jan 2023 17:57:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 19 Jan 2023 17:57:57 +0800
Date:   Thu, 19 Jan 2023 17:57:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: xts - Handle EBUSY correctly
Message-ID: <Y8kUJZfZ1+wQnMO0@gondor.apana.org.au>
References: <Y8kInrsuWybCTgK0@gondor.apana.org.au>
 <CAMj1kXGPqHsHSkj+hV_AcwPZxmWMi_=sVBHQWckUPomh6D7uGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGPqHsHSkj+hV_AcwPZxmWMi_=sVBHQWckUPomh6D7uGg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 19, 2023 at 10:50:26AM +0100, Ard Biesheuvel wrote:
> On Thu, 19 Jan 2023 at 10:08, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > As it is xts only handles the special return value of EINPROGERSS,
> 
> EINPROGRESS

Thanks, I will fix this.

> > -               rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
> > +               rctx->subreq.base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
> 
> I don't get this bit. We used to preserve CRYPTO_TFM_REQ_MAY_BACKLOG
> before (along with all other flags except MAY_SLEEP), but now, we
> *only* preserve CRYPTO_TFM_REQ_MAY_BACKLOG.

This change is just in case we introduce any more flags in
future that we may not wish to pass along (as this code knows
nothing about it).

> So how is this related? Why are we clearing
> CRYPTO_TFM_REQ_FORBID_WEAK_KEYS here for instance?

WEAK_KEYS is only defined for setkey.  Only MAY_SLEEP and MAY_BACKLOG
are currently meaningful for encryption and decryption.

> Apologies for the noob questions about this aspect of the crypto API,
> but I suppose this means that, if CRYPTO_TFM_REQ_MAY_BACKLOG was
> specified, it is up to the skcipher implementation to queue up the
> request and return -EBUSY, as opposed to starting the request
> asynchronously and returning -EINPROGRESS?
> 
> So why the distinction? If the skcipher signals that the request is
> accepted and will complete asynchronously, couldn't it use EINPROGRESS
> for both cases? Or is the EBUSY interpreted differently by the caller,
> for providing back pressure to the source?

EBUSY signals to the caller that it must back off and not issue
any more requests.  The caller should wait for a completion call
with EINPROGRESS to indicate that it may issue new requests.

For xts we essentially ignore EBUSY at this point, and assume that
if our own caller issued any more requests it would directly get
an EBUSY which should be sufficient to avoid total collapse.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
