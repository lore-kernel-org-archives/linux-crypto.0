Return-Path: <SRS0=1/ZA=UZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E5A0C48BD3
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 21:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 606D12085A
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 21:11:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KJtmiDbD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfFZVLk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jun 2019 17:11:40 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:33560 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZVLk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jun 2019 17:11:40 -0400
Received: by mail-oi1-f194.google.com with SMTP id f80so246433oib.0
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jun 2019 14:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9zZBcP42w+FfUJSSMob2Wy5TEGFIi2CbH0dibBo9nDw=;
        b=KJtmiDbD3Gc05H7ywz8pvyuRgtlvuMu5l+H/IgMtcVFt4t5CEbKEdYW6HUGaaNp7PP
         WWUtNj8EHRF9arWAiY4wvP6sGjvWKaAHdVsPRVGmhE3//+AEAKAHIMbcI52ZOgaPwF/z
         lU+3oRSVHnfLTxr0DKqev8217LkS0A92FyYqdPXosOQyA7HJv9Bpog6KjZKI1xxK1f+B
         oHnKY1aqfZBpWpIiis9i8u2Qdz4Qoj3TiKMiw9CnL1Nt18gSzPMq1ovoqXoxDpgap+rt
         stB7Yonfo3gqiR+FILATjmcpgv7RrowO6XzfnVpgCMvgNV/CMi6aFNXeMIhk3DeQ8ZIX
         aUig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9zZBcP42w+FfUJSSMob2Wy5TEGFIi2CbH0dibBo9nDw=;
        b=XHhHpjMd1d2Ktm17J5IlzaW3yGe/mqv4IgPrrcdAO0go+uh8Ixa9PbDK1Z4QenAhtB
         ShxTMtPOGo62VFnDX3D3If9uXEOSquOvfmhisFlh+xKMpIZsdSkZKGgosDi7+OjgaAgO
         BG6PlrGp/WSKkne8rrT26U7PhhCMWAwCpVwko5oQRFGorSbP//u8ct/mtEShaa22drT4
         c18U9SEulQ5ajWQtluKK89uB/EvJ3qlg9yJWvkY0L7tQt5kfV/HKgL6zfKNiwlGcpZ07
         prOsvXWR4eI8o5RyQHmHlcSo0bOpJxGY7QvGEDokkOfOiG08x0Yc7iufiK/DWmOUf3qq
         XFoA==
X-Gm-Message-State: APjAAAXQncubBBrgBUMRgFZPzV4gCMZ1hS37mr+wabp1ouB/VQSaA03j
        dT9a6Qx0JBJz/JQvzXNkOShkmB5gPqJPgyfvsGQ=
X-Google-Smtp-Source: APXvYqwyG2yf75s1qakjBsZ4XOG12tAY9PyETZuiCo5fq4m1CuZWbEVWJYbuHYbEqpIxbhtpFBxtje1a5BQZglwZqAU=
X-Received: by 2002:aca:c795:: with SMTP id x143mr267503oif.50.1561583499563;
 Wed, 26 Jun 2019 14:11:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190625145254.28510-1-ard.biesheuvel@linaro.org>
 <20190625171234.GB81914@gmail.com> <CAKv+Gu8P4AUNbf636d=h=RDFV+CPEZCoPi9EZ+OtKEd5cBky5g@mail.gmail.com>
 <ca908099-3305-9764-dbf2-adc7a256ad59@gmail.com> <CAKv+Gu9jAqGAYg8f_rBVbve=L3AQb_xKnpmnsqrZ3m7VLnaz1g@mail.gmail.com>
 <e9d045c6-f6e2-a0d2-b1f2-bebee5d027f4@gmail.com>
In-Reply-To: <e9d045c6-f6e2-a0d2-b1f2-bebee5d027f4@gmail.com>
From:   Samuel Neves <samuel.c.p.neves@gmail.com>
Date:   Wed, 26 Jun 2019 22:11:03 +0100
Message-ID: <CAEX_ruEDA9ZG+6aA_jTBSq-MM=pOrdxoJA2x0LPF3dkYk76kCQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: morus - remove generic and x86 implementations
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

, On Wed, Jun 26, 2019 at 8:40 AM Milan Broz <gmazyland@gmail.com> wrote:
>
> On 26/06/2019 09:15, Ard Biesheuvel wrote:
>
> > Thanks for the insight. So I guess we have consensus that MORUS should
> > be removed. How about aegis128l and aegis256, which have been
> > disregarded in favor of aegis128 by CAESAR (note that I sent an
> > accelerated ARM/arm64 version of aegis128 based on the ARMv8 crypto
> > instructions, in case you missed it)
>
> Well, there are similar cases, see that Serpent supports many keysizes, even 0-length key (!),
> despite the AES finalists were proposed only for 128/192/256 bit keys.
> (It happened to us several times during tests that apparent mistype in Serpent key length
> was accepted by the kernel...)

I'm not sure the Serpent case is comparable. In Serpent, the key can
be any size below 256 bits, but internally the key is simply padded to
256 bits and the algorithm is fundamentally the same. There are no
speed differences between different keys sizes.

On the other hand, AEGIS128, AEGIS256, and AEGIS128L are different
algorithms, with different state sizes and state update functions. The
existing cryptanalysis of AEGIS consists solely of [1] (which is the
paper that directly inspired the MORUS cryptanalysis), which does not
look at AEGIS128L at all. In effect, to my knowledge there are no
known cryptanalytic results on AEGIS128L, which I imagine to be one of
the main reasons why it did not end up in the CAESAR portfolio. But
AEGIS128L is by far the fastest option, and a user is probably going
to be naturally tempted to use it instead of the other variants.

[1] https://eprint.iacr.org/2018/292
