Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB5BC43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 07:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9FDB2089E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 07:46:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H3YtZKM7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfFVHqr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 03:46:47 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44014 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfFVHqr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 03:46:47 -0400
Received: by mail-io1-f66.google.com with SMTP id k20so1020329ios.10
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 00:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gO7xV8V8rMbz4lgHVplKKXB/U2QvprMvnG6pGySatqk=;
        b=H3YtZKM7zFp0i8WuqRiNgB0j8Sn1qzSIOW0qcqN0BOvt0rsEplslV46GIknNHVjkGK
         HnfytRxZjjhZcH0hIdCY8HDMMoXyNeQr/WhzhQKhAi0NQLcDJkEzs/GM5Z7KoSWEN9Hm
         U3L/YwAUhuYzVBf1wD+ODzTE0wv0sgo40ZkcVh9++oy55tBpOFaed9mTwsA8JDNzvcgs
         vlIIZcA2ybG/WQbUHp6Dy30dKWdWzuTPovXGwZGoUxVbkMJA1MZgB5Z1Hp2AucjtwLdO
         sJONtYvg2UxARs0eCxHqsmVF8YAuIjr+cdjAqMCLWsLiie72gQv3EPg9v5GncF3h1bg7
         qg1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gO7xV8V8rMbz4lgHVplKKXB/U2QvprMvnG6pGySatqk=;
        b=gMh6ZCEMorqYlUCE1TVkqpC3tzGv/vwFR5ll64AabJrWxnnwocOAPTPujHYCfWGhdL
         OshQqOoGA3jH/FaaDZVA8+bytuv40dmk2KPQapyEYzZaTci+dujBC5eL7aOP3q9X7sry
         l0uQEmtzTKXPpBWjgNPncPOIjllZArCESWBkLL43rCffRE6RQI2BNg0SQVgOj1GJo6Io
         ODLmi+FIEshvuJPIE2rfn959YceRh1ShEI8pko9OYRmMopby8V2vDk1bBG4wrMst0w/F
         iWZ3//n2e+F713VwZQSxQ4MtpFhMdV/i52YU+BIIRuKMXEeyEr2YttW9tRkhRxJzwSry
         08rQ==
X-Gm-Message-State: APjAAAUt2+KEjP21xOkkZ0PS7PFtBBRV7cpku6yFmgpG3tOZ/2MEJtNO
        AxsUcMS5V2k2oMgLIJZeUlvamoBecPbH0ybjYoYXOg==
X-Google-Smtp-Source: APXvYqyJ5nuXrjj1zzssij63VHNVEXLvpGvrNpCLEHANe4DNdYxOsPDprp5pZcIP2UOcT5WmlEhwi99p2NOHagmCfbw=
X-Received: by 2002:a5d:9d83:: with SMTP id 3mr11486248ion.65.1561189606435;
 Sat, 22 Jun 2019 00:46:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
 <20190622003112.31033-2-ard.biesheuvel@linaro.org> <20190622050622.zztsonohpmjvrovn@gondor.apana.org.au>
In-Reply-To: <20190622050622.zztsonohpmjvrovn@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 22 Jun 2019 09:46:32 +0200
Message-ID: <CAKv+Gu8s9HKpWAo=4509zuZxe9rfWo2x69XFyEYOqicN3zYhrw@mail.gmail.com>
Subject: Re: [RFC PATCH 01/30] crypto: des/3des_ede - add new helpers to
 verify key length
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 22 Jun 2019 at 07:06, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Sat, Jun 22, 2019 at 02:30:43AM +0200, Ard Biesheuvel wrote:
> > The recently added helper routines to perform key strength validation
> > of 3ede_keys is slightly inadequate, since it doesn't check the key
> > length, and it comes in two versions, neither of which are highly
>
> The skcipher helper doesn't need to check the key length because
> it's the responsibility of the crypto API to check the key length
> through min_keysize/max_keysize.
>
> But yes if you're going to do a helper for lib/des then you'd need
> to check the key length but please keep it separate from the skcipher
> helper.
>

Ah yes, I had missed the fact that skcipher checks the lengths
already. But actually, that applies equally to ablkcipher and cipher,
so only aead instantiations need to perform the length check
explicitly.

I will drop the key_len arg from these helper routines, but I'd still
like to convert the skcipher helper into a generic helper that takes a
struct crypto_tfm*.

I'll also add some better documentation of the API in the next rev.
