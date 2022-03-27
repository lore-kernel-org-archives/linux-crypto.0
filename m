Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 604FDC433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Mar 2022 06:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbiC0GGf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Mar 2022 02:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbiC0GGc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Mar 2022 02:06:32 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00A511C
        for <linux-crypto@vger.kernel.org>; Sat, 26 Mar 2022 23:04:52 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2e64a6b20eeso119259997b3.3
        for <linux-crypto@vger.kernel.org>; Sat, 26 Mar 2022 23:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Lk5sv6XbG/xPjFwnZhQqz13aCWm8cu1WoOK6d2cYq7E=;
        b=X5fRBYvyPwKLPcJQ8ruGiKgGQo1CM5RHqplc0efeENgtY6uy+H5Ig/0bjcIdM6O5qM
         TSpIovL/Db3yi316GHqbTUGqSmuWyLsMSE++9bkjsJZZYJne3bkEqKTH38z73axd2/6e
         WnkOdcWJeExYuZI/QRDRqXGr6K2KXgwe3usJhPL1JtXO5bmzitENjq3wW6FKV36AsR6E
         erg5GmD34OKcnRiw1PONtBaxyIM8CDyUV3DopEEyKK6fDX0Zn+oTBV84TC8iVJkoX9HW
         BvgLyqWSbRjIAwDVTOa23fBFHI51tiBj0V9r1Q7P2VFi9EoYN/plNB9wjzzpZ3JWS1OT
         uwTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Lk5sv6XbG/xPjFwnZhQqz13aCWm8cu1WoOK6d2cYq7E=;
        b=UN95Tf6B0xITEGkxi889PH/aNrKregqM5TU8i7sjA8iktdCW73zkVhXotybRgkaR1w
         xZQU84BbS0UX9Ieov0rBUfunwvZO4EjmBgu91s7Dzhdk8/mNcVBy1Bp4AefGHfaUEdN9
         MUZBb53jcmplcyH/Oned2RaLguO0OpMSuFR1aRhvIBm/+ruAHG/5hUGjdhAbpoFulolA
         DM+vQFCIN+KkYz37htk73IDF5NiNer2g8/reCv0Wr5EWmKs1pfYNXPTVkIMOuNAOu1yk
         2plI4U0/zWvlDZQAX2XpcgyApn9vH54mQsdqxeDhFADEIyGRGSNOmJk6fsKfwxQqJBbA
         QGJg==
X-Gm-Message-State: AOAM533P91NL78KnDfeeeSAfS3Ayr/EAAcVUkWwytb0UupmfUevOu1dL
        jMfKJaEPF9uvuga7aZZRLqpBeFh8bHz9hiTicU5xcYjwKCJ2CQ==
X-Google-Smtp-Source: ABdhPJzC0YQpG5/JPRDakSVIuCD3WuMCLbrW3uxVA8Rw1l6zzVvKLem9CPJfKHv46XKIQrgGRxtVwSmj45qg7MQVmKA=
X-Received: by 2002:a81:ad67:0:b0:2e5:8466:322a with SMTP id
 l39-20020a81ad67000000b002e58466322amr19094248ywk.54.1648361091841; Sat, 26
 Mar 2022 23:04:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220326071159.56056-1-ebiggers@kernel.org>
In-Reply-To: <20220326071159.56056-1-ebiggers@kernel.org>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sun, 27 Mar 2022 09:04:43 +0300
Message-ID: <CAOtvUMfpqxrdgmnzpkCW=EdUmquXYC6F=rwW+n8koJAt0Wg38g@mail.gmail.com>
Subject: Re: [PATCH] crypto: testmgr - test in-place en/decryption with two sglists
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Mar 26, 2022 at 10:13 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> As was established in the thread
> https://lore.kernel.org/linux-crypto/20220223080400.139367-1-gilad@benyos=
sef.com/T/#u,
> many crypto API users doing in-place en/decryption don't use the same
> scatterlist pointers for the source and destination, but rather use
> separate scatterlists that point to the same memory.  This case isn't
> tested by the self-tests, resulting in bugs.
>
> This is the natural usage of the crypto API in some cases, so requiring
> API users to avoid this usage is not reasonable.
>
> Therefore, update the self-tests to start testing this case.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>


Thank you Eric.

I have given this a lot of thought and here is what I predict will
happen thanks to this added test:
- We will not find a driver that this breaks, in the sense of
producing wrong results and triggering failure in this test.
- We probably will see drivers that when running this test when DMA
debug is compiled and enabled trigger the debug warning about double
DMA mapping of the same cache line.

The reason is that these double mapping stemming from this test will
be from mapping the same buffer as source and destination.
As such, the situation that is the cause for the DMA debug warning, of
a mapping causing  cache flush invalidate, followed by DMA, followed
by another mapping causing cache flush/invalidate while the DMA is in
flight, will not happen. Instead we will have mapping ->
flush/invalidate -> another mapping -> flush/invalidate -> DMA ...

Note, this is certainly not a claim we should not add this test! on
the contrary ...

In fact, I would be tempted to claim that this means the real problem
is with an over zealous DMA debug logic. Unfortunately, I can think of
other scenarios where things are not so simple:

For example, what happens if a crypto API user has a buffer, which it
divides into two parts, and then submit a crypto op on one part and
another crypto op on the 2nd part (say encrypt and hash, just as an
example). For the best of my knowledge, there is nothing forcing the
split between the two parts to fall on a cache line. This can cause a
double mapping of the same cache line - and this time the warning is
real, because we are not guaranteed a single DMA operation following
the two mappings. There is nothing much a crypto driver can do even -
the two operations don't have to be done by the same driver at all...

I believe the scenario you are proposing to test is a benign example
of a larger issue. I also believe this is an example of Worse in
Better* and that the right solution is to dictate certain rules on the
callers of the crypto API. Whether these rules should or should not
include a limitation of not passing the same buffer via two different
scatter gather list to the same crypto op is debatable, but I think we
cannot run away from defining some rules.

I would really love for others to voice an opinion on this. It seems a
rather narrow discussion so far between the two of us on what I feel
is  a broader issue.

Thanks!
Gilad

* https://dreamsongs.com/RiseOfWorseIsBetter.html


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
