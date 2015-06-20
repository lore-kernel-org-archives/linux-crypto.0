From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH v7 00/14] crypto: add a new driver for Marvell's CESA
Date: Sat, 20 Jun 2015 16:32:16 -0400
Message-ID: <CAP=VYLqQynCNRTpm4JnOxeO6DH_739fO2QNcDMxaXqCKCHiTtQ@mail.gmail.com>
References: <1434635190-27733-1-git-send-email-boris.brezillon@free-electrons.com>
 <20150619142444.GA15234@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
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
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Jason Guntho
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20150619142444.GA15234@gondor.apana.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 19, 2015 at 10:24 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Thu, Jun 18, 2015 at 03:46:16PM +0200, Boris Brezillon wrote:
>> Hello,
>>
>> This patch series adds a new driver supporting Marvell's CESA IP.
>> This driver addresses some limitations of the existing one.
>> >From a performance and CPU load point of view the most important
>> limitation in the existing driver is the lack of DMA support, thus
>> preventing us from chaining crypto operations.
>
> All applied to cryptodev.  Thanks a lot!

It seems this breaks linux-next allmodconfig on i386:

http://kisskb.ellerman.id.au/kisskb/buildresult/12445342/

ERROR: "phys_to_dma" [drivers/crypto/marvell/marvell-cesa.ko] undefined!
make[2]: *** [__modpost] Error 1

Paul.
--
