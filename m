From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta-3arQi8VN3Tc@public.gmane.org>
Subject: Re: [PATCH 0/4] add CAAM DMA memcpy driver
Date: Fri, 27 Oct 2017 11:00:18 +0000
Message-ID: <VI1PR0402MB33422B48B506D7FF6A894AE0985A0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <20171026100008.32169-1-radu.alexe@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Radu Andrei Alexe <radu.alexe-3arQi8VN3Tc@public.gmane.org>,
        "vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        "herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org" <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Dan Douglass <dan.douglass-3arQi8VN3Tc@public.gmane.org>,
        "shawnguo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <shawnguo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 10/26/2017 1:01 PM, Radu Alexe wrote:=0A=
> This patch-set introduces a new DMA memcpy driver based on the DMA=0A=
> capabilities of the CAAM crypto engine. Because of this dependency the=0A=
> included commits target various parts of the kernel tree.=0A=
I don't see the patches on any of the mail lists.=0A=
If they are moderated, I would expect this to be mentioned in the=0A=
MAINTAINERS file.=0A=
=0A=
> =0A=
> Patch 1.=0A=
> Since the CAAM DMA driver is a platform driver it is enabled by a new nod=
e=0A=
> in the device tree. This commit adds documentation for the device tree=0A=
> bindings.=0A=
> =0A=
> Patch 2.=0A=
> This patch adds the "caam-dma" node in the fsl-ls1012a.dtsi file.=0A=
> =0A=
> Patch 3.=0A=
> This commit adds various capabilities in the JR driver of the CAAM that i=
s=0A=
> used by the CAAM DMA driver.=0A=
> =0A=
> Patch 4.=0A=
> Adds the CAAM DMA memcpy driver.=0A=
> =0A=
> Patch 1 and 3 should be merged by the crypto maintainers, patch 2 by=0A=
> devicetree maintainers and patch 4 by the DMA maintainers.=0A=
I would go with all the patches through the dmaengine tree.=0A=
=0A=
Horia=0A=
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
