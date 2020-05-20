Return-Path: <SRS0=Eyne=7C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839F3C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 06:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 567E220657
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 06:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589956872;
	bh=Qgzm5Omvs4oJc9LoBEHGrGceOiNpLpQNzEShzQPpyUs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Zs1xWrN+JqIAUO3IMX9q+Zn/zX0Pxse91yikLfnTFvjszycpij9AyGHW9w5VANSRY
	 lfxf1HS/C4/tAnsWmWEkOGj7TAJSlwpGlaEUGLOisN8LIpYMzZouBccSO4R4Sn1VgE
	 uuIbgHLHZ7i2ew91YR94bVEQhoke9iHTUZ1fab5s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgETGlK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 May 2020 02:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgETGlK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 May 2020 02:41:10 -0400
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 539B920897
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2020 06:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589956869;
        bh=Qgzm5Omvs4oJc9LoBEHGrGceOiNpLpQNzEShzQPpyUs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kXcFH8JZtXdzrSYFxNlq8g9LexovFphnhDfbhrBRZnX3bkcK4xRqUTn2lOsBIleGh
         Z28d21cZdtn/+hjRN8RJHhKYASDR3xfo0/CHr2KLfYLS6g5RTzWUa1pBN3/BGzn6At
         y86M+Q3NyPJ7dN564oMywZcdcIyKOZ3Hpx8LNSXk=
Received: by mail-il1-f173.google.com with SMTP id o67so2047871ila.0
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2020 23:41:09 -0700 (PDT)
X-Gm-Message-State: AOAM5310ezTB0eSgUu7klOW7uXoRyzMkLzsDvs1pFRMRx8kx65p6z3Lx
        twPy7NT7JHLJ8P636ymkMOPYcpd9UWUj3Iq3n7w=
X-Google-Smtp-Source: ABdhPJzPt5lSpeelNjVE0xFeQuDqxigtSr4lzGDj5//CymV5Epryg8vWw0JB1CkAYuegIQ6uXoskKTXUFLfeUIgGVXE=
X-Received: by 2002:a92:bb55:: with SMTP id w82mr2552171ili.211.1589956868672;
 Tue, 19 May 2020 23:41:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200519190211.76855-1-ardb@kernel.org> <16565072.6IxHkjxkAd@tauon.chronox.de>
In-Reply-To: <16565072.6IxHkjxkAd@tauon.chronox.de>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 20 May 2020 08:40:57 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFDcHncnb=aUkWnX22Co2r4g3DSM+wug0FQ231Gv7J01Q@mail.gmail.com>
Message-ID: <CAMj1kXFDcHncnb=aUkWnX22Co2r4g3DSM+wug0FQ231Gv7J01Q@mail.gmail.com>
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

On Wed, 20 May 2020 at 08:03, Stephan Mueller <smueller@chronox.de> wrote:
>
> Am Dienstag, 19. Mai 2020, 21:02:09 CEST schrieb Ard Biesheuvel:
>
> Hi Ard,
>
> > Stephan reports that the arm64 implementation of cts(cbc(aes)) deviates
> > from the generic implementation in what it returns as the output IV. So
> > fix this, and add some test vectors to catch other non-compliant
> > implementations.
> >
> > Stephan, could you provide a reference for the NIST validation tool and
> > how it flags this behaviour as non-compliant? Thanks.
>
> The test definition that identified the inconsistent behavior is specified
> with [1]. Note, this testing is intended to become an RFC standard.
>

Are you referring to the line

CT[j] = AES_CBC_CS_ENCRYPT(Key[i], PT[j])

where the CTS transform is invoked without an IV altogether? That
simply seems like a bug to me. In an abstract specification like this,
it would be insane for pseudocode functions to be stateful objects,
and there is nothing in the pseudocode that explicitly captures the
'output IV' of that function call.


> To facilitate that testing, NIST offers an internet service, the ACVP server,
> that allows obtaining test vectors and uploading responses. You see the large
> number of concluded testing with [2]. A particular completion of the CTS
> testing I finished yesterday is given in [3]. That particular testing was also
> performed on an ARM system with CE where the issue was detected.
>
> I am performing the testing with [4] that has an extension to test the kernel
> crypto API.
>

OK. So given that that neither the CTS spec nor this document makes
any mention of an output IV or what its value should be, my suggestion
would be to capture the IV directly from the ciphertext, rather than
relying on some unspecified behavior to give you the right data. Note
that we have other implementations of cts(cbc(aes)) in the kernel as
well (h/w accelerated ones) and if there is no specification that
defines this behavior, you really shouldn't be relying on it.


That 'specification' invokes AES_CBC_CS_ENCRYPT() twice using a
different prototype, without any mention whatsoever what the implied
value of IV[] is if it is missing. This is especially problematic
given that it seems to cover all of CS1/2/3, and the relation between
next IV and ciphertext is not even the same between those for inputs
that are a multiple of the blocksize.


> [1] https://github.com/usnistgov/ACVP/blob/master/artifacts/draft-celi-acvp-block-ciph-00.txt#L366
>
> [2] https://csrc.nist.gov/projects/cryptographic-algorithm-validation-program/
> validation-search?searchMode=validation&family=1&productType=-1&ipp=25
>
> [3] https://csrc.nist.gov/projects/cryptographic-algorithm-validation-program/
> details?validation=32608
>
> [4] https://github.com/smuellerDD/acvpparser
> >
> > Cc: Stephan Mueller <smueller@chronox.de>
> >
> > Ard Biesheuvel (2):
> >   crypto: arm64/aes - align output IV with generic CBC-CTS driver
> >   crypto: testmgr - add output IVs for AES-CBC with ciphertext stealing
> >
> >  arch/arm64/crypto/aes-modes.S |  2 ++
> >  crypto/testmgr.h              | 12 ++++++++++++
> >  2 files changed, 14 insertions(+)
>
>
> Ciao
> Stephan
>
>
