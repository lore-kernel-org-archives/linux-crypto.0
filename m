Return-Path: <SRS0=chSI=24=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6363DC33C9E
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jan 2020 21:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D8802081E
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jan 2020 21:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgAGVVa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jan 2020 16:21:30 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:35995 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729067AbgAGVV3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jan 2020 16:21:29 -0500
Received: from mail-qk1-f176.google.com ([209.85.222.176]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MRCBm-1j0wpH32MG-00NBCp; Tue, 07 Jan 2020 22:21:27 +0100
Received: by mail-qk1-f176.google.com with SMTP id d71so820445qkc.0;
        Tue, 07 Jan 2020 13:21:27 -0800 (PST)
X-Gm-Message-State: APjAAAW22VWjWv8b9Ao6dyhJ0RYF1wjEWypQJHn4ATzEZjzNxoHsu7yz
        XHngJmWNcOd2tlMU/OjbLn0xMvkqIl3yYACs1U0=
X-Google-Smtp-Source: APXvYqwWX14oOMnhpeDIoY9y/919XllKVczGD7LmnCZAjDLYU2w9nCEzI9WjKQKE+gbrCYDkW3aHGRLQ/VQ1GiU5OO4=
X-Received: by 2002:a05:620a:cef:: with SMTP id c15mr1363924qkj.352.1578432086524;
 Tue, 07 Jan 2020 13:21:26 -0800 (PST)
MIME-Version: 1.0
References: <20200107201327.3863345-1-arnd@arndb.de> <CAHmME9rnevSYwWvfyv8LRitVo-=KVpPCoGLwYxo62mwnW0vjiQ@mail.gmail.com>
In-Reply-To: <CAHmME9rnevSYwWvfyv8LRitVo-=KVpPCoGLwYxo62mwnW0vjiQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 7 Jan 2020 22:21:10 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3N=Zcq3rztj94Ty0_Fbfkw4db+-fLgASvK_UD4LTY=Ww@mail.gmail.com>
Message-ID: <CAK8P3a3N=Zcq3rztj94Ty0_Fbfkw4db+-fLgASvK_UD4LTY=Ww@mail.gmail.com>
Subject: Re: [PATCH] crypto: curve25519 - Work around link failure
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Andy Polyakov <appro@cryptogams.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        Vitaly Chikunov <vt@altlinux.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:no2J6gE6SmsJ60PMl8NVwoArJBS4zufmwUfx8IRJAkKAr6hz8Y5
 zoZJ4SvFDO+ERCALKL/FmdEUuHUnda9SC0AWMLF9/karNoDjKJxHuFPbPjXBndwp0uUrXT5
 FbyvBPYSsrU3vfv9nPSYOOBCMMkR1xFUOjNW1FLoe7o/DyCzzmsMLgaZ4e5xOKgFlcOeNYq
 ZzipicfnquO02Qmjzl2Mw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:zuwX3DRtQJ4=:MaNpG9j+Cmp3pA5lz1WiVb
 aKjMy3lu26YwJskFp/MRd3tlKvlgV6INHCadmPqs7uyAq4v5gy1HsUdK6gRcqy+5jXEKyHTYv
 pORuAKiUCJZ2yHohuWA1HpuYnmDp4NMYwsUQLQnW/cOc3mk85JHUE64xIQEK8lj5/x7GmnZXq
 r2J493EsDVNbGk3wHgD+mQELeyzaXw1+27PdwQZMTcY9zD0peV9irGIwTl2gtB2ht6P33prK9
 OapfzInJ+Q6Czxuxawj+bKdHRxRQPEH9ZMy4hgT2mOpQ8n34E8RzpeqZEOSYLbJxXJ9GQn1pM
 4s9zDKFNxpBldBI0ajlbXnqbuKSPniNCHokt4Y49o3z2bD0xV0fDKuSOhkYW/opbWK5KCkXgs
 bauSWEPhj/Ogqu/eoCvq3P+rfpEnxgzFsr8lO+gHiTNJ2oIkw59cYBcXpj1s7+C2ql4DG86MA
 ShYW4Kt4loHsg66rsFd2XvTDVIQ17Nx0VR02UGib5jVrUOg8gKOJd9PMlAX5D2e3f2irZ0sFB
 gtIGlbDuQh1ig9Lv56jtevGbjm4nl1QSsr5kXNnw6uX90EVleoh6SlMI1IEkvOBl0z6e+M8gT
 Iuzt9Mgcv/sRdUuvfxTMBrdy6KD0FgB4ztO4sRFuPrAzTMhdmn8NJC1KBozJpPT5nrUgEqjYl
 drEba9p8fp85x8dve/cCyQ88TG2nLbEkrAdhfoNwelFJfkYo8K4CWjZQ8xzEDdmgEkeM/XL/d
 oSbBMx4vFfCkVGDJ3LNgXrQTyd4S/3XhNeBGfpEPwruRIuYNsqyJ0aXyiEYsckl+YZAtLTfkn
 ma+cIGsMspeSFUX3Dtr5mpsHO6Rxa1hZZmIpxk1nl8aTK1QgUXu/6HhtHEifobl51xLkEoEZX
 3TtN8KozTGMxxobMxMfw==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 7, 2020 at 9:26 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hey Arnd,
>
> Another solution to this was already posted:
>
> https://lore.kernel.org/linux-crypto/CAHmME9pg4KWw1zNVybxn1WLGusyGCjqeAHLQXY=Dr4zznUM82g@mail.gmail.com/T/#t
>
> That might be slightly cleaner, though yours is shorter. I'm alright
> with either one.

Yes, I agree the other approach looks nicer. I've added that to my randconfig
builder in place of my patch to see if it's sufficient. If not, I'll
let you know.

        Arnd
