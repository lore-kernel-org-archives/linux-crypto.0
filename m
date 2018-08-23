From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Deadlock when using crypto API for block devices
Date: Thu, 23 Aug 2018 16:39:23 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1808231621220.8560@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi

There's a deadlock reported here: 
https://bugzilla.kernel.org/show_bug.cgi?id=200835

* dm-crypt calls crypt_convert in xts mode
* init_crypt from xts.c calls kmalloc(GFP_KERNEL)
* kmalloc(GFP_KERNEL) recurses into the XFS filesystem, the filesystem 
	tries to submit some bios and wait for them, causing a deadlock

I was thinking how to fix it, there are several possibilities, but all 
have some caveats. So, I'd like to ask you as crypto code maintainers, 
what's the appropriate solution.


1. don't set CRYPTO_TFM_REQ_MAY_SLEEP in dm-crypt
=================================================
If we don't set it, dm-crypt will use GFP_ATOMIC and GFP_ATOMIC may fail. 
The function init_crypt in xts.c handles the failure gracefully - but the 
question is - does the whole crypto code handle allocation failures 
gracefully? If not and if it returns -ENOMEM somewhere, it would result in 
I/O errors and data corruption.

I'd like to ask if you as maintainers of the crypto API could say, whether 
the crypto code handles GFP_ATOMIC allocations failure gracefully or not.

Note that dm-crypt currently uses encryption, hashes and authernticated 
encryption, so if we go down this path, we must make sure that the code 
for these operations will never return -ENOMEM.

2. use memalloc_noio_save/memalloc_noio_restore in dm-crypt
===========================================================
This makes all allocations use GFP_NOIO implicitly, so it would fix the 
deadlock. But - the crypto API can offload encryption to the cryptd 
thread, and if the offload happens, the memalloc_noio_save flag is lost 
and the allocation can still be done with GFP_KERNEL and cause a deadlock.

3. introduce new flag CRYPTO_TFM_REQ_MAY_SLEEP_NOIO
===================================================
Would you like to introduce it?

4. make the whole crypto code use GFP_NOIO instead of GFP_KERNEL?
=================================================================


... any other suggestions?

Mikulas
