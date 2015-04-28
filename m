From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH crypto-2.6] lib: make memzero_explicit more robust against dead store elimination
Date: Tue, 28 Apr 2015 17:22:20 +0200
Message-ID: <85dfdd23d98412a183546e2e7659a6a2bed1fca8.1430230786.git.daniel@iogearbox.net>
Cc: linux-crypto@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>,
	Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	mancha security <mancha1@zoho.com>,
	Mark Charlebois <charlebm@gmail.com>,
	Behan Webster <behanw@converseincode.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:60564 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965792AbbD1PWa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Apr 2015 11:22:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In commit 0b053c951829 ("lib: memzero_explicit: use barrier instead
of OPTIMIZER_HIDE_VAR"), we made memzero_explicit() more robust in
case LTO would decide to inline memzero_explicit() and eventually
find out it could be elimiated as dead store.

While using barrier() works well for the case of gcc, recent efforts
from LLVMLinux people suggest to use llvm as an alternative to gcc,
and there, Stephan found in a simple stand-alone user space example
that llvm could nevertheless optimize and thus elimitate the memset().
A similar issue has been observed in the referenced llvm bug report,
which is regarded as not-a-bug.

The fix in this patch now works for both compilers (also tested with
more aggressive optimization levels). Arguably, in the current kernel
tree it's more of a theoretical issue, but imho, it's better to be
pedantic about it.

It's clearly visible though, with the below code: if we would have
used barrier()-only here, llvm would have omitted clearing, not so
with barrier_data() variant:

  static inline void memzero_explicit(void *s, size_t count)
  {
    memset(s, 0, count);
    barrier_data(s);
  }

  int main(void)
  {
    char buff[20];
    memzero_explicit(buff, sizeof(buff));
    return 0;
  }

  $ gcc -O2 test.c
  $ gdb a.out
  (gdb) disassemble main
  Dump of assembler code for function main:
   0x0000000000400400  <+0>: lea   -0x28(%rsp),%rax
   0x0000000000400405  <+5>: movq  $0x0,-0x28(%rsp)
   0x000000000040040e <+14>: movq  $0x0,-0x20(%rsp)
   0x0000000000400417 <+23>: movl  $0x0,-0x18(%rsp)
   0x000000000040041f <+31>: xor   %eax,%eax
   0x0000000000400421 <+33>: retq
  End of assembler dump.

  $ clang -O2 test.c
  $ gdb a.out
  (gdb) disassemble main
  Dump of assembler code for function main:
   0x00000000004004f0  <+0>: xorps  %xmm0,%xmm0
   0x00000000004004f3  <+3>: movaps %xmm0,-0x18(%rsp)
   0x00000000004004f8  <+8>: movl   $0x0,-0x8(%rsp)
   0x0000000000400500 <+16>: lea    -0x18(%rsp),%rax
   0x0000000000400505 <+21>: xor    %eax,%eax
   0x0000000000400507 <+23>: retq
  End of assembler dump.

As clang (but also icc) defines __GNUC__, it's sufficient to define this
in compiler-gcc.h only.

Reference: https://llvm.org/bugs/show_bug.cgi?id=15495
Reported-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Stephan Mueller <smueller@chronox.de>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: mancha security <mancha1@zoho.com>
Cc: Mark Charlebois <charlebm@gmail.com>
Cc: Behan Webster <behanw@converseincode.com>
---
 include/linux/compiler-gcc.h | 16 +++++++++++++++-
 include/linux/compiler.h     |  4 ++++
 lib/string.c                 |  2 +-
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index cdf13ca..371e560 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -9,10 +9,24 @@
 		   + __GNUC_MINOR__ * 100 \
 		   + __GNUC_PATCHLEVEL__)
 
-
 /* Optimization barrier */
+
 /* The "volatile" is due to gcc bugs */
 #define barrier() __asm__ __volatile__("": : :"memory")
+/*
+ * This version is i.e. to prevent dead stores elimination on @ptr
+ * where gcc and llvm may behave differently when otherwise using
+ * normal barrier(): while gcc behavior gets along with a normal
+ * barrier(), llvm needs an explicit input variable to be assumed
+ * clobbered. The issue is as follows: while the inline asm might
+ * access any memory it wants, the compiler could have fit all of
+ * @ptr into memory registers instead, and since @ptr never escaped
+ * from that, it proofed that the inline asm wasn't touching any of
+ * it. This version works well with both compilers, i.e. we're telling
+ * the compiler that the inline asm absolutely may see the contents
+ * of @ptr. See also: https://llvm.org/bugs/show_bug.cgi?id=15495
+ */
+#define barrier_data(ptr) __asm__ __volatile__("": :"r"(ptr) :"memory")
 
 /*
  * This macro obfuscates arithmetic on a variable address so that gcc
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 0e41ca0..8677225 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -169,6 +169,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 # define barrier() __memory_barrier()
 #endif
 
+#ifndef barrier_data
+# define barrier_data(ptr) barrier()
+#endif
+
 /* Unreachable code */
 #ifndef unreachable
 # define unreachable() do { } while (1)
diff --git a/lib/string.c b/lib/string.c
index a579201..bb3d4b6 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -607,7 +607,7 @@ EXPORT_SYMBOL(memset);
 void memzero_explicit(void *s, size_t count)
 {
 	memset(s, 0, count);
-	barrier();
+	barrier_data(s);
 }
 EXPORT_SYMBOL(memzero_explicit);
 
-- 
1.9.3
