From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH v2 2/2] Crypto: Talitos: Support for Async_tx XOR offload
Date: Wed, 16 Dec 2009 16:38:50 -0600
Message-ID: <2868C8CF-584B-4FA7-9C3B-2FACEF77527E@kernel.crashing.org>
References: <1260977698-4076-1-git-send-email-Vishnu@freescale.com> <20091216164144.daff5468.kim.phillips@freescale.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Vishnu Suresh <Vishnu@freescale.com>, herbert@gondor.apana.org.au,
	B04825@freescale.com, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org,
	linux-crypto@vger.kernel.org,
	Dipen Dudhat <Dipen.Dudhat@freescale.com>,
	dan.j.williams@intel.com,
	Maneesh Gupta <Maneesh.Gupta@freescale.com>,
	R58472@freescale.com
To: Kim Phillips <Kim.Phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:56839 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935181AbZLPWjK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Dec 2009 17:39:10 -0500
In-Reply-To: <20091216164144.daff5468.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Dec 16, 2009, at 4:41 PM, Kim Phillips wrote:

> On Wed, 16 Dec 2009 21:04:58 +0530
> Vishnu Suresh <Vishnu@freescale.com> wrote:
> 
>> Expose Talitos's XOR functionality to be used for
>> RAID Parity calculation via the Async_tx layer.
>> 
>> Known Issue:
>> When used with fsldma, random crashes are observed
>> on some platforms. Hence, inter-operability with fsldma
>> is currently disabled
>> 
>> Thanks to Surender Kumar and Lee Nipper for their help in
>> realising this driver
>> 
>> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
>> Signed-off-by: Dipen Dudhat <Dipen.Dudhat@freescale.com>
>> Signed-off-by: Maneesh Gupta <Maneesh.Gupta@freescale.com>
>> Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
>> ---
>> Changes with respect to v1 as per comments received
>> o. Rebased to linux-next as of 20091216
>> o. The selection is based exclusive of fsldma
>> o. Intoduced a new Kernel Configuration variable
>>   *. This enables selecting the Cryptographic functionality
>>      of Talitos along with fsldma.
>>   *. Disables the XOR parity calculation offload, if fsldma enabled
>>      either as kernel in-built or as a module
>>   *. Once the inter-operability with fsldma is resolved, this option
>>      can be removed
> 
> wait, why can't the interoperability bug be fixed in the first place?

I agree w/Kim.  We need to better understand what the bug is and how to reproduce it so we can get to the root cause.

Paper taping over it by disabling fsldma is not the right solution.

- k