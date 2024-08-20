Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A8A18EFC9
	for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2024 15:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724167173; cv=none; b=dWm4P0x/DIbDS5UBXPaKaNHZeRVdhb3QvL+xuTnYx2SvbK+MpLBR834myYEyupyaOZ49wOmrFkYp7I3HMMnq+qJ+nhetXIp5taaGoGZC1nS/NGODzfm0rvDrnMGtyQk8LmyFXxqBBPrb8IJmwrkYfFQ0YfjLPEMRGuE7oK/5oyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724167173; c=relaxed/simple;
	bh=M0lZ2DP22jfNN/C5aYt03sGQdVfogxyFNLx82l+fY0c=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=qpS7VhRzhKc9GfHNUCpZArr3KICocD/gNgAE3HxqoRiZ4v+IK+Bi9nEJvG64Qi7U7+fLLgawJ8afEnlpEKLFvSuMMxeWCczTQEiIIELebKNOjc23Yi2PhF2zh34WYSLpn10e6LG/S/ej0WI5cZjB5nyxtxcrcmS9JF9HfbtTKRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=G7Ep+/UP; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G7Ep+/UP"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-371afae614aso2028139f8f.0
        for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2024 08:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724167169; x=1724771969; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CO8k7gPS3ah2eo5Hppz8CJu9bMQrSC7MJe+A3wiVe2c=;
        b=G7Ep+/UPqFGChHWe5R/+Lv9j0L7cTLk+AaknRoV0IuiCBrc9rDkv+hmm/HlqLcMZ/U
         0IE7EMcTezUxzXD7jCvQSH3F9BUOBAuS0x0tqp1424IFYXa++G405jD5dSKX/1TOxtct
         o3jARo4739hgpCQE4eS8wv1kcWOJEufpNGQNyEl3JUZn/KOBnhStJZWP80YgBHZlcAk5
         hmtz43BomHh2TYJLV2S7sj1rcs9DUqk3OfoVrITt2k2+AS+52FYjushq/cFfhEiF4DiO
         RJSsvMI+0wrrY9Qy8RgGnuq4uZyutJyp4ybOxSNzOr6xRpLNokLDKxQ9HktSwU+M8O+e
         5VjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724167169; x=1724771969;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CO8k7gPS3ah2eo5Hppz8CJu9bMQrSC7MJe+A3wiVe2c=;
        b=cse6lxpLps87T+dRKzYbn/sd2S9hC6MwDrpOjfvr7E15Iq0xT+FQVJX4fEVXUP15eh
         q5j70J/2kz4ZBZjOIohC0sDRq9dKNYNRJT0l92/h/a8o4LqMpLPK9IAsbdKQfArGSbzn
         J2fVyaMbvlGqzC8XAHz7VgDgY54AN0ybcgbEhF2P/oCrDC5Q6yddRbajsmxP8DCIUc/O
         RMOOlSez7WuFfY6aBMIrH2fjdvT1nCXWndJWvyKsMViLiTDlNfpYILxuou62ygQQwF9i
         GHnIHUn2Dh46IqoCaKCLh/mr6hYHM1lEdyMUFRgWBcdbeMUTl4UeWr6RXf8E9WY28dDR
         63og==
X-Gm-Message-State: AOJu0YyfgDA8zWpuqAMTeUFfMGucu8u0yHPvdkec6uh9Bz18ks0UO6F9
	rFYnioY/IWF2mlopfO+m/rBrJtwA0Cbb/tKxuu+HWgK+Eu3IzBICzLbzSeuGnN4=
X-Google-Smtp-Source: AGHT+IFZv8g2osJqh6CIrgVGdxVcFJ776Ad1FAr/yJHw+toA0eOs6k0PzTFvoLjLqRM1QHuSjRpBag==
X-Received: by 2002:adf:a39a:0:b0:368:c6ff:dc94 with SMTP id ffacd0b85a97d-3719465a9fdmr8495859f8f.32.1724167168984;
        Tue, 20 Aug 2024 08:19:28 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:ebdf:8de4:37af:6aad? ([2a01:e0a:982:cbb0:ebdf:8de4:37af:6aad])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ed785708sm145468595e9.37.2024.08.20.08.19.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 08:19:28 -0700 (PDT)
