From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: caam - performance fixes/improvements
Date: Mon, 25 Jan 2016 15:11:03 +0800
Message-ID: <20160125071103.GA5609@gondor.apana.org.au>
References: <1452611650-15803-1-git-send-email-horia.geanta@nxp.com>
 <56A25E3F.8070004@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@nxp.com>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>,
	Scott Wood <scott.wood@nxp.com>
To: Horia Ioan Geanta Neag <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40065 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbcAYHLJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 02:11:09 -0500
Content-Disposition: inline
In-Reply-To: <56A25E3F.8070004@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 22, 2016 at 04:52:36PM +0000, Horia Ioan Geanta Neag wrote:
> Herbert, I see that you've sent the crypto fixes for 4.5 pull request.
> Any reason why these patches were not included?
> I was expecting at least the first one to get it, it's even Cc-ing stable.

Well the second patch is definitely too late for 4.5. In future
please don't bundle patches together unless they are all obviously
critical bug fixes or they may all be postponed to the next merge
window.

I'll look at the first patch again.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
