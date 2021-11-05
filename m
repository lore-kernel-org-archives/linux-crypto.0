Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32034C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 21:08:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13DEB61053
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 21:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbhKEVLc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Nov 2021 17:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233823AbhKEVLb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Nov 2021 17:11:31 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878B6C061714
        for <linux-crypto@vger.kernel.org>; Fri,  5 Nov 2021 14:08:51 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id az8so9943525qkb.2
        for <linux-crypto@vger.kernel.org>; Fri, 05 Nov 2021 14:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9KsUbY1oXbsCP4rHu/evsevKIZYVGER2+YYdO27//vs=;
        b=L5lZRPCJGwbZwuBGUVwQfXoVPaaDbjlBQDjZwtE0dyQLN0CcmK72hoiKW1yOOuXWgp
         dV7f1J25/FsiSD+WQyp8FkJNPjsX4/ZGv3VZazauNswQP1gREst4MzyJuX2SJxZu0IF4
         l5TMrAV+silnFZBU0EbVwBZaZyGGuOB1byDhoaONHRacr23ObiT5vui1Q3lr6m4uhkYZ
         T4vu38Z0c3I6S6mxHfeiz9H8kUnoDtMsf7MV41Z3PGk5JtidKloyCHV1EM5NitWKz3JI
         61MIdMaZ6K0OKvy0ymq15zVOmD/BiNpHYxUUJzvYLf0dQyoFjKS0Jz2eflQthUvLnKkM
         +WYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9KsUbY1oXbsCP4rHu/evsevKIZYVGER2+YYdO27//vs=;
        b=fpOgowOgCc55Zo6aF9/RBGmNJ36WuHHkgAd5U3bK5MJvQtR+zivR4FVm93yfP9Ja40
         ks7Nq7xiDDB+wn7JmAvFlPkaYARrOXMgt3+AeQxCsrYkPAosKxYD+VjrOOwo20+4KMAa
         /gcl7r6gBphwfFRzYAY57WUJc6ylNGUf/UviC2YuZAv7nQ2LZiq0iPv4asNvl9CpDdBm
         AjcM+X/+buOM4BzU3dP+fyG27seBHP93n360ml8uOli7qz/AoefkZgI1tMVuuC4S+R10
         pk1AeeB0b/m4X+ER79f5YiWHinu5BnzkN4FguUAPQpKrQdhZq7t+Cq2oueBguP1Mb61J
         2xXQ==
X-Gm-Message-State: AOAM531BxYOY77oSHuz3b3jKTiDcS63A9zlbr3dWZ/ZNIyB5vAZFGp+p
        f4+i/lH7ImBlck7j3xiu10lp/Q==
X-Google-Smtp-Source: ABdhPJz1gVsomHA5Iulysp2StyZDaDVhnvwJx5PH3tg6Os5U2vU6foKlvhsspkOmJfmpXEbf1nlRGw==
X-Received: by 2002:a05:620a:258c:: with SMTP id x12mr49581169qko.279.1636146530685;
        Fri, 05 Nov 2021 14:08:50 -0700 (PDT)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id t12sm1880309qta.51.2021.11.05.14.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 14:08:50 -0700 (PDT)
Subject: Re: [PATCH] crypto: qce: fix uaf on qce_aead_register_one
To:     Chengfeng Ye <cyeaa@connect.ust.hk>, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
References: <20211104132807.19366-1-cyeaa@connect.ust.hk>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <6267d89c-1f8d-7389-3650-fc9004e62b95@linaro.org>
Date:   Fri, 5 Nov 2021 17:08:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211104132807.19366-1-cyeaa@connect.ust.hk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 11/4/21 9:28 AM, Chengfeng Ye wrote:
> Pointer alg points to sub field of tmpl, it
> is dereferenced after tmpl is freed. Fix
> this by accessing alg before free tmpl.
> 
> Fixes: 9363efb4 ("crypto: qce - Add support for AEAD algorithms")
> Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>


Acked-by: Thara Gopinath <thara.gopinath@linaro.org>

-- 
Warm Regards
Thara (She/Her/Hers)
> ---
>   drivers/crypto/qce/aead.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
> index 290e2446a2f3..97a530171f07 100644
> --- a/drivers/crypto/qce/aead.c
> +++ b/drivers/crypto/qce/aead.c
> @@ -802,8 +802,8 @@ static int qce_aead_register_one(const struct qce_aead_def *def, struct qce_devi
>   
>   	ret = crypto_register_aead(alg);
>   	if (ret) {
> -		kfree(tmpl);
>   		dev_err(qce->dev, "%s registration failed\n", alg->base.cra_name);
> +		kfree(tmpl);
>   		return ret;
>   	}
>   
> 

