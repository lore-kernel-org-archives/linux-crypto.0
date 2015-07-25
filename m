From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] jent: use safe format string parameters
Date: Sat, 25 Jul 2015 12:14:27 +0200
Message-ID: <1837679.rRPrBYE39B@tauon.atsec.com>
References: <20150724224127.GA29924@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48009 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbbGYKOa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 25 Jul 2015 06:14:30 -0400
In-Reply-To: <20150724224127.GA29924@www.outflux.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 24. Juli 2015, 15:41:27 schrieb Kees Cook:

Hi Kees,

>Since the API for jent_panic() does not include format string parameters,
>adjust the call to panic() to use a literal string to avoid any future
>callers from leaking format strings into the panic message.
>
>Signed-off-by: Kees Cook <keescook@chromium.org>

Thanks.

Acked-by: Stephan Mueller <smueller@chronox.de>
>---
> crypto/jitterentropy-kcapi.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
>index b32d834144cd..ceea83d13168 100644
>--- a/crypto/jitterentropy-kcapi.c
>+++ b/crypto/jitterentropy-kcapi.c
>@@ -79,7 +79,7 @@ int jent_fips_enabled(void)
>
> void jent_panic(char *s)
> {
>-	panic(s);
>+	panic("%s", s);
> }
>
> void jent_memcpy(void *dest, const void *src, unsigned int n)


Ciao
Stephan
