From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta-3arQi8VN3Tc@public.gmane.org>
Subject: Re: [PATCH 0/4] crypto: caam - add Job Ring support for DPAA2 parts
Date: Thu, 3 Aug 2017 08:07:04 +0000
Message-ID: <VI1PR0401MB2591CA6951BDA1C4F5834D9F98B10@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170718153050.15330-1-horia.geanta@nxp.com>
 <20170725132129.GB29754@dragon>
 <VI1PR0401MB2591E386907CD8EA92DED08498B80@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <20170725135000.GC29754@dragon>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "Dan Douglass" <dan.douglass-3arQi8VN3Tc@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        "linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org"
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
To: Shawn Guo <shawnguo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 7/25/2017 4:50 PM, Shawn Guo wrote:=0A=
> On Tue, Jul 25, 2017 at 01:31:52PM +0000, Horia Geant=E3 wrote:=0A=
>> On 7/25/2017 4:22 PM, Shawn Guo wrote:=0A=
>>> On Tue, Jul 18, 2017 at 06:30:46PM +0300, Horia Geant=E3 wrote:=0A=
>>>> This patch set adds support for CAAM's legacy Job Ring backend / inter=
face=0A=
>>>> on platforms having DPAA2 (Datapath Acceleration Architecture v2), lik=
e=0A=
>>>> LS1088A or LS2088A.=0A=
>>>>=0A=
>>>> I would like to get the DT patches through the crypto list (to make su=
re=0A=
>>>> they don't end up merged before driver support).=0A=
>>>=0A=
>>> Unless it's really urgent (usually critical bug fix), the DTS patches=
=0A=
>>> should go through arm-soc tree.  We usually take DTS patches after the=
=0A=
>>> driver counterpart has been accepted by subsystem maintainers, or in th=
e=0A=
>>> best case, has landed on mainline.=0A=
>>=0A=
>> Thanks for the clarification.=0A=
>>=0A=
>> Do I have to re-post the DTS patches once the driver is accepted or a=0A=
>> ping should suffice or...?=0A=
> =0A=
> A ping is sufficient.=0A=
=0A=
Shawn,=0A=
=0A=
Driver support (patch 1/4) has just been applied to the cryptodev-2.6 tree:=
=0A=
297b9cebd2fc crypto: caam/jr - add support for DPAA2 parts=0A=
=0A=
Could you please pick up the DTS patches (2-4/4) in this series?=0A=
=0A=
Thanks,=0A=
Horia=0A=
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
