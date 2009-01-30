From: Pierre Habouzit <madcoder@debian.org>
Subject: [RFC] MPI module
Date: Fri, 30 Jan 2009 01:15:23 +0100
Message-ID: <20090130001523.GA909@artemis.corp>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="NDin8bjvE/0mNLFQ";
	protocol="application/pgp-signature"; micalg=SHA1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pan.madism.org ([88.191.52.104]:45605 "EHLO hermes.madism.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbZA3AWy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Jan 2009 19:22:54 -0500
Received: from madism.org (olympe.madism.org [82.243.245.108])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "artemis.madism.org", Issuer "madism.org" (verified OK))
	by hermes.madism.org (Postfix) with ESMTPS id 513253FDA2
	for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2009 01:15:25 +0100 (CET)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--NDin8bjvE/0mNLFQ
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

First let's talk about my endgame, and then my questions.

My endgame is simple, I'd like to see an in-kernel SSL/TLS
implementation in Linux happen. There are many reasons to want that,
ranging from performance reasons (waking the userland each time you
perform a handshake isn't particularly nice, and it's easy to make
system-wide session caches) to really cool features being enabled:
  - you can send "secure" file descriptors around through Unix Sockets,
    or prepare a "secure" socket, let it be your stdin/stdout pair and
    exec a service knowing nothing about SSL (think inetd-like stuff) ;
  - you can deploy secure services where the actual server knows nothing
    about the certificate that is used ;
  - you can have a system-wide service dealing with peer certificate
    validations and have a real system-wide policy in this regard ;
  - you could even think of some netfilter stuff to enforce security on
    a given socket, even if the service behind the socket knows nothing
    about it (bye bye stunnel)...

Nowadays, the kernel has most of what we need cipher-wise for TLS/SSL.
Only the key-exchange protocols and the very TLS protocol are lacking.
I'm currently addressing the former issue, namely, bringing RSA and
Diffie-Hellman to the kernel.

I'm quite new to the kernel cryptographic layer, hence I'm posting a
really early patch so that I can get some comments about style or
choices I made that are bad for the kernel. This first patch is a
concise implementation of primitives needed to implement RSA and DHM
key-exchange protocols. I've not tested it yet, it's likely to contain
bugs.

Though, I have a few questions.

(1) I need arch-specific headers to propose optimized assembly code for
the MPI multiplications. The API header is <crypto/bignum.h> though
there is no asm-generic/crypto/bignum.h header. Should I create such a
header or is using asm-generic/bignum.h (which is what the patch does
atm) correct ?

(2) The SSL library I based my work upon provides an SSE2 implementation
of the MPI multiplication, though I'm unsure how I should enable it. For
now it's guarded behind a #ifdef __HAVE_SSE2 which doesn't exist.  I
imagine options are either detecting if the compilation target has SSE2,
or some kind of runtime test, but I'm unsure what the kernel ways are in
that regard.

(3) I'm creating a module, but I'm unsure if that should not just be
yes-or-no stuff. I don't know what the policy is in that regard.


I believe that the code is quite readable, though if anything looks
wrong, please tell me :)


PS: wrt my endgame, I'm for now really concentrating on the crypto
    stuff, IOW bringing RSA and Diffie-Hellman in.

    I don't intend to bring x509 and certificate validation _into_ the
    kernel, it makes no sense to me, this can be delegated to userland
    easily.

--=20
=C2=B7O=C2=B7  Pierre Habouzit
=C2=B7=C2=B7O                                                madcoder@debia=
n.org
OOO                                                http://www.madism.org

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0001-crypto-add-multiple-precision-APIs.patch"
Content-Transfer-Encoding: quoted-printable

=46rom: Pierre Habouzit <madcoder@debian.org>
Subject: [PATCH] crypto: add multiple precision APIs

Adds CONFIG_CRYPTO_BIGNUM to provide mpi_* APIs.

This introduces the multiple precision integers, through the `struct mpi`
type. MPI instances are just a bunch of unsigned longs (or limbs), in
little endian order, which is a rather usual representation.

Though, MPI instances have to respect a couple of invariants, the most
importants being:
  * at any time the length (number of least significant limbs) of the MPI
    is known;
  * at any time, all allocated limbs after the most significant limb must
    be set to 0.

Many mpi_* APIs use that fact to compute a valid result (see for example
mpi_sbits or mpi_is_zero).

Signed-off-by: Pierre Habouzit <madcoder@debian.org>
---
 arch/x86/include/asm/bignum.h    |   11 +
 arch/x86/include/asm/bignum_32.h |  127 ++++++
 arch/x86/include/asm/bignum_64.h |   51 +++
 crypto/Kconfig                   |    6 +
 crypto/Makefile                  |    1 +
 crypto/bignum.c                  |  805 ++++++++++++++++++++++++++++++++++=
++++
 include/asm-generic/bignum.h     |   80 ++++
 include/crypto/bignum.h          |  209 ++++++++++
 8 files changed, 1290 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/bignum.h
 create mode 100644 arch/x86/include/asm/bignum_32.h
 create mode 100644 arch/x86/include/asm/bignum_64.h
 create mode 100644 crypto/bignum.c
 create mode 100644 include/asm-generic/bignum.h
 create mode 100644 include/crypto/bignum.h

