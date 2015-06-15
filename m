From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC v5 1/4] MPILIB: add mpi_read_buf() and mpi_get_size()
 helpers
Date: Mon, 15 Jun 2015 13:18:36 -0700
Message-ID: <20150615201836.15697.27743.stgit@tstruk-mobl1>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	tadeusz.struk@intel.com, steved@redhat.com, qat-linux@intel.com,
	dhowells@redhat.com, linux-crypto@vger.kernel.org,
	james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net, vgoyal@redhat.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18883 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756030AbbFOUSk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 16:18:40 -0400
In-Reply-To: <20150615201831.15697.57738.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Added a mpi_read_buf() helper function to export MPI to a buf provided by
the user, and a mpi_get_size() helper, that tells the user how big the buf is.
Changed mpi_free to use kzfree instead of kfree because it is used to free
crypto keys.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 include/linux/mpi.h |   15 +++++++++
 lib/mpi/mpicoder.c  |   87 ++++++++++++++++++++++++++++++++++++++++-----------
 lib/mpi/mpiutil.c   |    6 ++--
 3 files changed, 86 insertions(+), 22 deletions(-)

diff --git a/include/linux/mpi.h b/include/linux/mpi.h
index 5af1b81..641b7d6 100644
--- a/include/linux/mpi.h
+++ b/include/linux/mpi.h
@@ -81,6 +81,8 @@ MPI mpi_read_from_buffer(const void *buffer, unsigned *ret_nread);
 int mpi_fromstr(MPI val, const char *str);
 u32 mpi_get_keyid(MPI a, u32 *keyid);
 void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign);
+int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
+		    int *sign);
 void *mpi_get_secure_buffer(MPI a, unsigned *nbytes, int *sign);
 int mpi_set_buffer(MPI a, const void *buffer, unsigned nbytes, int sign);
 
@@ -142,4 +144,17 @@ int mpi_rshift(MPI x, MPI a, unsigned n);
 /*-- mpi-inv.c --*/
 int mpi_invm(MPI x, MPI u, MPI v);
 
+/* inline functions */
+
+/**
+ * mpi_get_size() - returns max size required to store the number
+ *
+ * @a:	A multi precision integer for which we want to allocate a bufer
+ *
+ * Return: size required to store the number
+ */
+static inline unsigned int mpi_get_size(MPI a)
+{
+	return a->nlimbs * BYTES_PER_MPI_LIMB;
+}
 #endif /*G10_MPI_H */
diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 4cc6442..bc0a1da 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -128,28 +128,36 @@ leave:
 }
 EXPORT_SYMBOL_GPL(mpi_read_from_buffer);
 
-/****************
- * Return an allocated buffer with the MPI (msb first).
- * NBYTES receives the length of this buffer. Caller must free the
- * return string (This function does return a 0 byte buffer with NBYTES
- * set to zero if the value of A is zero. If sign is not NULL, it will
- * be set to the sign of the A.
+/**
+ * mpi_read_buffer() - read MPI to a bufer provided by user (msb first)
+ *
+ * @a:		a multi precision integer
+ * @buf:	bufer to which the output will be written to. Needs to be at
+ *		leaset mpi_get_size(a) long.
+ * @buf_len:	size of the buf.
+ * @nbytes:	receives the actual length of the data written.
+ * @sign:	if not NULL, it will be set to the sign of a.
+ *
+ * Return:	0 on success or error code in case of error
  */
-void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign)
+int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
+		    int *sign)
 {
-	uint8_t *p, *buffer;
+	uint8_t *p;
 	mpi_limb_t alimb;
+	unsigned int n = mpi_get_size(a);
 	int i;
-	unsigned int n;
+
+	if (buf_len < n || !buf)
+		return -EINVAL;
 
 	if (sign)
 		*sign = a->sign;
-	*nbytes = n = a->nlimbs * BYTES_PER_MPI_LIMB;
-	if (!n)
-		n++;		/* avoid zero length allocation */
-	p = buffer = kmalloc(n, GFP_KERNEL);
-	if (!p)
-		return NULL;
+
+	if (nbytes)
+		*nbytes = n;
+
+	p = buf;
 
 	for (i = a->nlimbs - 1; i >= 0; i--) {
 		alimb = a->d[i];
@@ -171,15 +179,56 @@ void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign)
 #error please implement for this limb size.
 #endif
 	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpi_read_buffer);
+
+/*
+ * mpi_get_buffer() - Returns an allocated buffer with the MPI (msb first).
+ * Caller must free the return string.
+ * This function does return a 0 byte buffer with nbytes set to zero if the
+ * value of A is zero.
+ *
+ * @a:		a multi precision integer.
+ * @nbytes:	receives the length of this buffer.
+ * @sign:	if not NULL, it will be set to the sign of the a.
+ *
+ * Return:	Pointer to MPI buffer or NULL on error
+ */
+void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign)
+{
+	uint8_t *buf, *p;
+	unsigned int n;
+	int ret;
+
+	if (!nbytes)
+		return NULL;
+
+	n = mpi_get_size(a);
+
+	if (!n)
+		n++;
+
+	buf = kmalloc(n, GFP_KERNEL);
+
+	if (!buf)
+		return NULL;
+
+	ret = mpi_read_buffer(a, buf, n, nbytes, sign);
+
+	if (ret) {
+		kfree(buf);
+		return NULL;
+	}
 
 	/* this is sub-optimal but we need to do the shift operation
 	 * because the caller has to free the returned buffer */
-	for (p = buffer; !*p && *nbytes; p++, --*nbytes)
+	for (p = buf; !*p && *nbytes; p++, --*nbytes)
 		;
-	if (p != buffer)
-		memmove(buffer, p, *nbytes);
+	if (p != buf)
+		memmove(buf, p, *nbytes);
 
-	return buffer;
+	return buf;
 }
 EXPORT_SYMBOL_GPL(mpi_get_buffer);
 
diff --git a/lib/mpi/mpiutil.c b/lib/mpi/mpiutil.c
index bf076d2..314f4df 100644
--- a/lib/mpi/mpiutil.c
+++ b/lib/mpi/mpiutil.c
@@ -69,7 +69,7 @@ void mpi_free_limb_space(mpi_ptr_t a)
 	if (!a)
 		return;
 
-	kfree(a);
+	kzfree(a);
 }
 
 void mpi_assign_limb_space(MPI a, mpi_ptr_t ap, unsigned nlimbs)
@@ -95,7 +95,7 @@ int mpi_resize(MPI a, unsigned nlimbs)
 		if (!p)
 			return -ENOMEM;
 		memcpy(p, a->d, a->alloced * sizeof(mpi_limb_t));
-		kfree(a->d);
+		kzfree(a->d);
 		a->d = p;
 	} else {
 		a->d = kzalloc(nlimbs * sizeof(mpi_limb_t), GFP_KERNEL);
@@ -112,7 +112,7 @@ void mpi_free(MPI a)
 		return;
 
 	if (a->flags & 4)
-		kfree(a->d);
+		kzfree(a->d);
 	else
 		mpi_free_limb_space(a->d);
 
