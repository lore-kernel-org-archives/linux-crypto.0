From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v5 1/2] crypto: skcipher AF_ALG - overhaul memory management
Date: Thu, 30 Mar 2017 15:59:10 +0200
Message-ID: <6160628.Rma7UCP5As@positron.chronox.de>
References: <2523592.mde6d2a8Lg@positron.chronox.de> <1797510.JnIj36BbdJ@tauon.atsec.com> <20170316095248.GA11996@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart3099294.rQj4EmcCNo"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58704 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933527AbdC3N7S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Mar 2017 09:59:18 -0400
In-Reply-To: <20170316095248.GA11996@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart3099294.rQj4EmcCNo
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Am Donnerstag, 16. M=E4rz 2017, 10:52:48 CEST schrieb Herbert Xu:

Hi Herbert,

> More importantly, with the current code, a very large recvmsg
> would still work by doing it piecemeal.  With your patch, won't
> it fail because sock_kmalloc could fail to allocate memory for
> the whole thing?

=46or testing purpose, I wrote the app that is attached. It simply encrypts=
 a=20
given file with ctr(aes).

On the current implementation of algif_skcipher where I directly pipe in th=
e=20
provided memory block (i.e. using the stream operation of libkcapi):

dd if=3D/dev/zero of=3Dtestfile bs=3D1024 count=3D1000000
=2E/kcapi-long testfile testfile.out
encryption failed with error -14

=3D=3D> The -EFAULT happens at sendmsg() -- i.e. you cannot provide as much=
 data=20
as you want.

=3D=3D> On the proposed update, I see the same error.

When I use vmsplice, the current implementation somehow simply waits (I do =
not=20
yet know what happens). My new implementation simply returns the amount of=
=20
data that could have been spliced (64k -- which would allow user space to=20
implement a loop to send chunks).


When I ask libkcapi to send the data in chunks, libkcapi implements the loo=
p=20
that sends/receives the data. In this case, both implementations of=20
algif_skcipher.c work to encrypt the whole file regardless of its size.

Thus, I would conclude that the current outer loop in recvmsg of the curren=
t=20
algif_skcipher is not really helpful as the bottleneck is on the sendmsg si=
de.


With this, I would conclude that the new implementation of algif_skcipher.c=
=20
proposed in this patch set has the same behavior as the old one.

Ciao
Stephan
--nextPart3099294.rQj4EmcCNo
Content-Disposition: attachment; filename="kcapi-long.c"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-csrc; charset="UTF-8"; name="kcapi-long.c"

/*
 * Copyright (C) 2017, Stephan Mueller <smueller@chronox.de>
 *
 * License: see LICENSE file in root directory
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
 * WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */

#include <stdio.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdint.h>
#include <errno.h>
#include <string.h>
#include <fcntl.h>

#include <kcapi.h>

static int check_filetype(int fd, struct stat *sb, const char *filename)
{
	fstat(fd, sb);

	/* Do not return an error in case we cannot validate the data. */
	if ((sb->st_mode & S_IFMT) != S_IFREG &&
	    (sb->st_mode & S_IFMT) != S_IFLNK) {
		fprintf(stderr, "%s is no regular file or symlink\n", filename);
		return -EINVAL;
	}

	return 0;
}

static int crypt(struct kcapi_handle *handle, const uint8_t *iv,
		 const char *infile, const char *outfile)
{
	int infd = -1, outfd = -1;
	int ret = 0;
	struct stat insb, outsb;
	uint8_t *inmem = NULL, *outmem = NULL;
	size_t outsize;

	infd = open(infile, O_RDONLY | O_CLOEXEC);
	if (infd < 0) {
		fprintf(stderr, "Cannot open file %s: %s\n", infile,
			strerror(errno));
		return -EIO;
	}

	outfd = open(outfile, O_RDWR | O_CLOEXEC | O_CREAT, S_IRWXU | S_IRWXG | S_IRWXO);
	if (outfd < 0) {
		fprintf(stderr, "Cannot open file %s: %s\n", infile,
			strerror(errno));
		ret = -EIO;
		goto out;
	}

	ret = check_filetype(infd, &insb, infile);
	if (ret)
		goto out;

	ret = check_filetype(outfd, &outsb, outfile);
	if (ret)
		goto out;

	if (insb.st_size) {
		inmem = mmap(NULL, insb.st_size, PROT_READ, MAP_SHARED,
			     infd, 0);
		if (inmem == MAP_FAILED)
		{
			fprintf(stderr, "Use of mmap failed\n");
			ret = -ENOMEM;
			goto out;
		}
	}
	outsize = ((insb.st_size + kcapi_cipher_blocksize(handle) - 1) /
		   kcapi_cipher_blocksize(handle)) *
		    kcapi_cipher_blocksize(handle);

	ret = ftruncate(outfd, outsize);
	if (ret)
		goto out;

	if (outsize) {
		outmem = mmap(NULL, outsize, PROT_WRITE, MAP_SHARED,
			     outfd, 0);
		if (outmem == MAP_FAILED)
		{
			fprintf(stderr, "Use of mmap failed\n");
			ret = -ENOMEM;
			goto out;
		}
	}

#if 1
	/* Send all data in one go, libkcapi will not loop */
	struct iovec iniov, outiov;

	iniov.iov_base = inmem;
	iniov.iov_len = insb.st_size;
	outiov.iov_base = outmem;
	outiov.iov_len = outsize;

	ret = kcapi_cipher_stream_init_enc(handle, iv, NULL, 0);
	if (ret)
		goto out;

	ret = kcapi_cipher_stream_update(handle, &iniov, 1);
	if (ret)
		goto out;

	ret = kcapi_cipher_stream_op(handle, &outiov, 1);
#else
	/* libkcapi will loop over the data and send it in chunks */
	ret = kcapi_cipher_encrypt(handle, inmem, insb.st_size, iv,
				   outmem, outsize, KCAPI_ACCESS_SENDMSG);
#endif

out:
	if (inmem && inmem != MAP_FAILED)
		munmap(inmem, insb.st_size);
	if (outmem && outmem != MAP_FAILED)
		munmap(outmem, outsize);
	if (infd >= 0)
		close(infd);
	if (outfd >= 0)
		close(outfd);

	return ret;
}


int main(int argc, char *argv[])
{
	struct kcapi_handle *handle = NULL;
	int ret;

	if (argc != 3) {
		fprintf(stderr, "infile, outfile required\n");
		return -EINVAL;
	}

	/* with CTR mode, we can skip any padding */
	ret = kcapi_cipher_init(&handle, "ctr(aes)", 0);
	if (ret)
		return ret;

	ret = kcapi_cipher_setkey(handle, (uint8_t *)"0123456789012345", 16);
	if (ret)
		goto out;

	ret = crypt(handle, (uint8_t *)"0123456789012345", argv[1], argv[2]);

	if (ret > 0) {
		fprintf(stderr, "%d bytes of ciphertext created\n", ret);
		ret = 0;
	} else {
		fprintf(stderr, "encryption failed with error %d\n", ret);
	}

out:
	kcapi_cipher_destroy(handle);

	return ret;
}

--nextPart3099294.rQj4EmcCNo--
