Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8373E18595B
	for <linux-crypto@vger.kernel.org>; Wed,  4 Dec 2024 10:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733307472; cv=none; b=fkAYWRtDq52ivX1kI/NEg+mFB7oLkyNUJ+sjGVMSOar7wlOM8VvLYg+QEqdCa8PLgF5QXYlI5mI1v34NkPNS4x5orx5cHw3WoHuedLIab1EsERsZ5O4omkkJpL1a8xp+1WOfh+ti4agBnqsCt7geujZEhp6gDkde4wjRaZvwins=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733307472; c=relaxed/simple;
	bh=FYcf+TG4v3Fro3HhVWRH5fNH3rbp8QH4kvADmXi1ksY=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=MKQMfS5lBnIFk2eCnrv0xnCtTpLFl0gVLZwOg9g+eybW8xEJDV3sDEkuWYdRhQIFr964EjZ/ykCByhkvx0vqeEltPsId9Jcvs5zUkZ6N9pl/kklJIwszCLFR3Rz+5pzSfJ/tkCRO34jY3Q5miR1oXdpVLetOrphwt060jBZhxXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kA8hPaDs; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kA8hPaDs"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-434a7ee3d60so3947325e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 04 Dec 2024 02:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733307469; x=1733912269; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=82NS43ZeuZGozIY+Hjl7WSGtOlyPjP6/30XaSl/g4Ow=;
        b=kA8hPaDsKYoLOCEulGjlj6gSYV2ouYSbhHIEH3wI0TeX6981QwbbmuiFQ3yaY3ZM5s
         JxtRrZ8DIjIV2k+G9O3/18cOE2JMl+9RMd8ERv9cTXO6bdnR/JojherA3mY4ua4BwBMT
         29uFeyKZDqg3+0M37fuWbZiKS09/S/lY5T+iMHnkoWvFPLSlxPEP1mORxtHqfVtX2iHu
         /LEqkaWURmrgQLpH58DZPS9DnI6fpl6XBPSJ3RMuFXSBKjCEIMRit0ns6TYEQb15U7qK
         9WlJDl/9pPdU3IAYFWoYSwArSvjeVkespFJDCfTq6ZnGM/9M7r+s7oyFvMMbQvzU/nEx
         m6CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733307469; x=1733912269;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=82NS43ZeuZGozIY+Hjl7WSGtOlyPjP6/30XaSl/g4Ow=;
        b=RTLzb7QqesNnILx3b6pFhLdJEI/2UQYvlTE5KYrDIkKyC9WQH3VdKTta7DIC5pFtPK
         sNYex1vGpL0kutqJYcbv/Xe2NmviPMGduMzvHAAQHxksjG8QYcN0Ab244c+rNcilzRSc
         5jcsw0IhxfRjfxS+wwCnAQxGmx881A+ZSmedwgU1Qs45+egXnhrmQqxV6aqDg8UZhBH/
         yr68s3pYhX7kAvN4WMMDKjgbrQMpgsZu/lj6+4j1ITTzRNBndoxAjElfMIBQv0QVpruD
         aMHe8OCO3HhH6QHN/4gQX+pTZpjnnaC3R2KBp5GuAE5uBhWnGe04J8oMtpcOYItvurI4
         k3mg==
X-Gm-Message-State: AOJu0YywqBsRNx3q8GQtq3Bl6MWBbZmpIuyLsekfa9IubtZTyo/QP8C1
	yVMTP5gaSjZVRjwdf625GDB3jhN9uTAUHAQVWoBCiPzaO+3QtJh3+A3CSMdk/WM=
X-Gm-Gg: ASbGncsYWoRjp/fx5AoNNBR6i2voz4LgnfRnnFCuHKSP5x0oQsANNq3UP2cT2i0hWZL
	2IP2WopPnesQnFMHamOC3oBlR8/RgZr2n4Ej9E+N7Vz+QOtlMQhfFgIazjuDbTgX1yr2Fzk666U
	WSsboBuJs60LFPz8MJeCMIx+N86MkTv5UOYPiC/EBkEinKIVV1mjGxFRKdyUnWO0UurivN7lQ9t
	OcilxkFfJt3y015cj4y/Aq3dfKYOcFqnu05lfy/jVAAgM5Q29cRBiJyMOckS4b9jPU9jMJRE+Wj
	wjJa+PbWL9UZWnJD3e8AWHjQ
