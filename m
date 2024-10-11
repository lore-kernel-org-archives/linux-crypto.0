Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6A721644E;
	Fri, 11 Oct 2024 11:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728647963; cv=none; b=lgNmjD+OV2euIWSzxtdMUFWGiVM88jffezeMV+ZbC3XnRH5Bzp7D8f7bOA7/ihKLKLqdIgErtqnzzaklkLSryFSfe12Hi81MbTfCHznDNBHjLBC8G4S+QjhI8VHnW5Uz3M1QQ1MxzScRuqLxlxFs/KjLDjH/MIIyTC/M/dcFs98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728647963; c=relaxed/simple;
	bh=U3LEsolkz9g9RAkpD7e4ztp8DPs8HEASr8WRBa17/aw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=px4XyWU/dgqNmXwpWV5ozOVqi0H65PZZimES9SpIh9U7UgSpIqcU5Dh0hA8gGV81Hq4iW1+QSyFOWziCmNhb6M+QIiUTOmmWKGRIcrZeSQiKKRXsuLcJjrkXsBjQTOHku1BZJImj30GTcoXNBdefWei9/Co0SUBnSddCY6xJzkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=kofujvp4; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="kofujvp4"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 70F56892B6;
	Fri, 11 Oct 2024 13:59:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1728647957;
	bh=+UGdNzoVhustoJTF+QCSj0GHJ2kv3Y5c4vumVaqUSso=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kofujvp4rqbgaQPi63LTtT7uzTnnoJOgLXlhAnRYIvofKSV2LnNaz3j2EG0yXZwSj
	 e7oYLr6a/4xdD7+emFgRGAB8IokGUzp1k6dV//foRgF1U5FJmYyE+nJQ5tBE2tWsbB
	 ue4VvP3RhNcNHl9kkawTCUmdUZB6K4O0Mt0PYyqRN6IXOru/AAqUfj49C6GFoIEJRw
	 EJawpySVVkqDJSvXxEza9IMFLNJUGWVrQjhJnMHSjU7OE3kZHf7ybrnpOANEnt1X+5
	 Chs41k+2jqYz/LWcze1I4deLnJ5HqRb3Ko1L5MSb35qJCSahfiiad1SYPReoYoHgCy
	 B/ue0/qkjcKsQ==
Message-ID: <b4932f99-cda4-42ef-88d8-461ca6e8cefd@denx.de>
Date: Fri, 11 Oct 2024 13:24:38 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] hwrng: stm32 - implement support for STM32MP25x
 platforms
To: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>,
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
 <2fad1566-49f9-4586-b0d4-8a4a12f9e69e@denx.de>
 <9283caeb-1b84-43c2-a8a4-6b43a6962f34@foss.st.com>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <9283caeb-1b84-43c2-a8a4-6b43a6962f34@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 10/11/24 11:55 AM, Gatien CHEVALLIER wrote:
> 
> 
> On 10/7/24 15:54, Marek Vasut wrote:
>> On 10/7/24 3:27 PM, Gatien Chevallier wrote:
>>> Implement the support for STM32MP25x platforms. On this platform, a
>>> security clock is shared between some hardware blocks. For the RNG,
>>> it is the RNG kernel clock. Therefore, the gate is no more shared
>>> between the RNG bus and kernel clocks as on STM32MP1x platforms and
>>> the bus clock has to be managed on its own.
>>>
>>> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
>> A bit of a higher-level design question -- can you use drivers/clk/ 
>> clk-bulk.c clk_bulk_*() to handle all these disparate count of clock 
>> easily ?
> 
> Hi, I'd like to make sure that we enable the core clock before the bus
> clock so that the RNG hardware block can start its internal tests while
> we ungate the bus clock. It's not a strong opinion but it feels better.
Maybe this could still work if the struct clk_bulk_data {} is ordered 
that way, so the bus clock are first, and the rest afterward ?
