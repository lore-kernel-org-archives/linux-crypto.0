From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 2/2] Crypto: Talitos: Support for Async_tx XOR offload
Date: Wed, 16 Dec 2009 15:47:48 -0700
Message-ID: <4B296394.9010709@intel.com>
References: <1260977698-4076-1-git-send-email-Vishnu@freescale.com> <20091216164144.daff5468.kim.phillips@freescale.com> <2868C8CF-584B-4FA7-9C3B-2FACEF77527E@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Kim Phillips <Kim.Phillips@freescale.com>,
	Vishnu Suresh <Vishnu@freescale.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"B04825@freescale.com" <B04825@freescale.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Dipen Dudhat <Dipen.Dudhat@freescale.com>,
	Maneesh Gupta <Maneesh.Gupta@freescale.com>,
	"R58472@freescale.com" <R58472@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47754 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbZLPWru (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Dec 2009 17:47:50 -0500
In-Reply-To: <2868C8CF-584B-4FA7-9C3B-2FACEF77527E@kernel.crashing.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kumar Gala wrote:
>>> Changes with respect to v1 as per comments received
>>> o. Rebased to linux-next as of 20091216
>>> o. The selection is based exclusive of fsldma
>>> o. Intoduced a new Kernel Configuration variable
>>>   *. This enables selecting the Cryptographic functionality
>>>      of Talitos along with fsldma.
>>>   *. Disables the XOR parity calculation offload, if fsldma enabled
>>>      either as kernel in-built or as a module
>>>   *. Once the inter-operability with fsldma is resolved, this option
>>>      can be removed
>> wait, why can't the interoperability bug be fixed in the first place?
> 
> I agree w/Kim.  We need to better understand what the bug is and how to reproduce it so we can get to the root cause.
> 
> Paper taping over it by disabling fsldma is not the right solution.

Hopefully this prompts fsldma authors to get involved because the 
interoperability issue has been out there without comment*, just 
band-aids, since October.

--
Dan

* well one comment from Ira saying the interrupt functionality worked 
for him.
