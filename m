From: Vakul Garg <vakul.garg@nxp.com>
Subject: RE: [RFC crypto v3 8/9] chtls: Register the ULP
Date: Thu, 8 Feb 2018 10:34:06 +0000
Message-ID: <HE1PR04MB30825F7F830D61D4EA9C52B68BF30@HE1PR04MB3082.eurprd04.prod.outlook.com>
References: <20180125210850.GA69117@davejwatson-mba>
 <CY4PR1201MB0230C0D2D0F24900A084574D97E60@CY4PR1201MB0230.namprd12.prod.outlook.com>
 <CY4PR1201MB0230042A4D0EA83DC8F1BE7397E40@CY4PR1201MB0230.namprd12.prod.outlook.com>
 <20180130171144.GA42146@davejwatson-mba>
 <9e81c5b4-f319-8b33-5dec-dad19582bde4@chelsio.com>
 <20180131164347.GA34501@davejwatson-mba>
 <CY4PR1201MB0230A8289700B877C2CFA71097FB0@CY4PR1201MB0230.namprd12.prod.outlook.com>
 <CY4PR1201MB0230DF6A9692BED46F6A469297F30@CY4PR1201MB0230.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "sd@queasysnail.net" <sd@queasysnail.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "ganeshgr@chelsio.co" <ganeshgr@chelsio.co>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Boris Pismenny <borisp@mellanox.com>,
        Ilya Lesokhin <ilyal@mellanox.com>
To: Atul Gupta <atul.gupta@chelsio.com>,
        Dave Watson <davejwatson@fb.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CY4PR1201MB0230DF6A9692BED46F6A469297F30@CY4PR1201MB0230.namprd12.prod.outlook.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of Atul Gupta
> Sent: Thursday, February 8, 2018 3:56 PM
> To: Dave Watson <davejwatson@fb.com>
> Cc: sd@queasysnail.net; herbert@gondor.apana.org.au; linux-
> crypto@vger.kernel.org; ganeshgr@chelsio.co; netdev@vger.kernel.org;
> davem@davemloft.net; Boris Pismenny <borisp@mellanox.com>; Ilya
> Lesokhin <ilyal@mellanox.com>
> Subject: RE: [RFC crypto v3 8/9] chtls: Register the ULP
>=20
> I thought about this and approach below can avoid new ulp type:
>=20
> 1. Register Inline TLS driver to net TLS
> 2. enable ethtool -K <interface> tls-hw-record-offload on
> 3. Issue " setsockopt(fd, SOL_TCP, TCP_ULP, "tls", sizeof("tls")) " after=
 Bind,
> this will enable user fetch net_device corresponding to ipaadr bound to
> interface, if dev found is the one registered and record-offload enabled,
> program the sk->sk_prot as required.
=20
What happens in case of TLS  clients which do not explicitly call bind() an=
d
rely on kernel to choose an ephemeral port for socket?
Does calling setsockopt after the connection is established fix the problem=
?

> 4. fallback to SW TLS for any other case, bind to inaddr_any falls in thi=
s
> category and need proper handling?
>=20
> tls-hw-record-offload is TLS record offload to HW, which does tx/rx and
> record creation Inline.
>=20
> enum {
>         TLS_BASE_TX,
>         TLS_SW_TX,
>         TLS_RECORD_HW, /* TLS record processed Inline */
>         TLS_NUM_CONFIG,
> };
>=20
> -----Original Message-----
> From: Dave Watson [mailto:davejwatson@fb.com]
> Sent: Wednesday, January 31, 2018 10:14 PM
> To: Atul Gupta <atul.gupta@chelsio.com>
> Cc: sd@queasysnail.net; herbert@gondor.apana.org.au; linux-
> crypto@vger.kernel.org; ganeshgr@chelsio.co; netdev@vger.kernel.org;
> davem@davemloft.net; Boris Pismenny <borisp@mellanox.com>; Ilya
> Lesokhin <ilyal@mellanox.com>
> Subject: Re: [RFC crypto v3 8/9] chtls: Register the ULP
>=20
> On 01/31/18 04:14 PM, Atul Gupta wrote:
> >
> >
> > On Tuesday 30 January 2018 10:41 PM, Dave Watson wrote:
> > > On 01/30/18 06:51 AM, Atul Gupta wrote:
> > >
> > > > What I was referring is that passing "tls" ulp type in setsockopt
> > > > may be insufficient to make the decision when multi HW assist
> > > > Inline TLS solution exists.
> > > Setting the ULP doesn't choose HW or SW implementation, I think that
> > > should be done later when setting up crypto with
> > >
> > > setsockopt(SOL_TLS, TLS_TX, struct crypto_info).
> > setsockpot [mentioned above] is quite late for driver to enable HW
> > implementation, we require something as early as tls_init
> > [setsockopt(sock, SOL_TCP, TCP_ULP, "tls", sizeof("tls"))], for driver
> > to set HW prot and offload connection beside Inline Tx/Rx.
> > >
> > > Any reason we can't use ethtool to choose HW vs SW implementation,
> > > if available on the device?
> > Thought about it,=A0 the interface index is not available to fetch
> > netdev and caps check to set HW prot eg. bind [prot.hash] --> tls_hash =
to
> program HW.
>=20
> Perhaps this is the part I don't follow - why do you need to override has=
h and
> check for LISTEN?  I briefly looked through the patch named "CPL handler
> definition", this looks like it is a full TCP offload?
>=20
> Yes, this is connection and record layer offload, and the reason I used
> different ulp type, need to see what additional info or check can help se=
tup
> the required sk prot.
