Return-Path: <SRS0=EEB8=UY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D25C48BD5
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 14:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1048208E3
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jun 2019 14:57:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XfZxVwfA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731297AbfFYO5p (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Jun 2019 10:57:45 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45698 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731260AbfFYO5p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jun 2019 10:57:45 -0400
Received: by mail-io1-f65.google.com with SMTP id e3so140835ioc.12
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jun 2019 07:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RBh67YpD0OD3yk7o9NnrHFyxQK0UDHxkzLQbD7b4rwE=;
        b=XfZxVwfASv28bRs/Mc62z3XSt8P5A0VDGk10sOg2hpvQ/5cPKvzpz1V3evOZF6/4KJ
         AnleaSm34GE+7y0SNhj0nWKJnSpeafz8CFG7td98q0mdy5jfOqCVEim45aUBQxSw0suc
         76Etm2Y+ItN2m/KpPNXEm4fbF+XO1GPglKF9r0CmOoOwHc77VoIqPdMmtG7vD4JSRHso
         uxU4pR19dQHXRqzJOulZLS8LdF7cKTQU4cIW/QbBA3r3xy9D0fKNs0cc9xyB/WoqZxK4
         7EuWRmOi++X4LezqrWCNe6yRol7AeBep4+y0X7CrpeJU41a4f3oBABymDEifprpTqJHq
         1tKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RBh67YpD0OD3yk7o9NnrHFyxQK0UDHxkzLQbD7b4rwE=;
        b=qyFKP/9uWIZxO5fh/mTKi+gu5H+uWonWPhK9TKKgDs9SSfYMVKTOAyWt5IjniDTocn
         opoCiEqGOZE/C2J2B70CNdl4MiGtf92MRg6uOqxmHe0DIz41hxpKTuh/SlZAWsrfxvay
         WVzaYu/rm+4CiqXGgIUja+4glTLPSn+KXOT4MMe9i8i9Y8v0guIx7IstKTpwIWbTGndX
         9gpigUn26sP7JrAF9NNGTcWtDgl0OF1/TscaU4FYoGIzOeINp05ZpUh9QLl4+I850BwU
         0F+P/eDq/4+8GOymZb9J88xd7wrVi8HynECE5okOOFgtxAIGau7z1KTGFTZAm0fX2knR
         3Zbg==
X-Gm-Message-State: APjAAAX/h4+7dF4AXkR+qiqHlKQJYu4hnBRvFhUJhPRZPekxstHgEnl1
        OgSaw8uMxxfzB6RlvpS8ritvaH2UZ45xW/sKEbiogA==
X-Google-Smtp-Source: APXvYqydvpi8w/9A5Oy0x7L4gDZlAzUZu5PBL/jut5pWoijZm/8R1k2vmedCHN3PysHlS+a0kc25WXaeeJo3EQAULuI=
X-Received: by 2002:a5d:8794:: with SMTP id f20mr5184824ion.128.1561474663956;
 Tue, 25 Jun 2019 07:57:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190624073818.29296-1-ard.biesheuvel@linaro.org>
 <20190624165641.GB211064@gmail.com> <CAFqZXNvE2YaanvjQJq41AdcQh8qeY3=idng29GT=8Pt61PU_uw@mail.gmail.com>
In-Reply-To: <CAFqZXNvE2YaanvjQJq41AdcQh8qeY3=idng29GT=8Pt61PU_uw@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 25 Jun 2019 16:57:32 +0200
Message-ID: <CAKv+Gu_MV+eiAvv4QiMA9_8NSrpMaxggd0Sd-KAMhvW52STTXA@mail.gmail.com>
Subject: Re: [PATCH 0/6] crypto: aegis128 - add NEON intrinsics version for ARM/arm64
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 25 Jun 2019 at 16:07, Ondrej Mosnacek <omosnace@redhat.com> wrote:
>
> On Mon, Jun 24, 2019 at 6:57 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > On Mon, Jun 24, 2019 at 09:38:12AM +0200, Ard Biesheuvel wrote:
> > > Now that aegis128 has been announced as one of the winners of the CAESAR
> > > competition, it's time to provide some better support for it on arm64 (and
> > > 32-bit ARM *)
> > >
> > > This time, instead of cloning the generic driver twice and rewriting half
> > > of it in arm64 and ARM assembly, add hooks for an accelerated SIMD path to
> > > the generic driver, and populate it with a C version using NEON intrinsics
> > > that can be built for both ARM and arm64. This results in a speedup of ~11x,
> > > resulting in a performance of 2.2 cycles per byte on Cortex-A53.
> > >
> > > Patches #1 .. #3 are some fixes/improvements for the generic code. Patch #4
> > > adds the plumbing for using a SIMD accelerated implementation. Patch #5
> > > adds the ARM and arm64 code, and patch #6 adds a speed test.
> > >
> > > Note that aegis128l and aegis256 were not selected, and nor where any of the
> > > morus contestants, and so we should probably consider dropping those drivers
> > > again.
> > >
> >
> > I'll also note that a few months ago there were attacks published on all
> > versions of full MORUS, with only 2^76 data and time complexity
> > (https://eprint.iacr.org/2019/172.pdf).  So MORUS is cryptographically broken,
> > and isn't really something that people should be using.  Ondrej, are people
> > actually using MORUS in the kernel?  I understand that you added it for your
> > Master's Thesis with the intent that it would be used with dm-integrity and
> > dm-crypt, but it's not clear that people are actually doing that.
>
> AFAIK, the only (potential) users are dm-crypt/dm-integrity and
> af_alg. I don't expect many (if any) users using it, but who knows...
> I don't have any problem with MORUS being removed from crypto API. It
> seems to be broken rather heavily...
>

OK, patch sent.
