From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] crypto/ablkcipher: missing return statement
Date: Fri, 16 Jul 2010 10:23:11 +0800
Message-ID: <20100716022311.GA28155@gondor.apana.org.au>
References: <20100715075736.GC5164@bicker> <20100715.192141.242121343.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: error27@gmail.com, richih.mailinglist@gmail.com,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:58472 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935279Ab0GPCXU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Jul 2010 22:23:20 -0400
Content-Disposition: inline
In-Reply-To: <20100715.192141.242121343.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 15, 2010 at 07:21:41PM -0700, David Miller wrote:
> From: Dan Carpenter <error27@gmail.com>
> Date: Thu, 15 Jul 2010 09:57:36 +0200
> 
> > The intent was to return here.  In the original an allocation failure
> > would lead to a NULL dereference.
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks, applied to crypto-2.6.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
