Return-Path: <SRS0=4Nwj=Q2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A89C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 05:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 416E3217D9
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 05:09:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IvA3f7V2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbfBSFJR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Feb 2019 00:09:17 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:37117 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfBSFJR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Feb 2019 00:09:17 -0500
Received: by mail-vs1-f66.google.com with SMTP id s16so11005093vsk.4
        for <linux-crypto@vger.kernel.org>; Mon, 18 Feb 2019 21:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QuMX54/woE2OP6tGZe8WjJt99Ck8goHIiIH/ZdxhLgw=;
        b=IvA3f7V24nZrS+PQFkYaqrYScir3TdfvI1nsMs6k1BjNqdRBIX7Ig4dT6KTi2zeuDA
         QibWz5K9zIbhacwP6fEco1WMnUN0aAhOTEcsokfEieQ6Egq3mApwU+HIyCMdGCaAWWPU
         k4p5Ys16g4oNN1bDPXVNeuhhuNXtxaRHyNR4PaL1HZEof3YrHoWz1aFXJcHJbKcTonzt
         Paivoh+erZJHDZaQM9fdLnsLu6Ss0bbU3X2ryLicBwfPsn/6PhKdpukEdXESueTkHJ/N
         cqdD8W28zbdnEY+M01Q4PnhrvX+Y4nVkWZ2lNKForsirD6UI14sF1eelyBxN0BcLG/U+
         gNiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QuMX54/woE2OP6tGZe8WjJt99Ck8goHIiIH/ZdxhLgw=;
        b=YOcchRakB+nl1iOw8LV+j3zncjpe90w80kp6Km2y44ix0Iv7S9MzRwcQTwtwNtbXNk
         LE/dnOkVCDs01AJH2xbVy2A11Zv9LhD5jWuig5KFgv6Ix22tA1FCDyxd19Jx58GH/tqd
         uINba7YuKPeQdR1k/FOsNRToG4Ii7rF5r8NOjrQ98HapvndoMveuOGAMFF9MyCXbskFh
         WjwpIm6JseeT/Q5hynvakAbpkDZ3URyXXkVy/aTwoy75rSgvM2reLIkT7YpLmyhc9XeX
         Z5FAJDNZwW2cJUBJZFlY9okdTOaxTOemDNFnZscZPyZNE3APIul0YUXq8Lfl6aDpKBkf
         kQxg==
X-Gm-Message-State: AHQUAuZiItSEEF63CPm47zDaMoDlxQCkv2yOvHaEKmVuEKdSKOZD5h0G
        QGbF/zXDlrjaig0de5eLydR5IGJH3WU61SsesuGIVQ==
X-Google-Smtp-Source: AHgI3IbNxb2XeF0tSY74RGsdsqhXUd8mM/Grac6QS8GLOBAyitqbVApwQWk0G3cewz+hJ/eDimDr2pEJIniuG8Dfirw=
X-Received: by 2002:a67:eed1:: with SMTP id o17mr14329237vsp.174.1550552955783;
 Mon, 18 Feb 2019 21:09:15 -0800 (PST)
MIME-Version: 1.0
References: <20190219032240.22935-1-natechancellor@gmail.com>
In-Reply-To: <20190219032240.22935-1-natechancellor@gmail.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Tue, 19 Feb 2019 10:39:04 +0530
Message-ID: <CAFA6WYNS3JckLR3=EzhbbO9G-emjXnQTGAzY2j8QoAJsteamSg@mail.gmail.com>
Subject: Re: [PATCH] hwrng: optee: Initialize some structs using memset
 instead of braces
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Jens Wiklander <jens.wiklander@linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Daniel Thompson <daniel.thompson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 19 Feb 2019 at 08:52, Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns:
>
> drivers/char/hw_random/optee-rng.c:80:31: warning: suggest braces around
> initialization of subobject [-Wmissing-braces]
>         struct tee_param param[4] = {0};
>                                      ^
>                                      {}
> drivers/char/hw_random/optee-rng.c:177:31: warning: suggest braces
> around initialization of subobject [-Wmissing-braces]
>         struct tee_param param[4] = {0};
>                                      ^
>                                      {}
> drivers/char/hw_random/optee-rng.c:212:48: warning: suggest braces
> around initialization of subobject [-Wmissing-braces]
>         struct tee_ioctl_open_session_arg sess_arg = {0};
>                                                       ^
>                                                       {}
> 3 warnings generated.
>
> One way to fix these warnings is to add additional braces like Clang
> suggests; however, there has been a bit of push back from some
> maintainers, who just prefer memset as it is unambiguous, doesn't
> depend on a particular compiler version, and properly initializes all
> subobjects [1][2]. Do that here so there are no more warnings.
>
> [1]: https://lore.kernel.org/lkml/022e41c0-8465-dc7a-a45c-64187ecd9684@amd.com/
> [2]: https://lore.kernel.org/lkml/20181128.215241.702406654469517539.davem@davemloft.net/
>
> Fixes: 5fe8b1cc6a03 ("hwrng: add OP-TEE based rng driver")
> Link: https://github.com/ClangBuiltLinux/linux/issues/369
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Reviewed-by: Sumit Garg <sumit.garg@linaro.org>

> ---
>  drivers/char/hw_random/optee-rng.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
> index 2b9fc8ac5500..46f4bcd28c41 100644
> --- a/drivers/char/hw_random/optee-rng.c
> +++ b/drivers/char/hw_random/optee-rng.c
> @@ -76,8 +76,11 @@ static size_t get_optee_rng_data(struct optee_rng_private *pvt_data,
>         u32 ret = 0;
>         u8 *rng_data = NULL;
>         size_t rng_size = 0;
> -       struct tee_ioctl_invoke_arg inv_arg = {0};
> -       struct tee_param param[4] = {0};
> +       struct tee_ioctl_invoke_arg inv_arg;
> +       struct tee_param param[4];
> +
> +       memset(&inv_arg, 0, sizeof(inv_arg));
> +       memset(&param, 0, sizeof(param));
>
>         /* Invoke TA_CMD_GET_ENTROPY function of Trusted App */
>         inv_arg.func = TA_CMD_GET_ENTROPY;
> @@ -173,8 +176,11 @@ static struct optee_rng_private pvt_data = {
>  static int get_optee_rng_info(struct device *dev)
>  {
>         u32 ret = 0;
> -       struct tee_ioctl_invoke_arg inv_arg = {0};
> -       struct tee_param param[4] = {0};
> +       struct tee_ioctl_invoke_arg inv_arg;
> +       struct tee_param param[4];
> +
> +       memset(&inv_arg, 0, sizeof(inv_arg));
> +       memset(&param, 0, sizeof(param));
>
>         /* Invoke TA_CMD_GET_RNG_INFO function of Trusted App */
>         inv_arg.func = TA_CMD_GET_RNG_INFO;
> @@ -209,7 +215,9 @@ static int optee_rng_probe(struct device *dev)
>  {
>         struct tee_client_device *rng_device = to_tee_client_device(dev);
>         int ret = 0, err = -ENODEV;
> -       struct tee_ioctl_open_session_arg sess_arg = {0};
> +       struct tee_ioctl_open_session_arg sess_arg;
> +
> +       memset(&sess_arg, 0, sizeof(sess_arg));
>
>         /* Open context with TEE driver */
>         pvt_data.ctx = tee_client_open_context(NULL, optee_ctx_match, NULL,
> --
> 2.21.0.rc1
>
