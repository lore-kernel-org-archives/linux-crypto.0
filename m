Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E891E202C2A
	for <linux-crypto@vger.kernel.org>; Thu, 31 Jul 2025 08:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753949113; cv=none; b=AnVPO3+kX9fedlQdi8rBzdJ4x6h+SVZJLwo7sXPTr4/GjqyO7QlJ3MDmJS+4XoEWwUi1KnKcjGrYmI7aZbmVSsyg1vhjtXo4J8H+OgDIVmsy6c5aVMk8LP2ev+DJY2wusuaQFkvzlC4gGvm/xODqeCCx0J2tE65msMeQvKpo7lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753949113; c=relaxed/simple;
	bh=6bi4kRFwbYfyE28UT2me0jvb3Oreb7wCirpdwwV3Gso=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jQ5PZUBj6lkklwzh1tUCp4uxBYb5i5xtnRBOjb6R9D7OcbCDXvz1eXmJk4iXw5c2ivGjpcomaBXJs9IO5p65tAoHJThNdJuo+jcbZDycRanpb03X3RWxkFHVIiAqQTU/ClNFaPDl/0nqPLfBL3U3B1tEyNyCH1t/1SzVRAxCXUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev; spf=pass smtp.mailfrom=tuxon.dev; dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b=GOK/9s7M; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuxon.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tuxon.dev header.i=@tuxon.dev header.b="GOK/9s7M"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4561514c7f0so1108505e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 31 Jul 2025 01:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1753949110; x=1754553910; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GiWR9YBkQCBk6u1BEFYqq7bF5Tp24tb8A8i+jcDSHqs=;
        b=GOK/9s7M4IR+kgqShpE31nJt8j2ZH3iU4C+GllNjX9mN1+swh8Vg25JRhLfkAKPh78
         IdNEbaFb5M5hVisK3nqq5WX2a67aaIwYkEiKP43OtfAQX/kSpX/ZMLRcyo99UhUZSIgD
         Nj3S8CDa95DPptI3X60aIsPVVRMdBpTs/wm8WuN2U/Fildo1NcJ1dxkoszZd4PJwWEgY
         pRBsxdTShVlsmCro7A2MM0uvgawAMvn8qXeHp/zAWQ5CDw8tdVz+m9AaWH3kI9W/gSBh
         O9jqTkbaFeQ2aNyWJNXVARsMSnn7aLV7OMLXn5i8fEMHMk08sQ4/ZUOHYJcl/tePwvrQ
         v9cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753949110; x=1754553910;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GiWR9YBkQCBk6u1BEFYqq7bF5Tp24tb8A8i+jcDSHqs=;
        b=ebVfh6uti9JDf54jKgP6tvR0jcSQYlD7Z/Nvss8eWOz4S3/eNpyI3GoNUmKXibcOrJ
         qt2JlQW84DZnfrFvlVItFB1znodzC0fUIL5HgqHHR3DQ4q7Ll2a9qTSY7N0wLaa/DWXF
         iMgfeBKBj8XDl16CMEpz2Uw1EumEie/MEK2JTPt7NRamfcSy2j8AsvEpxoKDe3zCCve8
         0FsUMxN5BKdytlLeHwKblvoBs+d7ZBVDhnM7lmysBpwQQeCQrwWV/c1HNLr19X3hfwhT
         bfbC5vsHPZGGCdsDxZ5rdlFxx5rKDpvoP1+OOdqq/25i5DL2pM++53Sek5f2dag35Jka
         D4XQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJb2SyXzXfafHGSDRu2fmNK+hNciYgHN51MTrDFLx8mjGjA2xBlpLQW3GC7FDrw9PXI5tLkcQ5r8G1u9s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCbS8Vplt9BtQlpkBizdW22ycQfRoYoEnLXNTngdVJ0IX72+zR
	NKGCRYirWYzzpZB5I7e9gwpdHUVmRwuXCsZpJy3g7KpbG1byzcr3lv4h+qf/FRCI+/U=
