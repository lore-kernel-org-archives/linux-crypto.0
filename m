From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6/7] crypto: serpent: add 8-way parallel x86_64/SSE2
	assembler implementation
Date: Wed, 9 Nov 2011 11:44:43 +0800
Message-ID: <20111109034442.GA15096@gondor.apana.org.au>
References: <20111017210247.13543.75430.stgit@localhost6.localdomain6> <20111017210318.13543.78194.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:44159 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab1KIDoq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Nov 2011 22:44:46 -0500
Content-Disposition: inline
In-Reply-To: <20111017210318.13543.78194.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 18, 2011 at 12:03:18AM +0300, Jussi Kivilinna wrote:
> Patch adds x86_64/SSE2 assembler implementation of serpent cipher. As=
sembler
> functions crypt data in eigth block chunks (two 4 block chunk SSE2 op=
erations
> in parallel to improve performance on out-of-order CPUs). Glue code i=
s based
> on one from AES-NI implementation, so requests from irq context are r=
edirected
> to cryptd.

This doesn't build for me:

  CC [M]  arch/x86/crypto/serpent_sse2_glue.o
arch/x86/crypto/serpent_sse2_glue.c:154: error: =E2=80=98THIS_MODULE=E2=
=80=99 undeclared here (not in a function)
arch/x86/crypto/serpent_sse2_glue.c:716: error: expected declaration sp=
ecifiers or =E2=80=98...=E2=80=99 before string constant
arch/x86/crypto/serpent_sse2_glue.c:716: warning: data definition has n=
o type or storage class
arch/x86/crypto/serpent_sse2_glue.c:716: warning: type defaults to =E2=80=
=98int=E2=80=99 in declaration of =E2=80=98MODULE_DESCRIPTION=E2=80=99
arch/x86/crypto/serpent_sse2_glue.c:716: warning: function declaration =
isn=E2=80=99t a prototype
arch/x86/crypto/serpent_sse2_glue.c:717: error: expected declaration sp=
ecifiers or =E2=80=98...=E2=80=99 before string constant
arch/x86/crypto/serpent_sse2_glue.c:717: warning: data definition has n=
o type or storage class
arch/x86/crypto/serpent_sse2_glue.c:717: warning: type defaults to =E2=80=
=98int=E2=80=99 in declaration of =E2=80=98MODULE_LICENSE=E2=80=99
arch/x86/crypto/serpent_sse2_glue.c:717: warning: function declaration =
isn=E2=80=99t a prototype
arch/x86/crypto/serpent_sse2_glue.c:718: error: expected declaration sp=
ecifiers or =E2=80=98...=E2=80=99 before string constant
arch/x86/crypto/serpent_sse2_glue.c:718: warning: data definition has n=
o type or storage class
arch/x86/crypto/serpent_sse2_glue.c:718: warning: type defaults to =E2=80=
=98int=E2=80=99 in declaration of =E2=80=98MODULE_ALIAS=E2=80=99
arch/x86/crypto/serpent_sse2_glue.c:718: warning: function declaration =
isn=E2=80=99t a prototype
make[2]: *** [arch/x86/crypto/serpent_sse2_glue.o] Error 1
make[1]: *** [arch/x86/crypto] Error 2
make: *** [arch/x86] Error 2

So I've applied patches 1-5, please resubmit 6-7 after you've
fixed them up.

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
