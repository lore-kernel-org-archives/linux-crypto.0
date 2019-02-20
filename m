Return-Path: <SRS0=bqmp=Q3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C461C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 10:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1093220700
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 10:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="faYbSYfK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfBTKea (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Feb 2019 05:34:30 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:38163 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbfBTKea (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Feb 2019 05:34:30 -0500
Received: by mail-vs1-f66.google.com with SMTP id h132so1832367vsd.5
        for <linux-crypto@vger.kernel.org>; Wed, 20 Feb 2019 02:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YDkQyJF5paivJhhJZK73qyzho8l9Qh06MdCjo92EjQU=;
        b=faYbSYfK1ytcBTUSGnMsL7O1Oswlr9mEx1mqbAsy1yxARtmtr4EIiC1ece//t8+F0y
         X7Ix+jHLUa492+46TohRds4vKLQA68zsUxpIy0wKdv9BH0TD9UcQ641ezVJ7QD6eeQvg
         UhugB2bUraPdTUo8gzyomckXZHVGbbG6kLXzjEIciSu/kacTcnAi6Qcmivgz+y4ZReyf
         7mWdAnZasakemJhhYH+9TeLubdWnH55M9TOCPm3N6Qfg7RruqX1z4MKMK085alk5Gmhk
         EN23NF7UhZXFiGo8h78F8mjtlVGDYADykEJAiTTCi74p3NGMSKLhGSIbwh4WhUQJEwjt
         pi0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YDkQyJF5paivJhhJZK73qyzho8l9Qh06MdCjo92EjQU=;
        b=GgEMHkbN/BGuAfUHxw3HBTujC3xubA8HEgEkgWC7mc22RcpoiZsOBelgT4B3Jhmm34
         W0QX9vmHcixl3uZGxtciKv+2AzKs1lrMPGAyOFZ+yto4U3fHRMQiskmLb+44AOg5PXuS
         2R8hhHjYuCgqWdlivNcmrko8fKKgB4AFWC43oPW/JT8aKnEa25/YsDwM4q0nFClgN5oS
         DUtfnMfqyEgjrs9HRxzqn3PUARYr/K+rujhTv1gnVrzsi6DJYwqwXyIcFlbm75OsBlo8
         FB/vjw/8oca/zLvEeuLjVkcC7xCC53Nsy2KgNacmiqlhwEwGAgnvb0uhXtokY/MIYQ5Q
         LR5Q==
X-Gm-Message-State: AHQUAuZfonDvXIJvRJyZoWFYC301gpYz18/S0G4W2oQ+LfJf3DoKQDIr
        ePAoRH0rusrImTNnrtyR1U+9vPHiwHPpdnAQlC5agA==
X-Google-Smtp-Source: AHgI3IbGOGhBMKjxZ5nWtSPUqckUPFztM5KhSh8hmk02kbq//Tku9Cw5DNx5nyQd0WreXoe2KoC43vJOaKQfsmsg7RI=
X-Received: by 2002:a67:ef90:: with SMTP id r16mr7665199vsp.141.1550658869065;
 Wed, 20 Feb 2019 02:34:29 -0800 (PST)
MIME-Version: 1.0
References: <20190220093458.159208-1-weiyongjun1@huawei.com>
In-Reply-To: <20190220093458.159208-1-weiyongjun1@huawei.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Wed, 20 Feb 2019 16:04:17 +0530
Message-ID: <CAFA6WYODEymSPh6gQjUL3wRmoPy=zoMv-Z1Q1TbKtWFH=UUgMw@mail.gmail.com>
Subject: Re: [PATCH -next] hwrng: make symbol 'optee_rng_id_table' static
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 20 Feb 2019 at 14:51, Wei Yongjun <weiyongjun1@huawei.com> wrote:
>
> Fixes the following sparse warning:
>
> drivers/char/hw_random/optee-rng.c:265:35: warning:
>  symbol 'optee_rng_id_table' was not declared. Should it be static?
>

I haven't observed this warning during my normal Linux build using
gcc. Is there any specific configuration you are using?

-Sumit

> Fixes: 5fe8b1cc6a03 ("hwrng: add OP-TEE based rng driver")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/char/hw_random/optee-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
> index 2b9fc8ac5500..3a4dd6fc9ff4 100644
> --- a/drivers/char/hw_random/optee-rng.c
> +++ b/drivers/char/hw_random/optee-rng.c
> @@ -262,7 +262,7 @@ static int optee_rng_remove(struct device *dev)
>         return 0;
>  }
>
> -const struct tee_client_device_id optee_rng_id_table[] = {
> +static const struct tee_client_device_id optee_rng_id_table[] = {
>         {UUID_INIT(0xab7a617c, 0xb8e7, 0x4d8f,
>                    0x83, 0x01, 0xd0, 0x9b, 0x61, 0x03, 0x6b, 0x64)},
>         {}
>
>
>
