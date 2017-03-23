From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: Question - seeding the hw pseudo random number generator
Date: Thu, 23 Mar 2017 14:06:22 +0100
Message-ID: <25271998.F6jFv7Sebt@positron.chronox.de>
References: <20170318092554.lggkhfg5eko23o3k@kozik-lap> <20170323082307.GB16625@Red> <20170323094406.GA6848@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart4899256.oF0l2qdIU2"
Content-Transfer-Encoding: 7Bit
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Matt Mackall <mpm@selenic.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58258 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750915AbdCWNIe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Mar 2017 09:08:34 -0400
In-Reply-To: <20170323094406.GA6848@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart4899256.oF0l2qdIU2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Am Donnerstag, 23. M=E4rz 2017, 10:44:06 CET schrieb Herbert Xu:

Hi Herbert,

> On Thu, Mar 23, 2017 at 09:23:07AM +0100, Corentin Labbe wrote:
> > Problem with this conversion, a huge regression for user space.
> > Using hwrng is simple as cat /dev/hwrng.
> > Using algif_rng via AF_ALG is ... unusable for the moment.
> > Perhaps creating an user space tool (prng-tool which provide a cat
> > /dev/hwrng replacement) is mandatory before any convertion.
> Stephan may have a tool to do this.  Stephan?

Here is a suggestion for such a tool that I could add to libkcapi. Naturall=
y,=20
this code is only a demonstrator which lacks some features.

Ciao
Stephan
--nextPart4899256.oF0l2qdIU2
Content-Disposition: attachment; filename="kcapi-rng.c"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-csrc; charset="UTF-8"; name="kcapi-rng.c"

/*
 * Copyright (C) 2017, Stephan Mueller <smueller@chronox.de>
 *
 * License: see COPYING file in root directory
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

#include <unistd.h>
#include <errno.h>
#include <limits.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <linux/random.h>
#ifdef HAVE_GETRANDOM
#include <sys/random.h>
#endif

#include <kcapi.h>

struct kcapi_handle *rng = NULL;

static int read_complete(int fd, uint8_t *buf, uint32_t buflen)
{
	ssize_t ret;

	do {
		ret = read(fd, buf, buflen);
		if (0 < ret) {
			buflen -= ret;
			buf += ret;
		}
	} while ((0 < ret || EINTR == errno || ERESTART == errno)
		 && buflen > 0);

	if (buflen == 0)
		return 0;
	return 1;
}

static int read_random(uint8_t *buf, uint32_t buflen)
{
	int fd;
	int ret = 0;

	fd = open("/dev/urandom", O_RDONLY|O_CLOEXEC);
	if (0 > fd)
		return fd;

	ret = read_complete(fd, buf, buflen);
	close(fd);
	return ret;
}

static int get_random(uint8_t *buf, uint32_t buflen)
{
	if (buflen > INT_MAX)
		return 1;

#ifdef HAVE_GETRANDOM
	return getrandom(buf, buflen, 0);
#else
# ifdef __NR_getrandom
	do {
		int ret = syscall(__NR_getrandom, buf, buflen, 0);

		if (0 < ret) {
			buflen -= ret;
			buf += ret;
		}
	} while ((0 < ret || EINTR == errno || ERESTART == errno)
		 && buflen > 0);

	if (buflen == 0)
		return 0;

	return 1;
# else
	return read_random(buf, buflen);
# endif
#endif
}

static void usage(void)
{
	char version[30];
	uint32_t ver = kcapi_version();

	memset(version, 0, sizeof(version));
	kcapi_versionstring(version, sizeof(version));

	fprintf(stderr, "\nKernel Crypto API Random Number Gatherer\n");
	fprintf(stderr, "\nKernel Crypto API interface library version: %s\n", version);
	fprintf(stderr, "Reported numeric version number %u\n\n", ver);
	fprintf(stderr, "Usage:\n");
	fprintf(stderr, "\t<NUM>\tNumber of bytes to generate\n");
}

int main(int argc, char *argv[])
{
	int ret;
	uint8_t buf[64];
	unsigned long outlen;

	if (argc != 2) {
		usage();
		return -EINVAL;
	}

	outlen = strtoul(argv[1], NULL, 10);
	if (outlen == ULONG_MAX) {
		usage();
		return -EINVAL;
	}

	ret = kcapi_rng_init(&rng, "drbg_nopr_hmac_sha256", 0);
	if (ret)
		return ret;

	ret = get_random(buf, sizeof(buf));
	if (ret)
		goto out;

	ret = kcapi_rng_seed(rng, buf, sizeof(buf));
	kcapi_memset_secure(buf, 0, sizeof(buf));
	if (ret)
		goto out;

	while (outlen) {
		uint32_t todo = (outlen < sizeof(buf)) ? outlen : sizeof(buf);

		ret = kcapi_rng_generate(rng, buf, todo);
		if (ret < 0)
			goto out;

		if ((uint32_t)ret != todo) {
			ret = -EFAULT;
			goto out;
		}

		fwrite(&buf, todo, 1, stdout);

		outlen -= todo;
	}

out:
	if (rng)
		kcapi_rng_destroy(rng);
	kcapi_memset_secure(buf, 0, sizeof(buf));

	return ret;
}

--nextPart4899256.oF0l2qdIU2--
