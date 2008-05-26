From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] CRYPTO:  Simplify code using ARRAY_SIZE() macro.
Date: Mon, 26 May 2008 21:20:58 +1000
Message-ID: <20080526112058.GA16525@gondor.apana.org.au>
References: <alpine.LFD.1.10.0805250731530.23219@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from goliath.apana.org.au ([203.14.152.44]:52753 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755850AbYE0QYN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 May 2008 12:24:13 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805250731530.23219@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, May 25, 2008 at 11:32:45AM +0000, Robert P. J. Day wrote:
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> ---
> 
> diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
> index 81f3f95..c4c018d 100644
> --- a/drivers/crypto/hifn_795x.c
> +++ b/drivers/crypto/hifn_795x.c
> @@ -894,7 +894,7 @@ static int hifn_enable_crypto(struct hifn_device *dev)
>  	char *offtbl = NULL;
>  	int i;
> 
> -	for (i = 0; i < sizeof(pci2id)/sizeof(pci2id[0]); i++) {
> +	for (i = 0; i < ARRAY_SIZE(pci2id)); i++) {

You've got an extra parenthesis here.  You should be building the
patches that you send, no matter how trivial they might look!

I've fixed it for you this time.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
