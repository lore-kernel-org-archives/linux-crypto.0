From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH crypto-2.6] lib: make memzero_explicit more robust against dead store elimination
Date: Tue, 28 Apr 2015 23:37:16 +0200
Message-ID: <7775527.2BbWQL33o4@tauon>
References: <85dfdd23d98412a183546e2e7659a6a2bed1fca8.1430230786.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	mancha security <mancha1@zoho.com>,
	Mark Charlebois <charlebm@gmail.com>,
	Behan Webster <behanw@converseincode.com>
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34618 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031108AbbD1XmK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Apr 2015 19:42:10 -0400
In-Reply-To: <85dfdd23d98412a183546e2e7659a6a2bed1fca8.1430230786.git.daniel@iogearbox.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 28. April 2015, 17:22:20 schrieb Daniel Borkmann:

Hi Daniel,

>In commit 0b053c951829 ("lib: memzero_explicit: use barrier instead
>of OPTIMIZER_HIDE_VAR"), we made memzero_explicit() more robust in
>case LTO would decide to inline memzero_explicit() and eventually
>find out it could be elimiated as dead store.
>
>While using barrier() works well for the case of gcc, recent efforts
>from LLVMLinux people suggest to use llvm as an alternative to gcc,
>and there, Stephan found in a simple stand-alone user space example
>that llvm could nevertheless optimize and thus elimitate the memset().
>A similar issue has been observed in the referenced llvm bug report,
>which is regarded as not-a-bug.
>
>The fix in this patch now works for both compilers (also tested with
>more aggressive optimization levels). Arguably, in the current kernel
>tree it's more of a theoretical issue, but imho, it's better to be
>pedantic about it.
>
>It's clearly visible though, with the below code: if we would have
>used barrier()-only here, llvm would have omitted clearing, not so
>with barrier_data() variant:
>
>  static inline void memzero_explicit(void *s, size_t count)
>  {
>    memset(s, 0, count);
>    barrier_data(s);
>  }
>
>  int main(void)
>  {
>    char buff[20];
>    memzero_explicit(buff, sizeof(buff));
>    return 0;
>  }
>
>  $ gcc -O2 test.c
>  $ gdb a.out
>  (gdb) disassemble main
>  Dump of assembler code for function main:
>   0x0000000000400400  <+0>: lea   -0x28(%rsp),%rax
>   0x0000000000400405  <+5>: movq  $0x0,-0x28(%rsp)
>   0x000000000040040e <+14>: movq  $0x0,-0x20(%rsp)
>   0x0000000000400417 <+23>: movl  $0x0,-0x18(%rsp)
>   0x000000000040041f <+31>: xor   %eax,%eax
>   0x0000000000400421 <+33>: retq
>  End of assembler dump.
>
>  $ clang -O2 test.c
>  $ gdb a.out
>  (gdb) disassemble main
>  Dump of assembler code for function main:
>   0x00000000004004f0  <+0>: xorps  %xmm0,%xmm0
>   0x00000000004004f3  <+3>: movaps %xmm0,-0x18(%rsp)
>   0x00000000004004f8  <+8>: movl   $0x0,-0x8(%rsp)
>   0x0000000000400500 <+16>: lea    -0x18(%rsp),%rax
>   0x0000000000400505 <+21>: xor    %eax,%eax
>   0x0000000000400507 <+23>: retq
>  End of assembler dump.
>
>As clang (but also icc) defines __GNUC__, it's sufficient to define this
>in compiler-gcc.h only.
>
>Reference: https://llvm.org/bugs/show_bug.cgi?id=15495
>Reported-by: Stephan Mueller <smueller@chronox.de>
>Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>Cc: Theodore Ts'o <tytso@mit.edu>
>Cc: Stephan Mueller <smueller@chronox.de>
>Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
>Cc: mancha security <mancha1@zoho.com>
>Cc: Mark Charlebois <charlebm@gmail.com>
>Cc: Behan Webster <behanw@converseincode.com>

Using a user space test app: tested clang -O3, clang -O2, gcc -O3, gcc -O2.

Tested-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan
