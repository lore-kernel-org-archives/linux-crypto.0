Return-Path: <SRS0=AFir=YB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C54EC10F14
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 11:38:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E7E820673
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 11:38:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X9KLNDPr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbfJHLi1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Oct 2019 07:38:27 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54187 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729790AbfJHLi1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Oct 2019 07:38:27 -0400
Received: by mail-wm1-f65.google.com with SMTP id i16so2774991wmd.3
        for <linux-crypto@vger.kernel.org>; Tue, 08 Oct 2019 04:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VH+0C0uR5m7C8bWg29oN3PksDQMhMsMgqlBp18FmE1w=;
        b=X9KLNDPrZQbpAmY00fnhH3gUBt6So+TIaZQLwaiQIA/KlAgzLQHUIMJihzinKAJaiv
         pcGxMPQZPBgvYSqCVRkiUxpDHLHD188BvJhOS9f/1cctx0r1APjJvRQGLoYaDv8xEv84
         0Zz3TNl4qxcBCx00104lW2Z1BfLCeW66TPaVr26kfDiefOOMraeHKm1o0u0p9j2OY8/v
         LHfWMpOzon1tOizzwxqsX1g7ffYqKUOXcAlq5PGSaY0R6DMQEE/js2Ha3/fKhOvSJ5qY
         joCWdY7O8VmiSRwbax1qUPkLQigrdViqmyEcpPbecCl3j+4zWCLVQ4H1tN+Yd1DnjKQo
         gZtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VH+0C0uR5m7C8bWg29oN3PksDQMhMsMgqlBp18FmE1w=;
        b=NSvYobunResrGwGYue25KA6FDLM8QjHPWgyPoII83fawCy7MpiPtkAMVFiDF75q1uL
         1tdFZFp/RPahsrp0eka6Q6YbrmLmHESnkM6DVqKKTO1E2EFz6C8keydkj5Bn/DQDrZ+5
         86eUP6eR1XvVWT1rtbFNSPZzTnQt0OPQ+W8JoGmUp8cI1poIn6hQmjWqBuCDGJ88EFIL
         7Hj97jKG30cTr+Hol8xocmHoeweXcq2XdntlV3XFqn77zZiuS/l/xW92Y7LWs//HJFYL
         p4JSFt2edHzPzjuLG1Ao71GyGAUGP3cbwDFvNNnklOgpbaOix91YoIYejrx/l+DxgwPr
         sT+w==
X-Gm-Message-State: APjAAAWYMxG8Zf6qj+kJmXK5LLCZ9Xklfl2ZAP/jZpEQp61OhtQ1JJAd
        ug0/+Mlxg/QmlN98OExbXvR5B2vxpNsxiHoRYVGfrQ==
X-Google-Smtp-Source: APXvYqyWKJ6wzhbsq3wOqvUgPLA7CAZngPJ7cB4FCOkE5Ogat4YhGNuf406gPvwU/sSUXv13SMF+m4g9j2rxkz2NvNA=
X-Received: by 2002:a1c:2546:: with SMTP id l67mr3589422wml.10.1570534704763;
 Tue, 08 Oct 2019 04:38:24 -0700 (PDT)
MIME-Version: 1.0
References: <20191005091110.12556-1-ard.biesheuvel@linaro.org> <b18ff289-ceca-d934-6583-caf8d2916bcb@gert.gr>
In-Reply-To: <b18ff289-ceca-d934-6583-caf8d2916bcb@gert.gr>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 8 Oct 2019 13:38:13 +0200
Message-ID: <CAKv+Gu9yoROn8+vmE=_c-gTm2H1WGTJsPb+yj1YBv6+-P6ei_A@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: geode-aes - switch to skcipher for cbc(aes) fallback
To:     Gert Robben <t2@gert.gr>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Jelle de Jong <jelledejong@powercraft.nl>,
        Eric Biggers <ebiggers@kernel.org>,
        Florian Bezdeka <florian@bezdeka.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 5 Oct 2019 at 18:15, Gert Robben <t2@gert.gr> wrote:
>
> Op 05-10-2019 om 11:11 schreef Ard Biesheuvel:
> > Commit 79c65d179a40e145 ("crypto: cbc - Convert to skcipher") updated
> > the generic CBC template wrapper from a blkcipher to a skcipher algo,
> > to get away from the deprecated blkcipher interface. However, as a side
> > effect, drivers that instantiate CBC transforms using the blkcipher as
> > a fallback no longer work, since skciphers can wrap blkciphers but not
> > the other way around. This broke the geode-aes driver.
> >
> > So let's fix it by moving to the sync skcipher interface when allocating
> > the fallback. At the same time, align with the generic API for ECB and
> > CBC by rejecting inputs that are not a multiple of the AES block size.
> >
> > Fixes: 79c65d179a40e145 ("crypto: cbc - Convert to skcipher")
> > Cc: <stable@vger.kernel.org> # v4.20+ ONLY
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> > v2: pass dst and src scatterlist in the right order
> >      reject inputs that are not a multiple of the block size
>
> Yes, with this patch, the CRYPTO_MANAGER_EXTRA_TESTS output nothing
> (apart from "extra crypto tests enabled").
> All items in /proc/crypto have "selftest: passed" mentioned.
> "openssl speed -evp aes-128-cbc -elapsed -engine afalg" reaches the
> proper speed.
> And nginx (correctly) transfers files about 40% faster than without
> geode-aes.
>
> I didn't think about testing ecb before, because I don't use it.
> Now that I did, I tried the same openssl benchmark for ecb.
> But that only reaches software AES speed, and "time" also shows the work
> is being done in "user" instead of "sys" (see below).
> Yet I see no errors.
> (Maybe this is normal/expected, so I didn't look much further into it).
>
> Thank you,
> Gert
>
> # time openssl speed -evp aes-128-cbc -elapsed -engine afalg
> - - - 8< - - -
> type             16 bytes     64 bytes    256 bytes   1024 bytes   8192
> bytes  16384 bytes
> aes-128-cbc        135.82k      539.29k     2087.90k     7491.16k
> 29221.69k    34943.67k
>
> real    0m18.081s
> user    0m0.516s
> sys     0m17.541s
>
> # time openssl speed -evp aes-128-ecb -elapsed -engine afalg
> - - - 8< - - -
> type             16 bytes     64 bytes    256 bytes   1024 bytes   8192
> bytes  16384 bytes
> aes-128-ecb       4480.65k     5137.66k     5336.94k     5410.19k
> 5409.91k     5409.91k
>
> real    0m18.084s
> user    0m18.046s
> sys     0m0.012s
>

It seems likely that the ECB code in OpenSSL is not invoking the afalg
code at all. Since ECB is just the bare block cipher applied to each
block in the input, I wonder if it even uses a skcipher like interface
internally.
