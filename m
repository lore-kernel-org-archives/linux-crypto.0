From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 2/4] DRBG: cleanup of preprocessor macros
Date: Sun, 29 Jun 2014 00:41:22 -0700
Message-ID: <53AFC322.2060109@infradead.org>
References: <4927386.WYHrRe3NJm@myon.chronox.de> <1949550.LXKdkPOvgm@myon.chronox.de> <20140629122015.43f5178a@canb.auug.org.au> <3104100.drOBnqUFp8@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
	Dan Carpenter <dan.carpenter@oracle.com>,
	linux-crypto@vger.kernel.org, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3104100.drOBnqUFp8@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 06/28/14 22:07, Stephan Mueller wrote:
> Am Sonntag, 29. Juni 2014, 12:20:15 schrieb Stephen Rothwell:
> 
> Hi Stephen,
> 
>> Hi Stephan,
>>
>> On Sat, 28 Jun 2014 22:00:07 +0200 Stephan Mueller <smueller@chronox.de> 
> wrote:
>>> diff --git a/crypto/drbg.c b/crypto/drbg.c
>>> index 6679a26..03a230e 100644
>>> --- a/crypto/drbg.c
>>> +++ b/crypto/drbg.c
>>> @@ -102,8 +102,13 @@
>>>
>>>  #if !defined(CONFIG_CRYPTO_DRBG_HASH) && \
>>>  
>>>  	!defined(CONFIG_CRYPTO_DRBG_HMAC) && \
>>>  	!defined(CONFIG_CRYPTO_DRBG_CTR)
>>>
>>> -#warning "The DRBG code is useless without compiling at least one DRBG
>>> type" -#endif
>>> +#define CRYPTO_DRBG_NONE_STRING "none "
>>> +static int __init drbg_init(void)
>>> +{
>>> +	pr_warn("DRBG: no DRBG core was compiled!\n");
>>> +	return -EFAULT;
>>> +}
>>> +#else
>>
>> Wouldn't this be better handled by Kconfig so that we don't even try to
>> build this unless one of the required core modules is chosen?
> 
> I tried that, but it seems that my Kconfig Foo is not too well: adding the 
> DRBG cores to the depends line of CRYPTO_DRBG as indicated in the following, I 
> have a circular dependency. With that circular dependency, the DRBG entries do 
> not show up in make menuconfig.
> 
> menuconfig CRYTPO_DRBG
>         tristate "NIST SP800-90A DRBG"
>         depends on CRYPTO && (CRYPTO_DRBG_HMAC || CRYPTO_DRBG_CTR || 
> CRYPTO_DRBG_HASH)
> ...
> 
> if CRYTPO_DRBG
> 
> config CRYPTO_DRBG_HMAC
>         bool "Enable HMAC DRBG"
>         default y
>         depends on CRYTPO_DRBG
> 
> Do you have a working solution in mind? The goal is that once CRYPTO_DRBG is 
> selected, at least one of the DRBG cores must be selected.

That sounds like a 'choice' Kconfig could be used.
Have you looked at that possibility?

See Documentation/kbuild/kconfig-language.txt and search for 'choice'.


-- 
~Randy
