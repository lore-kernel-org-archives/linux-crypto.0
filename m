Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ECC1F76C7;
	Tue, 15 Oct 2024 16:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729011523; cv=none; b=qslidZOgGxjJbfzEZbiQCDJBID+jHPUMRPw0BmFQ06pNywfoFfQKpV+DFytPsPowBDmEE0fUjyOrve/hzlhf0Yi5o8nlHeN+Lvm+fk/iFE/HbM2UA0tUP/aanHZIadXdwxQmLJ1IwhreZY/hvmcXhWJw7BpXc+sRR3QmM5PmFFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729011523; c=relaxed/simple;
	bh=N5xtktxy1G6uRILpKJ8k41CpIUvcQl6Iw6JDeb/OqTM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WBJhyrmx24Ucyhr3Yum2FDPQ3gJkHYDkx2wmZ8QOXy6I+BABMpZmkYKXGX+pjRaxHr+fgByBGkMmk7jYKCYn8Ipm00ysLLjhXnN5Lc6jce/XVz+xk19dRdORDXTEsSIvIg7vm09SI2lCjAgoHpy2nNhYLGlk3RpzH6o0g+rqVgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=vw4aGWK3; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="vw4aGWK3"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id D921B8878A;
	Tue, 15 Oct 2024 18:58:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1729011520;
	bh=K2rDPHJqBMt/WLM3Dj0iejD1QKspAJKoayxohvdB8FM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vw4aGWK3A2fWfTFM6QPqVRm2XOjBgqiPTw5zmQxzmTjBZyz1Iev9Hx0WvLMjQoi9C
	 /btRp9gXFpuqyuHLiMCtFB8KUZgIkYXl2scjlUI3n9cwDfAh9n6XfnlNaNFPnPVHMp
	 DX8MAEgNqf3nsu6a966oB0Ixj/U6MKiK664AT4pDO8bHvr0Ttbf6JQqtsTkNKGK2ol
	 6RFRYkaP/p6hC2iQUbdxjaiZ4YqTjmfgENXpeX/u+awnd5C9XCaZOctUhQ8vCHwTGx
	 hElHB/CAbqBnqZ3EDcL3h/bicmyeoQdCMMEISWYc/cNGva8KIFfCgIYVHl/OJTApfJ
	 e5JbQj+4qsF1g==
Message-ID: <b9dc693a-3e85-4118-b792-806f07bc3e07@denx.de>
Date: Tue, 15 Oct 2024 18:57:57 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] hwrng: stm32 - implement support for STM32MP25x
 platforms
To: Gatien Chevallier <gatien.chevallier@foss.st.com>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Lionel Debieve <lionel.debieve@foss.st.com>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20241015-rng-mp25-v2-v3-0-87630d73e5eb@foss.st.com>
 <20241015-rng-mp25-v2-v3-2-87630d73e5eb@foss.st.com>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <20241015-rng-mp25-v2-v3-2-87630d73e5eb@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 10/15/24 6:48 PM, Gatien Chevallier wrote:
> Implement the support for STM32MP25x platforms. On this platform, a
> security clock is shared between some hardware blocks. For the RNG,
> it is the RNG kernel clock. Therefore, the gate is no more shared
> between the RNG bus and kernel clocks as on STM32MP1x platforms and
> the bus clock has to be managed on its own.
> 
> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
Reviewed-by: Marek Vasut <marex@denx.de>

Thanks !
