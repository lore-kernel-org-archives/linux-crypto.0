From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: Tree for July 2 (crypto/hifn_795x)
Date: Mon, 09 Jul 2012 14:40:22 -0700
Message-ID: <4FFB4FC6.7020509@xenotime.net>
References: <20120702172334.2618cae84cc57b4ec5a63ed7@canb.auug.org.au> <4FF1CBF2.8060303@xenotime.net> <20120709205441.11422bntesq3cdno@www.81.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20120709205441.11422bntesq3cdno@www.81.fi>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 07/09/2012 10:54 AM, Jussi Kivilinna wrote:

> Quoting Randy Dunlap <rdunlap@xenotime.net>:
> 
>> On 07/02/2012 12:23 AM, Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20120629:
>>>
>>
>>
>> on i386:
>>
>>
>> ERROR: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
>>
> 
> This is caused by commit feb7b7ab928afa97a79a9c424e4e0691f49d63be. hifn_795x has "DIV_ROUND_UP(NSEC_PER_SEC, dev->pk_clk_freq)", which should be changed to DIV_ROUND_UP_ULL now that NSEC_PER_SEC is 64bit on 32bit archs. Patch to fix hifn_795x is attached (only compile tested).



Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.


-- 
~Randy
