From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: Re: Crypto/nx842: Ignore invalid XER[S0] return error
Date: Sat, 12 Dec 2015 15:01:26 -0800
Message-ID: <566CA746.1090001@linux.vnet.ibm.com>
References: <1449891029.19568.5.camel@hbabu-laptop> <20151212084348.GA26552@gate.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, ddstreet@ieee.org,
	davem@davemloft.net, mpe@ellerman.id.au, pair@us.ibm.com,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Segher Boessenkool <segher@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:33868 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbbLLXBn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 Dec 2015 18:01:43 -0500
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
	Sat, 12 Dec 2015 18:01:42 -0500
In-Reply-To: <20151212084348.GA26552@gate.crashing.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/12/2015 12:43 AM, Segher Boessenkool wrote:
> On Fri, Dec 11, 2015 at 07:30:29PM -0800, Haren Myneni wrote:
>> NX842 coprocessor sets 3rd bit in CR register with XER[S0] which is
>> nothing to do with NX request. On powerpc, XER[S0] will be set if
>> overflow in FPU and stays until another floating point operation is
>> executed. Since this bit can be set with other valuable return status,
>> ignore this XER[S0] value.
> 
> XER[SO] is the *integer* summary overflow bit.  It is set by OE=1
> instructions ("addo" and the like), and can only be cleared explicitly
> (using "mtxer").

Thanks for the correct description. I was told XER[S0] is floating overflow from FPU.

> 
> The floating point overflow bit is FPSCR[OX].
> 
>> +	/*
>> +	 * NX842 coprocessor sets 3rd bit in CR register with XER[S0].
>> +	 * Setting XER[S0] happens if overflow in FPU and stays until
>> +	 * other floating operation is executed. XER[S0] value is nothing
>> +	 * to NX and no use to user. Since this bit can be set with other
>> +	 * return values, ignore this error.
>> +	 */
>> +	if (ret & ICSWX_XERS0)
>> +		ret &= ~ICSWX_XERS0;
> 
> You can just always clear it, there is no need to check if it is set first.

Do you mean reset this before calling NX? I believe NX coprocessor should not set CR bit as XER[S0] nothing to do with NX request and it is no use. NX is copying this CR bit with XER. But reset XER[S0] has to be done before NX request. We can not do this in icswx since this instruction can be used by other coprocessors in future. But I am not comfortable clearing as we are not touching this XER in the driver or result of NX operation. So I am proposing this patch to fix this not proper NX behaviour - ignores CR bit. 

If you are OK, I can repost the patch with proper description.

Thanks
Haren 


  
> 
> 
> Segher
> 
