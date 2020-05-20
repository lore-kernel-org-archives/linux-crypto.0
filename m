Return-Path: <SRS0=Eyne=7C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D0AC433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 06:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AAFF207F9
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 06:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589957664;
	bh=eWp/57KR02jyX9RDzX1ISdFvZf2YxceO+Vn9nPLMua8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=s76ugPCDU7uibf/j2j5E0NRiRogSXz1APOr8IIMha0tr1Udeq9uFW5dlnk85UZk7T
	 GEQqb9w7iq4eEMT1Ok04uiZNU/Z/VGEeXK4j+8hb9lPVFAvGPiJ8FLlQ5qKYaomzX8
	 JN7gOKe9Dl26b8lAtTJCkGQx52WASbgN3rIgabEU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgETGyX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 May 2020 02:54:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725998AbgETGyX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 May 2020 02:54:23 -0400
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F344207F9
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2020 06:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589957662;
        bh=eWp/57KR02jyX9RDzX1ISdFvZf2YxceO+Vn9nPLMua8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=xDgHv/cuD2F8VEBm0uBVWfwbFe5BH1zpvCJQ2bPpzFGmTtNTHr74DVM0epIeVktw/
         GFKxYDrhL4LOxu33DFKJ+3KBfBdzNiECgdgv9MrPmDyIMK0DHyoPKxHrmUCjvjL4tO
         wjHLtRYNLY+nuvohag4HpIRGRZHXHSGDiWMHj59c=
Received: by mail-il1-f171.google.com with SMTP id a14so2059612ilk.2
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2020 23:54:22 -0700 (PDT)
X-Gm-Message-State: AOAM530myBnCz3FDeXuRk6DehV++rymjioXUQAtZZ6uZU7cUpDDM8hxU
        JoZJ12xAfhJdar5E7nkoragYUC1EiqLvExDLBIw=
X-Google-Smtp-Source: ABdhPJw2/PZLQnnkWxphIMOmmYVSjRQF+quPQTdSMC4mRXDBf9KRtIfAHuL17pijTj4Hqf2DV6okOiexSDDO/vBDqNQ=
X-Received: by 2002:a92:8555:: with SMTP id f82mr2474982ilh.279.1589957661560;
 Tue, 19 May 2020 23:54:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200519190211.76855-1-ardb@kernel.org> <16565072.6IxHkjxkAd@tauon.chronox.de>
 <CAMj1kXFDcHncnb=aUkWnX22Co2r4g3DSM+wug0FQ231Gv7J01Q@mail.gmail.com> <16394356.0UTfFWEGjO@tauon.chronox.de>
In-Reply-To: <16394356.0UTfFWEGjO@tauon.chronox.de>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 20 May 2020 08:54:10 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF=Duh1AsAQy+aLWMcJPQ4RFL5p9-Mnmn-XAiCkzyGFbg@mail.gmail.com>
Message-ID: <CAMj1kXF=Duh1AsAQy+aLWMcJPQ4RFL5p9-Mnmn-XAiCkzyGFbg@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH 0/2] crypto: add CTS output IVs for arm64 and testmgr
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 20 May 2020 at 08:47, Stephan Mueller <smueller@chronox.de> wrote:
>
> Am Mittwoch, 20. Mai 2020, 08:40:57 CEST schrieb Ard Biesheuvel:
>
> Hi Ard,
>
> > On Wed, 20 May 2020 at 08:03, Stephan Mueller <smueller@chronox.de> wrote:
> > > Am Dienstag, 19. Mai 2020, 21:02:09 CEST schrieb Ard Biesheuvel:
> > >
> > > Hi Ard,
> > >
> > > > Stephan reports that the arm64 implementation of cts(cbc(aes)) deviates
> > > > from the generic implementation in what it returns as the output IV. So
> > > > fix this, and add some test vectors to catch other non-compliant
> > > > implementations.
> > > >
> > > > Stephan, could you provide a reference for the NIST validation tool and
> > > > how it flags this behaviour as non-compliant? Thanks.
> > >
> > > The test definition that identified the inconsistent behavior is specified
> > > with [1]. Note, this testing is intended to become an RFC standard.
> >
> > Are you referring to the line
> >
> > CT[j] = AES_CBC_CS_ENCRYPT(Key[i], PT[j])
> >
> > where the CTS transform is invoked without an IV altogether?
>
> Precisely.
>
> > That
> > simply seems like a bug to me. In an abstract specification like this,
> > it would be insane for pseudocode functions to be stateful objects,
> > and there is nothing in the pseudocode that explicitly captures the
> > 'output IV' of that function call.
>
> I think the description may be updated by simply refer to IV[j-1]. Then you
> would not have a stateful operation, but you rest on the IV of the previous
> operation.
>

