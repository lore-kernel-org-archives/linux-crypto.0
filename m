Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAEE30648A
	for <linux-crypto@vger.kernel.org>; Fri, 12 Sep 2025 12:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757679223; cv=none; b=FKqVoVC9ng6bRRsDK+cdKe+eDP9QwalUwD3SexJrPY7cbX+sYXh+P4WZ5oniLcaYQk16jxdjbNh0VlRB/yLcdf5TTa/FtGQfq3qGMOq0wVcuJyMp+CuODhNQpnXQg6ODxgwC2PRRlp4RU6iYRLRGsGQ+bYQD3JH+v/jhk13Zp8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757679223; c=relaxed/simple;
	bh=qu6uuAY9QNla7k9tKDmyzhhF6EpcU1dljJkDq7tZX54=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EGQdaPhia3DT45QLbgmItz897+xtAtc+bDsrJ4ZGygNwpb+OAtT4Mn1G/9ZL82bOGtwwE+a/AMT4uC4cZeFd7ZwyG+40HDKl7Gh1o7pG47J3Il0XLGXyu8H/+lril1jaTKL+z8tyfaGN6xhSzO7L2E4G3Ozuyz6y3wdr76vYSsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AbnC7ISS; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AbnC7ISS"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3e76766a172so527629f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 12 Sep 2025 05:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757679219; x=1758284019; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=zkoQ9SJncJQR2k7owlGfYP7lnnJQnXwneqiBOWb0ci8=;
        b=AbnC7ISSokXwH1QoB6/LIwI59VXgDXlH7jPi9gLu9ePech/s9tGDUmn0UzYUUvXdpN
         P4oJbaU95Zo1iK+KIXatRU7EJktn3DdftWI1ApttE7OvTEfoLWt9zWvCSF9Ai64+z4b6
         0/WeBxLhGzW0JlSgOONyVlD3DyelgymQPijwODkwXQgCnuWbwcct5w0tvm+KtvpAZhXH
         hNkp1KILFogur6XyJksiGFoR6FxVMsQwnDtDdzXAxF7QyrgmKmnKiFazDZRl2XSELd96
         7VCxoGsn6otcjWzoXecaXULEPcwxatLRIWBlLRP/ON4Ee+hUlNDW6Ac83iPo1nj2udlI
         Hz3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757679219; x=1758284019;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zkoQ9SJncJQR2k7owlGfYP7lnnJQnXwneqiBOWb0ci8=;
        b=DfmvEjX8h2gLuhZJOKhzU0lcBgPOO4lF8U4VEpyvr3Fopqpzycc1t8CXeFQ0t53agt
         MRJyL0SDWzkSeWbf2yR6CzyWqpV9n5qSLUqoRynAwu8Ae+zFegB4uNRajmk2BKqZdylu
         5clRLwmwndVEL30OTUJcB6+fYy92DS8FAvWxcbypWISA9AcswUHTURNqD7dTJVm1qmE8
         fg9oby+seIR5AMD91mwMVNn1w4CoZ84oQSiBnxbnt4JCYUzY9jOaagD3W3JZsF0QtkH3
         Oj4rfCwn1cQblHFY72q9b1Yv2o92HeYyryra2GciHlLbCm8QmF5I/bBjGnTpBjA1QuKm
         uNoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkm9DRcGks2tLAHnhKOJJOaK28N5dJyvM6x+8bSCo355ymMyfcsex3iZmpuvLmdxYJvPjP/annE+iOqro=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcmKSYQd50zxgNgbz/ijt3eLNOhU547wuzwt3HqWdJCNNHZxcg
	FUGJ5q8wSv7m7UdACt7A0oMeWOOsNyUqPJ+ap01YXATAtsEd8OXiuAAW
X-Gm-Gg: ASbGncvZywfBtMFEU7VEq4dYTmM32Y66GgBD4WYZLUy5l4GRGeDi83s0gS5w0PLM74m
	eNnKAA7o0fvD72GNCaOEs4fcW9+5cYanSdS4YJPvJeLw4B6lNfCAW2hxVtAfAa50hKYWxIA0ueA
	Sp99OCNUwd/+ZLSua8nhS/7Tk43YCxjpnHpXcEeaj4Jg6D+UBI+ZYRJH5QH/HuO0oeqXT0v2oFs
	Iv1L/RESor9DzxIvPh/9eHZR6Dtikb+6hyii8JR9qos1V6VBLuXr20XXjrFzHdqjBQ+qPnsxi98
	yXM4Yudr0nSaKe5ntyg+fA3QiR0D7QyLW5zl+0wcfdI+hn1gBbyBpwNeNRn84grtmaf5SvD1VqV
	lH0DZMXBf/DpQ+QpNv1QrtOfvazWD0qxJUy7+cfnWp4xMz5RsielN
