From: "Chanho Min" <chanho.min@lge.com>
Subject: Re: [PATCH 1/2] lib: Add lz4 compressor module
Date: Fri, 26 Apr 2013 14:02:01 +0900
Message-ID: <OF6B440C9E.4A0516C8-ON49257B59.001BA689-49257B59.001BA68A@lge.com>
References: <CAOAMb1D8rokZpQpp6mEJw6KXcQq8fJUWBJoC5+ZfkNaE6WvAZA@mail.gmail.com>
	<CAMuHMdXXoaQjb9sRK=X3gEDwqQBJcJQtaJbUGB8cJmteHSN3vQ@mail.gmail.com>
	<5175014e.487a420a.4c58.ffffe0b9SMTPIN_ADDED_BROKEN@mx.google.com>
Reply-To: "Chanho Min" <chanho.min@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: 'Geert Uytterhoeven' <geert@linux-m68k.org>,
	'Bob Pearson' <rpearson@systemfabricworks.com>,
	'Richard Weinberger' <richard@nod.at>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	'Yann Collet' <yann.collet.73@gmail.com>,
	=?EUC-KR?B?wMyw5r3E?= <kyungsik.lee@lge.com>,
	'Linux/m68k' <linux-m68k@vger.kernel.org>,
	'sparclinux' <sparclinux@vger.kernel.org>,
	'Linux-Next' <linux-next@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <5175014e.487a420a.4c58.ffffe0b9SMTPIN_ADDED_BROKEN@mx.google.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


>> gcc seems to define __builtin_clz as __clzsi2 in some architecture.
>> But, kernel doesn't link libgcc.a.
>> If kernel should use gcc's built-in function without libgcc.a,
>> do we need to port __clzsi2 to 'arch/*/lib/*'?
>
>This breaks alpha (gcc-4.4.4) as well.  Can we please get this fixed
>promptly?

__clzsi2 can be implemented by using generic functions.
It can be overridden by linking arch-specific versions may not be implemented.
does this way look acceptable?

diff --git a/lib/Makefile b/lib/Makefile
index af79e8c..e17b3ee 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -23,7 +23,7 @@ lib-y += kobject.o klist.o

 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
       bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-      gcd.o lcm.o list_sort.o uuid.o flex_array.o \
+      gcd.o lcm.o list_sort.o uuid.o flex_array.o clz.o\
       bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
diff --git a/lib/clz.c b/lib/clz.c
index e69de29..6794b83 100644
--- a/lib/clz.c
+++ b/lib/clz.c
@@ -0,0 +1,23 @@
+#include <linux/kernel.h>
+
+int __attribute__((weak)) __clzsi2(int val)
+{
+     return BITS_PER_LONG - fls(val);
+}
+EXPORT_SYMBOL(__clzsi2);
+
+#if BITS_PER_LONG == 32
+int __attribute__((weak)) __clzdi2(long val)
+{
+     return BITS_PER_LONG - fls((int)val);
+}
+EXPORT_SYMBOL(__clzdi2);
+#elif BITS_PER_LONG == 64
+int __attribute__((weak)) __clzdi2(long val)
+{
+     return BITS_PER_LONG - fls64((u64)val);
+}
+EXPORT_SYMBOL(__clzdi2);
+#else
+#error BITS_PER_LONG not 32 or 64
+#endif
