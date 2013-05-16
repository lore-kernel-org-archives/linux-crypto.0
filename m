From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 31/39] dmaengine: ste_dma40: Replace ST-E's home-brew DMA
 direction defs with generic ones
Date: Thu, 16 May 2013 08:06:38 +0100
Message-ID: <20130516070638.GC3269@gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-32-git-send-email-lee.jones@linaro.org>
 <20130516051701.GG27639@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	balbi@ti.com, linux-usb@vger.kernel.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	herbert@gondor.hengli.com.au, arnd@arndb.de,
	linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
	Dan Williams <djbw@fb.com>,
	Per Forlin <per.forlin@stericsson.com>,
	Rabin Vincent <rabin@rab.in>
To: Vinod Koul <vinod.koul@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130516051701.GG27639@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 16 May 2013, Vinod Koul wrote:

> On Wed, May 15, 2013 at 10:51:54AM +0100, Lee Jones wrote:
> > STEDMA40_*_TO_* direction definitions are identical in all but name=
 to
> > the pre-defined generic DMA_*_TO_* ones. Let's make things easy by =
not
> > duplicating such things.
> >=20
> > Cc: Vinod Koul <vinod.koul@intel.com>
> > Cc: Dan Williams <djbw@fb.com>
> > Cc: Per Forlin <per.forlin@stericsson.com>
> > Cc: Rabin Vincent <rabin@rab.in>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Nice :)

:)

> 1) I dont see the STE macro getting removed, why do we need it

They are removed later in the set, once their use has been removed
from platform code and all the other drivers.

> 2) last i checked the direction values had a bit idfference b/w what =
you are
> using and what dmaengine defines, so hopefully that is taken care of.=
=2E

Yes, no problem.

<place Ack here> ;)

--=20
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
