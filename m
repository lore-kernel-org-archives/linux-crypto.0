Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B0CCC47404
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 04:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BEFB20867
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 04:44:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="Mjr6RIdo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfJGEoV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 00:44:21 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41256 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbfJGEoU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 00:44:20 -0400
Received: by mail-pl1-f195.google.com with SMTP id t10so6258129plr.8
        for <linux-crypto@vger.kernel.org>; Sun, 06 Oct 2019 21:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=hD0qM4X3AmZViAYS6uPHZEGQw1p4YNYjpYOcwGVVkUU=;
        b=Mjr6RIdob7IDO3OU05Ee+C6sZQRO7wP+h7YCoTBAw+Tp8t2IjnfYvZcwOMLMR1WrTQ
         /AEi+PfR3+RPVd4PA1aJ0woIjpHjKTdOlAifbZk6BdlC4heO73JIyY5lfPbUehXCgVpZ
         BMILQVUzHs/5K7+Y5LOMvf3bbY/40Z7Uf4LZUqB0fW0NT5BDkwBRU9vHk4LBPW/euBv7
         OBbp1Je3/z+Yfmo9os8kMQCi8CO7JVKdHyvwuBaxhzsT6F2p0WRWDmUYgRy/VtMEUGd/
         mBUCTJy7Y+2a+w+B+sYLhObPyiWuBizqLf42k6rH03bWrfOhsNGZUmcqIp2n6zSuKNmV
         gbdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=hD0qM4X3AmZViAYS6uPHZEGQw1p4YNYjpYOcwGVVkUU=;
        b=oyYBR63IJngKAs5+MIcxsnCby2wQBbwYkKRcYRSmpEnsCN0HcxmjL1zXupVfzomoLM
         ttIRNHW0xp0AQ+HvKuRkIkVX9KVNermmv1nPbvFdDatTD4Omf6sjKv3w3mJFwbdW3ndO
         cofyD/h5EuLzP0DQVwM5aAVXwfCd15SbmwsHiwPC55a50LkvPKhhoXGjGpSyT/eblRMG
         rj9h3Zk3J5SvVWM38vnsmItvTw4AF2pbxvevJ1qpvx0e1zCxKDnnFqQe5y+I2C3qh8V2
         GeN2UVNHB8VE6w2oR4tBxLBaDJ9qOg35aqp4B1ZjzWDEVOKA94yuCbP69qHHJookJ+zJ
         bkgA==
X-Gm-Message-State: APjAAAW7Us4lB9GuFIKpR7fNpXHCbX5jnIzcZLkyRgcZ9CLaxsBwUfYy
        pRuodx6kzjHJmNrgjFG7gxd+9YeP2YQ=
X-Google-Smtp-Source: APXvYqzMEZCm47uhFOFIetQsQDN/Hiahj2ILfPYZ5CX4/0i1ACBPRXzVPbKhIIeiqO9NicqhaUlvfg==
X-Received: by 2002:a17:902:465:: with SMTP id 92mr27172500ple.65.1570423458324;
        Sun, 06 Oct 2019 21:44:18 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:fc86:34:1455:ba6a? ([2601:646:c200:1ef2:fc86:34:1455:ba6a])
        by smtp.gmail.com with ESMTPSA id h1sm13602045pfk.124.2019.10.06.21.44.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Oct 2019 21:44:17 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 00/20] crypto: crypto API library interfaces for WireGuard
Date:   Sun, 6 Oct 2019 21:44:15 -0700
Message-Id: <04D32F59-34D4-4EBF-80E3-69088D14C5D8@amacapital.net>
References: <CAKv+Gu-VqfFsW+nrG+-2g1-eu6S+ZuD7qaN9aTchwD=Bcj_giw@mail.gmail.com>
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
In-Reply-To: <CAKv+Gu-VqfFsW+nrG+-2g1-eu6S+ZuD7qaN9aTchwD=Bcj_giw@mail.gmail.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
X-Mailer: iPhone Mail (17A860)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> On Oct 5, 2019, at 12:24 AM, Ard Biesheuvel <ard.biesheuvel@linaro.org> wr=
ote:
>=20
> =EF=BB=BFOn Fri, 4 Oct 2019 at 16:56, Ard Biesheuvel <ard.biesheuvel@linar=
o.org> wrote:
>>=20
>>> On Fri, 4 Oct 2019 at 16:53, Andy Lutomirski <luto@amacapital.net> wrote=
:
>>>=20
>>>=20
>>>=20
>>>> On Oct 4, 2019, at 6:52 AM, Ard Biesheuvel <ard.biesheuvel@linaro.org> w=
rote:
>>>>=20
>>>> =EF=BB=BFOn Fri, 4 Oct 2019 at 15:42, Jason A. Donenfeld <Jason@zx2c4.c=
om> wrote:
>>>>>=20
>>>>>> On Thu, Oct 03, 2019 at 10:43:29AM +0200, Ard Biesheuvel wrote:
>>>>>> On Wed, 2 Oct 2019 at 16:17, Ard Biesheuvel <ard.biesheuvel@linaro.or=
g> wrote:
>>>>>>>=20
>>>>>> ...
>>>>>>>=20
>>>>>>> In the future, I would like to extend these interfaces to use static=
 calls,
