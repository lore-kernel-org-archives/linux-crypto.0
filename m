From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: Crypto API User-interface
Date: Tue, 7 Sep 2010 10:59:36 -0400
Message-ID: <20100907145936.GA23178@infradead.org>
References: <20100907084213.GA4610@gondor.apana.org.au>
 <20100907140646.GA31921@infradead.org>
 <AANLkTinfQprsNC2ipocUKUWv894mbVtnDoxd5as9kCt-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40832 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab0IGO7k (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Sep 2010 10:59:40 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTinfQprsNC2ipocUKUWv894mbVtnDoxd5as9kCt-@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 07, 2010 at 04:57:04PM +0200, Nikos Mavrogiannopoulos wrote:
> Or that someone is not really aware of some cryptographic uses.
> Embedded systems have crypto accelerators in hardware available
> through kernel device drivers. In the systems I worked the
> accelerators via a crypto device interface gave a 50x to 100x boost in
> crypto operations and relieved the CPU from doing them.

An interface to external crypto co-process _can_ be useful.  It
certainly isn't for the tiny requests where mr crackhead complains about
the overhead.   So if we do want to design an interface for addons cards
we need to expose a threshold from which it makes sense to use it, and
not even bother using for the simply software in-kernel algorithms.

Which is something that could be done easily using a variant of
Herbert's interface.
