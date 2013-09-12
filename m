From: Waiman Long <waiman.long@hp.com>
Subject: Re: [3.12-rc1] Dependency on module-init-tools >= 3.11 ?
Date: Thu, 12 Sep 2013 10:26:56 -0400
Message-ID: <5231CF30.8050500@hp.com>
References: <201307201456.JIC35412.VFOMFJOQLOtHFS@I-love.SAKURA.ne.jp> <201309112043.HBD04609.FOtLSOFVQHFOJM@I-love.SAKURA.ne.jp> <20130912042622.GA15181@gondor.apana.org.au> <201309121403.FIH09821.JtLOVOSFOFHFQM@I-love.SAKURA.ne.jp> <20130912052806.GA15737@gondor.apana.org.au> <201309121920.AHJ58678.OMVJFFSHOtOFQL@I-love.SAKURA.ne.jp> <20130912102953.GA18916@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	andr345@gmail.com, rusty@rustcorp.com.au,
	linux-kernel@vger.kernel.org, arthur.marsh@internode.on.net,
	tim.c.chen@linux.intel.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130912102953.GA18916@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 09/12/2013 06:29 AM, Herbert Xu wrote:
> On Thu, Sep 12, 2013 at 07:20:23PM +0900, Tetsuo Handa wrote:
>> Herbert Xu wrote:
>>> The trouble is not all distros will include the softdep modules in
>>> the initramfs.  So for now I think we will have to live with a fallback.
>> I see.
>>
>> Herbert Xu wrote:
>>> OK, can you please try this patch on top of the current tree?
>>>
>>> This way at least you'll have a working system until your initramfs
>>> tool is fixed to do the right thing.
>> I tested the patch and confirmed that the boot failure was solved.
>>
>> But arch/x86/crypto/crct10dif-pclmul.ko is not included into initramfs and
>> therefore we cannot benefit from PCLMULQDQ version.
> That is expected and is also the status quo.  So once the initrd
> generation tool is fixed to include softdeps it will work properly.
>
> Thanks!

I would like to report that I also have the same boot problem on a 
RHEL6.4 box with the crypto patch. My workaround is to force kernel 
build to have the crc_t10dif code built-in by changing the config file:

4889c4889
< CONFIG_CRYPTO_CRCT10DIF=m
---
 > CONFIG_CRYPTO_CRCT10DIF=y
5002c5002
< CONFIG_CRC_T10DIF=m
---
 > CONFIG_CRC_T10DIF=y

This solved the boot problem without any additional patch.  Do you think 
you should consider changing the configuration default to "y" instead of 
"m" or doesn't allow the "m" option at all?

Thanks!
