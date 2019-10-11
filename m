Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ACD3ECE58C
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 14:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7AC420679
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 14:15:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b="Ii+sYIaC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbfJKOPM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 10:15:12 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42162 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbfJKOPL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 10:15:11 -0400
Received: by mail-ed1-f68.google.com with SMTP id y91so8805629ede.9
        for <linux-crypto@vger.kernel.org>; Fri, 11 Oct 2019 07:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryptogams.org; s=gmail;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NxRqcpgft6HxNHQsFkXilvChGERevyF+onKOD4k/Nmw=;
        b=Ii+sYIaCTwABlDBgKtdN2uAmj90iqH+Ih9wnTeORJWBU3Ag+VIsCGyJAyz1Ut8cy4k
         Sz8vyeiwEZr0QyyTE9NZi+gASf3AJT5/8prfoG1Amd7NORV3k/p0Wn7SP+9sNlkXveSb
         q8AP6lsFpDqY5vpURjwvTlXRPbeemVIct8Q8oh1Zv3BBwUV6TaJAUz64qZ5LgiGXbpC+
         TIcAlgRWsfASh5ZVUZ/uUoidVp1CqwFy5qKVIDH/FhZpoJYrs6RRrqHa9GVWofkBJ3CZ
         Yr/iKouYJYH/qf02/1ITnXMi0tjZ0XNJUA8VS4MS7+8TpiIhGKpqeDmDPi5p0tKGYBDP
         Dxtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NxRqcpgft6HxNHQsFkXilvChGERevyF+onKOD4k/Nmw=;
        b=dpbmd7+CWYSV0VIOn0Y4aNw/bAUK+fypxrl/bvnHIB3yxK8x0q6rRXz2y+U7axYFw0
         azUqzALX89459sk5R7Qit5HVvRQWRmqFu2yzYOcrAHI7apgpCDU8zxjit/9caiZFm1fp
         ndS4QXZgneGEgT883oUR6mhYRg3eppm3GFkOLq8GGgPLp0kVO/WTp3dYMucJjJOwINwY
         tKBxfOwVFj4paVfycH1+5YCGQU0fgjz1kme4dwNlYtq6XF57qWCjvsfOqrHRCMtmPT8H
         liYl0FMMTde8IpK6uMYwWmhuMN0XujsZ/4ENc3NGgiJYLvDFzUC4ZKEr0HpOfwoVyJA7
         gbYg==
X-Gm-Message-State: APjAAAXm1qfnkpec0LrHtoUHDki5uADIXfvsf05TMbdijQlI/g/0q6kL
        1OYnfeK6lwAQUFD31CiB0QLOPkeKsxCdiHuoO8yErw==
X-Google-Smtp-Source: APXvYqyzAIPiBPtaTpf3RayFDYs8p7WmKnL2oRc/lyNFCA6WLrR3AyFMjDN0VBfxz2/eApU2ZWsmekKOgJB1GXPm0DI=
X-Received: by 2002:a17:906:1343:: with SMTP id x3mr14224938ejb.113.1570803309858;
 Fri, 11 Oct 2019 07:15:09 -0700 (PDT)
MIME-Version: 1.0
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
 <20191007164610.6881-20-ard.biesheuvel@linaro.org> <20191007210242.Horde.FiSEhRSAuhKHgFx9ROLFIco@www.vdorst.com>
 <a1c1ade1-f62a-3422-c161-a1d62ea67203@cryptogams.org>
In-Reply-To: <a1c1ade1-f62a-3422-c161-a1d62ea67203@cryptogams.org>
From:   Andy Polyakov <appro@cryptogams.org>
Date:   Fri, 11 Oct 2019 16:14:58 +0200
Message-ID: <CABb3=+a5zegft0e8ixCVe0xc=FAV1W-bse3x5qhytQ8GKJTJPA@mail.gmail.com>
Subject: Re: [PATCH v3 19/29] crypto: mips/poly1305 - incorporate
 OpenSSL/CRYPTOGAMS optimized implementation
To:     =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 10/8/19 1:38 PM, Andy Polyakov wrote:
>>> <snip>
>>
>> Hi Ard,
>>
>> Is it also an option to include my mip32r2 optimized poly1305 version?
>>
>> Below the results which shows a good improvement over the Andy Polyakov
>> version.
>> I swapped the poly1305 assembly file and rename the function to
>> <func_name>_mips
>> Full WireGuard source with the changes [0]
>>
>> bytes |  RvD | openssl | delta | delta / openssl
>>  ...
>>  4096 | 9160 | 11755   | -2595 | -22,08%

Update is pushed to cryptogams. Thanks to Ren=C3=A9 for ideas, feedback and
testing! There is even a question about supporting DSP ASE, let's
discuss details off-list first.

As for multiply-by-1-n-add.

> I assume that the presented results depict regression after switch to
> cryptogams module. Right? RvD implementation distinguishes itself in two
> ways:
>
> 1. some of additions in inner loop are replaced with multiply-by-1-n-add;
> ...
>
> I recall attempting 1. and chosen not to do it with following rationale.
> On processor I have access to, Octeon II, it made no significant
> difference. It was better, but only marginally. And it's understandable,
> because Octeon II should have lesser difficulty pairing those additions
> with multiply-n-add instructions. But since multiplication is an
> expensive operation, it can be pretty slow, I reckoned that on processor
> less potent than Octeon II it might be more appropriate to minimize
> amount of multiplication-n-add instructions.

As an example, MIPS 1004K manual discusses that that there are two
options for multiplier for this core, proper and poor-man's. Proper
multiplier unit can issue multiplication or multiplication-n-add each
cycle, with multiplication latency apparently being 4. Poor-man's unit
on the other hand can issue multiplication each 32nd[!] cycle with
corresponding latency. This means that core with poor-man's unit would
perform ~13% worse than it could have been. Updated module does use
multiply-by-1-n-add, so this note is effectively for reference in case
"poor man" wonders.

Cheers.
