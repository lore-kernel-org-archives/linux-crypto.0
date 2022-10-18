Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B9CC4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Oct 2022 13:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiJRNxJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Oct 2022 09:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJRNxG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2022 09:53:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899B6CF846
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 06:53:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72CDC615A6
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 13:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E9FC43144
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 13:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666101182;
        bh=BSDYmUetwBIPUtsDuswHZpT1TQxNmKAicztx7uSV49g=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ScZsWveHb+u1Tt+GMgzrCyl7aRK7mMnXAYdJ1QXozNMg1KQpA5w3R6CQmloYkISLz
         6mpJ3Gr+0ZWLkr0kQfRbisLYYDAyAY3qybCJkFCRbKS5EYYUbscMZytEjeGMV6+mcd
         WRNEzifu57gzP+dC/G322+G+fVtGGNP9AGDvcsvLZvkUroc7ZijQ5bvo2dckkuGqBf
         D0/+wsWQFjDxjQmOMEK6NlVWufAees5ln0XpfPIVoHJS482Enq2BG+ej417CC/fFe+
         ROfVhxR7ggHYlT1SVsSmjWU94lmPfbCIrBkXRITcuQKUY2H+ebt39ZmrPk2v2BR5H1
         anex2k90QeQ9w==
Received: by mail-lf1-f54.google.com with SMTP id d6so22591968lfs.10
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 06:53:02 -0700 (PDT)
X-Gm-Message-State: ACrzQf3hMEK9kvMyfafQv6mhTKrzgcd9HMYkI979S6ye1vVjLV2FUVDV
        bhFeTtsnGmAk8JbKb/MW7/kud0Pd42KJbunpLTk=
X-Google-Smtp-Source: AMsMyM5WELQTYNAzvJaBUvA55snbSzQinMexjqa4ilJV8sT9I+IB6caOiUY31Y52nDonnkdRKyKK3fWhNVmwGRUa6Og=
X-Received: by 2002:a05:6512:104a:b0:4a2:9c7b:c9c with SMTP id
 c10-20020a056512104a00b004a29c7b0c9cmr999036lfb.122.1666101180786; Tue, 18
 Oct 2022 06:53:00 -0700 (PDT)
MIME-Version: 1.0
References: <20221014104713.2613195-1-ardb@kernel.org> <Y02c4kfTIj4XZxNV@sol.localdomain>
In-Reply-To: <Y02c4kfTIj4XZxNV@sol.localdomain>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 18 Oct 2022 15:52:49 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF9A4z=_XeT7F-4gVxz7zwgaTqYtoN9G36LSpK9Vr2CFQ@mail.gmail.com>
Message-ID: <CAMj1kXF9A4z=_XeT7F-4gVxz7zwgaTqYtoN9G36LSpK9Vr2CFQ@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: gcmaes - Provide minimal library implementation
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, keescook@chromium.org,
        jason@zx2c4.com, herbert@gondor.apana.org.au,
        Nikunj A Dadhania <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 17 Oct 2022 at 20:20, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, Oct 14, 2022 at 12:47:13PM +0200, Ard Biesheuvel wrote:
> > Note that table based AES implementations are susceptible to known
> > plaintext timing attacks on the encryption key. The AES library already
> > attempts to mitigate this to some extent, but given that the counter
> > mode encryption used by GCM operates exclusively on known plaintext by
> > construction (the IV and therefore the initial counter value are known
> > to an attacker), let's take some extra care to mitigate this, by calling
> > the AES library with interrupts disabled.
>
> Note that crypto/gf128mul.c has no mitigations against timing attacks.  I take
> it that is something that needs to be tolerated here?
>

Ah good point - I misremembered and thought that the 'slow' version
without the expanded key uses not table lookups at all.

I can add a patch to address this, it doesn't seem all that difficult
to remove the table lookups and data or key dependent conditionals.

> > diff --git a/include/crypto/gcm.h b/include/crypto/gcm.h
> > index 9d7eff04f224..dfbc381df5ae 100644
> > --- a/include/crypto/gcm.h
> > +++ b/include/crypto/gcm.h
> > @@ -3,6 +3,9 @@
> >
> >  #include <linux/errno.h>
> >
> > +#include <crypto/aes.h>
> > +#include <crypto/gf128mul.h>
> > +
> >  #define GCM_AES_IV_SIZE 12
> >  #define GCM_RFC4106_IV_SIZE 8
> >  #define GCM_RFC4543_IV_SIZE 8
> > @@ -60,4 +63,67 @@ static inline int crypto_ipsec_check_assoclen(unsigned int assoclen)
> >
> >       return 0;
> >  }
> > +
> > +struct gcmaes_ctx {
> > +     be128                   ghash_key;
> > +     struct crypto_aes_ctx   aes_ctx;
> > +     unsigned int            authsize;
> > +};
> > +
> > +/**
> > + * gcmaes_expandkey - Expands the AES and GHASH keys for the GCM-AES key
> > + *                 schedule
> > + *
> > + * @ctx:     The data structure that will hold the GCM-AES key schedule
> > + * @key:     The AES encryption input key
> > + * @keysize: The length in bytes of the input key
> > + * @authsize:        The size in bytes of the GCM authentication tag
> > + *
> > + * Returns 0 on success, or -EINVAL if @keysize or @authsize contain values
> > + * that are not permitted by the GCM specification.
> > + */
> > +int gcmaes_expandkey(struct gcmaes_ctx *ctx, const u8 *key,
> > +                  unsigned int keysize, unsigned int authsize);
>
> These comments are duplicated in the .c file too.  They should be in just one
> place, probably the .c file since that approach is more common in the kernel.
>

OK

> Also, this seems to be intended to be a kerneldoc comment, but the return value
> isn't documented in the correct format.  It needs to be "Return:".  Try this:
>
> $ ./scripts/kernel-doc -v -none lib/crypto/gcmaes.c
> lib/crypto/gcmaes.c:35: info: Scanning doc for function gcmaes_expandkey
> lib/crypto/gcmaes.c:48: warning: No description found for return value of 'gcmaes_expandkey'
> lib/crypto/gcmaes.c:114: info: Scanning doc for function gcmaes_encrypt
> lib/crypto/gcmaes.c:142: info: Scanning doc for function gcmaes_decrypt
> lib/crypto/gcmaes.c:162: warning: No description found for return value of 'gcmaes_decrypt'
>

OK, will fix.

> > +config CRYPTO_LIB_GCMAES
> > +     tristate
> > +     select CRYPTO_GF128MUL
> > +     select CRYPTO_LIB_AES
> > +     select CRYPTO_LIB_UTILS
>
> Doesn't this mean that crypto/gf128mul.c needs to be moved into lib/crypto/?
>

Probably, I'll address that as well in v3.

Thanks,
Ard.
