From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/6] staging: lustre: Use ahash
Date: Thu, 4 Feb 2016 11:17:13 +0800
Message-ID: <20160204031713.GB1782@gondor.apana.org.au>
References: <20160201133405.GA10754@gondor.apana.org.au>
 <E1aQEez-0002pe-RL@gondolin.me.apana.org.au>
 <20160203224857.GA20244@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	devel@driverdev.osuosl.org
To: Greg KH <greg@kroah.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34855 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965263AbcBDDRR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Feb 2016 22:17:17 -0500
Content-Disposition: inline
In-Reply-To: <20160203224857.GA20244@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 03, 2016 at 02:48:57PM -0800, Greg KH wrote:
>
> This change breaks the build for me so I can't take this through my
> tree.  I'm hoping you have a patch earlier in the series that adds these
> functions, if so, feel free to take this through your tree:

Sorry I should've CCed you on the earlier patches in the series too.
But yes it would be easier to take this through the cryptodev tree
as a later patch removes the crypto_hash interface.

> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
