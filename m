From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: Tree for Oct 25 (crypto)
Date: Wed, 26 Oct 2011 09:27:57 -0700
Message-ID: <4EA8350D.1080003@xenotime.net>
References: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au> <4EA75759.3050900@xenotime.net> <20111026062717.GA10230@gondor.apana.org.au> <20111026143347.462fea95@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Linus <torvalds@linux-foundation.org>,
	linux-crypto@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:57353 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933361Ab1JZQ2H (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Oct 2011 12:28:07 -0400
In-Reply-To: <20111026143347.462fea95@stein>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/26/11 05:33, Stefan Richter wrote:
> On Oct 26 Herbert Xu wrote:
>> On Tue, Oct 25, 2011 at 05:42:01PM -0700, Randy Dunlap wrote:
>>> On 10/25/11 02:36, Stephen Rothwell wrote:
>>>> Hi all,
>>>
>>>
>>> When CONFIG_NET is not enabled:
>>
>> Thanks, I'll add this patch.
>>
>> diff --git a/crypto/Kconfig b/crypto/Kconfig
>> index a8442dc..259dea9 100644
>> --- a/crypto/Kconfig
>> +++ b/crypto/Kconfig
>> @@ -103,6 +103,7 @@ config CRYPTO_MANAGER2
>>  config CRYPTO_USER
>>  	tristate "Userspace cryptographic algorithm configuration"
>>  	select CRYPTO_MANAGER
>> +	select NET
>>  	help
>>  	  Userapace configuration for cryptographic instantiations such as
>>  	  cbc(aes).
>>
>> Cheers,
> 
> If you do it this way, you also need to select everything on which NET
> depends on.  In v3.1, that would be (only) NLATTR which in turn does not
> depend on anything else.
> 
> Furthermore, I am noticing in v3.1 that CRYPTO_MANAGER selects
> CRYPTO_MANAGER2 which in turn has the following dependencies:
> 
> config CRYPTO_MANAGER2
> 	def_tristate CRYPTO_MANAGER || (CRYPTO_MANAGER!=n && CRYPTO_ALGAPI=y)
> 	select CRYPTO_AEAD2
> 	select CRYPTO_HASH2
> 	select CRYPTO_BLKCIPHER2
> 	select CRYPTO_PCOMP2
> 
> I think you need to copy those dependencies into config CRYPTO_MANAGER.

That's correct, but it's better not to "select" an entire subsystem
like NET at all.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