Message-ID: <6e535895-6a06-42f8-abf3-e3b7472c97e0@linaro.org>
Date: Tue, 20 Aug 2024 17:19:27 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: neil.armstrong@linaro.org
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH v9 00/23] Support more Amlogic SoC families in crypto
 driver
To: Alexey Romanov <avromanov@salutedevices.com>, clabbe@baylibre.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, robh+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
 khilman@baylibre.com, jbrunet@baylibre.com,
 martin.blumenstingl@googlemail.com, vadim.fedorenko@linux.dev
Cc: linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel@salutedevices.com
References: <20240820145623.3500864-1-avromanov@salutedevices.com>
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
In-Reply-To: <20240820145623.3500864-1-avromanov@salutedevices.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 20/08/2024 16:56, Alexey Romanov wrote:
> Hello!
> 
> This patchset expand the funcionality of the Amlogic
> crypto driver by adding support for more SoC families:
> AXG, G12A, G12B, SM1, A1, S4.
> 
> Also specify and enable crypto node in device tree
> for reference Amlogic devices.
> 
> Tested on GXL, AXG, G12A/B, SM1, A1 and S4 devices via
> custom tests [1] and tcrypt module.

On which tree did you base yourself ? It fails to apply patch 20 on next-20240820 and 6.11-rc4

Neil

