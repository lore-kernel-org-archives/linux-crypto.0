Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DD51F4738
	for <linux-crypto@vger.kernel.org>; Tue,  3 Dec 2024 13:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733233554; cv=none; b=LiCJKWLavGF/3EjiR2WQ3YUGsKiy3y5EkCXZVfGUFNJiCEOuU2pY3i0YZFPYbpocQThvKeYD6H7qOa/5Gwvg8bD71RHNOP9UmLhU1BZ1oUs2Kfkmpno2ifJMmD/3YYt5kuuhGWoycFm6onv3h1lqWsrxNrWnD5NGCypDr2SFi6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733233554; c=relaxed/simple;
	bh=GlGFLFxkx9DQRevrZLmFiK+InFPz3jweBTqDoqK96kM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=gZpQRKdkR4bRtPeBN+Vo1/87b1EVJbX0fVcUTDgvJNyp6ntQEGP+n2EYJ0AxOWjiRKAB/EUPpnvNtNw27UmN75gU/JQe+DjcqPnP8SUlfD3VtW5IRRCrteOc3nCHbAzk2iB8d3eS7fyeA0aYbYoC0RJmDXJI5NlxOb6BtnxtTfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VDI5WFVV; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VDI5WFVV"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-385dfb168cbso2682755f8f.1
        for <linux-crypto@vger.kernel.org>; Tue, 03 Dec 2024 05:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733233551; x=1733838351; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eiGu8iByhbNDv/BuFyFFUdvZqp5bBysIB/4YrkuJL6w=;
        b=VDI5WFVVlKBQAILKHjZlnCGaZ7jky0jNJqTtI1xt+dG1zMVOcQPUq2kWi1+0Mtvkcf
         AH7E4QDVEynrAtKxQT1lzNyGHXA6l8E7VRwibeDsHX20sOSlzljMyWnuAmdBrRtndUgh
         cRNbceGU6Vw9fl8iNVYBi6pgIrDBk+JJM4slqgykD81pyFZvlEoH4jyTtx6+J5FenmYx
         MYhF/1lp8q5uTyhs2EG0OkHq3mfBbAKIMbxUwVH67aFzVplpKE0sAqh4wJD65rYBIoRL
         IskuScpBOePmy7zHeIAYPxVZ1ri4d/UqdeqIuWrp5rA9LEl5sWNbSpwyvplU6OGLH8kB
         QhEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733233551; x=1733838351;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eiGu8iByhbNDv/BuFyFFUdvZqp5bBysIB/4YrkuJL6w=;
        b=gF+y9aVYPVTlYqWXCqmTjreRVl1C/oSY2cgf/lY4b9GVKnC91MLSHhmlqju3cpYFl9
         PIDlNgM9ADrNGjnLJWrKDCkA9I2k94aIKCdtfS+rLbHPsO0ZvX1mzZMLcK+aG17Bb3AK
         WqcQcFVoIuUVaO2o+ZL1vbZwvqw8eV0B0r54Lp5/0q7Z/w7jW4KwcdNEtEea4qe4rgOz
         pA9W4D5qV3PBn56HC7lY+RIEl9tSh4AwRuvxlCjELbEQJoeFiHN9GGv4QOcdGDccd6P8
         ajzvzsvr0hHXSL6IFXZBBc3RwLV4M0cwq0E7JLHkz8SUKZcGCVymDB/hyNcEEFltMl87
         kNdQ==
X-Gm-Message-State: AOJu0YxuFU56CZghokNBqv28pvRk8WANguMkdFOHeVFSIXxDJBDskseK
	3QTKhVi+Un2DuMQfB4zStYzJGZlZ9xx/fP58JKFv4T7mK9QAdW2XDpMTIycKvwE=
X-Gm-Gg: ASbGncvukjknxBVXbnh/wT+ChR1+oQNzy1twC1jLF2jphm5yT5gdpE6CqY7yxkrjwEI
	FaWAqVf592AwZ086NsmtAQwdxgl+dnlZ6FOaGsQvumS9egQaENX47dG0PTdXFbdOXuvAqpeqCnS
	rXDeg2XtT05gflNkB1GFp/w6S8wMUKfrYRCKBoNy9SN+HSWkJ/RkjRawrUSYE1G6KKs/FbAoH/w
	utVoEDaHS0Ivkbkkbk6SLBFLvxGOQPcdxsOk+JFaiWYS1KAcu+xbX+K2wUmcyXT0wbeG2chI6wc
	/UEQMNs/7Ap6XE77E/RpK/HZ
X-Google-Smtp-Source: AGHT+IFR3RZIfTjKRyeR0jXC1Qh4UbpjEPkmqwhoQ9/lk/ngk6B1oqiy+DgsJrL0SU5IWmcaPRjp/Q==
X-Received: by 2002:a05:6000:1a86:b0:385:df59:1141 with SMTP id ffacd0b85a97d-385fd3c56a5mr2525765f8f.5.1733233551341;
        Tue, 03 Dec 2024 05:45:51 -0800 (PST)
Received: from ?IPV6:2a01:e0a:982:cbb0:b668:b88:4ecf:c065? ([2a01:e0a:982:cbb0:b668:b88:4ecf:c065])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-385f8448d32sm4019410f8f.96.2024.12.03.05.45.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 05:45:50 -0800 (PST)
Message-ID: <38579511-0265-4884-9a1b-d7e2d0bc07f5@linaro.org>
Date: Tue, 3 Dec 2024 14:45:49 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: neil.armstrong@linaro.org
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH 3/9] crypto: qce - remove unneeded call to icc_set_bw() in
 error path
To: Bartosz Golaszewski <brgl@bgdev.pl>,
 Thara Gopinath <thara.gopinath@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20241203-crypto-qce-refactor-v1-0-c5901d2dd45c@linaro.org>
 <20241203-crypto-qce-refactor-v1-3-c5901d2dd45c@linaro.org>
Content-Language: en-US, fr
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
Organization: Linaro
In-Reply-To: <20241203-crypto-qce-refactor-v1-3-c5901d2dd45c@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/12/2024 10:19, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> There's no need to call icc_set_bw(qce->mem_path, 0, 0); in error path
> as this will already be done in the release path of devm_of_icc_get().
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>   drivers/crypto/qce/core.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> index 848e5e802b92b..f9ff1dfc1defe 100644
> --- a/drivers/crypto/qce/core.c
> +++ b/drivers/crypto/qce/core.c
> @@ -234,7 +234,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
>   
>   	ret = clk_prepare_enable(qce->core);
>   	if (ret)
> -		goto err_mem_path_disable;
> +		return ret;
>   
>   	ret = clk_prepare_enable(qce->iface);
>   	if (ret)
> @@ -274,8 +274,6 @@ static int qce_crypto_probe(struct platform_device *pdev)
>   	clk_disable_unprepare(qce->iface);
>   err_clks_core:
>   	clk_disable_unprepare(qce->core);
> -err_mem_path_disable:
> -	icc_set_bw(qce->mem_path, 0, 0);
>   
>   	return ret;
>   }
> 

Indeed, Good catch

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
