Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AECFC7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 09:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63C7B22C7C
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 09:00:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QB+uiNde"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfGZJAe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 05:00:34 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33046 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfGZJAd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 05:00:33 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so53676902wru.0
        for <linux-crypto@vger.kernel.org>; Fri, 26 Jul 2019 02:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dJVx4P/EeCRADCgDlxio4Ghh0z07e18qae2iw3g0/Tw=;
        b=QB+uiNder4J7yPGtQrufMvro7531SU0nH/jVWiroocLxSGVsqmHDTT/+MfDK/IB3fU
         8a2HXVGXvw3+xRO0cPl6XTHndoaYdUUB9CEmv/3OmS1qGRuqXrlp7F7i4hr4kEbJb1PC
         rNmX8HaQ31+627HAa8ccPgAOLHxpk+X18gXF0yTWbYzKwcBfGkXTD5hICizmDcKXn73B
         IZrrKNkoI3ahlxvu2AuMQcs/IE7VxmhXV/TizoyZux1GUvzJGoctLVIZ1RfEvD/7N5rq
         0fOG6tLb9CupWe2/L0MjyrrOmqZeWOG61NNUj67w8VaDxlq3uJEnNnlcMql6WLYLNZZU
         sfkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dJVx4P/EeCRADCgDlxio4Ghh0z07e18qae2iw3g0/Tw=;
        b=Dav9ANimUPGNtHgVg6LXi/ZH/ECZzrVWxzJ1hEHeVqnE5XtqeTIAPz0fdNl5dbOGEN
         BFEjTariI4koQ62BuOHbLHv8Pq6JPZFHwmWvCmm/85Se0eGBzoueuVVLesCqoLnP5+yr
         ORfd0HT1p9iq6Kn5Qfq1gNHC6BOielXUZKdu0hSLSD3caRrllRTp2U/icLYMxNgvGnsj
         /BBK6bWX6Y+Z3nvhF1mimloYSnlAeNADYW24vK/+xgSG0RXTtKe8s5cLrHwGIfMV/zu8
         auTsVnfRwQwpQQMmxOmGkI36kZ4Lg8NcTg0hf9LLwhFftB0mYQRr1A2VISGZN3JlkuMj
         7jKQ==
X-Gm-Message-State: APjAAAXcZiSCQUnz3QZv67Ldskp+HXiwGNCj7PYMNXf+m5nJ+TKGGUNE
        xdeq7Dlh9d5Jwow5qKnjPNUsfS0ViuLLmoG9DICg3Q==
X-Google-Smtp-Source: APXvYqx7bUMqy+QSbXLNhmTp4DIf55sDRBr+HazKXdlvNwnSDKJEyJkJ3VlANZxNeJ7joo3dbTP9dkBrOhCiZU6qkQM=
X-Received: by 2002:adf:9ccf:: with SMTP id h15mr84833859wre.241.1564131631933;
 Fri, 26 Jul 2019 02:00:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190704183017.31570-2-ard.biesheuvel@linaro.org> <20190726043117.GA654@gondor.apana.org.au>
In-Reply-To: <20190726043117.GA654@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 26 Jul 2019 12:00:20 +0300
Message-ID: <CAKv+Gu_Pir7uU4h6GQfh2my2Fu-j2AGPLWNZKzc9_iG6n4xJNA@mail.gmail.com>
Subject: Re: [PATCH v8 1/7] crypto: essiv - create wrapper template for ESSIV generation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 26 Jul 2019 at 07:31, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >
> > + * The typical use of this template is to instantiate the skcipher
> > + * 'essiv(cbc(aes),aes,sha256)', which is the only instantiation used by
> > + * fscrypt, and the most relevant one for dm-crypt. However, dm-crypt
> > + * also permits ESSIV to be used in combination with the authenc template,
> > + * e.g., 'essiv(authenc(hmac(sha256),cbc(aes)),aes,sha256)', in which case
> > + * we need to instantiate an aead that accepts the same special key format
> > + * as the authenc template, and deals with the way the encrypted IV is
> > + * embedded into the AAD area of the aead request. This means the AEAD
> > + * flavor produced by this template is tightly coupled to the way dm-crypt
> > + * happens to use it.
>
> IIRC only authenc is allowed in dm-crypt currently in conjunction
> with ESSIV.  Does it ever allow a different hash algorithm in
> authenc compared to the one used for ESSIV? IOW given
>
>         essiv(authenc(hmac(X),cbc(Y)),Z,U)
>
> is it currently possible for X != U or Y != Z? If not then let's
> just make the algorithm name be essiv(Y,X).
>

X and U are independent, since the dm-crypt userland API permits you
to specify both, and the only requirement is that the digest size of U
is a valid jey size for Z.

For Y and Z, it is not straightforward either: since the crypto API
permits the use of driver names in addition to the plain CRA names,
we'd have to infer from the first parameter which cipher is being
used.

E.g., this could be

authenc-hmac-sha1-cbc-aes-chcr
authenc-hmac-sha1-cbc-aes-iproc
authenc-hmac-sha1-cbc-aes-caam-qi
authenc-hmac-sha1-cbc-aes-ccree
safexcel-authenc-hmac-sha1-cbc-aes
authenc-hmac-sha1-cbc-aes-picoxcell
qat_aes_cbc_hmac_sha1
authenc-hmac-sha1-cbc-aes-talitos

but also

authenc(..., cbc-ppc-spe))
authenc(..., cbc-aes-s390))
authenc(..., cbc-aes-ppc4xx))
authenc(..., artpec6-cbc-aes))
authenc(..., cbc-aes-iproc))
authenc(..., cbc-aes-caam))
authenc(..., cbc-aes-caam-qi))
authenc(..., cbc-aes-caam-qi2))
authenc(..., cavium-cbc-aes))
authenc(..., n5_cbc(aes)))
authenc(..., cbc-aes-geode))
authenc(..., hisi_sec_aes_cbc))
authenc(..., safexcel-cbc-aes))
authenc(..., mv-cbc-aes))
authenc(..., cbc-aes-nx))
authenc(..., cbc-aes-padlock))
authenc(..., cbc-aes-picoxcell))
authenc(..., qat_aes_cbc))
authenc(..., cbc-aes-sun4i-ss))
authenc(..., cbc-aes-talitos))
authenc(..., cbc-des-talitos))
authenc(..., cbc-aes-ux500))
authenc(..., virtio_crypto_aes_cbc))
authenc(..., p8_aes_cbc))

where the first one does not even have the cipher in its name.

So the only way to deal with this is to instantiate the AEAD and then
parse the name.

Unfortunately, this means that patch #3 in this series is broken,
since it assumes that we can infer authenc'ness from the user
specified cipher string.

> Because this is legacy stuff, I don't want it to support any more
> than what is currently being supported by dm-crypt.
>
> Similary for the skcipher case, given
>
>         essiv(cbc(X),Y,Z)
>
> is it ever possible for X != Y? If not then we should just make the
> algorithm name essiv(X,Z).
>

Same problem. We'd need to instantiate the skcipher and parse the cra_name.

Perhaps we should introduce a crypto API call that infers the cra_name
from a cra_driver_name?
