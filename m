From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 02/39] dmaengine: ste_dma40: Remove unnecessary call to
 d40_phy_cfg()
Date: Thu, 16 May 2013 11:59:59 +0100
Message-ID: <20130516105959.GI3269@gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-3-git-send-email-lee.jones@linaro.org>
 <20130516063546.GD14863@intel.com>
 <20130516072557.GD3269@gmail.com>
 <20130516094014.GJ14863@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	balbi@ti.com, linux-usb@vger.kernel.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	herbert@gondor.hengli.com.au, arnd@arndb.de,
	linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com
To: Vinod Koul <vinod.koul@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130516094014.GJ14863@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 16 May 2013, Vinod Koul wrote:

> On Thu, May 16, 2013 at 08:25:57AM +0100, Lee Jones wrote:
> > On Thu, 16 May 2013, Vinod Koul wrote:
> >=20
> > > On Wed, May 15, 2013 at 10:51:25AM +0100, Lee Jones wrote:
> > > > All configuration left in d40_phy_cfg() is runtime configurable=
 and
> > > > there is already a call into it from d40_runtime_config(), so l=
et's
> > > > rely on that.
> > > >=20
> > > > Acked-by: Vinod Koul <vnod.koul@intel.com>
> > > That needs up update!
> >=20
> > Ah, where did I get that from that?
> >=20
> > Was that my mistake, or was this in the MAINTAINERS file?
> Certainly not in MAINTAINERS file :)

My bad then, sorry.

Linus,

Would you be kind enough to fix it please, as it's in your tree now.
--=20
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
