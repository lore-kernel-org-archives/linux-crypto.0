Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF74B1F12FB
	for <linux-crypto@vger.kernel.org>; Tue,  3 Dec 2024 13:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733233954; cv=none; b=D2UUavvfNQfyhwjS9/SZ4nA8WhaADc5MJzEPrALJ7NG1y/la3SYlukxRRy430SQO8IQ1jgcj+KQFQNWFC8i1lNtQNqWaylQS0YP8iqZOZ8ltFsrP7H7S63FIQYAELQyvH4xsDawz+lK/Vse2fWtUnAoKFzOWRvH/lHu3ntto44Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733233954; c=relaxed/simple;
	bh=vQyNRZyfktd4dZ/VfxPnrD450fKtsTU4U0K5AmvMOA4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=fOAxOq0Uj6VWiHLm35IHph4fLv5FBtS7Q5GdpzNLb4KLushuoAz1O4CHNI5c7qTq9FBOy1eOXO+YVpkwMn0PFrsDGhskThf+9YH1OjlFzD3QrDGB5Nayv48vI5McKOHa4KY58HSKk5eo3f29c+d/5QKr6bwBZx0rHjKLRPhiSeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qZg3N+y+; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qZg3N+y+"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-385e0e224cbso2603456f8f.2
        for <linux-crypto@vger.kernel.org>; Tue, 03 Dec 2024 05:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733233950; x=1733838750; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ABkNR+66cga4jI8z0RZ2Hsh7LoVsEWiOT9UTom3Spu8=;
        b=qZg3N+y+GRR/kFH8MEewLuHAVvQpTuAxENwx9L+wxRu2/O2zN6+SvstcTF8fM0QETO
         0HK/6unrkmCwx4xq7HJgig8weVC91HzrRAsc8vJ1IcHD+LgYNZDdk+SQj5dI61XAmqp3
         I8ALwMzlwvImrR5RWd/nVBFTJF7USfYMGm49s4nfhHXk2CdwOaMKIHvEq5F7ViY56Eg4
         xe00RVnvLV/dG7g8xw32Z2uawtn6USxyP9Jw1guHMVLuqrbsXpeFvukB83ZjVwZ+5VyV
         bEaC0Xhe3F1qVbuWIo7KlDNWt2x94r9PxMgkouLgVA9WfE/sSV3grz+fFYyY1T7ZrRmq
         TgGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733233950; x=1733838750;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ABkNR+66cga4jI8z0RZ2Hsh7LoVsEWiOT9UTom3Spu8=;
        b=btF5Hs/dK7r+KIfWtpkZP9YqZ4Z0BIkW0N69YTNPejrn8MXvBQrP0tobojmoYCALQe
         Dlgy54KIjz70eHcd/APgUvEAlEH4OQyw6O0O12zBNHO1dpCFG4Gy8Vk4OxwPpO1QPrGo
         5w9h6SxHsBqcn3YDMPS9Ksn8O8uUTG1A5dPCwExCB3pe6v84sDTEYDo+7jJZXvCUO54V
         0VuVd4VRA6NARz18snujjA94aLuxDMOyW+63FRtIxLscgbDFQT6rsFxXQafGilnNVgqA
         8khx/xd0iHMLBU18u3fSS7rJu3BUQjTKUAzFiWwKh67Gt6Zt6UNu0kMzZZGSVm6PnCrs
         kxCw==
X-Gm-Message-State: AOJu0YzW6rMYvjhcP/+RAMw9ZdfCYo2lK8GQysrSlNa8Zu6vxSHfsPlQ
	OiBS7NnsZawnIs2OMGpSjYbh0QcNJHInP5MlirY5yObUu1U9VUqjexTQeA0OC4c=
