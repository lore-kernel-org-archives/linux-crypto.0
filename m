From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/5] crypto/camellia_generic.c: convert comma to
 semicolon
Date: Sat, 10 Aug 2013 09:19:17 -0700
Message-ID: <1376151557.2083.35.camel@joe-AO722>
References: <1376149225-3997-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1376149225-3997-3-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	kernel-janitors@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	trivial@kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:38114 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964808Ab3HJQTT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Aug 2013 12:19:19 -0400
In-Reply-To: <1376149225-3997-3-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 2013-08-10 at 17:40 +0200, Julia Lawall wrote:
> Replace a comma between expression statements by a semicolon.
[]
> This patch is separate from the others because the code appears to be
> machine-generated.

It may have once been machine generated, but it's not now.
It's been modified several times by human generated patches.

> diff --git a/crypto/camellia_generic.c b/crypto/camellia_generic.c
[]
> @@ -388,7 +388,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
[]
> -	dw = subL[1] & subL[9],
> +	dw = subL[1] & subL[9];
>  		subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl2) */

Perhaps you can (auto?) fix the indentation
on the next line too?

> @@ -397,7 +397,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
[]
> -	dw = subL[1] & subL[17],
> +	dw = subL[1] & subL[17];
>  		subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl4) */

etc...
