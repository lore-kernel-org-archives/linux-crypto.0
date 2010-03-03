From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH v3] compiler: prevent dead store elimination
Date: Thu, 04 Mar 2010 00:16:35 +0100
Message-ID: <4B8EEDD3.9040201@gmail.com>
References: <4B8984EE.8090605@gmail.com>	<20100228095520.GA29531@one.firstfloor.org>	<4B8A8D17.2040208@gmail.com> <19339.35080.637800.292674@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <andi@firstfloor.org>,
	"David S. Miller" <davem@davemloft.net>, penberg@cs.helsinki.fi,
	Brian Gerst <brgerst@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Herbert@gondor.apana.org.au
To: Mikael Pettersson <mikpe@it.uu.se>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f212.google.com ([209.85.219.212]:43187 "EHLO
	mail-ew0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab0CCXQI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Mar 2010 18:16:08 -0500
In-Reply-To: <19339.35080.637800.292674@pilspetsen.it.uu.se>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Due to optimization a call to memset() may be removed as a dead store when
the buffer is not used after its value is overwritten. The new function
secure_bzero() ensures a section of memory is padded with zeroes.

To prevent a memset() from being eliminated, the compiler must belive
that the memory area is used after the memset(). Also, every byte in
the memory area must be used. If only the first byte is used, via e.g.
asm("" :: "m"(*(char*)p)), then the compiler _will_ skip scrubbing
bytes beyond the first.

The trick is to define a local type of the same size as the memory
area, and use it for the "m" operand in a dummy asm():

	static inline void fake_memory_use(void *p, size_t n)
	{
		struct __scrub { char c[n]; }
		asm("" : : "m"(*(struct __scrub *)p));
	}

This looks strange, n being a variable, but has been confirmed to
work with gcc-3.2.3 up to gcc-4.4.3.

Many thanks to Mikael Pettersson and Andi Kleen.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I used a trick to prevent the assembly for Itanium, defining
fake_memory_use in instrinsics.h and checking its definition
in string.c, but maybe there's a better way to do this?

To provide a memory clobber for Itanium it appears we could use
the pragma directive to set the optimization level [1]. Only when
optimization level is greater than 3, dead store removal occurs[2].
But this will be ugly:

inline void secure_bzero(void *p, size_t n)
{
#ifdef _ASM_IA64_INTRINSICS_H
#pragma OPT_LEVEL 2
	memset(p, 0, n);
#pragma OPT_LEVEL INITIAL
#else
	memset(p, 0, n);
	fake_memory_use(p, n);
#endif /* _ASM_IA64_INTRINSICS_H */
}

Do we want this?

Thanks, Roel

[1] http://docs.hp.com/en/B3901-90030/ch03s04.html
[2] http://h21007.www2.hp.com/portal/download/files/unprot/Itanium/OptimizingApps-ItaniumV9-1.pdf
(page 6)

 arch/ia64/include/asm/intrinsics.h |    3 +++
 include/linux/string.h             |    1 +
 lib/string.c                       |   27 +++++++++++++++++++++++++++
 3 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/include/asm/intrinsics.h b/arch/ia64/include/asm/intrinsics.h
index 111ed52..51d8035 100644
--- a/arch/ia64/include/asm/intrinsics.h
+++ b/arch/ia64/include/asm/intrinsics.h
@@ -241,6 +241,9 @@ extern long ia64_cmpxchg_called_with_bad_pointer (void);
 	IA64_INTRINSIC_API(intrin_local_irq_restore)
 #define ia64_set_rr0_to_rr4		IA64_INTRINSIC_API(set_rr0_to_rr4)
 
+/* FIXME: define fake_memory_use as a memory clobber for Itanium */
+#define fake_memory_use
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_IA64_INTRINSICS_H */
diff --git a/include/linux/string.h b/include/linux/string.h
index a716ee2..be68efb 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -118,6 +118,7 @@ extern void * memchr(const void *,int,__kernel_size_t);
 extern char *kstrdup(const char *s, gfp_t gfp);
 extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
 extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
+extern void secure_bzero(void *, size_t);
 
 extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
 extern void argv_free(char **argv);
diff --git a/lib/string.c b/lib/string.c
index a1cdcfc..cbc32d4 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -559,6 +559,33 @@ void *memset(void *s, int c, size_t count)
 EXPORT_SYMBOL(memset);
 #endif
 
+#ifndef fake_memory_use
+/*
+ * Dead store elimination is an optimization that may remove a write to a
+ * buffer that is not used anymore. To prevent this, e.g. for security
+ * reasons, the compiler must believe that every byte in this memory area
+ * is used after the last write.
+ */
+static inline void fake_memory_use(void *p, size_t n)
+{
+	struct __scrub { char c[n]; }
+	asm("" : : "m"(*(struct __scrub *)p));
+}
+#endif /* fake_memory_use */
+
+/**
+ * secure_bzero - Call memset to fill a region of memory with zeroes and
+ * ensure this memset is not removed due to dead store elimination.
+ * @p: Pointer to the start of the area.
+ * @n: The size of the area.
+ */
+inline void secure_bzero(void *p, size_t n)
+{
+	memset(p, 0, n);
+	fake_memory_use(p, n);
+}
+EXPORT_SYMBOL(secure_bzero);
+
 #ifndef __HAVE_ARCH_MEMCPY
 /**
  * memcpy - Copy one area of memory to another
