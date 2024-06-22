Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A633D79DF;
	Sat, 22 Jun 2024 10:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719052187; cv=none; b=Felq0bPcH6oM0QVM4jLMOcbbNzIOGN+KWw7dT+Gcn1+8MZ4NLCx2UrHmB/wGHz4F/d8dI7SsfzbBpvegN/fhM/15zuUp4hdQfwdHH+pBIgBi/o3OsOnE5D+i0i+u+6/MrqyEZ1V8IlC/deZB4kUbU1bYOxpN2Y+mXduPHCy3F4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719052187; c=relaxed/simple;
	bh=EbhJrZl4vfVX69Ed6tMYXe+MvUXi6WxJaYR8+kCdLp0=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=Y3XnFGVnNvBAYCGnp625iYphtM6hVVwzacY6++q/XQyy7VjWcuJOQRJmctNtttWeLL29M2cL12RdcWtSy2U7PUj/iBuHz5zwLjKxePMEIGwvE9v/Zbyli7h/Dld5DuRDBmvRs8sEkvLwRopwss25NVdO5K/qi4MRYsH3tnIjGKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=nLBuVgLd; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="nLBuVgLd"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1719052181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gAs4OzU1Oz3fZkEyE0fXcGDcqifaH35w5B5v23oDbGw=;
	b=nLBuVgLdi1Ma3AsC4BcduWrQtZljtVvLRLy8P++PL4vrCvYI8UjuY1RWa1GQEQUYAss95u
	ZhOlYTGJL8HfYiXljF3nuWBQhZXfcw60f48BGapi1QZ1eZnQVwQ7Z7NG5tBGYdPdNEEMDi
	vf45ho21uqRa1x6iiIU5HK0qfJKGsT+YzEjZUhSLXR7eeufJ6saJjzserH6ceUmcMOmi6R
	heTdohQ4ujLYbMNd9ySFlM9XgOJgb9j8eaZow2P5XcKZ4XbABY2Qku9+KTFWgnBxsZn8bM
	tlmA2OK7w48oxzYmXFfp1fzheQXxkSryBkQwf3IG2ms7svnYumxZQIfTJZMqdg==
Date: Sat, 22 Jun 2024 12:29:33 +0200
From: Dragan Simic <dsimic@manjaro.org>
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>, Daniel Golle
 <daniel@makrotopia.org>, Aurelien Jarno <aurelien@aurel32.net>, Olivia
 Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, Rob
 Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor
 Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, Philipp
 Zabel <p.zabel@pengutronix.de>, Sebastian Reichel
 <sebastian.reichel@collabora.com>, Anand Moon <linux.amoon@gmail.com>,
 Sascha Hauer <s.hauer@pengutronix.de>, Martin Kaiser <martin@kaiser.cx>, Ard
 Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] hwrng: add Rockchip SoC hwrng driver
In-Reply-To: <ead26406-dd3b-491c-b6ab-11002a2db11a@kernel.org>
References: <cover.1718921174.git.daniel@makrotopia.org>
 <57a7fb13451f066ddc8d1d9339d8f6c1e1946bf1.1718921174.git.daniel@makrotopia.org>
 <f8e6b1b9-f8ff-42df-b1ef-bcc439c2e913@kernel.org>
 <173ce1663186ab8282356748abcac3f4@manjaro.org>
 <ead26406-dd3b-491c-b6ab-11002a2db11a@kernel.org>
Message-ID: <07fba45d99e9eabf9bcca71b86651074@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Uwe,

On 2024-06-22 00:16, Uwe Kleine-König wrote:
> On 6/21/24 20:13, Dragan Simic wrote:
>> On 2024-06-21 11:57, Krzysztof Kozlowski wrote:
>>> On 21/06/2024 03:25, Daniel Golle wrote:
>>>> From: Aurelien Jarno <aurelien@aurel32.net>
>> 
>> [snip]
>> 
>>>> +    pm_runtime_set_autosuspend_delay(dev, 
>>>> RK_RNG_AUTOSUSPEND_DELAY);
>>>> +    pm_runtime_use_autosuspend(dev);
>>>> +    pm_runtime_enable(dev);
>>>> +
>>>> +    ret = devm_hwrng_register(dev, &rk_rng->rng);
>>>> +    if (ret)
>>>> +        return dev_err_probe(&pdev->dev, ret, "Failed to register 
>>>> Rockchip hwrng\n");
>>>> +
>>>> +    dev_info(&pdev->dev, "Registered Rockchip hwrng\n");
>>> 
>>> Drop, driver should be silent on success.
>> 
>> I respectfully disagree.  Many drivers print a single line upon
>> successful probing, which I find very useful.  In this particular
>> case, it's even more useful, because some people may be concerned
>> about the use of hardware TRNGs, so we should actually make sure
>> to announce it.
> 
> I agree to Krzysztof here. From the POV of a driver author, your own
> driver is very important and while you write it, it really interests
> *you* if the driver is successfully probed. However from a system
> perspective these are annoying: There are easily >50 devices[1] on a
> system, if all of these print a message in probe, you have little 
> chance
> to see the relevant messages. Even if every driver author thinks their
> work is a special snow flake that is worth announcing, in practice 
> users
> only care about your driver if there is a problem. Additionally each
> message takes time and so delays the boot process. Additionally each
> message takes place in the printk ring buffer and so edges out earlier
> messages that might be more important.

Well, I don't find those messages annoying, for the drivers I've had
nothing to do with.  Also, in my experience, 99.9% of users don't care
about the kernel messages at all, be it everything hunky-dory, or be
it something really wrong somewhere.

> So +1 for dropping the dev_info() or at least using dev_debug() for it.
> 
> Best regards
> Uwe
> 
> [1] On my laptop if have:
> 
> 	$ find /sys/devices -name driver | wc -l
> 	87
> 
>     On a Raspberrypi it yields 66.
