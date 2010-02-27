From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH v1] compiler: prevent dead store elimination
Date: Sat, 27 Feb 2010 21:47:42 +0100
Message-ID: <4B8984EE.8090605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>,
	Mikael Pettersson <mikpe@it.uu.se>, penberg@cs.helsinki.fi,
	Brian Gerst <brgerst@gmail.com>, andi@firstfloor.org,
	Andrew Morton <akpm@linux-fo
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:63893 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030834Ab0B0Ure (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Feb 2010 15:47:34 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Due to optimization A call to memset() may be removed as a dead store when
the buffer is not used after its value is overwritten. The new function
secure_bzero() ensures a section of memory is padded with zeroes.

>From the GCC manual, section 5.37:
If your assembler instructions access memory in an unpredictable
fashion, add `memory' to the list of clobbered registers. This will
cause GCC to not keep memory values cached in registers across the
assembler instruction and not optimize stores or loads to that memory.

Every byte in the [p,p+n[ range must be used. If you only use the
first byte, via e.g. asm("" :: "m"(*(char*)p)), then the compiler
_will_ skip scrubbing bytes beyond the first. This works with
gcc-3.2.3 up to gcc-4.4.3.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 include/linux/compiler-gcc.h   |   11 +++++++++++
 include/linux/compiler-intel.h |    2 ++
 include/linux/string.h         |    1 +
 lib/string.c                   |   13 +++++++++++++
 4 files changed, 27 insertions(+), 0 deletions(-)

Thanks all for the required information, checkpatch.pl and compile
tested. In my (non-kernel) testcase this prevents dead store elimination.
Comments?

Roel

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 73dcf80..0799938 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -12,6 +12,17 @@
 #define barrier() __asm__ __volatile__("": : :"memory")
 
 /*
+ * Dead store elimination (DSE) is an optimization that may remove a write to
+ * a buffer that is not used anymore. Use ARRAY_PREVENT_DSE after a write when
+ * the scrub is required for security reasons.
+ */
+#define ARRAY_PREVENT_DSE(p, n)				\
+	do {						\
+		struct __scrub { char c[n]; };		\
+		asm("" : : "m"(*(struct __scrub *)p));	\
+	} while (0)
+
+/*
  * This macro obfuscates arithmetic on a variable address so that gcc
  * shouldn't recognize the original var, and make assumptions about it.
  *
diff --git a/include/linux/compiler-intel.h b/include/linux/compiler-intel.h
index d8e636e..e8e11f3 100644
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -14,9 +14,11 @@
  * It uses intrinsics to do the equivalent things.
  */
 #undef barrier
+#undef ARRAY_PREVENT_DSE
 #undef RELOC_HIDE
 
 #define barrier() __memory_barrier()
+#define ARRAY_PREVENT_DSE(p, n)
 
 #define RELOC_HIDE(ptr, off)					\
   ({ unsigned long __ptr;					\
diff --git a/include/linux/string.h b/include/linux/string.h
index a716ee2..36213e6 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -118,6 +118,7 @@ extern void * memchr(const void *,int,__kernel_size_t);
 extern char *kstrdup(const char *s, gfp_t gfp);
 extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
 extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
+extern void secure_bzero(void *, __kernel_size_t);
 
 extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
 extern void argv_free(char **argv);
diff --git a/lib/string.c b/lib/string.c
index a1cdcfc..588ac31 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -559,6 +559,19 @@ void *memset(void *s, int c, size_t count)
 EXPORT_SYMBOL(memset);
 #endif
 
+/**
+ * secure_bzero - Call memset to fill a region of memory with zeroes and
+ * ensure this memset is not removed due to dead store elimination.
+ * @p: Pointer to the start of the area.
+ * @n: The size of the area.
+ */
+void secure_bzero(void *p, size_t n)
+{
+	memset(p, 0, n);
+	ARRAY_PREVENT_DSE(p, n);
+}
+EXPORT_SYMBOL(secure_bzero);
+
 #ifndef __HAVE_ARCH_MEMCPY
 /**
  * memcpy - Copy one area of memory to another

