From: Avi Kivity <avi@redhat.com>
Subject: Re: [BUGFIX] Fix AES-NI CTR optimization compiling failure with gas
 2.16.1
Date: Fri, 12 Mar 2010 11:33:26 +0200
Message-ID: <4B9A0A66.2000108@redhat.com>
References: <4B99FD4D.4090206@redhat.com>	<20100312.004202.27822414.davem@davemloft.net>	<4B99FF0A.1030700@redhat.com> <20100312.005051.09912332.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ying.huang@intel.com, akpm@linux-foundation.org,
	herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100312.005051.09912332.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 03/12/2010 10:50 AM, David Miller wrote:
> From: Avi Kivity<avi@redhat.com>
> Date: Fri, 12 Mar 2010 10:44:58 +0200
>
>    
>> Strange, that people can install a new kernel, but not a new
>> assembler.
>>      
> Someone shouldn't have to upgrade their tools to build the
> kernel.
>    

The kernel would still build, just without the AES-NI CTR optimization 
(or kvm).

> And we work very hard to make sure this is the case except
> in the most unavoidable situations.
>    

Why so hard?  It has a cost.  The user can certainly 'make 
AS=~/new-binutils/bin/gas' and it wouldn't even affect the rest of their 
system.

tools/as/ anyone?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.
