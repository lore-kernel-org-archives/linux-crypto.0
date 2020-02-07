Return-Path: <SRS0=xktg=33=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE33C2D0B1
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 07:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1618214AF
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 07:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581060432;
	bh=T5v6bxB/Bk31esV16H2qf7S1vaaIWC3GRdkyumus3Ew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=q609J1HFXyCxPc9hCeor0YGSZ7hBB+ilEGKA4uKm1aeloTsz88NsJzHnXn4t0UNmw
	 h1SdzeSYq5I1dIi048OjbcNrdDzQ9seVgQ8H6dhS7S12dOicuT1mZHjYdwU1UK2RUb
	 SHBO3OGdE14Tn0YRxWROZpUXPmM+1gDfBPef6ahM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgBGH1L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Feb 2020 02:27:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:43982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgBGH1L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Feb 2020 02:27:11 -0500
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 918962082E;
        Fri,  7 Feb 2020 07:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581060430;
        bh=T5v6bxB/Bk31esV16H2qf7S1vaaIWC3GRdkyumus3Ew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Eb8SUoIV/b7KS1r0NnXcOx6IxvUsyLszTT5QHmHLP/gevgTFS88YNJ43I6e9r+yo2
         Gx7lU9CBqGdlHj6LSMn1is0nOKa9Q9uDJlJTcBcdw/srkVazQof5aZa484YjXITwCc
         p5evXeuvfoKtRBzxEBRB/0itj7rwblxSiNYqbXSI=
Date:   Thu, 6 Feb 2020 23:27:09 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>
Subject: Re: Possible issue with new inauthentic AEAD in extended crypto tests
Message-ID: <20200207072709.GB8284@sol.localdomain>
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com>
 <20200128023455.GC960@sol.localdomain>
 <20200128033824.p3z3jhc7mp7wlikp@gondor.apana.org.au>
 <CAOtvUMeJmhXL2V74e+LGxDEUJcDy5=f+x0MH86eyHq0u=HvKXw@mail.gmail.com>
 <20200128211229.GA224488@gmail.com>
 <CAOtvUMeVXTDvH5bxVFemYmD9rpZ=xX3MkypAGyZn5VROw6sgZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOtvUMeVXTDvH5bxVFemYmD9rpZ=xX3MkypAGyZn5VROw6sgZg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 05, 2020 at 04:48:16PM +0200, Gilad Ben-Yossef wrote:
> Probably another issue with my driver, but just in case -
> include/crypot/aead.h says:
> 
>  * The scatter list pointing to the input data must contain:
>  *
>  * * for RFC4106 ciphers, the concatenation of
>  *   associated authentication data || IV || plaintext or ciphertext. Note, the
>  *   same IV (buffer) is also set with the aead_request_set_crypt call. Note,
>  *   the API call of aead_request_set_ad must provide the length of the AAD and
>  *   the IV. The API call of aead_request_set_crypt only points to the size of
>  *   the input plaintext or ciphertext.
> 
> I seem to be missing the place where this is handled in
> generate_random_aead_testvec()
> and generate_aead_message()
> 
> We seem to be generating a random IV for providing as the parameter to
> aead_request_set_crypt()
> but than have other random bytes set in aead_request_set_ad() - or am
> I'm missing something again?

Yes, for rfc4106 the tests don't pass the same IV in both places.  This is
because I wrote the tests from the perspective of a generic AEAD that doesn't
have this weird IV quirk, and then I added the minimum quirks to get the weird
algorithms like rfc4106 passing.

Since the actual behavior of the generic implementation of rfc4106 is that the
last 8 bytes of the AAD are ignored, that means that currently the tests just
avoid mutating these bytes when generating inauthentic input tests.  They don't
know that they're (apparently) meant to be another copy of the IV.

So it seems we need to clearly define the behavior when the two IV copies don't
match.  Should one or the other be used, should an error be returned, or should
the behavior be unspecified (in which case the tests would need to be updated)?

Unspecified behavior is bad, but it would be easiest for software to use
req->iv, while hardware might want to use the IV in the scatterlist...

Herbert and Stephan, any idea what was intended here?

- Eric
