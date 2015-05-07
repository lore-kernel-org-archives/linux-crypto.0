From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 2/7] crypto: add new driver for Marvell CESA
Date: Thu, 7 May 2015 11:01:00 +0800
Message-ID: <20150507030100.GA29395@gondor.apana.org.au>
References: <1430742426-21202-1-git-send-email-boris.brezillon@free-electrons.com>
 <1430742426-21202-3-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Arnaud Ebalard <arno@natisbad.org>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57036 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbbEGDBm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 May 2015 23:01:42 -0400
Content-Disposition: inline
In-Reply-To: <1430742426-21202-3-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 04, 2015 at 02:27:01PM +0200, Boris Brezillon wrote:
> The existing mv_cesa driver supports some features of the CESA IP but is
> quite limited, and reworking it to support new features (like involving the
> TDMA engine to offload the CPU) is almost impossible.
> This driver has been rewritten from scratch to take those new features into
> account.
> 
> This new driver adds support for:
> - new armada SoCs (up to 38x) while keeping support for older ones (Orion
>   and Kirkwood)
> - DMA mode to offload the CPU in case of intensive crypto usage
> - new algorithms: SHA256, DES and 3DES
> 
> The existing CESA driver is kept around to ease transition to this new
> driver (take some time to audit the code and/or wait for users feedback).
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Signed-off-by: Arnaud Ebalard <arno@natisbad.org>

This patch is too big for the mailing list.  Please provide a
URL for people to download and review.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
