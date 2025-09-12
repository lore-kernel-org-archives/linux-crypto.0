Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DE530DEC5
	for <linux-crypto@vger.kernel.org>; Fri, 12 Sep 2025 14:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757685820; cv=none; b=ME+uE5Ijbs16i3VavuDG8FuE1fFIaxeZrLqfc/SgmyoKHLm4xLIzOCEbQ006p+mELYlwOKaUOgB0iJYrz0SjyDQaQKBNXgSE/XOIFZaLRjhWIjZNt1tPt9NHma+E1G3GlblG5g2FLVCiwLaO1zA8jbgrTwQWsYR+FtvoUmbx+3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757685820; c=relaxed/simple;
	bh=I9n2pVmu6LmPD6zvLHRAM5ekmJJV3HNaSaih80Ri9aQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ryAmu+xgYvX03dAIyGKXAP8y9/1CzuvdQedmu3m6Paj8HiDYoZBLnJvKLw8OcabqkDpgVKQE3XOrwyzk9kvgzXxVzjgWw84nnSx44sweRbv9f9y1U+1LpC9uOSro0SRYzY1nfSXTHc6fa5TTWlCkdHVkFpFVtLUNBzycrV27IYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BypA0bHt; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BypA0bHt"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45dd5e24d16so18731755e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 12 Sep 2025 07:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757685816; x=1758290616; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=/awESVZkJ9K+JfRYd9Rjr/yLS5bHXWrAEyFkBSavtRk=;
        b=BypA0bHtW8dc/9jFOduQ+R25ll0YATGAEaWEVnPnqn7pWbwrmTbEVvtGUj3ynHfroY
         s2PSNRHk2yNthP/TF1iOjTqEwoxDVOAghcPZ3vjw1FWt9hMoAnl+5lfMRMpxuy/EXJWO
         YhdsLY0KSNR626866tS4QUcTkkJpj6xiywYTSX7VZ3jt0VnCFg8U0pjZNhVNiA/8TbTv
         hBAdGcw03C0DJkYipsJsoMP7HjjVbjBQ+g5EXZJHQCu7WYjNpJdTB70hiVt7mW1yrdpd
         7nubU2A9S0bZfSTfEXoDrLOegDyhwcQrhclEMFmg0jvKFJC7OIXm78GDYb1aj/eEzhud
         40Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757685816; x=1758290616;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/awESVZkJ9K+JfRYd9Rjr/yLS5bHXWrAEyFkBSavtRk=;
        b=CpIj9S6bz+dtJ0mkrLoO+PSqv1SVtve2+lNR3GU18ffTRT0jGWJS3lO+1CxiItHA4P
         NgAWr0WokTJb82rVCOFXfb63+zCxqg8HPK7iGS8CrmtHsDRQhUbYrzxN4AkXpwSBrFcg
         CoN/rtopzeAwKvSOFM1tJA0DWtrLDvlAdrbnrCmhqnS7LpFW99duJ7c5ycAGPu9qjEoP
         DHIHwA4tgIoM3dK2iuF7SvY1cXjv7JZ89p+leANbpn5zqAmOhY6AZbZaq2OVIFqs3eNq
         nE7INqvkIiqLfXrnJ+O2XZB4NTftfmTCPZXOVf9R4ZYhe/EIQEQyxsrVzRaP2s3Ogh7E
         nlQA==
X-Forwarded-Encrypted: i=1; AJvYcCU9/3CmB7YPevz993V3wWNMykX/Zi1tBHpJYROlPb3Q6EKcJ0hT+qOO/zUYCmxQ3Espg0H7ls313V4RjVI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3BEASjTJvMi6j0eOJoF7JO1i8VFzwhI7jXo17OYdQp1alc+AZ
	CKW286LP7w61gpeCYaneqHANw3qsGvedQjpvOFwRTOHyXcJKmkYlXY80
X-Gm-Gg: ASbGnctMRLeJSuC8hLf9AZuYUI7pjgO8UrVQHrcrqcEvsVpgSABDjRUBZV4bP3QoGKY
	xBNm7ybNQTvuupUAKDKmCHXviG5V9a9MjPRM/TM94+qNN9tZrcNsHA4PbD4sYuGLwoRxSIJCY0V
	vKLUI1QLE1FPMvGUYuEZBCOskpZ9i00HCqF6K74BflxiL17N7hThfG5O3hkHljQBEcSqCcwEz0A
	fBqzT0EGGOSKYWBOcluKxviSi+NGvEEHvkxWkb4WAgG/kfF6y5N1QVufZWbqnbC4gOA2RrH3mmM
	8KK9tr0LwFiyy0kSXS0Bdna+4Cl3L+GryIZSaf+YXtZXBxft7sE9h77FTy3xjjNisgAagMytIef
	9XKTPVZK49rdsbXitPvbFqN6w3CEX4pR84t8f3rvd3A==
