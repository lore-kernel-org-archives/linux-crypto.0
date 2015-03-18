From: mancha <mancha1@zoho.com>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Wed, 18 Mar 2015 17:14:02 +0000
Message-ID: <20150318171402.GB24195@zoho.com>
References: <20150318095345.GA12923@zoho.com>
 <550972A7.9030100@iogearbox.net>
 <1426691374.2212055.242060697.4DDF89CA@webmail.messagingengine.com>
 <4937031.1sk5yglzr8@tauon>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zS7rBR6csb6tI2e1"
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Daniel Borkmann <daniel@iogearbox.net>, tytso@mit.edu,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, dborkman@redhat.com,
	cesarb@cesarb.eti.br
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sender1.zohomail.com ([74.201.84.156]:37631 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933160AbbCRRSR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 13:18:17 -0400
Content-Disposition: inline
In-Reply-To: <4937031.1sk5yglzr8@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--zS7rBR6csb6tI2e1
Content-Type: multipart/mixed; boundary="0vzXIDBeUiKkjNJl"
Content-Disposition: inline


--0vzXIDBeUiKkjNJl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 18, 2015 at 05:02:01PM +0100, Stephan Mueller wrote:
> Am Mittwoch, 18. M=C3=A4rz 2015, 16:09:34 schrieb Hannes Frederic Sowa:
>=20
> Hi Hannes,
>=20
> >On Wed, Mar 18, 2015, at 13:42, Daniel Borkmann wrote:
> >> On 03/18/2015 01:20 PM, Stephan Mueller wrote:
> >> > Am Mittwoch, 18. M=C3=A4rz 2015, 13:19:07 schrieb Hannes Frederic So=
wa:
> >> >>>> My proposal would be to add a
> >> >>>>=20
> >> >>>> #define OPTIMIZER_HIDE_MEM(ptr, len) __asm__ __volatile__ ("" :
> >> >>>> :
> >> >>>> "m"(
> >> >>>> ({ struct { u8 b[len]; } *p =3D (void *)ptr ; *p; }) )
> >> >>>>=20
> >> >>>> and use this in the code function.
> >> >>>>=20
> >> >>>> This is documented in gcc manual 6.43.2.5.
> >> >>>=20
> >> >>> That one adds the zeroization instructuctions. But now there are
> >> >>> much
> >> >>> more than with the barrier.
> >> >>>=20
> >> >>>    400469:       48 c7 04 24 00 00 00    movq   $0x0,(%rsp)
> >> >>>    400470:       00
> >> >>>    400471:       48 c7 44 24 08 00 00    movq   $0x0,0x8(%rsp)
> >> >>>    400478:       00 00
> >> >>>    40047a:       c7 44 24 10 00 00 00    movl   $0x0,0x10(%rsp)
> >> >>>    400481:       00
> >> >>>    400482:       48 c7 44 24 20 00 00    movq   $0x0,0x20(%rsp)
> >> >>>    400489:       00 00
> >> >>>    40048b:       48 c7 44 24 28 00 00    movq   $0x0,0x28(%rsp)
> >> >>>    400492:       00 00
> >> >>>    400494:       c7 44 24 30 00 00 00    movl   $0x0,0x30(%rsp)
> >> >>>    40049b:       00
> >> >>>=20
> >> >>> Any ideas?
> >> >>=20
> >> >> Hmm, correct definition of u8?
> >> >=20
> >> > I use unsigned char
> >> >=20
> >> >> Which version of gcc do you use? I can't see any difference if I
> >> >> compile your example at -O2.
> >> >=20
> >> > gcc-Version 4.9.2 20150212 (Red Hat 4.9.2-6) (GCC)
> >
> >Well, was an error on my side, I see the same behavior.
> >
> >> I can see the same with the gcc version I previously posted. So
> >> it clears the 20 bytes from your example (movq, movq, movl) at
> >> two locations, presumably buf[] and b[].
> >
> >Yes, it looks like that. The reservation on the stack changes, too.
> >
> >Seems like just using barrier() is the best and easiest option.
>=20
> Would you prepare a patch for that?
> >
> >Thanks,
> >Hannes
>=20
>=20
> Ciao
> Stephan

Hi.

Patch 0001 fixes the dead store issue in memzero_explicit().

However, if the idea is to use barrier() instead of OPTIMIZER_HIDE_VAR()
in crypto_memneq() as well, then patch 0002 is the one to use. Please
review and keep in mind my analysis was limited to memzero_explicit().

Cesar, were there reasons you didn't use the gcc version of barrier()
for crypto_memneq()?

Please let me know if I can be of any further assistance.

--mancha

--0vzXIDBeUiKkjNJl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-memzero_explicit.patch"
Content-Transfer-Encoding: quoted-printable

=46rom cd9e882cd1d684f50c52471d83f9ecf55427c360 Mon Sep 17 00:00:00 2001
=46rom: mancha security <mancha1@zoho.com>
Date: Wed, 18 Mar 2015 16:14:34 +0000
Subject: [PATCH] lib/string.c: use barrier() to protect memzero_explicit()

OPTIMIZER_HIDE_VAR(), as defined when using gcc, is insufficient
to ensure protection from dead store optimization.
---
 lib/string.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/string.c b/lib/string.c
index ce81aae..a579201 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -607,7 +607,7 @@ EXPORT_SYMBOL(memset);
 void memzero_explicit(void *s, size_t count)
 {
 	memset(s, 0, count);
-	OPTIMIZER_HIDE_VAR(s);
+	barrier();
 }
 EXPORT_SYMBOL(memzero_explicit);
=20
--=20
2.1.4


--0vzXIDBeUiKkjNJl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-OPTIMIZER_HIDE_VAR_purge.patch"
Content-Transfer-Encoding: quoted-printable

=46rom bca436d73ee5388be26488e3d2decdad1c6ba322 Mon Sep 17 00:00:00 2001
=46rom: mancha security <mancha1@zoho.com>
Date: Wed, 18 Mar 2015 16:26:11 +0000
Subject: [PATCH] crypto: cyrpto_memneq and memzero_explicit

OPTIMIZER_HIDE_VAR(), as defined for gcc, is insufficient to protect
against certain compiler optimizations. Use barrier() instead.
---
 crypto/memneq.c                | 48 +++++++++++++++++++++-----------------=
----
 include/linux/compiler-gcc.h   |  3 ---
 include/linux/compiler-intel.h |  7 ------
 include/linux/compiler.h       |  4 ----
 lib/string.c                   |  2 +-
 5 files changed, 25 insertions(+), 39 deletions(-)

diff --git a/crypto/memneq.c b/crypto/memneq.c
index afed1bd..efa7750 100644
--- a/crypto/memneq.c
+++ b/crypto/memneq.c
@@ -72,7 +72,7 @@ __crypto_memneq_generic(const void *a, const void *b, siz=
e_t size)
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 	while (size >=3D sizeof(unsigned long)) {
 		neq |=3D *(unsigned long *)a ^ *(unsigned long *)b;
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		a +=3D sizeof(unsigned long);
 		b +=3D sizeof(unsigned long);
 		size -=3D sizeof(unsigned long);
@@ -80,7 +80,7 @@ __crypto_memneq_generic(const void *a, const void *b, siz=
e_t size)
 #endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
 	while (size > 0) {
 		neq |=3D *(unsigned char *)a ^ *(unsigned char *)b;
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		a +=3D 1;
 		b +=3D 1;
 		size -=3D 1;
@@ -96,53 +96,53 @@ static inline unsigned long __crypto_memneq_16(const vo=
id *a, const void *b)
 #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 	if (sizeof(unsigned long) =3D=3D 8) {
 		neq |=3D *(unsigned long *)(a)   ^ *(unsigned long *)(b);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		neq |=3D *(unsigned long *)(a+8) ^ *(unsigned long *)(b+8);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 	} else if (sizeof(unsigned int) =3D=3D 4) {
 		neq |=3D *(unsigned int *)(a)    ^ *(unsigned int *)(b);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		neq |=3D *(unsigned int *)(a+4)  ^ *(unsigned int *)(b+4);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		neq |=3D *(unsigned int *)(a+8)  ^ *(unsigned int *)(b+8);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		neq |=3D *(unsigned int *)(a+12) ^ *(unsigned int *)(b+12);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 	} else
 #endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
 	{
 		neq |=3D *(unsigned char *)(a)    ^ *(unsigned char *)(b);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		neq |=3D *(unsigned char *)(a+1)  ^ *(unsigned char *)(b+1);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		neq |=3D *(unsigned char *)(a+2)  ^ *(unsigned char *)(b+2);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		neq |=3D *(unsigned char *)(a+3)  ^ *(unsigned char *)(b+3);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		neq |=3D *(unsigned char *)(a+4)  ^ *(unsigned char *)(b+4);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		neq |=3D *(unsigned char *)(a+5)  ^ *(unsigned char *)(b+5);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		neq |=3D *(unsigned char *)(a+6)  ^ *(unsigned char *)(b+6);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		neq |=3D *(unsigned char *)(a+7)  ^ *(unsigned char *)(b+7);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		neq |=3D *(unsigned char *)(a+8)  ^ *(unsigned char *)(b+8);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		neq |=3D *(unsigned char *)(a+9)  ^ *(unsigned char *)(b+9);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		neq |=3D *(unsigned char *)(a+10) ^ *(unsigned char *)(b+10);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		neq |=3D *(unsigned char *)(a+11) ^ *(unsigned char *)(b+11);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		neq |=3D *(unsigned char *)(a+12) ^ *(unsigned char *)(b+12);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		neq |=3D *(unsigned char *)(a+13) ^ *(unsigned char *)(b+13);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		neq |=3D *(unsigned char *)(a+14) ^ *(unsigned char *)(b+14);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 		neq |=3D *(unsigned char *)(a+15) ^ *(unsigned char *)(b+15);
-		OPTIMIZER_HIDE_VAR(neq);
+		barrier();
 	}
=20
 	return neq;
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index cdf13ca..d4c15f0 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -37,9 +37,6 @@
     __asm__ ("" : "=3Dr"(__ptr) : "0"(ptr));		\
     (typeof(ptr)) (__ptr + (off)); })
