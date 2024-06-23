Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8192113AA39;
	Sun, 23 Jun 2024 11:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719143282; cv=none; b=t6g/e2SpM81ScRyI6t3GDs5JcTPDYHwsA3dBLMmLvshSOLUrjGUY/JNx4sjC+WxNUBmYsc6ihFg89DDtbZpxnH1G3tdxSiaYNaN/YRETwEL2YR91RD3oVumXrm9Zm6WSJuMK8b7LFdx/DucWeCTXSs701rB5iBGh9VZVcmMq3zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719143282; c=relaxed/simple;
	bh=w+CDf5w2t977KxI8pwc/QoX7UorZ1kCyn3RckVK/bto=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=aINH7IBJFpy0awZ0JhVu17l4w5bNHwz5rYQ8/PKBrb5zHEeikL1Zvm+RTki/bfwO/dLUrYOI1KzcLStpxgafX21sGpnatUy2T7xm7UJdJ4zx9x73jtiRq5wTSXtjDAioauhflj0gLe1k/4O5TYeXrkg9tMRT2qh1I/yn3jQdf6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=hty961XI; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="hty961XI"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1719143275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yZOaYUoA97Ep2akKiluJXo61048Ck0byvoUwJNmlD6g=;
	b=hty961XIXoBvEtYoWvvtAB6zK7d8snxmtmqhs4AqVp2gw3TC30vm8HF6cI0u2mXj4TJxJO
	qvNAGUeGfecMkrperYCtVjAVDDwcqMhiH6CopcAefHqTn1Ff+YFz9DqP9sn5QsD7VpQocR
	jMfRLNJOsjghVOPvfwH9WbBKW3dtgRDzKK4NV9Da/CjszS2c7TGGy+HtIS3mr7UgP00Br9
	e3qGF+JjNR4FZ/7YpUswgtKRk8nyCJTPQQh78PtjYEnPLd9MjC1eDGPzJ4k+u8JTFyqMWP
	0LBYR/vgWbO9fqNnOBYLeAjgmBR4wKXEhmG0TV1JwG7wnwURsrgLvxqBbsiGQg==
Date: Sun, 23 Jun 2024 13:47:47 +0200
From: Dragan Simic <dsimic@manjaro.org>
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <ukleinek@debian.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>, Daniel Golle
 <daniel@makrotopia.org>, Aurelien Jarno <aurelien@aurel32.net>, Olivia
 Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, Rob
 Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor
 Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, Philipp
 Zabel <p.zabel@pengutronix.de>, Sebastian Reichel
 <sebastian.reichel@collabora.com>, Sascha Hauer <s.hauer@pengutronix.de>,
 Martin Kaiser <martin@kaiser.cx>, Ard Biesheuvel <ardb@kernel.org>,
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] hwrng: add Rockchip SoC hwrng driver
In-Reply-To: <395f8ebe-1392-4d8f-b91f-c9a8f5f48afe@debian.org>
References: <cover.1719106472.git.daniel@makrotopia.org>
 <240db6e0ab07e8e2a86da99b0fc085eabaf9f0cc.1719106472.git.daniel@makrotopia.org>
 <612bd49c-c44a-41f2-89e9-c96e62e52a0a@kernel.org>
 <395f8ebe-1392-4d8f-b91f-c9a8f5f48afe@debian.org>
Message-ID: <051d76a29de62b943b221cf0c7662ef1@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Uwe,

On 2024-06-23 11:46, Uwe Kleine-König wrote:
> On 6/23/24 09:00, Krzysztof Kozlowski wrote:
>> On 23/06/2024 05:33, Daniel Golle wrote:
>>> +
>>> +	pm_runtime_set_autosuspend_delay(dev, RK_RNG_AUTOSUSPEND_DELAY);
>>> +	pm_runtime_use_autosuspend(dev);
>>> +	devm_pm_runtime_enable(dev);
>>> +
>>> +	ret = devm_hwrng_register(dev, &rk_rng->rng);
>>> +	if (ret)
>>> +		return dev_err_probe(&pdev->dev, ret, "Failed to register Rockchip 
>>> hwrng\n");
>>> +
>>> +	dev_dbg(&pdev->dev, "Registered Rockchip hwrng\n");
>> 
>> Drop, it is not useful at all. Srsly, we had already long enough talk,
>> [...]
> 
> And in this long talk using dev_dbg() was one of the suggestions for a
> compromise. For me this is ok.
> 
>> There is no single benefit of such debug statement. sysfs already
>> provides you this information. Simple entry/exit  is provided by
>> tracing. You duplicate existing interfaces without any benefit, 
>> because
>> this prints nothing more.
> 
> There might be a (small) value if you want to know when during boot
> the device becomes available. So having a dev_dbg() that can be
> enabled dynamically (assuming DYNAMIC_DEBUG=y) and isn't in the way
> otherwise might be justified. IMHO a dev_dbg is lightweight enough
> that *I* won't continue the discussion.

For anyone interested, below is an example that shows the usability
of knowing when a device becomes available:

https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/issues/21
