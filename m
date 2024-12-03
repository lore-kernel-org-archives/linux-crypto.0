Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C9E1EE006
	for <linux-crypto@vger.kernel.org>; Tue,  3 Dec 2024 13:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733234117; cv=none; b=VrrIxzNx9xAoyiC41S5blV+5u7+EK9ko927SfVxyozlP20Ofg/ve8+wjYaN7oR32cisHSsXe4DSdVMOrdN8LklDu1z5vVFVQ8lH/oHBDBfn8cci9ADG0Vp8o8XtdYpcUVWM4mSDIenbxeLmZRkBnsxs+e3qFN8P8vOnCBN29Lds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733234117; c=relaxed/simple;
	bh=mle9UUb7dDskLtd9jCH9QqWnYl8wSrz63i6CvmV7vXA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=RH8Zklfx+uKH/5v4qHAP+EX/lYFRYvxuwFnDe6UDGC2CJbJfIE1T+M0Ag4pvj1LOABCldnQnpmED5n4X9TBYQ6Ql+hOZ3nuL61CX5upkzx2Q+v5+gOEOAmg1ZH1UxrHy8t/9rRkhBPsmmnSCgcKZUpwW9k4bHSx5NGAXqdQZMwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dqnCpyNj; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dqnCpyNj"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-434a45f05feso68675505e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 03 Dec 2024 05:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733234114; x=1733838914; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gz+l3KqObW/HJFvDTOv2iIjYIEIUxrukQz2sYdYBT8s=;
        b=dqnCpyNjGijGuEX4/HQfs0ORJbyiO2qrZUfkpvhuJBMOAAs3fj+kRSrNPS9+qA6p0X
         aqFOMLenlOaGS6gsxD8DgXpo4VM103k0d9wfvBE4a7g41PZLb6IJeuCf+9zkXOv9JS/9
         wkmXuCnzzVkyQdW/km5AyhUSzOjz/dBfCj+pgU7hZ7tq0FkCZZO2dPQ4ojBWYJM/bGsd
         mMvzkxOmrioMP7zd85+FODqysa4P/2awx96fJyhA13nLawuywC7j3CeyW/+pqc0lGLyq
         +7UrbkalMXACAwftQhn+mcL+pW7VqwNQQVnoCcdRAXCz9hj3fRFw7hmR2eaPbpa5yA5F
         aW8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733234114; x=1733838914;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gz+l3KqObW/HJFvDTOv2iIjYIEIUxrukQz2sYdYBT8s=;
        b=qYs4O2YNhwP28l+wucuPzdI1H7QWB4ksR008zgdaSBYxFQ9MthKEi8+uDwbbx/SNBI
         gkQHt4ETx3KkMiQ/MXmgueY83jAbr5y9f1PDEzoLkQg2fh5/S1BM5XOFbVMVPzknuCJP
         bt5iGrTZxMkNeyYCRRmYXfrsvLTgdwcuWO2fTO6JNq/YF5IpHP9J8p7xpcYbVJp6NBOM
         17+3SD/aszqEKS1NUmNN+QAC88tg0BTGiOi66caCXpwZdmIxwGy048Ep0xzgEYk7qJj+
         7a55C9+XwND3Ua4RuXHdClfjc4AGamZS/s6qsuu9o87DyXbH7HtUZ2c+ZzUTU3hdPZjo
         6UJg==
X-Gm-Message-State: AOJu0YwHXFIIUl+Wqs/I6MLeNipZ61Uwb6ENt5XiEGXKGY6+ztJdDwQX
	+20Jn+DmVgDDYfMqt+EiGUdJc6fCrzMANEYSQFPYEEdUqniIZvwrGgNZC2r7BtA=
X-Gm-Gg: ASbGncs4qMJkCg8kIXDs59i1rVBRVZz6CvFpxsaozCS7Dzs6NHBcQngiKsrhhHpqSNm
	AbMNIXv9gMGz2axdEw4nmB6xED4ARCHRWCmsL/jQ1uiz2eb4JY0zpdnkTzjSWwC6AHDpBGs6/Km
	/sraJu26MgKlpe8zR1sEGyl8aNA8e1CUlOGicUjQ9QcGcAl5ZQZusK0YLoK3U3jZQLlyov2CwDI
	/4bbkhkrTh5Gh3b5m1vTjfx8tO2A7Cc3EBeGG2dfIQ6Txa11in+nImuN5XVRzZ0R0+gg109kp6p
	gZSWCobM94gwGOrVZM9k9UGi
X-Google-Smtp-Source: AGHT+IHO5v4mBO5cO68x6c9dihydjdMPOihkNn60wLtRB6InkOSEoDsCz6rUvo0qtKSH5DZhekNFlg==
X-Received: by 2002:a05:600c:3502:b0:431:24c3:dbaa with SMTP id 5b1f17b1804b1-434d09b2e2cmr24599645e9.2.1733234114210;
        Tue, 03 Dec 2024 05:55:14 -0800 (PST)
Received: from ?IPV6:2a01:e0a:982:cbb0:b668:b88:4ecf:c065? ([2a01:e0a:982:cbb0:b668:b88:4ecf:c065])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434b0f32594sm193399585e9.32.2024.12.03.05.55.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 05:55:13 -0800 (PST)
Message-ID: <b3e5184d-19bc-45ed-92e3-a751842839b3@linaro.org>
Date: Tue, 3 Dec 2024 14:55:12 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: neil.armstrong@linaro.org
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH 2/9] crypto: qce - unregister previously registered algos
 in error path
To: Bartosz Golaszewski <brgl@bgdev.pl>,
 Thara Gopinath <thara.gopinath@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, stable@vger.kernel.org
References: <20241203-crypto-qce-refactor-v1-0-c5901d2dd45c@linaro.org>
 <20241203-crypto-qce-refactor-v1-2-c5901d2dd45c@linaro.org>
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
In-Reply-To: <20241203-crypto-qce-refactor-v1-2-c5901d2dd45c@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/12/2024 10:19, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> If we encounter an error when registering alorithms with the crypto
> framework, we just bail out and don't unregister the ones we
> successfully registered in prior iterations of the loop.
> 
> Add code that goes back over the algos and unregisters them before
> returning an error from qce_register_algs().
> 
> Cc: stable@vger.kernel.org
> Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>   drivers/crypto/qce/core.c | 11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> index 58ea93220f015..848e5e802b92b 100644
> --- a/drivers/crypto/qce/core.c
> +++ b/drivers/crypto/qce/core.c
> @@ -51,16 +51,19 @@ static void qce_unregister_algs(struct qce_device *qce)
>   static int qce_register_algs(struct qce_device *qce)
>   {
>   	const struct qce_algo_ops *ops;
> -	int i, ret = -ENODEV;
> +	int i, j, ret = -ENODEV;
>   
>   	for (i = 0; i < ARRAY_SIZE(qce_ops); i++) {
>   		ops = qce_ops[i];
>   		ret = ops->register_algs(qce);
> -		if (ret)
> -			break;
> +		if (ret) {
> +			for (j = i - 1; j >= 0; j--)
> +				ops->unregister_algs(qce);
> +			return ret;
> +		}
>   	}
>   
> -	return ret;
> +	return 0;
>   }
>   
>   static int qce_handle_request(struct crypto_async_request *async_req)
> 

Perhaps you can also use the devm trick here aswell ?

Neil