=20
-/* Make the optimizer believe the variable can be manipulated arbitrarily.=
 */
-#define OPTIMIZER_HIDE_VAR(var) __asm__ ("" : "=3Dr" (var) : "0" (var))
-
 #ifdef __CHECKER__
 #define __must_be_array(arr) 0
 #else
diff --git a/include/linux/compiler-intel.h b/include/linux/compiler-intel.h
index ba147a1..140211e 100644
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -14,19 +14,12 @@
  * It uses intrinsics to do the equivalent things.
  */
 #undef RELOC_HIDE
-#undef OPTIMIZER_HIDE_VAR
=20
 #define RELOC_HIDE(ptr, off)					\
   ({ unsigned long __ptr;					\
      __ptr =3D (unsigned long) (ptr);				\
     (typeof(ptr)) (__ptr + (off)); })
=20
-/* This should act as an optimization barrier on var.
- * Given that this compiler does not have inline assembly, a compiler barr=
ier
- * is the best we can do.
- */
-#define OPTIMIZER_HIDE_VAR(var) barrier()
-
 /* Intel ECC compiler doesn't support __builtin_types_compatible_p() */
 #define __must_be_array(a) 0
=20
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 1b45e4a..b70f303 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -181,10 +181,6 @@ void ftrace_likely_update(struct ftrace_branch_data *f=
, int val, int expect);
     (typeof(ptr)) (__ptr + (off)); })
 #endif
