Return-Path: <SRS0=ZKCq=6R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29705C28CBC
	for <linux-crypto@archiver.kernel.org>; Sun,  3 May 2020 14:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4FB92075B
	for <linux-crypto@archiver.kernel.org>; Sun,  3 May 2020 14:02:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="lEkmCnyC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728522AbgECOCM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 3 May 2020 10:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728239AbgECOCM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 May 2020 10:02:12 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4B2C061A0E
        for <linux-crypto@vger.kernel.org>; Sun,  3 May 2020 07:02:11 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id u203so3936738vkb.11
        for <linux-crypto@vger.kernel.org>; Sun, 03 May 2020 07:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9RvjLqM4GX3NRQ8lbi4uMCC4ITiyZWS4YVBknGPLOfQ=;
        b=lEkmCnyCQS6yho8pHyOVj8AaMr2yuDfPMuZ4gNovPiCt0QX1iZgac/5P6hbR2PemyV
         3ErtHs9s65XIXgY1egIV+rtkjUd+UgD+56OBk//Kcy5GggWJY1YHzJQnTwP1zI8RpqQh
         hseUvDrwaELhk6JSTVNDJODPAdbSzGgmHMZ4azOd+LAoBJjiin+acT5GCtx3TfpdO4Im
         xH27rKTNcPoa09T61EM/Ft7wXE1ROKWRoBk+3B1eZR/YBykpOx0Tw41ykKIl4TM3ucB0
         uNQS62PumvayikRnb+GAnss4lXYrs+Vs1HI2rq4P4LLmyD4CKzefTFeJxEjB0qOhxtyI
         Qiuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9RvjLqM4GX3NRQ8lbi4uMCC4ITiyZWS4YVBknGPLOfQ=;
        b=iCQBkIQbFMjKPtF7gxkjB8lTyfxA71Aoc2NN1W55pQVZGelrn8gYCIDBFJ87L7Tchn
         gWFUVIoqHx+fk2zEqZi5hqGWUU7OHd9A6wBk5YZPQGaPrTyyPPp4Mk0ijptOz+3wbWd7
         y3gihPVs2HVM5SfihqdLAyyoy8mDxlos9hVDfrtFvSjU7CQ1bhJMSUsB5DWXqFyU1kFp
         a/1XLMy9glPw1T9T9ph4VJWNM2L9Bf5JTw/yeYETygpBUggFsxMs9zGqdzzFhAKoxStx
         /9KGmeh6Y0PLF2018hRUOWHGprOWlEHp8XpmOTY2je32KTnIgJ2xdXtavddGDFgrgESA
         olYw==
X-Gm-Message-State: AGi0PuYEOEHF+lsahHLd/+ior8urPgqfKKddrA0GVfvfO+IOICgjakZv
        z7WcJTdQlKcJwilhQBUT7in1mtGJAmlcoEV9SDQ9h4rK/Ec=
X-Google-Smtp-Source: APiQypLDJpnWc18Dq+FkU4DW1kWsd/4MQgOCNhtPZVa2Ayc0JX5ISktE+WsBQ7iKf2PiDpbX4s7vTphPXpjxT9o9p6s=
X-Received: by 2002:a1f:c1:: with SMTP id 184mr7797378vka.62.1588514530283;
 Sun, 03 May 2020 07:02:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200502053122.995648-1-ebiggers@kernel.org> <20200502053122.995648-7-ebiggers@kernel.org>
In-Reply-To: <20200502053122.995648-7-ebiggers@kernel.org>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sun, 3 May 2020 17:01:59 +0300
Message-ID: <CAOtvUMemET3bkh0-sL-o=pSEEWYEs2ZVD1pGYW7RCpC=TR1i6g@mail.gmail.com>
Subject: Re: [PATCH 06/20] crypto: ccree - use crypto_shash_tfm_digest()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, May 2, 2020 at 8:33 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Instead of manually allocating a 'struct shash_desc' on the stack and
> calling crypto_shash_digest(), switch to using the new helper function
> crypto_shash_tfm_digest() which does this for us.
>
> Cc: Gilad Ben-Yossef <gilad@benyossef.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/crypto/ccree/cc_cipher.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_c=
ipher.c
> index a84335328f371c..872ea3ff1c6ba7 100644
> --- a/drivers/crypto/ccree/cc_cipher.c
> +++ b/drivers/crypto/ccree/cc_cipher.c
> @@ -427,12 +427,9 @@ static int cc_cipher_setkey(struct crypto_skcipher *=
sktfm, const u8 *key,
>                 int key_len =3D keylen >> 1;
>                 int err;
>
> -               SHASH_DESC_ON_STACK(desc, ctx_p->shash_tfm);
> -
> -               desc->tfm =3D ctx_p->shash_tfm;
> -
> -               err =3D crypto_shash_digest(desc, ctx_p->user.key, key_le=
n,
> -                                         ctx_p->user.key + key_len);
> +               err =3D crypto_shash_tfm_digest(ctx_p->shash_tfm,
> +                                             ctx_p->user.key, key_len,
> +                                             ctx_p->user.key + key_len);
>                 if (err) {
>                         dev_err(dev, "Failed to hash ESSIV key.\n");
>                         return err;
> --
> 2.26.2
>

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks,
Gilad


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
