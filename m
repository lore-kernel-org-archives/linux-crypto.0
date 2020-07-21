Return-Path: <SRS0=Ahx1=BA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32EE1C433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 12:55:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E9E22073A
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 12:55:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PrIo3Et6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgGUMz2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 08:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgGUMz1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 08:55:27 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD12C061794
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 05:55:27 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id x9so16270449ila.3
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 05:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AqzJDDVj1xwZngYQAwyCqGd849U32xsDuBy2vQysZ6Q=;
        b=PrIo3Et6c3Rnv9FhU0ZGJ2a2eas93yzC/0qrXu17go0ITlQPYgQrpPei+CXmRkNZNK
         Ilyd10XV6VOvhlQYdpw9aFzsnRFJCXuGQJDnghX11mm9YNh5mZWVeGSTIS0r6cKxiXnW
         FPI5gRj7XmOSJKEGaItrpZ5uqD9JM4i33NgeJPtVh6bza74nyW5VK2t69hotef/vXVym
         HZmDNjIz4lfdhb6+0/y/oFWekEIF8m2r54ajQ6qYyZnyEmisqBbBnJ6O0v6yPVc6bv1A
         bf+jJ8R/hMdVvtryVwKdlyF+dfK5vj0b9OexllGhjMDLr+UOk/fqrbAeMSvNzzGUABMj
         /hPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AqzJDDVj1xwZngYQAwyCqGd849U32xsDuBy2vQysZ6Q=;
        b=Di12wZuoOS0YGtw7vLzZL3J0OU5FWWcNJgwHRhEw4mZxQgsyeMVBEu4V34juiffV4z
         +CSTOYbD8ASGWEk9LojCoXIKumbj92hd0UwJLUd5W2Q9TVQS2oZeBD9x0WB22/GtZOA6
         TLRCt2qByLylEZq8yq3OhKTCaSxx2p4U75E2VuXWOAhlnyuDvpMhRFu2ZdruCanCbpdc
         vzuIeQllA65YX+0pkf9aa0LXi1co0lP0jWn739+71s0CYvkXRet3nLkEryJjRSX21hYv
         qlAYn0+6RGWTtxHV0nFRUjA1RdsU98nHUTOxmhhtSDTr5l5SZp11AzUVPEjYMprdThCV
         iqFA==
X-Gm-Message-State: AOAM531mP5/X7PRN4Ipa9sJ+/q5l6sMZoGRJ1tqe/GaRd91OMMHdL0PP
        4r8IL/rIeOzdlZDBPiXH+UF2HnKGWAT+7GNVYKCedA==
X-Google-Smtp-Source: ABdhPJxUEnBPBwTf27s0KZuIpYKeYTR9OwvCFg7JOqfsnxBDXnsvGq7ORTyZrrfobp+t7vkxiazm6hR/UzNk4kjPDkY=
X-Received: by 2002:a92:58d1:: with SMTP id z78mr27555793ilf.276.1595336126054;
 Tue, 21 Jul 2020 05:55:26 -0700 (PDT)
MIME-Version: 1.0
References: <CABvBcwY44BPa+TaDwxWaEogpg3Kdkq8o9cR5gSqNGF-o6d3jrw@mail.gmail.com>
 <20200716164028.1805047-1-lenaptr@google.com> <13569541.ZYm5mLc6kN@tauon.chronox.de>
In-Reply-To: <13569541.ZYm5mLc6kN@tauon.chronox.de>
From:   Elena Petrova <lenaptr@google.com>
Date:   Tue, 21 Jul 2020 13:55:14 +0100
Message-ID: <CABvBcwZ5mQPVFNpw=mY29cXo8oU8yviW5FZEFdKBNLvaudH6Ow@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: af_alg - add extra parameters for DRBG interface
To:     Stephan Mueller <smueller@chronox.de>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jeffrey Vander Stoep <jeffv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

