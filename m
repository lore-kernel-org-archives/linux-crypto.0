From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] MPI: Fix mpi_read_buffer
Date: Mon, 24 Aug 2015 07:52:14 -0700
Message-ID: <20150824145214.26239.98271.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56587 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053AbbHXOxc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Aug 2015 10:53:32 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Change mpi_read_buffer to return a number without leading zeros
so that mpi_read_buffer and mpi_get_buffer return the same thing.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 lib/mpi/mpicoder.c |   38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index bc0a1da..95c52a9 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -146,18 +146,25 @@ int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
 	uint8_t *p;
 	mpi_limb_t alimb;
 	unsigned int n = mpi_get_size(a);
-	int i;
+	int i, lzeros = 0;
 
-	if (buf_len < n || !buf)
+	if (buf_len < n || !buf || !nbytes)
 		return -EINVAL;
 
 	if (sign)
 		*sign = a->sign;
 
-	if (nbytes)
-		*nbytes = n;
+	p = (void *)&a->d[a->nlimbs] - 1;
+
+	for (i = a->nlimbs * sizeof(alimb) - 1; i >= 0; i--, p--) {
+		if (!*p)
+			lzeros++;
+		else
+			break;
+	}
 
 	p = buf;
+	*nbytes = n - lzeros;
 
 	for (i = a->nlimbs - 1; i >= 0; i--) {
 		alimb = a->d[i];
@@ -178,6 +185,19 @@ int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
 #else
 #error please implement for this limb size.
 #endif
+
+		if (lzeros > 0) {
+			if (lzeros >= sizeof(alimb)) {
+				p -= sizeof(alimb);
+			} else {
+				mpi_limb_t *limb1 = (void *)p - sizeof(alimb);
+				mpi_limb_t *limb2 = (void *)p - sizeof(alimb)
+							+ lzeros;
+				*limb1 = *limb2;
+				p -= lzeros;
+			}
+			lzeros -= sizeof(alimb);
+		}
 	}
 	return 0;
 }
@@ -197,7 +217,7 @@ EXPORT_SYMBOL_GPL(mpi_read_buffer);
  */
 void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign)
 {
-	uint8_t *buf, *p;
+	uint8_t *buf;
 	unsigned int n;
 	int ret;
 
@@ -220,14 +240,6 @@ void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign)
 		kfree(buf);
 		return NULL;
 	}
-
-	/* this is sub-optimal but we need to do the shift operation
-	 * because the caller has to free the returned buffer */
-	for (p = buf; !*p && *nbytes; p++, --*nbytes)
-		;
-	if (p != buf)
-		memmove(buf, p, *nbytes);
-
 	return buf;
 }
 EXPORT_SYMBOL_GPL(mpi_get_buffer);
