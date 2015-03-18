From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH -crypto] lib: memzero_explicit: use barrier instead of OPTIMIZER_HIDE_VAR
Date: Wed, 18 Mar 2015 22:30:08 +0100
Message-ID: <4726507.H4shmA7JdR@tachyon.chronox.de>
References: <9419c18a95e98ba92f1aad8fda7da51771fdccea.1426700375.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	mancha security <mancha1@zoho.com>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46735 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756995AbbCRVaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 17:30:12 -0400
In-Reply-To: <9419c18a95e98ba92f1aad8fda7da51771fdccea.1426700375.git.daniel@iogearbox.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 18. M=E4rz 2015, 18:47:25 schrieb Daniel Borkmann:

Hi Daniel,

> From: mancha security <mancha1@zoho.com>
>=20
> OPTIMIZER_HIDE_VAR(), as defined when using gcc, is insufficient to
> ensure protection from dead store optimization.
>=20
> For the random driver and crypto drivers, calls are emitted ...
>=20
>   $ gdb vmlinux
>   (gdb) disassemble memzero_explicit
>   Dump of assembler code for function memzero_explicit:
>     0xffffffff813a18b0 <+0>:	push   %rbp
>     0xffffffff813a18b1 <+1>:	mov    %rsi,%rdx
>     0xffffffff813a18b4 <+4>:	xor    %esi,%esi
>     0xffffffff813a18b6 <+6>:	mov    %rsp,%rbp
>     0xffffffff813a18b9 <+9>:	callq  0xffffffff813a7120 <memset>
>     0xffffffff813a18be <+14>:	pop    %rbp
>     0xffffffff813a18bf <+15>:	retq
>   End of assembler dump.
>=20
>   (gdb) disassemble extract_entropy
>   [...]
>     0xffffffff814a5009 <+313>:	mov    %r12,%rdi
>     0xffffffff814a500c <+316>:	mov    $0xa,%esi
>     0xffffffff814a5011 <+321>:	callq  0xffffffff813a18b0=20
<memzero_explicit>
>     0xffffffff814a5016 <+326>:	mov    -0x48(%rbp),%rax
>   [...]
>=20
> ... but in case in future we might use facilities such as LTO, then
> OPTIMIZER_HIDE_VAR() is not sufficient to protect gcc from a possible
> eviction of the memset(). We have to use a compiler barrier instead.
>=20
> Minimal test example when we assume memzero_explicit() would *not* be
> a call, but would have been *inlined* instead:
>=20
>   static inline void memzero_explicit(void *s, size_t count)
>   {
>     memset(s, 0, count);
>     <foo>
>   }
>=20
>   int main(void)
>   {
>     char buff[20];
>=20
>     snprintf(buff, sizeof(buff) - 1, "test");
>     printf("%s", buff);
>=20
>     memzero_explicit(buff, sizeof(buff));
>     return 0;
>   }
>=20
> With <foo> :=3D OPTIMIZER_HIDE_VAR():
>=20
>   (gdb) disassemble main
>   Dump of assembler code for function main:
>   [...]
>    0x0000000000400464 <+36>:	callq  0x400410 <printf@plt>
>    0x0000000000400469 <+41>:	xor    %eax,%eax
>    0x000000000040046b <+43>:	add    $0x28,%rsp
>    0x000000000040046f <+47>:	retq
>   End of assembler dump.
>=20
> With <foo> :=3D barrier():
>=20
>   (gdb) disassemble main
>   Dump of assembler code for function main:
>   [...]
>    0x0000000000400464 <+36>:	callq  0x400410 <printf@plt>
>    0x0000000000400469 <+41>:	movq   $0x0,(%rsp)
>    0x0000000000400471 <+49>:	movq   $0x0,0x8(%rsp)
>    0x000000000040047a <+58>:	movl   $0x0,0x10(%rsp)
>    0x0000000000400482 <+66>:	xor    %eax,%eax
>    0x0000000000400484 <+68>:	add    $0x28,%rsp
>    0x0000000000400488 <+72>:	retq
>   End of assembler dump.
>=20
> As can be seen, movq, movq, movl are being emitted inlined
> via memset().
>=20
> Reference: http://thread.gmane.org/gmane.linux.kernel.cryptoapi/13764=
/
> Fixes: d4c5efdb9777 ("random: add and use memzero_explicit() for clea=
ring
> data") Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Cc: Stephan Mueller <smueller@chronox.de>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: mancha security <mancha1@zoho.com>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  Sending to Herbert as crypto/random are the main users.
>  Based against -crypto tree. Thanks!
>=20
>  lib/string.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/lib/string.c b/lib/string.c
> index ce81aae..a579201 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -607,7 +607,7 @@ EXPORT_SYMBOL(memset);
>  void memzero_explicit(void *s, size_t count)
>  {
>  	memset(s, 0, count);
> -	OPTIMIZER_HIDE_VAR(s);
> +	barrier();
>  }
>  EXPORT_SYMBOL(memzero_explicit);

Acked-by: Stephan Mueller <smueller@chronox.de>

--=20
Ciao
Stephan
