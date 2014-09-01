From: Ondrej Kozina <okozina@redhat.com>
Subject: Re: [PATCH] avoid excessive use of socket buffer in skcipher
Date: Mon, 01 Sep 2014 17:42:08 +0200
Message-ID: <540493D0.9010306@redhat.com>
References: <1408960194-11726-1-git-send-email-okozina@redhat.com> <1408960194-11726-2-git-send-email-okozina@redhat.com> <54048F43.4090301@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060709000607090503060803"
Cc: herbert@gondor.apana.org.au, gmazyland@gmail.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbaIAPmR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Sep 2014 11:42:17 -0400
In-Reply-To: <54048F43.4090301@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060709000607090503060803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 09/01/2014 05:22 PM, Ondrej Kozina wrote:
> Attaching simple reproducer.

Sigh. Mondays... Sending fixed reproducer. Excuse my mistake.

Kind regards
Ondrej

--------------060709000607090503060803
Content-Type: text/x-csrc;
 name="reproducer_ppc64.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="reproducer_ppc64.c"

#include <errno.h>
#include <malloc.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <linux/if_alg.h>

#include <sys/socket.h>
#include <sys/types.h>

#ifndef SOL_ALG
#define SOL_ALG 279
#endif

#define IN_SIZE 1024

#define MODE "ecb"
#define CIPHER "aes"

const char key[] = "0123456789abcdef";
const size_t key_len = sizeof(key) - 1;

static unsigned _getpagesize(void)
{
	static unsigned ps;

	if (ps)
		return ps;

	long r = sysconf(_SC_PAGESIZE);
	ps = r < 0 ? 4096 : r;

	return ps;
}

static void fail(const char *msg)
{
	fprintf(stderr, "%s. Couldn't verify the skcipher bug!\n", msg);
}

int main(void)
{
	char *in = NULL;
	int err, r = 1; /* r == 0 => the bug in skcipher */
	int opfd = -1;
	int tfmfd = -1;
	uint32_t *type;

	struct iovec iov;
	struct cmsghdr *hdr;
	struct sockaddr_alg sa = {
		.salg_family = AF_ALG,
		.salg_type = "skcipher",
	};

	char buffer[CMSG_SPACE(sizeof(*type))];

	struct msghdr msg = {
		.msg_control = buffer,
		.msg_controllen = sizeof(buffer),
		.msg_iov = &iov,
		.msg_iovlen = 1,
	};

	printf("compare folowing page_size value with net.core.optmem_max value\n");
	printf("detected system's page_size: %zu\n", _getpagesize());

	if (posix_memalign((void **)&in, _getpagesize(), IN_SIZE)) {
		perror("posix_memalign()");
		fail("memalign failed");
		goto out;
	}

	memset((void *)in, 0, IN_SIZE);

	iov.iov_base = (void*)(uintptr_t)in;
	iov.iov_len = IN_SIZE;

	hdr = CMSG_FIRSTHDR(&msg);
	if (!hdr) {
		fail("small msg_control");
		goto out;
	}

	hdr->cmsg_level = SOL_ALG;
	hdr->cmsg_type = ALG_SET_OP;
	hdr->cmsg_len = CMSG_LEN(sizeof(*type));
	type = (void*)CMSG_DATA(hdr);
	*type = ALG_OP_ENCRYPT;

	if ((tfmfd = socket(AF_ALG, SOCK_SEQPACKET, 0)) == -1) {
		perror("socket()");
		fail("socket() failed supported");
		goto out;
	}

	snprintf((char *)sa.salg_name, sizeof(sa.salg_name), "%s(%s)", MODE, CIPHER);

	if (bind(tfmfd, (struct sockaddr *)&sa, sizeof(sa)) == -1) {
		perror("bind()");
		fail("bind failed");
		goto out;
	}

	if ((opfd = accept(tfmfd, NULL, 0)) == -1) {
		perror("accept()");
		fail("accept failed");
		goto out;
	}

	/* about to test aes-ecb with key size == 128b */
	printf("calling setsockopt(), setting key with keylen==%zu\n", key_len);
	if (setsockopt(tfmfd, SOL_ALG, ALG_SET_KEY, key, key_len) == -1) {
		perror("setsockopt()");
		fail("setsockopt failed");
		goto out;
	}

	if (sendmsg(opfd, &msg, 0) != IN_SIZE) {
		err = errno;
		perror("sendmsg()");

		if (err == ENOMEM) {
			printf("the kernel has a bug in a skcipher.\n");
			r = 0;
		}
		else
			fail("sendmsg() failed w/ different error than expected. "
			     "Can't verify the skcipher bug.\n");
	} else
		fprintf(stderr, "sendmsg() passed. No bug in skcipher.\n");

out:
	if (in)
		free((void *)in);

	if (tfmfd >= 0)
		close(tfmfd);

	if (opfd >= 0)
		close(opfd);

	return r;
}

--------------060709000607090503060803--
