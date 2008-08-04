From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c	algorithm by new crypto API.
Date: Mon, 04 Aug 2008 23:42:56 +0800
Message-ID: <E1KQ2D2-0003Fn-00@gondolin.me.apana.org.au>
References: <1217857537.29139.70.camel@think.oraclecorp.com>
Cc: dwmw2@infradead.org, austin_zhang@linux.intel.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: chris.mason@oracle.com (Chris Mason)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39229 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753053AbYHDPnQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 11:43:16 -0400
In-Reply-To: <1217857537.29139.70.camel@think.oraclecorp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Chris Mason <chris.mason@oracle.com> wrote:
>
>>From a performance point of view I'm probably reading the crypto API
> code wrong, but it looks like my choices are to either have a long
> standing context and use locking around the digest/hash calls to protect
> internal crypto state, or create a new context every time and take a
> perf hit while crypto looks up the right module.

You're looking at the old hash interface.  New users should use the
ahash interface which was only recently added to the kernel.  It
lets you store the state in the request object which you pass to
the algorithm on every call.  This means that you only need one
tfm in the entire system for crc32c.

BTW, don't let the a in ahash intimidate you.  It's meant to support
synchronous implementations such as the Intel instruction just as
well as asynchronous ones.

And if you're still not convinced here is the benchmark on the
digest_null algorithm:

testing speed of stub_digest_null
test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    190 cycles/operation,   11 cycles/byte
test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    367 cycles/operation,    5 cycles/byte
test  2 (   64 byte blocks,   64 bytes per update,   1 updates):    192 cycles/operation,    3 cycles/byte
test  3 (  256 byte blocks,   16 bytes per update,  16 updates):   1006 cycles/operation,    3 cycles/byte
test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    378 cycles/operation,    1 cycles/byte
test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    191 cycles/operation,    0 cycles/byte
test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   3557 cycles/operation,    3 cycles/byte
test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):    365 cycles/operation,    0 cycles/byte
test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):    191 cycles/operation,    0 cycles/byte
test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   6903 cycles/operation,    3 cycles/byte
test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):    574 cycles/operation,    0 cycles/byte
test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):    259 cycles/operation,    0 cycles/byte
test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):    192 cycles/operation,    0 cycles/byte
test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):  13626 cycles/operation,    3 cycles/byte
test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   1008 cycles/operation,    0 cycles/byte
test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):    370 cycles/operation,    0 cycles/byte
test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):    193 cycles/operation,    0 cycles/byte
test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  27042 cycles/operation,    3 cycles/byte
test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   1854 cycles/operation,    0 cycles/byte
test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):    576 cycles/operation,    0 cycles/byte
test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):    253 cycles/operation,    0 cycles/byte
test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):    241 cycles/operation,    0 cycles/byte

This is a dry run with a digest_null where all the functions
are stubbed out (i.e., just a return 0).  So this measures the
overhead of the benchmark itself.

Now with a run over a digest_null that simply touches all the
data:

testing speed of digest_null
test  0 (   16 byte blocks,   16 bytes per update,   1 updates):    193 cycles/operation,   12 cycles/byte
test  1 (   64 byte blocks,   16 bytes per update,   4 updates):    369 cycles/operation,    5 cycles/byte
test  2 (   64 byte blocks,   64 bytes per update,   1 updates):    193 cycles/operation,    3 cycles/byte
test  3 (  256 byte blocks,   16 bytes per update,  16 updates):   1010 cycles/operation,    3 cycles/byte
test  4 (  256 byte blocks,   64 bytes per update,   4 updates):    364 cycles/operation,    1 cycles/byte
test  5 (  256 byte blocks,  256 bytes per update,   1 updates):    191 cycles/operation,    0 cycles/byte
test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):   3538 cycles/operation,    3 cycles/byte
test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):    370 cycles/operation,    0 cycles/byte
test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):    192 cycles/operation,    0 cycles/byte
test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):   6927 cycles/operation,    3 cycles/byte
test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):    576 cycles/operation,    0 cycles/byte
test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):    259 cycles/operation,    0 cycles/byte
test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):    192 cycles/operation,    0 cycles/byte
test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates):  13624 cycles/operation,    3 cycles/byte
test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):   1001 cycles/operation,    0 cycles/byte
test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):    365 cycles/operation,    0 cycles/byte
test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):    192 cycles/operation,    0 cycles/byte
test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates):  27095 cycles/operation,    3 cycles/byte
test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates):   1854 cycles/operation,    0 cycles/byte
test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates):    578 cycles/operation,    0 cycles/byte
test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates):    255 cycles/operation,    0 cycles/byte
test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):    241 cycles/operation,    0 cycles/byte

As you can see, the crypto API overhead is pretty much lost in
the noise.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
