Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46ECAC48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C5B7208CB
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:04:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bpQA2pru"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfF0KEC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:04:02 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45919 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbfF0KEC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:04:02 -0400
Received: by mail-io1-f66.google.com with SMTP id e3so3378490ioc.12
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LUnzatdOsjTiEmHJ0av3m7xdK0wCqBtSlxPyyJ7mhbI=;
        b=bpQA2prum+jQb+nKpPLwLy6OYpJjGkIsAZAnTqkPdeC3opXxlNILWZURWqpSWTTZgV
         K/Ud5k0ZsbJWOcw1BDy6spaiiXpMpyMi6klgezVeqV6f1X9qvxQpbsVBszkUBdDGl3o7
         JIgqCkrv05ZAlEwh2kBRZT0mkKZFb5tzVURn7BaIAW6+5vCShSBhBRvzNQRHtUl1/6Xn
         zi1PSK0iBjiuiXUUp5rrWohrg+EAh7tcHBubozvZZGlstfttt0G/+TdJgJw16OEp3mad
         7S785UTuPErv3y24ei7N7EBmyxfuRKfBNDYSkcaAwALxJwEx2I4ah9XEfNrsrEk7y/z+
         jzFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LUnzatdOsjTiEmHJ0av3m7xdK0wCqBtSlxPyyJ7mhbI=;
        b=Qwn++Vbz5g/qFvZREZAmS7E5wNpVKxHfb7E4i8OPns3HlMkVm2BoVv6W6D7BRgq28c
         ba36sI95jW6GuqdvuDr6GDnP78np6NAnn2r06Ht3XSh9zP00ZiwzPKSiBtpLhJBsm9G4
         J9jmQ1ruZWBZo58vBrZ73IYeNJwchHocFo11npas9VKu2QShff5W24kuyj+zsxWeUlOF
         watep5IB6D8fUiF4WCGsOBMsWmSiNpzCw2hzksSgYZKF1XR9oBKnR+OOCl33BKveELXo
         OWqcLDJh1UqXhy+h8klwWW7UUsG9cNSrAEhVg9wfjiGWa5a1opcx/UgrtOvYGWUhozo+
         XzEQ==
X-Gm-Message-State: APjAAAWSujqNWnG1VMiDJqXHokUnKCaRuNBtruRediD8OgKpUs5v600M
        rVfJgaOgkbZZ0rd37F95nEz+s3cFcdafkfCzLUY7hA==
X-Google-Smtp-Source: APXvYqxA8rn2GQFzMcldG00FoHFiX14+Cg+wJZqYi1vcol/JOPg9Z38eczl3L3JoAsq17BENRMzUQ04nB1WgBwkuyRE=
X-Received: by 2002:a05:6602:98:: with SMTP id h24mr3623173iob.49.1561629841383;
 Thu, 27 Jun 2019 03:04:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190622193427.20336-1-ard.biesheuvel@linaro.org> <20190626041155.GC745@sol.localdomain>
In-Reply-To: <20190626041155.GC745@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 27 Jun 2019 12:03:49 +0200
Message-ID: <CAKv+Gu-qk6Hf=EJj3=KDfyU4EYHnwvfSEGPZ_aiX2rguP=pgyg@mail.gmail.com>
Subject: Re: [PATCH v2 00/26]crypto: AES cleanup
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 26 Jun 2019 at 06:11, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Sat, Jun 22, 2019 at 09:34:01PM +0200, Ard Biesheuvel wrote:
> > This started out as an attempt to provide synchronous SIMD based GCM
> > on 32-bit ARM, but along the way, I ended up changing and cleaning up
> > so many things that it is more of a general AES cleanup now rather than
> > anything else.
> >

...
>
> I'm seeing the following self-tests failures with this patchset applied:
>
> On arm32:
>
> [   20.956118] alg: skcipher: ctr-aes-ce-sync encryption test failed (wrong result) on test vector 0, cfg="random: inplace use_digest nosimd src_divs=[100.0%@+3650] iv_offset=9"
> [   28.344185] alg: skcipher: ctr-aes-neonbs-sync encryption test failed (wrong result) on test vector 0, cfg="random: inplace use_final nosimd src_divs=[16.88%@+3, <flush>39.11%@+1898, <reimport>44.1%@+5] iv_offset=13"
>
> On arm64:
>
> [   15.528433] alg: skcipher: ctr-aes-ce encryption test failed (wrong result) on test vector 0, cfg="random: use_digest nosimd src_divs=[100.0%@+4078]"
> [   20.080914] alg: skcipher: ctr-aes-neon encryption test failed (wrong result) on test vector 0, cfg="random: inplace use_final nosimd src_divs=[50.90%@+255, <flush,nosimd>49.10%@+25]"
>
> Maybe a bug in crypto_ctr_encrypt_walk()?
>

Yes. I was using the skcipher blocksize rather than the chunksize for
the transformation, which is obviously incorrect.
