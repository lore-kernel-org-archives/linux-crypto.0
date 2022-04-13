Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3962BC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Apr 2022 06:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbiDMGTA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Apr 2022 02:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbiDMGS7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Apr 2022 02:18:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E76340CE
        for <linux-crypto@vger.kernel.org>; Tue, 12 Apr 2022 23:16:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BB2461CF1
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 06:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0828C385AA
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 06:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649830598;
        bh=okRlPQNcB+6A2GoR1KXbY9jJModBQBGkTc2iPAB4FmE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Hc2Q1d4dmHsBNg6vj1/IOtdoyJGCzVDN3SqobL3FcB5P0ZbbtaUdbUEY43PlysS6k
         FdoVqX3XNgAZm/qmzPkLjbvwYeTTikAJOYFo7zYCqDzuH/aMEfhi/pfWubr4Kidohf
         kwaFHO19CuWq306/Z5+or/87d1yhw9DlOKKtnykDhqVXcXgKsal0EC9qDAdYt3QTAu
         4zbnS5JDkYNlkHZ30PyflziK//krMQWq3Zy8EStflQnqaRXexJvfMLd/WsYnr8qHyC
         bKUuLliJGtFOzGxJgt8UeO2Fxgk7ElA2XZoyHO7l2uwXZduxUOWTTtjXl2TOpZ809R
         3aMTRTp5aM+7A==
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-d6ca46da48so1002230fac.12
        for <linux-crypto@vger.kernel.org>; Tue, 12 Apr 2022 23:16:38 -0700 (PDT)
X-Gm-Message-State: AOAM531RZKLWMY8FWrd7LDktMH6SDFQG9saNk+Vnx+QklxJOK8qTCEhO
        ItVIFjk3NexBDDBevEhFu5/s2NMkvThj1zjosr4=
X-Google-Smtp-Source: ABdhPJyTEU5Ld+JducL+E0wR8/qSIBVvVJ5uZR0ho/+DxZ7jgaAd8UN6/dfIhQ6Y+oZVckF2C3G/1GVJ4f82SoLLW/M=
X-Received: by 2002:a05:6870:eaa5:b0:da:b3f:2b45 with SMTP id
 s37-20020a056870eaa500b000da0b3f2b45mr3814788oap.228.1649830597712; Tue, 12
 Apr 2022 23:16:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220412172816.917723-1-nhuck@google.com> <20220412172816.917723-9-nhuck@google.com>
 <YlZpUijo/1nJp0Bw@sol.localdomain>