>>>>>>> so that the accelerated implementations can be [un]plugged at runtim=
e. For
>>>>>>> the time being, we rely on weak aliases and conditional exports so t=
hat the
>>>>>>> users of the library interfaces link directly to the accelerated ver=
sions,
>>>>>>> but without the ability to unplug them.
>>>>>>>=20
>>>>>>=20
>>>>>> As it turns out, we don't actually need static calls for this.
>>>>>> Instead, we can simply permit weak symbol references to go unresolved=

>>>>>> between modules (as we already do in the kernel itself, due to the
>>>>>> fact that ELF permits it), and have the accelerated code live in
>>>>>> separate modules that may not be loadable on certain systems, or be
>>>>>> blacklisted by the user.
>>>>>=20
>>>>> You're saying that at module insertion time, the kernel will override
>>>>> weak symbols with those provided by the module itself? At runtime?
>>>>>=20
>>>>=20
>>>> Yes.
>>>>=20
>>>>> Do you know offhand how this patching works? Is there a PLT that gets
>>>>> patched, and so the calls all go through a layer of function pointer
>>>>> indirection? Or are all call sites fixed up at insertion time and the
>>>>> call instructions rewritten with some runtime patching magic?
>>>>>=20
>>>>=20
>>>> No magic. Take curve25519 for example, when built for ARM:
>>>>=20
>>>> 00000000 <curve25519>:
>>>>  0:   f240 0300       movw    r3, #0
>>>>                       0: R_ARM_THM_MOVW_ABS_NC        curve25519_arch
>>>>  4:   f2c0 0300       movt    r3, #0
>>>>                       4: R_ARM_THM_MOVT_ABS   curve25519_arch
>>>>  8:   b570            push    {r4, r5, r6, lr}
>>>>  a:   4604            mov     r4, r0
>>>>  c:   460d            mov     r5, r1
>>>>  e:   4616            mov     r6, r2
>>>> 10:   b173            cbz     r3, 30 <curve25519+0x30>
>>>> 12:   f7ff fffe       bl      0 <curve25519_arch>
>>>>                       12: R_ARM_THM_CALL      curve25519_arch
>>>> 16:   b158            cbz     r0, 30 <curve25519+0x30>
>>>> 18:   4620            mov     r0, r4
>>>> 1a:   2220            movs    r2, #32
>>>> 1c:   f240 0100       movw    r1, #0
>>>>                       1c: R_ARM_THM_MOVW_ABS_NC       .LANCHOR0
>>>> 20:   f2c0 0100       movt    r1, #0
>>>>                       20: R_ARM_THM_MOVT_ABS  .LANCHOR0
>>>> 24:   f7ff fffe       bl      0 <__crypto_memneq>
>>>>                       24: R_ARM_THM_CALL      __crypto_memneq
>>>> 28:   3000            adds    r0, #0
>>>> 2a:   bf18            it      ne
>>>> 2c:   2001            movne   r0, #1
>>>> 2e:   bd70            pop     {r4, r5, r6, pc}
>>>> 30:   4632            mov     r2, r6
>>>> 32:   4629            mov     r1, r5
>>>> 34:   4620            mov     r0, r4
>>>> 36:   f7ff fffe       bl      0 <curve25519_generic>
>>>>                       36: R_ARM_THM_CALL      curve25519_generic
>>>> 3a:   e7ed            b.n     18 <curve25519+0x18>
>>>>=20
>>>> curve25519_arch is a weak reference. It either gets satisfied at
>>>> module load time, or it doesn't.
>>>>=20
>>>> If it does get satisfied, the relocations covering the movw/movt pair
>>>> and the one covering the bl instruction get updated so that they point
>>>> to the arch routine.
>>>>=20
>>>> If it does not get satisfied, the relocations are disregarded, in
>>>> which case the cbz instruction at offset 0x10 jumps over the bl call.
>>>>=20
>>>> Note that this does not involve any memory accesses. It does involve
>>>> some code patching, but only of the kind the module loader already
>>>> does.
>>>=20
>>> Won=E2=80=99t this have the counterintuitive property that, if you load t=
he modules in the opposite order, the reference won=E2=80=99t be re-resolved=
 and performance will silently regress?
>>>=20
>>=20
>> Indeed, the arch module needs to be loaded first
>>=20
>=20
> Actually, this can be addressed by retaining the module dependencies
> as before, but permitting the arch module to be omitted at load time.

I think that, to avoid surprises, you should refuse to load the arch module i=
f the generic module is loaded, too.

>=20
>>> I think it might be better to allow two different modules to export the s=
ame symbol but only allow one of them to be loaded.
>>=20
>> That is what I am doing for chacha and poly
>>=20
>>> Or use static calls.
>=20
> Given that static calls don't actually exist yet, I propose to proceed
> with the approach above, and switch to static calls once all
> architectures where it matters have an implementation that does not
> use function pointers (which is how static calls will be implemented
> generically)