X-Gm-Gg: ASbGncvH1u2qBAP7M/4drvBXI+j2/MDxKcj/TYYqh+14b5x4iUW40a5FgtT3+86OTz+
	rcDwe4Pd7Ik7L9AH+IPIRVWP3MtWQQVZv7rUSyD2G0OI3pzSgZ2iTeLYQMOHILNvvYumSqzRpec
	VZxX/jVDdTpAo8nDSreMprBAHmEVVQo7XVplkOqA8ECwFKkY7ZdDpNNuWZUxO12O22yRGuTVvUu
	SB6qh4f3Mu661xZMaGc4kJHnxSATXZQ3mhT4HUvpCQmS5Hc3Sfm3jxQqGPMivmwe1w9Z8qjuNXd
	2tMmIRSRBwZpwsK/p4dyN4DZ
X-Google-Smtp-Source: AGHT+IFkJh1EUhfAJne4bE1d9lfMNE+K3tGMuLLZgbRBdMCN+TtCafvJ11ltFQ+c8Zv8qJ9vt2sg9Q==
X-Received: by 2002:a5d:47cb:0:b0:385:e8b0:df13 with SMTP id ffacd0b85a97d-385fd437301mr2434207f8f.40.1733233949965;
        Tue, 03 Dec 2024 05:52:29 -0800 (PST)
Received: from ?IPV6:2a01:e0a:982:cbb0:b668:b88:4ecf:c065? ([2a01:e0a:982:cbb0:b668:b88:4ecf:c065])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-385ccd3a710sm15397849f8f.57.2024.12.03.05.52.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 05:52:29 -0800 (PST)
Message-ID: <d0d4ce7a-033a-4a5f-8952-1cb46b24b8ce@linaro.org>
Date: Tue, 3 Dec 2024 14:52:28 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: neil.armstrong@linaro.org
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH 7/9] crypto: qce - use __free() for a buffer that's always
 freed
To: Bartosz Golaszewski <brgl@bgdev.pl>,
 Thara Gopinath <thara.gopinath@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20241203-crypto-qce-refactor-v1-0-c5901d2dd45c@linaro.org>
 <20241203-crypto-qce-refactor-v1-7-c5901d2dd45c@linaro.org>
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
In-Reply-To: <20241203-crypto-qce-refactor-v1-7-c5901d2dd45c@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/12/2024 10:19, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> The buffer allocated in qce_ahash_hmac_setkey is always freed before
> returning to use __free() to automate it.

I think you wanted to use "so" instead of "to", otherwise it means nothing ^^

> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>   drivers/crypto/qce/sha.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
> index fc72af8aa9a72..916908c04b635 100644
> --- a/drivers/crypto/qce/sha.c
> +++ b/drivers/crypto/qce/sha.c
> @@ -3,6 +3,7 @@
>    * Copyright (c) 2010-2014, The Linux Foundation. All rights reserved.
>    */
>   
> +#include <linux/cleanup.h>
>   #include <linux/device.h>
>   #include <linux/dma-mapping.h>
>   #include <linux/interrupt.h>
> @@ -336,7 +337,6 @@ static int qce_ahash_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
>   	struct scatterlist sg;
>   	unsigned int blocksize;
>   	struct crypto_ahash *ahash_tfm;
> -	u8 *buf;
>   	int ret;
>   	const char *alg_name;
>   
> @@ -370,7 +370,8 @@ static int qce_ahash_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
>   				   crypto_req_done, &wait);
>   	crypto_ahash_clear_flags(ahash_tfm, ~0);
>   
> -	buf = kzalloc(keylen + QCE_MAX_ALIGN_SIZE, GFP_KERNEL);
> +	u8 *buf __free(kfree) = kzalloc(keylen + QCE_MAX_ALIGN_SIZE,
> +					GFP_KERNEL);
>   	if (!buf) {
>   		ret = -ENOMEM;
>   		goto err_free_req;
> @@ -382,7 +383,6 @@ static int qce_ahash_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
>   
>   	ret = crypto_wait_req(crypto_ahash_digest(req), &wait);
>   
> -	kfree(buf);
>   err_free_req:
>   	ahash_request_free(req);
>   err_free_ahash:
> 

With the typo fixes:

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>

