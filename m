From: Christophe LEROY <christophe.leroy@c-s.fr>
Subject: Re: md5sum (from libkcapi) fails on kernel 4.9 but not on 4.13
Date: Tue, 17 Oct 2017 09:58:31 +0200
Message-ID: <64a7edb0-b9c0-32cd-cc6e-096f2911d5bc@c-s.fr>
References: <5c552c4b-c05e-7098-6e60-fdc6f7ed5d4b@c-s.fr>
 <2174001.55GM1Rvaqa@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:9675 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932726AbdJQH7D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Oct 2017 03:59:03 -0400
In-Reply-To: <2174001.55GM1Rvaqa@tauon.chronox.de>
Content-Language: fr
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

Le 16/10/2017 à 23:10, Stephan Mueller a écrit :
> Am Montag, 16. Oktober 2017, 08:53:00 CEST schrieb Christophe LEROY:
> 
> Hi Christophe,
> 
>> Hi Stephan,
>>
>> I get an issue with md5sum of a big file with kernel 4.9. It don't get
>> that issue with kernel 4.13.
> 
> The key to the difference in libkcapi is the following code:
> 
> static void _kcapi_handle_flags(struct kcapi_handle *handle)
> ...
>          /* older interfaces only processed 16 pages in a row */
>          handle->flags.alg_max_pages = _kcapi_kernver_ge(handle, 4, 11, 0) ?
>                                        UINT_MAX : ALG_MAX_PAGES;
> ...
> 
> This check is mainly for skcipher but it affects all cipher types. Thus, on
> older kernels, only 16 pages are injected into the kernel with splice and then
> it is reverted to sendmsg. Again, this logic is not so much of an issue for
> algif_hash, but rather for algif_skcipher and algif_aead.
>>
>> When I do an strace, I see a difference in the calls: at the end of the
>> file, with 4.9 md5sum uses sendmsg() for the last block while with 4.13
>> it uses splice() as for all the previous blocks.
>>
>> The problem is that the last block has a size over 32kbytes, which is
>> the maximum size the talitos driver accepts to hash at once.
>> It looks like sendmsg() sends the entire block to the crypto driver
>> while splice() calls the crypto driver with blocks of page size.
> 
> I understand that your driver has this 32kb limit. But I am not sure what the
> difference between the handling of the sendmsg and the splice invocation is.
> According to the strace, the splice accepted 256kb of data. Looking into the
> hash_sendpage function implementing the backend of this splice system call, it
> simply performs an update invocation with this buffer size. I.e. it invokes
> your driver with 256kb of data. The sendmsg first performs a copy_from_user
> with the maximum limit of 16 * PAGE_SIZE (see the limit variable in
> hash_sendmsg) and then invokes the update function.

As far as I can see, hash_sendpage() is called with one single page, of 
size 16kb in my setup. If I understand correct, the loop over every page 
is implemented in __splice_from_pipe().

> 
> So, I am not sure why the sendmsg call chokes where the sendpage call
> succeeds.

As far as I can see, the sendmsg() calls the update function with the 
full buffer, which in my case is over the 32kb limit of the driver.

> 
> If you tamper with the code shown above from libkcapi and set alg_max_pages to
> a low value, the library reverts to sendmsg after the given number of pages.

Couldn't we get the libkcapi to splice until the last full page, then 
only use sendmsg() for the last chunk once it is smaller than an entire 
page ?

Thanks
Christophe
