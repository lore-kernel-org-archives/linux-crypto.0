Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00859C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Mar 2022 13:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347365AbiCKNcm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Mar 2022 08:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239275AbiCKNcl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Mar 2022 08:32:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D3DAE1C468B
        for <linux-crypto@vger.kernel.org>; Fri, 11 Mar 2022 05:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647005497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mas990unEz6PSP1U0FiOPnrCX3Hkd5pxKLR2A9Xu28U=;
        b=cu9b0ADePpBI6Cw+uV57e+mDEyb//EKwhC/uPvPS5xKTG5ifNSKIPs4uZ8uKbv9CkSDIQr
        z9tQyGzZNtEa8Nz2UDo9xLeO2cU81fGehqlgN3EG7Ya8kFVNaPPnFMFV07JMcRciWiPQlF
        SGq2xM8BnmgZV3wUoPdi5LYLHTy3Cdo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-TrjF1rBJPoasDRVFzri3_A-1; Fri, 11 Mar 2022 08:31:36 -0500
X-MC-Unique: TrjF1rBJPoasDRVFzri3_A-1
Received: by mail-qk1-f200.google.com with SMTP id 12-20020a37090c000000b0067b32f93b90so6116329qkj.16
        for <linux-crypto@vger.kernel.org>; Fri, 11 Mar 2022 05:31:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Mas990unEz6PSP1U0FiOPnrCX3Hkd5pxKLR2A9Xu28U=;
        b=xWxLlxdncluu0AvVR6K3twYtp+FARf66DcRjhoKfbyNK7T69cvQpt1yc5YzOskZOph
         TtlqnhuOAJTIFfm10AVoUK1dWRykcKz7WRryMkXlMshZi3gV+kDHDaPfzbmdYQ1HVpbs
         RTrWq2lDSlNgDizwmUSRT2bbd6pxCoaVdQpZfemi9ZFePIOYV/REcPjOahe/UwxXfI3f
         UI2eaZ4rt5J9xxcRmKm7rvbByvL1+79BDxlpxJtWN02gluL9bBI1G02RUTNdFU616hUU
         zgTS1zSaqaOC3QKNLCxYj7MzpHyPGh4j1uBUNnUyOO4T0O5kZwX8mhj9M3OgoCNyHUTo
         mrjA==
X-Gm-Message-State: AOAM530rtQ2GVJjmPtKCf5qYLeACCgRf00fAZpZX9RfSFbbJt4L6p5z1
        uHJ25DlwhqPLofyN4FH6/R2jTccM9BSrcLYFzDtSstJETjr5GFVsuz+kxhuZXVO57ule9E+dlYp
        0b4t5aJdN9IXtbI/C7fl6e8FE
X-Received: by 2002:ac8:5a88:0:b0:2e1:bbda:3b21 with SMTP id c8-20020ac85a88000000b002e1bbda3b21mr2084704qtc.307.1647005495271;
        Fri, 11 Mar 2022 05:31:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxNdUIp1eKLAi+jizuIu9aOp2IavAeVwIgZiIQsmyB0BOQZveyw+HUV51FZhgO0o6hTm9/huQ==
X-Received: by 2002:ac8:5a88:0:b0:2e1:bbda:3b21 with SMTP id c8-20020ac85a88000000b002e1bbda3b21mr2084690qtc.307.1647005494961;
        Fri, 11 Mar 2022 05:31:34 -0800 (PST)
Received: from halaneylaptop (068-184-200-203.res.spectrum.com. [68.184.200.203])
        by smtp.gmail.com with ESMTPSA id g1-20020ae9e101000000b0067d4bfffc57sm2729346qkm.117.2022.03.11.05.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 05:31:34 -0800 (PST)
Date:   Fri, 11 Mar 2022 07:31:31 -0600
From:   Andrew Halaney <ahalaney@redhat.com>
To:     Brian Masney <bmasney@redhat.com>
Cc:     bjorn.andersson@linaro.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qcom-rng: ensure buffer for generate is
 completely filled
