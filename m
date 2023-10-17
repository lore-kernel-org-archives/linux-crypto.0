Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8658BCDB474
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Oct 2023 07:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbjJQHNi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Oct 2023 03:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234695AbjJQHNh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Oct 2023 03:13:37 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C348F9
        for <linux-crypto@vger.kernel.org>; Tue, 17 Oct 2023 00:13:33 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-5079f3f3d7aso4830696e87.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Oct 2023 00:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697526812; x=1698131612; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :references:cc:to:content-language:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jrizillEfaAgp0SRrsU3iFgwZ8wya1sI3h5VbmShlHs=;
        b=nckTyamFq2pRfLQUb3Lak2OEigBXpLVg780tvr/AwMiE1rVluu0oS9Wm2IpCQTbs07
         eAlpLaTRHpd42bwZ2V/al2iDFxSG4i5s2/Fd3K76tY+o2Lu5v+4MMatXRVkmD0xdo0Mn
         DgyCGDkTtjXoXrQvY/2trHTDd0RrsH6Bm+A384X0eCNpNyXmQukfng8iffZ6xGoxdjWN
         nEE/Vruf+dyEvP722wx9UBXIfrhNlQrFTU2IReEoV8AoEyVhJnytVBIDcSZd6Li12LpA
         r1poX7kQfCgdVGae81ouRWC8VkoUU6yF/t/vfy0Ae5FM1fQBonwKgmNk1wu7JTMARl92
         xLEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697526812; x=1698131612;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :references:cc:to:content-language:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jrizillEfaAgp0SRrsU3iFgwZ8wya1sI3h5VbmShlHs=;
        b=dIfMXEFMX636Y2Va1RT6HlPb/LLmlL4Oiel/3sz/GhD3md5SMyObI1IbZexaBNQ3NP
         V7FLteJqHG8sbGrw0oCevRZi/Q06kElXzdsR52v1U19MuV7cJjHwJQa6y+ZaiI+LyxL7
         JiiPlMqfAI5EqxuGpVRMxLFYSckRNAFTrxZNeeI9fcl4Dx+De/0Kn0QsO26hbX+JqvL+
         /ww+bYjOBLw1YAtZTGEzeHxNcV5n2dGtUhMQKQHfuNLEw4unZ/0N1Ny+eNXX15uDc/CP
         KIEvT8O37pbC4sMbHpcIsxEYHVbcb6ND7Z4pn8J3FqB+9O0UQBJMBDBAJm0adH26DhQ1
         kvgg==
X-Gm-Message-State: AOJu0YyH8nCcie9OpU2axfz3mPRFFa+uqDg5HynRCi0tCU1SrUH0xhvr
        KMD6HmJh6N8Wf8qY8ZXWaKUV3bbDgI1zkC7TkSTyKzpc
X-Google-Smtp-Source: AGHT+IELn2HMk+X2+I7J5BIVYNU6Z4AP7odyWZ/M4gv6njV1yvgA0XpKY4zh23tyX0Z7YvoKR5HHlw==
X-Received: by 2002:a05:6512:b96:b0:504:2d54:b4d0 with SMTP id b22-20020a0565120b9600b005042d54b4d0mr1482003lfv.19.1697526811804;
        Tue, 17 Oct 2023 00:13:31 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:97ef:6513:8029:4596? ([2a01:e0a:982:cbb0:97ef:6513:8029:4596])
        by smtp.gmail.com with ESMTPSA id n7-20020a05600c4f8700b00406408dc788sm9180427wmq.44.2023.10.17.00.13.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Oct 2023 00:13:31 -0700 (PDT)
Message-ID: <6118cb58-cdfa-458d-a034-d0422d79ae45@linaro.org>
Date:   Tue, 17 Oct 2023 09:13:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From:   Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH] crypto: qcom: add HW_RANDOM dependency
Content-Language: en-US, fr
To:     Arnd Bergmann <arnd@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Om Prakash Singh <quic_omprsing@quicinc.com>,
        Bjorn Andersson <quic_bjorande@quicinc.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20231016200324.757455-1-arnd@kernel.org>
