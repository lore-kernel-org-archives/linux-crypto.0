From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH 3/5] eseqiv: Add support for aead algorithms
Date: Mon, 29 Jun 2009 13:12:08 +0200
Message-ID: <20090629111208.GF20366@secunet.com>
References: <20090608070749.GR20366@secunet.com> <20090608071046.GU20366@secunet.com> <20090625104602.GA1528@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:58672 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbZF2LJc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Jun 2009 07:09:32 -0400
Content-Disposition: inline
In-Reply-To: <20090625104602.GA1528@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 25, 2009 at 06:46:02PM +0800, Herbert Xu wrote:
> On Mon, Jun 08, 2009 at 09:10:46AM +0200, Steffen Klassert wrote:
> > This adds eseqiv support for aead algorithms, this is usefull
> > for aead algorithms that need eseqiv as it's default IV generator.
> > 
> > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> 
> I'm going to change the default sync geniv to eseqiv for SMP.
> That should render this patch unnecessary, right?
> 

Right, this would reduce the patchset to the padata and the pcrypt
patch. I'll strip the patchset to these two patches as soon as I see
your patch applied to cryptodev-2.6.
