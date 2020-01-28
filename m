Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C62BDC2D0DB
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 21:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B4532465B
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 21:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580245953;
	bh=+XlQwNCZJu8RYt3/XKLDWwgVH4bdgW+X6Z09cM/YyRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=JXu4oOJjY9yx0/+iz07Epu8tg9OSOF5x6pIPG3H/EZqmEabiNCr9y9MhXpU5dFm7m
	 pU7CxN8gyPh+MccQC3lFRPBpI8c3VfFkO8CVwEjeH3XV/NAQTHNfe7VnpABZDMTkQD
	 tk64SdOawHa/0vvP/2WEvBJABcQetwD098sBoX30=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgA1VMc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 16:12:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:41832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgA1VMc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 16:12:32 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A30D32073A;
        Tue, 28 Jan 2020 21:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580245951;
        bh=+XlQwNCZJu8RYt3/XKLDWwgVH4bdgW+X6Z09cM/YyRs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t5+ZXxbtJo+Pwj58JEX5f5g6S1+t8BQb7XneJnuSaP2Ag29e/YYd/0h7SGrOjjazZ
         KTFnpw6EqDuxdbtHBGR0NT47we/zWdma7FXRXLeop299PLXMVGMFxVfX7CFndbAmFA
         PNqU3RMUQ4gkMrpn+GlQDvjOLW67+bG27uOHxnxo=
Date:   Tue, 28 Jan 2020 13:12:30 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>
Subject: Re: Possible issue with new inauthentic AEAD in extended crypto tests
Message-ID: <20200128211229.GA224488@gmail.com>
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com>
 <20200128023455.GC960@sol.localdomain>
 <20200128033824.p3z3jhc7mp7wlikp@gondor.apana.org.au>
 <CAOtvUMeJmhXL2V74e+LGxDEUJcDy5=f+x0MH86eyHq0u=HvKXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOtvUMeJmhXL2V74e+LGxDEUJcDy5=f+x0MH86eyHq0u=HvKXw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 28, 2020 at 09:24:25AM +0200, Gilad Ben-Yossef wrote:
> - The source is presumed to have enough room for both the associated
> data and the plaintext.
> - Unless it's in-place encryption, in which case, you also presume to
> have room for the authentication tag

The authentication tag is part of the ciphertext, not the plaintext.  So the
rule is just that the ciphertext buffer needs to have room for it, not the
plaintext.

Of course, when doing in-place encryption/decryption, the two buffers are the
same, so both will have room for it, even though the tag is only meaningful on
the ciphertext side.  That's just the logical consequence of "in-place".

> - The only way to tell if this is in-place encryption or not is to
> compare the pointers to the source and destination - there is no flag.

Requiring users to remember to provide a flag to indicate in-place
encryption/decryption, in addition to passing the same scatterlist, would make
the API more complex.

> - You can count on the scattergather list not having  a first NULL
> buffer, *unless* the plaintext and associated data length are both
> zero AND it's not in place encryption.
> - You can count on not getting NULL as a scatterlist point, *unless*
> the plaintext and associated data length are both zero AND it's not in
> place encryption. (I'm actually unsure of this one?)

If we consider that the input is not just a scatterlist, but rather a
scatterlist and a length, then these observations are really just "you can
access the first byte, unless the length is 0" -- which is sort of obvious.  And
requiring a dereferencable pointer for length = 0 is generally considered to be
bad API design; see the memcpy() fiasco
(https://www.imperialviolet.org/2016/06/26/nonnull.html).

The API could be simplified by only supporting full scatterlists, but it seems
that users are currently relying on being able to encrypt/decrypt just a prefix.

IMO, the biggest problems with the AEAD API are actually things you didn't
mention, such as the fact that the AAD isn't given in a separate scatterlist,
and that the API only supports scatterlists and not virtual addresses (which
makes it difficult to use in some cases).

In any case we do need much better documentation.  I'm planning to improve some
of the crypto API documentation, but I'll probably do the hash and skcipher
algorithm types first before getting to AEAD.  So if you want to improve the
AEAD documentation in the mean time, please go ahead.

- Eric
