Return-Path: <SRS0=MR99=BD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BCC1C433E3
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jul 2020 13:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78E952074A
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Jul 2020 13:22:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zGfFL6Gm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgGXNWV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Jul 2020 09:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgGXNWU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Jul 2020 09:22:20 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A87C0619E4
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2020 06:22:20 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id s9so5187815lfs.4
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jul 2020 06:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NRL0UF3/43vslaJwWgTDYbt4jG2vWByUDB6sLPDuLgg=;
        b=zGfFL6GmKfCKONek4mgXwt+6vzxav2G7E3CLcuQNhfLYOlekFkhc+89MaxLAL7qw3X
         HCOc3/HQHMtRl9xxbUrickjMs0ht8tRG431uD01gRfGYYmKa5xK7K9tG2cuhV8230kf6
         TZPGub5Z/Qm6994apf7zqFR5JT7k/mmb/zuPV3EVQG2Cjy5atgiwXwuMtAegmdOyQ4Dl
         Muy2DFwUjK8YWKAamgBp0DieYGDljuUJI9aCweRWFLKxqXIGj5zpY6kP654hi8CLwwJ2
         kKC1ILn6FXoT+jAdBs7Q/zKSSYq0APnEvjaE2CW1f6xuz08/uOFTak44QG3iKkhJVvz/
         izQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NRL0UF3/43vslaJwWgTDYbt4jG2vWByUDB6sLPDuLgg=;
        b=lbCqdEE/gs051DnlwDGl/t+RrQA6jqBb9id368H6frQmlOUXlciHkUIt0S9RQGmqaJ
         /P6SqYYqAmyBwj8D1301KePFOhKVMXMnghGGeaGRtF6hEiZXktAlFg5aB6BTNJKr9UoW
         lYWEx8lVEUmCL5F9lC5elcM6VwPM1v/etLNmBtus5yeuVjgL+kjVWOAvVoXS1tw6np60
         mOrucubNkHLxQIfa5lIcmgct/YoeoTEy+3P+fTotmWjNO6owu53xEPup+VDBL16hipjU
         pdSIQ3eWwWaXMRTqAKqD/uPGNgZVYfWn7e4vU/wMxpxHC7f9dGC39LKBRjvjWjjN44Vz
         WdgA==
X-Gm-Message-State: AOAM531twL7FKPTyO7cX4NDeIQL6CRmaJe+ZHDwH7gUdFKge1b7toJc/
        Z2UI5lOhl3dToHYMgEvRB6lA35TSRB9QaLPwvEy27A==
X-Google-Smtp-Source: ABdhPJzdYPF+cX3QXpVzwFZNMylvbWd3csH+Sajhbs6Ro6UfJ5+mgfxTXCDTtwTUBJA9hyU4+UKjUxUTeY3InVk+/Ho=
X-Received: by 2002:a19:86c3:: with SMTP id i186mr1625844lfd.59.1595596938380;
 Fri, 24 Jul 2020 06:22:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200723084622.31134-1-jorge@foundries.io> <20200723084622.31134-2-jorge@foundries.io>
In-Reply-To: <20200723084622.31134-2-jorge@foundries.io>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Fri, 24 Jul 2020 18:52:07 +0530
Message-ID: <CAFA6WYPQ3GGYostoHU=6qg4c_LqoqOZVbZ8gbQbGkNfyGydQjQ@mail.gmail.com>
Subject: Re: [PATCHv2 2/2] hwrng: optee: fix wait use case
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
> The current code waits for data to be available before attempting a
> second read. However the second read would not be executed as the
> while loop exits.
>
> This fix does not wait if all data has been read and reads a second
> time if only partial data was retrieved on the first read.
>
> This fix also does not attempt to read if not data is requested.

I am not sure how this is possible, can you elaborate?

>
> Signed-off-by: Jorge Ramirez-Ortiz <jorge@foundries.io>
> ---
>  v2: tidy up the while loop to avoid reading when no data is requested
>
>  drivers/char/hw_random/optee-rng.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
> index 5bc4700c4dae..a99d82949981 100644
> --- a/drivers/char/hw_random/optee-rng.c
> +++ b/drivers/char/hw_random/optee-rng.c
> @@ -122,14 +122,14 @@ static int optee_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
>         if (max > MAX_ENTROPY_REQ_SZ)
>                 max = MAX_ENTROPY_REQ_SZ;
>
> -       while (read == 0) {
> +       while (read < max) {
>                 rng_size = get_optee_rng_data(pvt_data, data, (max - read));
>
>                 data += rng_size;
>                 read += rng_size;
>
>                 if (wait && pvt_data->data_rate) {
> -                       if (timeout-- == 0)
> +                       if ((timeout-- == 0) || (read == max))

If read == max, would there be any sleep?

-Sumit

>                                 return read;
>                         msleep((1000 * (max - read)) / pvt_data->data_rate);
>                 } else {
> --
> 2.17.1
>
