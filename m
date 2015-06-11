From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC v4 1/4] MPILIB: add mpi_read_buf(),
 mpi_copy() and mpi_get_size() helpers
Date: Thu, 11 Jun 2015 12:05:38 -0700
Message-ID: <20150611190538.31826.97258.stgit@tstruk-mobl1>
References: <20150611190533.31826.13956.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, tadeusz.struk@intel.com,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150611190533.31826.13956.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Added a mpi_read_buf() helper function to export MPI to a buf provided by
the user, and a mpi_get_size() helper, that tells the user how big the buf is.
Implemented mpi_copy(), which was declared in mpi.h, but never implemented.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 include/linux/mpi.h |    3 ++
 lib/mpi/mpicoder.c  |   86 ++++++++++++++++++++++++++++++++++++++++-----------
 lib/mpi/mpiutil.c   |   47 ++++++++++++++++++++++++++++
 3 files changed, 117 insertions(+), 19 deletions(-)

diff --git a/include/linux/mpi.h b/include/linux/mpi.h
index 5af1b81..5e55fd0 100644
--- a/include/linux/mpi.h
+++ b/include/linux/mpi.h
@@ -73,6 +73,7 @@ int mpi_set_ui(MPI w, ulong u);
 MPI mpi_alloc_set_ui(unsigned long u);
 void mpi_m_check(MPI a);
 void mpi_swap(MPI a, MPI b);
+unsigned int mpi_get_size(MPI a);
 
 /*-- mpicoder.c --*/
 MPI do_encode_md(const void *sha_buffer, unsigned nbits);
@@ -81,6 +82,8 @@ MPI mpi_read_from_buffer(const void *buffer, unsigned *ret_nread);
 int mpi_fromstr(MPI val, const char *str);
 u32 mpi_get_keyid(MPI a, u32 *keyid);
 void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign);
+int mpi_read_buffer(MPI a, uint8_t *buf, unsigned buf_len, unsigned *nbytes,
+		    int *sign);
 void *mpi_get_secure_buffer(MPI a, unsigned *nbytes, int *sign);
 int mpi_set_buffer(MPI a, const void *buffer, unsigned nbytes, int sign);
 
diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 4cc6442..f48b028 100644
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
@@ -171,15 +179,55 @@ void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign)
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
+	int n, ret;
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
index bf076d2..ee078e2 100644
--- a/lib/mpi/mpiutil.c
+++ b/lib/mpi/mpiutil.c
@@ -54,6 +54,40 @@ MPI mpi_alloc(unsigned nlimbs)
 }
 EXPORT_SYMBOL_GPL(mpi_alloc);
 
+/**
+ * mpi_copy() - allocates a new MPI as exact copy of a.
+ *
+ * @copy: pointer to an MPI in which the copy will be stored
+ * @a:	A multi precision integer for which we want to do a copy
+ *
+ * Return: 0 on success or err
+ */
+int mpi_copy(MPI *copy, MPI a)
+{
+	int ret = 0;
+
+	if (!copy)
+		return -EINVAL;
+
+	if (a) {
+		*copy = mpi_alloc(a->nlimbs);
+		if (*copy) {
+			memcpy((*copy)->d, a->d, a->nlimbs *
+			       sizeof(mpi_limb_t));
+			(*copy)->nlimbs = a->nlimbs;
+			(*copy)->sign = a->sign;
+			(*copy)->flags = a->flags;
+			(*copy)->nbits = a->nbits;
+		} else {
+			ret = -ENOMEM;
+		}
+	} else {
+		*copy = NULL;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mpi_copy);
+
 mpi_ptr_t mpi_alloc_limb_space(unsigned nlimbs)
 {
 	size_t len = nlimbs * sizeof(mpi_limb_t);
@@ -122,5 +156,18 @@ void mpi_free(MPI a)
 }
 EXPORT_SYMBOL_GPL(mpi_free);
 
+/**
+ * mpi_get_size() - returns max size required to store the number
+ *
+ * @a:	A multi precision integer for which we want to allocate a bufer
+ *
+ * Return: size required to store the number
+ */
+unsigned int mpi_get_size(MPI a)
+{
+	return a->nlimbs * BYTES_PER_MPI_LIMB;
+}
+EXPORT_SYMBOL_GPL(mpi_get_size);
+
 MODULE_DESCRIPTION("Multiprecision maths library");
 MODULE_LICENSE("GPL");
