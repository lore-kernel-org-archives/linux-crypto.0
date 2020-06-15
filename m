Return-Path: <SRS0=gCBe=74=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FED8C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 18:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FCA520768
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 18:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592247031;
	bh=5VZ0RoELgjwUgUVHWg+4fR0DHRJwgkMCxoNNz9kAxZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=MfpoNjlLEz0Pd5FS0qL1vmAsQZ2tHzu0o0Di4bpF+/nyT3QDB85tIftT//b7kSKLg
	 tEmddO2qiH70NhP4c7euyvq2WvOkjULZ7wblkrHe8IQhBRcP6di++hm1fpxe6/HQUG
	 PxOqVt58+a3jjcuBP4oE1sOXrUW6rig2EEXZR8+4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729842AbgFOSua (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jun 2020 14:50:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729354AbgFOSua (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jun 2020 14:50:30 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76946206DB;
        Mon, 15 Jun 2020 18:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592247029;
        bh=5VZ0RoELgjwUgUVHWg+4fR0DHRJwgkMCxoNNz9kAxZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NCoD7D+oIwa8SzF95oF3jRHXOLotDA+aAhfww08vEeM77OEZLYZn6pHHfSTUIdCHr
         3RYXDnH0L5aWNVauy/cFbxaRXx7QEpCBMVpfHlCMdQK0vHotXtI+UU4t8EO4TvPmG3
         0hI1Gx1lqIPIKNM0KMrGBpGFKB378EQ2H3UskojM=
Date:   Mon, 15 Jun 2020 11:50:28 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 0/3] crypto: skcipher - Add support for no chaining
 and partial chaining
Message-ID: <20200615185028.GB85413@gmail.com>
References: <20200612120643.GA15724@gondor.apana.org.au>
 <E1jjiTA-0005BO-9n@fornost.hmeau.com>
 <1688262.LSb4nGpegl@tauon.chronox.de>
 <20200612121651.GA15849@gondor.apana.org.au>
 <20200612122105.GA18892@gondor.apana.org.au>
 <CAMj1kXGg25JL7WCrspMwB1PVPX6vx-rOCesg08a_Fy26_ET7Sg@mail.gmail.com>
 <20200615073024.GA27015@gondor.apana.org.au>
 <CAMj1kXHQNHh4PTLmGKaL+sSyuU1AS4u5F=OyjV6XuAaD21e6yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHQNHh4PTLmGKaL+sSyuU1AS4u5F=OyjV6XuAaD21e6yg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 15, 2020 at 09:50:50AM +0200, Ard Biesheuvel wrote:
> On Mon, 15 Jun 2020 at 09:30, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Fri, Jun 12, 2020 at 06:10:57PM +0200, Ard Biesheuvel wrote:
> > >
> > > First of all, the default fcsize for all existing XTS implementations
> > > should be -1 as well, given that chaining is currently not supported
> > > at all at the sckipher interface layer for any of them (due to the
> > > fact that the IV gets encrypted with a different key at the start of
> >
> > Sure.  I was just too lazy to actually set the -1 everywhere.  I'll
> > try to do that before I repost again.
> >
> 
> Fair enough
> 
> > > the operation). This also means it is going to be rather tricky to
> > > implement for h/w accelerated XTS implementations, and it seems to me
> > > that the only way to deal with this is to decrypt the IV in software
> > > before chaining the next operation, which is rather horrid and needs
> > > to be implemented by all of them.
> >
> > I don't think we should support chaining for XTS at all so I don't
> > see why we need to worry about the hardware accelerated XTS code.
> >
> 
> I would prefer that. But if it is fine to disallow chaining altogether
> for XTS, why can't we do the same for cbc-cts? In both cases, user
> space cannot be relying on it today, since the output is incorrect,
> even for inputs that are a round multiple of the block size but are
> broken up and chained.
> 
> > > Given that
> > >
> > > a) this is wholly an AF_ALG issue, as there are no in-kernel users
> > > currently suffering from this afaik,
> > > b) using AF_ALG to get access to software implementations is rather
> > > pointless in general, given that userspace can simply issue the same
> > > instructions directly
> > > c) fixing all XTS and CTS implementation on all arches and all
> > > accelerators is not a small task
> > >
> > > wouldn't it be better to special case XTS and CBC-CTS in
> > > algif_skcipher instead, rather than polluting the skipcher API this
> > > way?
> >
> > As I said we need to be able to differentiate between the ones
> > that can chain vs. the ones that can't.  Putting this knowledge
> > directly into algif_skcipher is just too horrid.
> >
> 
> No disagreement on the horrid. But polluting the API for an issue that
> only affects AF_ALG, which can't possibly be working as expected right
> now is not a great thing either.
> 
> > The alternative is to add this marker into the algorithms.  My
> > point was that if you're going to do that you might as well go
> > a step further and allow cts to chain as it is so straightforward.
> >
> 
> Given the fact that algos that require chaining are broken today and
> nobody noticed until Stephan started relying on the skcipher request
> object's IV field magically retaining its value on subsequent reuse, I
> would prefer it if we could simply mark all of them as non-chainable
> and be done with it. (Note that Stephan's case was invalid to begin
> with)

Wouldn't it make a lot more sense to make skcipher algorithms non-chainable by
default, and only opt-in the ones where chaining is actually working?  At the
moment we only test iv_out for CBC and CTR, so we can expect that all the others
are broken.

Note that wide-block modes such as Adiantum don't support chaining either.

Also, please use a better name than "fcsize".

- Eric
