Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B60C06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 16:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4655F2082F
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 16:30:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ol2y26JO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfGBQas (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 12:30:48 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38247 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbfGBQar (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 12:30:47 -0400
Received: by mail-wr1-f65.google.com with SMTP id p11so7374065wro.5
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 09:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9PsQvCCZoQ6Pr9ZY9NX1OgTQ4z7Cl/JEAfSQ/wKA4qg=;
        b=ol2y26JO3VcPZrpUUa0uP/W9Nq1zsvNy/OKaa7rB4temFaZpUB5wZToZEorWvTVgjg
         Td8pabZLF60puoXYeKnOOJHoir+mU6ikYpjNsjDB8FwoY1kLqiE1TZlEKK0gDCxLZv3Z
         WBumeokOAMug/Yj2CCf7e5z0YNPlU75LtyZR6y/Qe+hSP5WLE0+Hi5cTRDIabw9ijcfX
         IfdbxnArq98ylsHn+Xvw1e4RAaxQm/0EgHsr3GGx8pL6nYS5lO9iuPEW6BfxnrW3c2CH
         XV6LxrkwYNu2jEGaDCWJibs4ZvaXBQip3yqjlGRzV7bCD4vX8Q/TI69Xi1rD7lrBI8GA
         981g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9PsQvCCZoQ6Pr9ZY9NX1OgTQ4z7Cl/JEAfSQ/wKA4qg=;
        b=Y2OLFyBXgX495n0QqLZgQP4n95pgLNf5IvoH2eP4Z9uzLbuPr5fLnhkcNSUpHHDK+j
         yboKJml3bDkiIfcG3KE5DwREAE5ePG0Rs2HnXBm1zi7GT73q/9gzjfkqHamYI3IF9PvE
         KHZgnfbR5JiffXbGTLitosQwrm4L/a+q3g7RJeJ9XiFd0iCP+zzljTevY9pdsXd95uJ9
         FEKfLqklkIs90M3qaSIpfbY51Ex1eMbUTl3mET+pdDZ8LbYriG1ff0lBX9YdZ5059mi2
         P/D9JCfb9t29+zs+RWBWzPwBQUcs/mRFCy0csHWRe3jFm7RTCr0OdQ0lcfcAbTpN1N2d
         pg8A==
X-Gm-Message-State: APjAAAWgKb3cfjOiiGz3cbgLd+2FW6Jpmo8C0P6rtfIQDpCobXqSy4Ul
        hW6MaJifvi1OTRaR4oGq1MYpRSV+zvrwvjjfu4IAPw==
X-Google-Smtp-Source: APXvYqww7rnr2/OCeFvLIZKy6IV1f5KVjAf+1C7xAyWaibN9SGqeuSRRc5TkIlQIvUv0CkprWr3EM/GO4j5BMsePehE=
X-Received: by 2002:a5d:6b07:: with SMTP id v7mr9884997wrw.169.1562085045816;
 Tue, 02 Jul 2019 09:30:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190628152112.914-1-ard.biesheuvel@linaro.org>
 <20190628152112.914-5-ard.biesheuvel@linaro.org> <f068888f-1a13-babf-0144-07939a79d9d9@gmail.com>
In-Reply-To: <f068888f-1a13-babf-0144-07939a79d9d9@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 2 Jul 2019 18:30:30 +0200
Message-ID: <CAKv+Gu-hATMtNVUJ-WOr0yia0-X=M_ME6CutREy9q_ZyorpCzw@mail.gmail.com>
Subject: Re: [PATCH v6 4/7] md: dm-crypt: switch to ESSIV crypto API template
To:     Milan Broz <gmazyland@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 1 Jul 2019 at 10:59, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 28/06/2019 17:21, Ard Biesheuvel wrote:
> > Replace the explicit ESSIV handling in the dm-crypt driver with calls
> > into the crypto API, which now possesses the capability to perform
> > this processing within the crypto subsystem.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> >  drivers/md/dm-crypt.c | 200 ++++----------------
>
> ...
>
> > -/* Wipe salt and reset key derived from volume key */
> > -static int crypt_iv_essiv_wipe(struct crypt_config *cc)
>
> Do I understand it correctly, that this is now called inside the whole cipher
> set key in wipe command (in crypt_wipe_key())?
>
> (Wipe message is meant to suspend the device and wipe all key material
> from memory without actually destroying the device.)
>
> > -{
> > -     struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
> > -     unsigned salt_size = crypto_shash_digestsize(essiv->hash_tfm);
> > -     struct crypto_cipher *essiv_tfm;
> > -     int r, err = 0;
> > -
> > -     memset(essiv->salt, 0, salt_size);
> > -
> > -     essiv_tfm = cc->iv_private;
> > -     r = crypto_cipher_setkey(essiv_tfm, essiv->salt, salt_size);
> > -     if (r)
> > -             err = r;
> > -
> > -     return err;
> > -}
>
> ...
>
> > @@ -2435,9 +2281,19 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
> >       }
> >
> >       ret = crypt_ctr_blkdev_cipher(cc, cipher_api);
> > -     if (ret < 0) {
> > -             ti->error = "Cannot allocate cipher string";
> > -             return -ENOMEM;
> > +     if (ret < 0)
> > +             goto bad_mem;
> > +
> > +     if (*ivmode && !strcmp(*ivmode, "essiv")) {
> > +             if (!*ivopts) {
> > +                     ti->error = "Digest algorithm missing for ESSIV mode";
> > +                     return -EINVAL;
> > +             }
> > +             ret = snprintf(buf, CRYPTO_MAX_ALG_NAME, "essiv(%s,%s,%s)",
> > +                            cipher_api, cc->cipher, *ivopts);
> > +             if (ret < 0 || ret >= CRYPTO_MAX_ALG_NAME)
> > +                     goto bad_mem;
>
> Hm, nitpicking, but goto from only one place while we have another -ENOMEM above...
>
> Just place this here without goto?
>

Actually, the bad_mem label is used 10 lines up as well.
So I'll keep this goto in the next revision.

> > +     ti->error = "Cannot allocate cipher string";
> > +     return -ENOMEM;
>
> Otherwise
>
> Reviewed-by: Milan Broz <gmazyland@gmail.com>
>
> Thanks,
> Milan
