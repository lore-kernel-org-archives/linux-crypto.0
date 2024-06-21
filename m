Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCB612C484;
	Fri, 21 Jun 2024 22:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719008245; cv=none; b=AgDb9zp7G4cpB437f31/LMPaF1JpxvzHiSpBFB4ZoaRY36Hh4HmS7Cx7VPI9R2WUihddUJDvTyRmi8ncWKmFZoZQmmcNTKHYg00dZmiTdVOHQ0yj+uL82wOtrZwUak4lVEvGB7tSJp4y2pepMnj8ro4BdMQvI7mVGo+35/2FRP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719008245; c=relaxed/simple;
	bh=XIgP3gnjd7LTC0cYexQhnrJXzTEPBFd9t0ht0ox/1jo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ij0PfbXv+eziAOyTjGybXI7MlDqsRtk5D7MQGL4Xbcm8TEXGubTSRsCYhKcf1NtJ8SixEu0zPNfwWypIUMuCbl4+O7AUuRz9hlulK5X2yYdSbD15C13vRN+JPjKxhL4voW7Et74IqtghIRCLnX8fY5M4Kqq9CgsiCN6iwsJJ+A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FNLs4VxL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FNLs4VxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FBAC2BBFC;
	Fri, 21 Jun 2024 22:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719008244;
	bh=XIgP3gnjd7LTC0cYexQhnrJXzTEPBFd9t0ht0ox/1jo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FNLs4VxLGgEYEzsY52miCNNujSfXwPo8nvN02pkUceS4AGd/t9R0YBoGuSz0iSBC5
	 1P24T8SfRPpNKmYsJD3FQf44uMwvChSF0oWtp9SwcqssBupu93Dg7mQNvgDm9G60Uv
	 U2FFjo9EmbwgtSJ5EizcIuV+n3ybPB4bOryBaXpCd92LGyHoja7v/Y+S7s8WBBfq9C
	 XvOamhRIhWggfPWdi28OLfKdK+MZBdU6E++x8qWpRn2D5+Wu3w0XzST89l7AeJewfc
	 Y6jKnIVav4PDjOgs66bE1oBclTu97rV0yQDXG1sDtBRGWuesPPneNSCW+t+RoGwt3N
	 CuVYcjsbcJRYA==
Message-ID: <ead26406-dd3b-491c-b6ab-11002a2db11a@kernel.org>
Date: Sat, 22 Jun 2024 00:16:56 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] hwrng: add Rockchip SoC hwrng driver
To: Dragan Simic <dsimic@manjaro.org>, Krzysztof Kozlowski <krzk@kernel.org>
Cc: Daniel Golle <daniel@makrotopia.org>,
 Aurelien Jarno <aurelien@aurel32.net>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
 Philipp Zabel <p.zabel@pengutronix.de>,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Anand Moon <linux.amoon@gmail.com>, Sascha Hauer <s.hauer@pengutronix.de>,
 Martin Kaiser <martin@kaiser.cx>, Ard Biesheuvel <ardb@kernel.org>,
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1718921174.git.daniel@makrotopia.org>
 <57a7fb13451f066ddc8d1d9339d8f6c1e1946bf1.1718921174.git.daniel@makrotopia.org>
 <f8e6b1b9-f8ff-42df-b1ef-bcc439c2e913@kernel.org>
 <173ce1663186ab8282356748abcac3f4@manjaro.org>
Content-Language: en-US, de-DE
From: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
In-Reply-To: <173ce1663186ab8282356748abcac3f4@manjaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello Dragan,

On 6/21/24 20:13, Dragan Simic wrote:
> On 2024-06-21 11:57, Krzysztof Kozlowski wrote:
>> On 21/06/2024 03:25, Daniel Golle wrote:
>>> From: Aurelien Jarno <aurelien@aurel32.net>
> 
> [snip]
> 
>>> +    pm_runtime_set_autosuspend_delay(dev, RK_RNG_AUTOSUSPEND_DELAY);
>>> +    pm_runtime_use_autosuspend(dev);
>>> +    pm_runtime_enable(dev);
>>> +
>>> +    ret = devm_hwrng_register(dev, &rk_rng->rng);
>>> +    if (ret)
>>> +        return dev_err_probe(&pdev->dev, ret, "Failed to register 
>>> Rockchip hwrng\n");
>>> +
>>> +    dev_info(&pdev->dev, "Registered Rockchip hwrng\n");
>>
>> Drop, driver should be silent on success.
> 
> I respectfully disagree.  Many drivers print a single line upon
> successful probing, which I find very useful.  In this particular
> case, it's even more useful, because some people may be concerned
> about the use of hardware TRNGs, so we should actually make sure
> to announce it.

I agree to Krzysztof here. From the POV of a driver author, your own
driver is very important and while you write it, it really interests
*you* if the driver is successfully probed. However from a system
perspective these are annoying: There are easily >50 devices[1] on a
system, if all of these print a message in probe, you have little chance
to see the relevant messages. Even if every driver author thinks their
work is a special snow flake that is worth announcing, in practice users
only care about your driver if there is a problem. Additionally each
message takes time and so delays the boot process. Additionally each 
message takes place in the printk ring buffer and so edges out earlier 
messages that might be more important.

So +1 for dropping the dev_info() or at least using dev_debug() for it.

Best regards
Uwe

[1] On my laptop if have:

	$ find /sys/devices -name driver | wc -l
	87

     On a Raspberrypi it yields 66.
