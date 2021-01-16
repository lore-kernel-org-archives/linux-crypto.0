Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40324C433E6
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 17:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15E26227C3
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 17:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbhAPRUI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Jan 2021 12:20:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726862AbhAPRUG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Jan 2021 12:20:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3D2722C7D;
        Sat, 16 Jan 2021 16:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610815736;
        bh=pMRmEfmK5x7Y5a3dLDsXXNF4VdLrvyiV1rn4YphuYew=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fVkFxmC294BzdBLz+Ab4b4PULBzTa06oft8SvVS58cZs4UfrjHXkvlgzlF6TjhGCZ
         9qNlLFJc9pVOhINFcnihOuB4CCHg9rdFXx69+mykiIbEg9sU62/87fsUgHVro54e3S
         sIAj6MJXA7d7E5RGHfI3YPT6qcTcf1Fjouw8xczYyTfMqqPTVTaVVBP8KzLd92F6qo
         H7Ousc4TfW9bMF0xV1P07iGBeV5aEQGNbYPmeUayd95jqLwBTBfEArWwdtXp8qQPBd
         8jFXiQsmE1MMINm4zbeK4Y6+ZhWz88G3Mh/tAIRnEVGg6DWwqY7JrMO+blZou4Nst5
         wx9r43sngMYnw==
Received: by mail-oi1-f171.google.com with SMTP id d203so13088647oia.0;
        Sat, 16 Jan 2021 08:48:56 -0800 (PST)
X-Gm-Message-State: AOAM531L+ozTXRLzRP0eqR2D8NbTg7S6wNxlkhzhe8XM+JOoDiB0+x7x
        Qzl4bulPQWCQio4bYPrKT4fGoxoKkvcR20Tkls8=
X-Google-Smtp-Source: ABdhPJz3aVQKYdFzZAElS5YeQckBrqVvMe0bdcRA9AlrYV1YQTnLoqQQe8RJvABoARwVBurVSsndkjYP6gTvcIdcq1g=
X-Received: by 2002:aca:210f:: with SMTP id 15mr8952220oiz.174.1610815736088;
 Sat, 16 Jan 2021 08:48:56 -0800 (PST)
MIME-Version: 1.0
References: <1608325864-4033-1-git-send-email-megha.dey@intel.com>
 <1608325864-4033-4-git-send-email-megha.dey@intel.com> <CAMj1kXGhGopfg19at5N_9q89-UA4irSgMULyDXg+dKhnbRrCZQ@mail.gmail.com>
 <dfb5f2e0-027d-2b9c-aec7-313ff0275381@intel.com> <83d87dec-dd76-1ddc-1e20-4bf1c7db7918@intel.com>
 <YAJJmzWm3rPcdxMs@gmail.com> <7cdbce42-2d40-95bc-d719-62a1580d6ebf@intel.com>
In-Reply-To: <7cdbce42-2d40-95bc-d719-62a1580d6ebf@intel.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 16 Jan 2021 17:48:45 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHVGQhMO83qtkVGBV9ghTDrYv+VRz4+vwp91bVoJFqGiw@mail.gmail.com>
Message-ID: <CAMj1kXHVGQhMO83qtkVGBV9ghTDrYv+VRz4+vwp91bVoJFqGiw@mail.gmail.com>
Subject: Re: [RFC V1 3/7] crypto: ghash - Optimized GHASH computations
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ravi.v.shankar@intel.com, tim.c.chen@intel.com,
        andi.kleen@intel.com, wajdi.k.feghali@intel.com,
        greg.b.tucker@intel.com, robert.a.kasten@intel.com,
        rajendrakumar.chinnaiyan@intel.com, tomasz.kantecki@intel.com,
        ryan.d.saffores@intel.com, ilya.albrekht@intel.com,
        kyung.min.park@intel.com, Tony Luck <tony.luck@intel.com>,
        ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 16 Jan 2021 at 06:13, Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 1/15/21 6:04 PM, Eric Biggers wrote:
> > On Fri, Jan 15, 2021 at 04:20:44PM -0800, Dave Hansen wrote:
> >> On 1/15/21 4:14 PM, Dey, Megha wrote:
> >>> Also, I do not know of any cores that implement PCLMULQDQ and not AES-NI.
> >> That's true, bit it's also possible that a hypervisor could enumerate
> >> support for PCLMULQDQ and not AES-NI.  In general, we've tried to
> >> implement x86 CPU features independently, even if they never show up in
> >> a real CPU independently.
> > We only add optimized implementations of crypto algorithms if they are actually
> > useful, though.  If they would never be used in practice, that's not useful.
>
> Yes, totally agree.  If it's not of practical use, it doesn't get merged.
>
> I just wanted to share what we do for other related but independent CPU
> features.

Thanks for the insight.

The issue with the current GHASH driver is that it uses infrastructure
that we may decide to remove (the async cryptd helper [0]). So adding
more dependencies on that without any proven benefit should obviously
be avoided at this time as well.

[0] https://lore.kernel.org/linux-arm-kernel/20201218170106.23280-1-ardb@kernel.org/
