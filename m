Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81411863E;
	Sat, 22 Jun 2024 19:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719083472; cv=none; b=Jf7ghcTRCvClm+DeWB+69glk2kgwks8/R7XAsgPdQDcqgATJ0oAQW3QsSiObh2iZTufYKuDaSJl190dIMdOvuUnSxIxkh1Tf3Ox6Ngxs6riKShjspu8XQsy9cLu8BbZXkZzItWq7YbI+gotINVJqWrrzhQdLa1SSECDlw/LliJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719083472; c=relaxed/simple;
	bh=bNKqvfJcCxUliXk6egw86vUhi6IGdTyXYpgstC1ig48=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=jIfEyOGxmTe+2Ak8l922+HlsnwP0PZGX8GoOsVJgNfHQekhdoVFrISrI9cPAZMxhXqC3oTklYe2P97e4orOVUH5x5FFiDqMGTGeHGPH1t4IyTOrfCotCmtPr62pqukjAOnaVjCBvXynyCsOZrK3IGBE1Rxpt7QQ+1NCD03kHEog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=idOUMRHg; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="idOUMRHg"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1719083460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tsjjMssJVG+oE9sGmhyMnAuMsLYA+R/eJrkwoODbgVM=;
	b=idOUMRHgDMpzEsj+i3s89C5EXijlVePhRa+bpbkscQNve3CaiAVRAquR5LhFjvWmhGX+6z
	irhFMpwC7zk58vCbGxXZMKq4Fvj0g55tJK2ejOgGHS5NlNN0ChmgsYhhjV3wbFq6Ne7bR2
	UL7h+0z7qTcaQJNwG8ndMIYCnJjanxHwaWmfnvoiG8b/tcyzrOvJCveyR1osDmeR1Pf2jq
	qcMWJfHwLXVHzJjhqIZUNeSAHXY6SHUeSOFAtXEQ1wkEFQp+8mBaj20wET9FHEq6PKmntC
	XEr4C5IztY+yDK2mrLwkOw1EPaSKIN5T816EVmMuaO7lWsUmcYTrvGwgpezlSQ==
Date: Sat, 22 Jun 2024 21:10:52 +0200
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
In-Reply-To: <303bc9df-c887-41d0-8613-0fa2898ab48e@kernel.org>
References: <cover.1718921174.git.daniel@makrotopia.org>
 <57a7fb13451f066ddc8d1d9339d8f6c1e1946bf1.1718921174.git.daniel@makrotopia.org>
 <f8e6b1b9-f8ff-42df-b1ef-bcc439c2e913@kernel.org>
 <173ce1663186ab8282356748abcac3f4@manjaro.org>
 <303bc9df-c887-41d0-8613-0fa2898ab48e@kernel.org>
Message-ID: <b1adbe2604561e0958bd5084fe679eea@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Krzysztof,

On 2024-06-22 20:05, Krzysztof Kozlowski wrote:
> On 21/06/2024 20:13, Dragan Simic wrote:
>> On 2024-06-21 11:57, Krzysztof Kozlowski wrote:
>>> On 21/06/2024 03:25, Daniel Golle wrote:
>>>> From: Aurelien Jarno <aurelien@aurel32.net>
>> 
>> [snip]
>> 
>>>> +	pm_runtime_set_autosuspend_delay(dev, RK_RNG_AUTOSUSPEND_DELAY);
>>>> +	pm_runtime_use_autosuspend(dev);
>>>> +	pm_runtime_enable(dev);
>>>> +
>>>> +	ret = devm_hwrng_register(dev, &rk_rng->rng);
>>>> +	if (ret)
>>>> +		return dev_err_probe(&pdev->dev, ret, "Failed to register 
>>>> Rockchip
>>>> hwrng\n");
>>>> +
>>>> +	dev_info(&pdev->dev, "Registered Rockchip hwrng\n");
>>> 
>>> Drop, driver should be silent on success.
>> 
>> I respectfully disagree.  Many drivers print a single line upon
>> successful probing, which I find very useful.  In this particular
> 
> No, it's duplicating existing interfaces and polluting log 
> unnecessarily
> without any useful information.

Would you, please, clarify what existing interfaces are you
referring to?

>> case, it's even more useful, because some people may be concerned
>> about the use of hardware TRNGs, so we should actually make sure
>> to announce it.
