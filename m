From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: add new driver for Marvell CESA
Date: Wed, 29 Apr 2015 17:49:02 +0800
Message-ID: <20150429094902.GC9874@gondor.apana.org.au>
References: <1428591523-1780-1-git-send-email-boris.brezillon@free-electrons.com>
 <20150428215232.6834906c@bbrezillon>
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
	Thomas Petazzoni <info@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Arnaud Ebalard <arno@natisbad.org>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150428215232.6834906c@bbrezillon>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 28, 2015 at 09:52:32PM +0200, Boris Brezillon wrote:
> 
> In particular, I'd like to discuss the threaded-irq approach taken in
> this driver (other drivers are using tasklets).
> The main reason behind this choice is the fact that crypto engines
> are quite fast, and I'm worried about the CPU contention that might
> happen in case of fully loaded crypto engines (the CPU might spend most
> of its time in interrupt context until the crypto queue is emptied).
> Using threaded-irq allows preemption of the crypto completion
> operation, thus authorizing another thread (with higher priority) to be
> scheduled. ITOH, the tasklet approach provide slightly performances (I
> don't recall the exact numbers, but Arnaud did some tests).

Either approach is fine with me.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
