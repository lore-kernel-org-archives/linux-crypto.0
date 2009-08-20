From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] linux/kernel.h, linux/mm.h, linux/slab.h are not needed
 in crypto/*.c
Date: Thu, 20 Aug 2009 13:17:52 +0200 (CEST)
Message-ID: <alpine.LRH.2.00.0908201313210.12141@vixen.sonytel.be>
References: <1250765062-11749-1-git-send-email-squadette@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Alexey Mahotkin <squadette@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:43177 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753317AbZHTLRw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2009 07:17:52 -0400
In-Reply-To: <1250765062-11749-1-git-send-email-squadette@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Have you compile-tested this on (all?) architectures (note I didn't).
But usually some of the includes you removed may be included indirectly=
 on some
platforms, but not on all of them.

On Thu, 20 Aug 2009, Alexey Mahotkin wrote:
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index f347637..b2dfb69 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -16,10 +16,8 @@
>  #include <crypto/internal/hash.h>
>  #include <crypto/scatterwalk.h>
>  #include <linux/err.h>
> -#include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/sched.h>
> -#include <linux/slab.h>

ahash.c uses kmalloc(), hence it should include <linux/slab.h>

>  #include <linux/seq_file.h>
> =20
>  #include "internal.h"
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index 56c62e2..b35a9e7 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -13,7 +13,6 @@
>  #include <linux/err.h>
>  #include <linux/errno.h>
>  #include <linux/init.h>
> -#include <linux/kernel.h>

algapi.c uses printk(), hence it should include <linux/kernel.h>.

> diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_m=
emset.c
> index 5b5eb99..4103dc9 100644
> --- a/crypto/async_tx/async_memset.c
> +++ b/crypto/async_tx/async_memset.c
> @@ -23,9 +23,7 @@
>   * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
>   *
>   */
> -#include <linux/kernel.h>
>  #include <linux/interrupt.h>
> -#include <linux/mm.h>

async_memset.c uses page_address(), hence it should include <linux/mm.h=
>

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village =B7 Da Vincilaan 7-D1 =B7 B-1935 Zaventem =B7 Bel=
gium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =B7 RPR Brussels
=46ortis =B7 BIC GEBABEBB =B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
