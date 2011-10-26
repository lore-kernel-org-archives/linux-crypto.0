From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: linux-next: Tree for Oct 25 (crypto)
Date: Wed, 26 Oct 2011 19:15:17 +0200
Message-ID: <20111026191517.71f3aa93@stein>
References: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au>
	<4EA75759.3050900@xenotime.net>
	<20111026062717.GA10230@gondor.apana.org.au>
	<20111026143347.462fea95@stein>
	<4EA8350D.1080003@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Linus <torvalds@linux-foundation.org>,
	linux-crypto@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <4EA8350D.1080003@xenotime.net>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Oct 26 Randy Dunlap wrote:
> On 10/26/11 05:33, Stefan Richter wrote:
> > On Oct 26 Herbert Xu wrote:
> >> --- a/crypto/Kconfig
> >> +++ b/crypto/Kconfig
> >> @@ -103,6 +103,7 @@ config CRYPTO_MANAGER2
> >>  config CRYPTO_USER
> >>  	tristate "Userspace cryptographic algorithm configuration"
> >>  	select CRYPTO_MANAGER
> >> +	select NET
> >>  	help
> >>  	  Userapace configuration for cryptographic instantiations such as

btw, typo: "Userspace"

> >>  	  cbc(aes).
> >>
> >> Cheers,
> > 
> > If you do it this way, you also need to select everything on which NET
> > depends on.  In v3.1, that would be (only) NLATTR which in turn does not
> > depend on anything else.
[...]
> That's correct, but it's better not to "select" an entire subsystem
> like NET at all.

I agree; I add to my comment the implication that --- as a rule of thumb
--- "select" should be avoided if the option to be selected has further
dependencies.

A downside of "config A\n depends on B" is of course that potential users
of option A who are unaware of option B or not interested in B may miss how
to enable A.  Sometimes, a comment in the Kconfig file can help then.
Example (from linux-2.6.36/drivers/ieee1394/):

comment "PCILynx controller requires I2C"
	depends on IEEE1394 && I2C=n

config IEEE1394_PCILYNX
	tristate "PCILynx controller"
	depends on PCI && IEEE1394 && I2C
	select I2C_ALGOBIT
	help
	  Say Y here if you have an IEEE-1394 controller with the Texas
	  Instruments PCILynx chip.
-- 
Stefan Richter
-=====-==-== =-=- ==-=-
http://arcgraph.de/sr/
