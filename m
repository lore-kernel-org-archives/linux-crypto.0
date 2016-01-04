From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: Make CRYPTO_CBC select CRYPTO_ECHAINIV
Date: Mon, 04 Jan 2016 21:09:58 +0100
Message-ID: <4445865.9O5pIU29W2@myon.chronox.de>
References: <568AC07B.8020605@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Thomas Egerer <hakke_007@gmx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:41348 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbcADUKD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jan 2016 15:10:03 -0500
In-Reply-To: <568AC07B.8020605@gmx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 4. Januar 2016, 19:56:59 schrieb Thomas Egerer:

Hi Thomas,

> Similar to CTR mode selecting CRYPTO_SEQIV, CBC mode requires echainiv
> and has to select CRYPTO_ECHAINIV in order to work properly. This solves
> the issues caused by a misconfiguration as described in [1].
> 
> [1] https://lists.strongswan.org/pipermail/users/2015-December/009074.html
> 
> Signed-off-by: Thomas Egerer <hakke_007@gmx.de>

Please provide the patch inline as documented in 
Documentation/SubmittingPatches
> ---
>  crypto/Kconfig | 1 +
>  1 file changed, 1 insertion(+)


-- 
Ciao
Stephan
