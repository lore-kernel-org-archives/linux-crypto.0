Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7523A1E480;
	Tue, 14 May 2024 15:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715700834; cv=none; b=Tqx37+c8wxUugZHuLC8ZVGAC6HEnk4JrW293H6TQuSV3c6WE+r8SAjp81JgA+G5JumYWj7dQwfrpTmL2QqY1H9r6e1DGlwiTvxmPmSrBzwXSgQ4SWqvSLllSypEl4YUPDW2Hcv0Ye3jCb4ONBcoj6X5IbATN9f2iXmvYSMFssP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715700834; c=relaxed/simple;
	bh=I2afeUXRrRNWruaJZyuIueLvNDdutw2hjXnXM6yRGIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Frvx4s5ppkJMHNb4TEXTnSGLTox+i73G4IIsyBvPBCtVRznRvSODnCdn6tc5wnJMW2P5izGjH50oX01VODV75zkGL5dP5v54zuuSOnrZc6L4yAebB/7meO7GPrlFtjwGkh8wGwhQI73ZOPWoGVgf9PtfWjngMy2XVopqc/34M7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=Ik0uf6Gt; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="Ik0uf6Gt"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id B2F0088280;
	Tue, 14 May 2024 17:33:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1715700830;
	bh=eaQhgXWHbWMqf6I8rAKPNOuRRYsSQhfgPu8SXwLtL80=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ik0uf6Gte814yE7g5bKytAreIqV9wvHq7HCCxR7M6yyMhQ6NYTTxzn0YAF+lvNYsW
	 kPixg5xsaLs3uWHxWscWLbQ607cOgzG022nrShmYegVXZ9It1xXeuslG9SbR0MyDbe
	 Xcy964qLCku+tpgg8qMZMW36IOqsUjt5SsJgAR63uPqW3ieIbKvHh26mflRKZqZ6mR
	 fgmlw5v61zHSOTYjE0hMrfJBFiooNFYx1ErSOfq/mwTdF6LVyqNiXHnRCkxQSVI5GJ
	 xVC+TbCRAvoaqH7fYyjTrQfBKh6Ng8KSeOIKCTtxOgdJ/Y/cUSuN5RsohKqtu6JrIR
	 f/OQTkVU22kVg==
Message-ID: <cc6f98eb-f6b2-4a34-a8ed-c0f759fa4c79@denx.de>
Date: Tue, 14 May 2024 16:37:14 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [RFC] clk: stm32mp1: Keep RNG1 clock always running
To: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>,
 linux-crypto@vger.kernel.org
Cc: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Gabriel Fernandez <gabriel.fernandez@foss.st.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Michael Turquette <mturquette@baylibre.com>,
 Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
 Stephen Boyd <sboyd@kernel.org>, Yang Yingliang <yangyingliang@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com
References: <20240513220349.183568-1-marex@denx.de>
 <b2d0dfcb-37d6-4375-a4ad-ca96a5339840@foss.st.com>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <b2d0dfcb-37d6-4375-a4ad-ca96a5339840@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 5/14/24 10:10 AM, Gatien CHEVALLIER wrote:
> Hi Marek,

Hi,

> Strange indeed.

Yes.

> A potential reason that comes to my mind would be that something tries 
> to get a random number after the driver suspended and fails to do so.

Possibly.

> Else it might just be a bad clock balance.

I don't think so, this would be reported by the kernel and it would show 
up in /sys/kernel/debug/clk/clk_summary as incrementing use count. It 
would also not happen in a non-deterministic manner like this happens 
here, the hang doesn't always happen after well defined suspend/resume 
cycle count.

> Can you describe the software ecosystem that you're running please?
> (SCMI/no SCMI)?

STM32MP157C DHCOM PDK2 with mainline U-Boot 2024.07-rc2 , no SCMI.

> Do you have the 3 fixes of stm32_rng.c that you've sent recently in your
> software when testing?

Yes, but this happens even without them.

> What if you add a trace in a random generation function in random.c?

Do you have a function name or line number for me ?

> After this, I'll try to reproduce the issue.

If you have a minute to test it on some ST MP15 board, that would be 
real nice. Thanks !
