From: Avi Kivity <avi@redhat.com>
Subject: Re: [BUGFIX] Fix AES-NI CTR optimization compiling failure with gas
 2.16.1
Date: Fri, 12 Mar 2010 10:44:58 +0200
Message-ID: <4B99FF0A.1030700@redhat.com>
References: <1268377307.1640.491.camel@yhuang-dev.sh.intel.com>	<4B99FD4D.4090206@redhat.com> <20100312.004202.27822414.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ying.huang@intel.com, akpm@linux-foundation.org,
	herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756644Ab0CLIqP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Mar 2010 03:46:15 -0500
In-Reply-To: <20100312.004202.27822414.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/12/2010 10:42 AM, David Miller wrote:
> From: Avi Kivity<avi@redhat.com>
> Date: Fri, 12 Mar 2010 10:37:33 +0200
>
>    
>> Eventually you'll port the entire assembler into macros, as
>> instructions are introduced more frequently that people upgrade their
>> assemblers.  Maybe we should disable the new features and warn people
>> (and distros) to upgrade their tools instead.
>>      
> I totally and completely disagree.
>
> It would have taken more than a year to get Niagara cpu support out to
> people if I had done what you are suggesting.
>    

Strange, that people can install a new kernel, but not a new assembler.

> And here we're talking about one instruction in one specialized case
> in a very piece of crypto module assembler.
>    

If it were one place, I'd agree, but there are more.  kvm for example 
also uses .byte instead of the actual instructions.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

