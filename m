From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] padata: make the sequence counter an atomic_t
Date: Tue, 8 Oct 2013 14:08:24 +0200
Message-ID: <20131008120824.GN7660@secunet.com>
References: <1380721245-5215-1-git-send-email-mathias.krause@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Mathias Krause <mathias.krause@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:60660 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab3JHMI0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Oct 2013 08:08:26 -0400
Content-Disposition: inline
In-Reply-To: <1380721245-5215-1-git-send-email-mathias.krause@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 02, 2013 at 03:40:45PM +0200, Mathias Krause wrote:
> Using a spinlock to atomically increase a counter sounds wrong -- we've
> atomic_t for this!
> 
> Also move 'seq_nr' to a different cache line than 'lock' to reduce cache
> line trashing. This has the nice side effect of decreasing the size of
> struct parallel_data from 192 to 128 bytes for a x86-64 build, e.g.
> occupying only two instead of three cache lines.
> 
> Those changes results in a 5% performance increase on an IPsec test run
> using pcrypt.
> 
> Btw. the seq_lock spinlock was never explicitly initialized -- one more
> reason to get rid of it.
> 
> Signed-off-by: Mathias Krause <mathias.krause@secunet.com>

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Herbert can you take this one?
