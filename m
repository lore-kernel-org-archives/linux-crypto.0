From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH v2] compiler: prevent dead store elimination
Date: Sun, 28 Feb 2010 16:34:47 +0100
Message-ID: <4B8A8D17.2040208@gmail.com>
References: <4B8984EE.8090605@gmail.com> <20100228095520.GA29531@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	Mikael Pettersson <mikpe@it.uu.se>, penberg@cs.helsinki.fi,
	Brian Gerst <brgerst@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Herbert@gondor.apana.org.au
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100228095520.GA29531@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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

Thanks to Mikael Pettersson for this information.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
> You forgot to credit Mikael

Not intended, I first put it in the changelog but then decided to thank all
involved in my comments. Do credits belong in the changelog?

>> +#define ARRAY_PREVENT_DSE(p, n)				\
> 
> Maybe it's just me, but the name is ugly.

Ok, changed it to ARRAY_KEEP_STORE() or do you have a suggestion?

>> +	do {						\
>> +		struct __scrub { char c[n]; };		\
> 
> Better typeof(*p)[n]

I guess you meant `struct __scrub { typeof(*p) c[n]; };' ?

In the current implementation p is a void pointer. Is it ok to declare an array
of voids? In kernel it compiles, in my testcase it produces an error.

>> +++ b/include/linux/compiler-intel.h

>> +#define ARRAY_PREVENT_DSE(p, n)
> 
> Who says the Intel compiler doesn't need this?

There was a comment in include/linux/compiler-intel.h that it's not supported.

> I'm sure it does dead store elimination too and it understands
> gcc asm syntax.

Ok, should I put it in include/linux/compiler.h or where?

>> +void secure_bzero(void *p, size_t n)
>> +{
>> +	memset(p, 0, n);
>> +	ARRAY_PREVENT_DSE(p, n);

> I think that's a candidate for a inline

You mean the secure_bzero() function, right?

Thanks for comments, Roel

 include/linux/compiler.h |   11 +++++++++++
 include/linux/string.h   |    1 +
 lib/string.c             |   13 +++++++++++++
 3 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 188fcae..2f14199 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -302,4 +302,15 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
  */
 #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
 
+/*
+ * Dead store elimination is an optimization that may remove a write to a
+ * buffer that is not used anymore. Use ARRAY_KEEP_STORE after a write when
+ * the scrub is required for security reasons.
+ */
+#define ARRAY_KEEP_STORE(p, n)				\
+	do {						\
+		struct __scrub { typeof(*p) c[n]; };	\
+		asm("" : : "m"(*(struct __scrub *)p));	\
+	} while (0)
+
 #endif /* __LINUX_COMPILER_H */
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
index a1cdcfc..5576161 100644
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
+inline void secure_bzero(void *p, size_t n)
+{
+	memset(p, 0, n);
+	ARRAY_KEEP_STORE(p, n);
+}
+EXPORT_SYMBOL(secure_bzero);
+
 #ifndef __HAVE_ARCH_MEMCPY
 /**
  * memcpy - Copy one area of memory to another
