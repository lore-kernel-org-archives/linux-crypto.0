From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch v3] pcrypt: handle crypto_get_attr_type() errors
Date: Wed, 24 Mar 2010 21:35:50 +0800
Message-ID: <20100324133550.GA9640@gondor.apana.org.au>
References: <20100321092847.GJ5331@bicker> <20100322132342.GJ20508@secunet.com> <20100322135319.GQ21571@bicker> <20100322145357.GK20508@secunet.com> <20100322152845.GT21571@bicker> <20100323103431.GA27822@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Carpenter <error27@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:44600 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755234Ab0CXNgF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Mar 2010 09:36:05 -0400
Content-Disposition: inline
In-Reply-To: <20100323103431.GA27822@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 23, 2010 at 11:34:31AM +0100, Steffen Klassert wrote:
> On Mon, Mar 22, 2010 at 06:28:45PM +0300, Dan Carpenter wrote:
> > I was concerned about the error handling for crypto_get_attr_type() in
> > pcrypt_alloc_aead().  Steffen Klassert pointed out that we could simply
> > avoid calling crypto_get_attr_type() if we passed the type and mask as a
> > parameters.
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Patch applied.  Thanks everyone!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
