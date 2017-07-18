From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [RFC PATCH v12 1/4] crypto: make Jitter RNG directly accessible
Date: Tue, 18 Jul 2017 09:57:55 +0200
Message-ID: <22067042.Wh8NKMhEMa@positron.chronox.de>
References: <3910055.ntkqcq1Chb@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Jason A. Donenfeld" <jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3910055.ntkqcq1Chb@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

To support the LRNG operation which allocates the Jitter RNG separately
from the kernel crypto API, extract the relevant information into a
separate header file.

CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/jitterentropy.c         | 33 ++---------------
 include/crypto/jitterentropy.h | 80 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 31 deletions(-)
 create mode 100644 include/crypto/jitterentropy.h

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index acf44b2..90184a1 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -54,40 +54,11 @@
  #error "The CPU Jitter random number generator must not be compiled with optimizations. See documentation. Use the compiler switch -O0 for compiling jitterentropy.c."
 #endif
 
-typedef	unsigned long long	__u64;
-typedef	long long		__s64;
+#include <crypto/jitterentropy.h>
+
 typedef	unsigned int		__u32;
 #define NULL    ((void *) 0)
 
-/* The entropy pool */
-struct rand_data {
-	/* all data values that are vital to maintain the security
-	 * of the RNG are marked as SENSITIVE. A user must not
-	 * access that information while the RNG executes its loops to
-	 * calculate the next random value. */
-	__u64 data;		/* SENSITIVE Actual random number */
-	__u64 old_data;		/* SENSITIVE Previous random number */
-	__u64 prev_time;	/* SENSITIVE Previous time stamp */
-#define DATA_SIZE_BITS ((sizeof(__u64)) * 8)
-	__u64 last_delta;	/* SENSITIVE stuck test */
-	__s64 last_delta2;	/* SENSITIVE stuck test */
-	unsigned int stuck:1;	/* Time measurement stuck */
-	unsigned int osr;	/* Oversample rate */
-	unsigned int stir:1;		/* Post-processing stirring */
-	unsigned int disable_unbias:1;	/* Deactivate Von-Neuman unbias */
-#define JENT_MEMORY_BLOCKS 64
-#define JENT_MEMORY_BLOCKSIZE 32
-#define JENT_MEMORY_ACCESSLOOPS 128
-#define JENT_MEMORY_SIZE (JENT_MEMORY_BLOCKS*JENT_MEMORY_BLOCKSIZE)
-	unsigned char *mem;	/* Memory access location with size of
-				 * memblocks * memblocksize */
-	unsigned int memlocation; /* Pointer to byte in *mem */
-	unsigned int memblocks;	/* Number of memory blocks in *mem */
-	unsigned int memblocksize; /* Size of one memory block in bytes */
-	unsigned int memaccessloops; /* Number of memory accesses per random
-				      * bit generation */
-};
-
 /* Flags that can be used to initialize the RNG */
 #define JENT_DISABLE_STIR (1<<0) /* Disable stirring the entropy pool */
 #define JENT_DISABLE_UNBIAS (1<<1) /* Disable the Von-Neuman Unbiaser */
diff --git a/include/crypto/jitterentropy.h b/include/crypto/jitterentropy.h
new file mode 100644
index 0000000..7ed8f20
--- /dev/null
+++ b/include/crypto/jitterentropy.h
@@ -0,0 +1,80 @@
+/*
+ * Copyright (C) 2017, Stephan Mueller <smueller@chronox.de>
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, and the entire permission notice in its entirety,
+ *    including the disclaimer of warranties.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. The name of the author may not be used to endorse or promote
+ *    products derived from this software without specific prior
+ *    written permission.
+ *
+ * ALTERNATIVELY, this product may be distributed under the terms of
+ * the GNU General Public License, in which case the provisions of the GPL2 are
+ * required INSTEAD OF the above restrictions.  (This clause is
+ * necessary due to a potential bad interaction between the GPL and
+ * the restrictions contained in a BSD-style copyright.)
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
+ * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ALL OF
+ * WHICH ARE HEREBY DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
+ * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
+ * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+ * USE OF THIS SOFTWARE, EVEN IF NOT ADVISED OF THE POSSIBILITY OF SUCH
+ * DAMAGE.
+ */
+
+#ifndef _JITTERENTROPY_H
+#define _JITTERENTROPY_H
+
+typedef	unsigned long long	__u64;
+typedef	long long		__s64;
+
+/* The entropy pool */
+struct rand_data {
+	/*
+	 * All data values that are vital to maintain the security
+	 * of the RNG are marked as SENSITIVE. A user must not
+	 * access that information while the RNG executes its loops to
+	 * calculate the next random value.
+	 */
+	__u64 data;		/* SENSITIVE Actual random number */
+	__u64 old_data;		/* SENSITIVE Previous random number */
+	__u64 prev_time;	/* SENSITIVE Previous time stamp */
+#define DATA_SIZE_BITS ((sizeof(__u64)) * 8)
+	__u64 last_delta;	/* SENSITIVE stuck test */
+	__s64 last_delta2;	/* SENSITIVE stuck test */
+	unsigned int stuck:1;	/* Time measurement stuck */
+	unsigned int osr;	/* Oversample rate */
+	unsigned int stir:1;		/* Post-processing stirring */
+	unsigned int disable_unbias:1;	/* Deactivate Von-Neuman unbias */
+#define JENT_MEMORY_BLOCKS 64
+#define JENT_MEMORY_BLOCKSIZE 32
+#define JENT_MEMORY_ACCESSLOOPS 128
+#define JENT_MEMORY_SIZE (JENT_MEMORY_BLOCKS*JENT_MEMORY_BLOCKSIZE)
+	unsigned char *mem;	/*
+				 * Memory access location with size of
+				 * memblocks * memblocksize
+				 */
+	unsigned int memlocation; /* Pointer to byte in *mem */
+	unsigned int memblocks;	/* Number of memory blocks in *mem */
+	unsigned int memblocksize; /* Size of one memory block in bytes */
+	unsigned int memaccessloops; /* Number of memory accesses per random
+				      * bit generation */
+};
+
+int jent_entropy_init(void);
+int jent_read_entropy(struct rand_data *ec, unsigned char *data,
+		      unsigned int len);
+
+#endif /* _JITTERENTROPY_H */
-- 
2.9.4
