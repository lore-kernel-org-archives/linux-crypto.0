From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 02/39] dmaengine: ste_dma40: Remove unnecessary call to
 d40_phy_cfg()
Date: Thu, 16 May 2013 08:25:57 +0100
Message-ID: <20130516072557.GD3269@gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-3-git-send-email-lee.jones@linaro.org>
 <20130516063546.GD14863@intel.com>
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
In-Reply-To: <20130516063546.GD14863@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 16 May 2013, Vinod Koul wrote:

> On Wed, May 15, 2013 at 10:51:25AM +0100, Lee Jones wrote:
> > All configuration left in d40_phy_cfg() is runtime configurable and
> > there is already a call into it from d40_runtime_config(), so let's
> > rely on that.
> >=20
> > Acked-by: Vinod Koul <vnod.koul@intel.com>
> That needs up update!

Ah, where did I get that from that?

Was that my mistake, or was this in the MAINTAINERS file?

> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/dma/ste_dma40.c    |   14 +++---
> >  drivers/dma/ste_dma40_ll.c |  101 +++++++++++++++++++++-----------=
------------
> >  drivers/dma/ste_dma40_ll.h |    3 +-
> >  3 files changed, 58 insertions(+), 60 deletions(-)
> >=20
> > diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> > index 759293e..b7fe46b 100644
> > --- a/drivers/dma/ste_dma40.c
> > +++ b/drivers/dma/ste_dma40.c
> > @@ -2043,6 +2043,14 @@ static int d40_config_memcpy(struct d40_chan=
 *d40c)
