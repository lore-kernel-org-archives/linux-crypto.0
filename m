From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: keywrap - Add missing ULL suffixes for 64-bit constants
Date: Wed, 15 Nov 2017 15:26:22 +0100
Message-ID: <3608817.eAoC5DSMEg@tauon.chronox.de>
References: <1510742668-21121-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42362 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751255AbdKOO02 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Nov 2017 09:26:28 -0500
In-Reply-To: <1510742668-21121-1-git-send-email-geert@linux-m68k.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 15. November 2017, 11:44:28 CET schrieb Geert Uytterhoeven:

Hi Geert,

> On 32-bit (e.g. with m68k-linux-gnu-gcc-4.1):
> 
>     crypto/keywrap.c: In function ‘crypto_kw_decrypt’:
>     crypto/keywrap.c:191: warning: integer constant is too large for ‘long’
> type crypto/keywrap.c: In function ‘crypto_kw_encrypt’:
>     crypto/keywrap.c:224: warning: integer constant is too large for ‘long’
> type
> 
> Fixes: 9e49451d7a15365d ("crypto: keywrap - simplify code")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thank you

Reviewed-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan
