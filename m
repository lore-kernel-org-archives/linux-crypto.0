From: Radu Andrei Alexe <radu.alexe-3arQi8VN3Tc@public.gmane.org>
Subject: Re: [PATCH RESEND 1/4] crypto: caam: add caam-dma node to SEC4.0
 device tree binding
Date: Thu, 9 Nov 2017 11:54:13 +0000
Message-ID: <VI1PR04MB1325BAD68A7CC8C7A302D9A48A570@VI1PR04MB1325.eurprd04.prod.outlook.com>
References: <20171030134654.13729-1-horia.geanta@nxp.com>
 <20171030134654.13729-2-horia.geanta@nxp.com>
 <20171030092424.1279add003c96ced4233bd2d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        "Dan Douglass" <dan.douglass-3arQi8VN3Tc@public.gmane.org>,
        Shawn Guo <shawnguo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        "dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Kim Phillips <kim.phillips-5wv7dgnIgG8@public.gmane.org>,
        =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta-3arQi8VN3Tc@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 10/30/2017 4:24 PM, Kim Phillips wrote:=0A=
> On Mon, 30 Oct 2017 15:46:51 +0200=0A=
> Horia Geant=E3 <horia.geanta-3arQi8VN3Tc@public.gmane.org> wrote:=0A=
> =0A=
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
>> +CAAM DMA Node=0A=
>> +=0A=
>> +    Child node of the crypto node that enables the use of the DMA capab=
ilities=0A=
>> +    of the CAAM by a stand-alone driver. The only required property is =
the=0A=
>> +    "compatible" property. All the other properties are determined from=
=0A=
>> +    the job rings on which the CAAM DMA driver depends (ex: the number =
of=0A=
>> +    dma-channels is equal to the number of defined job rings).=0A=
>> +=0A=
>> +  - compatible=0A=
>> +      Usage: required=0A=
>> +      Value type: <string>=0A=
>> +      Definition: Must include "fsl,sec-v4.0-dma"=0A=
>> +=0A=
>> +EXAMPLE=0A=
>> +  caam-dma {=0A=
>> +    compatible =3D "fsl,sec-v5.4-dma",=0A=
>> +                 "fsl,sec-v5.0-dma",=0A=
>> +                 "fsl,sec-v4.0-dma";=0A=
>> +  }=0A=
> =0A=
> If this isn't describing an aspect of the hardware, then what is it=0A=
> doing in the device tree?=0A=
> =0A=
> Kim=0A=
> =0A=
=0A=
Because the caam_dma driver is a platform driver I needed to create a =0A=
platform device to activate the driver. My thought was that it was =0A=
simpler to implement it using device tree.=0A=
The next patch version will create the platform device dynamically at =0A=
run time.=0A=
=0A=
BR,=0A=
Radu=0A=
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
