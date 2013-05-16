From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 01/39] dmaengine: ste_dma40: Separate Logical Global
 Interrupt Mask (GIM) unmasking
Date: Thu, 16 May 2013 08:26:34 +0100
Message-ID: <20130516072634.GE3269@gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-2-git-send-email-lee.jones@linaro.org>
 <CACRpkdZJp-WRGNgzwqERVBtb_WxQGybmMjnnLTAoX66qECNh7g@mail.gmail.com>
 <20130516063513.GC14863@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linus Walleij <linus.walleij@linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Felipe Balbi <balbi@ti.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Rabin Vincent <rabin@rab.in>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
	Per Forlin <per.forlin@stericsson.com>,
	Dan Williams <djbw@fb.com>
To: Vinod Koul <vinod.koul@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130516063513.GC14863@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 16 May 2013, Vinod Koul wrote:

> On Wed, May 15, 2013 at 06:29:51PM +0200, Linus Walleij wrote:
> > On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> =
wrote:
> >=20
> > > During the initial setup of a logical channel, it is necessary to=
 unmask
> > > the GIM in order to receive generated terminal count and error in=
terrupts.
> > > We're separating out this required code so it will be possible to=
 move
> > > the remaining code in d40_phy_cfg(), which is mostly runtime conf=
iguration
> > > into the runtime_config() routine.
> > >
> > > Cc: Vinod Koul <vinod.koul@intel.com>
> > > Cc: Dan Williams <djbw@fb.com>
> > > Cc: Per Forlin <per.forlin@stericsson.com>
> > > Cc: Rabin Vincent <rabin@rab.in>
> > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >=20
> > Tentatively applied to my ux500-dma40 branch.
> >=20
> > This lacks an ACK from Vinod...
> Acked-by: Vinod Koul <vinod.koul@intel.com>
> >=20
> > I cannot get any of this stack of patches up to ARM SoC
> > before I have Vinod's ACK on all hitting drivers/dma/*
> Wip ... :)

Nice! :)

--=20
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
