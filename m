Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B78BAC4CECE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FFD2217F9
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:27:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tCsg8/BI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730430AbfJNM1j (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 08:27:39 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45872 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730398AbfJNM1j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 08:27:39 -0400
Received: by mail-wr1-f65.google.com with SMTP id r5so19456517wrm.12
        for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2019 05:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=74yP2FxtDtG0Yd27NaPGtt7r14yMghW+Jf1gUnHQp+s=;
        b=tCsg8/BIBUlbpsqZtroC38Z3Xjzi5BfqfCZK8nUVkrfZgMA0s9XJgV+XCKUHQmJjOS
         8Pre32L6bDLw6peIdTPsF58olTmJjhfivaBr++af5pNg/9+qjNmqfFEsf+IQ1VVBGLTp
         3vu3ao5P8ytuIY5jSQ9X092ZW907OQbpp12cVZE27MDFNsIU6zZ83XWUif/2BtXIthew
         dqIuGlLkB08XeQhgPsQGDzuyuThKrY+xZTnpQJWnRnTvGZUQpERVY9XUJWusSXhKRreX
         kB/QTrjqhDPHiAUIfDeBzC+yW3dlxPfbX7x3X9572K/XH0SqNvjTaqEVlmdnNy2Z6KXR
         YNBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=74yP2FxtDtG0Yd27NaPGtt7r14yMghW+Jf1gUnHQp+s=;
        b=od95dtGbZL+fdGa1uWVfror5RN9HBKxkHl6DLQsdkEK2qGNOvZIuLBsF0sfX6gbjfj
         TDxFkTwCinAqk9ivWkLud3tDQ26w63M1phix9xXuBb84f1wyZ++PXrVWkx6Go34RNDCM
         0VuVf6DTjdo4n4WaWN9z8sKeuQj+t0LigcxeqCl3Q5ajhRQjYuJjAQWjpHGR0ErXK4mF
         53E+j8oU3H5oVBoR4GPibJWKB+yU9l42P74M0ZTyBmjjAF4vhlYdiPhiqHnbzfbVswxp
         ui5QsrCm1Ll0onM+4lLWEB5CmloM1LusQEbtymqC9sBP1/WV+o2DCiTBs58ytw6KaJji
         bSuQ==
X-Gm-Message-State: APjAAAU/axDKu5K3kBtDccVtA+LeZqogd7tpiw30vjZWk2Y3U18Atqt+
        gLHJFQeDy8r5+KdXbaQxsKAaKw==
X-Google-Smtp-Source: APXvYqxxzyIg26hZjfXLFi87SCcAcVzu4Z2f8d7+IbSXeAsrXFC5DtJECFz6xeg5J3k8zXF/jzmTZQ==
X-Received: by 2002:a5d:4c85:: with SMTP id z5mr25686239wrs.384.1571056055517;
        Mon, 14 Oct 2019 05:27:35 -0700 (PDT)
Received: from holly.lan (cpc141214-aztw34-2-0-cust773.18-1.cable.virginm.net. [86.9.19.6])
        by smtp.gmail.com with ESMTPSA id u26sm18054666wrd.87.2019.10.14.05.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 05:27:34 -0700 (PDT)
Date:   Mon, 14 Oct 2019 13:27:32 +0100
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     linux-crypto@vger.kernel.org, dsaxena@plexity.net,
        herbert@gondor.apana.org.au, mpm@selenic.com,
        romain.perier@free-electrons.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, ralph.siemsen@linaro.org,
        milan.stevanovic@se.com, ryan.harkin@linaro.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] hwrng: omap - Fix RNG wait loop timeout
Message-ID: <20191014122732.d6ow5tbko5xdwd7g@holly.lan>
References: <1571054565-6991-1-git-send-email-sumit.garg@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571054565-6991-1-git-send-email-sumit.garg@linaro.org>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 14, 2019 at 05:32:45PM +0530, Sumit Garg wrote:
> Existing RNG data read timeout is 200us but it doesn't cover EIP76 RNG
> data rate which takes approx. 700us to produce 16 bytes of output data
> as per testing results. So configure the timeout as 1000us to also take
> account of lack of udelay()'s reliability.

What "lack of udelay()'s reliability" are you concerned about?


Daniel.

> 
> Fixes: 383212425c92 ("hwrng: omap - Add device variant for SafeXcel IP-76 found in Armada 8K")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> ---
>  drivers/char/hw_random/omap-rng.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
> index b27f396..e329f82 100644
> --- a/drivers/char/hw_random/omap-rng.c
> +++ b/drivers/char/hw_random/omap-rng.c
> @@ -66,6 +66,13 @@
>  #define OMAP4_RNG_OUTPUT_SIZE			0x8
>  #define EIP76_RNG_OUTPUT_SIZE			0x10
>  
> +/*
> + * EIP76 RNG takes approx. 700us to produce 16 bytes of output data
> + * as per testing results. And to account for the lack of udelay()'s
> + * reliability, we keep the timeout as 1000us.
> + */
> +#define RNG_DATA_FILL_TIMEOUT			100
> +
>  enum {
>  	RNG_OUTPUT_0_REG = 0,
>  	RNG_OUTPUT_1_REG,
> @@ -176,7 +183,7 @@ static int omap_rng_do_read(struct hwrng *rng, void *data, size_t max,
>  	if (max < priv->pdata->data_size)
>  		return 0;
>  
> -	for (i = 0; i < 20; i++) {
> +	for (i = 0; i < RNG_DATA_FILL_TIMEOUT; i++) {
>  		present = priv->pdata->data_present(priv);
>  		if (present || !wait)
>  			break;
> -- 
> 2.7.4
> 
