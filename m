Return-Path: <SRS0=gV+R=BS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42AE7C433DF
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Aug 2020 12:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D1BB20759
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Aug 2020 12:11:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="a27s0HjD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgHHMLN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 Aug 2020 08:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgHHMKx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Aug 2020 08:10:53 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26136C061A27
        for <linux-crypto@vger.kernel.org>; Sat,  8 Aug 2020 05:10:52 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g33so2386545pgb.4
        for <linux-crypto@vger.kernel.org>; Sat, 08 Aug 2020 05:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EuDMSmp04hSHSVLRHL1PUWBPuYB4U3JnGDB9t2qv6ho=;
        b=a27s0HjDAgd0N2W+2hyaEb/r9U8rPWgKPcToKVqzsY6g1RHey3lP/n73NLKJYe/Ok9
         55O55oJSSu9auuHd0IZZMeayaFYrB0XkDdzao+sYMQoIml9w00hFjBH8r/pwdPpew/sz
         D4U3ycTuRW2hhSyGQ/+vQPPBrkxE9ZKOeqrJhg7L0PM3vPL7tG3pJcxpNVs3aBK4ByJe
         KCqGQqzLjn/hShsU0zUkoh4exC0lP0KHzK4vtrIfJ3N9ohkhYUxOT1oj/NDw/OG3J1d+
         9y8hysX2pQorUHhg24RtZ6E+WgR2WN28nXtkQnzysvPpbbsZGt1ljbQWW59Kk3ViJl54
         tcqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EuDMSmp04hSHSVLRHL1PUWBPuYB4U3JnGDB9t2qv6ho=;
        b=nx5I/dfRAX7hYi26E1p/o+jOTlVx5aVzZuqOjng72x2Sekpp6/4H1WBOhTftnZuoOa
         GkjAzEfnLh7L7s44n0QZ03K539hJoe7DEbht+5BJdaJ5oqDuQ7MU3R4TRi88em6XhzZJ
         d7YH92R09aPlDTOQWWHvGEsgdMN4b01w7pvVUJYWr6RekDGLjvqGJ2I9PaeqWHLhpLGW
         9BDG8jcTOzUHtd53ogVNjD0qHxcI+3pqppIa/egSqAdbK9Kxm7QMasV3OujV4XakxblO
         ASU6osoiB9RFSskx/k9yNJ1/MpVR1je1+bbfE4uCIgB+Z8kIkrD0NanPY7paSdpu/7FQ
         WFiw==
X-Gm-Message-State: AOAM531IUA31ZNc4gZy44LThKax4NGJbzRXgdyOWyxcg6n6oVoChJZML
        rNORjiEWJpYV+y80kCgWEMxg3Q0S9vymbpiQxdAaCw==
X-Google-Smtp-Source: ABdhPJzM1muWFLwLDSvo0MoNAYjZ2t7+UNajWvXxXMkjymrpkaeIPbZuHepCLbtxZZBVSatO1nbVYIIZ+/IHe775HYM=
X-Received: by 2002:a63:4b44:: with SMTP id k4mr15861573pgl.305.1596888644708;
 Sat, 08 Aug 2020 05:10:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200807162010.18979-1-andrei.botila@oss.nxp.com> <20200807162010.18979-17-andrei.botila@oss.nxp.com>
In-Reply-To: <20200807162010.18979-17-andrei.botila@oss.nxp.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Sat, 8 Aug 2020 15:10:33 +0300
Message-ID: <CAOtvUMero-gF5ZE1unnD_wcDnzZX_SL0tQ2yJNqzc3rg5RhuDA@mail.gmail.com>
Subject: Re: [PATCH 16/22] crypto: ccree - add check for xts input length
 equal to zero
To:     Andrei Botila <andrei.botila@oss.nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@axis.com, Andrei Botila <andrei.botila@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 7, 2020 at 7:22 PM Andrei Botila <andrei.botila@oss.nxp.com> wr=
ote:
>
> From: Andrei Botila <andrei.botila@nxp.com>
>
> Standardize the way input lengths equal to 0 are handled in all skcipher
> algorithms. All the algorithms return 0 for input lengths equal to zero.
> This change has implications not only for xts(aes) but also for cts(cbc(a=
es))
> and cts(cbc(paes)).
>
> Cc: Gilad Ben-Yossef <gilad@benyossef.com>
> Signed-off-by: Andrei Botila <andrei.botila@nxp.com>
> ---
>  drivers/crypto/ccree/cc_cipher.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_c=
ipher.c
> index 076669dc1035..112bb8b4dce6 100644
> --- a/drivers/crypto/ccree/cc_cipher.c
> +++ b/drivers/crypto/ccree/cc_cipher.c
> @@ -912,17 +912,18 @@ static int cc_cipher_process(struct skcipher_reques=
t *req,
>
>         /* STAT_PHASE_0: Init and sanity checks */
>
> -       if (validate_data_size(ctx_p, nbytes)) {
> -               dev_dbg(dev, "Unsupported data size %d.\n", nbytes);
> -               rc =3D -EINVAL;
> -               goto exit_process;
> -       }
>         if (nbytes =3D=3D 0) {
>                 /* No data to process is valid */
>                 rc =3D 0;
>                 goto exit_process;
>         }
>
> +       if (validate_data_size(ctx_p, nbytes)) {
> +               dev_dbg(dev, "Unsupported data size %d.\n", nbytes);
> +               rc =3D -EINVAL;
> +               goto exit_process;
> +       }
> +
>         if (ctx_p->fallback_on) {
>                 struct skcipher_request *subreq =3D skcipher_request_ctx(=
req);
>
> --
> 2.17.1
>

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks,
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
