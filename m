From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH 1/2] Renamed salsa20_32.c to salsa20_glue.c
Date: Sun, 16 Dec 2007 20:53:10 +0100
Message-ID: <20071216195310.GA29507@Chamillionaire.breakpoint.cc>
References: <fd3e431c0712160959o240861cqbfcc05672507d51f@mail.gmail.com>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:59943 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755292AbXLPTxQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 16 Dec 2007 14:53:16 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0712160959o240861cqbfcc05672507d51f@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Tan Swee Heng | 2007-12-17 01:59:26 [+0800]:

>The salsa20_32.c file is renamed to salsa20_glue.c. This is done
git-format-patch -M produces a smaller patch because it can detect
renames. Just a note for the future :)

>diff --git a/arch/x86/crypto/salsa20_glue.c b/arch/x86/crypto/salsa20_glue.c
>new file mode 100644
>index 0000000..8592ccb
>--- /dev/null
>+++ b/arch/x86/crypto/salsa20_glue.c

>+static struct crypto_alg alg = {
>+	.cra_name           =   "salsa20",
>+	.cra_driver_name    =   "salsa20-asm",

>+MODULE_ALIAS("salsa20");

I guess Herbert wants to see here a
MODULE_ALIAS("salsa20-asm");
here as well.
