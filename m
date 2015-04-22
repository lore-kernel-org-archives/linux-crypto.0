From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: api - Move module sig ifdef into accessor function
Date: Wed, 22 Apr 2015 16:12:20 +0800
Message-ID: <20150422081220.GA9337@gondor.apana.org.au>
References: <20150422032846.GA6798@gondor.apana.org.au>
 <87pp6wodh7.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35055 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267AbbDVIMZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 04:12:25 -0400
Content-Disposition: inline
In-Reply-To: <87pp6wodh7.fsf@rustcorp.com.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 22, 2015 at 04:29:16PM +0930, Rusty Russell wrote:
> Herbert Xu <herbert@gondor.apana.org.au> writes:
> > Currently we're hiding mod->sig_ok under an ifdef in open code.
> > This patch adds a module_sig_ok accessor function and removes that
> > ifdef.
> >     
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Did you want me to take this via modules-next?  Assuming not.
> 
> So:
>         Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks Rusty.  Yes I'd lik to push this through the crypto tree.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
