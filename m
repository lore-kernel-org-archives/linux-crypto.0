From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [RFC] [PATCH v2 0/4] Parallel IPsec
Date: Sat, 25 Apr 2009 14:10:19 +0400
Message-ID: <20090425101019.GA28498@ioremap.net>
References: <20090424102451.GB12680@secunet.com> <20090425083849.GD26070@ioremap.net> <20090425092142.GA5830@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cs-studio.ru ([195.178.208.66]:35905 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbZDYKK3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 25 Apr 2009 06:10:29 -0400
Content-Disposition: inline
In-Reply-To: <20090425092142.GA5830@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 25, 2009 at 05:21:42PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > Why can't it be used by default for all crypto operations instead of
> > synchronous one?
> 
> PCI-based drivers will not benefit from spreading the requests
> across CPUs.  If anything they will suffer from the synchronisation.

What's the deal PCI drivers have with CPUs data comes from/to?
They do not touch cache, just run DMA transfer and complete the request.

-- 
	Evgeniy Polyakov
