From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RESEND] padata: make the sequence counter an atomic_t
Date: Wed, 30 Oct 2013 12:11:19 +0800
Message-ID: <20131030041119.GC2957@gondor.apana.org.au>
References: <1380721245-5215-1-git-send-email-mathias.krause@secunet.com>
 <20131008120824.GN7660@secunet.com>
 <526A29E0.8070204@secunet.com>
 <20131025092644.GA20145@gondor.apana.org.au>
 <1382696055-24264-1-git-send-email-mathias.krause@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
To: Mathias Krause <mathias.krause@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:34424 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751498Ab3J3ELU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Oct 2013 00:11:20 -0400
Content-Disposition: inline
In-Reply-To: <1382696055-24264-1-git-send-email-mathias.krause@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 25, 2013 at 12:14:15PM +0200, Mathias Krause wrote:
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
> Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
