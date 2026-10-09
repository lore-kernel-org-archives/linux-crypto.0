Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797584EDCAA;
	Fri,  9 Oct 2026 16:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791562792; cv=none; b=gvLXZ5KkhzvWnrz3E9sAf0J8fpLHuOVVHwDuk+j2iIy/CIaOiU2GBU86AoLkMkRsO6cCQKbZjXzWNqeHPhSm5RgPWMaIJlpNsHhjwwmSgWADJpD73ozS8aYRxP/UIegFfWmD1wsR42Z0JRd6ldNKLsJj1GThb7/BJiQQ7+H0n2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791562792; c=relaxed/simple;
	bh=l8lTQmuQUVNbSfDz0Zf0iH99lbvEq/5Wv5F7IBYSbig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FvBDAFrB+c13fw2JUi2zP5Qnb9C6MupFjAA0n9TXHvxud7VxDpc6AbTXwEZMbyl1kJphPJr/OqsmCAjHYUqVEe3mI/Ha+NbAZ7zE9cwJm+kWlVjDkTjlbOAtMznpXGE7lvTcUKhFjR0vxwQyaHVwnFbzSwlbGq8kOGsR2xLh+Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KjmiN4B4; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KjmiN4B4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791562786; x=1823098786;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=l8lTQmuQUVNbSfDz0Zf0iH99lbvEq/5Wv5F7IBYSbig=;
  b=KjmiN4B4Fv8fsIi3+oa42m9LawRRyXV//P1XTyfNOSYcJS3WFwu5WDVw
   UJK86YWNWfVYQEm6y3FPCHw7Q8+cFeBxpN6ACOHdo2+0kGN2SOMrCXT7G
   yyLjKezxnkPNie1/1Yr5vIa2NLioJigT7N6MW33Fk8N6CNDQrMhQhjRnI
   mnqfD/2jq/N1uqTCh7v8RQxwUbMdyhxgOiuSDwUgGyBvw4uVuz+VGNTGj
   +Lbxdl2B6JusYe2NZwCc+Zgj2vYWtoQMGRsFE4ovGTBIhJ4EtSeeaG7KK
   19ghD+9tBgByEXOpzxemLjfP/4M4/TbBX+D+p63wFv4cXPLULYSLOm9c9
   Q==;
X-CSE-ConnectionGUID: ZOezuGKDRr2JGtxEk3DExw==
X-CSE-MsgGUID: qYIwYrepQI+rxOou6glvcA==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="379056"
X-IronPort-AV: E=Sophos;i="6.27,148,1787036400"; 
   d="scan'208";a="379056"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 09:19:45 -0700
X-CSE-ConnectionGUID: fMpTZGn1Q0iTUPSwH+CJ8A==
X-CSE-MsgGUID: obzL/MyhSMSBk56GhwBt/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,148,1787036400"; 
   d="scan'208";a="662490"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.109.99]) ([10.125.109.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 09:19:44 -0700
Message-ID: <67081b4f-56a8-4ead-a912-645d5f742fd8@intel.com>
Date: Fri, 9 Oct 2026 09:19:43 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] dmaengine: change dmaengine_get_unmap_data() first
 arg to dma_chan
To: Vinod Koul <vkoul@kernel.org>
Cc: Frank.Li@oss.nxp.com, Dan Williams <djbw@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Frank Li <Frank.Li@kernel.org>,
 Jon Mason <jdmason@kudzu.us>, Allen Hubbe <allenbh@gmail.com>,
 Ard Biesheuvel <ardb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Eric Biggers <ebiggers@kernel.org>,
 "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:DMA GENERIC OFFLOAD ENGINE SUBSYSTEM"
 <dmaengine@vger.kernel.org>, "open list:NTB DRIVER CORE"
 <ntb@lists.linux.dev>, imx@lists.linux.dev, Frank Li <Frank.Li@nxp.com>
References: <20260922184527.2414043-1-Frank.Li@oss.nxp.com>
 <b40fa0d7-fbd0-4ee8-b99c-781d08c18838@intel.com> <asi3R24SY-Y2wJQx@parshuram>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <asi3R24SY-Y2wJQx@parshuram>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/9/26 2:43 AM, Vinod Koul wrote:
> On 22-09-26, 16:09, Dave Jiang wrote:
>>
>>
>> On 9/22/26 11:45 AM, Frank.Li@oss.nxp.com wrote:
>>> From: Frank Li <Frank.Li@nxp.com>
>>>
>>> Replace the struct device *dev argument with struct dma_chan *chan so
>>> callers do not need to reach into the dma_device internals to obtain
>>> the device pointer.  The implementation now derives the device via
>>> dmaengine_get_dma_device(chan), which correctly handles the per-channel
>>> IOMMU mapping case.
>>>
>>> Prepare to make dma_device private and make dmaengine API consistent.
>>>
>>> Signed-off-by: Frank Li <Frank.Li@nxp.com>
>>
>> For the NTB bits:
>> Acked-by: Dave Jiang <dave.jiang@intel.com>
>>
>>
>>> ---
>>>  crypto/async_tx/async_memcpy.c      | 4 ++--
>>>  crypto/async_tx/async_pq.c          | 4 ++--
>>>  crypto/async_tx/async_raid6_recov.c | 4 ++--
>>>  crypto/async_tx/async_xor.c         | 8 ++++----
>>
>> Maybe one day Dan's wishes will become true and someone will finally deprecate async_tx....
> 
> Does Intel still have use it. I am looking at fixing the names and we
> can drop async_tx completely...? 
> 
I don't think so. Not since ioatdma days. Dan has talked about wanting to remove async_tx for quite a few years now. No idea if there are ARM dma devices that still use that or not. 