X-Google-Smtp-Source: AGHT+IFrFziaROE6t7OvfnHw1fSxmStjyRsw0iDsiUclaiLc+LNP4gi88MN0nbdrnjXQvf8i78gTdw==
X-Received: by 2002:a7b:cd0b:0:b0:45d:dbf4:8880 with SMTP id 5b1f17b1804b1-45f211efda6mr20357825e9.27.1757685815284;
        Fri, 12 Sep 2025 07:03:35 -0700 (PDT)
Received: from [192.168.2.177] ([91.116.220.47])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e01832af1sm35682985e9.3.2025.09.12.07.03.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 07:03:34 -0700 (PDT)
Message-ID: <0c088460-da7e-4443-92e3-23f160415ce8@gmail.com>
Date: Fri, 12 Sep 2025 14:16:34 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/38] arm64: dts: mediatek: mt6797: Fix pinctrl node
 names
To: Fei Shao <fshao@chromium.org>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-mediatek@lists.infradead.org, robh@kernel.org,
 daniel.lezcano@linaro.org, mwalle@kernel.org, devicetree@vger.kernel.org,
 linus.walleij@linaro.org, linux-remoteproc@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 olivia.wen@mediatek.com, shane.chien@mediatek.com,
 linux-gpio@vger.kernel.org, linux-phy@lists.infradead.org,
 airlied@gmail.com, simona@ffwll.ch, herbert@gondor.apana.org.au,
 jassisinghbrar@gmail.com, jiaxin.yu@mediatek.com, andy.teng@mediatek.com,
 chunfeng.yun@mediatek.com, jieyy.yang@mediatek.com, chunkuang.hu@kernel.org,
 conor+dt@kernel.org, jitao.shi@mediatek.com, p.zabel@pengutronix.de,
 arnd@arndb.de, kishon@kernel.org, kyrie.wu@mediatek.corp-partner.google.com,
 maarten.lankhorst@linux.intel.com, tinghan.shen@mediatek.com,
 mripard@kernel.org, ck.hu@mediatek.com, broonie@kernel.org,
 eugen.hristev@linaro.org, houlong.wei@mediatek.com, tglx@linutronix.de,
 mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
 granquet@baylibre.com, sam.shih@mediatek.com, mathieu.poirier@linaro.org,
 fparent@baylibre.com, andersson@kernel.org, sean.wang@kernel.org,
 linux-sound@vger.kernel.org, lgirdwood@gmail.com, vkoul@kernel.org,
 linux-crypto@vger.kernel.org, tzimmermann@suse.de, atenart@kernel.org,
 krzk+dt@kernel.org, linux-media@vger.kernel.org, davem@davemloft.net
References: <20250724083914.61351-1-angelogioacchino.delregno@collabora.com>
 <20250724083914.61351-18-angelogioacchino.delregno@collabora.com>
 <CAC=S1nh5bF6kZe7TFA_EGPGt8Xp_rfuc-rkeXgjRCU=QEtZQiw@mail.gmail.com>
Content-Language: en-US, ca-ES, es-ES
From: Matthias Brugger <matthias.bgg@gmail.com>
Autocrypt: addr=matthias.bgg@gmail.com; keydata=
 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
In-Reply-To: <CAC=S1nh5bF6kZe7TFA_EGPGt8Xp_rfuc-rkeXgjRCU=QEtZQiw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 25/07/2025 12:56, Fei Shao wrote:
> On Thu, Jul 24, 2025 at 5:48 PM AngeloGioacchino Del Regno
> <angelogioacchino.delregno@collabora.com> wrote:
>>
>> Change the pinctrl node names to adhere to the binding: the main
>> nodes are now named like "uart0-pins" and the children "pins-bus".
>>
>> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> 
> Reviewed-by: Fei Shao <fshao@chromium.org>
> 

Applied, thanks

