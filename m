Return-Path: <SRS0=gCBe=74=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5407FC433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 07:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BF822068E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 07:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgFOHa2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jun 2020 03:30:28 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48780 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728369AbgFOHa2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jun 2020 03:30:28 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jkjZY-00036T-Me; Mon, 15 Jun 2020 17:30:25 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 15 Jun 2020 17:30:24 +1000
Date:   Mon, 15 Jun 2020 17:30:24 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [v2 PATCH 0/3] crypto: skcipher - Add support for no chaining
 and partial chaining
Message-ID: <20200615073024.GA27015@gondor.apana.org.au>
References: <20200612120643.GA15724@gondor.apana.org.au>
 <E1jjiTA-0005BO-9n@fornost.hmeau.com>
 <1688262.LSb4nGpegl@tauon.chronox.de>
 <20200612121651.GA15849@gondor.apana.org.au>
 <20200612122105.GA18892@gondor.apana.org.au>
 <CAMj1kXGg25JL7WCrspMwB1PVPX6vx-rOCesg08a_Fy26_ET7Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGg25JL7WCrspMwB1PVPX6vx-rOCesg08a_Fy26_ET7Sg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 12, 2020 at 06:10:57PM +0200, Ard Biesheuvel wrote:
>
> First of all, the default fcsize for all existing XTS implementations
> should be -1 as well, given that chaining is currently not supported
> at all at the sckipher interface layer for any of them (due to the
> fact that the IV gets encrypted with a different key at the start of

Sure.  I was just too lazy to actually set the -1 everywhere.  I'll
try to do that before I repost again.

> the operation). This also means it is going to be rather tricky to
> implement for h/w accelerated XTS implementations, and it seems to me
> that the only way to deal with this is to decrypt the IV in software
> before chaining the next operation, which is rather horrid and needs
> to be implemented by all of them.

I don't think we should support chaining for XTS at all so I don't
see why we need to worry about the hardware accelerated XTS code.

> Given that
> 
> a) this is wholly an AF_ALG issue, as there are no in-kernel users
> currently suffering from this afaik,
> b) using AF_ALG to get access to software implementations is rather
> pointless in general, given that userspace can simply issue the same
> instructions directly
> c) fixing all XTS and CTS implementation on all arches and all
> accelerators is not a small task
> 
> wouldn't it be better to special case XTS and CBC-CTS in
> algif_skcipher instead, rather than polluting the skipcher API this
> way?

As I said we need to be able to differentiate between the ones
that can chain vs. the ones that can't.  Putting this knowledge
directly into algif_skcipher is just too horrid.

The alternative is to add this marker into the algorithms.  My
point was that if you're going to do that you might as well go
a step further and allow cts to chain as it is so straightforward.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
