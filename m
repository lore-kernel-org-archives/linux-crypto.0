From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: doc - clarify hash callbacks state machine
Date: Mon, 19 Mar 2018 11:04:24 +0000
Message-ID: <AM3PR04MB4520497CC3D9B2B98B8E63798D40@AM3PR04MB452.eurprd04.prod.outlook.com>
References: <20180305103945.3517-1-horia.geanta@nxp.com>
 <20180316151642.GA6606@gondor.apana.org.au>
 <AM3PR04MB45284A83B66E00785872DE698D40@AM3PR04MB452.eurprd04.prod.outlook.com>
 <20180319092458.GB12302@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 3/19/2018 11:25 AM, Herbert Xu wrote:=0A=
> On Mon, Mar 19, 2018 at 06:39:50AM +0000, Horia Geant=E3 wrote:=0A=
>>=0A=
>> The fact that there can be multiple requests in parallel (for a given tf=
m) is a=0A=
>> different topic.=0A=
>> Each request object has its state in its own state machine, independent =
from the=0A=
>> other request objects.=0A=
>> I assume this is clear enough.=0A=
> =0A=
> My point is that all of the state associated with a request needs=0A=
> to be stored in the request object.  If you're start storing things=0A=
> in the driver/hardware, then things will get ugly one way or another.=0A=
> =0A=
Agree, the request state should be stored in the request object; I am not=
=0A=
debating that.=0A=
=0A=
Still there are limitations even when keeping state in the request object.=
=0A=
For e.g. an implementation cannot DMA map a buffer for the entire lifetime =
of a=0A=
request object, because this lifetime is unknown - user can "abandon" the o=
bject=0A=
after a few .update() calls, or even after .init(). By "abandon" I mean not=
 call=0A=
_ever_ any of .final(), .finup() or .export() on the object.=0A=
=0A=
The only solution to avoid leaks in this case is to repeatedly DMA map & un=
map=0A=
the buffer.=0A=
IOW, if one wants to load/save HW state in a buffer after an .update() and =
to=0A=
instruct the crypto engine to do this operation, the following steps are in=
volved:=0A=
-gpp: DMA map the buffer, get its IOVA=0A=
-gpp: program the crypto engine with IOVA, wait for crypto engine's signal=
=0A=
-crypto engine: load HW state from buffer, perform the partial hash, save H=
W=0A=
state in buffer, signal gpp=0A=
-gpp: DMA unmap the buffer=0A=
=0A=
I'd say this is pretty inefficient, yet I don't see an alternative.=0A=
=0A=
Good or bad, the documentation should reflect this limitation - hence this =
patch.=0A=
=0A=
Thanks,=0A=
Horia=0A=
