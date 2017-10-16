From: Stephan Mueller <smueller@chronox.de>
Subject: Re: md5sum (from libkcapi) fails on kernel 4.9 but not on 4.13
Date: Mon, 16 Oct 2017 23:10:00 +0200
Message-ID: <2174001.55GM1Rvaqa@tauon.chronox.de>
References: <5c552c4b-c05e-7098-6e60-fdc6f7ed5d4b@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Christophe LEROY <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34910 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932131AbdJPVKK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Oct 2017 17:10:10 -0400
In-Reply-To: <5c552c4b-c05e-7098-6e60-fdc6f7ed5d4b@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 16. Oktober 2017, 08:53:00 CEST schrieb Christophe LEROY:

Hi Christophe,

> Hi Stephan,
> 
> I get an issue with md5sum of a big file with kernel 4.9. It don't get
> that issue with kernel 4.13.

The key to the difference in libkcapi is the following code:

static void _kcapi_handle_flags(struct kcapi_handle *handle)
...
        /* older interfaces only processed 16 pages in a row */
        handle->flags.alg_max_pages = _kcapi_kernver_ge(handle, 4, 11, 0) ?
                                      UINT_MAX : ALG_MAX_PAGES;
...

This check is mainly for skcipher but it affects all cipher types. Thus, on 
older kernels, only 16 pages are injected into the kernel with splice and then 
it is reverted to sendmsg. Again, this logic is not so much of an issue for 
algif_hash, but rather for algif_skcipher and algif_aead.
> 
> When I do an strace, I see a difference in the calls: at the end of the
> file, with 4.9 md5sum uses sendmsg() for the last block while with 4.13
> it uses splice() as for all the previous blocks.
> 
> The problem is that the last block has a size over 32kbytes, which is
> the maximum size the talitos driver accepts to hash at once.
> It looks like sendmsg() sends the entire block to the crypto driver
> while splice() calls the crypto driver with blocks of page size.

I understand that your driver has this 32kb limit. But I am not sure what the 
difference between the handling of the sendmsg and the splice invocation is. 
According to the strace, the splice accepted 256kb of data. Looking into the 
hash_sendpage function implementing the backend of this splice system call, it 
simply performs an update invocation with this buffer size. I.e. it invokes 
your driver with 256kb of data. The sendmsg first performs a copy_from_user 
with the maximum limit of 16 * PAGE_SIZE (see the limit variable in 
hash_sendmsg) and then invokes the update function.

So, I am not sure why the sendmsg call chokes where the sendpage call 
succeeds. 

If you tamper with the code shown above from libkcapi and set alg_max_pages to 
a low value, the library reverts to sendmsg after the given number of pages.


Ciao
Stephan
