From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] Added CRYPTO_ALG_KERN_DRIVER_ONLY flag (3rd
	attempt)
Date: Fri, 6 Jan 2012 19:28:24 +1100
Message-ID: <20120106082824.GA9152@gondor.apana.org.au>
References: <20120106013701.GA6484@gondor.apana.org.au> <4F06AE75.9050806@gnutls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:42019 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab2AFI22 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Jan 2012 03:28:28 -0500
Content-Disposition: inline
In-Reply-To: <4F06AE75.9050806@gnutls.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 06, 2012 at 09:19:01AM +0100, Nikos Mavrogiannopoulos wrote:
>
> I needed this function in order to access the new flag without
> relying on the structure format. The available crypto_tfm_alg_type() 
> would apply a mask and remove it, thus I added this function.

Can you show me some example code so I can see how you intend
to use it in userspace?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
