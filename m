Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB35C47404
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36AF52084D
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:53:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="1xXww+80"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389285AbfJDOx4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:53:56 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40361 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389146AbfJDOx4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 10:53:56 -0400
Received: by mail-pf1-f195.google.com with SMTP id x127so4046076pfb.7
        for <linux-crypto@vger.kernel.org>; Fri, 04 Oct 2019 07:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=XMrs8/BIsHWCs+KRMYnuA0Tui2ETsMtq71wHa7As1+E=;
        b=1xXww+8097YvR9BhwGzXhU6eYAmab18Yaec05B+U1lmxUBc4BpOouP2WsPISAs7XZ5
         NfFrcYt4g09m+knBKzyzqxA1+VoC/0jzTFFMM1I8b3Poc+cUG8YQ5BEZBS0L2j7WmqIm
         X8lGYcdjKYTGmAWohtpviYU5Pk6YyOwoWFG1wJ40l7d0JGRwiqrbPO6fIWSPVML9uOKy
         BUI6boUgsqi9rYN3LZNFEd7TjsnvhfnPpZgLtIUEeIw4WNWSX3d76Q5pXo25u0JD/2xt
         CcXans3uwe8xidgPihiVRrQZvv6zSqNbd+ztsDyKBjs2bqPjMn4CNj/BFb/TnXdWaw/C
         sC1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=XMrs8/BIsHWCs+KRMYnuA0Tui2ETsMtq71wHa7As1+E=;
        b=sM5BDdEkJLhBoDLQO6JYjSkbMeJCtdeZB9M2PcHj+UiKhey/kg+jUryKAPh/21dHfe
         2C9xNhABJOGgwFrBlN1NCHjD3H051TCptR8xcV/71vvli9nv8VE3LDGF1SDNtySn/C93
         UY1tmvLkqRZX74iWf227kHYcp2tvL0uzmVB96coBMYFPVNUeLwgdM40zvhj8d1eXEXpi
         EEwHDQ/P82Mudnbi7HIQtoXpO9t+AE7+I0+vtGBXg3zdDBtoOVtI5vuO5shlO5WIuBWg
         Rj74EtlYr7qgdSYF7IQTKIi7OZdp1zO/2ehZiSgBC1K3qe4hl2FUfX0sHGUMf0tJYFXx
         SnJA==
X-Gm-Message-State: APjAAAXxqNP93+rYTlvMNx/hjJNzBTy4Oh7PWpw4NTkWnEuDdly9THN1
        33GTetCA6/hKOBz5OBOABSUMPg==
X-Google-Smtp-Source: APXvYqzy59oNaBVxq9dRIZ5e2UnQHcRGCd3xnQ3h/qiIFgA1WU8vLuSbea0lKfd2y3NjGCyYQLb4kw==
X-Received: by 2002:a65:6844:: with SMTP id q4mr16474521pgt.274.1570200835242;
        Fri, 04 Oct 2019 07:53:55 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:b800:f509:3b99:5225? ([2601:646:c200:1ef2:b800:f509:3b99:5225])
        by smtp.gmail.com with ESMTPSA id a7sm5109519pjv.0.2019.10.04.07.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2019 07:53:54 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 00/20] crypto: crypto API library interfaces for WireGuard
Date:   Fri, 4 Oct 2019 07:53:53 -0700
Message-Id: <BE18E4E0-D4CC-40B9-96E1-C44D25B879D9@amacapital.net>
References: <CAKv+Gu-Xe-BfYzVDqDaZZ2wawYs8HHHc-CMYPPOU3E=6CPgccA@mail.gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
In-Reply-To: <CAKv+Gu-Xe-BfYzVDqDaZZ2wawYs8HHHc-CMYPPOU3E=6CPgccA@mail.gmail.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
X-Mailer: iPhone Mail (17A854)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> On Oct 4, 2019, at 6:52 AM, Ard Biesheuvel <ard.biesheuvel@linaro.org> wro=
te:
>=20
> =EF=BB=BFOn Fri, 4 Oct 2019 at 15:42, Jason A. Donenfeld <Jason@zx2c4.com>=
 wrote:
