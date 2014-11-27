From: Stephan Mueller <smueller@chronox.de>
Subject: Re: crypto: algif_skcipher - Fixed blocking recvmsg
Date: Thu, 27 Nov 2014 15:45:29 +0100
Message-ID: <7895068.9zYFrJNGYN@tauon>
References: <20141127143811.GA25283@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54836 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaK0Opf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Nov 2014 09:45:35 -0500
Received: from tauon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S98C1> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Thu, 27 Nov 2014 15:45:30 +0100
In-Reply-To: <20141127143811.GA25283@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 27. November 2014, 22:38:12 schrieb Herbert Xu:

Hi Herbert,

>As most (all?) users of algif_skcipher are single-threaded and
>therefore always write before reading from an algif_skcipher
>socket, they never block and exercise that code-path.
>
>It turns out that code path doesn't even work because we never
>reload ctx->used after waking up so we never even see the new
>data and immediately return an error (and a loud WARN_ON).
>
>This patch fixes this by always reloading ctx->used.
>
>Reported-by: Stephan Mueller <smueller@chronox.de>
>Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Stephan Mueller <smueller@chronox.de>
>
>diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
>index 3438996..f80e652 100644
>--- a/crypto/algif_skcipher.c
>+++ b/crypto/algif_skcipher.c
>@@ -448,14 +448,13 @@ static int skcipher_recvmsg(struct kiocb *unused,
>struct socket *sock, while (!sg->length)
> 				sg++;
>
>-			used = ctx->used;
>-			if (!used) {
>+			if (!ctx->used) {
> 				err = skcipher_wait_for_data(sk, flags);
> 				if (err)
> 					goto unlock;
> 			}
>
>-			used = min_t(unsigned long, used, seglen);
>+			used = min_t(unsigned long, ctx->used, seglen);
>
> 			used = af_alg_make_sg(&ctx->rsgl, from, used, 
1);
> 			err = used;
>
>Thanks,


Ciao
Stephan
