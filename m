From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: blowfish-x86_64: fix ctr blocksize to 1
Date: Fri, 21 Oct 2011 14:19:08 +0200
Message-ID: <20111021121908.GA15139@gondor.apana.org.au>
References: <20111010093215.7547.44692.stgit@localhost6.localdomain6> <20111021121749.GA15115@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:53163 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab1JUMTK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Oct 2011 08:19:10 -0400
Content-Disposition: inline
In-Reply-To: <20111021121749.GA15115@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 21, 2011 at 02:17:49PM +0200, Herbert Xu wrote:
> On Mon, Oct 10, 2011 at 12:32:15PM +0300, Jussi Kivilinna wrote:
> > Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> 
> What is the rationale for this? Blowfish is not a stream cipher.

Scratch that, I missed the bit about ctr.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
