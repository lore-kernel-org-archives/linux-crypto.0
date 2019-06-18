Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 816E7C31E5D
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 10:03:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 583752084B
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 10:03:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ia2sw0NT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbfFRKDN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 06:03:13 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46969 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfFRKDL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 06:03:11 -0400
Received: by mail-io1-f65.google.com with SMTP id i10so28267763iol.13
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2019 03:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nJWZTkerYqxZ8gox46rKtBpw5zXrYUkGFpFgduRzBEM=;
        b=Ia2sw0NT56vt9MAhKYJr79OAixoaXcvg6diSg0meFCUnwWd/eCu8gUH7+O4ae+rgf1
         cdq41wz+PlzpG2b9JAvj481SrxZqhHTebNXphQ96w0Ela7iHjuELF5OWTaWxa7MKS+a9
         RsNdIeLuOsSBghpWBf6nxFrsR5gMUMxB/IRtUWLbVOwAR+4nkvTFYPaWkS+N9BfjkHSi
         wrZY0MV4ZO9JGi/TWadOXa5eI6LcGpIMtp9pNs7VKCUj93tMppy/N9ImARlkHkr5jqzp
         TQIQ/86hcvWog/4DiaZjEPWCxOyY8K+vD5kQrhEkHoCbQB5APcbYf5zN1Rx14sHx0Qtv
         K1fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nJWZTkerYqxZ8gox46rKtBpw5zXrYUkGFpFgduRzBEM=;
        b=jHVpMzyGj6WkK+Xcne+w+7QzWjTHbc24N0cdG7bsEaEM/JE2k3HFnn4jK6e6bnEYq5
         EjCidF7VRHbKJZXzSGFMXNDrsMrJ4yEXmitRSwYYt4s/ouB/DabqsItTyqMPSL+oX5SW
         zsvd5rk6xJEaYOXeEAKcW6SXje6lZt9eIo/ouVHnYqMsJd/CWl48BaYSj/OE7RRWGwac
         fiqadlZtBB9iMvUS14bF1tKQvxuuLw0VhuF5YWR4dkrA+HeAVWJ3GQ3PsCzhjklUhSMH
         V1lWtfpUn7SLOK93Zl6vRA7PfUv9FpueVqvu0Dn0AF4Z7o3lioVOe2DoCufdPlTWIULI
         ZBkw==
X-Gm-Message-State: APjAAAWhQIxaSW2t+KYLuuMJopamG1SvyMsWSCA/D4Lyvg0GJ2sBw7qx
        iemXPS5wLOYpX/6rZe0HODzMuEC7Vj+JTPiQtYUTZA==
X-Google-Smtp-Source: APXvYqyC/Ng32ZvFlhOwyn4z6NWnGD8Z+TDbznbemfj3+nPbVGf9H4m+90QigvpO9vzeq2jl13PBsRtecex4kvAUspw=
X-Received: by 2002:a02:ce37:: with SMTP id v23mr2244603jar.2.1560852191037;
 Tue, 18 Jun 2019 03:03:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190618093207.13436-1-ard.biesheuvel@linaro.org>
 <20190618093207.13436-2-ard.biesheuvel@linaro.org> <CANn89iJuTq36KMf1madQH08g6K0a-Uj-PDH80ao9zuEw+WNcZg@mail.gmail.com>
 <CAKv+Gu894bEEzpKNDTaNiiNJTFoUTYQuFjBBm-ezdkrzW5fyNQ@mail.gmail.com> <CANn89i+X7YQ6DueDQAusA+1S5Kmo75OwzO+eYRZe_nR8=YWjuQ@mail.gmail.com>
In-Reply-To: <CANn89i+X7YQ6DueDQAusA+1S5Kmo75OwzO+eYRZe_nR8=YWjuQ@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 18 Jun 2019 12:02:59 +0200
Message-ID: <CAKv+Gu9sjaCix_MkKHd=2tfGgaxehTrEw_mzAoOOFbkT4xxCVQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: fastopen: make key handling more robust against
 future changes
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
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

On Tue, 18 Jun 2019 at 11:53, Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Jun 18, 2019 at 2:41 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > On Tue, 18 Jun 2019 at 11:39, Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Tue, Jun 18, 2019 at 2:32 AM Ard Biesheuvel
> > > <ard.biesheuvel@linaro.org> wrote:
> > > >
> > > > Some changes to the TCP fastopen code to make it more robust
> > > > against future changes in the choice of key/cookie size, etc.
> > > >
> > > > - Instead of keeping the SipHash key in an untyped u8[] buffer
> > > >   and casting it to the right type upon use, use the correct
> > > >   siphash_key_t type directly. This ensures that the key will
> > > >   appear at the correct alignment if we ever change the way
> > > >   these data structures are allocated. (Currently, they are
> > > >   only allocated via kmalloc so they always appear at the
> > > >   correct alignment)
> > > >
> > > > - Use DIV_ROUND_UP when sizing the u64[] array to hold the
> > > >   cookie, so it is always of sufficient size, even when
> > > >   TCP_FASTOPEN_COOKIE_MAX is no longer a multiple of 8.
> > > >
> > > > - Add a key length check to tcp_fastopen_reset_cipher(). No
> > > >   callers exist currently that fail this check (they all pass
> > > >   compile constant values that equal TCP_FASTOPEN_KEY_LENGTH),
> > > >   but future changes might create problems, e.g., by leaving part
> > > >   of the key uninitialized, or overflowing the key buffers.
> > > >
> > > > Note that none of these are functional changes wrt the current
> > > > state of the code.
> > > >
> > > ...
> > >
> > > > -       memcpy(ctx->key[0], primary_key, len);
> > > > +       if (unlikely(len != TCP_FASTOPEN_KEY_LENGTH)) {
> > > > +               pr_err("TCP: TFO key length %u invalid\n", len);
> > > > +               err = -EINVAL;
> > > > +               goto out;
> > > > +       }
> > >
> > >
> > > Why a pr_err() is there ?
> > >
> > > Can unpriv users flood the syslog ?
> >
> > They can if they could do so before: there was a call to
> > crypto_cipher_setkey() in the original pre-SipHash code which would
> > also result in a pr_err() on an invalid key length. That call got
> > removed along with the AES cipher handling, and this basically
> > reinstates it, as suggested by EricB.
>
> This tcp_fastopen_reset_cipher() function is internal to TCP stack, all callers
> always pass the correct length.
>
> We could add checks all over the place, and end up having a TCP stack
> full of defensive
> checks and 10,000 additional lines of code :/
>
> I would prefer not reinstating this.

Fair enough.
