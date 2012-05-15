From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: aesni-intel: use crypto_[un]register_algs
Date: Tue, 15 May 2012 17:28:04 +1000
Message-ID: <20120515072804.GB24175@gondor.apana.org.au>
References: <20120511130048.26495.55851.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Huang Ying <ying.huang@intel.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:53156 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757113Ab2EOH2J (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 May 2012 03:28:09 -0400
Content-Disposition: inline
In-Reply-To: <20120511130048.26495.55851.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 11, 2012 at 04:00:48PM +0300, Jussi Kivilinna wrote:
> Combine all crypto_alg to be registered and use new crypto_[un]register_algs
> functions. Simplifies init/exit code and reduce object size.
> 
> Cc: Huang Ying <ying.huang@intel.com>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Both patches applied.  Thanks Jussi.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
