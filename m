From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: lzo: use kvfree() helper
Date: Wed, 25 Jun 2014 21:56:29 +0800
Message-ID: <20140625135629.GG10379@gondor.apana.org.au>
References: <1401211735.5367.254.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140620184053.GC3169@gondor.apana.org.au>
 <1403598225.27425.9.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Seth Jennings <sjennings@variantweb.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:59356 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444AbaFYN4c (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Jun 2014 09:56:32 -0400
Content-Disposition: inline
In-Reply-To: <1403598225.27425.9.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 24, 2014 at 01:23:45AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> kvfree() helper is now available, use it instead of open code it.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
