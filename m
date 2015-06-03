From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 0/9] crypto: Add ChaCha20-Poly1305 AEAD support for IPsec
Date: Wed, 3 Jun 2015 09:53:37 +0200
Message-ID: <20150603075336.GA14200@secunet.com>
References: <1433159044-30753-1-git-send-email-martin@strongswan.org>
 <20150603024425.GA2553@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Martin Willi <martin@strongswan.org>,
	<linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:49316 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbbFCHxk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 03:53:40 -0400
Content-Disposition: inline
In-Reply-To: <20150603024425.GA2553@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 03, 2015 at 10:44:25AM +0800, Herbert Xu wrote:
> On Mon, Jun 01, 2015 at 01:43:55PM +0200, Martin Willi wrote:
> > This is a first version of a patch series implementing the ChaCha20-Poly1305
> > AEAD construction defined in RFC7539. It is based on the current cryptodev tree.
> 
> The patches look fine to me.  Steffen, what do you think?

I'm fine with this. If you want to merge this series through the
cryptodev tree, feel free to add a

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
