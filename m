Return-Path: <SRS0=IEBh=S6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 231FBC43218
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Apr 2019 07:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1A4F20881
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Apr 2019 07:59:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="duA59wo5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfD1H64 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Apr 2019 03:58:56 -0400
Received: from mail-vk1-f194.google.com ([209.85.221.194]:44994 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbfD1H6z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Apr 2019 03:58:55 -0400
Received: by mail-vk1-f194.google.com with SMTP id q189so1658059vkq.11
        for <linux-crypto@vger.kernel.org>; Sun, 28 Apr 2019 00:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yadCq+3TFtjJOWElejuaUSgw6RJEnKLjvwR5ZDLWJ3E=;
        b=duA59wo5lnfQDeEFZYdACgMLLfO4I0sGb/82yCn57UdR51AXVJ92nw62UKMYtLIG2H
         6BS7UYy+R3DUo6YMZjIYB/63h6Bpxpf8Nf7LIZkdDfOxgjdNCl1R0RQYsrQZq39FRz9S
         w//4imMTO+iySHATUxg/goM4kz7hfmQJ2qqBH6H4z1AWYDu2j2bPSn6Zz2VQuNY297EB
         D17csPJuiy9WUmRFf504gmFclTW1Rd6AGj7JaN5lqYoWktnE68pFCIlOzrKaqGXDAC/2
         otD1OtkJoGiVGvWyNtshbRwUh30W8gLXEP6hj06SZpJ0Sv742Sr85e9GItedNOIP/6vC
         dzOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yadCq+3TFtjJOWElejuaUSgw6RJEnKLjvwR5ZDLWJ3E=;
        b=kLpUfWIp4dytjA4V2Ac08LwI4lH+DMGEStqVVx6KvZ/xPvbc3+cVvoC1egUhlOouBw
         nfiG9WgsFKzsWhLdwxDAZu3U9PZ/l5pELs8cz2jyh+0vp+dM2q7Ss/RY6h0UwUdK2bUf
         vrxKWzymxpoZTCRgFYVHYPsSEkJk2djcFWdVNLZKJSMeoL0alzspj9sQzagBQudsn5uh
         QKgaKRpxxgbL2MvD7vz/ZpwL53lkQd7oCpWOgd4rICQAOQFxxjczhdLPjwoCavZoulkS
         IBgG60OaA1pYisO2ze3K80BUe861D8dEVF4MOxkE+01AfC5JgHPFyW+oakx4TP3BHKi1
         VOiQ==
X-Gm-Message-State: APjAAAWyld7uPNHn8H2dkWAMnJ6uqP0heIf1NV4x7uYjkm6Yq04Y6BHQ
        kPdtyL7KuDRNRo3DEJniSjS+t4TqSS9RuONYhz+xlw==
X-Google-Smtp-Source: APXvYqzM2mHelZQDg7170xe9MHOKTlaQJCD7sNFNKFFEDLeAMsHhLXzzRDz8+QnUqQMimwbro3CZlYdg3pFwR+I/tGA=
X-Received: by 2002:a1f:97ce:: with SMTP id z197mr29161293vkd.58.1556438334562;
 Sun, 28 Apr 2019 00:58:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190426151821.36944-1-yuehaibing@huawei.com>
In-Reply-To: <20190426151821.36944-1-yuehaibing@huawei.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sun, 28 Apr 2019 10:58:43 +0300
Message-ID: <CAOtvUMesBDrnMd=d5S50xj0W2PyYbb9E9SeYvaev4Dw7Uu_tHg@mail.gmail.com>
Subject: Re: [PATCH -next] crypto: ccree - remove set but not used variable 'du_size'
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 26, 2019 at 7:38 PM Yue Haibing <yuehaibing@huawei.com> wrote:
>
> From: YueHaibing <yuehaibing@huawei.com>
>
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/crypto/ccree/cc_cipher.c: In function cc_setup_key_desc:
> drivers/crypto/ccree/cc_cipher.c:645:15: warning: variable du_size set bu=
t not used [-Wunused-but-set-variable]
>
> It is never used since introduction in
> commit dd8486c75085 ("crypto: ccree - move key load desc. before flow des=
c.")
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/crypto/ccree/cc_cipher.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_c=
ipher.c
> index d9f8cd5..6bd3791 100644
> --- a/drivers/crypto/ccree/cc_cipher.c
> +++ b/drivers/crypto/ccree/cc_cipher.c
> @@ -642,16 +642,12 @@ static void cc_setup_key_desc(struct crypto_tfm *tf=
m,
>         int direction =3D req_ctx->gen_ctx.op_type;
>         dma_addr_t key_dma_addr =3D ctx_p->user.key_dma_addr;
>         unsigned int key_len =3D ctx_p->keylen;
> -       unsigned int du_size =3D nbytes;
>         unsigned int din_size;
>
>         struct cc_crypto_alg *cc_alg =3D
>                 container_of(tfm->__crt_alg, struct cc_crypto_alg,
>                              skcipher_alg.base);
>
> -       if (cc_alg->data_unit)
> -               du_size =3D cc_alg->data_unit;

Thanks!
This is a good catch. It seems we can also drop the whole cc_alg var
as well in this case,
since it is only used by the code setting du_size....

Do you want to send a patch doing both or shall I ?

Cheers,
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
