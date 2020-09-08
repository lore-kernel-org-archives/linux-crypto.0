Return-Path: <SRS0=6HzI=CR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C717C433E2
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Sep 2020 17:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E9B42087D
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Sep 2020 17:19:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ehU0e5D9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgIHRTE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Sep 2020 13:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730249AbgIHRSy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Sep 2020 13:18:54 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E41C061573
        for <linux-crypto@vger.kernel.org>; Tue,  8 Sep 2020 10:18:53 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id q6so16097002ild.12
        for <linux-crypto@vger.kernel.org>; Tue, 08 Sep 2020 10:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nBuWqIh94Za8Z8YJhBwtRXjthJBFaFEN+ixL8OjHzms=;
        b=ehU0e5D944k6bZX75+tAkyyIPGR338R299ZSnYRKIvdIhcClyWfnJo29EVl6QOSS7X
         mmPJG9A12GnOKaudwdkIriAT20hTPRXVy7CXET3ZSsK2dqUu5f/G4qtXbuB08ys+jplk
         AqpnpPSKUHQcWy+ullDrqosXTiixddZHu1/t9B7A+EDeDGS531EPZB3zJ82CHbjEOtR3
         IVI3JMZ9q5WtppWeOT3YM/bcjCbIecbH+w0SN+r00yC5DJbEupxlLMCeIgw/LEHNWzX4
         GRK6SVhdNFfTFwRn8n/nZ5IRyOXF90Tg+RFfbE8d6jJ/aPHY/EAh/kGxole/NkRIYsG3
         1keQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nBuWqIh94Za8Z8YJhBwtRXjthJBFaFEN+ixL8OjHzms=;
        b=eweHEz1KQ+sd1k78BQQkGNykKpayArzri4AvRvQjjvPmcXQKKIbGOZKmb03S2nk38S
         oeTHBtzskoNSCjd9G0lijDgZ7k108e4BbbkHd+qJSzb1yh2qavHtmD1CiINaW3EmKbin
         mPjCrPUvZMPWCnrlvbH49GDe+pSHPSnZeDb8Bp4chvzXRjNmcT+8vvWBqlmvuurZRkY9
         mVGOsde7/hoom+e2KEIdFTM0OgYOXcy45eDKWaJDjDjGPsSqWKS4uqNZoWRyP/lRkpnr
         XdXL0o0Sz2qKLYcsIptOYSDPcnxr/JEVbqLgGCvEyR+Bx2UaI1nKBeN+OoANAXFai6hq
         ORCg==
X-Gm-Message-State: AOAM531D0M4f4+QXHMLTu4ChxcifcIcPYccthbAX9ZIoNWXwnuEgdgol
        1OiSzduhUONYCad0UCnKiG5jX8bOFHnJbdapZmbziN+yzPkteg==
X-Google-Smtp-Source: ABdhPJwcXRrX5TFuJPKEA45Ut8Yo6Sg88+O8vtC5tDNI50vbZXoT2cW4/r29UW85ujZUeTKv6epIhU2I7Ngg1QuM8Hc=
X-Received: by 2002:a92:9a1d:: with SMTP id t29mr20978562ili.160.1599585532978;
 Tue, 08 Sep 2020 10:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <CABvBcwYPXvK1_b2hR5THaqfq8nKVwppdBd2aJF6cmS_aCxHxUg@mail.gmail.com>
 <20200813160811.3568494-1-lenaptr@google.com> <20200813193239.GA2470@sol.localdomain>
In-Reply-To: <20200813193239.GA2470@sol.localdomain>
From:   Elena Petrova <lenaptr@google.com>
Date:   Tue, 8 Sep 2020 18:18:41 +0100
Message-ID: <CABvBcwZtWQZsYGd-aUPm+gARtKm5TV-c4dFq6Hz9tuWPQ3uH6Q@mail.gmail.com>
Subject: Re: [PATCH v5] crypto: af_alg - add extra parameters for DRBG interface
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jeffrey Vander Stoep <jeffv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 13 Aug 2020 at 20:32, Eric Biggers <ebiggers@kernel.org> wrote:

> >  Depending on the RNG type, the RNG must be seeded. The seed is provided
> >  using the setsockopt interface to set the key. For example, the
> >  ansi_cprng requires a seed. The DRBGs do not require a seed, but may be
> > -seeded.
> > +seeded. The seed is also known as a *Personalization String* in DRBG800-90A
> > +standard.
>
> Isn't the standard called "NIST SP 800-90A"?
> "DRBG800-90A" doesn't return many hits on Google.

Fixed, thanks!

> > +For the purpose of CAVP testing, the concatenation of *Entropy* and *Nonce*
> > +can be provided to the RNG via ALG_SET_DRBG_ENTROPY setsockopt interface. This
> > +requires a kernel built with CONFIG_CRYPTO_USER_API_CAVP_DRBG, and
> > +CAP_SYS_ADMIN permission.
> > +
> > +*Additional Data* can be provided using the send()/sendmsg() system calls.
>
> This doesn't make it clear whether the support for "Additional Data" is
> dependent on CONFIG_CRYPTO_USER_API_CAVP_DRBG or not.

Fixed.

> > +config CRYPTO_USER_API_CAVP_DRBG
> > +     tristate "Enable CAVP testing of DRBG"
> > +     depends on CRYPTO_USER_API_RNG && CRYPTO_DRBG
> > +     help
> > +       This option enables extra API for CAVP testing via the user-space
> > +       interface: resetting of DRBG entropy, and providing Additional Data.
> > +       This should only be enabled for CAVP testing. You should say
> > +       no unless you know what this is.
>
> Using "tristate" here is incorrect because this option is not a module itself.
> It's an option *for* a module.  So it needs to be "bool" instead.

Done.

> Also, since this is an option to refine CRYPTO_USER_API_RNG, how about renaming
> it to "CRYPTO_USER_API_RNG_CAVP", and moving it to just below the definition of
> "CRYPTO_USER_API_RNG" so that they show up adjacent to each other?

Sounds good, done.

> > +static int rng_test_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> > +                         int flags)
> > +{
> > +     struct sock *sk = sock->sk;
> > +     struct alg_sock *ask = alg_sk(sk);
> > +     struct rng_ctx *ctx = ask->private;
> > +     int err;
> > +
> > +     lock_sock(sock->sk);
> > +     err = _rng_recvmsg(ctx->drng, msg, len, ctx->addtl, ctx->addtl_len);
> > +     rng_reset_addtl(ctx);
> > +     release_sock(sock->sk);
> > +
> > +     return err ? err : len;
>
> Shouldn't this just return the value that _rng_recvmsg() returned?
>
> Also 'err' is conventionally just for 0 or -errno codes.  Use 'ret' if the
> variable can also hold a length.

Done.
