Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6475C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 17:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C579D64EC4
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Mar 2021 17:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhCQRek (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Mar 2021 13:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhCQRef (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Mar 2021 13:34:35 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A349C06174A;
        Wed, 17 Mar 2021 10:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=899uy+opuBYMan6yzLPG9/V5iogxQaeqI/5Fsy2GYy8=; b=pPunVPMIc6x2/TQzWdqa6GjxNe
        snj+Qpc884RUynHAwC08mrBSdj/rbnbg0UhhHxF0Zm+HSqI1usAX0XDRtzw3rXtoe7kGczwf9V7PM
        53ziD1KW8Crr9UjlcRhGH8orc0I19W/q1QGOLAeZKF0gEG5kjcv3KgizMv980TDLThM9bVYtSBEvT
        csccGPHMXlo05mhemj2Vxwligt7Hc7T95dlQ21ziQK6zCKffmPRHqMhCIXVUC4yqqm87MnMajflrR
        LLe8BB30Q0j9inBdWupmlsqPCWZB78Tkjt3mA1OHRCyqDRAuecO2z4zyLE8QkDX00Q8CEnIOM5SLa
        aUPqQlNA==;
Received: from [2601:1c0:6280:3f0::9757]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMa3z-001fW4-EO; Wed, 17 Mar 2021 17:34:31 +0000
Subject: Re: [PATCH] crypto: inside-secure: Minor typo fix in the file
 safexcel.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, atenart@kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210317091445.614865-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <2b589f48-164b-2079-a1a7-5befa66a3564@infradead.org>
Date:   Wed, 17 Mar 2021 10:34:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210317091445.614865-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/17/21 2:14 AM, Bhaskar Chowdhury wrote:
> 
> s/procesing/processing/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  drivers/crypto/inside-secure/safexcel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
> index 6364583b88b2..9ff885d50edf 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -688,7 +688,7 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
>  		/* Leave the DSE threads reset state */
>  		writel(0, EIP197_HIA_DSE_THR(priv) + EIP197_HIA_DSE_THR_CTRL(pe));
> 
> -		/* Configure the procesing engine thresholds */
> +		/* Configure the processing engine thresholds */
>  		writel(EIP197_PE_OUT_DBUF_THRES_MIN(opbuflo) |
>  		       EIP197_PE_OUT_DBUF_THRES_MAX(opbufhi),
>  		       EIP197_PE(priv) + EIP197_PE_OUT_DBUF_THRES(pe));
> --


-- 
~Randy

