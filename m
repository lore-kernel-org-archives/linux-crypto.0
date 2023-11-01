Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA073C4332F
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Nov 2023 10:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbjKAKKr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Nov 2023 06:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234882AbjKAKKq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Nov 2023 06:10:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593EEE4
        for <linux-crypto@vger.kernel.org>; Wed,  1 Nov 2023 03:10:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D700BC433CC
        for <linux-crypto@vger.kernel.org>; Wed,  1 Nov 2023 10:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698833441;
        bh=QFH4mbOlwulYYasFS3YuYwTE92akGQL8J4F9Y36xcuI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=V3A9dZHWYN/ljW33r4rPDYX2hWgMeE5fTvsiql7Uu1cL216ab8euWmr2ZgeudaXJg
         Yl8vVJpFMCTJ0uch4n8S93s6z+HRj/gqxa3CW3sJ6Z+7cIC9eYYnObFo+vWBe9IEoF
         pdTV6uy8FqI+F66TjJHgEX5Pqhl7WEejLGUWWC3nQC12W/ynCYdB9udDi/jAiu8+cN
         9ozsRmE+9qffNQMVoSCxQXPU1zWw3uXzYI+QavEIQffBlUSqm7/0OOUfY6h4fiGxaR
         2Uvbjk5rhO3EAqwK3oUFDmWWQusXZZ5fkM9gZJw1q4TI9gjUJBoJZ+TY7ytwlXh9M7
         mkOyilr1RB1Sg==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-507a5f2193bso768095e87.1
        for <linux-crypto@vger.kernel.org>; Wed, 01 Nov 2023 03:10:41 -0700 (PDT)
X-Gm-Message-State: AOJu0YwGYeYNfEl4GtHEDaPoPqEt4ErjWkIbP4s5zQ9GuXJfqVHpxrEQ
        wKtHSh4ZolLWZaXNEwrOeCz4k3JncxWTnDJJmEc=
X-Google-Smtp-Source: AGHT+IGUolrzHl+5DPRZaJM1K8FO2NyqWCUzH8G7kYBqNXIiYIj6quDWBwTyhi8z0igm3YpdEz7izRR/1AFraApPjBY=
X-Received: by 2002:a05:6512:3189:b0:504:320a:b420 with SMTP id
 i9-20020a056512318900b00504320ab420mr785872lfe.17.1698833440076; Wed, 01 Nov
 2023 03:10:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAMj1kXF0e+MKyDJPS7r=LWusEBCaw=t03JC=+Dz0Qk+GmY+uXw@mail.gmail.com>
 <mhng-ff1fe914-36e9-42e8-88ac-44c7f6976e3d@palmer-ri-x1c9> <20231027-stage-cable-022844c2567d@spud>
In-Reply-To: <20231027-stage-cable-022844c2567d@spud>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 1 Nov 2023 11:10:28 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE7g9Xvn+SMRyJWJpC_Au3JguSMRj0p1cCF4azSMc6y2Q@mail.gmail.com>
Message-ID: <CAMj1kXE7g9Xvn+SMRyJWJpC_Au3JguSMRj0p1cCF4azSMc6y2Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: riscv/aes - Implement scalar Zkn version for RV32
To:     Conor Dooley <conor@kernel.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        linux-riscv@lists.infradead.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, christoph.muellner@vrull.eu,
        heiko.stuebner@vrull.eu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 27 Oct 2023 at 15:17, Conor Dooley <conor@kernel.org> wrote:
>
> On Fri, Oct 27, 2023 at 06:11:40AM -0700, Palmer Dabbelt wrote:
> > On Thu, 31 Aug 2023 10:10:21 PDT (-0700), Ard Biesheuvel wrote:
> > > On Fri, 4 Aug 2023 at 10:31, Ard Biesheuvel <ardb@kernel.org> wrote:
> > > >
> > > > On Fri, 4 Aug 2023 at 10:21, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > > > >
> > > ...
> > >
> > > > > Hi Ard:
> > > > >
> > > > > Any chance you could postpone this til after I've finished removing
> > > > > crypto_cipher?
> > > > >
> > > >
> > > > That's fine with me. Do you have an ETA on that? Need any help?
> > > >
> > > > I have implemented the scalar 64-bit counterpart as well in the mean time
> > >
> > > Is this still happening?
> >
> > I don't really know much about the crypto stuff, but looks like there's
> > still a "struct crypto_cipher" in my trees.  Am I still supposed to be
> > waiting on something?
>
> Regardless of crypto_cipher structs, this needs whatever series that
> actually implements Zkn detection from DT/ACPI to be merged first,
> as otherwise the definitions that iscv_isa_extension_available() depends
> on don't exist.
>

Please disregard this patch. I have an updated version already, but
I'll need to rebase it once the prerequisites are in place.

https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=riscv-scalar-aes
