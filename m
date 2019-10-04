Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B10FC4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 06:16:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CAF52133F
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 06:16:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mcvGOxoU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388279AbfJDGQi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 02:16:38 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46796 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388278AbfJDGQh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 02:16:37 -0400
Received: by mail-wr1-f65.google.com with SMTP id o18so5489264wrv.13
        for <linux-crypto@vger.kernel.org>; Thu, 03 Oct 2019 23:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HTfuVudNBTsJMvkvlGNHwxIyZ/TnJDdl0LFyTOEYAPo=;
        b=mcvGOxoU7Mjd1La9sMKWyEKIr9keK5BEN42vdacTByX+BH6oyflR5nIy1ttqUFZ423
         HzYHLz3y72NtVBk4BfjSwxESITwtCsELNNcY6XfQXiIaqRQZQc2jHInRO8OdHP5MEvPB
         SVFqPtwVeuh9z5hJIfYAiSg4B7DjjgbeFLIIe/yjSuPMVShmHowNmi0WaIMpnIRVaumJ
         p83L0PisXEPQmTD8MNWVG8oFTEG19QFwjpPrsq7/WMXfuZ4UGWQDgjfQo/iacQx094JB
         CKQ97XvreLsf3ahrVHVw8LUQKa+96VsjQ0vRlEKAqGVcKA32KIq5ofmfihorFT5z9+Ya
         fTtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HTfuVudNBTsJMvkvlGNHwxIyZ/TnJDdl0LFyTOEYAPo=;
        b=NCFvgrHk0ZjSFYiMyIHQwCtwhavN8C5f430+xhefIw7O8SHhqhDezZp5p0U/dWVfoX
         lr4K3UgV5mlCj9BFzgE+jVKBXVq+1T0Uo9YMWnDywGaiyt9LXytaOIfHs/0EwyuTx96A
         cEXp1mpdWK4s22VRkzQkXt7Ic/c1nM17Fzhu/ewYblIRW9leC/Dz/mxefCkVGs6XAN4v
         6+e37uN/CppvIh/PddosBdpZ0csmr+m3wfEhrKHA+anpD4zXgIblhy9Dfd+ib0LytpPG
         Z8HNuY/Qx1a9pfLgFrYddpq8GitExFRM3E8/TgGyMpe0U74QTme3Am/vVVjUbO3ZvybW
         /nag==
X-Gm-Message-State: APjAAAV7xLI4ySDxszjHxoaXvYfHnLasClmmIWXTG+gGyuFQa8cc1k/T
        EX6yFIQdTncqCp3fqjGuUxGllbBf4Y+N35LUyIvbVw==
X-Google-Smtp-Source: APXvYqwUoLaAlwwvVICx0xpo+OvypXPdPQ990jexzAWVMamUpk4ustJ6onjetoS6m0YDEXJv3LOF9AJ3vB48JWDhVqQ=
X-Received: by 2002:a5d:61c8:: with SMTP id q8mr4467650wrv.325.1570169794654;
 Thu, 03 Oct 2019 23:16:34 -0700 (PDT)
MIME-Version: 1.0
References: <20191003133921.29344-1-ard.biesheuvel@linaro.org> <64d5c8ec-41c5-1ef2-cc4b-a050bf4c48ba@gert.gr>
In-Reply-To: <64d5c8ec-41c5-1ef2-cc4b-a050bf4c48ba@gert.gr>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 4 Oct 2019 08:16:22 +0200
Message-ID: <CAKv+Gu8htzzdi5=4z5-E5o+J+bAPO=N4dR75Se=3JOZw8P_tDA@mail.gmail.com>
Subject: Re: [PATCH] crypto: geode-aes - switch to skcipher for cbc(aes) fallback
To:     Gert Robben <t2@gert.gr>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jelle de Jong <jelledejong@powercraft.nl>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 3 Oct 2019 at 23:26, Gert Robben <t2@gert.gr> wrote:
>
> Op 03-10-2019 om 15:39 schreef Ard Biesheuvel:
> > Commit 79c65d179a40e145 ("crypto: cbc - Convert to skcipher") updated
> > the generic CBC template wrapper from a blkcipher to a skcipher algo,
> > to get away from the deprecated blkcipher interface. However, as a side
> > effect, drivers that instantiate CBC transforms using the blkcipher as
> > a fallback no longer work, since skciphers can wrap blkciphers but not
> > the other way around. This broke the geode-aes driver.
> >
> > So let's fix it by moving to the sync skcipher interface when allocating
> > the fallback.
> >
> > Cc: Gert Robben <t2@gert.gr>
> > Cc: Jelle de Jong <jelledejong@powercraft.nl>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> > Gert, Jelle,
> >
> > If you can, please try this patch and report back to the list if it solves
> > the Geode issue for you.
>
> Thanks for the patch!
> I tried it on Alix 2C2 / Geode LX800 with Linux 5.4-rc1 (also 5.1-5.3 fwiw).
>
> At least now openssl doesn't give those errors anymore.
> (openssl speed -evp aes-128-cbc -elapsed -engine afalg)
> But looking at the results (<6MB/s), apparently it's not using geode-aes
> (>30MB/s?).
> In dmesg can be seen:
>
> alg: skcipher: ecb-aes-geode encryption test failed (wrong result) on
> test vector 1, cfg="out-of-place"
> alg: skcipher: cbc-aes-geode encryption test failed (wrong result) on
> test vector 2, cfg="out-of-place"
> Geode LX AES 0000:00:01.2: GEODE AES engine enabled.
>
> In /proc/crypto, drivers cbc-aes-geode/ecb-aes-geode are listed with
> "selftest: unknown". Driver "geode-aes" has "selftest: passed".
>
> I'm happy to test other patches.

Oops, mistake there on my part

Can you replace the two instances of

skcipher_request_set_crypt(req, dst, src, nbytes, desc->info);

with

skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);

please?
