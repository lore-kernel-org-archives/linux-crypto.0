Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7778D1D54E2;
	Mon,  7 Oct 2024 14:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728310120; cv=none; b=FmvDW6oFHGXZx1cJqrmCv870bVnwAVtWIzfYoAWcvr438svkbD9/XmoaBt4dFTNESledGJgCSa6QJrjnqfds62ZRXvppVrkbwHcrpoZ7UogHC4mmtJFfal5JD3Zmo0OWLMEjXVsuLHZkjjDIOoGvcDJUzdk9w2yLh0Tf+/GpAPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728310120; c=relaxed/simple;
	bh=8/HXtBWcSewYHlpNmuGeBAeFCrtS0j3bzHO62Z9c6fE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T34n1DIlB2HyEsAIqsgEnEhDdsH352CNV3lLLNMiImnNapzw2aHrwymToqvtOk/PTiAmiWJF4HAumDuMDo0InPjXdzeuBnC8ecbFzirydVb7XooFR/GRN+cIpw6JqPQfiL51pXC0mEUjyL1vShBc46DaSuzwpzqJP2TLRQN4I9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=iKafxCqT; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="iKafxCqT"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 9E59788CEA;
	Mon,  7 Oct 2024 16:08:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1728310116;
	bh=vQdGIKHRyzU9Q7dYLvDcZB3dYRUP1mo2poi+xhjUMpM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iKafxCqT9JhqZEyW4zfSeS9snXdsUCDWX61pe3Ua5BmCPeaBUSu44WXHz3Mp6Ut0N
	 p6GMyZ3CbBeGILW2bTLXp8yd2Ws1d02/+QPQ9Q+oAeaLTIZHuNKzN1QFHMY6PU1EHG
	 446dsLrGukHnDjLIhVwvEgRBho3s00PC8JGHB4ssPHAkS/MbG4aSUxH4BZykRBKJ9i
	 HCGUPgkbmd19vVQTAO/sbuoWRokDk1j1m0CxcDZAT5zufJpQ1Hzd9GAII7SGl0x3B5
	 6r6G12dSMYK3NqJ+QzmN3oRJxa/prvxjYNfSQrNHbtu0pSNGsctHN6VtT0C52RoJ2O
	 6KdibxfTnx8Ng==
Message-ID: <41fb71cf-7ae8-47b8-bd0e-fc24da9d0bd3@denx.de>
Date: Mon, 7 Oct 2024 15:55:02 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] hwrng: stm32 - update STM32MP15 RNG max clock
 frequency
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
 <20241007132721.168428-4-gatien.chevallier@foss.st.com>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <20241007132721.168428-4-gatien.chevallier@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 10/7/24 3:27 PM, Gatien Chevallier wrote:
> RNG max clock frequency can be updated to 48MHz for stm32mp1x
> platforms according to the latest specifications.
> 
> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
Does this also apply to MP13 ?
