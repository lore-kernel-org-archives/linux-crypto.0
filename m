From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: use __devexit not __exit in n2_unregister_algs
Date: Thu, 6 Jan 2011 17:15:58 +1100
Message-ID: <20110106061558.GB18939@gondor.apana.org.au>
References: <1294263387-8984-1-git-send-email-dgilmore@redhat.com> <20110105.133858.102556381.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dgilmore@redhat.com, linux-crypto@vger.kernel.org,
	herbert@gondoa.apana.org.au, dennis@daedalus.ausil.us
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:43202 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1AFGQG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Jan 2011 01:16:06 -0500
Content-Disposition: inline
In-Reply-To: <20110105.133858.102556381.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 05, 2011 at 09:38:58PM +0000, David Miller wrote:
> From: Dennis Gilmore <dgilmore@redhat.com>
> Date: Wed,  5 Jan 2011 15:36:27 -0600
> 
> > From: dennis <dennis@daedalus.ausil.us>
> > 
> > fixes fedora sparc build failure, thanks to kylem for helping with debugging
> > 
> > Signed-off-by: Dennis Gilmore <dgilmore@redhat.com>
> 
> Acked-by: David S. Miller <davem@davemloft.net>


Patch applied.  Thanks a lot!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
