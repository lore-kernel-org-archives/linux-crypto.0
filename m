Return-Path: <SRS0=Wq3S=VB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FDF5C0650E
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jul 2019 07:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F4632133F
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jul 2019 07:39:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="llZ031et"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfGDHjJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jul 2019 03:39:09 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43257 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbfGDHjJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jul 2019 03:39:09 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so5438347wru.10
        for <linux-crypto@vger.kernel.org>; Thu, 04 Jul 2019 00:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=XkALWcZPhy/UlmJy/l5A12TANGuzgR+hn/seVO8wsMw=;
        b=llZ031etpU3igTTEQRusZiGE1UvfGRKrSJtz1nYNuNruMttEQm1QwpzpEM/Ddto1E0
         mkC7n8IgZtDTRDm1sfpQkcPUgLwVK1cyPbrj8J3Zm/J5N1qcCyyAF7uB1C0llw9Po5ik
         8QAptBopu/daAIZDkTJrml/gaLeK5cy0aPf+mtvqNUuiH0Uvijfw+/l9LeX0d0sRD/xH
         R/krZEWdiyfOOUi2MW1CfihU6jVBxRsEnIxDOAb+ScbG2O+rxSaRMIJOlaIttiCTSXOd
         EACoi1Iucc8FFg1qMvOqMeV5HT/92Dpfwct93um7nFmGPGtX9UsgfRgqAPN+tPSsoJ3I
         9LyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=XkALWcZPhy/UlmJy/l5A12TANGuzgR+hn/seVO8wsMw=;
        b=BzZSiV+Pu6rkupeu8m9kuTBsa+dYHQroCGnoY9jMiaztfFBsguaKLnSlI6/9ZyamFS
         1xLA40/DT2Ikq94wQoSKPWP2TYixtMgLYWoO4j57jVUWV0ulOFmT90SeJak6x1s8hkcV
         26j3PiRqurkA9O7PONxaY2bkiWr/LE6bYNK6qYHYM2c3QGc/jqYo8+rx1ltYs3RC5OCE
         FJI7t1D+5jmGpGTyivVSn3Q6EYzJEqEzkbLfuibfCMytF1X2l11fpWuMFrgVbi05EZDo
         CPbBUCEW1j8OIfbaQuuPCzmiUY7HjSUrE1ODiJo+XfXk4jupBljnl9vrdDhSNLt/ZqGv
         ekKg==
X-Gm-Message-State: APjAAAUVN+0iOgY4lU0U3WN5137kFv/lhikH1jSt0uOE0V0cecJTU9tw
        fF0gL6KR/Dx7+Fxi+4yS3iJAurNQyELL1GrVqxU=
X-Google-Smtp-Source: APXvYqx5bH/CjBFioqJj/QoeCPrv9f08VwsaY7/MGRKDjkNV/e9eAkxhVhJxq8K5RIB806j2FoKvNpb718jivgpiF4I=
X-Received: by 2002:a5d:498f:: with SMTP id r15mr4511823wrq.353.1562225946735;
 Thu, 04 Jul 2019 00:39:06 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUX3EOhrUp0Afbo_fK9rb5AbXjbaBFwhj1qmBaHom1b3MA@mail.gmail.com>
 <CAKwvOdn8Za1Dy4QgdDZu1My5oYLJJzyRqYsq+XkpRpnViC6aKQ@mail.gmail.com>
 <20190617182256.GB92263@gmail.com> <CA+icZUV8693G8jgHw2t9qUay4_Ad-7BgNOkL6z+4z8xNXyL=cA@mail.gmail.com>
 <20190703161456.GC21629@sol.localdomain> <CAKwvOdmRdef1PD9NQnOhfeNC_LWAp8a-oYcnxXo1WWGoWnyn0w@mail.gmail.com>
In-Reply-To: <CAKwvOdmRdef1PD9NQnOhfeNC_LWAp8a-oYcnxXo1WWGoWnyn0w@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 4 Jul 2019 09:38:55 +0200
Message-ID: <CA+icZUUgcXRH14yZRguopjuGzDWUi04Q2L_drbMU-AZCX9NDkA@mail.gmail.com>
Subject: Re: crypto: x86/crct10dif-pcl - cleanup and optimizations
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Fangrui Song <maskray@google.com>,
        Peter Smith <peter.smith@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 3, 2019 at 8:52 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Wed, Jul 3, 2019 at 9:15 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > Sorry, I am still confused.  Are you saying that something still needs to be
> > fixed in the kernel code, and if so, why?  To reiterate, the byteshift_table
> > doesn't actually *need* any particular alignment.  Would it avoid the confusion
> > if I changed it to no alignment?  Or is there some section merging related
> > reason it actually needs to be 32?
>
> Looks like the section merging of similarly named sections of
> differing alignment in LLD just got reverted:
> https://bugs.llvm.org/show_bug.cgi?id=42289#c8
> I wasn't able to find any documentation that said alignment must match
> entity size, but if there's not a functional reason for them to differ
> then it seems like LLD need not even support such a particularly
> non-common case.
>

My primary goal was to get rid of these sysfs warnings when building
with clang-9 and linking with lld-9 (details see [0]).
"clang-9" and "lld-9" are snapshot versions (details see [1]).

- Sedat -

[0] https://github.com/ClangBuiltLinux/linux/issues/431
[1] https://github.com/ClangBuiltLinux/linux/issues/431#issuecomment-508354865
