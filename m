From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH -next] digsig: fix build errors
Date: Mon, 21 Nov 2011 12:32:48 +0200
Message-ID: <CALLzPKYmmah9EcXgN2ruRLoFSjV-ozn1pBMans=n2_ouB8Tqsg@mail.gmail.com>
References: <20111121133936.ae0ecadbf39ae50da6b842d1@canb.auug.org.au>
	<4EC9EBD2.3040708@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:24364 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754035Ab1KUKcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Nov 2011 05:32:51 -0500
In-Reply-To: <4EC9EBD2.3040708@xenotime.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 21, 2011 at 8:12 AM, Randy Dunlap <rdunlap@xenotime.net> wr=
ote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> Fix build errors by adding kconfig dependency on KEYS:
>
> lib/digsig.c:106:16: error: dereferencing pointer to incomplete type
> lib/digsig.c:107:11: error: dereferencing pointer to incomplete type
> lib/digsig.c:184:14: error: dereferencing pointer to incomplete type
> lib/digsig.c:223:3: error: 'key_ref_t' undeclared (first use in this =
function)
> lib/digsig.c:223:13: error: expected ';' before 'kref'
> lib/digsig.c:224:3: error: 'kref' undeclared (first use in this funct=
ion)
> lib/digsig.c:224:3: error: implicit declaration of function 'keyring_=
search'
> lib/digsig.c:231:3: error: implicit declaration of function 'request_=
key'
>
> and after changing lib/Kconfig:
> warning: (INTEGRITY_DIGSIG) selects DIGSIG which has unmet direct dep=
endencies (CRYPTO && KEYS)
>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> ---
> =C2=A0lib/Kconfig =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0| =C2=A0 =C2=A04 ++--
> =C2=A0security/integrity/Kconfig | =C2=A0 =C2=A02 +-
> =C2=A02 files changed, 3 insertions(+), 3 deletions(-)
>
> --- next-2011-1121.orig/lib/Kconfig
> +++ next-2011-1121/lib/Kconfig
> @@ -294,10 +294,10 @@ config MPILIB_EXTRA
>
> =C2=A0config DIGSIG
> =C2=A0 =C2=A0 =C2=A0 =C2=A0tristate "In-kernel signature checker"
> - =C2=A0 =C2=A0 =C2=A0 depends on CRYPTO
> + =C2=A0 =C2=A0 =C2=A0 depends on CRYPTO && KEYS

this patch was in /crypto dir before, now it is in /lib...
I think CRYPTO is not needed at all at the moment..


> =C2=A0 =C2=A0 =C2=A0 =C2=A0select MPILIB
> =C2=A0 =C2=A0 =C2=A0 =C2=A0help
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Digital signature verification. Cur=
rently only RSA is supported.
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 Implementation is done using GnuPG MPI =
library
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 Implementation is done using GnuPG MPI =
library.
>
> =C2=A0endmenu
> --- next-2011-1121.orig/security/integrity/Kconfig
> +++ next-2011-1121/security/integrity/Kconfig
> @@ -5,7 +5,7 @@ config INTEGRITY
>
> =C2=A0config INTEGRITY_DIGSIG
> =C2=A0 =C2=A0 =C2=A0 =C2=A0boolean "Digital signature verification us=
ing multiple keyrings"
> - =C2=A0 =C2=A0 =C2=A0 depends on INTEGRITY
> + =C2=A0 =C2=A0 =C2=A0 depends on INTEGRITY && CRYPTO && KEYS

Is it really needed, because 2 lines bellow is "select DIGSIG", which
will depend on KEYS??


> =C2=A0 =C2=A0 =C2=A0 =C2=A0default n
> =C2=A0 =C2=A0 =C2=A0 =C2=A0select DIGSIG
> =C2=A0 =C2=A0 =C2=A0 =C2=A0help
>

Thanks!