diff --git a/arch/x86/include/asm/bignum.h b/arch/x86/include/asm/bignum.h
new file mode 100644
index 0000000..e33da47
--- /dev/null
+++ b/arch/x86/include/asm/bignum.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_X86_BIGNUM_H
+#define _ASM_X86_BIGNUM_H
+
+#ifdef CONFIG_X86_32
+# include "bignum_32.h"
+#else
+# include "bignum_64.h"
+#endif
+#include <asm-generic/bignum.h>
+
+#endif
diff --git a/arch/x86/include/asm/bignum_32.h b/arch/x86/include/asm/bignum=
_32.h
new file mode 100644
index 0000000..0923585
--- /dev/null
+++ b/arch/x86/include/asm/bignum_32.h
@@ -0,0 +1,127 @@
+/**
+ *  Multi-precision integer library
+ *
+ *  Based on XySSL:
+ *
+ *    Copyright (C) 2006-2008  Christophe Devine
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#ifndef _ASM_X86_BIGNUM_32_H
+#define _ASM_X86_BIGNUM_32_H
+
+#define MPI_MULADDC_INIT                           \
+	asm("movl   %%ebx, %0      " : "=3Dm" (t));  \
+	asm("movl   %0, %%esi      " :: "m" (s));  \
+	asm("movl   %0, %%edi      " :: "m" (d));  \
+	asm("movl   %0, %%ecx      " :: "m" (c));  \
+	asm("movl   %0, %%ebx      " :: "m" (b))
+
+#define MPI_MULADDC_CORE                           \
+	asm("lodsl                 ");             \
+	asm("mull   %ebx           ");             \
+	asm("addl   %ecx,   %eax   ");             \
+	asm("adcl   $0,     %edx   ");             \
+	asm("addl   (%edi), %eax   ");             \
+	asm("adcl   $0,     %edx   ");             \
+	asm("movl   %edx,   %ecx   ");             \
+	asm("stosl                 ")
+
+#if defined(__HAVE_SSE2)
+
+#define MPI_MULADDC_8                              \
+	asm("movd     %ecx,     %mm1     ");       \
+	asm("movd     %ebx,     %mm0     ");       \
+	asm("movd     (%edi),   %mm3     ");       \
+	asm("paddq    %mm3,     %mm1     ");       \
+	asm("movd     (%esi),   %mm2     ");       \
+	asm("pmuludq  %mm0,     %mm2     ");       \
+	asm("movd     4(%esi),  %mm4     ");       \
+	asm("pmuludq  %mm0,     %mm4     ");       \
+	asm("movd     8(%esi),  %mm6     ");       \
+	asm("pmuludq  %mm0,     %mm6     ");       \
+	asm("movd     12(%esi), %mm7     ");       \
+	asm("pmuludq  %mm0,     %mm7     ");       \
+	asm("paddq    %mm2,     %mm1     ");       \
+	asm("movd     4(%edi),  %mm3     ");       \
+	asm("paddq    %mm4,     %mm3     ");       \
+	asm("movd     8(%edi),  %mm5     ");       \
+	asm("paddq    %mm6,     %mm5     ");       \
+	asm("movd     12(%edi), %mm4     ");       \
+	asm("paddq    %mm4,     %mm7     ");       \
+	asm("movd     %mm1,     (%edi)   ");       \
+	asm("movd     16(%esi), %mm2     ");       \
+	asm("pmuludq  %mm0,     %mm2     ");       \
+	asm("psrlq    $32,      %mm1     ");       \
+	asm("movd     20(%esi), %mm4     ");       \
+	asm("pmuludq  %mm0,     %mm4     ");       \
+	asm("paddq    %mm3,     %mm1     ");       \
+	asm("movd     24(%esi), %mm6     ");       \
+	asm("pmuludq  %mm0,     %mm6     ");       \
+	asm("movd     %mm1,     4(%edi)  ");       \
+	asm("psrlq    $32,      %mm1     ");       \
+	asm("movd     28(%esi), %mm3     ");       \
+	asm("pmuludq  %mm0,     %mm3     ");       \
+	asm("paddq    %mm5,     %mm1     ");       \
+	asm("movd     16(%edi), %mm5     ");       \
+	asm("paddq    %mm5,     %mm2     ");       \
+	asm("movd     %mm1,     8(%edi)  ");       \
+	asm("psrlq    $32,      %mm1     ");       \
+	asm("paddq    %mm7,     %mm1     ");       \
+	asm("movd     20(%edi), %mm5     ");       \
+	asm("paddq    %mm5,     %mm4     ");       \
+	asm("movd     %mm1,     12(%edi) ");       \
+	asm("psrlq    $32,      %mm1     ");       \
+	asm("paddq    %mm2,     %mm1     ");       \
+	asm("movd     24(%edi), %mm5     ");       \
+	asm("paddq    %mm5,     %mm6     ");       \
+	asm("movd     %mm1,     16(%edi) ");       \
+	asm("psrlq    $32,      %mm1     ");       \
+	asm("paddq    %mm4,     %mm1     ");       \
+	asm("movd     28(%edi), %mm5     ");       \
+	asm("paddq    %mm5,     %mm3     ");       \
+	asm("movd     %mm1,     20(%edi) ");       \
+	asm("psrlq    $32,      %mm1     ");       \
+	asm("paddq    %mm6,     %mm1     ");       \
+	asm("movd     %mm1,     24(%edi) ");       \
+	asm("psrlq    $32,      %mm1     ");       \
+	asm("paddq    %mm3,     %mm1     ");       \
+	asm("movd     %mm1,     28(%edi) ");       \
+	asm("addl     $32,      %edi     ");       \
+	asm("addl     $32,      %esi     ");       \
+	asm("psrlq    $32,      %mm1     ");       \
+	asm("movd     %mm1,     %ecx     ")
+
+#define MPI_MULADDC_STOP                           \
+	asm("emms                        ");       \
+	asm("movl   %0, %%ebx      " :: "m" (t));  \
+	asm("movl   %%ecx, %0      " : "=3Dm" (c));  \
+	asm("movl   %%edi, %0      " : "=3Dm" (d));  \
+	asm("movl   %%esi, %0      " : "=3Dm" (s) :: \
+	"eax", "ecx", "edx", "esi", "edi")
+
+#else
+
+#define MPI_MULADDC_STOP                           \
+	asm("movl   %0, %%ebx      " :: "m" (t));  \
+	asm("movl   %%ecx, %0      " : "=3Dm" (c));  \
+	asm("movl   %%edi, %0      " : "=3Dm" (d));  \
+	asm("movl   %%esi, %0      " : "=3Dm" (s) :: \
+	"eax", "ecx", "edx", "esi", "edi")
+
+#endif /* SSE2 */
+
+#endif
diff --git a/arch/x86/include/asm/bignum_64.h b/arch/x86/include/asm/bignum=
_64.h
new file mode 100644
index 0000000..b22598b
--- /dev/null
+++ b/arch/x86/include/asm/bignum_64.h
@@ -0,0 +1,51 @@
+/**
+ *  Multi-precision integer library
+ *
+ *  Based on XySSL:
+ *
+ *    Copyright (C) 2006-2008  Christophe Devine
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#ifndef _ASM_X86_BIGNUM_64_H
+#define _ASM_X86_BIGNUM_64_H
+
+#define MPI_MULADDC_INIT                            \
+	asm("movq   %0, %%rsi      " :: "m" (s));   \
+	asm("movq   %0, %%rdi      " :: "m" (d));   \
+	asm("movq   %0, %%rcx      " :: "m" (c));   \
+	asm("movq   %0, %%rbx      " :: "m" (b));   \
+	asm("xorq   %r8, %r8       ")
+
+#define MPI_MULADDC_CORE                            \
+	asm("movq  (%rsi),%rax     ");              \
+	asm("mulq   %rbx           ");              \
+	asm("addq   $8,   %rsi     ");              \
+	asm("addq   %rcx, %rax     ");              \
+	asm("movq   %r8,  %rcx     ");              \
+	asm("adcq   $0,   %rdx     ");              \
+	asm("nop                   ");              \
+	asm("addq   %rax, (%rdi)   ");              \
+	asm("adcq   %rdx, %rcx     ");              \
+	asm("addq   $8,   %rdi     ")
+
+#define MPI_MULADDC_STOP                            \
+	asm("movq   %%rcx, %0      " : "=3Dm" (c));   \
+	asm("movq   %%rdi, %0      " : "=3Dm" (d));   \
+	asm("movq   %%rsi, %0      " : "=3Dm" (s) ::  \
+	"rax", "rcx", "rdx", "rbx", "rsi", "rdi", "r8")
+
+#endif
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 8dde4fc..12a7d99 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -29,6 +29,12 @@ config CRYPTO_FIPS
 	  certification.  You should say no unless you know what
 	  this is.
=20
+config CRYPTO_BIGNUM
+        tristate "Big Number library"
+        help
+	  This option provides the APIs for multiple precision integer
+	  operations.
+
 config CRYPTO_ALGAPI
 	tristate
 	select CRYPTO_ALGAPI2
diff --git a/crypto/Makefile b/crypto/Makefile
index 46b08bf..270cdea 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_CRYPTO) +=3D crypto.o
 crypto-objs :=3D api.o cipher.o digest.o compress.o
=20
 obj-$(CONFIG_CRYPTO_FIPS) +=3D fips.o
+obj-$(CONFIG_CRYPTO_BIGNUM) +=3D bignum.o
=20
 crypto_algapi-$(CONFIG_PROC_FS) +=3D proc.o
 crypto_algapi-objs :=3D algapi.o scatterwalk.o $(crypto_algapi-y)
diff --git a/crypto/bignum.c b/crypto/bignum.c
new file mode 100644
index 0000000..7e4279c
--- /dev/null
+++ b/crypto/bignum.c
@@ -0,0 +1,805 @@
+/*
+ *  Multi-precision integer library
+ *
+ *  Based on XySSL:
+ *
+ *    Copyright (C) 2006-2008  Christophe Devine
+ *    Copyright (C) 2009       Pierre Habouzit <madcoder@debian.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+/*
+ *  This MPI implementation is based on:
+ *
+ *  http://www.cacr.math.uwaterloo.ca/hac/about/chap14.pdf
+ *  http://www.stillhq.com/extracted/gnupg-api/struct mpi/
+ *  http://math.libtomcrypt.com/files/tommath.pdf
+ */
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <crypto/bignum.h>
+
+#define ciL           ((int)sizeof(unsigned long))    /* chars in limb  */
+#define biL           (ciL << 3)                      /* bits  in limb  */
+#define MPI_CHK(f)    if (unlikely(ret =3D f) !=3D 0) goto cleanup
+#if (BITS_PER_LONG =3D=3D 32)
+#  define __be_long_to_cpu(x)  __be32_to_cpu(x)
+#  define __cpu_to_be_long(x)  __cpu_to_be32(x)
+#else
+#  define __be_long_to_cpu(x)  __be64_to_cpu(x)
+#  define __cpu_to_be_long(x)  __cpu_to_be64(x)
+#endif
+
+#define MPI_FROM_INT(i) \
+	{ .sign =3D (i) < 0,                                   \
+	  .len  =3D (i) !=3D 0,                                  \
+	  .p =3D (unsigned long []){ (i) < 0 ? -i : i },       \
+	}
+static struct mpi const ONE =3D MPI_FROM_INT(1);
+
+static inline void mpi_setlen(struct mpi *X, int len, int do_fix)
+{
+	if (len < X->len)
+		memset(X->p + len, 0, (X->len - len) * ciL);
+	if (do_fix) {
+		while (len > 0 && X->p[len - 1] =3D=3D 0)
+			len--;
+	}
+	X->len =3D len;
+}
+
+static int mpi_set_2pow(struct mpi *X, int pow)
+{
+	if (mpi_grow(X, pow / biL))
+		return -ENOMEM;
+	mpi_zero(X);
+	X->p[pow / biL] =3D 1 << (pow % biL);
+	mpi_setlen(X, pow / biL + 1, 0);
+	return 0;
+}
+
+int mpi_grow(struct mpi *X, int nblimbs)
+{
+	unsigned long *p;
+
+	if (unlikely(nblimbs < 0))
+		return -ENOMEM;
+	if (X->alloc < nblimbs) {
+		p =3D krealloc(X->p, nblimbs * ciL, GFP_KERNEL);
+		if (!p)
+			return -ENOMEM;
+		memset(p + X->alloc, 0, (nblimbs - X->alloc) * ciL);
+		X->alloc =3D nblimbs;
+		X->p =3D p;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpi_grow);
+
+static int mpi_copy(struct mpi *X, const struct mpi *Y)
+{
+	if (X =3D=3D Y)
+		return 0;
+
+	if (mpi_grow(X, Y->len))
+		return -ENOMEM;
+
+	X->sign =3D Y->sign;
+	memcpy(X->p, Y->p, Y->len * ciL);
+	mpi_setlen(X, Y->len, 0);
+	return 0;
+}
+
+int mpi_read_binary(struct mpi *X, const u8 *buf, int buflen)
+{
+	unsigned long u;
+	int i, v0, v1, xl;
+
+	while (buflen > 0 && *buf =3D=3D 0) {
+		buf++;
+		buflen--;
+	}
+
+	xl =3D DIV_ROUND_UP(buflen, ciL);
+	if (mpi_grow(X, xl))
+		return -ENOMEM;
+
+	v0 =3D buflen / ciL;
+	v1 =3D buflen % ciL;
+
+	if (v1) {
+		for (u =3D i =3D 0; i < v1; i++) {
+			u =3D (u << 8) | *buf++;
+		}
+		X->p[v0] =3D u;
+	}
+	for (i =3D v0 - 1; i >=3D 0; i--, buf +=3D ciL) {
+		memcpy(&u, buf, ciL);
+		X->p[i] =3D __be_long_to_cpu(u);
+	}
+	mpi_setlen(X, xl, 0);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpi_read_binary);
+
+u8 *mpi_write_binary(const struct mpi *X, u8 *buf, int buflen)
+{
+	unsigned long u;
+	int i, v0, v1;
+
+	if (buflen > ciL * X->len) {
+		memset(buf, 0, buflen - ciL * X->len);
+		buf   +=3D buflen - ciL * X->len;
+		buflen =3D ciL * X->len;
+		v0     =3D X->len;
+	} else {
+		v0 =3D buflen / ciL;
+		v1 =3D buflen % ciL;
+
+		for (i =3D v1 - 1; i >=3D 0; i--) {
+			*buf++ =3D X->p[v0] >> (i << 3);
+		}
+	}
+	for (i =3D v0 - 1; i >=3D 0; i--, buf +=3D ciL) {
+		u =3D __cpu_to_be_long(X->p[i]);
+		memcpy(buf, &u, ciL);
+	}
+	return buf;
+}
+EXPORT_SYMBOL_GPL(mpi_write_binary);
+
+
+int mpi_ctz(const struct mpi *X)
+{
+	int i;
+
+	for (i =3D 0; i < X->len; i++) {
+		if (X->p[i])
+			return i * biL + __builtin_ctzl(X->p[i]);
+	}
+	return -1;
+}
+EXPORT_SYMBOL_GPL(mpi_ctz);
+
+int mpi_sbits(const struct mpi *X)
+{
+	if (X->len =3D=3D 0)
+		return 0;
+	return X->len * biL + (biL - __builtin_clzl(X->p[X->len - 1]));
+}
+EXPORT_SYMBOL_GPL(mpi_sbits);
+
+int mpi_shift_l(struct mpi *X, int count)
+{
+	int i, v0, v1, bits;
+
+	if (count =3D=3D 0 || mpi_is_zero(X))
+		return 0;
+
+	v0 =3D count / biL;
+	v1 =3D count % biL;
+	bits =3D mpi_sbits(X);
+
+	if (mpi_grow(X, DIV_ROUND_UP(bits + count, BITS_PER_LONG)))
+		return -ENOMEM;
+
+	if (v1 =3D=3D 0) {
+		memmove(X->p + v0, X->p, (X->len - v0) * ciL);
+	} else {
+		unsigned long limb, rest =3D 0;
+
+		for (i =3D X->len - 1; i >=3D 0; i--) {
+			limb =3D X->p[i];
+			X->p[i + v0 + 1] =3D rest | (limb >> (biL - v1));
+			rest             =3D limb << v1;
+		}
+		X->p[v0] =3D rest;
+	}
+	memset(X->p, 0, v0 * ciL);
+	X->len =3D DIV_ROUND_UP(bits + count, BITS_PER_LONG);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpi_shift_l);
+
+void mpi_shift_r(struct mpi *X, int count)
+{
+	int i, v0, v1, bits;
+
+	if (count =3D=3D 0)
+		return;
+
+	bits =3D mpi_sbits(X);
+	if (count >=3D bits) {
+		mpi_zero(X);
+		return;
+	}
+
+	v0 =3D count / biL;
+	v1 =3D count % biL;
+
+	if (v1 =3D=3D 0) {
+		memmove(X->p, X->p + v0, (X->len - v0) * ciL);
+	} else {
+		unsigned long limb, rest =3D X->p[v0] >> v1;
+
+		for (i =3D 0; i < X->len - v0 - 1; i++) {
+			limb    =3D X->p[i + v0 + 1];
+			X->p[i] =3D rest | (limb << (biL - v1));
+			rest    =3D limb >> v1;
+		}
+	}
+	mpi_setlen(X, DIV_ROUND_UP(bits - count, BITS_PER_LONG), 0);
+}
+EXPORT_SYMBOL_GPL(mpi_shift_r);
+
+static int mpi_cmp_abs(const struct mpi *X, const struct mpi *Y)
+{
+	int xl =3D X->len;
+
+	if (xl > Y->len)
+		return 1;
+	if (Y->len > xl)
+		return -1;
+
+	while (xl-- > 0) {
+		if (X->p[xl] > Y->p[xl])
+			return 1;
+		if (X->p[xl] < Y->p[xl])
+			return -1;
+	}
+
+	return 0;
+}
+
+int mpi_cmp(const struct mpi *X, const struct mpi *Y)
+{
+	int xl =3D X->len;
+	int sign =3D 1 - 2 * X->sign;
+
+	if (X->sign !=3D Y->sign)
+		return sign;
+
+	if (xl > Y->len)
+		return sign;
+	if (Y->len > xl)
+		return -sign;
+
+	while (xl-- > 0) {
+		if (X->p[xl] > Y->p[xl])
+			return sign;
+		if (X->p[xl] < Y->p[xl])
+			return -sign;
+	}
+	return 0;
+}
+int mpi_cmp_int(const struct mpi *X, int y)
+{
+	struct mpi _Y =3D MPI_FROM_INT(y);
+	return mpi_cmp(X, &_Y);
+}
+EXPORT_SYMBOL_GPL(mpi_cmp);
+EXPORT_SYMBOL_GPL(mpi_cmp_int);
+
+/*
+ * Unsigned addition: X =3D |A| + |B|  (HAC 14.7)
+ */
+static int mpi_add_abs(struct mpi *X, const struct mpi *A, const struct mp=
i *B)
+{
+	unsigned long *x, *a, *b, c;
+	int i;
+
+	if (B->len > A->len)
+		swap(A, B);
+
+	if (mpi_grow(X, A->len + 1))
+		return -ENOMEM;
+
+	a =3D A->p; b =3D B->p; x =3D X->p;
+
+	for (c =3D i =3D 0; i < B->len; i++, x++, a++, b++) {
+		*x  =3D *a + c;
+		c   =3D (*x < c) + (*x + *b < *b);
+		*x +=3D *b;
+	}
+	for (; c && i < A->len; i++, x++, a++) {
+		*x  =3D *a + c;
+		c   =3D (*x < c);
+	}
+	if (X !=3D A)
+		memcpy(x, a, (A->len - i) * ciL);
+	if (c)
+		*x  =3D c;
+	mpi_setlen(X, A->len + c, 0);
+	return 0;
+}
+
+/*
+ * Unsigned substraction: X =3D |A| - |B|  (HAC 14.9)
+ * assumes |A| > |B|
+ */
+static int mpi_sub_abs(struct mpi *X, const struct mpi *A, const struct mp=
i *B)
+{
+	unsigned long *x, *a, *b, c;
+	int i;
+
+	if (mpi_grow(X, A->len))
+		return -ENOMEM;
+
+	a =3D A->p; b =3D B->p; x =3D X->p;
+
+	for (c =3D i =3D 0; i < B->len; i++, x++, a++, b++) {
+		*x  =3D *a - c;
+		c   =3D (*a < c) + (*x < *b);
+		*x  =3D *x - *b;
+	}
+	for (; c && i < A->len; i++, x++, a++) {
+		*x  =3D *a - c;
+		c   =3D (*a < c);
+	}
+	if (X !=3D A)
+		memcpy(x, a, (A->len - i) * ciL);
+	mpi_setlen(X, A->len, 1);
+	return 0;
+}
+
+static int mpi_add_or_sub(struct mpi *X, const struct mpi *A,
+			  const struct mpi *B, int is_add)
+{
+	int ret;
+
+	if ((A->sign =3D=3D B->sign) =3D=3D is_add) {
+		ret =3D mpi_add_abs(X, A, B);
+		X->sign =3D A->sign;
+	} else {
+		ret =3D mpi_cmp_abs(A, B);
+		if (ret > 0) {
+			ret =3D mpi_sub_abs(X, A, B);
+			X->sign =3D A->sign;
+		} else if (ret < 0) {
+			ret =3D mpi_sub_abs(X, B, A);
+			X->sign =3D A->sign ^ 1;
+		} else {
+			mpi_zero(X);
+		}
+	}
+
+	return ret;
+}
+
+int mpi_add(struct mpi *X, const struct mpi *A, const struct mpi *B)
+{
+	return mpi_add_or_sub(X, A, B, 1);
+}
+int mpi_add_int(struct mpi *X, const struct mpi *A, int b)
+{
+	struct mpi _B =3D MPI_FROM_INT(b);
+	return mpi_add(X, A, &_B);
+}
+int mpi_sub(struct mpi *X, const struct mpi *A, const struct mpi *B)
+{
+	return mpi_add_or_sub(X, A, B, 0);
+}
+int mpi_sub_int(struct mpi *X, const struct mpi *A, int b)
+{
+	struct mpi _B =3D MPI_FROM_INT(b);
+	return mpi_sub(X, A, &_B);
+}
+EXPORT_SYMBOL_GPL(mpi_add);
+EXPORT_SYMBOL_GPL(mpi_add_int);
+EXPORT_SYMBOL_GPL(mpi_sub);
+EXPORT_SYMBOL_GPL(mpi_sub_int);
+
+/*
+ * A /=3D 2; while (A is even) A /=3D 2
+ * Assumes A is non zero and positive
+ */
+static void mpi_gcd_hlp(struct mpi *A)
+{
+	if (A->len =3D=3D 1 && A->p[0] =3D=3D 1) {
+		mpi_zero(A);
+	} else {
+		A->p[0] &=3D ~1UL;
+		mpi_shift_r(A, mpi_ctz(A));
+	}
+}
+int mpi_gcd(struct mpi *G, const struct mpi *A, const struct mpi *B)
+{
+	struct mpi X =3D MPI_INIT, Y =3D MPI_INIT;
+	int ret, lzx, lzy;
+
+	if (mpi_is_zero(A) || mpi_is_zero(B))
+		return -EINVAL;
+
+	lzx =3D mpi_ctz(A);
+	lzy =3D mpi_ctz(B);
+	MPI_CHK(mpi_copy(&X, A));
+	MPI_CHK(mpi_copy(&Y, B));
+	X.sign =3D Y.sign =3D 0;
+	mpi_shift_r(&X, lzx);
+	mpi_shift_r(&Y, lzy);
+
+	while (!mpi_is_zero(&X)) {
+		ret =3D mpi_cmp_abs(&X, &Y);
+		if (ret > 0) {
+			mpi_sub_abs(&X, &X, &Y);
+			mpi_gcd_hlp(&X);
+		} else if (ret < 0) {
+			mpi_sub_abs(&Y, &Y, &X);
+			mpi_gcd_hlp(&Y);
+		} else
+			break;
+	}
+
+	mpi_shift_l(&Y, lzx < lzy ? lzx : lzy);
+	swap(*G, Y);
+
+cleanup:
+	mpi_destroy(&Y);
+	mpi_destroy(&X);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mpi_gcd);
+
+static void mpi_mul_hlp(int i, unsigned long *s, unsigned long *d, unsigne=
d long b)
+{
+	unsigned long c =3D 0, t =3D 0;
+
+	if (i & 1) {
+		MPI_MULADDC_INIT; MPI_MULADDC_CORE; MPI_MULADDC_STOP;
+	}
+	if (i & 2) {
+		MPI_MULADDC_INIT; MPI_MULADDC_CORE2; MPI_MULADDC_STOP;
+	}
+	if (i & 4) {
+		MPI_MULADDC_INIT; MPI_MULADDC_CORE4; MPI_MULADDC_STOP;
+	}
+	for (i /=3D 8; i >=3D 0; i--) {
+		MPI_MULADDC_INIT; MPI_MULADDC_CORE8; MPI_MULADDC_STOP;
+	}
+
+	/* may be used by asm code and gcc isn't too clever about it */
+	t =3D t;
+	do {
+		*d +=3D c; c =3D (*d < c); d++;
+	} while (c);
+}
+
+int mpi_mul(struct mpi *X, const struct mpi *A, const struct mpi *B)
+{
+	struct mpi T =3D MPI_INIT;
+	int al, bl, i;
+
+	if (A->len < B->len)
+		swap(A, B);
+
+	al =3D A->len;
+	bl =3D B->len;
+	if (mpi_grow(X, al + bl))
+		return -ENOMEM;
+
+	if (X =3D=3D A) {
+		T =3D *A;
+		A =3D &T;
+		mpi_init(X);
+	} else if (X =3D=3D B) {
+		T =3D *B;
+		B =3D &T;
+		mpi_init(X);
+	} else {
+		mpi_zero(X);
+	}
+
+	for (i =3D bl - 1; i >=3D 0; i--)
+		mpi_mul_hlp(al, A->p, X->p + i, B->p[i]);
+
+	X->sign =3D A->sign ^ B->sign;
+	mpi_setlen(X, al + bl, 1);
+	kfree(T.p);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mpi_mul);
+
+/*
+ * Baseline multiplication: X =3D A * b
+ */
+static int mpi_mul_ulong(struct mpi *X, struct mpi *A, unsigned long b)
+{
+	unsigned long p[1] =3D { b };
+	struct mpi B =3D { .sign =3D 0, .len =3D 1, .p =3D p };
+
+	return mpi_mul(X, A, &B);
+}
+
+/*
+ * Division by struct mpi: A =3D Q * B + R  (HAC 14.20)
+ */
+int mpi_div(struct mpi *Q, struct mpi *R, const struct mpi *A, const struc=
t mpi *B)
+{
+	struct mpi X  =3D MPI_INIT, Y  =3D MPI_INIT, Z =3D MPI_INIT;
+	struct mpi T1 =3D MPI_INIT, T2 =3D MPI_INIT;
+	int ret =3D -ENOMEM, i, xl, yl, lambda;
+
+	if (mpi_is_zero(B))
+		return -EINVAL;
+
+	if (mpi_cmp_abs(A, B) < 0) {
+		if (Q)
+			mpi_zero(Q);
+		return R ? mpi_copy(R, A) : 0;
+	}
+
+	MPI_CHK(mpi_copy(&X, A));
+	MPI_CHK(mpi_copy(&Y, B));
+	X.sign =3D Y.sign =3D 0;
+
+	MPI_CHK(mpi_grow(&Z, A->len - B->len + 2));
+	MPI_CHK(mpi_grow(&T1, 2));
+	MPI_CHK(mpi_grow(&T2, 3));
+
+	/* HAC 14.23: normalization */
+	lambda =3D __builtin_clzl(Y.p[Y.len - 1]);
+	if (lambda) {
+		MPI_CHK(mpi_shift_l(&X, lambda));
+		MPI_CHK(mpi_shift_l(&Y, lambda));
+	}
+
+	xl =3D X.len;
+	yl =3D Y.len;
+	mpi_shift_l(&Y, biL * (xl - yl));
+
+	while (mpi_cmp(&X, &Y) >=3D 0) {
+		Z.p[xl - yl]++;
+		mpi_sub(&X, &X, &Y);
+	}
+	mpi_shift_r(&Y, biL * (xl - yl));
+
+	for (i =3D xl - 1; i >=3D yl; i--) {
+		if (X.p[i] >=3D Y.p[yl - 1])
+			Z.p[i - yl] =3D ULONG_MAX;
+		else {
+#if (BITS_PER_LONG =3D=3D 32)
+			unsigned long long r;
+
+			r  =3D (unsigned long long)X.p[i] << biL;
+			r |=3D (unsigned long long)X.p[i - 1];
+			Z.p[i - yl] =3D r / Y.p[yl - 1];
+#else
+			/*
+			 * __udiv_qrnnd_c, from gmp/longlong.h
+			 */
+			unsigned long q0, q1, r0, r1;
+			unsigned long d0, d1, d, m;
+
+			d  =3D Y.p[yl];
+			d0 =3D (d << 32) >> 32;
+			d1 =3D (d >> 32);
+
+			q1 =3D X.p[i] / d1;
+			r1 =3D X.p[i] - d1 * q1;
+			r1 <<=3D 32;
+			r1 |=3D (X.p[i - 1] >> 32);
+
+			m =3D q1 * d0;
+			if (r1 < m) {
+				q1--, r1 +=3D d;
+				while (r1 >=3D d && r1 < m)
+					q1--, r1 +=3D d;
+			}
+			r1 -=3D m;
+
+			q0 =3D r1 / d1;
+			r0 =3D r1 - d1 * q0;
+			r0 <<=3D 32;
+			r0 |=3D (X.p[i - 1] << 32) >> 32;
+
+			m =3D q0 * d0;
+			if (r0 < m) {
+				q0--, r0 +=3D d;
+				while (r0 >=3D d && r0 < m)
+					q0--, r0 +=3D d;
+			}
+			r0 -=3D m;
+
+			Z.p[i - yl] =3D (q1 << 32) | q0;
+#endif
+		}
+
+		Z.p[i - yl]++;
+		do {
+			Z.p[i - yl]--;
+
+			mpi_zero(&T1);
+			T1.p[0] =3D (yl <=3D 1) ? 0 : Y.p[yl - 2];
+			T1.p[1] =3D Y.p[yl - 1];
+			mpi_setlen(&T1, 2, 1);
+			MPI_CHK(mpi_mul_ulong(&T1, &T1, Z.p[i - yl]));
+
+			mpi_zero(&T2);
+			T2.p[0] =3D (i < 2) ? 0 : X.p[i - 2];
+			T2.p[1] =3D (i < 1) ? 0 : X.p[i - 1];
+			T2.p[2] =3D X.p[i];
+			mpi_setlen(&T2, 3, 1);
+		} while (mpi_cmp(&T1, &T2) > 0);
+
+		MPI_CHK(mpi_mul_ulong(&T1, &Y, Z.p[i - yl]));
+		MPI_CHK(mpi_shift_l(&T1,  biL * (i - yl)));
+		MPI_CHK(mpi_sub(&X, &X, &T1));
+
+		if (X.sign) {
+			MPI_CHK(mpi_copy(&T1, &Y));
+			MPI_CHK(mpi_shift_l(&T1, biL * (i - yl)));
+			MPI_CHK(mpi_add(&X, &X, &T1));
+			Z.p[i - yl]--;
+		}
+	}
+
+	if (Q) {
+		mpi_setlen(&Z, Z.alloc, 1);
+		swap(*Q, Z);
+		Q->sign =3D A->sign ^ B->sign;
+	}
+
+	if (R) {
+		mpi_shift_r(&X, lambda);
+		swap(*R, X);
+		R->sign =3D mpi_is_zero(R) ? 0 : A->sign;
+	}
+	ret =3D 0;
+
+cleanup:
+	kfree(X.p);
+	kfree(Y.p);
+	kfree(Z.p);
+	kfree(T1.p);
+	kfree(T2.p);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mpi_div);
+
+/*
+ * Modulo: R =3D A mod B
+ */
+int mpi_mod(struct mpi *R, const struct mpi *A, const struct mpi *B)
+{
+	int ret =3D mpi_div(NULL, R, A, B);
+
+	while (ret =3D=3D 0 && R->sign)
+		ret =3D mpi_add(R, R, B);
+
+	while (ret =3D=3D 0 && mpi_cmp(R, B) >=3D 0)
+		ret =3D mpi_sub(R, R, B);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mpi_mod);
+
+/*
+ * Fast Montgomery initialization (thanks to Tom St Denis)
+ */
+static unsigned long mpi_montg_init(const struct mpi *N)
+{
+	unsigned long x, m0 =3D N->p[0];
+
+	x  =3D m0;
+	x +=3D ((m0 + 2) & 4) << 1;
+	x *=3D (2 - (m0 * x));
+	x *=3D (2 - (m0 * x));
+	x *=3D (2 - (m0 * x));
+#if (BITS_PER_LONG =3D=3D 64)
+	x *=3D (2 - (m0 * x));
+#endif
+	return ~x + 1;
+}
+
+/*
+ * Montgomery multiplication: A =3D A * B * R^-1 mod N  (HAC 14.36)
+ * T is a buffer that shall be N->len * 2 limbs big at least.
+ */
+static void mpi_montmul(struct mpi *A, const struct mpi *B, const struct m=
pi *N,
+			unsigned long mm, struct mpi *T)
+{
+	int i, n, m;
+	unsigned long u0, u1, *d;
+
+	mpi_zero(T);
+
+	d =3D T->p;
+	n =3D N->len;
+	m =3D B->len < n ? B->len : n;
+
+	for (i =3D 0; i < n; i++) {
+		/*
+		 * T =3D (T + u0*B + u1*N) / 2^biL
+		 */
+		u0 =3D A->p[i];
+		u1 =3D (d[0] + u0 * B->p[0]) * mm;
+
+		mpi_mul_hlp(m, B->p, d, u0);
+		mpi_mul_hlp(n, N->p, d, u1);
+
+		*d++ =3D u0; d[n + 1] =3D 0;
+	}
+
+	memcpy(A->p, d, (n + 1) * ciL);
+	mpi_setlen(A, n + 1, 1);
+	mpi_setlen(T, T->alloc, 1);
+	if (mpi_cmp_abs(A, N) >=3D 0)
+		mpi_sub_abs(A, A, N);
+	else {
+		/* prevent timing attacks */
+		mpi_sub_abs(T, N, A);
+	}
+}
+
+/*
+ * Montgomery exponentiation: A =3D X^E mod N  (HAC 14.94)
+ */
+int mpi_exp_mod(struct mpi *A, const struct mpi *X, const struct mpi *E,
+		const struct mpi *N, struct mpi *_RR)
+{
+	struct mpi RR =3D MPI_INIT, _X =3D MPI_INIT, T =3D MPI_INIT;
+	unsigned long mm;
+	int ret, i;
+
+	MPI_CHK(mpi_grow(&T, N->len * 2));
+	mm =3D mpi_montg_init(N);
+
+	/* If 1st call, pre-compute R^2 mod N */
+	if (!_RR || !_RR->p) {
+		mpi_set_2pow(&RR, N->len * 2 * biL);
+		MPI_CHK(mpi_mod(&RR, &RR, N));
+		if (_RR)
+			*_RR =3D RR;
+	} else
+		RR =3D *_RR;
+
+	/* _X =3D X * R^2 * R^-1 mod N =3D X * R mod N */
+	MPI_CHK(mpi_mod(&_X, X, N));
+	mpi_montmul(&_X, &RR, N, mm, &T);
+
+	/* A =3D R^2 * R^-1 mod N =3D R mod N */
+	MPI_CHK(mpi_copy(A, &RR));
+	mpi_montmul(A, &ONE, N, mm, &T);
+
+	for (i =3D mpi_sbits(E) - 1; i >=3D 0; i--) {
+		mpi_montmul(A, A, N, mm, &T);
+		if (E->p[i / biL] & (1 << (i % biL)))
+			mpi_montmul(A, &_X, N, mm, &T);
+	}
+
+cleanup:
+	if (!_RR)
+		kfree(RR.p);
+	kfree(_X.p);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mpi_exp_mod);
+
+static int __init crypto_bignum_init(void)
+{
+	return 0;
+}
+
+static void __exit crypto_bignum_exit(void)
+{
+}
+
+module_init(crypto_bignum_init);
+module_exit(crypto_bignum_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Multiple Precision Integers API");
+MODULE_AUTHOR("Pierre Habouzit <madcoder@debian.org>");
diff --git a/include/asm-generic/bignum.h b/include/asm-generic/bignum.h
new file mode 100644
index 0000000..91f003e
--- /dev/null
+++ b/include/asm-generic/bignum.h
@@ -0,0 +1,80 @@
+/*
+ *  Multi-precision integer library
+ *
+ *  Based on XySSL:
+ *
+ *    Copyright (C) 2006-2008  Christophe Devine
+ *    Copyright (C) 2009       Pierre Habouzit <madcoder@debian.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#ifndef _ASM_GENERIC_BIGNUM
+#define _ASM_GENERIC_BIGNUM
+
+#include <asm/types.h>
+
+#ifndef MPI_MULADDC_CORE
+#if (BITS_PER_LONG =3D=3D 32)
+
+#define MPI_MULADDC_INIT                    \
+	unsigned long long r;               \
+	unsigned long r0, r1
+
+#define MPI_MULADDC_CORE                    \
+	r   =3D *(s++) * (t_dbl) b;           \
+	r0  =3D r;                            \
+	r1  =3D r >> biL;                     \
+	r0 +=3D c;  r1 +=3D (r0 <  c);          \
+	r0 +=3D *d; r1 +=3D (r0 < *d);          \
+	c =3D r1; *(d++) =3D r0;
+
+#else
+
+#define MPI_MULADDC_INIT                    \
+	unsigned long s0, s1, b0, b1;       \
+	unsigned long r0, r1, rx, ry;       \
+	b0 =3D (b << 32) >> 32;               \
+	b1 =3D (b >> 32);
+
+#define MPI_MULADDC_CORE                    \
+	s0 =3D (*s << 32) >> 32;              \
+	s1 =3D (*s >> 32); s++;               \
+	rx =3D s0 * b1; r0 =3D s0 * b0;         \
+	ry =3D s1 * b0; r1 =3D s1 * b1;         \
+	r1 +=3D (rx >> 32);                   \
+	r1 +=3D (ry >> 32);                   \
+	rx <<=3D 32; ry <<=3D 32;               \
+	r0 +=3D rx; r1 +=3D (r0 < rx);          \
+	r0 +=3D ry; r1 +=3D (r0 < ry);          \
+	r0 +=3D  c; r1 +=3D (r0 <  c);          \
+	r0 +=3D *d; r1 +=3D (r0 < *d);          \
+	c =3D r1; *(d++) =3D r0;
+
+#endif
+#define MPI_MULADDC_STOP    do { } while (0)
+#endif
+
+#ifndef MPI_MULADDC_CORE2
+#define MPI_MULADDC_CORE2 do { MPI_MULADDC_CORE; MPI_MULADDC_CORE; } while=
 (0)
+#endif
+#ifndef MPI_MULADDC_CORE4
+#define MPI_MULADDC_CORE4 do { MPI_MULADDC_CORE2; MPI_MULADDC_CORE2; } whi=
le (0)
+#endif
+#ifndef MPI_MULADDC_CORE8
+#define MPI_MULADDC_CORE8 do { MPI_MULADDC_CORE4; MPI_MULADDC_CORE4; } whi=
le (0)
+#endif
+
+#endif
diff --git a/include/crypto/bignum.h b/include/crypto/bignum.h
new file mode 100644
index 0000000..dc5f3bd
--- /dev/null
+++ b/include/crypto/bignum.h
@@ -0,0 +1,209 @@
+/*
+ *  Multi-precision integer library
+ *
+ *  Based on XySSL:
+ *
+ *    Copyright (C) 2006-2008  Christophe Devine
+ *    Copyright (C) 2009       Pierre Habouzit <madcoder@debian.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#ifndef _LINUX_BIGNUM_H
+#define _LINUX_BIGNUM_H
+
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <asm/bignum.h>
+
+/**
+ * \brief          MPI structure
+ *
+ * invariants:
+ *  - alloc is the number of allocated limbs
+ *  - len is the number of non zero limbs (p[len - 1] is never 0)
+ *  - p[len .. alloc[ must always be set to 0
+ *  - "0" is positive.
+ *  - sign is set to 1 for negative values.
+ */
+struct mpi {
+	unsigned sign  :  1; /*!< integer sign         */
+	unsigned alloc : 31; /*!< allocated limbs      */
+	unsigned len;        /*!< number of used limbs */
+	unsigned long *p;    /*!< pointer to limbs     */
+};
+
+#define MPI_INIT  { .p =3D NULL }
+
+static inline void mpi_init(struct mpi *X) {
+	memset(X, 0, sizeof(*X));
+}
+
+static inline void mpi_zero(struct mpi *X) {
+	memset(X->p, 0, X->len * sizeof(*X->p));
+	X->sign =3D 0;
+	X->len  =3D 0;
+}
+
+static inline void mpi_destroy(struct mpi *X) {
+	kfree(X->p);
+}
+
+static inline int mpi_is_zero(const struct mpi *X) {
+	return X->len =3D=3D 0;
+}
+
+/**
+ * \brief          Enlarge to the specified number of limbs
+ *
+ * \return         0 if successful,
+ *                 -ENOMEM if memory allocation failed
+ */
+int mpi_grow(struct mpi *X, int nblimbs);
+
+/**
+ * \brief          Import X from unsigned binary data, big endian
+ *
+ * \param X        destination struct mpi
+ * \param buf      input buffer
+ * \param buflen   input buffer size
+ *
+ * \return         0 if successful,
+ *                 -ENOMEM if memory allocation failed
+ */
+int mpi_read_binary(struct mpi *X, const u8 *buf, int buflen);
+
+/**
+ * \brief          Export X into unsigned binary data, big endian
+ *
+ * If %buflen is too short, the %X is truncated. If %buflen is larger than=
 the
+ * number of octets required to write %X, then the buffer is left-padded w=
ith
+ * zeroes.
+ *
+ * \param X        source struct mpi
+ * \param buf      output buffer
+ * \param buflen   number of octets of %X to write
+ *
+ * \return         a pointer to the last written byte in buf.
+ */
+u8 *mpi_write_binary(const struct mpi *X, u8 *buf, int buflen);
+
+
+/**
+ * \brief          Return the number of traling zeroes
+ *
+ * \return         -1 if X is zero
+ */
+int mpi_ctz(const struct mpi *X);
+
+/**
+ * \brief          Return the number of significant bits
+ */
+int mpi_sbits(const struct mpi *X);
+
+/**
+ * \brief          Left-shift: X <<=3D count
+ *
+ * \return         0 if successful,
+ *                 -ENOMEM if memory allocation failed
+ */
+int mpi_shift_l(struct mpi *X, int count);
+
+/**
+ * \brief          Right-shift: X >>=3D count
+ */
+void mpi_shift_r(struct mpi *X, int count);
+
+/**
+ * \brief          Compare signed values
+ *
+ * \return         1 if X is greater than Y,
+ *                -1 if X is lesser  than Y or
+ *                 0 if X is equal to Y
+ */
+int mpi_cmp(const struct mpi *X, const struct mpi *Y);
+int mpi_cmp_int(const struct mpi *X, int i);
+
+/**
+ * \brief          Signed addition: X =3D A + B
+ *
+ * \return         0 if successful,
+ *                 -ENOMEM if memory allocation failed
+ */
+int mpi_add(struct mpi *X, const struct mpi *A, const struct mpi *B);
+int mpi_add_int(struct mpi *X, const struct mpi *A, int b);
+
+/**
+ * \brief          Signed substraction: X =3D A - B
+ *
+ * \return         0 if successful,
+ *                 -ENOMEM if memory allocation failed
+ */
+int mpi_sub(struct mpi *X, const struct mpi *A, const struct mpi *B);
+int mpi_sub_int(struct mpi *X, const struct mpi *A, int b);
+
+/**
+ * \brief          Greatest common divisor: G =3D gcd(A, B)
+ *
+ * \return         0 if successful,
+ *                 -ENOMEM if memory allocation failed
+ */
+int mpi_gcd(struct mpi *G, const struct mpi *A, const struct mpi *B);
+
+/**
+ * \brief          Baseline multiplication: X =3D A * B
+ *
+ * \return         0 if successful,
+ *                 -ENOMEM if memory allocation failed
+ */
+int mpi_mul(struct mpi *X, const struct mpi *A, const struct mpi *B);
+
+/**
+ * \brief          Division by struct mpi: A =3D Q * B + R
+ *
+ * \return         0 if successful,
+ *                 -ENOMEM if memory allocation failed,
+ *                 -EINVAL if B =3D=3D 0
+ *
+ * \note           Either Q or R can be NULL.
+ */
+int mpi_div(struct mpi *Q, struct mpi *R,
+            const struct mpi *A, const struct mpi *B);
+
+/**
+ * \brief          Modulo: R =3D A mod B
+ *
+ * \return         0 if successful,
+ *                 -ENOMEM if memory allocation failed,
+ *                 -EINVAL if B =3D=3D 0
+ */
+int mpi_mod(struct mpi *R, const struct mpi *A, const struct mpi *B);
+
+/**
+ * \brief          Sliding-window exponentiation: X =3D A^E mod N
+ *
+ * \return         0 if successful,
+ *                 -ENOMEM if memory allocation failed,
+ *                 -EINVAL if N is negative or even
+ *
+ * \note           _RR is used to avoid re-computing R*R mod N across
+ *                 multiple calls, which speeds up things a bit. It can
+ *                 be set to NULL if the extra performance is unneeded.
+ */
+int mpi_exp_mod(struct mpi *X, const struct mpi *A,
+                const struct mpi *E, const struct mpi *N, struct mpi *_RR);
+
+#endif /* bignum.h */
--=20
1.6.1.399.g0d272


--4Ckj6UjgE2iN1+kY--

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmCRpoACgkQvGr7W6Hudhx01wCeLW2hCjsBovlFqvKTTlfNhGJt
vPQAnAuIcC5J8B7dIMMJczfflR3URbtg
=tIp9
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
