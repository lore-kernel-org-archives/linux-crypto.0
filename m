Return-Path: <SRS0=4Nwj=Q2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8E4C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 12:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B86621738
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 12:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550577744;
	bh=vvgPUmPHLHFQpog5R2xIDB0Imy2VOr9vESE13puopzc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=rVtn18SUP9Xj61dzgjNd9ZKsh2AaWxWx2hS5FTcRZQhQua+jJ0NirB2WarfRFjgZb
	 OVp7qMwEufYNQ6pBxEtvlW+SjzcSPdwimxEH5oh7wBfVqcoPE7u0pK7Oz7jkB7b3tP
	 lXZqIE8eciHlLfzqMu01DRcnaqbYCs3rZQ8ivmnE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfBSMCX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Feb 2019 07:02:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbfBSMCX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Feb 2019 07:02:23 -0500
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39BEF21738;
        Tue, 19 Feb 2019 12:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550577742;
        bh=vvgPUmPHLHFQpog5R2xIDB0Imy2VOr9vESE13puopzc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=O5JB5PSxWhS6eJvCFTL5MKUNnWCFciIzdfvP3uX6MIbqEDvT71G21oV9lkJXPqxud
         OkWDzQ5Kn5Bl3WRiXDfAAXCP75x6o1RnXZ9gbfime6SwKnuzUTjmb5sT4TZ6eeFw4I
         Jat5BJMlYznIGcDWcTJKh3ZYNWM8NLwJlhQy005c=
Received: by mail-lj1-f182.google.com with SMTP id a17so862473ljd.4;
        Tue, 19 Feb 2019 04:02:22 -0800 (PST)
X-Gm-Message-State: AHQUAub+hho4tdlsU23P6lNdTaFqQcBy9tQOOjlefrse1J0Y3bpVk0L8
        J/itTlGjiOiLXPFc4gAazn461wK/NbuNtwjJ0ak=
X-Google-Smtp-Source: AHgI3IYd0e1+jStyck/D6aIKHh2WqOt//AaXpNXfH9BveSNQmBI6aT2uYGQoqmNEZpyB0nLDy4PXoO+GmO4YG5+xwUM=
X-Received: by 2002:a2e:4a19:: with SMTP id x25-v6mr14923974lja.19.1550577740347;
 Tue, 19 Feb 2019 04:02:20 -0800 (PST)
MIME-Version: 1.0
References: <CGME20190218160113eucas1p2183a3620f8322ee33273d3bfe5f06486@eucas1p2.samsung.com>
 <20190218160046.6387-1-k.konieczny@partner.samsung.com>
In-Reply-To: <20190218160046.6387-1-k.konieczny@partner.samsung.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Tue, 19 Feb 2019 13:02:08 +0100
X-Gmail-Original-Message-ID: <CAJKOXPcpdUtvnH45DPoK8vpDo_1ZkUU9y0RGg67S--8HSkoAXQ@mail.gmail.com>
Message-ID: <CAJKOXPcpdUtvnH45DPoK8vpDo_1ZkUU9y0RGg67S--8HSkoAXQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: s5p: update iv after AES op end
To:     Kamil Konieczny <k.konieczny@partner.samsung.com>
Cc:     Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 18 Feb 2019 at 17:01, Kamil Konieczny
<k.konieczny@partner.samsung.com> wrote:
>
> Fix bug "s5p-sss crypto driver doesn't set next AES-CBC IV". This should
> also fix AES-CTR mode. Tested on Odroid U3 with Eric Biggers branch
> "iv-out-testing".
>
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> ---
>  drivers/crypto/s5p-sss.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 0064be0e3941..3ea058addad3 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -463,6 +463,9 @@ static void s5p_sg_copy_buf(void *buf, struct scatterlist *sg,
>
>  static void s5p_sg_done(struct s5p_aes_dev *dev)
>  {
> +       struct ablkcipher_request *req = dev->req;
> +       struct s5p_aes_reqctx *reqctx = ablkcipher_request_ctx(req);
> +
>         if (dev->sg_dst_cpy) {
>                 dev_dbg(dev->dev,
>                         "Copying %d bytes of output data back to original place\n",
> @@ -472,6 +475,11 @@ static void s5p_sg_done(struct s5p_aes_dev *dev)
>         }
>         s5p_free_sg_cpy(dev, &dev->sg_src_cpy);
>         s5p_free_sg_cpy(dev, &dev->sg_dst_cpy);
> +       if (reqctx->mode & FLAGS_AES_CBC)
> +               memcpy_fromio(req->info, dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), 0x10);
> +

0x10 -> AES_BLOCK_SIZE

> +       if (reqctx->mode & FLAGS_AES_CTR)

if -> else if

Beside that looks good.

Best regards,
Krzysztof
