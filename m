From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: Crypto API User-interface
Date: Tue, 7 Sep 2010 10:06:46 -0400
Message-ID: <20100907140646.GA31921@infradead.org>
References: <20100907084213.GA4610@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52386 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab0IGOGr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Sep 2010 10:06:47 -0400
Content-Disposition: inline
In-Reply-To: <20100907084213.GA4610@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 07, 2010 at 04:42:13PM +0800, Herbert Xu wrote:
> Hi:
> 
> This is what I am proposing for the Crypto API user-interface.

Can you explain why we would ever want a userspace interface to it?

doing crypto in kernel for userspace consumers sis simply insane.
It's computational intensive code which has no business in kernel space
unless absolutely required (e.g. for kernel consumers).  In addition
to that adding the context switch overhead and address space transitions
is god awfull too.

This all very much sounds like someone had far too much crack.
