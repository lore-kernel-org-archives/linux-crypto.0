Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19CA3C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Feb 2022 19:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245287AbiBQThB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:37:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245272AbiBQThA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Feb 2022 14:37:00 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9193AA69
        for <linux-crypto@vger.kernel.org>; Thu, 17 Feb 2022 11:36:44 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id v63so15101115ybv.10
        for <linux-crypto@vger.kernel.org>; Thu, 17 Feb 2022 11:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ooI0JvtrMm1EWIWCxV5c2URZAUO8zQ/vmYnuAIZ6onk=;
        b=0CkOigzXtlWg/1yHf8eOrlWj0Xdu1g8OuW163v1hOABclEWhibv031qIzaTelNnNIg
         2wpxiy0ITL4/mJC/f9kVy5f06oL126Y5ZM3gz/uxrtFuAF38bc8dk0d/tK+/hrR24NvS
         wsVZTQxsYiryHo/62FkJZSG1ey81c9lTuYW5TlJKUWKnjuPzEhokxgcxnsVzWs2O05SB
         n0lGBLVhhRm436CbhvG08k1DRK2cImBthP0MZa7noZwCDv7jSUAcjnBzr9qFXC53vd6M
         0bPlJQrv3+/5XgdroFmEoJkPEKuVgnWkCMXgdpfg6YGSacLaffEqUQiCIsnVIYDcVTW/
         XvZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ooI0JvtrMm1EWIWCxV5c2URZAUO8zQ/vmYnuAIZ6onk=;
        b=7Ej4kj64zyyMzu2ZzjzG8GjM5bEaRJ/6IBW7L1P1KTDFe2Tnszpy/GngF1xtTMSWg0
         iywizstS+sDdJV++tvzOaDjw/YE4y8TeOmdVdGFBLqEVC5++AXnFG19NLmj91/ussBBl
         IgvpMOZt2qcIYc/aPeVVI1HyefE+8kBaO1X2oZKBd+HAWx6EJfoFGBzYIpZguKXAwjCz
         XWHtAvNnCPAIOfpbHbA5N2zVgzKX7f6vL4KnOc3adz9h2ecDKMmypLDy1BD4UOf834IL
         evpQa4sDGbq+BcNCOwUeMPtnq76wsY4BufZvEx6V+LBEgN08rbkJYaRET2kYxBWro1lu
         AtYw==
X-Gm-Message-State: AOAM531v0RQtZzbVbhRa9Q4dXIvjD2Dq8IhhYMOV7RsSNopgWhHVr6oj
        5xO1s8WHVilGFAVIq/g00Jf2Zi7p+DQ2SpW5/sOJ2w==
X-Google-Smtp-Source: ABdhPJx+lOiB7Ua1wUV60YpmjG9bncDOD5Dbx4/P3hF0MmWKaNdLPF+e2h1dcV/bdqGjVjy/l+yWLR7pVLn3hsOyrUA=
X-Received: by 2002:a05:6902:284:b0:624:1c25:cda1 with SMTP id
 v4-20020a056902028400b006241c25cda1mr3670848ybh.480.1645126603948; Thu, 17
 Feb 2022 11:36:43 -0800 (PST)
MIME-Version: 1.0
References: <20220209070608.985213-1-clabbe@baylibre.com>
In-Reply-To: <20220209070608.985213-1-clabbe@baylibre.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Thu, 17 Feb 2022 21:36:41 +0200
Message-ID: <CAOtvUMfhgJBNhDfotkxW0wMyJK-3y4-QGTCKFxG+8oc3EQDKAg@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccree: fix xts-aes-ccree blocksize
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Again,

Thank you for taking the time to look into this!

However, this is an old topic that has been discussed before and the
answer really is that the selftests are wrong. They are looking at the
wrong thing. Yes, I know...

See the discussion here:
https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg40576.html

I also also point out this is actually documented in the code:

+               /* See
https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg40576.html
+                * for the reason why this differs from the generic
+                * implementation.
+                */

Thanks again!
Gilad


On Wed, Feb 9, 2022 at 9:06 AM Corentin Labbe <clabbe@baylibre.com> wrote:
>
> loading ccree on next-20220207 with CRYPTO_MANAGER_EXTRA_TESTS show a war=
ning:
> alg: skcipher: blocksize for xts-aes-ccree (1) doesn't match generic impl=
 (16)
> alg: self-tests for xts-aes-ccree (xts(aes)) failed (rc=3D-22)
>
> After setting the correct blocksize, selftests pass.
>
> Fixes: 67caef08a71f ("crypto: ccree - enable CTS support in AES-XTS")
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  drivers/crypto/ccree/cc_cipher.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_c=
ipher.c
> index 78833491f534..d955fe15cf40 100644
> --- a/drivers/crypto/ccree/cc_cipher.c
> +++ b/drivers/crypto/ccree/cc_cipher.c
> @@ -1010,7 +1010,7 @@ static const struct cc_alg_template skcipher_algs[]=
 =3D {
>         {
>                 .name =3D "xts(paes)",
>                 .driver_name =3D "xts-paes-ccree",
> -               .blocksize =3D 1,
> +               .blocksize =3D XTS_BLOCK_SIZE,
>                 .template_skcipher =3D {
>                         .setkey =3D cc_cipher_sethkey,
>                         .encrypt =3D cc_cipher_encrypt,
> @@ -1140,7 +1140,7 @@ static const struct cc_alg_template skcipher_algs[]=
 =3D {
>                  */
>                 .name =3D "xts(aes)",
>                 .driver_name =3D "xts-aes-ccree",
> -               .blocksize =3D 1,
> +               .blocksize =3D XTS_BLOCK_SIZE,
>                 .template_skcipher =3D {
>                         .setkey =3D cc_cipher_setkey,
>                         .encrypt =3D cc_cipher_encrypt,
> --
> 2.34.1
>


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
