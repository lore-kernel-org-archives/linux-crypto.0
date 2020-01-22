Return-Path: <SRS0=EdI7=3L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6FCC33CAF
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 09:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 695292465A
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 09:53:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zDMOYEs9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbgAVJef (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 04:34:35 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:42101 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730923AbgAVJee (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 04:34:34 -0500
Received: by mail-oi1-f194.google.com with SMTP id 18so5457030oin.9
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jan 2020 01:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ynAECvucuhMvbP8cwS6QYymonzK/uMzxWqNsu6RxVOQ=;
        b=zDMOYEs9suLo1wloXAuvTs9YuKNSsBp5Hh/My3IXvDI6pIh0N2z5UqrziYJxv+bYpB
         l50xJH65RISb7s2LXKuIi/E7S9p056wetT4ckJ4EMLpqz4XK9oULN60ECDbtiqxoQdSX
         +GzjIx8Y4IuBR1HS2aQGWRlscUJXE6WEueyP7X2B83ydNU9jzKEIk4xz9xds8p+yd4pU
         VaOQr8TdMNrp/PtAhkXAF8yr/DOaO6CX5qFTzirH7j7WXFn8E/P4d7ncmuNOKz2IaUe3
         Bu9s/PMnIIuYfwZV/Nem2ypzDq9hT9n+hhZdnhfwK2wwXuU3hIEjMRqwHUHKzsQBESJU
         x+qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ynAECvucuhMvbP8cwS6QYymonzK/uMzxWqNsu6RxVOQ=;
        b=EiENb7pi4ED6JhvbvAU90VcgIDTiYYfWhYIYm7tZhHUkl0YqnPKB2fs1jprOqDhuz6
         sr8wU1GsQCAkNTP27prPVXy6avCpy9Yj3fnIMZPN7bfSqbT+Rqtias+S7UzjTU+aQy1U
         Mc3L63bgCNvfGruhGL596cYPxTgUSM6tFFOLmbP+3uDK602k0cXuLsB9uyf62PqDSlPH
         tRmJgEQZY0SI0a2haoAadBZORFXBKfIOI2a4Vx09ziGlfRrO+rs3EJ0GsJhe/mlZfCSS
         gkbBf+UttpEBgLET67bCGVgf1dPsIZxU/c3QqX6c+SZbgFTry50rhr+IHSED8V1xUxju
         89bA==
X-Gm-Message-State: APjAAAUhOv4GgFnbzoBsP9izUuekNt3+D92NLi3gjoCYlFAIWgYsyXNA
        vx+qOyirX+jVs4/DiBKl+vtu3qFhDySCZM5JdN17Yg==
X-Google-Smtp-Source: APXvYqwbzDz1LV33C9eQRfMQ66DgycbUpabSvDxrpEo286vM48FZGUaJUsNg4Vuy0HVPZJ0WcR6p/x4MsZDxM7YGMsc=
X-Received: by 2002:a54:4f14:: with SMTP id e20mr6057794oiy.84.1579685673521;
 Wed, 22 Jan 2020 01:34:33 -0800 (PST)
MIME-Version: 1.0
References: <20200122091238.65484-1-yaohongbo@huawei.com>
In-Reply-To: <20200122091238.65484-1-yaohongbo@huawei.com>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Wed, 22 Jan 2020 10:34:22 +0100
Message-ID: <CAHUa44FMK8WC_1H5QKz706qZyM4215vX9MQYCkPno1M40-MX0g@mail.gmail.com>
Subject: Re: [PATCH RESEND -next] tee: amdtee: amdtee depends on CRYPTO_DEV_CCP_DD
To:     Hongbo Yao <yaohongbo@huawei.com>
Cc:     "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>,
        chenzhou10@huawei.com,
        "tee-dev @ lists . linaro . org" <tee-dev@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rangasamy, Devaraj" <Devaraj.Rangasamy@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 22, 2020 at 10:17 AM Hongbo Yao <yaohongbo@huawei.com> wrote:
>
> If CRYPTO_DEV_CCP_DD=m and AMDTEE=y, the following error is seen
> while building call.c or core.c
>
> drivers/tee/amdtee/call.o: In function `handle_unload_ta':
> call.c:(.text+0x35f): undefined reference to `psp_tee_process_cmd'
> drivers/tee/amdtee/core.o: In function `amdtee_driver_init':
> core.c:(.init.text+0xf): undefined reference to `psp_check_tee_status
>
> Fix the config dependency for AMDTEE here.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 757cc3e9ff ("tee: add AMD-TEE driver")
> Signed-off-by: Hongbo Yao <yaohongbo@huawei.com>
> Reviewed-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
> ---
>  drivers/tee/amdtee/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Jens Wiklander <jens.wiklander@linaro.org>

Thanks,
Jens

>
> diff --git a/drivers/tee/amdtee/Kconfig b/drivers/tee/amdtee/Kconfig
> index 4e32b6413b41..191f9715fa9a 100644
> --- a/drivers/tee/amdtee/Kconfig
> +++ b/drivers/tee/amdtee/Kconfig
> @@ -3,6 +3,6 @@
>  config AMDTEE
>         tristate "AMD-TEE"
>         default m
> -       depends on CRYPTO_DEV_SP_PSP
> +       depends on CRYPTO_DEV_SP_PSP && CRYPTO_DEV_CCP_DD
>         help
>           This implements AMD's Trusted Execution Environment (TEE) driver.
> --
> 2.20.1
>
