Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64A43CB2DC;
	Mon, 12 Oct 2026 11:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791803451; cv=none; b=E+O/MMW8C7dRwO4p9fjC6PTSH8hz+k9uIVwSQ96iGQ2dOyGqgyqVL1QTi7u3f/FRnEYambIHoz4L0GIMKKthmr5k9mwgoimOcJASGp4fczTTBfnvimAseQ8HKeU3zMKR0+X2cmtuO5aCVJar+K8jGCxR5MN5Cssz+yUUowEZQ40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791803451; c=relaxed/simple;
	bh=meL/o5DImxbUnM/+BUmkCbQ7elraRI5kkf5ONcCuyHc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NUreZwxWiPAgJxoz2ZvAA6OTFwtVsbhZHAeAfhBE1EO+qVrZK1YYTIDfmfwdHrzJyqhB4I4EcL1DI/HrhXqLmgExUfeLxC8dRUSJJLSTHaj7tmSpuOG4+ymi6gOlz289CQ50L4dKVQS1Wwiv7HwqM6+WOxmkDpT0JfMm9DxsU+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950421F0089B;
	Mon, 12 Oct 2026 11:10:46 +0000 (UTC)
Message-ID: <d2a8ae3b-779d-42c2-8a36-2770ab7ce19c@linux-m68k.org>
Date: Mon, 12 Oct 2026 21:10:29 +1000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] m68k: coldfire: Add RNG support for MCF54418
To: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
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
 <ee54b08f-b3d8-4a62-bc43-0117a9b11102@yoseli.org>
Content-Language: en-US
From: Greg Ungerer <gerg@linux-m68k.org>
In-Reply-To: <ee54b08f-b3d8-4a62-bc43-0117a9b11102@yoseli.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi JM,

On 12/10/26 18:46, Jean-Michel Hautbois wrote:
> Le 11/10/2026 à 17:28, Greg Ungerer a écrit :
>> On 10/10/26 18:51, Herbert Xu wrote:
>>> On Wed, Aug 19, 2026 at 07:36:36AM +1000, Greg Ungerer wrote:
>>>> On 19/8/26 01:09, Jean-Michel Hautbois wrote:
>>>>> Sorry for the very long silence on this one, it fell off my radar...
>>>>>
>>>>> Le 03/12/2025 à 13:15, Greg Ungerer a écrit :
>>>>>> Hi Jean-Michel,
>>>>>>
>>>>>> On 26/11/25 17:08, Jean-Michel Hautbois via B4 Relay wrote:
>>>>>>> From: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
>>>>>>>
>>>>>>> Add support for the hardware Random Number Generator (RNGB) found on
>>>>>>> MCF54418 ColdFire processors with clock enabled at platform
>>>>>>> initialization.
>>>>>>>
>>>>>>> The RNGB block is compatible with the imx-rngc driver.
>>>>>>>
>>>>>>> Reviewed-by: Frank Li <Frank.Li@nxp.com>
>>>>>>> Signed-off-by: Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>
>>>>>>> ---
>>>>>>>    arch/m68k/coldfire/device.c       | 28 ++++++++++++++++++++++++++++
>>>>>>>    arch/m68k/coldfire/m5441x.c       |  2 +-
>>>>>>>    arch/m68k/include/asm/m5441xsim.h |  9 +++++++++
>>>>>>>    drivers/char/hw_random/Kconfig    |  3 ++-
>>>>>>>    drivers/char/hw_random/imx-rngc.c |  7 +++++++
>>>>>>>    5 files changed, 47 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> I am happy with the ColdFire arch parts, so from me:
>>>>>>
>>>>>>       Acked-by: Greg Ungerer <gerg@linux-m68k.org>
>>>>>>
>>>>>> I don't mind taking this commit via the m68knommu git tree if the hw_rng
>>>>>> maintainers are ok with that. Otherwise if you break out the arch/m68k
>>>>>> parts I can apply those on their own.
>>>>>
>>>>> I think Herbert acked ?
>>>>> Do you need another ack ?
>>>>
>>>> I would like to see an acknowledgement that taking this patch via the
>>>> m68knommu git tree (to Linus) is ok with the RNG maintainers.
>>>
>>> I have no objections to this.
>>
>> Thanks Herbert.
>>
>> JM: I have applied this to the for-next branch of the m68knommu git tree.
>> I didn't quite go on cleanly, so please double check it for me.
> 
> Thanks, I think you missed 1/2 ?
> Or did I miss something ?

I assumed patch 1/2 would go via the RNG maintainers directly since it has
no dependency on, and contains no arch code for, m68knommu. Is the expectation
that I should push that too?

Regards
Greg



