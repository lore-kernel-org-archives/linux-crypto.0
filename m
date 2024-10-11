Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD1B5381E;
	Fri, 11 Oct 2024 16:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728663528; cv=none; b=WlVK2QlD9r5P4plFtKxsK8VFC1bzDxme89jY9+obH4ZaWiY7cnX5j5hGZrFGw0X5iRIBU8YetCmHiYqui0oj5vzgZBFwMuq4KgwQhY3EX0339jCHkKUAKlVkLtxrQKFiN+ghgiuL18YzD6GQkG9Pr6/eZwacEoRIiMxMF96d8ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728663528; c=relaxed/simple;
	bh=z3IvY6rAbQar0nhrAHNpssnXq/knSWZjH92chYz581w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gs77PaEtwSGWykaDxvIqZgV4oB8P3vq4O9U7WTCYAg7nzq0fGhRdenshuc9dbnG3Jmg8jZIY5STesvTUp8o7K2GpRIuUFcoPOQ60xHU/XMVsUBSc8gbb56zYS+RY5t6xW+i1yrFzBwAAqoOSgZJOgqXb69KInqXnyrLGVOXk7NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=ntbx0xm+; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="ntbx0xm+"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 20D778937B;
	Fri, 11 Oct 2024 18:18:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1728663525;
	bh=vvsbk2d8EvpWSFsU5FaWBMAvqRk0nVVmSGZCglaWOcc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ntbx0xm+McN29h2k+0qWBy/PD5MCdg3CSyzBeAjMVEAvTwH/gtYH7DCA6x7V2Hkpk
	 KyBGYvmnSz2dry564qptoY+K1gKdNw6SOPedrL9x6YOvqzZRz9rtQs92SypuURiGjD
	 EOhMFlkyA6RUWTKVGLNLYe4T0gBAjkpW2wFVauPlK72olDDXmOSDyxuMxmWo0zrPsi
	 68Lln2lYrCGUzmb2Mcnvk9l3ilBYqiCEX9GsekPGp0a3HnlqSbH4iNpHsEnTy396Ea
	 5353AC1na8vUW4UJWm0t2UA3IiYCD8ZWfKwAirR/N5MDoiASUl33jCTQiKORWMwvyt
	 QS7HC85OYhukw==
Message-ID: <54ec1bb6-9aaf-40a3-8b42-aa1b8a11b2af@denx.de>
Date: Fri, 11 Oct 2024 18:17:27 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] hwrng: stm32 - update STM32MP15 RNG max clock
 frequency
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
References: <20241011-rng-mp25-v2-v2-0-76fd6170280c@foss.st.com>
 <20241011-rng-mp25-v2-v2-3-76fd6170280c@foss.st.com>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <20241011-rng-mp25-v2-v2-3-76fd6170280c@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 10/11/24 5:41 PM, Gatien Chevallier wrote:
> RNG max clock frequency can be updated to 48MHz for stm32mp1x
> platforms according to the latest specifications.
> 
> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
Reviewed-by: Marek Vasut <marex@denx.de>
