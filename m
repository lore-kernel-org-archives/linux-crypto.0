From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: AF_ALG - get_page upon reassignment to TX SGL
Date: Thu, 10 Aug 2017 16:40:03 +0200
Message-ID: <2704295.VBAGuigrBX@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58480 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752091AbdHJOkF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2017 10:40:05 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

The error can be triggered with the following test. Invoking that test
in a while [ 1 ] loop shows that no memory is leaked.

#include <stdio.h>
#include <kcapi.h>

int main(int argc, char *argv[])
{
	char buf[8192];
	struct kcapi_handle *handle;
	struct iovec iov;
	int ret;

	(void)argc;
	(void)argv;

	iov.iov_base = buf;

	ret = kcapi_cipher_init(&handle, "ctr(aes)", 0);
	if (ret)
		return ret;

	ret = kcapi_cipher_setkey(handle, (unsigned char *)"0123456789abcdef", 16);
	if (ret)
		return ret;

	ret = kcapi_cipher_stream_init_enc(handle, (unsigned char *)"0123456789abcdef", NULL, 0);
	if (ret < 0)
		return ret;

	iov.iov_len = 4152;
	ret = kcapi_cipher_stream_update(handle, &iov, 1);
	if (ret < 0)
		return ret;

	iov.iov_len = 4096;
	ret = kcapi_cipher_stream_op(handle, &iov, 1);
	if (ret < 0)
		return ret;

	kcapi_cipher_destroy(handle);

	return 0;
}

---8<---

When a page is assigned to a TX SGL, call get_page to increment the
reference counter. It is possible that one page is referenced in
multiple SGLs:

- in the global TX SGL in case a previous af_alg_pull_tsgl only
reassigned parts of a page to a per-request TX SGL

- in the per-request TX SGL as assigned by af_alg_pull_tsgl

Note, multiple requests can be active at the same time whose TX SGLs all
point to different parts of the same page.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index d6936c0e08d9..ffa9f4ccd9b4 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -641,9 +641,9 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 				if (dst_offset >= plen) {
 					/* discard page before offset */
 					dst_offset -= plen;
-					put_page(page);
 				} else {
 					/* reassign page to dst after offset */
+					get_page(page);
 					sg_set_page(dst + j, page,
 						    plen - dst_offset,
 						    sg[i].offset + dst_offset);
@@ -661,9 +661,7 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 			if (sg[i].length)
 				return;
 
-			if (!dst)
-				put_page(page);
-
+			put_page(page);
 			sg_assign_page(sg + i, NULL);
 		}
 
-- 
2.13.4