Message-ID: <20220311133131.v3gtasex5fpnyqfp@halaneylaptop>
References: <20220310232459.749638-1-bmasney@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220310232459.749638-1-bmasney@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 10, 2022 at 06:24:59PM -0500, Brian Masney wrote:
> The generate function in struct rng_alg expects that the destination
> buffer is completely filled if the function returns 0. qcom_rng_read()
> can run into a situation where the buffer is partially filled with
> randomness and the remaining part of the buffer is zeroed since
> qcom_rng_generate() doesn't check the return value. This issue can
> be reproduced by running the following from libkcapi:
> 
>     kcapi-rng -b 9000000 > OUTFILE
> 
> The generated OUTFILE will have three huge sections that contain all
> zeros, and this is caused by the code where the test
> 'val & PRNG_STATUS_DATA_AVAIL' fails.
> 
> Let's fix this issue by ensuring that qcom_rng_read() always returns
> with a full buffer if the function returns success. Let's also have
> qcom_rng_generate() return the correct value.
> 
> Here's some statistics from the ent project
> (https://www.fourmilab.ch/random/) that shows information about the
> quality of the generated numbers:
> 
>     $ ent -c qcom-random-before
>     Value Char Occurrences Fraction
>       0           606748   0.067416
>       1            33104   0.003678
>       2            33001   0.003667
>     ...
>     253   �        32883   0.003654
>     254   �        33035   0.003671
>     255   �        33239   0.003693
> 
>     Total:       9000000   1.000000
> 
>     Entropy = 7.811590 bits per byte.
> 
>     Optimum compression would reduce the size
>     of this 9000000 byte file by 2 percent.
> 
>     Chi square distribution for 9000000 samples is 9329962.81, and
>     randomly would exceed this value less than 0.01 percent of the
>     times.
> 
>     Arithmetic mean value of data bytes is 119.3731 (127.5 = random).
>     Monte Carlo value for Pi is 3.197293333 (error 1.77 percent).
>     Serial correlation coefficient is 0.159130 (totally uncorrelated =
>     0.0).
> 
> Without this patch, the results of the chi-square test is 0.01%, and
> the numbers are certainly not random according to ent's project page.
> The results improve with this patch:
> 
>     $ ent -c qcom-random-after
>     Value Char Occurrences Fraction
>       0            35432   0.003937
>       1            35127   0.003903
>       2            35424   0.003936
>     ...
>     253   �        35201   0.003911
>     254   �        34835   0.003871
>     255   �        35368   0.003930
> 
>     Total:       9000000   1.000000
> 
>     Entropy = 7.999979 bits per byte.
> 
>     Optimum compression would reduce the size
>     of this 9000000 byte file by 0 percent.
> 
>     Chi square distribution for 9000000 samples is 258.77, and randomly
>     would exceed this value 42.24 percent of the times.
> 
>     Arithmetic mean value of data bytes is 127.5006 (127.5 = random).
>     Monte Carlo value for Pi is 3.141277333 (error 0.01 percent).
>     Serial correlation coefficient is 0.000468 (totally uncorrelated =
>     0.0).
> 
> This change was tested on a Nexus 5 phone (msm8974 SoC).
> 
> Signed-off-by: Brian Masney <bmasney@redhat.com>
> Fixes: ceec5f5b5988 ("crypto: qcom-rng - Add Qcom prng driver")
> Cc: stable@vger.kernel.org # 4.19+

FWIW

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>

> ---
>  drivers/crypto/qcom-rng.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
> index 99ba8d51d102..11f30fd48c14 100644
> --- a/drivers/crypto/qcom-rng.c
> +++ b/drivers/crypto/qcom-rng.c
> @@ -8,6 +8,7 @@
>  #include <linux/clk.h>
>  #include <linux/crypto.h>
>  #include <linux/io.h>
> +#include <linux/iopoll.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> @@ -43,16 +44,19 @@ static int qcom_rng_read(struct qcom_rng *rng, u8 *data, unsigned int max)
>  {
>  	unsigned int currsize = 0;
>  	u32 val;
> +	int ret;
>  
>  	/* read random data from hardware */
>  	do {
> -		val = readl_relaxed(rng->base + PRNG_STATUS);
> -		if (!(val & PRNG_STATUS_DATA_AVAIL))
> -			break;
> +		ret = readl_poll_timeout(rng->base + PRNG_STATUS, val,
> +					 val & PRNG_STATUS_DATA_AVAIL,
> +					 200, 10000);
> +		if (ret)
> +			return ret;
>  
>  		val = readl_relaxed(rng->base + PRNG_DATA_OUT);
>  		if (!val)
> -			break;
> +			return -EINVAL;
>  
>  		if ((max - currsize) >= WORD_SZ) {
>  			memcpy(data, &val, WORD_SZ);
> @@ -61,11 +65,10 @@ static int qcom_rng_read(struct qcom_rng *rng, u8 *data, unsigned int max)
>  		} else {
>  			/* copy only remaining bytes */
>  			memcpy(data, &val, max - currsize);
> -			break;
>  		}
>  	} while (currsize < max);
>  
> -	return currsize;
> +	return 0;
>  }
>  
>  static int qcom_rng_generate(struct crypto_rng *tfm,
> @@ -87,7 +90,7 @@ static int qcom_rng_generate(struct crypto_rng *tfm,
>  	mutex_unlock(&rng->lock);
>  	clk_disable_unprepare(rng->clk);
>  
> -	return 0;
> +	return ret;
>  }
>  
>  static int qcom_rng_seed(struct crypto_rng *tfm, const u8 *seed,
> -- 
> 2.34.1
> 

