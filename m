Return-Path: <SRS0=sEgb=BN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ADB8C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Aug 2020 14:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03AA12076C
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Aug 2020 14:55:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="afZEa9Is"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgHCOzB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Aug 2020 10:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbgHCOzB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Aug 2020 10:55:01 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F2BC06174A
        for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2020 07:48:14 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id z17so16208610ill.6
        for <linux-crypto@vger.kernel.org>; Mon, 03 Aug 2020 07:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZiVG74CBjFRbQEERa7N005E1k517NFDC015QhJsLxvk=;
        b=afZEa9IsG779qg1na27HNdmt95QiLDTPOT+xTfz92SZ8uA2dvTfg1AkIKVKxj32Nvq
         sDM5YUBdk+LaXT37gV1oTMUyLSrpsE1LHVCVH3LyDp3QfDuLwr1d/tLSJ74b9wjIYs6P
         28CnDh/n09YZlchGQ7Zjlw+47NRVHsiT/WOvpvMgTROTq4QPbCoB+Tyg7U5RDefl8REF
         D9tTGrSKhlhcF/tttCgIfiFmsZhLvB2L3MK5OYkWbzlbvS5gxx9ThUJMa9j6fW2E5WAE
         aVNd0hc+nVqa6OqdsRvvIIAiYV4jC0q+9rpT+9u01WWMWd2G8hVGY0JGRMzRR1isY84g
         zKfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZiVG74CBjFRbQEERa7N005E1k517NFDC015QhJsLxvk=;
        b=E8MMTNHfUOh8elJJzEZx3bo7mZUe+Y6dGx+dznVPHB8UHZRh3sLxRwHpYapKvsMEkp
         JxaKhrlFv3IUEww/IMR9nA3mH0WAJoDKvu6MF78+65xpiqpyuAjoWGgYuV26NmgK8Nvd
         oIKBd2M/9U8/4jJELZL6ecvjF75AdXUIYuzBcQkAcU3NyMHlSAKZVCG5LmscX4ytJxAV
         VtjNTmbwmasHHw+6tZFilQZhoFwQk//U9eaQgwpcfchAPHrKRWfq/QqrioTidK3R87bb
         zUpQQzPSCAw2IjqARnpZGRnNPdjci2jLiW3SrBA+4WT2hxpMoPz7ZlUi2PsZofPeNX5U
         3PfA==
X-Gm-Message-State: AOAM5334il+5eBghRq7adB2paZSkfNfTozBlaRZf/d2rW3UhkNN+Z3bS
        sB035PJvjgkhMG8SvRzT/PNLrb5e17ALAJDQXTWr+0a+Rj0=
X-Google-Smtp-Source: ABdhPJyPygm2qsoEww0tgpCsL/v8E6qn5MPnESYtLNkd+fnEtTMfknCbe8RHLywusWtfOiGBxLAMZi7jmkhBWTf/xN0=
X-Received: by 2002:a92:d4cf:: with SMTP id o15mr15435548ilm.160.1596466093573;
 Mon, 03 Aug 2020 07:48:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200729154501.2461888-1-lenaptr@google.com> <20200731072338.GA17285@gondor.apana.org.au>
In-Reply-To: <20200731072338.GA17285@gondor.apana.org.au>
From:   Elena Petrova <lenaptr@google.com>
Date:   Mon, 3 Aug 2020 15:48:02 +0100
Message-ID: <CABvBcwY-F6Euo2SAY6MKpT0KP7OtyswLhUmShPNPfB0qqL6heQ@mail.gmail.com>
Subject: Re: [PATCH v4] crypto: af_alg - add extra parameters for DRBG interface
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jeffrey Vander Stoep <jeffv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

> > +#ifdef CONFIG_CRYPTO_USER_API_CAVP_DRBG
> > +static int rng_setentropy(void *private, const u8 *entropy, unsigned int len)
>
> Please use __maybe_unused instead of the ifdef.

Ack

On Fri, 31 Jul 2020 at 08:27, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > lock_sock() would solve the former.  I'm not sure what should be done about
> > rng_recvmsg().  It apparently relies on the crypto_rng doing its own locking,
> > but maybe it should just use lock_sock() too.
>
> The lock_sock is only needed if you're doing testing.  What I'd
> prefer is to have a completely different code-path for testing.

sendmsg is used for "Additional Data" input, and unlike entropy, it
could be useful outside of testing. But if you confirm it's not
useful, then yes, I can decouple the testing parts.

> How about you fork the code in rng_accept_parent so that you have
> a separate proto_ops for the test path that is used only if
> setentropy has been called? That way all of this code could
> magically go away if the CONFIG option wasn't set.

Depends on the comment above, but otherwise, my only concern is that
the testing variant of rng_recvmsg would be largely copy-pasted from
the normal rng_recvmsg, apart from a few lines of lock/release and
crypto_rng_generate/crypto_rng_get_bytes.


Thanks!
Elena
