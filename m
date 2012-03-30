From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: pcrypt - Use the online cpumask as the default
Date: Fri, 30 Mar 2012 17:21:00 +0800
Message-ID: <20120330092100.GB27551@gondor.apana.org.au>
References: <20120328065103.GH16191@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:35791 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756782Ab2C3JVE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Mar 2012 05:21:04 -0400
Content-Disposition: inline
In-Reply-To: <20120328065103.GH16191@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 28, 2012 at 08:51:03AM +0200, Steffen Klassert wrote:
> We use the active cpumask to determine the superset of cpus
> to use for parallelization. However, the active cpumask is
> for internal usage of the scheduler and therefore not the
> appropriate cpumask for these purposes. So use the online
> cpumask instead.
> 
> Reported-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Applied to crypto.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