Autocrypt: addr=neil.armstrong@linaro.org; keydata=
 xsBNBE1ZBs8BCAD78xVLsXPwV/2qQx2FaO/7mhWL0Qodw8UcQJnkrWmgTFRobtTWxuRx8WWP
 GTjuhvbleoQ5Cxjr+v+1ARGCH46MxFP5DwauzPekwJUD5QKZlaw/bURTLmS2id5wWi3lqVH4
 BVF2WzvGyyeV1o4RTCYDnZ9VLLylJ9bneEaIs/7cjCEbipGGFlfIML3sfqnIvMAxIMZrvcl9
 qPV2k+KQ7q+aXavU5W+yLNn7QtXUB530Zlk/d2ETgzQ5FLYYnUDAaRl+8JUTjc0CNOTpCeik
 80TZcE6f8M76Xa6yU8VcNko94Ck7iB4vj70q76P/J7kt98hklrr85/3NU3oti3nrIHmHABEB
 AAHNKk5laWwgQXJtc3Ryb25nIDxuZWlsLmFybXN0cm9uZ0BsaW5hcm8ub3JnPsLAkQQTAQoA
 OwIbIwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgBYhBInsPQWERiF0UPIoSBaat7Gkz/iuBQJk
 Q5wSAhkBAAoJEBaat7Gkz/iuyhMIANiD94qDtUTJRfEW6GwXmtKWwl/mvqQtaTtZID2dos04
 YqBbshiJbejgVJjy+HODcNUIKBB3PSLaln4ltdsV73SBcwUNdzebfKspAQunCM22Mn6FBIxQ
 GizsMLcP/0FX4en9NaKGfK6ZdKK6kN1GR9YffMJd2P08EO8mHowmSRe/ExAODhAs9W7XXExw
 UNCY4pVJyRPpEhv373vvff60bHxc1k/FF9WaPscMt7hlkbFLUs85kHtQAmr8pV5Hy9ezsSRa
 GzJmiVclkPc2BY592IGBXRDQ38urXeM4nfhhvqA50b/nAEXc6FzqgXqDkEIwR66/Gbp0t3+r
 yQzpKRyQif3OwE0ETVkGzwEIALyKDN/OGURaHBVzwjgYq+ZtifvekdrSNl8TIDH8g1xicBYp
 QTbPn6bbSZbdvfeQPNCcD4/EhXZuhQXMcoJsQQQnO4vwVULmPGgtGf8PVc7dxKOeta+qUh6+
 SRh3vIcAUFHDT3f/Zdspz+e2E0hPV2hiSvICLk11qO6cyJE13zeNFoeY3ggrKY+IzbFomIZY
 4yG6xI99NIPEVE9lNBXBKIlewIyVlkOaYvJWSV+p5gdJXOvScNN1epm5YHmf9aE2ZjnqZGoM
 Mtsyw18YoX9BqMFInxqYQQ3j/HpVgTSvmo5ea5qQDDUaCsaTf8UeDcwYOtgI8iL4oHcsGtUX
 oUk33HEAEQEAAcLAXwQYAQIACQUCTVkGzwIbDAAKCRAWmrexpM/4rrXiB/sGbkQ6itMrAIfn
 M7IbRuiSZS1unlySUVYu3SD6YBYnNi3G5EpbwfBNuT3H8//rVvtOFK4OD8cRYkxXRQmTvqa3
 3eDIHu/zr1HMKErm+2SD6PO9umRef8V82o2oaCLvf4WeIssFjwB0b6a12opuRP7yo3E3gTCS
 KmbUuLv1CtxKQF+fUV1cVaTPMyT25Od+RC1K+iOR0F54oUJvJeq7fUzbn/KdlhA8XPGzwGRy
 4zcsPWvwnXgfe5tk680fEKZVwOZKIEuJC3v+/yZpQzDvGYJvbyix0lHnrCzq43WefRHI5XTT
 QbM0WUIBIcGmq38+OgUsMYu4NzLu7uZFAcmp6h8g
Organization: Linaro Developer Services
In-Reply-To: <20231016200324.757455-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 16/10/2023 22:02, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The driver now calls into the hwrng subsystem and causes a link failure if that
> is not reachable:
> 
> x86_64-linux-ld: vmlinux.o: in function `qcom_rng_probe':
> qcom-rng.c:(.text+0xfefc7e): undefined reference to `devm_hwrng_register'
> 
> Add a Kconfig dependency as we have for the pure hw_random drivers. I see
> that there are some other crypto drivers that instead use 'select HW_RANDOM',
> but those seem to be mistakes as that may lead to circular dependencies,
> and a simple driver should not force-enable an entire subsytem.
> 
> Fixes: f29cd5bb64c25 ("crypto: qcom-rng - Add hw_random interface support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/crypto/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index c761952f0dc6d..79c3bb9c99c3b 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -601,6 +601,7 @@ config CRYPTO_DEV_QCE_SW_MAX_LEN
>   config CRYPTO_DEV_QCOM_RNG
>   	tristate "Qualcomm Random Number Generator Driver"
>   	depends on ARCH_QCOM || COMPILE_TEST
> +	depends on HW_RANDOM
>   	select CRYPTO_RNG
>   	help
>   	  This driver provides support for the Random Number

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
