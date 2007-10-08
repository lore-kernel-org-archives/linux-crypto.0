From: Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [PATCH] [crypto] load the SHA1[1|256] module by an alias
Date: Mon, 08 Oct 2007 13:25:23 +0200
Message-ID: <1191842723.7760.3.camel@localhost.localdomain>
References: <200708200234.25620.ak@suse.de>
	 <E1IMveX-0002Kv-00@gondolin.me.apana.org.au>
	 <20070820101618.GE16680@bingen.suse.de>
	 <20070820120605.GA13163@gondor.apana.org.au>
	 <20070930124239.GB24811@Chamillionaire.breakpoint.cc>
	 <20071003073522.GA7285@gondor.apana.org.au>
	 <20071004083512.GA11305@Chamillionaire.breakpoint.cc>
	 <E1IdMSX-0004KV-LS@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Sebastian Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:36639 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbXJHLXo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Oct 2007 07:23:44 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.13.8/8.13.8) with ESMTP id l98BNhCc161658
	for <linux-crypto@vger.kernel.org>; Mon, 8 Oct 2007 11:23:43 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l98BNgfD2216094
	for <linux-crypto@vger.kernel.org>; Mon, 8 Oct 2007 13:23:42 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l98BNgIv014121
	for <linux-crypto@vger.kernel.org>; Mon, 8 Oct 2007 13:23:42 +0200
In-Reply-To: <E1IdMSX-0004KV-LS@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Sebastian,

what about SHA-512? Should that not also be renamed to sha512_generic.c=
 ?

--Jan

On Thu, 2007-10-04 at 09:37 +0200, Sebastian Siewior wrote:
> Loading the crypto algorithm by the alias instead of by module direct=
ly
> has the advantage that all possible implementations of this algorithm
> are loaded automatically and the crypto API can choose the best one
> depending on its priority.
> Additionally it ensures that the generic implementation as well as th=
e
> HW driver (if available) is loaded in case the HW driver needs the
> generic version as fallback in corner cases.
>=20
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
> ---
>  arch/s390/crypto/sha1_s390.c          |    2 +-
>  arch/s390/crypto/sha256_s390.c        |    2 +-
>  crypto/Makefile                       |    4 ++--
>  crypto/{sha1.c =3D> sha1_generic.c}     |    2 +-
>  crypto/{sha256.c =3D> sha256_generic.c} |    2 +-
>  drivers/crypto/padlock-sha.c          |    4 ++--
>  6 files changed, 8 insertions(+), 8 deletions(-)
>  rename crypto/{sha1.c =3D> sha1_generic.c} (99%)
>  rename crypto/{sha256.c =3D> sha256_generic.c} (99%)
>=20
> diff --git a/arch/s390/crypto/sha1_s390.c b/arch/s390/crypto/sha1_s39=
0.c
> index af4460e..8ebd3cd 100644
> --- a/arch/s390/crypto/sha1_s390.c
> +++ b/arch/s390/crypto/sha1_s390.c
> @@ -12,7 +12,7 @@
>   *   Author(s): Thomas Spatzier
>   *		Jan Glauber (jan.glauber@de.ibm.com)
>   *
> - * Derived from "crypto/sha1.c"
> + * Derived from "crypto/sha1_generic.c"
>   *   Copyright (c) Alan Smithee.
>   *   Copyright (c) Andrew McDonald <andrew@mcdonald.org.uk>
>   *   Copyright (c) Jean-Francois Dive <jef@linuxbe.org>
> diff --git a/arch/s390/crypto/sha256_s390.c b/arch/s390/crypto/sha256=
_s390.c
> index 2ced333..c728bd0 100644
> --- a/arch/s390/crypto/sha256_s390.c
> +++ b/arch/s390/crypto/sha256_s390.c
> @@ -7,7 +7,7 @@
>   *   Copyright IBM Corp. 2005,2007
>   *   Author(s): Jan Glauber (jang@de.ibm.com)
>   *
> - * Derived from "crypto/sha256.c"
> + * Derived from "crypto/sha256_generic.c"
>   * and "arch/s390/crypto/sha1_s390.c"
>   *
>   * This program is free software; you can redistribute it and/or mod=
ify it
> diff --git a/crypto/Makefile b/crypto/Makefile
> index b6ef5e4..43c2a0d 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -21,8 +21,8 @@ obj-$(CONFIG_CRYPTO_XCBC) +=3D xcbc.o
>  obj-$(CONFIG_CRYPTO_NULL) +=3D crypto_null.o
>  obj-$(CONFIG_CRYPTO_MD4) +=3D md4.o
>  obj-$(CONFIG_CRYPTO_MD5) +=3D md5.o
> -obj-$(CONFIG_CRYPTO_SHA1) +=3D sha1.o
> -obj-$(CONFIG_CRYPTO_SHA256) +=3D sha256.o
> +obj-$(CONFIG_CRYPTO_SHA1) +=3D sha1_generic.o
> +obj-$(CONFIG_CRYPTO_SHA256) +=3D sha256_generic.o
>  obj-$(CONFIG_CRYPTO_SHA512) +=3D sha512.o
>  obj-$(CONFIG_CRYPTO_WP512) +=3D wp512.o
>  obj-$(CONFIG_CRYPTO_TGR192) +=3D tgr192.o
> diff --git a/crypto/sha1.c b/crypto/sha1_generic.c
> similarity index 99%
> rename from crypto/sha1.c
> rename to crypto/sha1_generic.c
> index 1bba551..70364dd 100644
> --- a/crypto/sha1.c
> +++ b/crypto/sha1_generic.c
> @@ -139,4 +139,4 @@ module_exit(fini);
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("SHA1 Secure Hash Algorithm");
> =20
> -MODULE_ALIAS("sha1-generic");
> +MODULE_ALIAS("sha1");
> diff --git a/crypto/sha256.c b/crypto/sha256_generic.c
> similarity index 99%
> rename from crypto/sha256.c
> rename to crypto/sha256_generic.c
> index 716195b..74bf2f9 100644
> --- a/crypto/sha256.c
> +++ b/crypto/sha256_generic.c
> @@ -339,4 +339,4 @@ module_exit(fini);
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("SHA256 Secure Hash Algorithm");
> =20
> -MODULE_ALIAS("sha256-generic");
> +MODULE_ALIAS("sha256");
> diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sh=
a.c
> index a781fd2..b8ee645 100644
> --- a/drivers/crypto/padlock-sha.c
> +++ b/drivers/crypto/padlock-sha.c
> @@ -314,5 +314,5 @@ MODULE_DESCRIPTION("VIA PadLock SHA1/SHA256 algor=
ithms support.");
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Michal Ludvig");
> =20
> -MODULE_ALIAS("sha1-padlock");
> -MODULE_ALIAS("sha256-padlock");
> +MODULE_ALIAS("sha1");
> +MODULE_ALIAS("sha256");
--=20
++49 7031 161911

IBM Deutschland Entwicklung GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter Gesch=E4ftsf=FChrung: Her=
bert
Kircher, Sitz der Gesellschaft: B=F6blingen, Registergericht Amtsgerich=
t
Stuttgart, HRB 243294
