From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 0/2] crypto: add new driver for Marvell CESA
Date: Thu, 9 Apr 2015 17:57:35 +0200
Message-ID: <20150409175735.342d0111@bbrezillon>
References: <1428591523-1780-1-git-send-email-boris.brezillon@free-electrons.com>
	<55269C05.2060401@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
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
	Andrew Lunn <andrew@lunn.ch>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Arnaud Ebalard <arno@natisbad.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55269C05.2060401@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Sebastian,

On Thu, 09 Apr 2015 17:34:29 +0200
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:

> 
> if you include a bunch of performance measurements, I guess it will help
> you to get an agreement of replacing the driver instead of reworking it.

Yep, I made some measurements using tcrypt a while ago, I'll provide
them in the next round.

> 
> > Here are the main features brought by this new driver:
> > - support for armada SoCs (up to 38x) while keeping support for older ones
> >    (Orion and Kirkwood)
> 
> Unfortunately, the list above is missing Dove SoCs which also have a
> CESA engine with TDMA support. I checked the registers _very_ quickly
> but it seems that they are compatible with Kirkwood's CESA.

I checked it too: it should work, but I don't have any board to test
it :-/.

> 
> > - DMA mode to offload the CPU in case of intensive crypto usage
> > - new algorithms: SHA256, DES and 3DES
> >
> [...]
> > Boris Brezillon (2):
> >    crypto: add new driver for Marvell CESA
> >    crypto: marvell/CESA: update DT bindings documentation
> 
> IMHO, the patch set should be split up in:
> - new core driver
> - add support for TDMA on platforms that support it
> - new cipher algorithms
> - removal of old mv_cesa

I agree for the 2 steps operation:
- add new driver code without compiling it
- remove old code, update Kconfig (add new dependencies) and Makefile
  entries (compile the code in marvell/ instead of mv_cesa.c)

Is there a good reason for separating the core, TDMA and algorithms
support in different patches (keep Arnaud's authorship ?) ?
Anyway, this should be feasible, but I thought the policy was to
minimize the number of patches when submitting new drivers.

> 
> I'd love to test on Dove, but time still is very limited. I guess the
> patches will receive another round anyway, maybe I find some until the
> final version.

No problem (thanks for the offer).

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
