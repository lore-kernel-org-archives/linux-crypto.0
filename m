From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: build #373 issue for v2.6.25-rc2-477-g1a4c6be in ./crypto/authenc.c
Date: Sat, 23 Feb 2008 11:13:50 +0800
Message-ID: <20080223031350.GA18824@gondor.apana.org.au>
References: <200802221323.19718.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44323 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754247AbYBWDNy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Feb 2008 22:13:54 -0500
Content-Disposition: inline
In-Reply-To: <200802221323.19718.toralf.foerster@gmx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 22, 2008 at 12:23:15PM +0000, Toralf F=F6rster wrote:
> Hello,
>=20
> the build with the attached .config failed, make ends with:
> ...
>   CC      arch/x86/lib/strstr_32.o
>   CC      arch/x86/lib/usercopy_32.o
>   AR      arch/x86/lib/lib.a
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: modpost: Found 15 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=3Dy'
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> crypto/built-in.o: In function `crypto_authenc_alloc':
> authenc.c:(.text+0x10f4f): undefined reference to `crypto_grab_skciph=
er'
> make: *** [.tmp_vmlinux1] Error 1

This patch should fix the problem.

Cheers,
--=20
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--=20
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 898acc5..69f1be6 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -575,6 +575,7 @@ config CRYPTO_TEST
 config CRYPTO_AUTHENC
 	tristate "Authenc support"
 	select CRYPTO_AEAD
+	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
 	select CRYPTO_HASH
 	help
