From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto_shash_update & CRYPTO_TFM_REQ_MAY_SLEEP
Date: Tue, 16 Feb 2010 15:27:05 +0800
Message-ID: <20100216072705.GA28670@gondor.apana.org.au>
References: <20100209074146.GA17681@gondor.apana.org.au> <4B72A3A4.4050700@nokia.com> <4B799E83.5000700@nokia.com> <20100216004430.GA26021@gondor.apana.org.au> <4B7A3CD8.2000500@nokia.com> <20100216065844.GA28436@gondor.apana.org.au> <4B7A43A6.6090409@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:49531 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932618Ab0BPH1J (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2010 02:27:09 -0500
Content-Disposition: inline
In-Reply-To: <4B7A43A6.6090409@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 16, 2010 at 09:05:10AM +0200, Dmitry Kasatkin wrote:
> Hi,
> 
> How is it possible to wait for completion here?: shash.c
> 
> shash_compat_digest()
> {
> ....
>         data = crypto_kmap(sg_page(sg), 0);
>         err = crypto_shash_digest(desc, data + offset, nbytes, out);
>         crypto_kunmap(data, 0);
> ....
> }
> 
> It happens as single operation/call.

Well you'd do it as an ahash algorithm, not shash.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
