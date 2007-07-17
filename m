From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/aes.c remove operator ? and variable t in bf_setkey
Date: Tue, 17 Jul 2007 20:35:05 +0800
Message-ID: <20070717123505.GB7211@gondor.apana.org.au>
References: <1184547154.23516.12.camel@localhost> <20070716032831.GA25617@gondor.apana.org.au> <1184591714.8255.16.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Frederik Sdun <fs_1600@web.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2996 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751841AbXGQMfN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Jul 2007 08:35:13 -0400
Content-Disposition: inline
In-Reply-To: <1184591714.8255.16.camel@localhost>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Sorry, your patch doesn't apply.

On Mon, Jul 16, 2007 at 03:15:13PM +0200, Frederik Sdun wrote:
> 
> --- crypto/aes.c.orig   2007-07-15 11:43:21.000000000 +0200
> +++ crypto/aes.c        2007-07-16 14:38:57.000000000 +0200

Please make sure your patch can be applied with patch -p1.

> @@ -135,7 +135,7 @@ f_mult (u8 a, u8 b)
>  static void __init
>  gen_tabs (void)
>  {
> -       u32 i, t;
> +       u32 i;

Your mailer has corrupted the tabs.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
