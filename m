Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7733D381AA;
	Sat, 22 Jun 2024 20:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719089131; cv=none; b=If1Hem8KRMOUGVYTdwLWlwfoYW/g13dDGWybJqgbWiJ8+Wm3Ia23+6VnJuyjxkZiE7uYBvj3kp3cofdzE7RVy10s7NDoigWlRgZMcM9+A1E9X6vihUF+iHwdBOnmSa5He79v1Ph4phhrKG2JDtCBcIudyetGHijjnQslG7H8uvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719089131; c=relaxed/simple;
	bh=f361aP1H2fhPiV6ZzXRV4IlCRWpJ16KLdJmM2TAa/xg=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=dd/t6FTfYVmH1v6G9lijH4Bny100XCKXR4u7kdb+FRqfMGBLY6gMcBBGT3ASVZt4OlXAGl4JgWR1aVyWxVa7G+XlIRm8AtpwUHBRCxf/z26mNQhUdOFBcck0GzRLbbLonBm9mNJ7tjt0d8VvvzXmuIUdXXuESGmD0sWYSILpwNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=yut8vwcx; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="yut8vwcx"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1719089125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZAx6xJEcAp2BzU+6jCZ3gQ0T/OrV48S/ARN8pl1rVcw=;
	b=yut8vwcxjmeGy4YmsZGRxYcx0knvQfa1RRPq0L8Y2dElH+KmWFRYK+BC8x9fQp5Dji4FRj
	Rg+/zD5pw1CSr7whGYO4CIuiY/52drtn8tpCZwZVJUYYRFaLggpDMs+NiiNq8EDXW5kHQQ
	6+dEGFaVR8d95EdSohBI2qhlglNr0eeO/m5uas95//jDed91uFLFXxdgWASR2nxcdilWFt
	/EYmo1mcWO2M4wF+a/9ubAUq3MudExsN+bhjEgYXuFwbw4o0/OfTLSZ4pzaxC4/ueysE4X
	IONlh7c2olGV0pHdtZA0ZkrmwGQ7ZkuI1JQcUfmCmXu2W1ofoDs+m7umToCZ+g==
Date: Sat, 22 Jun 2024 22:45:22 +0200
From: Dragan Simic <dsimic@manjaro.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <ukleinek@kernel.org>, Krzysztof
 Kozlowski <krzk@kernel.org>, Daniel Golle <daniel@makrotopia.org>, Aurelien
 Jarno <aurelien@aurel32.net>, Olivia Mackall <olivia@selenic.com>, Herbert
 Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Philipp
 Zabel <p.zabel@pengutronix.de>, Sebastian Reichel
 <sebastian.reichel@collabora.com>, Anand Moon <linux.amoon@gmail.com>,
 Sascha Hauer <s.hauer@pengutronix.de>, Martin Kaiser <martin@kaiser.cx>, Ard
 Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] hwrng: add Rockchip SoC hwrng driver
In-Reply-To: <3660160.WbyNdk4fJJ@diego>
References: <cover.1718921174.git.daniel@makrotopia.org>
 <ead26406-dd3b-491c-b6ab-11002a2db11a@kernel.org>
 <07fba45d99e9eabf9bcca71b86651074@manjaro.org> <3660160.WbyNdk4fJJ@diego>
Message-ID: <b0164e0d05d9e445a844ffdfca7a82d5@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Heiko,

On 2024-06-22 22:26, Heiko Stübner wrote:
> Am Samstag, 22. Juni 2024, 12:29:33 CEST schrieb Dragan Simic:
>> On 2024-06-22 00:16, Uwe Kleine-König wrote:
>> > On 6/21/24 20:13, Dragan Simic wrote:
>> >> On 2024-06-21 11:57, Krzysztof Kozlowski wrote:
>> >>> On 21/06/2024 03:25, Daniel Golle wrote:
>> >>>> From: Aurelien Jarno <aurelien@aurel32.net>
>> >>
>> >> [snip]
>> >>
>> >>>> +    pm_runtime_set_autosuspend_delay(dev,
>> >>>> RK_RNG_AUTOSUSPEND_DELAY);
>> >>>> +    pm_runtime_use_autosuspend(dev);
>> >>>> +    pm_runtime_enable(dev);
>> >>>> +
>> >>>> +    ret = devm_hwrng_register(dev, &rk_rng->rng);
>> >>>> +    if (ret)
>> >>>> +        return dev_err_probe(&pdev->dev, ret, "Failed to register
>> >>>> Rockchip hwrng\n");
>> >>>> +
>> >>>> +    dev_info(&pdev->dev, "Registered Rockchip hwrng\n");
>> >>>
>> >>> Drop, driver should be silent on success.
>> >>
>> >> I respectfully disagree.  Many drivers print a single line upon
>> >> successful probing, which I find very useful.  In this particular
>> >> case, it's even more useful, because some people may be concerned
>> >> about the use of hardware TRNGs, so we should actually make sure
>> >> to announce it.
>> >
>> > I agree to Krzysztof here. From the POV of a driver author, your own
>> > driver is very important and while you write it, it really interests
>> > *you* if the driver is successfully probed. However from a system
>> > perspective these are annoying: There are easily >50 devices[1] on a
>> > system, if all of these print a message in probe, you have little
>> > chance
>> > to see the relevant messages. Even if every driver author thinks their
>> > work is a special snow flake that is worth announcing, in practice
>> > users
>> > only care about your driver if there is a problem. Additionally each
>> > message takes time and so delays the boot process. Additionally each
>> > message takes place in the printk ring buffer and so edges out earlier
>> > messages that might be more important.
>> 
>> Well, I don't find those messages annoying, for the drivers I've had
>> nothing to do with.  Also, in my experience, 99.9% of users don't care
>> about the kernel messages at all, be it everything hunky-dory, or be
>> it something really wrong somewhere.
>> 
>> > So +1 for dropping the dev_info() or at least using dev_debug() for it.
> 
> Just for 2ct ... I'm also in the don't print too much camp ;-) .
> When parsing kernel logs to see where things fail, messages just
> telling me about sucesses make things more difficult.
> 
> So really this message should be dropped or at least as Uwe suggests
> made a dev_dbg.

As a note, "dmesg --level=err,warn", for example, is rather useful
when it comes to filtering the kernel messages to see only those that
are signs of a trouble.
