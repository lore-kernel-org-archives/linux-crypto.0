From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto_shash_digest API
Date: Tue, 23 Nov 2010 22:42:43 +0800
Message-ID: <20101123144242.GA29858@gondor.apana.org.au>
References: <1290522841.2606.168.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:35495 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab0KWOmp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Nov 2010 09:42:45 -0500
Content-Disposition: inline
In-Reply-To: <1290522841.2606.168.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 23, 2010 at 09:34:01AM -0500, Mimi Zohar wrote:
> Hi!
> 
> Am having problems finding any shash API documentation.  Could someone
> tell me if 'out' needs to be zeroed before calling crypto_shash_digest?
> 
> int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
>                         unsigned int len, u8 *out)

No, out will be filled with the crypto_shash_digestsize bytes
if crypto_shash_digest returns zero.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
