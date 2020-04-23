Return-Path: <SRS0=jAnl=6H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94222C2BA19
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 05:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D8FA2074F
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 05:20:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GYZrKG8/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbgDWFUx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Apr 2020 01:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725562AbgDWFUx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Apr 2020 01:20:53 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A25C03C1AB
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2020 22:20:53 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id u10so3686527lfo.8
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2020 22:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0XNuFJldWIFAh71O2L1PcqD5B/3heEJe5lOmHQD0OY4=;
        b=GYZrKG8/dg1Ps0iSKJf+KHK0m4629/Y0psFrEsnVs0VHqjYf/cZaTZx5ffH3qtizsg
         tlIw8Ub0Srx4ytTYBpIoKtLyBaV8dFMaqUtOQp7iFuEOAgW9DJICt96coRZryeGaMPUF
         IHmbcXRJAxGFRRB6zHy4epPVfRGyn25XFbNEorAfdy4xMCbQHeRV+sgBuwAznqPJYY5A
         F3rmogiqSNf+gl0ZNJ5oBpTVt4rIWWTpfUJcnyO7RwprC9MXWPmM4w7/gnggCDO4K1DM
         gxjVTdHQhJMKS+nqswhD26Y0r+kMn/qwf1SNY444qjVLIn32jeq/UDHTkyYglU8HVIv9
         IoAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0XNuFJldWIFAh71O2L1PcqD5B/3heEJe5lOmHQD0OY4=;
        b=ajrd5YX8yoPnNw8qR9wrEydrZQwXgi86v06hu4hapmcqmWbYOS1aEPn5uQvrhOTos9
         UJ1tbSy/Y/sr7OjLfwqSfckwfV5sMJImJbj767ob7quZfUrx/O5o3hfw3H89ZFsWwRbo
         DSipBsreEVvVlwQNlZuj7muLIq8RQZOaLk2oE5OYauzp+lLp+eXTlLWuDNSPoXTk25WD
         cepqRZE+v0Syes9efO3ZtKdG4xLQWlwP6fja4WUdUCvxY57wEsCWeMh8zFroztAgDmWr
         NrgsQD3QMSJqHOmudy3hp2Qwqt3m+C0Y3u/RSIyiU4PV77jdeMH9DNMsOP/tHUatRPrr
         87rw==
X-Gm-Message-State: AGi0PuYi0FF4yI/TRVQbc4ur3kBBN6zfyZXSZEgsVwYZk4zzgBolm12w
        WcovALlllLOYaKP749tYgN3dNnGdh3nhZFvgjnHLVPP+I5Y=
X-Google-Smtp-Source: APiQypIlTkbHEhmLsKJmckygX0SYVaNdAFud/bRyTfaiWYcFuim9jN6BdyOnipOhuUFuEAFnaQnyDGWFYHDKAOPDfFE=
X-Received: by 2002:ac2:4859:: with SMTP id 25mr1261989lfy.59.1587619251519;
 Wed, 22 Apr 2020 22:20:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200422125808.38278-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20200422125808.38278-1-andriy.shevchenko@linux.intel.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Thu, 23 Apr 2020 10:50:40 +0530
Message-ID: <CAFA6WYP3kEG4SrNJBkKKHCAUN+CdqkAmufq2gidnAvscXVhkSQ@mail.gmail.com>
Subject: Re: [PATCH v1] hwrng: Use UUID API for exporting the UUID
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     "tee-dev @ lists . linaro . org" <tee-dev@lists.linaro.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 22 Apr 2020 at 18:28, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> There is export_uuid() function which exports uuid_t to the u8 array.
> Use it instead of open coding variant.
>
> This allows to hide the uuid_t internals.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/char/hw_random/optee-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Reviewed-by: Sumit Garg <sumit.garg@linaro.org>

> diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
> index ddfbabaa5f8f6..49b2e02537ddb 100644
> --- a/drivers/char/hw_random/optee-rng.c
> +++ b/drivers/char/hw_random/optee-rng.c
> @@ -226,7 +226,7 @@ static int optee_rng_probe(struct device *dev)
>                 return -ENODEV;
>
>         /* Open session with hwrng Trusted App */
> -       memcpy(sess_arg.uuid, rng_device->id.uuid.b, TEE_IOCTL_UUID_LEN);
> +       export_uuid(sess_arg.uuid, &rng_device->id.uuid);
>         sess_arg.clnt_login = TEE_IOCTL_LOGIN_PUBLIC;
>         sess_arg.num_params = 0;
>
> --
> 2.26.1
>
