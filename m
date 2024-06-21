Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA92C1667CF;
	Fri, 21 Jun 2024 18:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718993599; cv=none; b=t3GZYfQX5I9kfFm0qcXTk0poXkGE00FY/8HWRl6gWogBm1vdJfvLhiaWFF8R+baww2UnN9J2oGyrGEu6wciyLxjSHsU5M4EZBqNpRvY7MmzMRc9blRO8T57l5vwj4Zf9VHj6MpguHM2iaf3jqOoSy0MNqjRZowdjKqIecl8jG4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718993599; c=relaxed/simple;
	bh=LZ0iYmZkSzEwlSv99nqaHY3jPJ/b/fOk4KxJwrNfLm0=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=GtMiGEb/POF00D4PHahrAgyRyxc+HjoTohi7d9+hMZDPusRt3yW7a1hSP79KxiAnwmOhr3Tfm/AP7eAknKdQi+/yw9aFCG6jm7cIgTQdFo1g9U8Uk8l9h7e/bfvCYSAUS5n8DIm33aH54KMjPdk/RDh0t/gttUUt+16mIKi44/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=fbAaTOmn; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="fbAaTOmn"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1718993593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oF3mZo1VFDTjJ8h7Wuq2E3h4BU0kvs78+Dm/ptq/cD8=;
	b=fbAaTOmnqaoD3oG8vocepB00x8sRNHPWzj9Hw6y3RORWi8aRrtkyfaolBJgaWalyo/t17b
	svKXjQA6eljRoko99JasfzdGExxQ9eIRlJYCsTlj6da6yje2DoQosKeJoUZupHWlGIxaaQ
	P3LPhMfHfW4kitBEe4zBl+Z1ul/Yb/lBGow8uwLFWh/O8+78WIIrJKAqD9d8xdZZMyxPm8
	4umP5ug3QHoa95y6rcJZxDsZyeaOsZGD+tJppn2sUJMm0Jlx1vLW3/aUVnF6Bvy5PTaacF
	6ODlLFtAjGXQAEtYgzWMUNvFPmoVmBwdehacUaab1/EBQhAJ4NnNnXRkaYWuyQ==
Date: Fri, 21 Jun 2024 20:13:08 +0200
From: Dragan Simic <dsimic@manjaro.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Daniel Golle <daniel@makrotopia.org>, Aurelien Jarno
 <aurelien@aurel32.net>, Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Heiko
 Stuebner <heiko@sntech.de>, Philipp Zabel <p.zabel@pengutronix.de>,
 =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <ukleinek@debian.org>, Sebastian Reichel
 <sebastian.reichel@collabora.com>, Anand Moon <linux.amoon@gmail.com>,
 Sascha Hauer <s.hauer@pengutronix.de>, Martin Kaiser <martin@kaiser.cx>, Ard
 Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] hwrng: add Rockchip SoC hwrng driver
In-Reply-To: <f8e6b1b9-f8ff-42df-b1ef-bcc439c2e913@kernel.org>
References: <cover.1718921174.git.daniel@makrotopia.org>
 <57a7fb13451f066ddc8d1d9339d8f6c1e1946bf1.1718921174.git.daniel@makrotopia.org>
 <f8e6b1b9-f8ff-42df-b1ef-bcc439c2e913@kernel.org>
Message-ID: <173ce1663186ab8282356748abcac3f4@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Krzysztof,

On 2024-06-21 11:57, Krzysztof Kozlowski wrote:
> On 21/06/2024 03:25, Daniel Golle wrote:
>> From: Aurelien Jarno <aurelien@aurel32.net>

[snip]

>> +	pm_runtime_set_autosuspend_delay(dev, RK_RNG_AUTOSUSPEND_DELAY);
>> +	pm_runtime_use_autosuspend(dev);
>> +	pm_runtime_enable(dev);
>> +
>> +	ret = devm_hwrng_register(dev, &rk_rng->rng);
>> +	if (ret)
>> +		return dev_err_probe(&pdev->dev, ret, "Failed to register Rockchip 
>> hwrng\n");
>> +
>> +	dev_info(&pdev->dev, "Registered Rockchip hwrng\n");
> 
> Drop, driver should be silent on success.

I respectfully disagree.  Many drivers print a single line upon
successful probing, which I find very useful.  In this particular
case, it's even more useful, because some people may be concerned
about the use of hardware TRNGs, so we should actually make sure
to announce it.
