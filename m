From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Subject: [PATCH v3 1/4] lib/mpi: only require buffers as big as needed for the integer
Date: Fri, 20 Nov 2015 04:13:32 +0100
Message-ID: <1447989215-523-1-git-send-email-andrew.zaborowski@intel.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:32941 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933930AbbKTDOT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Nov 2015 22:14:19 -0500
Received: by wmec201 with SMTP id c201so53767377wme.0
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2015 19:14:17 -0800 (PST)
Received: from localhost.localdomain (9.Red-2-136-109.dynamicIP.rima-tde.net. [2.136.109.9])
        by smtp.gmail.com with ESMTPSA id t194sm672803wmt.11.2015.11.19.19.14.16
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 19 Nov 2015 19:14:17 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since mpi_write_to_sgl and mpi_read_buffer explicitly left-align the
integers being written it makes no sense to require a buffer big enough for
the number + the leading zero bytes which are not written.  The error
returned also doesn't convey any information.  So instead require only the
size needed and return -EOVERFLOW to signal when buffer too short.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
No changes since v1
---
 lib/mpi/mpicoder.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index c7e0a70..074d2df 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -135,7 +135,9 @@ EXPORT_SYMBOL_GPL(mpi_read_from_buffer);
  * @buf:	bufer to which the output will be written to. Needs to be at
  *		leaset mpi_get_size(a) long.
  * @buf_len:	size of the buf.
- * @nbytes:	receives the actual length of the data written.
+ * @nbytes:	receives the actual length of the data written on success and
+ *		the data to-be-written on -EOVERFLOW in case buf_len was too
+ *		small.
  * @sign:	if not NULL, it will be set to the sign of a.
  *
  * Return:	0 on success or error code in case of error
@@ -148,7 +150,7 @@ int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
 	unsigned int n = mpi_get_size(a);
 	int i, lzeros = 0;
 
-	if (buf_len < n || !buf || !nbytes)
+	if (!buf || !nbytes)
 		return -EINVAL;
 
 	if (sign)
@@ -163,6 +165,11 @@ int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
 			break;
 	}
 
+	if (buf_len < n - lzeros) {
+		*nbytes = n - lzeros;
+		return -EOVERFLOW;
+	}
+
 	p = buf;
 	*nbytes = n - lzeros;
 
@@ -332,7 +339,8 @@ EXPORT_SYMBOL_GPL(mpi_set_buffer);
  * @nbytes:	in/out param - it has the be set to the maximum number of
  *		bytes that can be written to sgl. This has to be at least
  *		the size of the integer a. On return it receives the actual
- *		length of the data written.
+ *		length of the data written on success or the data that would
+ *		be written if buffer was too small.
  * @sign:	if not NULL, it will be set to the sign of a.
  *
  * Return:	0 on success or error code in case of error
@@ -345,7 +353,7 @@ int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned *nbytes,
 	unsigned int n = mpi_get_size(a);
 	int i, x, y = 0, lzeros = 0, buf_len;
 
-	if (!nbytes || *nbytes < n)
+	if (!nbytes)
 		return -EINVAL;
 
 	if (sign)
@@ -360,6 +368,11 @@ int mpi_write_to_sgl(MPI a, struct scatterlist *sgl, unsigned *nbytes,
 			break;
 	}
 
+	if (*nbytes < n - lzeros) {
+		*nbytes = n - lzeros;
+		return -EOVERFLOW;
+	}
+
 	*nbytes = n - lzeros;
 	buf_len = sgl->length;
 	p2 = sg_virt(sgl);
-- 
2.1.4