X-Google-Smtp-Source: AGHT+IG6D7KwX+tf7CMNPdvfPMNMtR1LpEMO49ikb8Hoq7QCYVi8fl5TrfF5cKG7Aa3SSTtKGYQpQQ==
X-Received: by 2002:a7b:cb90:0:b0:431:416e:2603 with SMTP id 5b1f17b1804b1-434afb8df3amr229011835e9.3.1733307468986;
        Wed, 04 Dec 2024 02:17:48 -0800 (PST)
Received: from ?IPV6:2a01:e0a:982:cbb0:740:b323:3531:5c75? ([2a01:e0a:982:cbb0:740:b323:3531:5c75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434d52165c3sm20085525e9.0.2024.12.04.02.17.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 02:17:48 -0800 (PST)
Message-ID: <af4c67a6-9ed6-4174-a41e-95b03ab96166@linaro.org>
Date: Wed, 4 Dec 2024 11:17:46 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: neil.armstrong@linaro.org
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH 9/9] crypto: qce - switch to using a mutex
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
 Thara Gopinath <thara.gopinath@gmail.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Stanimir Varbanov <svarbanov@mm-sol.com>
References: <20241203-crypto-qce-refactor-v1-0-c5901d2dd45c@linaro.org>
 <20241203-crypto-qce-refactor-v1-9-c5901d2dd45c@linaro.org>
 <d6220576-eaf5-4415-b25f-b5984255ab78@linaro.org>
 <CAMRc=MevaM4tUNQUs_LjFYaUtDH=YqE-t2gBponGqtK5xE9Gpw@mail.gmail.com>
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
In-Reply-To: <CAMRc=MevaM4tUNQUs_LjFYaUtDH=YqE-t2gBponGqtK5xE9Gpw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/12/2024 16:10, Bartosz Golaszewski wrote:
> On Tue, 3 Dec 2024 14:53:21 +0100, neil.armstrong@linaro.org said:
>> On 03/12/2024 10:19, Bartosz Golaszewski wrote:
>>> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>>>
>>> Having switched to workqueue from tasklet, we are no longer limited to
>>> atomic APIs and can now convert the spinlock to a mutex. This, along
>>> with the conversion from tasklet to workqueue grants us ~15% improvement
>>> in cryptsetup benchmarks for AES encryption.
>>
>> Can you share on which platforms you did the tests and the results you got ?
>>
> 
> Sure, I tested on sm8650 with the following results (they vary from
> one run to other but are more or less in this range):
> 
> With this series:
> 
> #     Algorithm |       Key |      Encryption |      Decryption
>          aes-cbc        128b        94.1 MiB/s       138.6 MiB/s
>      serpent-cbc        128b               N/A               N/A
>      twofish-cbc        128b               N/A               N/A
>          aes-cbc        256b        94.8 MiB/s       128.5 MiB/s
>      serpent-cbc        256b               N/A               N/A
>      twofish-cbc        256b               N/A               N/A
>          aes-xts        256b       132.9 MiB/s       131.8 MiB/s
>      serpent-xts        256b               N/A               N/A
>      twofish-xts        256b               N/A               N/A
>          aes-xts        512b       122.6 MiB/s       122.4 MiB/s
>      serpent-xts        512b               N/A               N/A
>      twofish-xts        512b               N/A               N/A
> 
> Without it:
> 
> #     Algorithm |       Key |      Encryption |      Decryption
>          aes-cbc        128b        96.4 MiB/s       141.0 MiB/s
>      serpent-cbc        128b               N/A               N/A
>      twofish-cbc        128b               N/A               N/A
>          aes-cbc        256b        67.0 MiB/s        97.8 MiB/s
>      serpent-cbc        256b               N/A               N/A
>      twofish-cbc        256b               N/A               N/A
>          aes-xts        256b       131.7 MiB/s       132.0 MiB/s
>      serpent-xts        256b               N/A               N/A
>      twofish-xts        256b               N/A               N/A
>          aes-xts        512b        93.9 MiB/s        96.8 MiB/s
>      serpent-xts        512b               N/A               N/A
>      twofish-xts        512b               N/A               N/A
> 
> AES-CBC and AES-XTS with shorter keys remain pretty much the same. I'm not
> sure why that is. I also tested on sa8775p but there are no visible
> improvements there. :(

Thanks for the results !

Neil

> 
> Bart

