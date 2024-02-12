Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7973F8C8
	for <linux-crypto@vger.kernel.org>; Mon, 12 Feb 2024 17:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707757479; cv=none; b=hlcwrlAV4cLk57a5/B/t4ktRjhFbLyYOZYzSWwgiXXWca+aEcXz4DtR/wbiYUZ6d7SvCNBCml5FH9A24X5jUfrj7pzDsie46lhijjELJuVPEuubHjmt+cbMaTlyojYAPoqwEkHMF9bqiXAU7bZL8W5yi+LjjJh4aZztfDg0b8T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707757479; c=relaxed/simple;
	bh=Opp+xhBrb/Y2lPvfhLZEGK0/2jcMTkN5dUMH61tigio=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=A9MSRQIe/BZz+bvp3cPbaM6yhnKQKTfHMjpDI3kPpCs8tCFABlEGm+TP2ucOzgKElPqnut5YeB+sapKCxMMpqK7MlAR6SVi1nTq8zio/Zw9mD/N9ohpxvq+dcuopv+S2H2saO23emF4MJQPexFFq1DpyY03TlzGwYKgmpiL3Gpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NgYh8E+b; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NgYh8E+b"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-40f02b8d176so28509725e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 12 Feb 2024 09:04:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707757475; x=1708362275; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :references:cc:to:content-language:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TCiCJbR2fFWNQTiu09VOn5xEOdbx6D5LzB/153ytI5k=;
        b=NgYh8E+bSGkgeUWPM3YZRrOXFx7jlhXAvL7qFokWgDYn2Cq+PRh/VAPOk1kVyZZy64
         iAdIV2SE5yni8tK8LMnUfniA1GKr+jXDhvwlCXPmLSM0HT29YOXXKnBo9c7nEEGOe5ie
         C4xqzb7HB2wDGj80ChA9RnunkHYJfNwyhpb6dIcD5bcqcLUC/IYm26WvTiuK3mmaKVXp
         HPAYGBUMXidRV5oTUrg8djoxCH3y7hze+ktb8Wy2pXM8EebMzLwyaLqwOQgKTnjx5eQL
         DCqoU2y4LTqGeOdnPQyqt0qc4zsth6WcuLZ6ewmiA2LzvLjOSAf3PMTosKU3YkiN1y9L
         BX1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707757475; x=1708362275;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :references:cc:to:content-language:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TCiCJbR2fFWNQTiu09VOn5xEOdbx6D5LzB/153ytI5k=;
        b=swkzv1Fc19enMlfj0Jaf8cKWlh0dPBhuFIWyKm8KuDovA+H4C90xxjNJvjljOBIukC
         x2bCWjCFbgmzJqyo/SzjS6UxWAcKZkyK3mfxa90VOPC0b++DHhlXTOGYkNAje8IiEGQw
         kGyGciwGwxdWbF3kMEQU1rlU8CNQBNHO+E3nyeu64EEdsY4uYeGasygBHMejEIubm9JZ
         kNvvxXO8WCfSUmZSqNG+dy/GV8+nVgFDXibIt7oZeOiGNLeyOAMcNZkkz3rgLMQZ18Ne
         +rNRNnVtP+W5ogjcQm433UMWJTDpR3mbh/0RzxdqUR74WIAOUv4VaM3AxC8TAJX4At9W
         zVvQ==
X-Gm-Message-State: AOJu0YwlJSyC9r33TzC7wBG1wInqiumoVQW3OXQPQ6hisC4UTS4qla6u
	Zi55XR6LInv2EUsXsGiu+KswA8mW0BycifyeQcIpeI0wY87kEyllu7/Zi3STQc0=
