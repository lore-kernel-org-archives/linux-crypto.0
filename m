From: Mathias Krause <minipli@googlemail.com>
Subject: Re: linux-next: Tree for November 29 (aesni-intel)
Date: Mon, 29 Nov 2010 20:45:39 +0100
Message-ID: <45B80502-8597-4650-990F-F23B4FC751B8@googlemail.com>
References: <4CF3F6CB.8080904@oracle.com> <1291058505-9384-1-git-send-email-minipli@googlemail.com> <4CF3FFAE.40906@oracle.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Huang Ying <ying.huang@intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <4CF3FFAE.40906@oracle.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 29.11.2010, 20:31 Randy Dunlap wrote:
> On 11/29/10 11:21, Mathias Krause wrote:
>> On 29.11.2010, 19:54 Randy Dunlap wrote:
>>> On 11/29/10 10:26, Mathias Krause wrote:
>>>> On 29.11.2010, 17:31 Randy Dunlap wrote:
>>>>> On Mon, 29 Nov 2010 14:03:35 +1100 Stephen Rothwell wrote:
>>>>> 
>>>>>> Hi all,
>>>>>> 
>>>>>> Changes since 20101126:
>>>>> 
>>>>> 
>>>>> on i386 builds, I get tons of these (and more) errors:
>>>>> 
>>>>> arch/x86/crypto/aesni-intel_asm.S:841: Error: bad register name `%r12'
>>>>> arch/x86/crypto/aesni-intel_asm.S:842: Error: bad register name `%r13'
>>>>> arch/x86/crypto/aesni-intel_asm.S:843: Error: bad register name `%r14'
>>>>> arch/x86/crypto/aesni-intel_asm.S:844: Error: bad register name `%rsp'
>>>>> arch/x86/crypto/aesni-intel_asm.S:849: Error: bad register name `%rsp'
>>>>> arch/x86/crypto/aesni-intel_asm.S:850: Error: bad register name `%rsp'
>>>>> arch/x86/crypto/aesni-intel_asm.S:851: Error: bad register name `%r9'
>>>>> 
>>>>> even though the kernel .config file says:
>>>>> 
>>>>> CONFIG_CRYPTO_AES=m
>>>>> CONFIG_CRYPTO_AES_586=m
>>>>> CONFIG_CRYPTO_AES_NI_INTEL=m
>>>>> 
>>>>> Should arch/x86/crypto/aesni-intel_asm.S be testing
>>>>> #ifdef CONFIG_X86_64
>>>>> instead of
>>>>> #ifdef __x86_64__
>>>>> or does that not matter?
>>>>> 
>>>>> or is this a toolchain issue?
>>>> 
>>>> Well, __x86_64__ should be a build-in define of the compiler while
>>>> CONFIG_X86_64 is defined for 64 bit builds in include/generated/autoconf.h.
>>>> So by using the latter we should be on the safe side but if your compiler
>>>> defines __x86_64__ for 32-bit builds it's simply broken. Also git grep
>>>> showed quite a few more places using __x86_64__ so those would miscompile on
>>>> your toolchain, too.
>>>> 
>>>> But it looks like linux-next is just missing
>>>> 559ad0ff1368baea14dbc3207d55b02bd69bda4b from Herbert's git repo at
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git.
>>>> That should fix the build issue.
>>> 
>>> The build problem still happens when that patch is applied.
>> 
>> That's weird. So it must be something with your toolchain.
>> Can you please post the output of the following commands?:
>> 
>> $ touch /tmp/null.c; cc -m32 -dD -E /tmp/null.c | grep -E 'x86|i.86'
> 
> #define __i386 1
> #define __i386__ 1
> #define i386 1
> #define __i586 1
> #define __i586__ 1
> 
>> $ touch /tmp/null.c; cc -m64 -dD -E /tmp/null.c | grep -E 'x86|i.86'
> 
> #define __x86_64 1
> #define __x86_64__ 1
> 
> So that's not the problem... and the patch below didn't help.

That's odd. The output of the commands looks good so the x86-64 specific code
should be left out for 32-bit builds. :/

> Sorry that I even asked about that.  What next?

Can you please post the full error message. Meanwhile I'm checking out a
linux-next tree, trying to reproduce your problem.
