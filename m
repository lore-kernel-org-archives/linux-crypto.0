Return-Path: <SRS0=gnyg=NA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E021AC67863
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Oct 2018 05:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 963C521502
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Oct 2018 05:27:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="cFSexrms"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 963C521502
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbeJTNgL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Oct 2018 09:36:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbeJTNgL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Oct 2018 09:36:11 -0400
Received: from sol.localdomain (c-67-185-97-198.hsd1.wa.comcast.net [67.185.97.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3BC021470;
        Sat, 20 Oct 2018 05:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540013219;
        bh=gWwhEbVHtpr/BdEfz0vfSd8QqlLbwg9J5UGG+AKJsyo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cFSexrmsGPEU3CrHxXyLJYLdZyFQaTAQvZ+TBdCB/P7FeW5DIp14IlWY2pT/MdrKA
         s+SGhX7Bt7lEmC4LmDSeFtdp594rxhH9kYs6YtphpP1W6KNQqrb7m93FT3YOJ2m6MP
         iDHAOlG9prQflEHSZkl0Mci8vySKD8C7hDmEGzGM=
Date:   Fri, 19 Oct 2018 22:26:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paul Crowley <paulcrowley@google.com>,
        Greg Kaiser <gkaiser@google.com>,
        Michael Halcrow <mhalcrow@google.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>
Subject: Re: [RFC PATCH v2 06/12] crypto: arm/chacha20 - refactor to allow
 varying number of rounds
Message-ID: <20181020052657.GB876@sol.localdomain>
References: <20181015175424.97147-1-ebiggers@kernel.org>
 <20181015175424.97147-7-ebiggers@kernel.org>
 <CAKv+Gu96nz-kMp8VwPZAoHC5jHvhZ4_jRYTDKS=XNmrqDW5i8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <CAKv+Gu96nz-kMp8VwPZAoHC5jHvhZ4_jRYTDKS=XNmrqDW5i8A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181020052658.TTIVRwYqjllUlXwuatv2jRfml3YfFA8r4KCeGFH8DE0@z>

Hi Ard,

On Sat, Oct 20, 2018 at 11:35:22AM +0800, Ard Biesheuvel wrote:
> On 16 October 2018 at 01:54, Eric Biggers <ebiggers@kernel.org> wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > In preparation for adding XChaCha12 support, rename/refactor the NEON
> > implementation of ChaCha20 to support different numbers of rounds.
> >
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> > ---
> >  arch/arm/crypto/Makefile                      |  4 +-
> >  ...hacha20-neon-core.S => chacha-neon-core.S} | 36 ++++++------
> >  ...hacha20-neon-glue.c => chacha-neon-glue.c} | 56 ++++++++++---------
> >  3 files changed, 52 insertions(+), 44 deletions(-)
> >  rename arch/arm/crypto/{chacha20-neon-core.S => chacha-neon-core.S} (96%)
> >  rename arch/arm/crypto/{chacha20-neon-glue.c => chacha-neon-glue.c} (73%)
> >
> > diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
> > index bd5bceef0605f..005482ff95047 100644
> > --- a/arch/arm/crypto/Makefile
> > +++ b/arch/arm/crypto/Makefile
> > @@ -9,7 +9,7 @@ obj-$(CONFIG_CRYPTO_SHA1_ARM) += sha1-arm.o
> >  obj-$(CONFIG_CRYPTO_SHA1_ARM_NEON) += sha1-arm-neon.o
> >  obj-$(CONFIG_CRYPTO_SHA256_ARM) += sha256-arm.o
> >  obj-$(CONFIG_CRYPTO_SHA512_ARM) += sha512-arm.o
> > -obj-$(CONFIG_CRYPTO_CHACHA20_NEON) += chacha20-neon.o
> > +obj-$(CONFIG_CRYPTO_CHACHA20_NEON) += chacha-neon.o
> >
> 
> I take it you are preserving the Kconfig symbol name to prevent
> breaking existing configs?

Yes, that's the intent.  Though perhaps we should just change it.

> 
> If so, we might consider doing something like
> 
> config CRYPTO_CHACHA20_NEON
>     tristate
> 
> config CRYPTO_CHACHA_NEON
>     default CRYPTO_CHACHA20_NEON
>     ... the existing kconfig symbol description ...
> 
> and drop the former at some point in the future?
> 

The problem is that only symbols with a prompt string can be set explicitly,
e.g. in a kconfig file.  So it's not possible to migrate a symbol to a new one
without breakage, unless both are to remain separately promptable.  It seems
there should be a way, but last I checked I don't think there was...

- Eric
