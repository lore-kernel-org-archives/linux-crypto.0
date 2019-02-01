Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD666C282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 05:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F46F2084A
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 05:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548998724;
	bh=HWgZm++3GNATO7e8ZSZpoIEFfmURVVW3OSVLvfQptX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Q4kyw8MinjM3QNoJrEh1F+72ZtqhVR+oqVaOF1GiP7RVkT5j3mv4dhPEwtmnUHcC/
	 nocE95YPi4EoXJo4jXogFTEPtXXa+UuEc+V+nqK7RwOtvVAYy6RmpApwlS4HM5EM1V
	 FZFPztER7b4McjCLjPpW4D7yL36I/+JlkqjVx43k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbfBAFZS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 00:25:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbfBAFZS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 00:25:18 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 266A82084A;
        Fri,  1 Feb 2019 05:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548998717;
        bh=HWgZm++3GNATO7e8ZSZpoIEFfmURVVW3OSVLvfQptX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GsRP/ACnduBE4mZjSpkh6KvFzS/cPe7TlWBg0qPfCrNshPxBCl8i0aWgHYm/zvChj
         Us+iWSjmeuVUPK9C1Gr5aC5mTPpGOBISe915aQb3jp6YCmTVVxKlCZ1eAbRIJNP8sq
         qsxUZ/PA2tvsGEFVVfPlbY7UvR/6c7VxxOPBPS/Q=
Date:   Thu, 31 Jan 2019 21:25:07 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: Re: [RFC/RFT PATCH 02/15] crypto: morus - fix handling chunked inputs
Message-ID: <20190201052506.GA765@sol.localdomain>
References: <20190123224926.250525-1-ebiggers@kernel.org>
 <20190123224926.250525-3-ebiggers@kernel.org>
 <CAFqZXNv+=qgg+Jo4iC72D++BmoxK4S0XiKED47M7MQJjFtMYRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFqZXNv+=qgg+Jo4iC72D++BmoxK4S0XiKED47M7MQJjFtMYRw@mail.gmail.com>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 31, 2019 at 10:05:17AM +0100, Ondrej Mosnacek wrote:
> Hi Eric,
> 
> On Wed, Jan 23, 2019 at 11:52 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > The generic MORUS implementations all fail the improved AEAD tests
> > because they produce the wrong result with some data layouts.  Fix them.
> >
> > Fixes: 396be41f16fd ("crypto: morus - Add generic MORUS AEAD implementations")
> > Cc: <stable@vger.kernel.org> # v4.18+
> > Cc: Ondrej Mosnacek <omosnace@redhat.com>
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  crypto/morus1280.c | 13 +++++++------
> >  crypto/morus640.c  | 13 +++++++------
> >  2 files changed, 14 insertions(+), 12 deletions(-)
> >
> > diff --git a/crypto/morus1280.c b/crypto/morus1280.c
> > index 3889c188f266..b83576b4eb55 100644
> > --- a/crypto/morus1280.c
> > +++ b/crypto/morus1280.c
> > @@ -366,18 +366,19 @@ static void crypto_morus1280_process_crypt(struct morus1280_state *state,
> >                                            const struct morus1280_ops *ops)
> >  {
> >         struct skcipher_walk walk;
> > -       u8 *dst;
> > -       const u8 *src;
> >
> >         ops->skcipher_walk_init(&walk, req, false);
> >
> >         while (walk.nbytes) {
> > -               src = walk.src.virt.addr;
> > -               dst = walk.dst.virt.addr;
> > +               unsigned int nbytes = walk.nbytes;
> >
> > -               ops->crypt_chunk(state, dst, src, walk.nbytes);
> > +               if (nbytes < walk.total)
> > +                       nbytes = round_down(nbytes, walk.stride);
> >
> > -               skcipher_walk_done(&walk, 0);
> > +               ops->crypt_chunk(state, walk.dst.virt.addr, walk.src.virt.addr,
> > +                                nbytes);
> > +
> > +               skcipher_walk_done(&walk, walk.nbytes - nbytes);
> >         }
> 
> Hm... I assume the problem was that skcipher_walk may give you nbytes
> that is not rounded to the algorithm's walksize (aka walk.stride) even
> in the middle of the stream, right? I must have misread the code in
> skcipher.c and assumed that it automatically makes every step of a
> round size, with the exception of the very last one, which may include
> a final partial block. Thinking about it now it makes sense to me that
> this isn't the case, since for stream ciphers it would mean some
> unnecessary memcpy'ing in the skcipher_walk code...
> 
> Maybe you could explain the problem in one or two sentences in the
> commit message(s), since the contract of skcipher_walk doesn't seem to
> be documented anywhere and so it is not obvious why the change is
> necessary.
> 
> Thank you for all your work on this - the improved testmgr tests were
> long needed!
> 

Yes, that's correct.  I'll add an explanation to the commit messages.  I'm
actually not convinced that this behavior should be the default (vs. allowing
the caller to opt-in to it if needed), but this is how it works now...  

A while back I also started work on a documentation patch for the skcipher_walk
functions, but it's still pretty incomplete.  I'll see if I can get it in a
state to send out.

- Eric