X-Google-Smtp-Source: AGHT+IGQEhQIRknYaP1YuGQvYnjZ0p0JV8FXvcoSvGq8FP5ylA0D/T0PXvLLFUR4FEgtbThEIjz1Fw==
X-Received: by 2002:a05:6000:2689:b0:3e7:47f2:253 with SMTP id ffacd0b85a97d-3e765a14106mr2866757f8f.56.1757679219199;
        Fri, 12 Sep 2025 05:13:39 -0700 (PDT)
Received: from [192.168.2.177] ([91.116.220.47])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607878c9sm6393277f8f.26.2025.09.12.05.13.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 05:13:38 -0700 (PDT)
Message-ID: <b43e8ec7-06a3-447f-8694-278e6677733d@gmail.com>
Date: Fri, 12 Sep 2025 14:13:35 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/38] dt-bindings: timer: mediatek: Add compatible for
 MT6795 GP Timer
To: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 linux-mediatek@lists.infradead.org, robh@kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, krzk+dt@kernel.org,
 conor+dt@kernel.org, chunkuang.hu@kernel.org, p.zabel@pengutronix.de,
 airlied@gmail.com, simona@ffwll.ch, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, tzimmermann@suse.de, jassisinghbrar@gmail.com,
 mchehab@kernel.org, chunfeng.yun@mediatek.com, vkoul@kernel.org,
 kishon@kernel.org, sean.wang@kernel.org, linus.walleij@linaro.org,
 lgirdwood@gmail.com, broonie@kernel.org, andersson@kernel.org,
 mathieu.poirier@linaro.org, daniel.lezcano@linaro.org, tglx@linutronix.de,
 atenart@kernel.org, jitao.shi@mediatek.com, ck.hu@mediatek.com,
 houlong.wei@mediatek.com, kyrie.wu@mediatek.corp-partner.google.com,
 andy.teng@mediatek.com, tinghan.shen@mediatek.com, jiaxin.yu@mediatek.com,
 shane.chien@mediatek.com, olivia.wen@mediatek.com, granquet@baylibre.com,
 eugen.hristev@linaro.org, arnd@arndb.de, sam.shih@mediatek.com,
 jieyy.yang@mediatek.com, frank-w@public-files.de, mwalle@kernel.org,
 fparent@baylibre.com, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-phy@lists.infradead.org,
 linux-gpio@vger.kernel.org, linux-remoteproc@vger.kernel.org,
 linux-sound@vger.kernel.org
References: <20250724083914.61351-1-angelogioacchino.delregno@collabora.com>
 <20250724083914.61351-7-angelogioacchino.delregno@collabora.com>
Content-Language: en-US, ca-ES, es-ES
From: Matthias Brugger <matthias.bgg@gmail.com>
Autocrypt: addr=matthias.bgg@gmail.com; keydata=
 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
In-Reply-To: <20250724083914.61351-7-angelogioacchino.delregno@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 24/07/2025 10:38, AngeloGioacchino Del Regno wrote:
> Add a compatible for the General Purpose Timer (GPT) found on the
> MediaTek Helio X10 MT6795 SoC which is fully compatible with the
> one found in MT6577.
> 
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>

> ---
>   Documentation/devicetree/bindings/timer/mediatek,timer.yaml | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/timer/mediatek,timer.yaml b/Documentation/devicetree/bindings/timer/mediatek,timer.yaml
> index e3e38066c2cb..337580dc77d8 100644
> --- a/Documentation/devicetree/bindings/timer/mediatek,timer.yaml
> +++ b/Documentation/devicetree/bindings/timer/mediatek,timer.yaml
> @@ -30,6 +30,7 @@ properties:
>                 - mediatek,mt6580-timer
>                 - mediatek,mt6582-timer
>                 - mediatek,mt6589-timer
> +              - mediatek,mt6795-timer
>                 - mediatek,mt7623-timer
>                 - mediatek,mt8127-timer
>                 - mediatek,mt8135-timer

