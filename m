From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 0/5] KEYS: fixes for new keyctl_dh_compute() KDF extension
Date: Mon, 01 May 2017 16:52:35 +0200
Message-ID: <1624022.PrVQjhuSKS@positron.chronox.de>
References: <20170420054633.14572-1-ebiggers3@gmail.com> <791.1493394780@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Eric Biggers <ebiggers3@gmail.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        mathew.j.martineau@linux.intel.com,
        Eric Biggers <ebiggers@google.com>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59388 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1950597AbdEAOwi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 May 2017 10:52:38 -0400
In-Reply-To: <791.1493394780@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 28. April 2017, 17:53:00 CEST schrieb David Howells:

Hi David,

> Stephan,
> 
> Eric Biggers <ebiggers3@gmail.com> wrote:
> > This patch series fixes several bugs in the KDF extension to
> > keyctl_dh_compute() currently sitting in keys-next: a way userspace could
> > cause an infinite loop, two ways userspace could cause the use of
> > uninitialized memory, a misalignment, and missing __user annotations.
> 
> Do you want to ack these or do they need fixing?

Please see the replacement for patch 3/5 below.

Thanks
Stephan

---8<---

>From 7229546f5ca0eed032208c03e7aef47f6b52ca18 Mon Sep 17 00:00:00 2001
From: Stephan Mueller <smueller@chronox.de>
Date: Mon, 1 May 2017 16:45:22 +0200
Subject: [PATCH] keys: SP800-56A - preserve leading zeros for shared secret

The shared secret that is to be processed shall be the unchanged result
of the DH mathematical primitive. The leading zeros shall be preserved.

In addition, the kernel memory that is used as input to the KDF is
zeroized to ensure that no leaks exist.

Reported-by: Eric Biggers <ebiggers3@gmail.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/linux/mpi.h |  2 +-
 lib/mpi/mpicoder.c  | 10 ++++++----
 security/keys/dh.c  |  4 ++--
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/linux/mpi.h b/include/linux/mpi.h
index 1cc5ffb..1f679b6 100644
--- a/include/linux/mpi.h
+++ b/include/linux/mpi.h
@@ -78,7 +78,7 @@ int mpi_fromstr(MPI val, const char *str);
 u32 mpi_get_keyid(MPI a, u32 *keyid);
 void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign);
 int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
-		    int *sign);
+		    int *sign, bool skip_lzeros);
 void *mpi_get_secure_buffer(MPI a, unsigned *nbytes, int *sign);
 int mpi_write_to_sgl(MPI a, struct scatterlist *sg, unsigned nbytes,
 		     int *sign);
diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 5a0f75a..659d787 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -137,11 +137,12 @@ static int count_lzeros(MPI a)
  *		the data to-be-written on -EOVERFLOW in case buf_len was too
  *		small.
  * @sign:	if not NULL, it will be set to the sign of a.
+ * @skip_lzeros:Skip the leading zeros of the MPI before writing to buffer.
  *
  * Return:	0 on success or error code in case of error
  */
 int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
-		    int *sign)
+		    int *sign, bool skip_lzeros)
 {
 	uint8_t *p;
 #if BYTES_PER_MPI_LIMB == 4
@@ -152,7 +153,7 @@ int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
 #error please implement for this limb size.
 #endif
 	unsigned int n = mpi_get_size(a);
-	int i, lzeros;
+	int i, lzeros = 0;
 
 	if (!buf || !nbytes)
 		return -EINVAL;
@@ -160,7 +161,8 @@ int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
 	if (sign)
 		*sign = a->sign;
 
-	lzeros = count_lzeros(a);
+	if (skip_lzeros)
+		lzeros = count_lzeros(a);
 
 	if (buf_len < n - lzeros) {
 		*nbytes = n - lzeros;
@@ -219,7 +221,7 @@ void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign)
 	if (!buf)
 		return NULL;
 
-	ret = mpi_read_buffer(a, buf, n, nbytes, sign);
+	ret = mpi_read_buffer(a, buf, n, nbytes, sign, true);
 
 	if (ret) {
 		kfree(buf);
diff --git a/security/keys/dh.c b/security/keys/dh.c
index e603bd9..80089dd 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -296,7 +296,7 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user *params,
 	}
 
 	/* allocate space for DH shared secret and SP800-56A otherinfo */
-	kbuf = kmalloc(kdfcopy ? (resultlen + kdfcopy->otherinfolen) : resultlen,
+	kbuf = kzalloc(kdfcopy ? (resultlen + kdfcopy->otherinfolen) : resultlen,
 		       GFP_KERNEL);
 	if (!kbuf) {
 		ret = -ENOMEM;
@@ -318,7 +318,7 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user *params,
 	if (ret)
 		goto error5;
 
-	ret = mpi_read_buffer(result, kbuf, resultlen, &nbytes, NULL);
+	ret = mpi_read_buffer(result, kbuf, resultlen, &nbytes, NULL, false);
 	if (ret != 0)
 		goto error5;
 
-- 
2.9.3
