From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: algif_aead - fix invalid sgl linking
Date: Fri, 15 May 2015 10:18:37 -0700
Message-ID: <20150515171837.5222.92988.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: smueller@chronox.de, linux-crypto@vger.kernel.org,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:44693 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbbEORWC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 May 2015 13:22:02 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The current linking of receive sgls is invalid.
It only works with a single list, but when multiple rsgls are being chained
the list is built incorrectly. The following example, when run on the existing
implementation causes an Oops.

----- %< ------
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <linux/types.h>
#define SOL_ALG 279

#define SPLICE_F_GIFT	(0x08)
struct sockaddr_alg {
	__u16	salg_family;
	__u8	salg_type[14];
	__u32	salg_feat;
	__u32	salg_mask;
	__u8	salg_name[64];
};
struct af_alg_iv {
	__u32	ivlen;
	__u8	iv[0];
};
/* Socket options */
#define ALG_SET_KEY			1
#define ALG_SET_IV			2
#define ALG_SET_OP			3
#define ALG_SET_AEAD_ASSOCLEN           4
#define ALG_SET_AEAD_AUTHSIZE           5
/* Operations */
#define ALG_OP_DECRYPT			0
#define ALG_OP_ENCRYPT			1
#define ASSOCLEN 512
#define AUTHLEN 64
#define PKG_SIZE ((4096 * 16) + ASSOCLEN)
#define PKG_SIZE_TO_READ ((512 * 16) + AUTHLEN)
#define PKG_SINGLE_LEN (512)
#define PKG_SINGLE_RCV_LEN (512)
static char buf[PKG_SIZE]__attribute__((__aligned__(4096)));

void dump(char *mem, unsigned int len)
{
        unsigned int i;

        for (i = 0; i < len ; i++)
        {
                if (!(i % 0x10))
                        printf("0x%04x: ", i);

                if (i < len)
                        printf("%02x ", 0xff & *(mem + i));

		if (i && !((i + 1) % 0x10))
			printf("\n");
        }
}

int main(int argc, char **argv)
{
	const char key[16] =
		"\x06\xa9\x21\x40\x36\xb8\xa1\x5b"
		"\x51\x2e\x03\xd5\x34\x12\x00\x06";
	char oiv[16] =
		"\x3d\xaf\xba\x42\x9d\x9e\xb4\x30"
		"\xb4\x22\xda\x80\x2c\x9f\xac\x41";
	int opfd;
	int tfmfd;
	struct sockaddr_alg sa = {
		.salg_family = AF_ALG,
		.salg_type = "aead",
		.salg_name = "authenc(hmac(sha512),cbc(aes))"
	};
	struct msghdr msg = {};
	struct msghdr rcvmsg = {};
	struct cmsghdr *cmsg;
	char cbuf[CMSG_SPACE(4) + CMSG_SPACE(4) + CMSG_SPACE(20)] = {};
	struct aes_iv {
		__u32 len;
		__u8 iv[16];
	} *iv;
	struct iovec iov[16];
	struct iovec rcviov[16];
	char *ptrs[16];
	int pipes[2];
	int i, ret;

	memset(buf, 'A', PKG_SIZE);
	pipe(pipes);
	tfmfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
	bind(tfmfd, (struct sockaddr *)&sa, sizeof(sa));
	setsockopt(tfmfd, SOL_ALG, ALG_SET_KEY, key, 16);
	setsockopt(tfmfd, SOL_ALG, ALG_SET_AEAD_AUTHSIZE, NULL, AUTHLEN);
	opfd = accept(tfmfd, NULL, 0);

	msg.msg_control = cbuf;
	msg.msg_controllen = sizeof(cbuf);

	cmsg = CMSG_FIRSTHDR(&msg);
	cmsg->cmsg_level = SOL_ALG;
	cmsg->cmsg_type = ALG_SET_OP;
	cmsg->cmsg_len = CMSG_LEN(4);
	*(__u32 *)CMSG_DATA(cmsg) = ALG_OP_ENCRYPT;

	cmsg = CMSG_NXTHDR(&msg, cmsg);
	cmsg->cmsg_level = SOL_ALG;
	cmsg->cmsg_type = ALG_SET_AEAD_ASSOCLEN;
	cmsg->cmsg_len = CMSG_LEN(4);
	*(__u32 *)CMSG_DATA(cmsg) = ASSOCLEN;

	cmsg = CMSG_NXTHDR(&msg, cmsg);
	cmsg->cmsg_level = SOL_ALG;
	cmsg->cmsg_type = ALG_SET_IV;
	cmsg->cmsg_len = CMSG_LEN(20);
	iv = (void *)CMSG_DATA(cmsg);
	iv->len = 16;
	memcpy(iv->iv, oiv, 16);

	for (i = 0; i < 16; i++)
	{
		ptrs[i] = malloc(PKG_SINGLE_RCV_LEN);
		if (!ptrs[i])
			return -1;
		memset(ptrs[i], 'A', PKG_SINGLE_RCV_LEN);
	}
	for (i = 0; i < 16; i++)
	{
		iov[i].iov_base = buf + i * 4096;
		iov[i].iov_len = PKG_SINGLE_LEN;
	}

	iov[0].iov_len += ASSOCLEN;
	msg.msg_iovlen = 0;
	msg.msg_flags = MSG_MORE;
	for (i = 0; i < 16; i++)
	{
		rcviov[i].iov_base = ptrs[i];
		rcviov[i].iov_len = PKG_SINGLE_RCV_LEN;
	}
	rcvmsg.msg_iovlen = 16;
	rcvmsg.msg_iov = rcviov;

	ret = sendmsg(opfd, &msg, 0);
	vmsplice(pipes[1], iov, 16, SPLICE_F_GIFT);
	splice(pipes[0], NULL, opfd, NULL, PKG_SIZE_TO_READ, 0);
	ret = recvmsg(opfd, &rcvmsg, 0);
	for (i = 0; i < 16; i++)
	{
		printf("*********** Buff %d ***************\n", i);
		dump(ptrs[i], PKG_SINGLE_RCV_LEN);
		free(ptrs[i]);
	}
	close(opfd);
	close(tfmfd);
	close(pipes[0]);
	close(pipes[1]);
}
----- %< ------
This patch fixes it.
Also minor updates to comments.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/algif_aead.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 53702e9..a55e4e6 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -34,7 +34,7 @@ struct aead_ctx {
 	/*
 	 * RSGL_MAX_ENTRIES is an artificial limit where user space at maximum
 	 * can cause the kernel to allocate RSGL_MAX_ENTRIES * ALG_MAX_PAGES
-	 * bytes
+	 * pages
 	 */
 #define RSGL_MAX_ENTRIES ALG_MAX_PAGES
 	struct af_alg_sgl rsgl[RSGL_MAX_ENTRIES];
@@ -436,11 +436,10 @@ static int aead_recvmsg(struct socket *sock, struct msghdr *msg, size_t ignored,
 		if (err < 0)
 			goto unlock;
 		usedpages += err;
-		/* chain the new scatterlist with initial list */
+		/* chain the new scatterlist with previous one */
 		if (cnt)
-			scatterwalk_crypto_chain(ctx->rsgl[0].sg,
-					ctx->rsgl[cnt].sg, 1,
-					sg_nents(ctx->rsgl[cnt-1].sg));
+			af_alg_link_sg(&ctx->rsgl[cnt-1], &ctx->rsgl[cnt]);
+
 		/* we do not need more iovecs as we have sufficient memory */
 		if (outlen <= usedpages)
 			break;
