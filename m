From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/aes.c remove operator ? and variable t in bf_setkey
Date: Mon, 16 Jul 2007 11:28:31 +0800
Message-ID: <20070716032831.GA25617@gondor.apana.org.au>
References: <1184547154.23516.12.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Frederik Sdun <fs_1600@web.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1767 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759038AbXGPD2d (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Jul 2007 23:28:33 -0400
Content-Disposition: inline
In-Reply-To: <1184547154.23516.12.camel@localhost>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 16, 2007 at 02:52:34AM +0200, Frederik Sdun wrote:
> 
> this removes the the ? operator which is false nearly all the time.

These changes look good.  Could you please resend them as
patches that can be directly applied and add a sign-off?
You can refer to Documentation/SubmittingPatches for detailed
instructions.

> --- aes.c.orig  2007-07-15 11:43:21.000000000 +0200
> +++ aes.c       2007-07-16 01:56:49.000000000 +0200
> @@ -156,9 +156,12 @@
>  
>                 p = (p << 1) ^ (p & 0x80 ? 0x01b : 0);
>         }
> +
> +       sbx_tab[0] = 0x63;
> +       isb_tab[0x63] = (u8) 0;

Please kill that cast.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
