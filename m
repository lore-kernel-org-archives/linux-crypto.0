From: Mathias Krause <minipli@googlemail.com>
Subject: Re: [PATCH] crypto: include crypto- module prefix in template
Date: Mon, 24 Nov 2014 20:35:20 +0100
Message-ID: <CA+rthh-v825SPF0VEdpfC1VGVEQp8=FniREWmchHTRGX3xbfSA@mail.gmail.com>
References: <20141124191742.GA13783@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63811 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaKXTfV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Nov 2014 14:35:21 -0500
In-Reply-To: <20141124191742.GA13783@www.outflux.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 24 November 2014 at 20:17, Kees Cook <keescook@chromium.org> wrote:
> This adds the module loading prefix "crypto-" to the template lookup
> as well.
>
> For example, attempting to load 'vfat(blowfish)' via AF_ALG now correctly
> includes the "crypto-" prefix at every level, correctly rejecting "vfat":
>
>         net-pf-38
>         algif-hash
>         crypto-vfat(blowfish)
>         crypto-vfat(blowfish)-all
>         crypto-vfat
>
> Reported-by: Mathias Krause <minipli@googlemail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  crypto/algapi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

That commit will break the user API again as ciphers like 'cbc(aes)'
won't work any more -- as the cbc module won't be loaded.
You're missing the MODULE_ALIAS_CRYPTO() annotaions for all the crypto
templates -- cbc, ctr, xts, hmac, ...


Regards,
Mathias
