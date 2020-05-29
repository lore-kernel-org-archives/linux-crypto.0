Return-Path: <SRS0=pw/0=7L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4099C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 08:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC723207F5
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 08:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbgE2IFR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 May 2020 04:05:17 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40314 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgE2IFQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 May 2020 04:05:16 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jea0q-00009x-S2; Fri, 29 May 2020 18:05:09 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 May 2020 18:05:08 +1000
Date:   Fri, 29 May 2020 18:05:08 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC/RFT PATCH 0/2] crypto: add CTS output IVs for arm64 and
 testmgr
Message-ID: <20200529080508.GA2880@gondor.apana.org.au>
References: <20200519190211.76855-1-ardb@kernel.org>
 <20200528073349.GA32566@gondor.apana.org.au>
 <CAMj1kXGkvLP1YnDimdLOM6xMXSQKXPKCEBGRCGBRsWKAQR5Stg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGkvLP1YnDimdLOM6xMXSQKXPKCEBGRCGBRsWKAQR5Stg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 28, 2020 at 10:33:25AM +0200, Ard Biesheuvel wrote:
>
> The reason we return output IVs for CBC is because our generic
> implementation of CTS can wrap any CBC implementation, and relies on
> this output IV rather than grabbing it from the ciphertext directly
> (which may be tricky and is best left up to the CBC code)

No that's not the main reason.  The main user of chaining is
algif_skcipher.

> So if you are saying that we should never split up algif_skcipher
> requests into multiple calls into the underlying skcipher, then I
> agree with you. Even if the generic CTS seems to work more or less as
> expected by, e.g., the NIST validation tool, this is unspecified
> behavior, and definitely broken in various other places.

I was merely suggesting that requests to CTS/XTS shouldn't be
split up.  Doing it for others would be a serious regression.

However, having looked at this it would seem that the effort
in marking CTS/XTS is not that different to just adding support
to hold the last two blocks of data so that CTS/XTS can support
chaining.

I'll work on this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
