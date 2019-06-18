Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D38C31E5E
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4345F2084B
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:53:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D6TZhzqj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbfFRJxS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 05:53:18 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:39562 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfFRJxR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 05:53:17 -0400
Received: by mail-yb1-f193.google.com with SMTP id i6so198161ybq.6
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2019 02:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pIimnQedLsNTe4jHjnfMzbpVWdg0o136mrKDsbQep04=;
        b=D6TZhzqjgMR+27nw5jzYCej+WWezx2zJFrcGt3II6Q5/JW6s3XlJ6bC3UAhj/5c43T
         TUSidgpJ8JQsmWAacbp2CmzBZ2TxYvUP1+TFUaltSIFblVXwtsUkj5UPwn8/lm/zGEsZ
         zV2cR/qJIFlTuxbfaLgzKBhRuU4oA5i/fLBwRoIoFcC0/e9pyS0aPOHZWUEEZjioZVU6
         YxotDzzzCIAH6ChUTomeCsYz1cDZlpxPo6hRNKWMdugFvFt7EjTiGAME4w/kDIr5cnEN
         VBw6QV3XtLYUELmVKmCg0gDhg5pOUGkxuj+wNDL1JiAqq6dmqUY3ERcf40O51lcucjxw
         wbbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pIimnQedLsNTe4jHjnfMzbpVWdg0o136mrKDsbQep04=;
        b=Kxke/uzW9WIViicC1rsnK9NtyABHC2+Cr1PR4A/9Fm3WNebcqRlDKXYPgatoccHuvd
         sz3sO517UNi+Fyr5rZY4h/OxV/MjyfH6X5hfwIvKqxUTqWAsd+hT4sf6mNTSdukgTsVq
         NX2CjhhX3/0JXWGK0VqQEa+gVjEUk7Zc/lzvXhkFiUEYzDu5xsoExS4kFM31A8bug9r0
         +Gm5xiVFlRo7w5Aei/ukxps4SjVZwlT+x8dFEbwO10TREo5szGrclDcutcmh05IMQEQA
         291x8mJqVhqG1DLUwWKXLqVhJ0a7l9i4LK2dXU3hFqBkAh6rQ1C5B3rKpelaoJKQ9+CE
         iegA==
X-Gm-Message-State: APjAAAVpnu4t+8rGEYVWzk5s/0l3ByQLd4kOTgKshj8soX2aLpfsrxoH
        hx1l/hnd3Bd8PgYZoiHOyvc8/P42CJdM5qX79ThHqA==
X-Google-Smtp-Source: APXvYqx2vu3tjsOfo57Oqo2isWun0e+CA3Nl5HTAQk1gDpdrweIqgCa0QN7BNT1ilUmjxz+cr9HYHeB/xIczYYatFGo=
X-Received: by 2002:a25:55d7:: with SMTP id j206mr62189670ybb.234.1560851596825;
 Tue, 18 Jun 2019 02:53:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190618093207.13436-1-ard.biesheuvel@linaro.org>
 <20190618093207.13436-2-ard.biesheuvel@linaro.org> <CANn89iJuTq36KMf1madQH08g6K0a-Uj-PDH80ao9zuEw+WNcZg@mail.gmail.com>
 <CAKv+Gu894bEEzpKNDTaNiiNJTFoUTYQuFjBBm-ezdkrzW5fyNQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu894bEEzpKNDTaNiiNJTFoUTYQuFjBBm-ezdkrzW5fyNQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 18 Jun 2019 02:53:05 -0700
Message-ID: <CANn89i+X7YQ6DueDQAusA+1S5Kmo75OwzO+eYRZe_nR8=YWjuQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: fastopen: make key handling more robust against
 future changes
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
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

On Tue, Jun 18, 2019 at 2:41 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> On Tue, 18 Jun 2019 at 11:39, Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Tue, Jun 18, 2019 at 2:32 AM Ard Biesheuvel
> > <ard.biesheuvel@linaro.org> wrote:
> > >
> > > Some changes to the TCP fastopen code to make it more robust
> > > against future changes in the choice of key/cookie size, etc.
> > >
> > > - Instead of keeping the SipHash key in an untyped u8[] buffer
> > >   and casting it to the right type upon use, use the correct
> > >   siphash_key_t type directly. This ensures that the key will
> > >   appear at the correct alignment if we ever change the way
> > >   these data structures are allocated. (Currently, they are
> > >   only allocated via kmalloc so they always appear at the
> > >   correct alignment)
> > >
> > > - Use DIV_ROUND_UP when sizing the u64[] array to hold the
> > >   cookie, so it is always of sufficient size, even when
> > >   TCP_FASTOPEN_COOKIE_MAX is no longer a multiple of 8.
> > >
> > > - Add a key length check to tcp_fastopen_reset_cipher(). No
> > >   callers exist currently that fail this check (they all pass
> > >   compile constant values that equal TCP_FASTOPEN_KEY_LENGTH),
> > >   but future changes might create problems, e.g., by leaving part
> > >   of the key uninitialized, or overflowing the key buffers.
> > >
> > > Note that none of these are functional changes wrt the current
> > > state of the code.
> > >
> > ...
> >
> > > -       memcpy(ctx->key[0], primary_key, len);
> > > +       if (unlikely(len != TCP_FASTOPEN_KEY_LENGTH)) {
> > > +               pr_err("TCP: TFO key length %u invalid\n", len);
> > > +               err = -EINVAL;
> > > +               goto out;
> > > +       }
> >
> >
> > Why a pr_err() is there ?
> >
> > Can unpriv users flood the syslog ?
>
> They can if they could do so before: there was a call to
> crypto_cipher_setkey() in the original pre-SipHash code which would
> also result in a pr_err() on an invalid key length. That call got
> removed along with the AES cipher handling, and this basically
> reinstates it, as suggested by EricB.

This tcp_fastopen_reset_cipher() function is internal to TCP stack, all callers
always pass the correct length.

We could add checks all over the place, and end up having a TCP stack
full of defensive
checks and 10,000 additional lines of code :/

I would prefer not reinstating this.
