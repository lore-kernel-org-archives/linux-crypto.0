From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] Renamed salsa20_32.c to salsa20_glue.c
Date: Tue, 18 Dec 2007 00:01:36 +0800
Message-ID: <20071217160136.GA14440@gondor.apana.org.au>
References: <fd3e431c0712160959o240861cqbfcc05672507d51f@mail.gmail.com> <20071216195310.GA29507@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Tan Swee Heng <thesweeheng@gmail.com>,
	Linux Crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2329 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758950AbXLQQBk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Dec 2007 11:01:40 -0500
Content-Disposition: inline
In-Reply-To: <20071216195310.GA29507@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 16, 2007 at 08:53:10PM +0100, Sebastian Siewior wrote:
> * Tan Swee Heng | 2007-12-17 01:59:26 [+0800]:
> 
> >The salsa20_32.c file is renamed to salsa20_glue.c. This is done

Patch applied.  Thanks!

> >diff --git a/arch/x86/crypto/salsa20_glue.c b/arch/x86/crypto/salsa20_glue.c
> >new file mode 100644
> >index 0000000..8592ccb
> >--- /dev/null
> >+++ b/arch/x86/crypto/salsa20_glue.c
> 
> >+static struct crypto_alg alg = {
> >+	.cra_name           =   "salsa20",
> >+	.cra_driver_name    =   "salsa20-asm",
> 
> >+MODULE_ALIAS("salsa20");
> 
> I guess Herbert wants to see here a
> MODULE_ALIAS("salsa20-asm");
> here as well.

I've added that too.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