=20
-#ifndef OPTIMIZER_HIDE_VAR
-#define OPTIMIZER_HIDE_VAR(var) barrier()
-#endif
-
 /* Not-quite-unique ID. */
 #ifndef __UNIQUE_ID
 # define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __LINE=
__)
diff --git a/lib/string.c b/lib/string.c
index ce81aae..a579201 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -607,7 +607,7 @@ EXPORT_SYMBOL(memset);
 void memzero_explicit(void *s, size_t count)
 {
 	memset(s, 0, count);
-	OPTIMIZER_HIDE_VAR(s);
+	barrier();
 }
 EXPORT_SYMBOL(memzero_explicit);
=20
--=20
2.1.4


--0vzXIDBeUiKkjNJl--

--zS7rBR6csb6tI2e1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVCbJaAAoJEB4VYy8JqhaDrrIP/2EzUwqxb4VTk4jruWCXWMxJ
8Wg7du2u668PrpfT7Eqc62CQFGyHfifd4PVjQ1wRjDwe/a6BWfSckF/R5C6DuS9w
v5Mf8hrI7FB0LANmSOd+KgZHfKnZG/S0UzJDCU4IvJi+U7pgW6LrnPgfJfcO+6Jo
MNq9EZ3yJIiKqZeSguylm1XQVcOzuQOpn6dOxGnIRD92Qe1jj/QwA9ntuJt27UBi
9yQmGTRCy0Zl7+9JGuX9qvQqhZw3I/9+TBdQaOitekawRr/IuR8uBMxMJH0N8zmf
e142ICkz1WGuGsDLc579BM1xnSOgbf3W1KgPuJ+O4+vGJbnR03wlr+8jtN50CN+x
AGyc5hoPnvy4s+l09yS1NL1082vNEqoJDGqdgck2AOVzNgGx4/KmSYKECXbek8I+
NNipaOddyVx+ellAlchcTTb05MuUKVp/tWsFzP2UEmUlxD4u38q0OpcwcixRHnyM
OSXIiKa0S2Zz0+2W1Iyg0KQo/P7kF6ubn5M+NO37H0aLendtGaXYueKow5wLXbP8
e6dW6RTqx9nhk9ftJu1IvmaUUpiGcC5OooaMxD6gY9QafTHuqB7fQFe2bXVYtfOS
25FUCIzrclO5u3RXzXX907jqgVoYwXtnPBhaAMfSMURAO0vGJpI6qaiQwxEKsy8T
vdOoG4oovzqJBytl2b4Q
=70Kz
-----END PGP SIGNATURE-----

--zS7rBR6csb6tI2e1--
