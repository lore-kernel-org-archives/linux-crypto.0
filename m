From: Vakul Garg <vakul.garg@nxp.com>
Subject: RE: [PATCHv2] tls: Add support for encryption using async offload
 accelerator
Date: Thu, 1 Feb 2018 06:17:53 +0000
Message-ID: <HE1PR04MB3082F38B39BCC88D835B12958BFA0@HE1PR04MB3082.eurprd04.prod.outlook.com>
References: <20180131160437.6583-1-vakul.garg@nxp.com>
 <20180131152228.GA24247@davejwatson-mba>
 <HE1PR04MB30827E0097BB30E4E2EE51648BFB0@HE1PR04MB3082.eurprd04.prod.outlook.com>
 <20180131173444.GA41553@davejwatson-mba>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "ilyal@mellanox.com" <ilyal@mellanox.com>,
        "aviadye@mellanox.com" <aviadye@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>
To: Dave Watson <davejwatson@fb.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180131173444.GA41553@davejwatson-mba>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



> -----Original Message-----
> From: Dave Watson [mailto:davejwatson@fb.com]
> Sent: Wednesday, January 31, 2018 11:05 PM
> To: Vakul Garg <vakul.garg@nxp.com>
> Cc: linux-crypto@vger.kernel.org; ilyal@mellanox.com;
> aviadye@mellanox.com; davem@davemloft.net; netdev@vger.kernel.org;
> Gilad Ben-Yossef <gilad@benyossef.com>
> Subject: Re: [PATCHv2] tls: Add support for encryption using async offloa=
d
> accelerator
>=20
> On 01/31/18 05:22 PM, Vakul Garg wrote:
> > > > On second though in stable we should probably just disable async
> > > > tfm allocations.
> > > > It's simpler. But this approach is still good for -next
> > > >
> > > >
> > > > Gilad
> > >
> > > I agree with Gilad, just disable async for now.
> > >
> >
> > How to do it? Can you help with the api name?
>=20
> *aead =3D crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);
>=20
> https://emea01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit
> hub.com%2Fktls%2Fnet_next_ktls%2Fcommit%2Ff3b9b402e755e4b0623fa8
> 3f88137173fc249f2d&data=3D02%7C01%7Cvakul.garg%40nxp.com%7Cf1c707
> 9af97e48c9e89308d568d1633a%7C686ea1d3bc2b4c6fa92cd99c5c301635%
> 7C0%7C0%7C636530170887502735&sdata=3DqTdwbuDsCRmK1UHAYiOcwfPC
> U%2FPXgKg%2BICh%2F2N0b9Nw%3D&reserved=3D0
>=20
=20
The above patch you authored works fine. I tested it on my test platform.
I have nothing to contribute here.
Would you send it to stable kernel yourself or still want me to do it?


> > > If the flag MSG_DONTWAIT is set, we should be returning -EINPROGRESS
> > > and not wait for a response.  I had started working on a patch for
> > > that, but it's pretty tricky to get right.
> >
> > Can you point me to your WIP code branch for this?
>=20
> https://emea01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit
> hub.com%2Fktls%2Fnet_next_ktls%2Fcommit%2F9cc839aa551ed972d148ec
> ebf353b25ee93543b9&data=3D02%7C01%7Cvakul.garg%40nxp.com%7Cf1c70
> 79af97e48c9e89308d568d1633a%7C686ea1d3bc2b4c6fa92cd99c5c301635
> %7C0%7C0%7C636530170887502735&sdata=3D0ASwmPPXXSGCXpBGes9vBma
> y8Gojv0wSUGAOOOjBExc%3D&reserved=3D0
>=20
> > If MSG_DONTWAIT is not used, will it be sane if enqueue the crypto
> > request to accelerator and return to user space back so that user
> > space can send more plaintext data while crypto accelerator is working =
in
> parallel?
>=20
> Right, that's roughly what the above does.  I believe the tricky unfinish=
ed part
> was getting poll() to work correctly if there is an async crypto request
> outstanding.  Currently the tls poll() just relies on backpressure from
> do_tcp_sendpages.
=20
I wanted to add async accelerator support for ktls where multiple crypto re=
quests can be pipelined.
But since you are already doing it, I won't duplicate the efforts.
I would leverage your work on my platform, test it and try to contribute fr=
om here.
