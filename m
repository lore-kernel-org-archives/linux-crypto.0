From: Christophe LEROY <christophe.leroy@c-s.fr>
Subject: Re: md5sum (from libkcapi) fails as splice() returns -ENOKEY
Date: Tue, 12 Sep 2017 11:06:06 +0200
Message-ID: <fd69e3da-1361-e2e1-4135-7f2a9c4a8a7c@c-s.fr>
References: <dadd0e10-f2e8-015a-a432-e7174331ab46@c-s.fr>
 <3811873.su3Mf2IGi3@positron.chronox.de>
 <85331bd3-b799-f4a1-d1da-085be723f5cb@c-s.fr>
 <5590856.XjYaqbyTry@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:52396 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751363AbdILJGI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Sep 2017 05:06:08 -0400
In-Reply-To: <5590856.XjYaqbyTry@tauon.chronox.de>
Content-Language: fr
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

Le 12/09/2017 à 09:20, Stephan Mueller a écrit :
> Am Dienstag, 12. September 2017, 09:01:08 CEST schrieb Christophe LEROY:
> 
> Hi Christophe,
> 
>> Hi Stephan
>>
>> Le 11/09/2017 à 21:17, Stephan Müller a écrit :
>>> Am Montag, 11. September 2017, 19:07:31 CEST schrieb christophe leroy:
>>>
>>> Hi christophe,
>>>
>>>> Hello Stephan,
>>>>
>>>> I'm trying to use md5sum from the latest libkcapi 0.14 and I getting a
>>>> failure with return code -5.
>>>>
>>>> What am I missing ? See strace below, splice() return -ENOKEY.
>>>
>>> The ENOKEY error is due to an accept() at the wrong location. But I do not
>>> see
>>> that error:
>> I did the test once more without the Talitos Crypto driver compiled in
>> the kernel, and this time it works.
>> I believe it must then be an issue with that driver.
>> What could be the issue, what should I look for in the driver ?
>>
> 
> I think I see the error in talitos.c -- yet I do not have that hardware so I
> cannot create a patch and test.
> 
> In talitos_alg_alloc the function pointer setkey is set unconditional for
> CRYPTO_ALG_TYPE_AHASH. This is correct for HMAC/CMAC, but not correct for
> staight hashes. As both, md5 and hmac(md5) (and also for the SHA equivalents)
> are marked as CRYPTO_ALG_TYPE_AHASH in driver_algs, they all will get a setkey
> function.
> 
> This will trigger the following code in algif_hash:
> 
> static int hash_accept_parent(void *private, struct sock *sk)
> {
>          struct algif_hash_tfm *tfm = private;
> 
>          if (!tfm->has_key && crypto_ahash_has_setkey(tfm->hash))
>                  return -ENOKEY;
> 
> If the setkey would not be present for the straight hashes, ENOKEY would not
> be returned.

Thanks.
I modified it and it now works (allthough it doesn't provide the correct 
MD5sum ... have to findout why)
I submitted a patch for it.

Christophe
> 
> ...
> 
>>
>> # autoreconf --version
>> autoreconf (GNU Autoconf) 2.63
> 
> Thanks for the bug report. But I think the autoconf tools are not up to date.
> It should be 2.69.
> 
> Could you please check whether you can update?
> 
> I am thinking now to add AC_PREREQ([2.60]) to configure.ac.
> 
> 
> 
> Ciao
> Stephan
> 
