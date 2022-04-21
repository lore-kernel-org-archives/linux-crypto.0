Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E824FC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Apr 2022 22:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344390AbiDUWcJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Apr 2022 18:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235154AbiDUWcG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Apr 2022 18:32:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CDA4B850
        for <linux-crypto@vger.kernel.org>; Thu, 21 Apr 2022 15:29:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 065F4B8298E
        for <linux-crypto@vger.kernel.org>; Thu, 21 Apr 2022 22:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61653C385A5;
        Thu, 21 Apr 2022 22:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650580152;
        bh=hhx6ZHpH8Kxhx1mXm+n7JX0qgOHEiTHJNbV8HmTcis0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lEujdmH8wTGzV6Osp9POxVQ8aLECEmnHAFDLR0Wsi501pOvrniLyCTATlKr69AkfX
         rEZ0Lh/3jCH9s1OVd4WZAIDmpxEmeuLHsdcj3412WbA6HlK5hJxf2rGvSx8pqna+h8
         Kct/yUmCmuUk7r+I062zCGUeluU1QqxmnDVwbGJmTppS2hjcXb/+kCsnhPJT394OSn
         cST14YDYyk2qVvDzSmJ9++TnAOvwmkturki1QxYtBUODinTGf9yVMCc+J9sGzLKV2m
         k4Nyic2bQHIHp6jC+IUQf6YNJeZ42R1g8JjoukTA7yrWwvd231ziaKre/eY3YL/BO6
         Dy9MloD4yALvQ==
Date:   Thu, 21 Apr 2022 15:29:10 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4 4/8] crypto: x86/aesni-xctr: Add accelerated
 implementation of XCTR
Message-ID: <YmHatvKDOZ5z1A9I@sol.localdomain>
References: <20220412172816.917723-1-nhuck@google.com>
 <20220412172816.917723-5-nhuck@google.com>
 <Yl3+wqeOw2/jRgOC@sol.localdomain>
 <CAJkfWY51QXF3Mf6jfNc54yRPhR5J9azyaXkkd2=x6Q-RkfdBsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJkfWY51QXF3Mf6jfNc54yRPhR5J9azyaXkkd2=x6Q-RkfdBsA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 21, 2022 at 04:59:31PM -0500, Nathan Huckleberry wrote:
> On Mon, Apr 18, 2022 at 7:13 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Tue, Apr 12, 2022 at 05:28:12PM +0000, Nathan Huckleberry wrote:
> > > diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
> > > index 363699dd7220..ce17fe630150 100644
> > > --- a/arch/x86/crypto/aesni-intel_asm.S
> > > +++ b/arch/x86/crypto/aesni-intel_asm.S
> > > @@ -2821,6 +2821,76 @@ SYM_FUNC_END(aesni_ctr_enc)
> > >
> > >  #endif
> > >
> > > +#ifdef __x86_64__
> > > +/*
> > > + * void aesni_xctr_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
> > > + *                 size_t len, u8 *iv, int byte_ctr)
> > > + */
> > > +SYM_FUNC_START(aesni_xctr_enc)
> > > +     FRAME_BEGIN
> > > +     cmp $16, LEN
> > > +     jb .Lxctr_ret
> > > +     shr     $4, %arg6
> > > +     movq %arg6, CTR
> > > +     mov 480(KEYP), KLEN
> > > +     movups (IVP), IV
> > > +     cmp $64, LEN
> > > +     jb .Lxctr_enc_loop1
> > > +.align 4
> > > +.Lxctr_enc_loop4:
> > > +     movaps IV, STATE1
> > > +     vpaddq ONE(%rip), CTR, CTR
> > > +     vpxor CTR, STATE1, STATE1
> > > +     movups (INP), IN1
> > > +     movaps IV, STATE2
> > > +     vpaddq ONE(%rip), CTR, CTR
> > > +     vpxor CTR, STATE2, STATE2
> > > +     movups 0x10(INP), IN2
> > > +     movaps IV, STATE3
> > > +     vpaddq ONE(%rip), CTR, CTR
> > > +     vpxor CTR, STATE3, STATE3
> > > +     movups 0x20(INP), IN3
> > > +     movaps IV, STATE4
> > > +     vpaddq ONE(%rip), CTR, CTR
> > > +     vpxor CTR, STATE4, STATE4
> > > +     movups 0x30(INP), IN4
> > > +     call _aesni_enc4
> > > +     pxor IN1, STATE1
> > > +     movups STATE1, (OUTP)
> > > +     pxor IN2, STATE2
> > > +     movups STATE2, 0x10(OUTP)
> > > +     pxor IN3, STATE3
> > > +     movups STATE3, 0x20(OUTP)
> > > +     pxor IN4, STATE4
> > > +     movups STATE4, 0x30(OUTP)
> > > +     sub $64, LEN
> > > +     add $64, INP
> > > +     add $64, OUTP
> > > +     cmp $64, LEN
> > > +     jge .Lxctr_enc_loop4
> > > +     cmp $16, LEN
> > > +     jb .Lxctr_ret
> > > +.align 4
> > > +.Lxctr_enc_loop1:
> > > +     movaps IV, STATE
> > > +     vpaddq ONE(%rip), CTR, CTR
> > > +     vpxor CTR, STATE1, STATE1
> > > +     movups (INP), IN
> > > +     call _aesni_enc1
> > > +     pxor IN, STATE
> > > +     movups STATE, (OUTP)
> > > +     sub $16, LEN
> > > +     add $16, INP
> > > +     add $16, OUTP
> > > +     cmp $16, LEN
> > > +     jge .Lxctr_enc_loop1
> > > +.Lxctr_ret:
> > > +     FRAME_END
> > > +     RET
> > > +SYM_FUNC_END(aesni_xctr_enc)
> > > +
> > > +#endif
> >
> > Sorry, I missed this file.  This is the non-AVX version, right?  That means that
> > AVX instructions, i.e. basically anything instruction starting with "v", can't
> > be used here.  So the above isn't going to work.  (There might be a way to test
> > this with QEMU; maybe --cpu-type=Nehalem without --enable-kvm?)
> >
> > You could rewrite this without using AVX instructions.  However, polyval-clmulni
> > is broken in the same way; it uses AVX instructions without checking whether
> > they are available.  But your patchset doesn't aim to provide a non-AVX polyval
> > implementation at all.  So even if you got the non-AVX XCTR working, it wouldn't
> > be paired with an accelerated polyval.
> >
> > So I think you should just not provide non-AVX versions for now.  That would
> > mean:
> >
> >         1.) Drop the change to aesni-intel_asm.S
> >         2.) Don't register the AES XCTR algorithm unless AVX is available
> >             (in addition to AES-NI)
> 
> Is there a preferred way to conditionally register xctr? It looks like
> aesni-intel_glue.c registers a default implementation for all the
> algorithms in the array, then better versions are enabled depending on
> cpu features. Should I remove xctr from the list of other algorithms
> and register it separately?
> 

Yes, it will need to be removed from the aesni_skciphers array.  I don't see any
other algorithms in that file that are conditional on AES-NI && AVX, so it will
have to go by itself.

- Eric