X-Gm-Gg: ASbGncs5HPuUFRjjpxsVf8Gx96bmH8nK9iugTsCuWTn1VCcXD2J/wp9Vy3qKpGBN4pd
	1+SgdFyllLkEKvYOqSw9RBn8TW/5uU07oGzarH0A8NrYd/3328+h2hLFr0A6lfZMFCld+jVmMI2
	vwp6fAWSoxqAv14qP2twO+uLBPUtk0EMEIzuGCSeLUPardB4En1vkZsdka5QImHB/Rhk1GrCK13
	QP+nmuEGceKKkla7cu0V9qMz3+ISSgiBLUgiDASsuqpkhuMt/g5PySHHiMZ1GBmzQ8MOU2P9UAy
	t3vaFWuAp3VDW9vyx7rr1gnKniN26REAb/iL7qI9R5BiP/xVqxdbHyvnVm7YFdbMVc12aL2zZSm
	6i54NAH31q5YKN+LxZ6uiIZBsYhmmug==
X-Google-Smtp-Source: AGHT+IH/541SBqMgVRMwq19FcxpTJ84aTjtwL21hMdK7WasoI4YZqc/Qb8aQtoiT1F7mEW4j9xyVmQ==
X-Received: by 2002:a05:600c:8b83:b0:43c:f8fe:dd82 with SMTP id 5b1f17b1804b1-45892bbf78cmr68783845e9.18.1753949110073;
        Thu, 31 Jul 2025 01:05:10 -0700 (PDT)
Received: from [192.168.50.4] ([82.78.167.30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c485444sm1527560f8f.66.2025.07.31.01.05.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 01:05:09 -0700 (PDT)
Message-ID: <bac5390f-725a-43db-a2b6-17a68d0d733c@tuxon.dev>
Date: Thu, 31 Jul 2025 11:05:07 +0300
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH v8 00/10] arm64: lan969x: Add support for
 Microchip LAN969x SoC
To: Vinod Koul <vkoul@kernel.org>, linux@armlinux.org.uk,
 nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
 catalin.marinas@arm.com, will@kernel.org, olivia@selenic.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, andi.shyti@kernel.org,
 lee@kernel.org, broonie@kernel.org, gregkh@linuxfoundation.org,
 jirislaby@kernel.org, arnd@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 dmaengine@vger.kernel.org, linux-i2c@vger.kernel.org,
 linux-spi@vger.kernel.org, linux-serial@vger.kernel.org,
 o.rempel@pengutronix.de, daniel.machon@microchip.com,
 Robert Marko <robert.marko@sartura.hr>
Cc: luka.perkov@sartura.hr
References: <20250702183856.1727275-1-robert.marko@sartura.hr>
 <175327377884.189941.15214972441246653208.b4-ty@kernel.org>
From: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Content-Language: en-US
In-Reply-To: <175327377884.189941.15214972441246653208.b4-ty@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi, Vinod,

On 23.07.2025 15:29, Vinod Koul wrote:
> 
> On Wed, 02 Jul 2025 20:35:58 +0200, Robert Marko wrote:
>> This patch series adds basic support for Microchip LAN969x SoC.
>>
>> It introduces the SoC ARCH symbol itself under the ARCH_MICROCHIP symbol
>> which allows to avoid the need to change dependencies of the drivers that
>> are shared for Microchip SoC-s in the future.
>>
>> DTS and further driver will be added in follow-up series.
>>
>> [...]
> 
> Applied, thanks!
> 
> [08/10] dma: xdmac: make it selectable for ARCH_MICROCHIP
>         commit: e56982021f5303b2523ac247e3c79b063459d012

As this one depends, as well, on the first 3 patches in the series (Robert,
please correct me if I'm wrong), and there are still discussions ongoing,
can you please drop it until all is clear on the first 3 patches?

Otherwise, applying only this patch will lead to AT91 XDMAC driver not
being built for SAMA5{D2, D3, D4}, SAMA7{G5, D65} SoCs. Linux is not
booting on SAMA7G5 SoC only with this patch applied.

Thank you,
Claudiu

