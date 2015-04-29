From: mancha security <mancha1@zoho.com>
Subject: Re: [PATCH crypto-2.6] lib: make memzero_explicit more robust
 against dead store elimination
Date: Wed, 29 Apr 2015 13:08:16 +0000
Message-ID: <20150429130816.GA8526@zoho.com>
References: <85dfdd23d98412a183546e2e7659a6a2bed1fca8.1430230786.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Mark Charlebois <charlebm@gmail.com>,
	Behan Webster <behanw@converseincode.com>
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sender1.zohomail.com ([74.201.84.155]:35735 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423057AbbD2NIw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Apr 2015 09:08:52 -0400
Content-Disposition: inline
In-Reply-To: <85dfdd23d98412a183546e2e7659a6a2bed1fca8.1430230786.git.daniel@iogearbox.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel et al.

Looks good from here.

By the way, has anyone been able to verify that __memory_barrier=20
provides DSE protection under various optimizations? Unfortunately, I
don't have ready access to ICC at the moment or I'd test it myself.

--mancha

PS It would be nice if memset_s were universally adopted/implemented so
we could stop worrying about these things.


On Tue, Apr 28, 2015 at 05:22:20PM +0200, Daniel Borkmann wrote:
> In commit 0b053c951829 ("lib: memzero_explicit: use barrier instead
> of OPTIMIZER_HIDE_VAR"), we made memzero_explicit() more robust in
> case LTO would decide to inline memzero_explicit() and eventually
> find out it could be elimiated as dead store.
>=20
> While using barrier() works well for the case of gcc, recent efforts
> from LLVMLinux people suggest to use llvm as an alternative to gcc,
> and there, Stephan found in a simple stand-alone user space example
> that llvm could nevertheless optimize and thus elimitate the memset().
> A similar issue has been observed in the referenced llvm bug report,
> which is regarded as not-a-bug.
>=20
> The fix in this patch now works for both compilers (also tested with
> more aggressive optimization levels). Arguably, in the current kernel
> tree it's more of a theoretical issue, but imho, it's better to be
> pedantic about it.
>=20
> It's clearly visible though, with the below code: if we would have
> used barrier()-only here, llvm would have omitted clearing, not so
> with barrier_data() variant:
>=20
>   static inline void memzero_explicit(void *s, size_t count)
>   {
>     memset(s, 0, count);
>     barrier_data(s);
>   }
>=20
>   int main(void)
>   {
>     char buff[20];
>     memzero_explicit(buff, sizeof(buff));
>     return 0;
>   }
>=20
>   $ gcc -O2 test.c
>   $ gdb a.out
>   (gdb) disassemble main
>   Dump of assembler code for function main:
>    0x0000000000400400  <+0>: lea   -0x28(%rsp),%rax
>    0x0000000000400405  <+5>: movq  $0x0,-0x28(%rsp)
>    0x000000000040040e <+14>: movq  $0x0,-0x20(%rsp)
>    0x0000000000400417 <+23>: movl  $0x0,-0x18(%rsp)
>    0x000000000040041f <+31>: xor   %eax,%eax
>    0x0000000000400421 <+33>: retq
>   End of assembler dump.
>=20
>   $ clang -O2 test.c
>   $ gdb a.out
>   (gdb) disassemble main
>   Dump of assembler code for function main:
>    0x00000000004004f0  <+0>: xorps  %xmm0,%xmm0
>    0x00000000004004f3  <+3>: movaps %xmm0,-0x18(%rsp)
>    0x00000000004004f8  <+8>: movl   $0x0,-0x8(%rsp)
>    0x0000000000400500 <+16>: lea    -0x18(%rsp),%rax
>    0x0000000000400505 <+21>: xor    %eax,%eax
>    0x0000000000400507 <+23>: retq
>   End of assembler dump.
>=20
> As clang (but also icc) defines __GNUC__, it's sufficient to define this
> in compiler-gcc.h only.
>=20
> Reference: https://llvm.org/bugs/show_bug.cgi?id=3D15495
> Reported-by: Stephan Mueller <smueller@chronox.de>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Stephan Mueller <smueller@chronox.de>
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Cc: mancha security <mancha1@zoho.com>
> Cc: Mark Charlebois <charlebm@gmail.com>
> Cc: Behan Webster <behanw@converseincode.com>
> ---
>  include/linux/compiler-gcc.h | 16 +++++++++++++++-
>  include/linux/compiler.h     |  4 ++++
>  lib/string.c                 |  2 +-
>  3 files changed, 20 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> index cdf13ca..371e560 100644
> --- a/include/linux/compiler-gcc.h
> +++ b/include/linux/compiler-gcc.h
> @@ -9,10 +9,24 @@
>  		   + __GNUC_MINOR__ * 100 \
>  		   + __GNUC_PATCHLEVEL__)
> =20
> -
>  /* Optimization barrier */
> +
>  /* The "volatile" is due to gcc bugs */
>  #define barrier() __asm__ __volatile__("": : :"memory")
> +/*
> + * This version is i.e. to prevent dead stores elimination on @ptr
> + * where gcc and llvm may behave differently when otherwise using
> + * normal barrier(): while gcc behavior gets along with a normal
> + * barrier(), llvm needs an explicit input variable to be assumed
> + * clobbered. The issue is as follows: while the inline asm might
> + * access any memory it wants, the compiler could have fit all of
> + * @ptr into memory registers instead, and since @ptr never escaped
> + * from that, it proofed that the inline asm wasn't touching any of
> + * it. This version works well with both compilers, i.e. we're telling
> + * the compiler that the inline asm absolutely may see the contents
> + * of @ptr. See also: https://llvm.org/bugs/show_bug.cgi?id=3D15495
> + */
> +#define barrier_data(ptr) __asm__ __volatile__("": :"r"(ptr) :"memory")
> =20
>  /*
>   * This macro obfuscates arithmetic on a variable address so that gcc
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 0e41ca0..8677225 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -169,6 +169,10 @@ void ftrace_likely_update(struct ftrace_branch_data =
*f, int val, int expect);
>  # define barrier() __memory_barrier()
>  #endif
> =20
> +#ifndef barrier_data
> +# define barrier_data(ptr) barrier()
> +#endif
> +
>  /* Unreachable code */
>  #ifndef unreachable
>  # define unreachable() do { } while (1)
> diff --git a/lib/string.c b/lib/string.c
> index a579201..bb3d4b6 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -607,7 +607,7 @@ EXPORT_SYMBOL(memset);
>  void memzero_explicit(void *s, size_t count)
>  {
>  	memset(s, 0, count);
> -	barrier();
> +	barrier_data(s);
>  }
>  EXPORT_SYMBOL(memzero_explicit);
> =20
> --=20
> 1.9.3
>=20

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVQNe/AAoJEB4VYy8JqhaD2oMQALAWSdv/QkQQush+V98FOXt7
wtlapLmiTLKRJo4zlqP2XL7PtEd8pjlP65v3ttIcXilJzM0CpcURLbd+bINxz/XD
Sg9BsvFnyl3SBjLDHysMxKw58eyEIsxphMUFKxCNrixX8FoRL8WNvvvyOvoOSf99
XyzI2LXMzeEaH7VS+vv8Gl5PWDTMd+KmELvAm3v45vQR0HhQA7S04599ol6tZFbI
T4LyS3dbuX6vRmOtQBR/LqcGtabp0HBIWIFcO+aeii/zqN5bskYT9cH9nMyPQQk5
CuaMgSoWOOFoHIkAUuyU7PDNP3cTeSrgShuNzp5Nd1pLM5Vqx1dVrYVARPLmCy8l
/XIhjac9eITBoltMjHxVtkpkpytes3vPyZ0uSAVzVVKg7OUHxLiDekWAVo+9PM94
ofxVJR9ULdDw/0sy6/XP11jUarRNDqzlsiwCT50d7kbZXkZ4cG3g0AUj8/WWsC24
F5UT5Sn64jqu5GytHe1dO+0ANQsidZpLA/Q5nnZcxeBRdRFXKE+f+OsR9HpNeWXl
Mo8reykhMpdMjtQs8aWW8EL+8Hj+1NP9tILszDmCGgmECFTkXKDMXizGRtq0EsB7
pvaqIkfTp+We5reG9qZGq13J5fQMZjUITIkPv0zP/RxaTkRhjD/saS7vs0C4yX4F
EUoW6eguOgjeM9bCTNNP
=5e90
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