On Mon, 20 Jul 2020 at 18:35, Stephan Mueller <smueller@chronox.de> wrote:
>
> Am Donnerstag, 16. Juli 2020, 18:40:28 CEST schrieb Elena Petrova:
>
> Hi Elena,
>
> sorry for the delay in answering.
>
> > Extending the userspace RNG interface:
> >   1. adding ALG_SET_DRBG_ENTROPY setsockopt option for entropy input;
> >   2. using sendmsg syscall for specifying the additional data.
> >
> > Signed-off-by: Elena Petrova <lenaptr@google.com>
> > ---
> >
> > libkcapi patch for testing:
> >
> > https://github.com/Len0k/libkcapi/commit/6f095d270b982008f419078614c15caa59
> > 2cb531
>
> If that kernel patch is taken, I would be happy to take the libkcapi patch
> with the following suggested changes:
>
> - add full documentation of kcapi_rng_set_entropy and kcapi_rng_send_addtl to
> kcapi.h
>
> - move test_cavp into either test/kcapi-main.c or its own application inside
> test/ where the caller provides the entropy_input, personalization string,
> additional inputs

Ok, thanks!

> >
> > diff --git a/crypto/Kconfig b/crypto/Kconfig
> > index 091c0a0bbf26..8484617596d1 100644
> > --- a/crypto/Kconfig
> > +++ b/crypto/Kconfig
> > @@ -1896,6 +1896,14 @@ config CRYPTO_STATS
> >  config CRYPTO_HASH_INFO
> >       bool
> >
> > +config CRYPTO_CAVS_DRBG
>
> CAVS is dead, long live ACVT :-) So, maybe use CAVP or ACVT as abbreviations?

Ok, let's use CAVP then.

> As the config option applies to AF_ALG, wouldn't it be better to use an
> appropriate name here like CRYPTO_USER_API_CAVP_DRBG or similar?
>
> Note, if indeed we would add akcipher or even KPP with CAVP support, maybe we
> need additional config options here. So, I would recommend to use this
> separate name space.

Yes, that makes sense, thanks.

> > +     tristate "Enable CAVS testing of DRBG"
>
> Dto: replace CAVS

Ack

> > +#ifdef CONFIG_CRYPTO_CAVS_DRBG
> > +static int rng_setentropy(void *private, const u8 *entropy, unsigned int
> > len) +{
> > +     struct rng_parent_ctx *pctx = private;
> > +     u8 *kentropy = NULL;
> > +
> > +     if (!capable(CAP_SYS_ADMIN))
> > +             return -EPERM;
> > +
> > +     if (pctx->entropy)
> > +             return -EINVAL;
> > +
> > +     if (len > MAXSIZE)
> > +             len = MAXSIZE;
> > +
> > +     if (len) {
> > +             kentropy = memdup_user(entropy, len);
> > +             if (IS_ERR(kentropy))
> > +                     return PTR_ERR(kentropy);
> > +     }
> > +
> > +     crypto_rng_alg(pctx->drng)->set_ent(pctx->drng, kentropy, len);
> > +     pctx->entropy = kentropy;
>
> Why do you need to keep kentropy around? For the check above whether entropy
> was set, wouldn't a boolean suffice?

I need to keep the pointer to free it after use. Unlike the setting of
the key, DRBG saves the entropy pointer in one of its internal
structures, but doesn't do any memory
management. I had only two ideas on how to prevent memory leaks:
either change drbg code to deal with the memory, or save the pointer
somewhere inside the socket. I opted for the latter. But if you know a
better approach I'm happy to rework my code accordingly.

> > diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
> > index 56527c85d122..312fdb3469cf 100644
> > --- a/include/crypto/if_alg.h
> > +++ b/include/crypto/if_alg.h
> > @@ -46,6 +46,7 @@ struct af_alg_type {
> >       void *(*bind)(const char *name, u32 type, u32 mask);
> >       void (*release)(void *private);
> >       int (*setkey)(void *private, const u8 *key, unsigned int keylen);
> > +     int (*setentropy)(void *private, const u8 *entropy, unsigned int len);
> >       int (*accept)(void *private, struct sock *sk);
> >       int (*accept_nokey)(void *private, struct sock *sk);
> >       int (*setauthsize)(void *private, unsigned int authsize);
> > @@ -123,7 +124,7 @@ struct af_alg_async_req {
> >   * @tsgl_list:               Link to TX SGL
> >   * @iv:                      IV for cipher operation
> >   * @aead_assoclen:   Length of AAD for AEAD cipher operations
> > - * @completion:              Work queue for synchronous operation
> > + * @wait:            Wait on completion of async crypto ops
>
> What is this change about? I am not sure it relates to the changes above.

I noticed that the documentation for the function differs from the
function declaration, so I thought I'd fix that, since I touched the
header. But yeah, it doesn't relate to the changes.

> Ciao
> Stephan

Thanks,
Elena
