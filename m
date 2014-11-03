From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security System crypto
 accelerator
Date: Mon, 3 Nov 2014 18:35:28 +0800
Message-ID: <20141103103528.GA30154@gondor.apana.org.au>
References: <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com>
 <20141021191149.GQ21108@lukather>
 <544A9FEA.6020304@gmail.com>
 <20141030171933.GR21251@lukather>
 <20141031072030.GA7563@gondor.apana.org.au>
 <20141031081323.GS21251@lukather>
 <20141031081803.GA8012@gondor.apana.org.au>
 <20141031095706.GA8054@lukather>
 <20141031100522.GA8655@gondor.apana.org.au>
 <20141103093446.GG11263@lukather>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Corentin LABBE <clabbe.montjoie@gmail.com>, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	linux@arm.linux.org.uk, davem@davemloft.net,
	grant.likely@linaro.org, akpm@linux-foundation.org,
	gregkh@linuxfoundation.org, joe@perches.com,
	mchehab@osg.samsung.com, crope@iki.fi, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-sunxi@googlegroups.com
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141103093446.GG11263@lukather>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 03, 2014 at 10:34:46AM +0100, Maxime Ripard wrote:
> What I mean is that since you are saying that drivers should do the
> kmap themselves, then *all* of the drivers are broken if they are not
> using it. And all of them are missing this kmap.

kmap is used by the software implementations to map the input/output
into virtual address space.  Drivers typically use DMA and operate
on physical addresses so they don't need kmap.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
