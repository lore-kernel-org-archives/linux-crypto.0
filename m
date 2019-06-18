Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E1DC31E51
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A55D206B7
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:39:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GiJrqR8t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbfFRJjQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 05:39:16 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:38096 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729113AbfFRJjQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 05:39:16 -0400
Received: by mail-yw1-f68.google.com with SMTP id k125so6440216ywe.5
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2019 02:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=leaXUi5ri0cQyDOTph/umJ47L10A5R130By8h9bkWuM=;
        b=GiJrqR8tEg+IgMf+ERQsK3vkLG/3KxpD6hP1IKk+/jSWrrTb0LJmXU7Z1Iv8SthYTG
         /+L+fPxg3AE5IR5cgOTyRvHzcfSwNUWHkAEiWIW+DBZYBd1GJJJ/aaibb4vnhIPVogvK
         JJtEKDlQ3glh8mrfetO+lYKUunHPcj0yAVVuEss9Pt9QC583HKroYWioqBc24zTgJI3h
         knS35KmWHe4nAy8P0vJDzyY3RvLNnXI8Il1eTIP3CyCx7YXcYXbQCHQR6Gr1uauCYlER
         tLhy/Uy38JoJcfweB/H8HfFwZ3rOZM2SPwAO7H/qisjo5ITX0+vm2KS3fMABNEDqaatW
         BJ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=leaXUi5ri0cQyDOTph/umJ47L10A5R130By8h9bkWuM=;
        b=qneQir4CLDHq2uDosPkkrAU5MWX69scj+Ik8Uu3w29tGNRG9WRSZMqnNeKww2NW6Xi
         70jVgik53KUoYwBVa62fDrS1tq8xhUijGL0SUkCvuhHpuqT9SYttlWyTUToWRF1aTFW4
         SW0z/F0J+iMZlA+FGQBUrb5pEciaCAYxph9hxHT8jR3LE/qdlW9xDv+rVykF/EKCcrw0
         Hd35bylwz/0Xiiw6qPH/hcubpxIbM3BH3EQVZHBEAdvOCbh+73PxWHIgnv86S5zC0HQ7
         pkstBSHiEzVFA18d0tTMLDW0025gi8BR8jEhY/7l8tSdXqJeG43tOdGIMp2RDogN6jmD
         Nl2g==
X-Gm-Message-State: APjAAAV6q4qySFBULRj7IeYnO6YgOGfbpFfIEYkmBjC7GJ4tEXGAScX+
        YJyXymk4JNJMFrJz4lzgKrij/FJ4bTlT3TDxlBs+JikHyCg=
X-Google-Smtp-Source: APXvYqwOtdo/l+34qiJmGaKb1hdEfZkMNPw4IXxkUawdQEKNBHK8eVk2i8TKl92yzxFn+/Y6Yu5ontIWKIX3MTdjYMo=
X-Received: by 2002:a0d:dfc4:: with SMTP id i187mr20962306ywe.146.1560850755293;
 Tue, 18 Jun 2019 02:39:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190618093207.13436-1-ard.biesheuvel@linaro.org> <20190618093207.13436-2-ard.biesheuvel@linaro.org>
In-Reply-To: <20190618093207.13436-2-ard.biesheuvel@linaro.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 18 Jun 2019 02:39:04 -0700
Message-ID: <CANn89iJuTq36KMf1madQH08g6K0a-Uj-PDH80ao9zuEw+WNcZg@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: fastopen: make key handling more robust against
 future changes
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Christoph Paasch <cpaasch@apple.com>,
        David Laight <David.Laight@aculab.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 18, 2019 at 2:32 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> Some changes to the TCP fastopen code to make it more robust
> against future changes in the choice of key/cookie size, etc.
>
> - Instead of keeping the SipHash key in an untyped u8[] buffer
>   and casting it to the right type upon use, use the correct
>   siphash_key_t type directly. This ensures that the key will
>   appear at the correct alignment if we ever change the way
>   these data structures are allocated. (Currently, they are
>   only allocated via kmalloc so they always appear at the
>   correct alignment)
>
> - Use DIV_ROUND_UP when sizing the u64[] array to hold the
>   cookie, so it is always of sufficient size, even when
>   TCP_FASTOPEN_COOKIE_MAX is no longer a multiple of 8.
>
> - Add a key length check to tcp_fastopen_reset_cipher(). No
>   callers exist currently that fail this check (they all pass
>   compile constant values that equal TCP_FASTOPEN_KEY_LENGTH),
>   but future changes might create problems, e.g., by leaving part
>   of the key uninitialized, or overflowing the key buffers.
>
> Note that none of these are functional changes wrt the current
> state of the code.
>
...

> -       memcpy(ctx->key[0], primary_key, len);
> +       if (unlikely(len != TCP_FASTOPEN_KEY_LENGTH)) {
> +               pr_err("TCP: TFO key length %u invalid\n", len);
> +               err = -EINVAL;
> +               goto out;
> +       }


Why a pr_err() is there ?

Can unpriv users flood the syslog ?
