Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDE5C433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 19:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A444A6162B
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 19:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbhEKTc0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 May 2021 15:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:32782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231454AbhEKTc0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 May 2021 15:32:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EACE6162B;
        Tue, 11 May 2021 19:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620761479;
        bh=ltm7Qvvsrf9/bNVssnd1NXrjG9EJr/zjqPxJ0d5MSn8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W+58nwv+UKr/4MKHZ6S0NvZSGAaMy/btFugbvHAF/TPc0ww0yrt+BRLQiAxa0ClUm
         o9gGZxgdJ4LvQAvR7xkp/CuEoxAmTQ9noA5Bi7WnSSm8DOaP1PMZIBb0JtstfbfZbC
         iA407iWshf8p3TnoXYo2fplV1v8YAIEtEEgCj2ZU26+rh9qUt0GG0z0EHJnhUCgXMW
         oW+Yeg0CFziBDSF6/DIrohcXJkkejmG05i00l6lDJ60bji32alVzpefS7avHxuVx2u
         MV1K0MdP/c2iaW7+WQe5w5tM9wnm18Q6pMNbdnWYcwlhpjZtGnpOBNIb8jHcgol2qb
         t1D6wiTQGyYJg==
Date:   Tue, 11 May 2021 12:31:17 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mike Brooks <m@ib.tc>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Kestrel seventyfour <kestrelseventyfour@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: or should block size for xts.c set to 1 instead of AES block
 size?
Message-ID: <YJrbhR/EruMOMHd9@gmail.com>
References: <CAE9cyGTQZXW-6YsmHu3mGSHonTztBszqaYske7PKgz0pWHxQKA@mail.gmail.com>
 <CAMj1kXHOVRDAt7-C8UKi=5=MAgQ9kQz=HUtiuK_gt7ch_i950w@mail.gmail.com>
 <CALFqKjQVz7xyEZN0XWdGGHOfP4wRMsnU6amN11ege0XXbhQq8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALFqKjQVz7xyEZN0XWdGGHOfP4wRMsnU6amN11ege0XXbhQq8Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 11, 2021 at 11:01:11AM -0700, Mike Brooks wrote:
> xst(ecb()) can only produce a minimum of AES_BLOCK_SIZE of data -
> sending in a smaller dataset will still return AES_BLOCK_SIZE of data.
> If you try and pass in lets say 4 bytes - and then you truncate the
> response to 4 bytes you'll lose data.
> 
> Moving to a smaller size is asking for trouble. IMHO.
> 
> -Michael Brooks
> 
> On Tue, May 11, 2021 at 8:48 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > On Fri, 7 May 2021 at 08:12, Kestrel seventyfour
> > <kestrelseventyfour@gmail.com> wrote:
> > >
> > > Hi,
> > >
> > > one more thought, shouldn't the block size for generic xts set to 1 in
> > > order to reflect that any input size length is allowed to the
> > > algorithm?
> > >
> >
> > I think this was discussed at some point on the list, and Herbert
> > seemed to suggest that 1 was a better choice than AES_BLOCK_SIZE.
> > You'd have to set the chunksize, though, to ensure that the input is
> > presented in the right granularity, i.e., to ensure that the skcipher
> > walk layer never presents less than chunksize bytes unless it is the
> > end of the input.
> >
> > However, this is a flag day change, so you'd need to update all
> > implementations at the same time. Otherwise, the extended tests (which
> > compare accelerated implementations with xts(ecb(aes-generic))) will
> > start failing on the cra_blocksize mismatch.

Well, the problem is that it isn't well defined what the cra_blocksize property
actually means.  Depending on the algorithm, it can mean either the minimum
input size, the required alignment of the input size, the exact input size that
is required (in the case of block ciphers), or the input size that is required
by the algorithm's internal compression function (in the case of hashes).

"xts" follows the convention of cra_blocksize meaning the "minimum input size",
as do "cts" and "adiantum" which have the same constraints on input sizes as
"xts".

So I'm not sure that changing cra_blocksize for xts to 1 would accomplish
anything useful, other than confuse things further.

- Eric
