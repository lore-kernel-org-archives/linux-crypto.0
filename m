Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356D73F20F9;
	Fri,  9 Oct 2026 23:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791587202; cv=none; b=o0WU9n22YNhB4Lw6K+lxkWEg8GKMQUzXS/2qnz5XLgkC0JDIYZPjOkD9MoGSNiVXdEC9llAn+CqJLGP6q3eLLwMFdyFjxIxp4Rltf0Us3U1Yr0sabMuDN94t24HnKiLp4NpNzssWHRcUE57TKPALNYrRrchKmeC7IGmb9aq/E6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791587202; c=relaxed/simple;
	bh=uTKaAhre+h+714f57a5ptCMXQK1uVjxd7BGGrgoLev8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sOap8yyeiP1dMT7N1D5PPZxUW+KH0ECGJAA78lBuzD0//Str4F7MzWDe6bd7Acj2cZx/PWz+lhigQPi7I7ntO5f8JEPyGcr+5GqYfkcbC8JF1FDQxsg2++0T5cet+NnP0DpUc/X58gEyqU5B1lGeIhPqF7Ikggf5Te3W5I0Znd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aAic0nc6; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aAic0nc6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791587201; x=1823123201;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uTKaAhre+h+714f57a5ptCMXQK1uVjxd7BGGrgoLev8=;
  b=aAic0nc6rzg/cIa8jUt+ZqkwQ0X6bW/ibP0/4KUyDMTQNePWjNtbzsV8
   e9tF44LYtjbhJY60V5w2aIvdHC4pjGwUSmlUqFHE+CrZFiM7bmgOtsytF
   fbsklqJpnVIwsKTm0Hvb00XMRvOGnsRtOnXxbC7MlRvNZ29fY4aex00Wk
   TGjX3CdfHzg46kc8swFvI+VEg4fgFc6EsYTxxzaXWaxCSrBu/tCMQte7q
   2cBnvYDhmHZNqAqHGC0FbOJpMNeDWiDqHo2g0DDgNM26W2Y4dEBlbMxgv
   FWvJEhALfcJoi59bSQMKfYq4ePnb/DG6Zjnv10X8oJyeE3C353fb7HhVe
   g==;
X-CSE-ConnectionGUID: hVzfl2/dTwGkS+5a2x4QDA==
X-CSE-MsgGUID: /YYRbg7CSgaGRx73rpguZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="488598"
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="488598"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 16:06:40 -0700
X-CSE-ConnectionGUID: n4P8RrsxR6aa5kfwEkAmww==
X-CSE-MsgGUID: LYrnRV7hRty7C3yaBeE6rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="355088"
Received: from ssimmeri-mobl2.amr.corp.intel.com (HELO [10.125.109.123]) ([10.125.109.123])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 16:06:39 -0700
Message-ID: <1c913faa-06da-4b02-bd47-c74da54df0de@intel.com>
Date: Fri, 9 Oct 2026 16:06:37 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] dmaengine: change dmaengine_get_unmap_data() first
 arg to dma_chan
To: Frank Li <Frank.li@oss.nxp.com>
Cc: Vinod Koul <vkoul@kernel.org>, Dan Williams <djbw@kernel.org>,
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
 <67081b4f-56a8-4ead-a912-645d5f742fd8@intel.com> <ask6Ud7ps9A1Gkc1@SMW015318>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <ask6Ud7ps9A1Gkc1@SMW015318>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/9/26 12:02 PM, Frank Li wrote:
> On Fri, Oct 09, 2026 at 09:19:43AM -0700, Dave Jiang wrote:
>>
>>
>> On 10/9/26 2:43 AM, Vinod Koul wrote:
>>> On 22-09-26, 16:09, Dave Jiang wrote:
>>>>
>>>>
>>>> On 9/22/26 11:45 AM, Frank.Li@oss.nxp.com wrote:
>>>>> From: Frank Li <Frank.Li@nxp.com>
>>>>>
>>>>> Replace the struct device *dev argument with struct dma_chan *chan so
>>>>> callers do not need to reach into the dma_device internals to obtain
>>>>> the device pointer.  The implementation now derives the device via
>>>>> dmaengine_get_dma_device(chan), which correctly handles the per-channel
>>>>> IOMMU mapping case.
>>>>>
>>>>> Prepare to make dma_device private and make dmaengine API consistent.
>>>>>
>>>>> Signed-off-by: Frank Li <Frank.Li@nxp.com>
>>>>
>>>> For the NTB bits:
>>>> Acked-by: Dave Jiang <dave.jiang@intel.com>
>>>>
>>>>
>>>>> ---
>>>>>  crypto/async_tx/async_memcpy.c      | 4 ++--
>>>>>  crypto/async_tx/async_pq.c          | 4 ++--
>>>>>  crypto/async_tx/async_raid6_recov.c | 4 ++--
>>>>>  crypto/async_tx/async_xor.c         | 8 ++++----
>>>>
>>>> Maybe one day Dan's wishes will become true and someone will finally deprecate async_tx....
>>>
>>> Does Intel still have use it. I am looking at fixing the names and we
>>> can drop async_tx completely...?
>>>
>> I don't think so. Not since ioatdma days. Dan has talked about wanting to remove async_tx for quite a few years now. No idea if there are ARM dma devices that still use that or not.
> 
> Maybe we can create patch to skip build it firstly, let's see if there are
> really user.

There is a way to mark something going towards deprecation in KCONFIG right?

DJ

> 
> Frank

