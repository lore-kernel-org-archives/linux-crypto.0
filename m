Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A6220E3;
	Sun, 23 Jun 2024 05:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.91.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719121297; cv=none; b=U7EslKkBl8Iv7BgsN5qD0BPmv4KSyPHxLKAX2Ck8tN46Q6yp81jsm+j16R74H8voGgnCHiPBi5hA4ltpPMaRRfuYdwVqfQR3OxAgyg/OnvVJs9SZdPpaO/mxprxhTQpGeqO7N+syM3/rbS/3nEFeD6YbwRTsujbtrohISQIP6nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719121297; c=relaxed/simple;
	bh=kw2n74NFhG7fvcLMgNLgU7YKski/ADT3cGP7TRzxwjo=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=srT99wKPk91xPxepMhyq6iYGbsRzuMpzB3DUM+8SeY8aTN6OLUyIkv4VoplMLvP/Q5LTJUwZXio/1y8ITfNOSf7vvevOHGRYn9O4HobBPdA2NbrLMo6+dX5VsM5dnMP9XIxHOu3GefbSc+Ao4iouwk5RNEBQ6Q3tFBs+2UlRgiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=bZMlifUd; arc=none smtp.client-ip=116.203.91.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="bZMlifUd"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
	t=1719121291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1hA4dCOLp0zx4KWYxG86LNj6SzPfCiUAfc/2NfNSI7k=;
	b=bZMlifUds8UpGha6YTfwdj9vQC190I7o1RV82fY5Skw4kMEFmh/mtP6MrcJXK1S8Y1zquM
	IOk8O3Z9h7TaaENQfH//dhVjci+kZj9+PMgcZSpGlFuzG1XQskmgPUHL6yvz/uQNid3Yfg
	LuzY+iXeerazKvlIjCorkz2WGz4g2FsAKQIOyI1Sn5rkVp38F1IlF9+x3su2VL4mWP/H8i
	PBEcJBiTT6US6wStHFLErWiXJ9KT8oNRZ98ODDJ7OPkwTepFStaekpU6UywFDBJpZz0aQw
	1zHc2YCYD4G4mQ9XUgQjpS9rLmODGVRYd9APv3gtxklUsHztj9t3p76jEzbAmw==
Date: Sun, 23 Jun 2024 07:41:28 +0200
From: Dragan Simic <dsimic@manjaro.org>
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, Krzysztof Kozlowski
 <krzk@kernel.org>, Daniel Golle <daniel@makrotopia.org>, Aurelien Jarno
 <aurelien@aurel32.net>, Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Philipp
 Zabel <p.zabel@pengutronix.de>, Sebastian Reichel
 <sebastian.reichel@collabora.com>, Anand Moon <linux.amoon@gmail.com>,
 Sascha Hauer <s.hauer@pengutronix.de>, Martin Kaiser <martin@kaiser.cx>, Ard
 Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] hwrng: add Rockchip SoC hwrng driver
In-Reply-To: <6u4bgwemukkpjvregtvrhdarelvy4rf76n5dv5oiclbyh4q7gd@b776tut4a6ki>
References: <cover.1718921174.git.daniel@makrotopia.org>
 <ead26406-dd3b-491c-b6ab-11002a2db11a@kernel.org>
 <07fba45d99e9eabf9bcca71b86651074@manjaro.org> <3660160.WbyNdk4fJJ@diego>
 <b0164e0d05d9e445a844ffdfca7a82d5@manjaro.org>
 <6u4bgwemukkpjvregtvrhdarelvy4rf76n5dv5oiclbyh4q7gd@b776tut4a6ki>
Message-ID: <adcfb712619033fb2e55f25a512f375a@manjaro.org>
X-Sender: dsimic@manjaro.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=dsimic@manjaro.org smtp.mailfrom=dsimic@manjaro.org

Hello Uwe,

On 2024-06-23 02:20, Uwe Kleine-König wrote:
> On Sat, Jun 22, 2024 at 10:45:22PM +0200, Dragan Simic wrote:
>> On 2024-06-22 22:26, Heiko Stübner wrote:
>> > Am Samstag, 22. Juni 2024, 12:29:33 CEST schrieb Dragan Simic:
>> > > On 2024-06-22 00:16, Uwe Kleine-König wrote:
>> > > > On 6/21/24 20:13, Dragan Simic wrote:
>> > > >> On 2024-06-21 11:57, Krzysztof Kozlowski wrote:
>> > > >>> On 21/06/2024 03:25, Daniel Golle wrote:
>> > > >>>> +    dev_info(&pdev->dev, "Registered Rockchip hwrng\n");
>> > > >>>
>> > > >>> Drop, driver should be silent on success.
>> > > >>
>> > [...]
>> > So really this message should be dropped or at least as Uwe suggests
>> > made a dev_dbg.
>> 
>> As a note, "dmesg --level=err,warn", for example, is rather useful
>> when it comes to filtering the kernel messages to see only those that
>> are signs of a trouble.
> 
> IMHO it's a bit sad, that there is such a long thread about something 
> so
> trivial, but I want to make a few points:
> 
>  - not all dmesg implementations support this:
> 
> 	root@machine:~ dmesg --level=err,warn
> 	dmesg: unrecognized option '--level=err,warn'
> 	BusyBox v1.36.1 () multi-call binary.
> 
> 	Usage: dmesg [-cr] [-n LEVEL] [-s SIZE]
> 
> 	Print or control the kernel ring buffer
> 
> 		-c              Clear ring buffer after printing
> 		-n LEVEL        Set console logging level
> 		-s SIZE         Buffer size
> 		-r              Print raw message buffer
> 
>  - Your argument that the output of this dev_info can easily be ignored
>    is a very weak reason to keep it.
> 
>  - I personally consider it hard sometimes to accept feedback if I 
> think
>    it's wrong and there is a good reason to do it the way I want it.
>    But there are now three people opposing your position, who brought
>    forward (IMHO) good reasons and even a constructive alternative was
>    presented. Please stay open minded while weighting the options.
>    The questions to ask here include:
> 
>     - How many people care for this message? During every boot? Is it
>       maybe enough for these people to check in /sys if the device
>       probed successfully? Or maybe even the absence of an error 
> message
>       is enough?
>     - How many people get this message and don't care about the
>       presented information? How many people are even annoyed by it?
>     - Is the delay and memory usage introduced by this message 
> justified
>       then, even if it's small?

I'm sorry if my responses caused any inconvenience.  I find most of your
points totally valid, but there are a couple of them I could continue
arguing about.  Though, as you also pointed out, my opinion has been
already outvoted, so I'll remain silent.