> >  	} else if (dma_has_cap(DMA_MEMCPY, cap) &&
> >  		   dma_has_cap(DMA_SLAVE, cap)) {
> >  		d40c->dma_cfg =3D dma40_memcpy_conf_phy;
> > +
> > +		/* Generate interrrupt at end of transfer or relink. */
> > +		d40c->dst_def_cfg |=3D BIT(D40_SREG_CFG_TIM_POS);
> > +
> > +		/* Generate interrupt on error. */
> > +		d40c->src_def_cfg |=3D BIT(D40_SREG_CFG_EIM_POS);
> > +		d40c->dst_def_cfg |=3D BIT(D40_SREG_CFG_EIM_POS);
> > +
> >  	} else {
> >  		chan_err(d40c, "No memcpy\n");
> >  		return -EINVAL;
> > @@ -2496,9 +2504,6 @@ static int d40_alloc_chan_resources(struct dm=
a_chan *chan)
> >  	}
> > =20
> >  	pm_runtime_get_sync(d40c->base->dev);
> > -	/* Fill in basic CFG register values */
> > -	d40_phy_cfg(&d40c->dma_cfg, &d40c->src_def_cfg,
> > -		    &d40c->dst_def_cfg, chan_is_logical(d40c));
> > =20
> >  	d40_set_prio_realtime(d40c);
> > =20
> > @@ -2862,8 +2867,7 @@ static int d40_set_runtime_config(struct dma_=
chan *chan,
> >  	if (chan_is_logical(d40c))
> >  		d40_log_cfg(cfg, &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
> >  	else
> > -		d40_phy_cfg(cfg, &d40c->src_def_cfg,
> > -			    &d40c->dst_def_cfg, false);
> > +		d40_phy_cfg(cfg, &d40c->src_def_cfg, &d40c->dst_def_cfg);
> > =20
> >  	/* These settings will take precedence later */
> >  	d40c->runtime_addr =3D config_addr;
> > diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.=
c
> > index 435a223..ab5a2a7 100644
> > --- a/drivers/dma/ste_dma40_ll.c
> > +++ b/drivers/dma/ste_dma40_ll.c
> > @@ -50,63 +50,58 @@ void d40_log_cfg(struct stedma40_chan_cfg *cfg,
> > =20
> >  }
> > =20
> > -/* Sets up SRC and DST CFG register for both logical and physical =
channels */
> > -void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
> > -		 u32 *src_cfg, u32 *dst_cfg, bool is_log)
> > +void d40_phy_cfg(struct stedma40_chan_cfg *cfg, u32 *src_cfg, u32 =
*dst_cfg)
> >  {
> >  	u32 src =3D 0;
> >  	u32 dst =3D 0;
> > =20
> > -	if (!is_log) {
> > -		/* Physical channel */
> > -		if ((cfg->dir =3D=3D  STEDMA40_PERIPH_TO_MEM) ||
> > -		    (cfg->dir =3D=3D STEDMA40_PERIPH_TO_PERIPH)) {
> > -			/* Set master port to 1 */
> > -			src |=3D 1 << D40_SREG_CFG_MST_POS;
> > -			src |=3D D40_TYPE_TO_EVENT(cfg->dev_type);
> > -
> > -			if (cfg->src_info.flow_ctrl =3D=3D STEDMA40_NO_FLOW_CTRL)
> > -				src |=3D 1 << D40_SREG_CFG_PHY_TM_POS;
> > -			else
> > -				src |=3D 3 << D40_SREG_CFG_PHY_TM_POS;
> > -		}
> > -		if ((cfg->dir =3D=3D  STEDMA40_MEM_TO_PERIPH) ||
> > -		    (cfg->dir =3D=3D STEDMA40_PERIPH_TO_PERIPH)) {
> > -			/* Set master port to 1 */
> > -			dst |=3D 1 << D40_SREG_CFG_MST_POS;
> > -			dst |=3D D40_TYPE_TO_EVENT(cfg->dev_type);
> > -
> > -			if (cfg->dst_info.flow_ctrl =3D=3D STEDMA40_NO_FLOW_CTRL)
> > -				dst |=3D 1 << D40_SREG_CFG_PHY_TM_POS;
> > -			else
> > -				dst |=3D 3 << D40_SREG_CFG_PHY_TM_POS;
> > -		}
> > -		/* Interrupt on end of transfer for destination */
> > -		dst |=3D 1 << D40_SREG_CFG_TIM_POS;
> > -
> > -		/* Generate interrupt on error */
> > -		src |=3D 1 << D40_SREG_CFG_EIM_POS;
> > -		dst |=3D 1 << D40_SREG_CFG_EIM_POS;
> > -
> > -		/* PSIZE */
> > -		if (cfg->src_info.psize !=3D STEDMA40_PSIZE_PHY_1) {
> > -			src |=3D 1 << D40_SREG_CFG_PHY_PEN_POS;
> > -			src |=3D cfg->src_info.psize << D40_SREG_CFG_PSIZE_POS;
> > -		}
> > -		if (cfg->dst_info.psize !=3D STEDMA40_PSIZE_PHY_1) {
> > -			dst |=3D 1 << D40_SREG_CFG_PHY_PEN_POS;
> > -			dst |=3D cfg->dst_info.psize << D40_SREG_CFG_PSIZE_POS;
> > -		}
> > -
> > -		/* Element size */
> > -		src |=3D cfg->src_info.data_width << D40_SREG_CFG_ESIZE_POS;
> > -		dst |=3D cfg->dst_info.data_width << D40_SREG_CFG_ESIZE_POS;
> > -
> > -		/* Set the priority bit to high for the physical channel */
> > -		if (cfg->high_priority) {
> > -			src |=3D 1 << D40_SREG_CFG_PRI_POS;
> > -			dst |=3D 1 << D40_SREG_CFG_PRI_POS;
> > -		}
> > +	if ((cfg->dir =3D=3D  STEDMA40_PERIPH_TO_MEM) ||
> > +	    (cfg->dir =3D=3D STEDMA40_PERIPH_TO_PERIPH)) {
> > +		/* Set master port to 1 */
> > +		src |=3D 1 << D40_SREG_CFG_MST_POS;
> > +		src |=3D D40_TYPE_TO_EVENT(cfg->dev_type);
> > +
> > +		if (cfg->src_info.flow_ctrl =3D=3D STEDMA40_NO_FLOW_CTRL)
> > +			src |=3D 1 << D40_SREG_CFG_PHY_TM_POS;
> > +		else
> > +			src |=3D 3 << D40_SREG_CFG_PHY_TM_POS;
> > +	}
> > +	if ((cfg->dir =3D=3D  STEDMA40_MEM_TO_PERIPH) ||
> > +	    (cfg->dir =3D=3D STEDMA40_PERIPH_TO_PERIPH)) {
> > +		/* Set master port to 1 */
> > +		dst |=3D 1 << D40_SREG_CFG_MST_POS;
> > +		dst |=3D D40_TYPE_TO_EVENT(cfg->dev_type);
> > +
> > +		if (cfg->dst_info.flow_ctrl =3D=3D STEDMA40_NO_FLOW_CTRL)
> > +			dst |=3D 1 << D40_SREG_CFG_PHY_TM_POS;
> > +		else
> > +			dst |=3D 3 << D40_SREG_CFG_PHY_TM_POS;
> > +	}
> > +	/* Interrupt on end of transfer for destination */
> > +	dst |=3D 1 << D40_SREG_CFG_TIM_POS;
> > +
> > +	/* Generate interrupt on error */
> > +	src |=3D 1 << D40_SREG_CFG_EIM_POS;
> > +	dst |=3D 1 << D40_SREG_CFG_EIM_POS;
> > +
> > +	/* PSIZE */
> > +	if (cfg->src_info.psize !=3D STEDMA40_PSIZE_PHY_1) {
> > +		src |=3D 1 << D40_SREG_CFG_PHY_PEN_POS;
> > +		src |=3D cfg->src_info.psize << D40_SREG_CFG_PSIZE_POS;
> > +	}
> > +	if (cfg->dst_info.psize !=3D STEDMA40_PSIZE_PHY_1) {
> > +		dst |=3D 1 << D40_SREG_CFG_PHY_PEN_POS;
> > +		dst |=3D cfg->dst_info.psize << D40_SREG_CFG_PSIZE_POS;
> > +	}
> > +
> > +	/* Element size */
> > +	src |=3D cfg->src_info.data_width << D40_SREG_CFG_ESIZE_POS;
> > +	dst |=3D cfg->dst_info.data_width << D40_SREG_CFG_ESIZE_POS;
> > +
> > +	/* Set the priority bit to high for the physical channel */
> > +	if (cfg->high_priority) {
> > +		src |=3D 1 << D40_SREG_CFG_PRI_POS;
> > +		dst |=3D 1 << D40_SREG_CFG_PRI_POS;
> >  	}
> > =20
> >  	if (cfg->src_info.big_endian)
> > diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.=
h
> > index fdde8ef..1b47312 100644
> > --- a/drivers/dma/ste_dma40_ll.h
> > +++ b/drivers/dma/ste_dma40_ll.h
> > @@ -432,8 +432,7 @@ enum d40_lli_flags {
> > =20
> >  void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
> >  		 u32 *src_cfg,
> > -		 u32 *dst_cfg,
> > -		 bool is_log);
> > +		 u32 *dst_cfg);
> > =20
> >  void d40_log_cfg(struct stedma40_chan_cfg *cfg,
> >  		 u32 *lcsp1,

--=20
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
