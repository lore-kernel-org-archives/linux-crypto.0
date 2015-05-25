From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 01/16] crypto: mv_cesa: request registers memory region
Date: Mon, 25 May 2015 20:56:40 +0800
Message-ID: <20150525125640.GA30783@gondor.apana.org.au>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
 <1432301642-11470-2-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33606 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbbEYM5R (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 May 2015 08:57:17 -0400
Content-Disposition: inline
In-Reply-To: <1432301642-11470-2-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 22, 2015 at 03:33:47PM +0200, Boris Brezillon wrote:
> The mv_cesa driver does not request the CESA registers memory region.
> Since we're about to add a new CESA driver, we need to make sure only one
> of these drivers probe the CESA device, and requesting the registers memory
> region is a good way to achieve that.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
