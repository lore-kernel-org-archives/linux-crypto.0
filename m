From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: properly handle null input and assoc data
	aead test vectors
Date: Mon, 20 Apr 2009 14:23:01 +0800
Message-ID: <20090420062301.GA1083@gondor.apana.org.au>
References: <200904091434.59639.jarod@redhat.com> <200904150835.38818.jarod@redhat.com> <200904150935.15947.jarod@redhat.com> <200904150936.10800.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36057 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751285AbZDTGXF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2009 02:23:05 -0400
Content-Disposition: inline
In-Reply-To: <200904150936.10800.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 15, 2009 at 09:36:10AM -0400, Jarod Wilson wrote:
> Currenty, if either input or associated data are null in an aead
> test vector, we'll have random contents of the input and assoc
> arrays. Similar to the iv, play it safe and zero out the contents.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

This patch doesn't make sense unless you were getting a crash
without it.
 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index bfee6e9..a8bdcb3 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -314,8 +314,18 @@ static int test_aead(struct crypto_aead *tfm, int enc,
>  			input = xbuf[0];
>  			assoc = axbuf[0];
>  
> -			memcpy(input, template[i].input, template[i].ilen);
> -			memcpy(assoc, template[i].assoc, template[i].alen);
> +			if (template[i].input)
> +				memcpy(input, template[i].input,
> +				       template[i].ilen);
> +			else
> +				memset(input, 0, MAX_IVLEN);

If template[i].input was really NULL then the memcpy should crash.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
