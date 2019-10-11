Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25BBEC47404
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 18:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE90C222D1
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 18:49:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b="FBpxSDHS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbfJKStW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 14:49:22 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37196 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728966AbfJKStW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 14:49:22 -0400
Received: by mail-ed1-f68.google.com with SMTP id r4so9557591edy.4
        for <linux-crypto@vger.kernel.org>; Fri, 11 Oct 2019 11:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryptogams.org; s=gmail;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dLREoD8VZsbLG4RNnQzVU+lz0coRJeXKm7I6cQzHWCM=;
        b=FBpxSDHSl5h0D0K0CUSQr+iDnLFNRCThN7zywYEYH0IR45Qbjk8tE6aAW3jKmkvILr
         1ycQbgRiNyEej71ci6GO46wkxLg0Sqv0cJhgCRe8u8gho8NL9NXAqBVjYfEywpRYIeLE
         f7i6kwJbP2dB/6ME1h7Tq2g49XPVe//Bojng+ID7FaFWcXmdJPRjFDOhtPMn8AwJ6nDj
         EYLBOO6nFuMHlJPEgWkAwWp2pEgCEWlKeD80JSufywSeySKIuh+ni1AVHuIqUUnrcVwj
         0N/F71gdmFtAmeiQmWig7qFsdwN00PJebdbbYb1u4GraTZ1vogWYBBpONd6eXZ9SZ4NI
         6HmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dLREoD8VZsbLG4RNnQzVU+lz0coRJeXKm7I6cQzHWCM=;
        b=hgQ63wmwlBixpGA00D8MTc6umvgZEQQM0vwgBq7kPXByYx3qki6XtYh0cCbKOq6hrT
         D+m3iqgWHOQrVMdieIqumocGfHQgznoPIY4g8MU8IsW72JSoR28rTsa4zk2zuhl365es
         6/a3pCfblferRIoUWdnCTBAaJhUpIiHitBhMqkit6Gt0LdjmoDR4/XDAj9kT2M3cNerM
         +p43u6VAlzDQJVMF2NUYx6T0tA66qTJpCHvYQRgAa5il/BMgqtUJ9+WzneC/YAKq4U3s
         /vVq1GOMxw3dv060veJxUfdYcbIsKl8+ee3W7m1ZMvvBXd/AIAacTHhTaQeJ3cyb21bW
         3FGw==
X-Gm-Message-State: APjAAAXegEtERkhJPn+1GsBDn6jaxmBR74PK9e1rTAHBK5RRLpfU8Jfi
        /OqSpMFlH8V+tVsZBi9ujHFFu17KZEimfTRSxjd2mQ==
X-Google-Smtp-Source: APXvYqyjTgZ5NjVsILsULeLWY2Z8jzdOLbEi9VjspmJqkxC9KOyRuUm6s1GUQ/3n0nfZ8y16gnibrQzM48RJfy01WzM=
X-Received: by 2002:a05:6402:21d6:: with SMTP id bi22mr14876917edb.19.1570819760376;
 Fri, 11 Oct 2019 11:49:20 -0700 (PDT)
MIME-Version: 1.0
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
 <20191007164610.6881-20-ard.biesheuvel@linaro.org> <20191007210242.Horde.FiSEhRSAuhKHgFx9ROLFIco@www.vdorst.com>
 <a1c1ade1-f62a-3422-c161-a1d62ea67203@cryptogams.org> <CABb3=+a5zegft0e8ixCVe0xc=FAV1W-bse3x5qhytQ8GKJTJPA@mail.gmail.com>
 <20191011172133.Horde.sxiyClHzSJAUvHtYJdMQEbN@www.vdorst.com>
In-Reply-To: <20191011172133.Horde.sxiyClHzSJAUvHtYJdMQEbN@www.vdorst.com>
From:   Andy Polyakov <appro@cryptogams.org>
Date:   Fri, 11 Oct 2019 20:49:08 +0200
Message-ID: <CABb3=+a7qfin8QjaDgt9iU-ps05GYP+pA=fs2L1E9vgEBr7Egg@mail.gmail.com>
Subject: Re: [PATCH v3 19/29] crypto: mips/poly1305 - incorporate
 OpenSSL/CRYPTOGAMS optimized implementation
To:     =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
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

On 10/11/2019 7:21 PM, Ren=C3=A9 van Dorst wrote:
>
> ...
>
> I also wonder if we can also replace the "li $x, -4" and "and $x" with
> "sll $x"
> combination on other places like [0], also on line 1169?
>
> Replace this on line 1169, works on my device.
>
> -       li      $in0,-4
>         srl     $ctx,$tmp4,2
> -       and     $in0,$in0,$tmp4
>         andi    $tmp4,$tmp4,3
> +       sll     $in0, $ctx, 2
>         addu    $ctx,$ctx,$in0

The reason for why I chose to keep 'li $in0,-4' in poly1305_emit is
because the original sequence has higher instruction-level parallelism.
Yes, it's one extra instruction, but if all of them get paired, they
will execute faster. Yes, it doesn't help single-issue processors such
as yours, but thing is that next instruction depends on last, and then
*formally* it's more appropriate to aim for higher ILP as general rule.
Just in case, in poly1305_blocks is different, because dependent
instruction does not immediately follow one that computes the residue.

>> As for multiply-by-1-n-add.
>>
>
> I wonder how many devices do exist with the "poor man" version.

Well, it's not just how many devices, but more specifically how many of
those will end up running the code in question. I would guess poor-man's
unit would be found in ultra-low-power microcontroller, so... As
implied, it's probably sufficient to keep this in mind just in case :-)

Cheers.
