From: Stephan Mueller <smueller@chronox.de>
Subject: algif_hash: splice of data > 2**16
Date: Thu, 18 Dec 2014 13:15:28 +0100
Message-ID: <8707521.TbV00HIEUx@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	'LKML' <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

While testing the vmsplice/splice interface of algif_hash I was made 
aware of the problem that data blobs larger than 16 pages do not seem to 
be hashed properly.

For testing, a file is mmap()ed and handed to vmsplice / splice. If the 
file is smaller than 2**16, the interface returns the proper hash. 
However, when the file is larger, only the first 2**16 bytes seem to be 
used.

When adding printk's to hash_sendpage, I see that this function is 
invoked exactly 16 times where the first 15 invocations have the 
MSG_MORE flag set and the last invocation does not have MSG_MORE.

To invoke the vmsplice/splice interface, I use my current implementation 
of libkcapi available at [1]. That library uses the following calls:

vmsplice(handle->pipes[1], iov, iovlen, SPLICE_F_GIFT);
splice(handle->pipes[0], NULL, handle->opfd, NULL, inlen, 0);
read(handle->opfd, out, outlen);

The return code of splice() is always 65536 irrespectively of the 
following variations:

- have one iovec pointing to the entire buffer of the mmap()ed file

- have multiple iovecs with all pointing to at most 2**16 bytes

- invoke splice/read multiple times with at most 2**16 bytes

My guess of the problem is that the maximum buffer size for the pipe is 
16 pages. These 16 pages are filled with the repeated invocation of 
hash_sendpage.

Is there a specific way of how the splice interface is to be called so 
that the pages are released? Or is there a need to change hash_sendpage 
such that after the af_alg_wait_for_completion call, some form of 
"releasing/putting" of the used page needs to be added?

Note, hashing the large mmap()ed file with one iovec using the sendmsg() 
interface works flawlessly.

[1] http://www.chronox.de/libkcapi.html

Thanks
Stephan
