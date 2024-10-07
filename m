Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524681D47AC;
	Mon,  7 Oct 2024 14:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728310119; cv=none; b=MxXX1Ylnz0YZR1a6JmjqCvj8xfN5iuKrGv0PaUVEiNHxoXcZUCrTay8fZXlGVwSWR+ON8MiyoLThlNYf1tw0I3y8PE6WQLAiWxYbX7w7d+SpD36puejZsN7ReV+bnI0vCYh7mEhfBKgH4foMk0r4PUG4o9KtJISOu/WvIlkrK6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728310119; c=relaxed/simple;
	bh=d34LOUW5bPDJ59np/V6nRKFWhiW1bXQ/0wUdML7GWVo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sy10VeCbWDjs6Rm4vllapFXOeKgVYE8bAdM3KR9j1OXPx35FoHe28vWKIuTS9T7I2jXfQP6zBr42prXTzI1gvs3cHPRbSU9Ef6SSIUZm+Ru0Rn1GSAt/QGSe3dzWbSZOzq7VN2pRdXOcqOt4NNVGhaazoNVa99TmSipO2yHbrGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=zcCMf1BY; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="zcCMf1BY"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 6381B88CBF;
	Mon,  7 Oct 2024 16:08:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1728310115;
	bh=ZmBHTV1fOUYvvXtvrtb8Irc6COkKPbTLflN6CAGn+pc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=zcCMf1BYIgp/mPtbgBI64MFOwp+hNcIF1PYGNJjFnFNsM8Hhgbrv3gheJzFL//YKt
	 Vm26NXa29CTZ+vVL6WI9ry2Cstcg+Id6NzXauvy9JEIWor9BDhQ4LHc2vgBAoHNs2Y
	 F0HY4iXY4GWW9ICmUZlVKDI+nw4zdp156y+QUeiqzoD2YZ8c7nwLqDvr3ScP4HMIKf
	 TOLqhHoBfu3b6OLbPSGX8Tunj2zwDFEg29nYWH5aNDsa16nlCvVewXmYdaLoXE+PQg
	 aNpoRkC4etOECnPapa1N8zPtcLSkzuZpfHoGH+RTELBNVTl8BQeYu0Fe5uTFA/k4/H
	 jVgToMyobFA5Q==
Message-ID: <2fad1566-49f9-4586-b0d4-8a4a12f9e69e@denx.de>
Date: Mon, 7 Oct 2024 15:54:26 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] hwrng: stm32 - implement support for STM32MP25x
 platforms
To: Gatien Chevallier <gatien.chevallier@foss.st.com>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
 Lionel Debieve <lionel.debieve@foss.st.com>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Yang Yingliang <yangyingliang@huawei.com>
References: <20241007132721.168428-1-gatien.chevallier@foss.st.com>
 <20241007132721.168428-3-gatien.chevallier@foss.st.com>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <20241007132721.168428-3-gatien.chevallier@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 10/7/24 3:27 PM, Gatien Chevallier wrote:
> Implement the support for STM32MP25x platforms. On this platform, a
> security clock is shared between some hardware blocks. For the RNG,
> it is the RNG kernel clock. Therefore, the gate is no more shared
> between the RNG bus and kernel clocks as on STM32MP1x platforms and
> the bus clock has to be managed on its own.
> 
> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
A bit of a higher-level design question -- can you use 
drivers/clk/clk-bulk.c clk_bulk_*() to handle all these disparate count 
of clock easily ?