> 
> ---
> 
> Changes V1 -> V2 [2]:
> 
> - Rebased over linux-next.
> - Adjusted device tree bindings description.
> - A1 and S4 dts use their own compatible, which is a G12 fallback.
> 
> Changes V2 -> V3 [3]:
> 
> - Fix errors in dt-bindings and device tree.
> - Add new field in platform data, which determines
> whether clock controller should be used for crypto IP.
> - Place back MODULE_DEVICE_TABLE.
> - Correct commit messages.
> 
> Changes V3 -> V4 [4]:
> 
> - Update dt-bindings as per Krzysztof Kozlowski comments.
> - Fix bisection: get rid of compiler errors in some patches.
> 
> Changes V4 -> V5 [5]:
> 
> - Tested on GXL board:
>    1. Fix panic detected by Corentin Labbe [6].
>    2. Disable hasher backend for GXL: in its current realization
>       is doesn't work. And there are no examples or docs in the
>       vendor SDK.
> - Fix AES-CTR realization: legacy boards (gxl, g12, axg) requires
>    inversion of the keyiv at keys setup stage.
> - A1 now uses its own compatible string.
> - S4 uses A1 compatible as fallback.
> - Code fixes based on comments Neil Atrmstrong and Rob Herring.
> - Style fixes (set correct indentations)
> 
> Changes V5 -> V6 [7]:
> 
> - Fix DMA sync warning reported by Corentin Labbe [8].
> - Remove CLK input from driver. Remove clk definition
>    and second interrput line from crypto node inside GXL dtsi.
> 
> Changes V6 -> V7 [9]:
> 
> - Fix dt-schema: power domain now required only for A1.
> - Use crypto_skcipher_ctx_dma() helper for cipher instead of
>    ____cacheline_aligned.
> - Add import/export functions for hasher.
> - Fix commit message for patch 17, acorrding to discussion [10].
> 
> Changes V7 -> V8 [11]:
> 
> - Test patchset with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS: fix some bugs
>    in hasher logic.
> - Use crypto crypto_ahash_ctx_dma in hasher code.
> - Correct clock definition: clk81 is required for all SoC's.
> - Add fixed-clock (clk81) definition for A1/S4.
> - Add information (in commit messages) why different compatibles are used.
> 
> Changes V8 -> V9 [12]:
> 
> - Remove required field clk-names from dt-schema according to Rob Herring
> recommendation [13].
> - Fix commit order: all dt-bindings schema commits now located earlier
> than any changes in device tree.
> - Fix typos and add more clarifications in dt-schema patches.
> 
> Links:
>    - [1] https://gist.github.com/mRrvz/3fb8943a7487ab7b943ec140706995e7
>    - [2] https://lore.kernel.org/all/20240110201216.18016-1-avromanov@salutedevices.com/
>    - [3] https://lore.kernel.org/all/20240123165831.970023-1-avromanov@salutedevices.com/
>    - [4] https://lore.kernel.org/all/20240205155521.1795552-1-avromanov@salutedevices.com/
>    - [5] https://lore.kernel.org/all/20240212135108.549755-1-avromanov@salutedevices.com/
>    - [6] https://lore.kernel.org/all/ZcsYaPIUrBSg8iXu@Red/
>    - [7] https://lore.kernel.org/all/20240301132936.621238-1-avromanov@salutedevices.com/
>    - [8] https://lore.kernel.org/all/Zf1BAlYtiwPOG-Os@Red/
>    - [9] https://lore.kernel.org/all/20240326153219.2915080-1-avromanov@salutedevices.com/
>    - [10] https://lore.kernel.org/all/20240329-dotted-illusive-9f0593805a05@wendy/
>    - [11] https://lore.kernel.org/all/20240411133832.2896463-1-avromanov@salutedevices.com/
>    - [12] https://lore.kernel.org/all/20240607141242.2616580-1-avromanov@salutedevices.com/
>    - [13] https://lore.kernel.org/all/20240610222827.GA3166929-robh@kernel.org/
> 
> Alexey Romanov (23):
>    drivers: crypto: meson: don't hardcode IRQ count
>    drviers: crypto: meson: add platform data
>    drivers: crypto: meson: remove clock input
>    drivers: crypto: meson: add MMIO helpers
>    drivers: crypto: meson: move get_engine_number()
>    drivers: crypto: meson: drop status field from meson_flow
>    drivers: crypto: meson: move algs definition and cipher API to
>      cipher.c
>    drivers: crypto: meson: cleanup defines
>    drivers: crypto: meson: process more than MAXDESCS descriptors
>    drivers: crypto: meson: avoid kzalloc in engine thread
>    drivers: crypto: meson: introduce hasher
>    drivers: crypto: meson: add support for AES-CTR
>    drivers: crypto: meson: use fallback for 192-bit keys
>    drivers: crypto: meson: add support for G12-series
>    drivers: crypto: meson: add support for AXG-series
>    drivers: crypto: meson: add support for A1-series
>    dt-bindings: crypto: meson: correct clk and remove second interrupt
>      line
>    dt-bindings: crypto: meson: support new SoC's
>    arch: arm64: dts: meson: gxl: correct crypto node definition
>    arch: arm64: dts: meson: a1: add crypto node
>    arch: arm64: dts: meson: s4: add crypto node
>    arch: arm64: dts: meson: g12: add crypto node
>    arch: arm64: dts: meson: axg: add crypto node
> 
>   .../bindings/crypto/amlogic,gxl-crypto.yaml   |  32 +-
>   arch/arm64/boot/dts/amlogic/meson-a1.dtsi     |  14 +
>   arch/arm64/boot/dts/amlogic/meson-axg.dtsi    |   7 +
>   .../boot/dts/amlogic/meson-g12-common.dtsi    |   7 +
>   arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |   6 +-
>   arch/arm64/boot/dts/amlogic/meson-s4.dtsi     |  13 +
>   drivers/crypto/amlogic/Makefile               |   2 +-
>   drivers/crypto/amlogic/amlogic-gxl-cipher.c   | 632 ++++++++++++------
>   drivers/crypto/amlogic/amlogic-gxl-core.c     | 292 ++++----
>   drivers/crypto/amlogic/amlogic-gxl-hasher.c   | 507 ++++++++++++++
>   drivers/crypto/amlogic/amlogic-gxl.h          | 118 +++-
>   11 files changed, 1269 insertions(+), 361 deletions(-)
>   create mode 100644 drivers/crypto/amlogic/amlogic-gxl-hasher.c
> 

