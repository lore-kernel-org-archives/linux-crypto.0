Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F04C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 07:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAC5723D37
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 07:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733102AbgLJHbl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Dec 2020 02:31:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728919AbgLJHbl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Dec 2020 02:31:41 -0500
X-Gm-Message-State: AOAM533zW6fLCQiXtU5RpJLXAaNUsWKMaucB3DCSFm9UsPrzXHRx6JxK
        WO3rkA9NigLEUz5o6ln+EOA3i3IXydtXhjEIDSQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607585459;
        bh=AzCj91TzxpXweVtX9FTRQKUrbJoQLeArn2OVDrgylG4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UixfHFeHuudoAikf20lKRJFWu52PaNc8NxNcTlTZp0LgX+t8Qn81ogmV2mkTJ216C
         hhesG7To9XjQSeGONTyuxP+gsXBqz5DcQ5P7XW0wNkHG1RYNNoipCWan1gDug5/p3u
         CDH/7K+c16ryHHBr+kYxKOcqNSasHQbQpaB2K/MOS8/TrOyAiVdLkxSU442N5k4p4b
         rJo//0qrv9sKeiVp+9P3CA0t6kkoncqgdNsCFKi3h/HMELjlTJA+OxiGkZAaEY/N1q
         rXtYx9H3yLrLpBa3I9wgxSK0KT1CQt0ImWgLWGEOW4UFahVC4Et1Uw+SjVoiuduRlt
         9Z26TSDjZebrA==
X-Google-Smtp-Source: ABdhPJx/5WbEdAs3+7i8o4zqTHa6NLXdnr3r+TSKTnZ9ZBouXQyZsiKin0ol/j8DotbM8p0XRdhlgmDl6hUiKAZ8N58=
X-Received: by 2002:aca:dd0b:: with SMTP id u11mr4593934oig.47.1607585459001;
 Wed, 09 Dec 2020 23:30:59 -0800 (PST)
MIME-Version: 1.0
References: <20201201194556.5220-1-ardb@kernel.org> <20201201215722.GA31941@gondor.apana.org.au>
 <CAMj1kXHb27ugTWuQZhPD0DvjtgYC8t_pj+igqK7dNfh+WsUS4w@mail.gmail.com>
 <20201201220431.GA32072@gondor.apana.org.au> <CAMj1kXGO+kbZ+2VmUQKxLYos2nR5vqZKjengxPxPjSXudG-zLw@mail.gmail.com>
 <20201201221628.GA32130@gondor.apana.org.au> <CAMj1kXFrLiHfv1S1AM=5pc1J9gWwZVuoGvmFoTT0-+oREoojTA@mail.gmail.com>
 <20201201231158.GA32274@gondor.apana.org.au> <CAMj1kXHwD5ktJTUrh8sndMY7P0kSFhgkGT66YJN1-ONUaU05-g@mail.gmail.com>
 <20201210024342.GA26428@gondor.apana.org.au> <e02fe07e-8cb6-f889-3228-60e4fabf4e40@candelatech.com>
In-Reply-To: <e02fe07e-8cb6-f889-3228-60e4fabf4e40@candelatech.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 10 Dec 2020 08:30:47 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF05XZtyakdpLixpP9Lroy0D3_gEcY2SFbSshD8ERUU7w@mail.gmail.com>
Message-ID: <CAMj1kXF05XZtyakdpLixpP9Lroy0D3_gEcY2SFbSshD8ERUU7w@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Ben Greear <greearb@candelatech.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steve deRosier <derosier@cal-sierra.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 10 Dec 2020 at 04:01, Ben Greear <greearb@candelatech.com> wrote:
>
> On 12/9/20 6:43 PM, Herbert Xu wrote:
> > On Thu, Dec 10, 2020 at 01:18:12AM +0100, Ard Biesheuvel wrote:
> >>
> >> One thing I realized just now is that in the current situation, all
> >> the synchronous skciphers already degrade like this.
> >>
> >> I.e., in Ben's case, without the special ccm implementation, ccm(aes)
> >> will resolve to ccm(ctr(aesni),cbcmac(aesni)), which is instantiated
> >> as a sync skcipher using the ctr and ccm/cbcmac templates built on top
> >> of the AES-NI cipher (not skcipher).  This cipher will also fall back
> >> to suboptimal scalar code if the SIMD is in use in process context.
> >
> > Sure, your patch is not making it any worse.  But I don't think
> > the extra code is worth it considering that you're still going to
> > be running into that slow fallback path all the time.
>
> How can we test this assumption?  I see 3x performance gain, so it is not hitting
> the fallback path much in my case.  What traffic pattern and protocol do you think
> will cause the slow fallback path to happen often enough to make this patch not
> helpful?
>

Is there a way to verify Herbert's assertion that TX and RX tend to be
handled by the same core? I am not a networking guy, but that seems
dubious to me.

You could add a pr_warn_ratelimited() inside the fallback path and see
if it ever gets called at all under various loads.

> > Much better to fix the wireless code to actually go async.
>
> This will not happen any time soon, so better to make incremental
> improvement in the crypt code.
>

I would argue that these are orthogonal. My patch improves both the
accelerated and the fallback path, given that the latter does not have
to walk the input data twice anymore, and go through 3 layers of
templates and the associated indirect calls for each 16 bytes of
input.

Of course, it would be better to avoid using the fallback path
altogether, but I don't think one should hold up the other.
