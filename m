Received: from mslow3.mail.gandi.net (mslow3.mail.gandi.net [217.70.178.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970CB393DE2;
	Mon, 12 Oct 2026 09:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.178.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791796339; cv=none; b=iXShzCYAeZM0G+8F6H4rUmG5goe6ehIGtEf/4dXCpv5Aw/IS13NJlGy+qhM3WMc9y1CrmTvp2/KPK6dx7MOAILCHHC7kBm7q/cXVXytf7YmfB2pI3LIHR3NiGA5cy49L6WeG/WxMQIzzq/KxrWbL+XnYq2xB8wewIPF2F9fXb5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791796339; c=relaxed/simple;
	bh=JJbp9gY5o+Y9jQt84wdvC7PHP6OKYOMmG0y/d7r9l+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nYK/TJr+lk2Lc1a0mAK44orTmWocpaVSxIywPeYy/Ea4zLvGzXhz7C2M1I7TKjNmrKz0V8opQItLwHJubJF3RMV9zKpaPhwNW23qCskz1/9IDQlt+EfAGjsY3BaWrcmr/zqE+o9obdrrpf5Fz6aLeCFe2uxDNZ6xvfcfZl6hjgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yoseli.org; spf=pass smtp.mailfrom=yoseli.org; dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b=AAz8ZPAZ; arc=none smtp.client-ip=217.70.178.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yoseli.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yoseli.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yoseli.org header.i=@yoseli.org header.b="AAz8ZPAZ"
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by mslow3.mail.gandi.net (Postfix) with ESMTP id A475F580BAB;
	Mon, 12 Oct 2026 08:46:29 +0000 (UTC)
Received: by mail.gandi.net (Postfix) with ESMTPSA id 957A53EB8E;
	Mon, 12 Oct 2026 08:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yoseli.org; s=gm1;
	t=1791794782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=19boBTCsjzigUNehuNnbCAd0sjXKxyv/w6iDQ2Y4Fdc=;
	b=AAz8ZPAZyEpuFA2hg1GD2suLLmvBqd0ODa7hc1UL+saONfjIxVSk6G/tnsQe2ISC1P0G4y
	VfxTMHDMvQ0SZdF0yzIY/jsdYFHuCL2MQyvJFMaWhQm9liejE3gEDXTWRaJYvrtY6XxDTY
	QeVKWrkiKVYFh8wizEQb7r8XBHtku4LDZ4ZwEiIndpKFQaTH7DIpd3jqTHzBuTH7olquCm
	HUb/Zl1H7kEfZa5DEizrslSK8++usYILUQQIMp6BKUNSzVEKh+aFJ+ehl/oZFk6NR2R63V
	nudiPNLAPLX9rUQkjM56gpuhxlvy2Vvo5vSA8vmwDlfzD9bBEl+/zdF274qzUQ==
Message-ID: <ee54b08f-b3d8-4a62-bc43-0117a9b11102@yoseli.org>
Date: Mon, 12 Oct 2026 10:46:16 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] m68k: coldfire: Add RNG support for MCF54418
To: Greg Ungerer <gerg@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 Olivia Mackall <olivia@selenic.com>, Shawn Guo <shawnguo@kernel.org>,
 Sascha Hauer <s.hauer@pengutronix.de>,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>, linux-m68k@lists.linux-m68k.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 Frank Li <Frank.Li@nxp.com>, Herbert Xu <herbert@gondor.apana.org.au>
References: <20251126-b4-m5441x-add-rng-support-v4-0-5309548c9555@yoseli.org>
 <20251126-b4-m5441x-add-rng-support-v4-2-5309548c9555@yoseli.org>
 <bd25e903-30fc-4905-986c-96d1b42e9f02@linux-m68k.org>
 <ddf0ab32-5b66-453e-b7aa-1722aeaf2aa0@yoseli.org>
 <9ba1ebd8-61cc-4e1a-b68d-906b20dd4999@polyxeno.com>
 <asn8e5puc3I01Lva@gondor.apana.org.au>
 <8be9c875-68a9-4bb5-b581-501a0a6819f4@linux-m68k.org>
Content-Language: fr-FR, en-US, en-GB
From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
In-Reply-To: <8be9c875-68a9-4bb5-b581-501a0a6819f4@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-GND-Sasl: jeanmichel.hautbois@yoseli.org
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTEPWrJqe016L8I3chHHuK71fvLMlYu+6IrNfxrvD/MyQtgB2kOmSroRn5pztNxyoPXTsP3v9st2xoK0cTKVkCkEXnzk+tyydkEnZa3BeDOpN+lBo3VSfju+U2Tk5DFLr2QTf3rS7cF70bZN6RCshXOZ6HVSfbaHlah6rgF+S1ghDvtrdNc33ylG978pFkIVKZAjrHrrK4lzsId4ZikSGWG++dyZRIZYSLuxWGOy6uWwFvRqYp7eHk+F8lCkqQkRzDYLf/PNuPs9yHrHnCbSXcwXnUuKid+zR4eyu85684+A5SFc3yxeSVSajXUtZMboFqBEssGGUH2TBR8Yk1f07MSZJgLkJ/dO+CwPvwngLjI92MEv73dMHbbBqJibq0do1B0Lz0Zo4mzA4OezcBN5mVpeb0VThW9sEYznRUJeYGoRvkCbWRdrYkcknQFhqJwUI1dRKs9JjHOG0kHLDHZ8rpKjMT14YRCg/zYDN9c5wK/DOOHXEvlA1ipL+b+3rKxzP3fnDw63p4Y44/pyd0xok+TQxEAM35f5EE+5btGH4X2G7kPlNHHh5Ik+e2cJFW/1kSa3D12NjWBUnaHClNFyhqUsOcUOJZDYAZk3O5uHc2Xx45m7gaOtKGgKEbDe1QC01g3/kF2lnlW+BO6+ah4NHNgEER4kazqxwF5roUA2tzhB1w

Hi Greg,

Le 11/10/2026 à 17:28, Greg Ungerer a écrit :
> Hi JM,
> 
> On 10/10/26 18:51, Herbert Xu wrote:
>> On Wed, Aug 19, 2026 at 07:36:36AM +1000, Greg Ungerer wrote:
>>> Hi JM,
>>>
>>> On 19/8/26 01:09, Jean-Michel Hautbois wrote:
>>>> Hi Greg,
>>>>
>>>> Sorry for the very long silence on this one, it fell off my radar...
>>>>
>>>> Le 03/12/2025 à 13:15, Greg Ungerer a écrit :
>>>>> Hi Jean-Michel,
>>>>>
>>>>> On 26/11/25 17:08, Jean-Michel Hautbois via B4 Relay wrote:
>>>>>> From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
>>>>>>
>>>>>> Add support for the hardware Random Number Generator (RNGB) found on
>>>>>> MCF54418 ColdFire processors with clock enabled at platform
>>>>>> initialization.
>>>>>>
>>>>>> The RNGB block is compatible with the imx-rngc driver.
>>>>>>
>>>>>> Reviewed-by: Frank Li <Frank.Li@nxp.com>
>>>>>> Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
>>>>>> ---
>>>>>>    arch/m68k/coldfire/device.c       | 28 ++++++++++++++++++++++++++++
>>>>>>    arch/m68k/coldfire/m5441x.c       |  2 +-
>>>>>>    arch/m68k/include/asm/m5441xsim.h |  9 +++++++++
>>>>>>    drivers/char/hw_random/Kconfig    |  3 ++-
>>>>>>    drivers/char/hw_random/imx-rngc.c |  7 +++++++
>>>>>>    5 files changed, 47 insertions(+), 2 deletions(-)
>>>>>
>>>>> I am happy with the ColdFire arch parts, so from me:
>>>>>
>>>>>       Acked-by: Greg Ungerer <gerg@linux-m68k.org>
>>>>>
>>>>> I don't mind taking this commit via the m68knommu git tree if the hw_rng
>>>>> maintainers are ok with that. Otherwise if you break out the arch/m68k
>>>>> parts I can apply those on their own.
>>>>
>>>> I think Herbert acked ?
>>>> Do you need another ack ?
>>>
>>> I would like to see an acknowledgement that taking this patch via the
>>> m68knommu git tree (to Linus) is ok with the RNG maintainers.
>>
>> I have no objections to this.
> 
> Thanks Herbert.
> 
> JM: I have applied this to the for-next branch of the m68knommu git tree.
> I didn't quite go on cleanly, so please double check it for me.

Thanks, I think you missed 1/2 ?
Or did I miss something ?

Thanks !
JM

> 
> Regards
> Greg

