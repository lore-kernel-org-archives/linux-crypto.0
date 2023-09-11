Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6248ECA0EC7
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Sep 2023 21:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353849AbjIKVvG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Sep 2023 17:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236392AbjIKKdo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Sep 2023 06:33:44 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB08E5F
        for <linux-crypto@vger.kernel.org>; Mon, 11 Sep 2023 03:33:39 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-401d80f4ef8so45604265e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 11 Sep 2023 03:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694428417; x=1695033217; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :references:cc:to:content-language:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hd5+bavmQbtOKvL+wey92Vxqp4guJA0VMGCPEUn7ND4=;
        b=OcN3pzI+cftP7u1zx8oh7h+ytbnm6G1s3UGRke/JIt53C6kjU8cZWmZNwTr97cWyFn
         cxi8uRmaTCl9ljdxGQZLf1+ivEYaZSxMEf3nm+1eqj0sF+60Nr6/KT+mUQ8YpLOoIOOV
         joTy8Rw92yPqmxxPnX3kKzVK/6QDbQvwYwCl4kU4BASVvby2G+1yIppS/0O/PeKbgmTP
         vCuDiK8ZHilHB3EXn/aTzUPeeNUw9IpPgzmM6eRaP8NaOi1s/+WQDYuMupHqX+BhiaZi
         uVELXkrlikpJQ2pTnIRxKjSE2xyUbAsGo5N2rmAZXJeUSpPo3CLPbv7mjYVCDYuYmIli
         r/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694428417; x=1695033217;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :references:cc:to:content-language:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hd5+bavmQbtOKvL+wey92Vxqp4guJA0VMGCPEUn7ND4=;
        b=W8hOU7qzPJAR4cpBMT6iQdW8xHdEtFh2ObOI/GM0O755ah798WMYhaKpDTe07sOwT0
         u5ioM93wC1x6Z/1QaMQC8ItHJJCxedXefEpbUZ0eOObW/MRPkTTD2OAkyVDgDxBLagK1
         kT51v2RDHFc8sUfXu13lbNOqLL89cF2fBhQtS4mjjAiR70xvgPeLq900PRSMIQR5AbMV
         BG8jMvW0PF9tgK+5fEKadYCMFAyuDD9RpxzQRIMGcy7/duMLryZMrOR21rM5RyU6wbAU
         IYGk1x3Jug6mhhtzPPtiYl9Q2f3f0+c6uCQfTQxUyZ5201KhNH/INvtVU5R3a6L+sWTs
         MVOQ==
X-Gm-Message-State: AOJu0Yws8oTycasC6Udl3pFUoXBh6Z5+vC51LNpqUnRtEvlLC/I5rtLE
        98G2doAxBiDlIaSqHFEyzUzrQw==
X-Google-Smtp-Source: AGHT+IHVdvs08TyzRIACfwL0Gt+0zksvifLWePCc/mECez0aCu5F00s8w2auWW3JiOasBbnRnPrQnA==
X-Received: by 2002:a05:600c:2196:b0:401:b493:f7c1 with SMTP id e22-20020a05600c219600b00401b493f7c1mr8249860wme.35.1694428417556;
        Mon, 11 Sep 2023 03:33:37 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:daaa:8bc3:eeb7:ce8? ([2a01:e0a:982:cbb0:daaa:8bc3:eeb7:ce8])
        by smtp.gmail.com with ESMTPSA id r17-20020adfce91000000b003198a9d758dsm9726204wrn.78.2023.09.11.03.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Sep 2023 03:33:37 -0700 (PDT)
Message-ID: <d226525d-b025-48c8-8176-4a3356ba23b8@linaro.org>
Date:   Mon, 11 Sep 2023 12:33:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From:   neil.armstrong@linaro.org
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH v3 3/3] arch/arm64: dts: meson-s4: add hwrng node
Content-Language: en-US, fr
To:     Alexey Romanov <avromanov@salutedevices.com>,
        narmstrong@baylibre.com, olivia@selenic.com,
        herbert@gondor.apana.org.au, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        conor@kernel.org, khilman@baylibre.com, jbrunet@baylibre.com,
        martin.blumenstingl@googlemail.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com, lists@kaiser.cx
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        kernel@sberdevices.ru, Alexey Romanov <avromanov@sberdevices.ru>
References: <20230911101129.10604-1-avromanov@salutedevices.com>
 <20230911101129.10604-4-avromanov@salutedevices.com>
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
In-Reply-To: <20230911101129.10604-4-avromanov@salutedevices.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/09/2023 12:11, Alexey Romanov wrote:
> From: Alexey Romanov <avromanov@sberdevices.ru>
> 
> Using this node, we can obtain random numbers via
> hardware random number generator.
> 
> Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
> ---
>   arch/arm64/boot/dts/amlogic/meson-s4.dtsi | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
> index f24460186d3d..b3a1ecf36467 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
> @@ -133,6 +133,11 @@ reset: reset-controller@2000 {
>   				reg = <0x0 0x2000 0x0 0x98>;
>   				#reset-cells = <1>;
>   			};
> +
> +			hwrng: rng@440788 {
> +				compatible = "amlogic,meson-s4-rng";
> +				reg = <0x0 0x440788 0x0 0x0c>;
> +			};
>   		};
>   	};
>   };

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
