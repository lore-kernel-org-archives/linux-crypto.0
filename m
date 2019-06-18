Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D2EC31E51
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D6FC206B7
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:41:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SmPpnKId"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbfFRJls (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 05:41:48 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39352 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729329AbfFRJlr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 05:41:47 -0400
Received: by mail-io1-f65.google.com with SMTP id r185so22277159iod.6
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2019 02:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O3Ncl71p7lzVXgKkRwrjXIIwyt50nJ3KDmUjaxlB9AQ=;
        b=SmPpnKIdO03ICXlO41/ekNNXbkBI9XyYTzoC11R7zFcCD+Ea6KQLUumFSFBgR6sbuy
         krAXHMBTQW0v7FDxVJc1KymISd0P1VmHg3PV9bf5O98CLWTv8z07mRKO3GIu5thc+Bs9
         K+33VsZ4y3K0ZogKS/npywpmRrXNH/Qkl5aTyRfEF4+q+ji7kqYyId5cobIJs2kgDJbG
         Qhn6VifCGkyydzVHQcpBT6YRUOPTocqSr//e1HXPix/AJXiV8KRj+nZ2DH17Vpq9axmt
         4plhWLz06OO9IdLDB1skNfyhBUIbozb4nk0Ub0dj4xeIL0vaI46xmlcx3kfGju6ND81k
         hZXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O3Ncl71p7lzVXgKkRwrjXIIwyt50nJ3KDmUjaxlB9AQ=;
        b=bL8NkAXt2U67vE92pGj83E4SwpRF0SH7Z0OTMy1HKts0ZWEVg/PTrdd27PQ2NB93R5
         QobYLsx0pyOlTj/fQD2TnbVG8xsMM0FwslD1tmhQ4Fkp3eJo/tgmk2C4KKlET7o8P0aJ
         JSKYs21OdsUzTUtp2SswioG5JfOyQitdnaHqbiSC3JHvP1+HkEqJF1sn/AvsalwQYSpO
         +H2ElINpArnIomEUd0xb/WNLZwI6ILRcC45nL2D7fKMr3XFGAExV1GCNv+S4qDS+CAO3
         kC+u2mglMG9VmegB4fg5dxQScOLK0WwGNV6nnSEVb+CPpQAVD4ZZ2wVaheq4IaIt+VSe
         0Mug==
X-Gm-Message-State: APjAAAXqsIN+FNjRLOtxH37TOR/+38rl+WJPCeotaX5L9wfHDydg0kfG
        FaXzMzY2kuJcRYpwEMTRD9PeFM97+q+MOjoX++EZ8g==
X-Google-Smtp-Source: APXvYqwbYKrZUMbHjaBrEKJYmJa8zKIBi2tbQPgyUTmGJ7/LfXBsAe97G6TCuKKtIqX54PhrI2hQl8kqe/K0EdRf+hU=
X-Received: by 2002:a5d:8794:: with SMTP id f20mr16488425ion.128.1560850906822;
 Tue, 18 Jun 2019 02:41:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190618093207.13436-1-ard.biesheuvel@linaro.org>
 <20190618093207.13436-2-ard.biesheuvel@linaro.org> <CANn89iJuTq36KMf1madQH08g6K0a-Uj-PDH80ao9zuEw+WNcZg@mail.gmail.com>
In-Reply-To: <CANn89iJuTq36KMf1madQH08g6K0a-Uj-PDH80ao9zuEw+WNcZg@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 18 Jun 2019 11:41:35 +0200
Message-ID: <CAKv+Gu894bEEzpKNDTaNiiNJTFoUTYQuFjBBm-ezdkrzW5fyNQ@mail.gmail.com>
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

On Tue, 18 Jun 2019 at 11:39, Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Jun 18, 2019 at 2:32 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > Some changes to the TCP fastopen code to make it more robust
> > against future changes in the choice of key/cookie size, etc.
> >
> > - Instead of keeping the SipHash key in an untyped u8[] buffer
> >   and casting it to the right type upon use, use the correct
> >   siphash_key_t type directly. This ensures that the key will
> >   appear at the correct alignment if we ever change the way
> >   these data structures are allocated. (Currently, they are
> >   only allocated via kmalloc so they always appear at the
> >   correct alignment)
> >
> > - Use DIV_ROUND_UP when sizing the u64[] array to hold the
> >   cookie, so it is always of sufficient size, even when
> >   TCP_FASTOPEN_COOKIE_MAX is no longer a multiple of 8.
> >
> > - Add a key length check to tcp_fastopen_reset_cipher(). No
> >   callers exist currently that fail this check (they all pass
> >   compile constant values that equal TCP_FASTOPEN_KEY_LENGTH),
> >   but future changes might create problems, e.g., by leaving part
> >   of the key uninitialized, or overflowing the key buffers.
> >
> > Note that none of these are functional changes wrt the current
> > state of the code.
> >
> ...
>
> > -       memcpy(ctx->key[0], primary_key, len);
> > +       if (unlikely(len != TCP_FASTOPEN_KEY_LENGTH)) {
> > +               pr_err("TCP: TFO key length %u invalid\n", len);
> > +               err = -EINVAL;
> > +               goto out;
> > +       }
>
>
> Why a pr_err() is there ?
>
> Can unpriv users flood the syslog ?

They can if they could do so before: there was a call to
crypto_cipher_setkey() in the original pre-SipHash code which would
also result in a pr_err() on an invalid key length. That call got
removed along with the AES cipher handling, and this basically
reinstates it, as suggested by EricB.