X-Google-Smtp-Source: AGHT+IEVj9r0GB8WBsSsyY8MRB81zPzdWeVZbh5tR7F7nE64MMR9Fg9HfefBpCGR2loSH1mGvnencw==
X-Received: by 2002:a05:600c:3b87:b0:410:cbc5:b4ab with SMTP id n7-20020a05600c3b8700b00410cbc5b4abmr3235043wms.19.1707757475631;
        Mon, 12 Feb 2024 09:04:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVU/mVoQDf/+OEwVJt47fBfZs+lRKKggI9zd8lVuXp2Jj4XdIj0ouvrIspQhkhmS4WblFRFFI4tnAdJqMX8Si5KvWw3N0SBwHiMhbuD2iVPcgEfa3l4MOJXXbbhN+heYNjDIKa8OtzTbx2zjEqQ+yAJD1uX7XO0ZCD493UBebjd3HYqF7uoBZxE5XbKK+MgLNMzMr59mKaYTwNfH8dnKUgUfG9C8iFBPpg04cVeUlxXUTzA4gdxOCzBDgZPFcmsTW8ETGAzRbOjKLyAMxmR/BgEXteAH5M6s9189eCuzAjWnR/xwYxsizO/zUjVm1EN1ufpdoamLZ0R/qk2QT4/Lov0gwgoskEB5QXR6ft1+/Ns3c4DdSefe85GykiqK0TtChHz8QawODnehYMhzKZq6YDzbqb6FEef6R5RSZf9TIpqWlogK4L6VHqvN99ArKAe28XjRa8HbnE5dZVsQtf6/2B9J3RroX53XGGefvkHBIYjMUiSxfl7zjfKLOaByznVSgHhIMz8bv1XfmNBG0hMAQVivc427fMlgzhBT+4PiafT4z9FPWkJo3Z6M9FtkVlp8Wf24CIdKFXwrM5Axo9nsgevC1RJrH68dWjL
Received: from ?IPV6:2a01:e0a:982:cbb0:fcee:f026:296d:135f? ([2a01:e0a:982:cbb0:fcee:f026:296d:135f])
        by smtp.gmail.com with ESMTPSA id h16-20020a05600c351000b00410e6a6403esm2462229wmq.34.2024.02.12.09.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Feb 2024 09:04:34 -0800 (PST)
Message-ID: <847b368f-3f71-4391-85f0-e00eca24a922@linaro.org>
Date: Mon, 12 Feb 2024 18:04:33 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: neil.armstrong@linaro.org
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH v4 17/20] arch: arm64: dts: meson: a1: add crypto node
Content-Language: en-US, fr
To: Alexey Romanov <avromanov@salutedevices.com>, clabbe@baylibre.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, robh+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
 khilman@baylibre.com, jbrunet@baylibre.com,
 martin.blumenstingl@googlemail.com, vadim.fedorenko@linux.dev
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel@salutedevices.com
References: <20240212135108.549755-1-avromanov@salutedevices.com>
 <20240212135108.549755-18-avromanov@salutedevices.com>
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
In-Reply-To: <20240212135108.549755-18-avromanov@salutedevices.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/02/2024 14:51, Alexey Romanov wrote:
> This patch adds a crypto node declaration. With the
> Amlogic crypto driver we can use HW implementation
> of SHA1/224/256 and AES algo.
> 
> Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
> ---
>   arch/arm64/boot/dts/amlogic/meson-a1.dtsi | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi b/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
> index b9fd69112535..6d11e38ca3c0 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
> @@ -653,6 +653,13 @@ sd_emmc: sd@10000 {
>   				power-domains = <&pwrc PWRC_SD_EMMC_ID>;
>   				status = "disabled";
>   			};
> +
> +			crypto: crypto@6000 {
> +				compatible = "amlogic,a1-crypto", "amlogic,g12a-crypto";
> +				reg = <0x0 0x6000 0x0 0x48>;
> +				interrupts = <GIC_SPI 120 IRQ_TYPE_EDGE_RISING>;
> +				power-domains = <&pwrc PWRC_DMA_ID>;
> +			};
>   		};
>   
>   		usb: usb@fe004400 {

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
