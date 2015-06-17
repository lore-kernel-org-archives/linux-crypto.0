From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v7 05/14] crypto: marvell/CESA: add TDMA support
Date: Wed, 17 Jun 2015 23:08:08 +0800
Message-ID: <20150617150808.GA14915@gondor.apana.org.au>
References: <20150617122533.GA13185@gondor.apana.org.au>
 <1434547922-10363-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Arnaud Ebalard <arno@natisbad.org>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	Imre Kaloz <kaloz@openwrt.org>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434547922-10363-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 17, 2015 at 03:32:02PM +0200, Boris Brezillon wrote:
>
> Hi Herbert,
> 
> I send you this patch alone so that you can verify I'm now properly
> manipulating the SG list. Once I have your confirmation I'll send
> the whole series again and annoy all the people in Cc one more time
> ;-).

Thanks.  The only problem that I can see is the fact you're not
checking for req->src == req->dst.  If they're equal then you must
not map it twice.  Instead it should be mapped as DMA_BIDIRECTIONAL.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