>> ---
>>   arch/arm64/boot/dts/mediatek/mt6797.dtsi | 40 ++++++++++++------------
>>   1 file changed, 20 insertions(+), 20 deletions(-)
>>
>> diff --git a/arch/arm64/boot/dts/mediatek/mt6797.dtsi b/arch/arm64/boot/dts/mediatek/mt6797.dtsi
>> index 0e9d11b4585b..be401617dfd8 100644
>> --- a/arch/arm64/boot/dts/mediatek/mt6797.dtsi
>> +++ b/arch/arm64/boot/dts/mediatek/mt6797.dtsi
>> @@ -135,71 +135,71 @@ pio: pinctrl@10005000 {
>>                  gpio-controller;
>>                  #gpio-cells = <2>;
>>
>> -               uart0_pins_a: uart0 {
>> -                       pins0 {
>> +               uart0_pins_a: uart0-pins {
>> +                       pins-bus {
>>                                  pinmux = <MT6797_GPIO234__FUNC_UTXD0>,
>>                                           <MT6797_GPIO235__FUNC_URXD0>;
>>                          };
>>                  };
>>
>> -               uart1_pins_a: uart1 {
>> -                       pins1 {
>> +               uart1_pins_a: uart1-pins {
>> +                       pins-bus {
>>                                  pinmux = <MT6797_GPIO232__FUNC_URXD1>,
>>                                           <MT6797_GPIO233__FUNC_UTXD1>;
>>                          };
>>                  };
>>
>> -               i2c0_pins_a: i2c0 {
>> -                       pins0 {
>> +               i2c0_pins_a: i2c0-pins {
>> +                       pins-bus {
>>                                  pinmux = <MT6797_GPIO37__FUNC_SCL0_0>,
>>                                           <MT6797_GPIO38__FUNC_SDA0_0>;
>>                          };
>>                  };
>>
>> -               i2c1_pins_a: i2c1 {
>> -                       pins1 {
>> +               i2c1_pins_a: i2c1-pins {
>> +                       pins-bus {
>>                                  pinmux = <MT6797_GPIO55__FUNC_SCL1_0>,
>>                                           <MT6797_GPIO56__FUNC_SDA1_0>;
>>                          };
>>                  };
>>
>> -               i2c2_pins_a: i2c2 {
>> -                       pins2 {
>> +               i2c2_pins_a: i2c2-pins {
>> +                       pins-bus {
>>                                  pinmux = <MT6797_GPIO96__FUNC_SCL2_0>,
>>                                           <MT6797_GPIO95__FUNC_SDA2_0>;
>>                          };
>>                  };
>>
>> -               i2c3_pins_a: i2c3 {
>> -                       pins3 {
>> +               i2c3_pins_a: i2c3-pins {
>> +                       pins-bus {
>>                                  pinmux = <MT6797_GPIO75__FUNC_SDA3_0>,
>>                                           <MT6797_GPIO74__FUNC_SCL3_0>;
>>                          };
>>                  };
>>
>> -               i2c4_pins_a: i2c4 {
>> -                       pins4 {
>> +               i2c4_pins_a: i2c4-pins {
>> +                       pins-bus {
>>                                  pinmux = <MT6797_GPIO238__FUNC_SDA4_0>,
>>                                           <MT6797_GPIO239__FUNC_SCL4_0>;
>>                          };
>>                  };
>>
>> -               i2c5_pins_a: i2c5 {
>> -                       pins5 {
>> +               i2c5_pins_a: i2c5-pins {
>> +                       pins-bus {
>>                                  pinmux = <MT6797_GPIO240__FUNC_SDA5_0>,
>>                                           <MT6797_GPIO241__FUNC_SCL5_0>;
>>                          };
>>                  };
>>
>> -               i2c6_pins_a: i2c6 {
>> -                       pins6 {
>> +               i2c6_pins_a: i2c6-pins {
>> +                       pins-bus {
>>                                  pinmux = <MT6797_GPIO152__FUNC_SDA6_0>,
>>                                           <MT6797_GPIO151__FUNC_SCL6_0>;
>>                          };
>>                  };
>>
>> -               i2c7_pins_a: i2c7 {
>> -                       pins7 {
>> +               i2c7_pins_a: i2c7-pins {
>> +                       pins-bus {
>>                                  pinmux = <MT6797_GPIO154__FUNC_SDA7_0>,
>>                                           <MT6797_GPIO153__FUNC_SCL7_0>;
>>                          };
>> --
>> 2.50.1
>>
>>

