Return-Path: <SRS0=2cET=YT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0232BCA9EB9
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 07:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0D6D21655
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 07:32:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EVZyemV8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfJZHca (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 26 Oct 2019 03:32:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36036 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfJZHca (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Oct 2019 03:32:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id w18so4741693wrt.3
        for <linux-crypto@vger.kernel.org>; Sat, 26 Oct 2019 00:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dtyBaARQzyWYqzK+keiEY0eULHl/XmtLTqCIKdR+ZNo=;
        b=EVZyemV8ZX09sKSvdOvQGp87E/TzTsA0jljxX1tfZfX/S3gMixnGz/iw1S2c/37oKE
         FYZOtd2B18msQDsGlQQdtwvJsS9wNAIA8lm0xsjpaIwgZmK6eJGFwFszkQiYpaAIb3yc
         Z/tAeNPo1BKt2NisgitYpZPD2VMSu6vW2bl6dDU0z9NgJB5Hd5TuITQbyZCoXl6qq2Rh
         o3YOT5ixZ5q2Mv6f91+/yZuJP+UbWNyc87FLwqStv6cneobi0XHaOnNbzsaB0MUJRfY7
         6QrL1j1WHxfJJJfQ+meefiJxuRu4qi1M3y+5gksJJ96fMlvAvwmv5X6L794iKeRs6p8H
         tgMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dtyBaARQzyWYqzK+keiEY0eULHl/XmtLTqCIKdR+ZNo=;
        b=sLiNKni6UpNmp9/x9xqL7zneb1Q7149GliOhXtCss6pi5oWCx5qAyQs9HwqieIHSXU
         f1zmhGR8pumVirnmMk0qz8uHyYMGk3eX5odDxSytkycnKe3XBpQaL5GK98INZPmoPdyg
         f916OSGKx1t7xvHnoT3C4tVHa24lmnxQmi/NVmX98KUJuTXASA5/asKqTq7VIkw7KIzq
         J5ztrqA0rUXom1Vl+Q40EiyCejSWomFqcL4wuXN4694Cx1T4M4hBc3Oi+gt6p4GvFyQM
         Km8VDcVgD+6jIYIDI5r8Kk8BZfPG5kKaiRJ56hoLkdgU1OYloW9y0PmP/ktTDbWG1L5x
         2XPQ==
X-Gm-Message-State: APjAAAXFTJbEepc69RaLG56lOhFGiBqD0Wdg1/nAJ9OLEcs+dguW2cQ2
        Oj4vH7AIqUnf6wyH5Im2VpCaRKtUN+HF1Z815y2JBw==
X-Google-Smtp-Source: APXvYqwWjstPDryCV7cq44BJWdXg73GM0oJSuDN023jDtKy9ycMOpWH169d3Z0fgPUgadEqP90DzUGee1DsfhGb7zn8=
X-Received: by 2002:adf:f685:: with SMTP id v5mr6658668wrp.246.1572075147381;
 Sat, 26 Oct 2019 00:32:27 -0700 (PDT)
MIME-Version: 1.0
References: <1572058641-173376-1-git-send-email-wangzhou1@hisilicon.com>
In-Reply-To: <1572058641-173376-1-git-send-email-wangzhou1@hisilicon.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 26 Oct 2019 09:32:25 +0200
Message-ID: <CAKv+Gu8VC0S8JXbojyQpvQOdq9EL4b5kRJfE1xkZYXW0ody4dQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: hisilicon - use sgl API to get sgl dma addr and len
To:     Zhou Wang <wangzhou1@hisilicon.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 26 Oct 2019 at 05:01, Zhou Wang <wangzhou1@hisilicon.com> wrote:
>
> Use sgl API to get sgl dma addr and len, this will help to avoid compile
> error in some platforms. So NEED_SG_DMA_LENGTH can be removed here, which
> can only be selected by arch code.
>
> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/crypto/hisilicon/Kconfig | 1 -
>  drivers/crypto/hisilicon/sgl.c   | 4 ++--
>  2 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
> index a71f2bf..82fb810d 100644
> --- a/drivers/crypto/hisilicon/Kconfig
> +++ b/drivers/crypto/hisilicon/Kconfig
> @@ -18,7 +18,6 @@ config CRYPTO_DEV_HISI_QM
>         tristate
>         depends on ARM64 || COMPILE_TEST
>         depends on PCI && PCI_MSI
> -       select NEED_SG_DMA_LENGTH
>         help
>           HiSilicon accelerator engines use a common queue management
>           interface. Specific engine driver may use this module.
> diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
> index bf72603..012023c 100644
> --- a/drivers/crypto/hisilicon/sgl.c
> +++ b/drivers/crypto/hisilicon/sgl.c
> @@ -164,8 +164,8 @@ static struct hisi_acc_hw_sgl *acc_get_sgl(struct hisi_acc_sgl_pool *pool,
>  static void sg_map_to_hw_sg(struct scatterlist *sgl,
>                             struct acc_hw_sge *hw_sge)
>  {
> -       hw_sge->buf = sgl->dma_address;
> -       hw_sge->len = cpu_to_le32(sgl->dma_length);
> +       hw_sge->buf = sg_dma_address(sgl);
> +       hw_sge->len = cpu_to_le32(sg_dma_len(sgl));
>  }
>
>  static void inc_hw_sgl_sge(struct hisi_acc_hw_sgl *hw_sgl)
> --
> 2.8.1
>
