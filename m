From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] [CRYPTO] add alignment for setkey()
Date: Fri, 18 May 2007 23:46:32 +1000
Message-ID: <20070518134632.GA21326@gondor.apana.org.au>
References: <20070510095717.GD26502@Chamillionaire.breakpoint.cc> <20070518063001.GA16171@gondor.apana.org.au> <20070518134341.GA16349@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2286 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754437AbXERNqn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 May 2007 09:46:43 -0400
Content-Disposition: inline
In-Reply-To: <20070518134341.GA16349@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, May 18, 2007 at 03:43:41PM +0200, Sebastian Siewior wrote:
>
> Good point. I take kmalloc() with GFP_KERNEL (the caller should not be
> atomic at this point). Additionaly I zero the temporary key (I don't
> think the setkey() path is performace critical).

They shouldn't be.  But it would be good if you could do a grep to see
if any of them are doing it in an atomic context since we've not tested
for this before.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
