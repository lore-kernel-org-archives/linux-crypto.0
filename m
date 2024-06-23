Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B282CA7;
	Sun, 23 Jun 2024 09:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719136037; cv=none; b=mLS/5m6pMmTh2MvvaXA7byjQhDKReHlwyVLWvXzsqpxtLWb7jgPoneK4sizHZKyWU7u1POvcuAUvAmU8M2MJsAlc3Xs2QoEOqz3TNA5qChMt5qQRhsH1r4MBn+SucRdGiI8UiLKbBZGkMI27wvdVE1sVgKDhkos1SqNXqlcD+C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719136037; c=relaxed/simple;
	bh=IoaeKT8XpnnlbWlzxCWTjF0duh7pAxL12B/Wwz0WEYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=heUw4Vs4mzGZ0TwOliiag+UtgH26Wm93thrkKU7kkwX8T3mSoND53WVxkL695bdxhr+K90Jriur34G+YjFN7YjxPhWD8p4Z7vaq+h4LnwcvXCgBA+2MH9DQaano3dzzVlZii8B0wP7e3vWdt44j4uyB+30cE8IrE6kvcXBS8mHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=S/bjxUlO; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="S/bjxUlO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:Content-Type
	:In-Reply-To:From:References:To:Subject:MIME-Version:Date:Message-ID:Reply-To
	:Cc:Content-ID:Content-Description;
	bh=3CsmWJkTCw2jya7yKPckZb+JwnRAGwemKYs+ww4s8j8=; b=S/bjxUlO9I8ybdU5ALqZwHdTFq
	67j1QPwyYKmfNx6/72eTci7oHSYYA2moxwevv+faRy5PI7jIYipdoetqWT8ep0R9prWiwVXl+01Jn
	7xQ4R7f17pmI8e2Key+nixdyPshM/oWS+C0zvEu1SPukzQXrFXIaWDqUxNvhnMqlQtpoyx7wI2/K1
	QbKLRfsNBw8uRuFgGDfhdLEAbIcvpZKQlzoNFDNDVwysvfI+VE/ovki11LFjLfjKO2ygVDxF1jeKg
	OPhrSVenBYPre2t7MzIHSxkXiCawabOVUyUadukZGu21D7JOHtRCWMptN/SjAYOHR03hkISd5mUkr
	tn36iRWg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	(Exim 4.94.2)
	(envelope-from <ukleinek@debian.org>)
	id 1sLJnr-00HNav-0c; Sun, 23 Jun 2024 09:46:31 +0000
Message-ID: <395f8ebe-1392-4d8f-b91f-c9a8f5f48afe@debian.org>
Date: Sun, 23 Jun 2024 11:46:25 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] hwrng: add Rockchip SoC hwrng driver
To: Krzysztof Kozlowski <krzk@kernel.org>,
 Daniel Golle <daniel@makrotopia.org>, Aurelien Jarno <aurelien@aurel32.net>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
 Philipp Zabel <p.zabel@pengutronix.de>,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Sascha Hauer <s.hauer@pengutronix.de>, Dragan Simic <dsimic@manjaro.org>,
 Martin Kaiser <martin@kaiser.cx>, Ard Biesheuvel <ardb@kernel.org>,
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1719106472.git.daniel@makrotopia.org>
 <240db6e0ab07e8e2a86da99b0fc085eabaf9f0cc.1719106472.git.daniel@makrotopia.org>
 <612bd49c-c44a-41f2-89e9-c96e62e52a0a@kernel.org>
Content-Language: en-US, de-DE
From: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <ukleinek@debian.org>
In-Reply-To: <612bd49c-c44a-41f2-89e9-c96e62e52a0a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Debian-User: ukleinek

Hello Krzysztof,

On 6/23/24 09:00, Krzysztof Kozlowski wrote:
> On 23/06/2024 05:33, Daniel Golle wrote:
>> +
>> +	pm_runtime_set_autosuspend_delay(dev, RK_RNG_AUTOSUSPEND_DELAY);
>> +	pm_runtime_use_autosuspend(dev);
>> +	devm_pm_runtime_enable(dev);
>> +
>> +	ret = devm_hwrng_register(dev, &rk_rng->rng);
>> +	if (ret)
>> +		return dev_err_probe(&pdev->dev, ret, "Failed to register Rockchip hwrng\n");
>> +
>> +	dev_dbg(&pdev->dev, "Registered Rockchip hwrng\n");
> 
> Drop, it is not useful at all. Srsly, we had already long enough talk,
 > [...]

And in this long talk using dev_dbg() was one of the suggestions for a 
compromise. For me this is ok.

> There is no single benefit of such debug statement. sysfs already
> provides you this information. Simple entry/exit  is provided by
> tracing. You duplicate existing interfaces without any benefit, because
> this prints nothing more.

There might be a (small) value if you want to know when during boot the 
device becomes available. So having a dev_dbg() that can be enabled 
dynamically (assuming DYNAMIC_DEBUG=y) and isn't in the way otherwise 
might be justified. IMHO a dev_dbg is lightweight enough that *I* won't 
continue the discussion.

Best regards
Uwe
