Return-Path: <SRS0=vxh5=N7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EFEFC18DF5
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Nov 2018 14:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3382720831
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Nov 2018 14:19:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3382720831
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbeKUAsn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Nov 2018 19:48:43 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:47178 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbeKUAsm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 19:48:42 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gP6rm-0002Mw-Ub; Tue, 20 Nov 2018 22:19:02 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gP6ra-0002S0-8g; Tue, 20 Nov 2018 22:18:50 +0800
Date:   Tue, 20 Nov 2018 22:18:50 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Greg Kaiser <gkaiser@google.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>,
        Martin Willi <martin@strongswan.org>
Subject: Re: [RFC PATCH v2 0/4] Exporting existing crypto API code through
 zinc
Message-ID: <20181120141850.zjmfwcari5kykk6y@gondor.apana.org.au>
References: <20181105232526.173947-1-ebiggers@kernel.org>
 <20181105232526.173947-11-ebiggers@kernel.org>
 <CAKv+Gu-o0khD5=0EOkv2PiczMs5uZ=XP9V=G2ogBNMK8Kb93sw@mail.gmail.com>
 <20181112185816.GA8663@gmail.com>
 <20181116060227.hwu4igi6bp26ddpi@gondor.apana.org.au>
 <20181117001718.GA175522@gmail.com>
 <CAHmME9rtsCk8ZLt05xRKMGr4CVRnaUvCaVOS_WX3N22HOat4-A@mail.gmail.com>
 <20181119052451.qttzfgcm4hvbdc4u@gondor.apana.org.au>
 <20181120060217.t4nccaqpwnxkl4tx@gondor.apana.org.au>
 <CAKv+Gu-SHS2tF665dfqSgmH5EF5vGVtef=3_4WgCE=+8+Jw7Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-SHS2tF665dfqSgmH5EF5vGVtef=3_4WgCE=+8+Jw7Rw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181120141850.Vu_NQmy2X9tRqF7Lw-vJb3-8PxIsERVjkb10NGCnGNY@z>

Hi Ard:

On Tue, Nov 20, 2018 at 11:32:05AM +0100, Ard Biesheuvel wrote:
>
> > 1. The crypto API algorithms remain individually accessible, this
> > is crucial as these algorithm names are exported to user-space so
> > changing the names to foo-zinc is not going to work.
> 
> Are you saying user space may use names like "ctr-aes-neon" directly
> rather than "ctr(aes)" for any implementation of the mode?

Yes.  In fact it's used for FIPS certification testing.

> If so, that is highly unfortunate, since it means we'd be breaking
> user space by wrapping a crypto library function with its own arch
> specific specializations into a generic crypto API wrapper.

You can never break things by introducing new algorithms.  The
problem is only when you remove existing ones.

> Note that I think that using AF_ALG to access software crypto routines
> (as opposed to accelerators) is rather pointless to begin with, but if
> it permits that today than we're stuck with it.

Sure, nobody sane should be doing it.  But when it comes to
government certification... :)

> > 2. The arch-specific algorithm code lives in their own module rather
> > than in a monolithic module.
> 
> This is one of the remaining issues I have with Zinc. However, modulo
> the above concerns, I think it does make sense to have a separate
> function API for synchronous software routines below the current
> crypto API. What I don't want is a separate Zinc kingdom with a
> different name, different maintainers and going through a different
> tree, and with its own approach to test vectors, arch specific code,
> etc etc

Even without the issue of replacing chacha20-generic with
chacha20-zinc which breaks point 1 above, we simply don't want
or need to go through zinc's run-time implementation choice for
the crypto API algorithms.  They've already paid for the indirect
function call so why make them go through yet another run-time
branch?

If the optics of having the code in crypto is the issue, we could
move the actual algorithm code into a third location, perhaps
arch/x86/crypto/lib or arch/x86/lib/crypto.  Then both zinc and
the crypto API can sit on top of that.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
