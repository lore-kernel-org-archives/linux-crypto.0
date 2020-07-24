Return-Path: <SRS0=MR99=BD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2539C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jul 2020 13:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCE8D206C1
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jul 2020 13:24:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PioAJypK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgGXNYV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Jul 2020 09:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgGXNYU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Jul 2020 09:24:20 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490E8C0619D3
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2020 06:24:20 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id k13so5203876lfo.0
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2020 06:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vrNd1IsGR4tP8PBdHAFs3AhICen6bv/rNf6zgNWwFI4=;
        b=PioAJypK5ctFm6Xpj+L40YBoTd0JCG/mujuTgjgFt5XPDhLDMYIHuNZ1Gru3Xl1cPw
         7QsYFW1PVV5ED1ho4LpWE8uqv8Z1+5PChli2H7RVUs0JgrT8x7uwT4Lq0A3FdXAmcj44
         +bUSSrcbH3I9fbldqLNr+s4TKMTp2PmVV8Jrmqzxhd2A7paYkowMApdmShipQCBDSvzh
         yb0grHRbq8Nu7Q1KGGdJcrjfFpv6kx3Iw/gU5VAeYZCfsHjzBHM2vKM3zjVchhsFf+U3
         3AOEgFQm4R6pgWiA8g7HC+rAurTwKgrRSxTtx0XunZCr3Y7toQi+k84kbOIoajdoL302
         C/zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vrNd1IsGR4tP8PBdHAFs3AhICen6bv/rNf6zgNWwFI4=;
        b=b55/0Tj52nirARDYipJa40MPcIq8deDOie+5Pm58DokLGPTm20bjA+Ce8QqIuY9Dw0
         4E0KoFAPPT5AP66olvtDeISOSUCsKTiFf1Bqe/GMUurISIAO9aWzdAiJa5YaL/onCylv
         cTCqn0yGBdxnPOBYKDusODwsM8hRDIyTM17O/EyRqHBOKtr1OoQtjYMWXGx/FPtOq3Sh
         6c5LkgsrLAmfLplOPYYdtOOkHgQv/oObgahAM+Ua+rba576Vqk9iqp1BxKMSq+VKECu3
         8I9tb+otVWnq8GfV4VSkaWEmpAVx7CWDhF6hngS+h0WHkVDompJ0sCFjwzEGMQ6YSt/X
         V4Cg==
X-Gm-Message-State: AOAM532x1pF+Zkt+QFi9faDThwaMb8rIFoK8cLRjBV/ZLFK6F41th5LJ
        Zdmr+y5t9zh4bo0VSYUh6O5gkp8ohX8bfQq/ayZHPw==
X-Google-Smtp-Source: ABdhPJzQ+DJRA0iFuI99YTbcfAz/FjMxLPDD4nS06PTBDi9IeLSDtUNouRu4oWlAKHjrLeLOfNOoXu4MPSQg8iNP4Jk=
X-Received: by 2002:ac2:4d16:: with SMTP id r22mr4986311lfi.21.1595597058699;
 Fri, 24 Jul 2020 06:24:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200723084622.31134-1-jorge@foundries.io>
In-Reply-To: <20200723084622.31134-1-jorge@foundries.io>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Fri, 24 Jul 2020 18:54:07 +0530
Message-ID: <CAFA6WYMCs-50WnwqqhefE9b_aXaORq1e3JdZJAjb04tHKvqP0A@mail.gmail.com>
Subject: Re: [PATCHv2 1/2] hwrng: optee: handle unlimited data rates
To:     Jorge Ramirez-Ortiz <jorge@foundries.io>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, ricardo@foundries.io,
        Michael Scott <mike@foundries.io>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        op-tee@lists.trustedfirmware.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 23 Jul 2020 at 14:16, Jorge Ramirez-Ortiz <jorge@foundries.io> wrote:
>
> Data rates of MAX_UINT32 will schedule an unnecessary one jiffy
> timeout on the call to msleep. Avoid this scenario by using 0 as the
> unlimited data rate.
>
> Signed-off-by: Jorge Ramirez-Ortiz <jorge@foundries.io>
> ---
>  drivers/char/hw_random/optee-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Sounds good to me. FWIW:

Reviewed-by: Sumit Garg <sumit.garg@linaro.org>

-Sumit

> diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
> index 49b2e02537dd..5bc4700c4dae 100644
> --- a/drivers/char/hw_random/optee-rng.c
> +++ b/drivers/char/hw_random/optee-rng.c
> @@ -128,7 +128,7 @@ static int optee_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
>                 data += rng_size;
>                 read += rng_size;
>
> -               if (wait) {
> +               if (wait && pvt_data->data_rate) {
>                         if (timeout-- == 0)
>                                 return read;
>                         msleep((1000 * (max - read)) / pvt_data->data_rate);
> --
> 2.17.1
>
