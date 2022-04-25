Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FB1C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Apr 2022 05:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241278AbiDYFzo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Apr 2022 01:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbiDYFzl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Apr 2022 01:55:41 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD09A3631C
        for <linux-crypto@vger.kernel.org>; Sun, 24 Apr 2022 22:52:34 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id s14so24605311plk.8
        for <linux-crypto@vger.kernel.org>; Sun, 24 Apr 2022 22:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I8PWt7OjbJmxLANi6mNzNMu0WXmhqmQPufvVnsJYKmw=;
        b=RN+YWN/6ZEosVdavFx6I+1osrVBC6v3XRA/fIXRE0bY2SOhSo+1/4Wqfie+Hs44EOi
         hTNboelvwlwPk379FYh10R/YISw23eV3zPOfAuuAZDdKVh05n6aEiv+Y1uf81gHDNEj4
         OvdOUiAnM4PnFQHQDidUvwNGOAJ8zYHXn2cZlK0qsqgBOlMDOdzYEHdNoDr4UDed78rq
         QofJYCCDnCmbBK5vX+WWyhb8qoFmhqquCmPYp89NgTY35yQJ9DCDaFB0IxH/vstbfjmf
         QmytdENTfQFln9XSaOKk0VH55nJgtEA7SKH4I3CuLblBxs1MiT0N26oHoebuSZcKGGCI
         ACNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I8PWt7OjbJmxLANi6mNzNMu0WXmhqmQPufvVnsJYKmw=;
        b=068kiEGVtqx1k+xCto07YBiNtZ6fZyThrpWDU4gZDzN8I7QwsgIJzjxmhTHDb8wTA/
         Vu4NF4MDYGFcNA3Qus/jvF8q3sdSdlIm/xEdAknM24wGgN7TxSKubRrpXv3vtneT+wBa
         9ED0qA9c1x02852uAAl8VbLRGn1bk+vGMpjyJIpCdhHlsn2/y6ZwpSQGK/eRuLJXRavZ
         ijaCYPEkiyeAe6d+k00QOQMtmZbVvxgxR2r7ABCLjn7xtdPEd5r1uaw/wEWGLa8l/LBv
         wHzkuWXefxbfKEXOXlIw71HyVicFJBaFyEWP7MyZkdutc6d4/ZUPrNV4oxxvLvRMIOXX
         7CPQ==
X-Gm-Message-State: AOAM5338iTq4gfWJE1E5GjNNeKgPdw+yKHnXEcetuHEs3HouRAEsoA/1
        RNn7KhM+sQ22u3516zfH9OV0nnIlZAkdKq+jOxSF9Q==
X-Google-Smtp-Source: ABdhPJwHuUIcwQrmSB5z5lvcykuJgyvBocbIF4etjzQWiYbhgjI8gV8ciq759eDd9ud0j1ZfooBpy+vVS4zuhMC83WY=
X-Received: by 2002:a17:902:9f96:b0:15d:1ee7:4231 with SMTP id
 g22-20020a1709029f9600b0015d1ee74231mr1335076plq.131.1650865953665; Sun, 24
 Apr 2022 22:52:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220424181156.1364446-1-colin.i.king@gmail.com>
In-Reply-To: <20220424181156.1364446-1-colin.i.king@gmail.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Mon, 25 Apr 2022 11:22:19 +0530
Message-ID: <CAFA6WYMeOv160_mnEHVN9GgN1tqN9Zt0GqnGQRgP4m8V-aztTQ@mail.gmail.com>
Subject: Re: [PATCH] hwrng: optee-rng: remove redundant initialization to
 variable rng_size
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        op-tee@lists.trustedfirmware.org, linux-crypto@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 24 Apr 2022 at 23:41, Colin Ian King <colin.i.king@gmail.com> wrote:
>
> Variable rng_size is being initialized with a value that is never read,
> the variable is being re-assigned later on. The initialization is
> redundant and can be removed.
>
> Cleans up cppcheck warning:
> Variable 'rng_size' is assigned a value that is never used.
>
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/char/hw_random/optee-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Reviewed-by: Sumit Garg <sumit.garg@linaro.org>

-Sumit

> diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
> index a948c0727b2b..96b5d546d136 100644
> --- a/drivers/char/hw_random/optee-rng.c
> +++ b/drivers/char/hw_random/optee-rng.c
> @@ -115,7 +115,7 @@ static size_t get_optee_rng_data(struct optee_rng_private *pvt_data,
>  static int optee_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
>  {
>         struct optee_rng_private *pvt_data = to_optee_rng_private(rng);
> -       size_t read = 0, rng_size = 0;
> +       size_t read = 0, rng_size;
>         int timeout = 1;
>         u8 *data = buf;
>
> --
> 2.35.1
>
