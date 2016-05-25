From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH] hwrng: stm32 - fix build warning
Date: Wed, 25 May 2016 07:35:17 +0530
Message-ID: <5745085D.6000104@gmail.com>
References: <1464007448-25395-1-git-send-email-sudipm.mukherjee@gmail.com> <6297051.TAxtzW5OIB@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35655 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbcEYGfZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 May 2016 02:35:25 -0400
In-Reply-To: <6297051.TAxtzW5OIB@wuerfel>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday 24 May 2016 02:05 AM, Arnd Bergmann wrote:
> On Monday, May 23, 2016 6:14:08 PM CEST Sudip Mukherjee wrote:
>> We have been getting build warning about:
>> drivers/char/hw_random/stm32-rng.c: In function 'stm32_rng_read':
>> drivers/char/hw_random/stm32-rng.c:82:19: warning: 'sr' may be used
>> 					uninitialized in this function
>>
>> On checking the code it turns out that sr can never be used
>> uninitialized as sr is getting initialized in the while loop and while
>> loop will always execute as the minimum value of max can be 32.
>> So just initialize sr to 0 while declaring it to silence the compiler.
>>
>> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
>> ---
>
> I notice that you are using a really old compiler. While this warning
> seems to be valid in the sense that the compiler should figure out that
> the variable might be used uninitialized, please update your toolchain
> before reporting other such problems, as gcc-4.6 had a lot more false
> positives that newer ones (5.x or 6.x) have.

yes, i need to upgrade gcc in my travis bot. But in my local system I am 
having gcc-4.8.4 and there also I am having this error and i am sure 
4.8.4 is still being used by many people.

Regards
Sudip
