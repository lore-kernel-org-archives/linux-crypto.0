Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5977DC43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 08:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A53E2083D
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 08:01:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Sqr1MaHR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfFXIBv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 04:01:51 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36529 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbfFXIBv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 04:01:51 -0400
Received: by mail-io1-f68.google.com with SMTP id h6so278174ioh.3
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jun 2019 01:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FTPWwACdEm2iARChdi+A0l0E519w0LgFxkdMjzE6KqA=;
        b=Sqr1MaHRYO02yMQpmq6sGmEOyYe4gqkL//8AtMvJOtTKj39AZpjbOgbVi/XBZlrcT3
         gp1JZO0PeQfv5PSCB1yzkwsbsCcCFg3PvvLqE3wkCsPotrbDsBbd3RsEPLbwVBVW92ea
         DOei8IpXCQ7BRAgxycot1z8B1VMu5YE6OQjrIgcsHHqZuV9HVoZ95uBAlD6YqWgGHabY
         e0E9efXtJzMzmBwkSL3olYKJbN99R/HA65opTIx3nlFkiUSu65Un2cO+dYdGrY+z4+9A
         BhBsIdGGn5ZpKyrNxHmvHTbX+HTyaJwgUqVASZGxmNUwlRps6LYyqMTZc0jW6IPp6WsV
         H61w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FTPWwACdEm2iARChdi+A0l0E519w0LgFxkdMjzE6KqA=;
        b=GwjiCwfc5oCJ3PhfTr9KFW7wclL9RIlY+tLtzi3gyQ54MlE/sDoZVZwH0DfFP6tozl
         lqc4AsVxgMy5pPmtjmou51vQbFtu2hDknmEL58AO/GKYNIfiZNnZ0lXLY8zy+eJmlCIS
         2TgU36oO0KRa+Aa0UIdIuXw0RuNZpDbRuWMULiT8Uh7MkwWpwrshgUW8T2x7PrU01P4k
         p9srx6bzmv4+uOFfshZr1kkxrkR0kOgmFlZ9srz6qxNKhO3DhzNs47xck0r1kGfPcaOa
         jJmwH92WVtmDinjnM3YV+JWwJ7PbpGaJnHVK5+DP1NQK8JceoymFue5aaELc1HaXjZVd
         NMXw==
X-Gm-Message-State: APjAAAX8DqvHstPVTlp/pMMpfiLYno4t6WeBzB5foK0r4g0TXWt/rX0q
        wcfq1Op04ornDlpQxeZj5U+EfJvFswgfcbAYg6de6w==
X-Google-Smtp-Source: APXvYqygfqk82gjJizKwuyDhHTlE1j+Su2e7VGfdGDa2jVMnGL3Ouit0b9Fe24gt7DT23pEtf84DZF3Iqm24HkWYfe0=
X-Received: by 2002:a05:6602:98:: with SMTP id h24mr20097216iob.49.1561363310654;
 Mon, 24 Jun 2019 01:01:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190624073818.29296-1-ard.biesheuvel@linaro.org>
 <20190624073818.29296-2-ard.biesheuvel@linaro.org> <CAFqZXNt4PgTB1Ocmui4CCYTCbguAqmcrdA=ZMbA6anH3LBX9EQ@mail.gmail.com>
In-Reply-To: <CAFqZXNt4PgTB1Ocmui4CCYTCbguAqmcrdA=ZMbA6anH3LBX9EQ@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 24 Jun 2019 10:01:37 +0200
Message-ID: <CAKv+Gu-UQ_QYqwDXM659PfZNKjHnS8vPfL6yV_ZT=Ggt5jDB-A@mail.gmail.com>
Subject: Re: [PATCH 1/6] crypto: aegis128 - use unaliged helper in unaligned
 decrypt path
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 24 Jun 2019 at 09:59, Ondrej Mosnacek <omosnace@redhat.com> wrote:
>
> Hi Ard,
>
> On Mon, Jun 24, 2019 at 9:38 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > Use crypto_aegis128_update_u() not crypto_aegis128_update_a() in the
> > decrypt path that is taken when the source or destination pointers
> > are not aligned.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  crypto/aegis128.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/crypto/aegis128.c b/crypto/aegis128.c
> > index d78f77fc5dd1..125e11246990 100644
> > --- a/crypto/aegis128.c
> > +++ b/crypto/aegis128.c
> > @@ -208,7 +208,7 @@ static void crypto_aegis128_decrypt_chunk(struct aegis_state *state, u8 *dst,
> >                         crypto_aegis_block_xor(&tmp, &state->blocks[1]);
> >                         crypto_xor(tmp.bytes, src, AEGIS_BLOCK_SIZE);
> >
> > -                       crypto_aegis128_update_a(state, &tmp);
> > +                       crypto_aegis128_update_u(state, &tmp);
>
> The "tmp" variable used here is declared directly on the stack as
> 'union aegis_block' and thus should be aligned to alignof(__le64),
> which allows the use of crypto_aegis128_update_a() ->
> crypto_aegis_block_xor(). It is also passed directly to
> crypto_aegis_block_xor() a few lines above. Or am I missing something?
>

Ah yes, you are absolutely right. Apologies for the noise. I just
noticed the asymmetry with the encrypt path, but I should have looked
more carefully.

Please disregard this patch.
