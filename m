From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH] hwrng: stm32 - fix build warning
Date: Fri, 27 May 2016 14:30:48 +0530
Message-ID: <57480CC0.80500@gmail.com>
References: <1464007448-25395-1-git-send-email-sudipm.mukherjee@gmail.com> <6297051.TAxtzW5OIB@wuerfel> <5745085D.6000104@gmail.com> <7211115.EdoBLRGZ1i@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Matt Mackall <mpm@selenic.com>
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33041 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbcE0NbI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 May 2016 09:31:08 -0400
In-Reply-To: <7211115.EdoBLRGZ1i@wuerfel>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 25 May 2016 03:36 PM, Arnd Bergmann wrote:
> On Wednesday, May 25, 2016 7:35:17 AM CEST Sudip Mukherjee wrote:
>> On Tuesday 24 May 2016 02:05 AM, Arnd Bergmann wrote:
>>> On Monday, May 23, 2016 6:14:08 PM CEST Sudip Mukherjee wrote:
>>>> We have been getting build warning about:
>>>> drivers/char/hw_random/stm32-rng.c: In function 'stm32_rng_read':
>>>> drivers/char/hw_random/stm32-rng.c:82:19: warning: 'sr' may be used
>>>>                                       uninitialized in this function
>>>>
>>>> On checking the code it turns out that sr can never be used
>>>> uninitialized as sr is getting initialized in the while loop and while
>>>> loop will always execute as the minimum value of max can be 32.
>>>> So just initialize sr to 0 while declaring it to silence the compiler.
>>>>
>>>> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
>>>> ---
>>>
>snip>
>
> BTW, regarding your build infrastructure, I'd also recommend building
> with 'make -s' to make the output more compact.

travis is having a timeout and if there is no output from the build 
within a time limit then it will cancel the build. I can use the option 
if i can increase the timeout limit. I will have a look at the options. 
Thanks for the idea.

Regards
Sudip