In-Reply-To: <YlZpUijo/1nJp0Bw@sol.localdomain>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 13 Apr 2022 08:16:25 +0200
X-Gmail-Original-Message-ID: <CAMj1kXH1C8W6Cxa7jTZ8_h3L4_Xefwv2=r1JRNva101CvWWsjw@mail.gmail.com>
Message-ID: <CAMj1kXH1C8W6Cxa7jTZ8_h3L4_Xefwv2=r1JRNva101CvWWsjw@mail.gmail.com>
Subject: Re: [PATCH v4 8/8] fscrypt: Add HCTR2 support for filename encryption
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 13 Apr 2022 at 08:10, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Apr 12, 2022 at 05:28:16PM +0000, Nathan Huckleberry wrote:
> > HCTR2 is a tweakable, length-preserving encryption mode.  It has the
> > same security guarantees as Adiantum, but is intended for use on CPUs
> > with dedicated crypto instructions.  It fixes a known weakness with
> > filename encryption: when two filenames in the same directory share a
> > prefix of >= 16 bytes, with CTS-CBC their encrypted filenames share a
> > common substring, leaking information.  HCTR2 does not have this
> > problem.
> >
> > More information on HCTR2 can be found here: Length-preserving
> > encryption with HCTR2: https://eprint.iacr.org/2021/1441.pdf
>
> Please quote titles to distinguish them from the surrounding text.  E.g.
>
> More information on HCTR2 can be found in the paper "Length-preserving
> encryption with HCTR2" (https://eprint.iacr.org/2021/1441.pdf)
>
>
> >
> > Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> > ---
> >  Documentation/filesystems/fscrypt.rst | 19 ++++++++++++++-----
> >  fs/crypto/fscrypt_private.h           |  2 +-
> >  fs/crypto/keysetup.c                  |  7 +++++++
> >  fs/crypto/policy.c                    |  4 ++++
> >  include/uapi/linux/fscrypt.h          |  3 ++-
> >  tools/include/uapi/linux/fscrypt.h    |  3 ++-
> >  6 files changed, 30 insertions(+), 8 deletions(-)
>
> Can you make sure that all fscrypt patches are Cc'ed to the linux-fscrypt
> mailing list?  In this case, just Cc the whole series to there.
>
> >
> > diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> > index 4d5d50dca65c..09915086abd8 100644
> > --- a/Documentation/filesystems/fscrypt.rst
> > +++ b/Documentation/filesystems/fscrypt.rst
> > @@ -337,6 +337,7 @@ Currently, the following pairs of encryption modes are supported:
> >  - AES-256-XTS for contents and AES-256-CTS-CBC for filenames
> >  - AES-128-CBC for contents and AES-128-CTS-CBC for filenames
> >  - Adiantum for both contents and filenames
> > +- AES-256-XTS for contents and AES-256-HCTR2 for filenames
> >
> >  If unsure, you should use the (AES-256-XTS, AES-256-CTS-CBC) pair.
> >
> > @@ -357,6 +358,14 @@ To use Adiantum, CONFIG_CRYPTO_ADIANTUM must be enabled.  Also, fast
> >  implementations of ChaCha and NHPoly1305 should be enabled, e.g.
> >  CONFIG_CRYPTO_CHACHA20_NEON and CONFIG_CRYPTO_NHPOLY1305_NEON for ARM.
> >
> > +AES-256-HCTR2 is another true wide-block encryption mode.  It has the same
> > +security guarantees as Adiantum, but is intended for use on CPUs with dedicated
> > +crypto instructions. See the paper "Length-preserving encryption with HCTR2"
> > +(https://eprint.iacr.org/2021/1441.pdf) for more details. To use HCTR2,
> > +CONFIG_CRYPTO_HCTR2 must be enabled. Also, fast implementations of XCTR and
> > +POLYVAL should be enabled, e.g. CRYPTO_POLYVAL_ARM64_CE and
> > +CRYPTO_AES_ARM64_CE_BLK for ARM64.
>
> "same security guarantees as Adiantum" is not really correct.  Both Adiantum and
> HCTR2 are secure super-pseudorandom permutations if their underlying primitives
> are secure.  So their security guarantees are pretty similar, but not literally
> the same.  Can you reword this?  This potentially-misleading claim also showed
> up in the commit message.
>
> > diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
> > index ed3d623724cd..fa8bdb8c76b7 100644
> > --- a/fs/crypto/policy.c
> > +++ b/fs/crypto/policy.c
> > @@ -54,6 +54,10 @@ static bool fscrypt_valid_enc_modes(u32 contents_mode, u32 filenames_mode)
> >           filenames_mode == FSCRYPT_MODE_ADIANTUM)
> >               return true;
> >
> > +     if (contents_mode == FSCRYPT_MODE_AES_256_XTS &&
> > +         filenames_mode == FSCRYPT_MODE_AES_256_HCTR2)
> > +             return true;
> > +
> >       return false;
> >  }
>
> This is allowing HCTR2 for both v1 and v2 encryption policies.  I don't think we
> should add any new features to v1 encryption policies, as they are deprecated.
> How about allowing HCTR2 for v2 encryption policies only?  This is the first new
> encryption mode where this issue has come up, but this could be handled easily
> by splitting fscrypt_valid_enc_modes() into fscrypt_valid_enc_modes_v1() and
> fscrypt_valid_enc_modes_v2().  The v2 one can call the v1 one to share code.
>
> > diff --git a/tools/include/uapi/linux/fscrypt.h b/tools/include/uapi/linux/fscrypt.h
> > index 9f4428be3e36..a756b29afcc2 100644
> > --- a/tools/include/uapi/linux/fscrypt.h
> > +++ b/tools/include/uapi/linux/fscrypt.h
> > @@ -27,7 +27,8 @@
> >  #define FSCRYPT_MODE_AES_128_CBC             5
> >  #define FSCRYPT_MODE_AES_128_CTS             6
> >  #define FSCRYPT_MODE_ADIANTUM                        9
> > -/* If adding a mode number > 9, update FSCRYPT_MODE_MAX in fscrypt_private.h */
> > +#define FSCRYPT_MODE_AES_256_HCTR2           10
> > +/* If adding a mode number > 10, update FSCRYPT_MODE_MAX in fscrypt_private.h */
> >
>
> As far as I know, you don't actually need to update the copy of UAPI headers in
> tools/.  The people who maintain those files handle that.  It doesn't make sense
> to have copies of files in the source tree anyway.
>

Doesn't the x86 build emit a warning if these go out of sync?