>>=20
>>> On Thu, Oct 03, 2019 at 10:43:29AM +0200, Ard Biesheuvel wrote:
>>> On Wed, 2 Oct 2019 at 16:17, Ard Biesheuvel <ard.biesheuvel@linaro.org> w=
rote:
>>>>=20
>>> ...
>>>>=20
>>>> In the future, I would like to extend these interfaces to use static ca=
lls,
>>>> so that the accelerated implementations can be [un]plugged at runtime. =
For
>>>> the time being, we rely on weak aliases and conditional exports so that=
 the
>>>> users of the library interfaces link directly to the accelerated versio=
ns,
>>>> but without the ability to unplug them.
>>>>=20
>>>=20
>>> As it turns out, we don't actually need static calls for this.
>>> Instead, we can simply permit weak symbol references to go unresolved
>>> between modules (as we already do in the kernel itself, due to the
>>> fact that ELF permits it), and have the accelerated code live in
>>> separate modules that may not be loadable on certain systems, or be
>>> blacklisted by the user.
>>=20
>> You're saying that at module insertion time, the kernel will override
>> weak symbols with those provided by the module itself? At runtime?
>>=20
>=20
> Yes.
>=20
>> Do you know offhand how this patching works? Is there a PLT that gets
>> patched, and so the calls all go through a layer of function pointer
>> indirection? Or are all call sites fixed up at insertion time and the
>> call instructions rewritten with some runtime patching magic?
>>=20
>=20
> No magic. Take curve25519 for example, when built for ARM:
>=20
> 00000000 <curve25519>:
>   0:   f240 0300       movw    r3, #0
>                        0: R_ARM_THM_MOVW_ABS_NC        curve25519_arch
>   4:   f2c0 0300       movt    r3, #0
>                        4: R_ARM_THM_MOVT_ABS   curve25519_arch
>   8:   b570            push    {r4, r5, r6, lr}
>   a:   4604            mov     r4, r0
>   c:   460d            mov     r5, r1
>   e:   4616            mov     r6, r2
>  10:   b173            cbz     r3, 30 <curve25519+0x30>
>  12:   f7ff fffe       bl      0 <curve25519_arch>
>                        12: R_ARM_THM_CALL      curve25519_arch
>  16:   b158            cbz     r0, 30 <curve25519+0x30>
>  18:   4620            mov     r0, r4
>  1a:   2220            movs    r2, #32
>  1c:   f240 0100       movw    r1, #0
>                        1c: R_ARM_THM_MOVW_ABS_NC       .LANCHOR0
>  20:   f2c0 0100       movt    r1, #0
>                        20: R_ARM_THM_MOVT_ABS  .LANCHOR0
>  24:   f7ff fffe       bl      0 <__crypto_memneq>
>                        24: R_ARM_THM_CALL      __crypto_memneq
>  28:   3000            adds    r0, #0
>  2a:   bf18            it      ne
>  2c:   2001            movne   r0, #1
>  2e:   bd70            pop     {r4, r5, r6, pc}
>  30:   4632            mov     r2, r6
>  32:   4629            mov     r1, r5
>  34:   4620            mov     r0, r4
>  36:   f7ff fffe       bl      0 <curve25519_generic>
>                        36: R_ARM_THM_CALL      curve25519_generic
>  3a:   e7ed            b.n     18 <curve25519+0x18>
>=20
> curve25519_arch is a weak reference. It either gets satisfied at
> module load time, or it doesn't.
>=20
> If it does get satisfied, the relocations covering the movw/movt pair
> and the one covering the bl instruction get updated so that they point
> to the arch routine.
>=20
> If it does not get satisfied, the relocations are disregarded, in
> which case the cbz instruction at offset 0x10 jumps over the bl call.
>=20
> Note that this does not involve any memory accesses. It does involve
> some code patching, but only of the kind the module loader already
> does.

Won=E2=80=99t this have the counterintuitive property that, if you load the m=
odules in the opposite order, the reference won=E2=80=99t be re-resolved and=
 performance will silently regress?

I think it might be better to allow two different modules to export the same=
 symbol but only allow one of them to be loaded. Or use static calls.=
