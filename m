From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v2 2/7] crypto: add new driver for Marvell CESA
Date: Thu, 7 May 2015 09:18:09 +0200
Message-ID: <20150507091809.2fb5b22e@bbrezillon>
References: <1430742426-21202-1-git-send-email-boris.brezillon@free-electrons.com>
	<1430742426-21202-3-git-send-email-boris.brezillon@free-electrons.com>
	<20150507030100.GA29395@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:46608 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753243AbbEGHSO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 May 2015 03:18:14 -0400
In-Reply-To: <20150507030100.GA29395@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Thu, 7 May 2015 11:01:00 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Mon, May 04, 2015 at 02:27:01PM +0200, Boris Brezillon wrote:
> > The existing mv_cesa driver supports some features of the CESA IP but is
> > quite limited, and reworking it to support new features (like involving the
> > TDMA engine to offload the CPU) is almost impossible.
> > This driver has been rewritten from scratch to take those new features into
> > account.
> > 
> > This new driver adds support for:
> > - new armada SoCs (up to 38x) while keeping support for older ones (Orion
> >   and Kirkwood)
> > - DMA mode to offload the CPU in case of intensive crypto usage
> > - new algorithms: SHA256, DES and 3DES
> > 
> > The existing CESA driver is kept around to ease transition to this new
> > driver (take some time to audit the code and/or wait for users feedback).
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
> 
> This patch is too big for the mailing list.  Please provide a
> URL for people to download and review.

Here [1] is a branch containing the patches submitted in this series.
I guess I won't have other choices but to split this patch (as
Sebastian suggested) in my next iteration :-).

Best Regards,

Boris

[1]https://github.com/bbrezillon/linux-marvell/commits/cesa-v2


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