But that value is not the value you are using now, right? I suspect
that the line

IV[i+1] = MSB(CT[j], IV.length)

needs to be duplicated in the inner loop for j, although that would
require different versions for CS1/2/3


> The state of all block chaining modes we currently have is defined with the
> IV. That is the reason why I mentioned it can be implemented stateless when I
> am able to get the IV output from the previous operation.
>

But it is simply the same as the penultimate block of ciphertext. So
you can simply capture it after encrypt, or before decrypt. There is
really no need to rely on the CTS transformation to pass it back to
you via the buffer that is only specified to provide an input to the
CTS transform.


> >
> > > To facilitate that testing, NIST offers an internet service, the ACVP
> > > server, that allows obtaining test vectors and uploading responses. You
> > > see the large number of concluded testing with [2]. A particular
> > > completion of the CTS testing I finished yesterday is given in [3]. That
> > > particular testing was also performed on an ARM system with CE where the
> > > issue was detected.
> > >
> > > I am performing the testing with [4] that has an extension to test the
> > > kernel crypto API.
> >
> > OK. So given that that neither the CTS spec nor this document makes
> > any mention of an output IV or what its value should be, my suggestion
> > would be to capture the IV directly from the ciphertext, rather than
> > relying on some unspecified behavior to give you the right data. Note
> > that we have other implementations of cts(cbc(aes)) in the kernel as
> > well (h/w accelerated ones) and if there is no specification that
> > defines this behavior, you really shouldn't be relying on it.
>
> Agreed, but all I need is the IV from the previous round without relying on
> any state.

So just grab it from the ciphertext of the previous round.

> >
> >
> > That 'specification' invokes AES_CBC_CS_ENCRYPT() twice using a
> > different prototype, without any mention whatsoever what the implied
> > value of IV[] is if it is missing. This is especially problematic
> > given that it seems to cover all of CS1/2/3, and the relation between
> > next IV and ciphertext is not even the same between those for inputs
> > that are a multiple of the blocksize.
>
> I will relay that comment back to the authors for update.

Thanks.


> >
> > > [1]
> > > https://github.com/usnistgov/ACVP/blob/master/artifacts/draft-celi-acvp-b
> > > lock-ciph-00.txt#L366
> > >
> > > [2]
> > > https://csrc.nist.gov/projects/cryptographic-algorithm-validation-program
> > > / validation-search?searchMode=validation&family=1&productType=-1&ipp=25
> > >
> > > [3]
> > > https://csrc.nist.gov/projects/cryptographic-algorithm-validation-program
> > > / details?validation=32608
> > >
> > > [4] https://github.com/smuellerDD/acvpparser
> > >
> > > > Cc: Stephan Mueller <smueller@chronox.de>
> > > >
> > > > Ard Biesheuvel (2):
> > > >   crypto: arm64/aes - align output IV with generic CBC-CTS driver
> > > >   crypto: testmgr - add output IVs for AES-CBC with ciphertext stealing
> > > >
> > > >  arch/arm64/crypto/aes-modes.S |  2 ++
> > > >  crypto/testmgr.h              | 12 ++++++++++++
> > > >  2 files changed, 14 insertions(+)
> > >
> > > Ciao
> > > Stephan
>
>
> Ciao
> Stephan
>
>
