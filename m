Return-Path: <SRS0=WH6x=DO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA80AC4727E
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 04:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6391420B1F
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 04:21:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IAtzqnsh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgJGEVM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Oct 2020 00:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgJGEVK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Oct 2020 00:21:10 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF7EC0613D2
        for <linux-crypto@vger.kernel.org>; Tue,  6 Oct 2020 21:21:08 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id t25so940672ejd.13
        for <linux-crypto@vger.kernel.org>; Tue, 06 Oct 2020 21:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NBNZtVQQB2KTdNFAhcuch9XxJZhD9YHNjFHMfmNY94s=;
        b=IAtzqnshZSKEtiIEx3/kBic2CZfhf5/w50Z/OJjVK0+RDEdhrzjVzNZZaqGoeOkTZg
         c1K3VeB6RiR6uVngB7hth37dc2V/gtvVklcbHLmT0aGSMqs8zDvZAplv0Vfg/6FFNkts
         qkyacXrYhC658NZhNQrgNwkwuGem15wyoWFv5bEILsdACBl90iga7QekKs8nZ21xx+jr
         +miiB2scgvBloMfrUS1Pg/YQ/bZvlMDDSOCXneEfN/NeAIuYgzf5PAn+4n66WlRP3ReR
         uOYpl/x8+bVMvHXhcYp/LAQWcGB4lHOfg3Be0qhjDsO4SmWE+tTAMt8GiO89iT93w5p2
         gMKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NBNZtVQQB2KTdNFAhcuch9XxJZhD9YHNjFHMfmNY94s=;
        b=l9nFeL4XhVlUCl7Uxe3JokR41XrQSAHYCAcYCGnXdXfmIqQnRWqMRLdnbKlq4r5O5P
         UY6t2DqzYXw9DRKosIZVBbD/7dLIS60jVIkJtiYWVS8ZMGgaSmTK2JhmxQ6bppzQ48Ko
         EcaHpELBQG0dwmPfWXlKjJPHRqyfsE9/JUE0em8dFbSKr/VybEJbqVcQGG/28V3uQL8f
         hJN37r13AyB7OlH6XtWKLZ4qX+HjPlf7cvSWnqL9eWZLwKEqClrZKpS4JX8r43TUi85d
         9KYhKY5p1Z/OlHG3ylsSU7g8hiZYUPlLa8CdgWHoOSLk0Rz8X9A4h/vD4pn2g+cpfZA4
         qcsg==
X-Gm-Message-State: AOAM530muPekzrlJxgO4Tz06O3CzjgFX/Sciqpp+5Q7QInlMi9cPEe/T
        zM6VAFUJoHKoECM/fCRBVNM41i2tJ3N/61rB/Z3H+w==
X-Google-Smtp-Source: ABdhPJxdiczbtzfxGozT7L2wA9lT0y/4c98CZNLdrbdeb8WB+XggqqPmqtnlngt+l7qVyRbNLZSVAX1iCA9NPJp9B3c=
X-Received: by 2002:a17:906:86c3:: with SMTP id j3mr1441155ejy.493.1602044466731;
 Tue, 06 Oct 2020 21:21:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200916041908.66649-1-ebiggers@kernel.org>
In-Reply-To: <20200916041908.66649-1-ebiggers@kernel.org>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 7 Oct 2020 06:20:40 +0200
Message-ID: <CAG48ez3Jv6_SSgxMrzEmx1pY04TnsOXhGVvjt2-14-xe-BjTzA@mail.gmail.com>
Subject: Re: [PATCH] random: fix the RNDRESEEDCRNG ioctl
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-crypto@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 16, 2020 at 6:19 AM Eric Biggers <ebiggers@kernel.org> wrote:
> The RNDRESEEDCRNG ioctl reseeds the primary_crng from itself, which
> doesn't make sense.  Reseed it from the input_pool instead.

Good catch. (And its purpose is to ensure that entropy from
random_write() is plumbed all the way through such that getrandom()
and friends are guaranteed to actually use that entropy on the next
invocation; and random_write() just puts data into the input pool.)

But actually, looking at the surrounding code, I think there's another
small problem?

> Fixes: d848e5f8e1eb ("random: add new ioctl RNDRESEEDCRNG")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Jann Horn <jannh@google.com>

> ---
>  drivers/char/random.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index d20ba1b104ca3..a8b9e66f41435 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -1973,7 +1973,7 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
>                         return -EPERM;
>                 if (crng_init < 2)
>                         return -ENODATA;
> -               crng_reseed(&primary_crng, NULL);
> +               crng_reseed(&primary_crng, &input_pool);

So now this will pull the data from the input_pool into the
primary_crng, so far so good...

>                 crng_global_init_time = jiffies - 1;

... and this will hopefully cause _extract_crng() to pull from the
primary_crng into crng_node_pool[numa_node_id()] afterwards. Unless
things are going too fast and therefore the jiffies haven't changed
since the last crng_reseed() on the crng_node_pool[numa_node_id()]...
a sequence number would probably be more robust than a timestamp.

And a plain write like this without holding any locks is also questionable.

The easiest way would probably be to make it an atomic_long_t, do
atomic_long_inc() instead of setting crng_global_init_time here, and
check atomic_long_read(...) against a copy stored in the crng_state on
_extract_crng()? And in crng_reseed(), grab the global sequence number
at the start, then do smp_rmb(), and then under the lock do the actual
reseeding and bump ->init_time? Or something like that?

>                 return 0;
>         default:
