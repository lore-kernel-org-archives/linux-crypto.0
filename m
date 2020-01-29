Return-Path: <SRS0=eQ+U=3S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E62C2D0DB
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jan 2020 14:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 218042070E
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jan 2020 14:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgA2O6H (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Jan 2020 09:58:07 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35883 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgA2O6H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Jan 2020 09:58:07 -0500
Received: by mail-ot1-f68.google.com with SMTP id g15so15817075otp.3;
        Wed, 29 Jan 2020 06:58:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=98/1pZSuwZiSFwLJuAyYfT+2dHa717H2MdqRYmDk+Pc=;
        b=NCnTYnwURfwnLce1Clv3d3riEC1JmRyqakTyGcC2yzoEZCOz2TKsIfWCruLv5FWXkF
         Nu8F2uHy1D6kKy9CGltiwqYfIu/JGytCDWTPe1D0zWFY94gRX+DWZKfd0B8ADlGRlMTV
         o3Qs0pl0hho1B/Jkj5JWQloKEoLyeMs5worUOyesyO2n3P86evGfzDkl5N4uwkF4cVdQ
         jnoYxutbDI2umTipKO/7y6lQ+OTcArj/U964vfOAIlQeACl9nygU0F/tAGE2gwn3Yz3R
         gXInVrdbZiP4v+gKHVRkDa0tsCS2TZ5dILKNXahMqvCEwQjQMZnt8fHS3twmE4mLRS1W
         oSpQ==
X-Gm-Message-State: APjAAAX8CRXZ0SX4p4T401biO5Z3LonT8UDkjdH3s/OWuAlnJfgSVYq2
        teyyTPibvB/B49YJmOUcnsCahUIIYiH8mq363bM=
X-Google-Smtp-Source: APXvYqyfOrUHbnkU98kQkt60f3TFC6BBB4lD5Yff/pIGG/upfr4Yn5+6q3+JWtiC5lDOiDs7eHTutvtsBwt2shwhvuA=
X-Received: by 2002:a9d:dc1:: with SMTP id 59mr21064913ots.250.1580309886519;
 Wed, 29 Jan 2020 06:58:06 -0800 (PST)
MIME-Version: 1.0
References: <20200129143757.680-1-gilad@benyossef.com> <20200129143757.680-4-gilad@benyossef.com>
In-Reply-To: <20200129143757.680-4-gilad@benyossef.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 29 Jan 2020 15:57:55 +0100
Message-ID: <CAMuHMdV0jPF_jWh_qhdNnazYunMpq-xZqG7AKj4m1oAMDp72WQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] crypto: ccree - fix some reported cipher block sizes
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Gilad,

On Wed, Jan 29, 2020 at 3:38 PM Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> OFB and CTR modes block sizes were wrongfully reported as
> the underlying block sizes. Fix it to 1 bytes as they
> turn the block ciphers into stream ciphers.
>
> Also document why our XTS differes from the generic
> implementation.
>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  drivers/crypto/ccree/cc_cipher.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
> index c08dee04941b..73457548ee92 100644
> --- a/drivers/crypto/ccree/cc_cipher.c
> +++ b/drivers/crypto/ccree/cc_cipher.c
> @@ -1236,6 +1236,10 @@ static const struct cc_alg_template skcipher_algs[] = {
>                 .sec_func = true,
>         },
>         {
> +               /* See https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg40576.html

You may want to refer to
https://lore.kernel.org/linux-crypto/20190910012134.GA24413@gondor.apana.org.au/
instead, as mail-archive is maintained externally.


> +                * for the reason why this differs from the generic
> +                * implementation.
> +                */
>                 .name = "xts(aes)",
>                 .driver_name = "xts-aes-ccree",
>                 .blocksize = 1,
> @@ -1431,7 +1435,7 @@ static const struct cc_alg_template skcipher_algs[] = {
>         {
>                 .name = "ofb(aes)",
>                 .driver_name = "ofb-aes-ccree",
> -               .blocksize = AES_BLOCK_SIZE,
> +               .blocksize = 1,
>                 .template_skcipher = {
>                         .setkey = cc_cipher_setkey,
>                         .encrypt = cc_cipher_encrypt,
> @@ -1584,7 +1588,7 @@ static const struct cc_alg_template skcipher_algs[] = {
>         {
>                 .name = "ctr(sm4)",
>                 .driver_name = "ctr-sm4-ccree",
> -               .blocksize = SM4_BLOCK_SIZE,
> +               .blocksize = 1,
>                 .template_skcipher = {
>                         .setkey = cc_cipher_setkey,
>                         .encrypt = cc_cipher_encrypt,
> --
> 2.25.0
>


--
Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
