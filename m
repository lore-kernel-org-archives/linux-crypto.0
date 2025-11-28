Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523913054F8;
	Fri, 28 Nov 2025 10:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764326216; cv=none; b=Ub/dRhSiTko+QVtuH6b3cIUfIPT+ZK7OyQAPFSq0letiI22xCkQvlJC7ZVpTRKXGxiLRB9F0SlFmphJcyNUaOkiFPakmC+3XUQj9O5frQ4hzM/ip50SuwR3G5fURCaIuhriUUSZW7gGvKfSREw5xEZHiZt1L4lUYIch/fvTWA3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764326216; c=relaxed/simple;
	bh=gS1OFzixQRxxWZtiC2pcNhNU6BQ9IEUj0ZxgJCQzowM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=cHFvtMnT/ZD3LT/9w8DTGwAKUWodAuZ6HxmUslJjG8ogCidSe61vSw3DS7A7kZx871abxs7WzwurUD4Q8N+J90QDZsP57bHKMgDlmJwIamHn8ObT0EVNLdVy8NYgaUogvApGFQCyKT6+N1HXumRFFST8mjKOdKzxxY409Bg1FZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rwqadcyn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rwqadcyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEEDC4CEF1;
	Fri, 28 Nov 2025 10:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764326215;
	bh=gS1OFzixQRxxWZtiC2pcNhNU6BQ9IEUj0ZxgJCQzowM=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=Rwqadcyn62wfoPCoW86RInP99ZLSG6nJcfnIOKIMS8GFOb1965LtZo5Oi7PM8HKiR
	 f7RI2hVvhUjQqGxSoaotblbciHlile6YWO+2kHJaMK7BFeqDT3lWR22rVgSLBmgwPo
	 xRJTRU33jedFtFsyZOyC3nDDUgWEV/D9M6hUxLiryh0qtrvIUMFquqPU5GKWTGkVG2
	 vWuMz4fXychHZlAH/SMDolbsup77yLfbtZmbMQXer/f9CF6CP8/bVIxS3Fems7r5Hf
	 2qRjy56sK0M10A/Fe0ye6nLzEkrXPyLhzuZ5KtPKLYq6ucAQaW+e1t2wSTz9jtJgNV
	 HI9OnXq3tLMeA==
Message-ID: <51e2de7a-5913-4c53-9637-6d60f875e3d8@kernel.org>
Date: Fri, 28 Nov 2025 11:36:24 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Ahmad Fatoum <ahmad@kernel.org>
Subject: Re: CAAM RSA breaks cfg80211 certificate verification on iMX8QXP
To: Vitor Soares <ivitro@gmail.com>, Ahmad Fatoum <ahmad@kernel.org>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 imx@lists.linux.dev
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
 herbert@gondor.apana.org.au, john.ernberg@actia.se,
 meenakshi.aggarwal@nxp.com
References: <b017b6260075f7ba11c52e71bcc5cebe427e020f.camel@gmail.com>
 <ac727d79bdd7e20bf390408e4fa4dfeadb4b8732.camel@gmail.com>
 <3d44957f-8c09-47f3-93e0-78a1d34adfd0@kernel.org>
 <82e78d56c7df6e1f93de29f9b3a70f7c132603c4.camel@gmail.com>
Content-Language: en-US, de-DE, de-BE
In-Reply-To: <82e78d56c7df6e1f93de29f9b3a70f7c132603c4.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Vitor,

On 11/26/25 7:35 PM, Vitor Soares wrote:
> On Wed, 2025-11-26 at 13:59 +0100, Ahmad Fatoum wrote:
>> Is the CAAM cache-coherent on your SoC? If so does the DT specify dma-coherent
>> as it should? On i.MX8M, it's not cache-coherent, but on Layerscape it was and
>> the mismatch with the DT leads to symptoms matching what you are observing.
>>
> 
> Thanks for the suggestion. I tested with dma-coherent added to the CAAM and job
> ring nodes but the issue persists.
> I traced through the DMA path in caampkc.c and confirmed:
> 
> - dma_map_sg() is called in rsa_edesc_alloc() with DMA_FROM_DEVICE
> - dma_unmap_sg() is called in rsa_io_unmap() from rsa_pub_done() before
> completion
> - CAAM returns status err=0x00000000 (success)
> - dst_nents=1 
> 
> Yet the output buffer remains untouched (still contains my 0xAA poison pattern).
> The kernel DMA handling appears correct. CAAM accepts the job and reports
> success, but never writes the RSA result. Given that CAAM reports success but
> does not populate the RSA output buffer, the problem appears to be somewhere in
> the RSA execution flow (possibly in how the result buffer is handled or
> returned), but I don't have enough insight into CAAM's RSA implementation.

Ok.. That was the only thing off the top of my head right now.

>> Off-topic remark: If you have performance comparison between running with and
>> without CAAM RSA acceleration, I'd be interested to hear about them.
>> At least for the hashing algorithms, using the Cortex-A53 (+ CE) CPU was a lot
>> faster than bothering with the CAAM "acceleration".
>>
> 
> I haven't done a kernel-level CAAM vs software RSA comparison, but OpenSSL with
> ARM Crypto Extensions shows ~3100 verify ops/sec and ~80 sign ops/sec for RSA
> 2048 on the Cortex-A35.

I see, thanks.

Cheers,
Ahmad

> 
> Regards,
> Vítor
> 
> 
> 
> 

-- 
Pengutronix e.K.                  |                             |
Steuerwalder Str. 21              | http://www.pengutronix.de/  |
31137 Hildesheim, Germany         | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686  | Fax:   +49-5121-206917-5555 |

