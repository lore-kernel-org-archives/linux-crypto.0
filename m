Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A20EC35280
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 10:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6349121920
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 10:00:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="e5cqkXTy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfJBKAi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 06:00:38 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:44185 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfJBKAi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 06:00:38 -0400
Received: by mail-vs1-f65.google.com with SMTP id w195so11478194vsw.11
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2019 03:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UXFe3Cdoh6neghhn+MaZ0YaGkgSW9dDmYFd/u2oSM9o=;
        b=e5cqkXTyMS2bK7Z38fZlO5AIT94/EzGYk5po2nVuHCrMMSJIGppW440+lxjrj/+9fD
         8eSwhvtZGr11SEcSiR9LqIEGzIZ1EQoPfve0QDZnkELNphBIeMgHkh4qU7gZDu49WhOU
         TIgWLufpoIl1OJDIVSg9NcwMN4Xqvo4cFVzYQ1Y71rsxATvUfQyLr9xJTQHeNA0ipZzo
         e1WCi0zG925kcQkSMrh+5mZFtLWQys/GspiMztPfUpnmi0Y6AWiR7uVbTT2ZLSdHcxu6
         DbixfGa8X/fuAIFDeUWb6d+yvzttJEfjMTfFs09gEFAHT1MZhACiTiZs7wruwgs74LbX
         RfUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UXFe3Cdoh6neghhn+MaZ0YaGkgSW9dDmYFd/u2oSM9o=;
        b=U0H0YnyUDDfzvKqfUhI9GkE4/ZYDBmZnYi20ltx6MViB9vj1pkXN4D+imLf6cNoyn3
         VSJYAtazjmAzhtlUu4dhRuX4q7EYzMsKEE52bVA2I+8vOj6ST0yQbZdAbi+2ZkBohgBP
         2LN/Pivjf+tu5c3CCk4aSLfwvzbqKiN6p3W/XWcUWzVJweTLcffW4VfOkGV+BoDbq+Df
         cZYtjJV/jGSqRdwIP++5wxdEETxv7yIccj5sElOqqMFSRSri+2GzLDOTDooZFJ1c7AWv
         xXeBmHAgxffqzZbomgh98uNKk0g76sKiuTblujKXmUmqLDfDFbW9fAwSUrPIN1YIbHfE
         NWpA==
X-Gm-Message-State: APjAAAUdnbO8MJJlCuJuF2j5wYu84oTuy+YbdK4iXjrwbjE3oZoUQWja
        nzbBbDImOAvA+JkDgjhgyAxJQhNdZ2zpSrDRZRAPdw==
X-Google-Smtp-Source: APXvYqzLtMqctpYwkcfc3sdrr4U4ddc1UveGmWlfq73zD8l4MTK0fZYXzzGqh1hncQckaKUqqOuenxL6Tw7mBPUvmK0=
X-Received: by 2002:a67:ef5d:: with SMTP id k29mr1247634vsr.11.1570010437288;
 Wed, 02 Oct 2019 03:00:37 -0700 (PDT)
MIME-Version: 1.0
References: <1569833361-47224-1-git-send-email-tiantao6@huawei.com>
In-Reply-To: <1569833361-47224-1-git-send-email-tiantao6@huawei.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Wed, 2 Oct 2019 13:00:25 +0300
Message-ID: <CAOtvUMeaRp08Go7BqdPzOaTFQKLOUTXMZfUE5pTpUNk3vM649A@mail.gmail.com>
Subject: Re: [PATCH] crypto: fix comparison of unsigned expression warnings
To:     Tian Tao <tiantao6@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,


On Mon, Sep 30, 2019 at 11:52 AM Tian Tao <tiantao6@huawei.com> wrote:
>
> This patch fixes the following warnings:
> drivers/crypto/ccree/cc_aead.c:630:5-12: WARNING: Unsigned expression
> compared with zero: seq_len > 0
>

Thanks for the report!

Can you please share which compiler/arch/config you use that produces
this warning?

I'm not seeing it on my end.

Many thanks,
Gilad

> Signed-off-by: Tian Tao <tiantao6@huawei.com>
> ---
>  drivers/crypto/ccree/cc_aead.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aea=
d.c
> index d3e8faa..b19291d 100644
> --- a/drivers/crypto/ccree/cc_aead.c
> +++ b/drivers/crypto/ccree/cc_aead.c
> @@ -546,7 +546,7 @@ static int cc_aead_setkey(struct crypto_aead *tfm, co=
nst u8 *key,
>         struct cc_aead_ctx *ctx =3D crypto_aead_ctx(tfm);
>         struct cc_crypto_req cc_req =3D {};
>         struct cc_hw_desc desc[MAX_AEAD_SETKEY_SEQ];
> -       unsigned int seq_len =3D 0;
> +       int seq_len =3D 0;
>         struct device *dev =3D drvdata_to_dev(ctx->drvdata);
>         const u8 *enckey, *authkey;
>         int rc;
> --
> 2.7.4
>


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
