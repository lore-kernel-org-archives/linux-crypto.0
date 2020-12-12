Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 287C2C19425
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 19:49:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC72D22EBE
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 19:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407835AbgLLTsy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Dec 2020 14:48:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407792AbgLLTsu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Dec 2020 14:48:50 -0500
Date:   Sat, 12 Dec 2020 11:48:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607802489;
        bh=3aKr4v+i7KrJ+/Nfda/fGXDWB/9VCxMZkwZGpDIuFKY=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=WpFQpG5qolNpv1gtAFkxVPl1ZGnKqa0PxiDR7lnBFMHq4WJxxrXn4+wDLAKroYAlx
         sHe6tdiopSV/LI4mkthukp9XJ1f2Zx9Tj13vM4HLlsRkliNJYsKo9N6qs362i/sB+r
         +8vY/dm6Gew0DlA/QUJYWEHmFxeBt8mLPDvAtrcLEcZyjYMYqtyzNXUEk1GrsGrHQc
         JIquqwX/wLM0VOAjZFqNQFAhspekIF4QTqr1hbFpJn+UHIdjF51e6XFywbywYUHsKF
         fgzYT61lQZz2SCVi1PW174lDUvq19GtCbPl+zaiKrWl3PT0oYrsyvhCn1u8dZ07y4W
         Dkg/IjQXKmJtg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Andre Przywara <andre.przywara@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v2] crypto: arm/chacha-neon - optimize for non-block size
 multiples
Message-ID: <X9UeeOMVi/fxkVkX@sol.localdomain>
References: <20201103162809.28167-1-ardb@kernel.org>
 <X9RmlccBrwoY7zXS@sol.localdomain>
 <CAMj1kXEyZXKiiO55qRMyTGkThBspGnPAFdxRkc+d9H29AmhoZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEyZXKiiO55qRMyTGkThBspGnPAFdxRkc+d9H29AmhoZQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Dec 12, 2020 at 08:24:24AM +0100, Ard Biesheuvel wrote:
> On Sat, 12 Dec 2020 at 07:43, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > Hi Ard,
> >
> > On Tue, Nov 03, 2020 at 05:28:09PM +0100, Ard Biesheuvel wrote:
> > > @@ -42,24 +42,24 @@ static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
> > >  {
> > >       u8 buf[CHACHA_BLOCK_SIZE];
> > >
> > > -     while (bytes >= CHACHA_BLOCK_SIZE * 4) {
> > > -             chacha_4block_xor_neon(state, dst, src, nrounds);
> > > -             bytes -= CHACHA_BLOCK_SIZE * 4;
> > > -             src += CHACHA_BLOCK_SIZE * 4;
> > > -             dst += CHACHA_BLOCK_SIZE * 4;
> > > -             state[12] += 4;
> > > -     }
> > > -     while (bytes >= CHACHA_BLOCK_SIZE) {
> > > -             chacha_block_xor_neon(state, dst, src, nrounds);
> > > -             bytes -= CHACHA_BLOCK_SIZE;
> > > -             src += CHACHA_BLOCK_SIZE;
> > > -             dst += CHACHA_BLOCK_SIZE;
> > > -             state[12]++;
> > > +     while (bytes > CHACHA_BLOCK_SIZE) {
> > > +             unsigned int l = min(bytes, CHACHA_BLOCK_SIZE * 4U);
> > > +
> > > +             chacha_4block_xor_neon(state, dst, src, nrounds, l);
> > > +             bytes -= l;
> > > +             src += l;
> > > +             dst += l;
> > > +             state[12] += DIV_ROUND_UP(l, CHACHA_BLOCK_SIZE);
> > >       }
> > >       if (bytes) {
> > > -             memcpy(buf, src, bytes);
> > > -             chacha_block_xor_neon(state, buf, buf, nrounds);
> > > -             memcpy(dst, buf, bytes);
> > > +             const u8 *s = src;
> > > +             u8 *d = dst;
> > > +
> > > +             if (bytes != CHACHA_BLOCK_SIZE)
> > > +                     s = d = memcpy(buf, src, bytes);
> > > +             chacha_block_xor_neon(state, d, s, nrounds);
> > > +             if (d != dst)
> > > +                     memcpy(dst, buf, bytes);
> > >       }
> > >  }
> > >
> >
> > Shouldn't this be incrementing the block counter after chacha_block_xor_neon()?
> > It might be needed by the library API.
> >
> 
> Yeah, good point. 'bytes' could be exactly CHACHA_BLOCK_SIZE now,
> which wasn't the case before.
> 
> I'll send a fix.
> 
> > Also, even with that fixed, this patch is causing the self-tests (both the
> > chacha20poly1305_selftest(), and the crypto API tests for chacha20-neon,
> > xchacha20-neon, and xchacha12-neon) to fail when I boot a kernel in QEMU.  This
> > doesn't happen on real hardware (Raspberry Pi 2), and I don't see any other bugs
> > in this patch, so I'm not sure what the problem is.  Did you run the self-tests
> > on every platform you tested this on?
> >
> 
> Does your QEMU lack this patch? I found that bug working on this code.
> 
> https://git.qemu.org/?p=qemu.git;a=commitdiff;h=604cef3e57eaeeef77074d78f6cf2eca1be11c62

It doesn't have that patch.  That must be the problem then; good to hear that
you've already fixed it.

- Eric
