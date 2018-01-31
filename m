From: Atul Gupta <atul.gupta@chelsio.com>
Subject: RE: [RFC crypto v3 8/9] chtls: Register the ULP
Date: Wed, 31 Jan 2018 18:28:11 +0000
Message-ID: <CY4PR1201MB0230A8289700B877C2CFA71097FB0@CY4PR1201MB0230.namprd12.prod.outlook.com>
References: <20180125210850.GA69117@davejwatson-mba>
 <CY4PR1201MB0230C0D2D0F24900A084574D97E60@CY4PR1201MB0230.namprd12.prod.outlook.com>
 <CY4PR1201MB0230042A4D0EA83DC8F1BE7397E40@CY4PR1201MB0230.namprd12.prod.outlook.com>
 <20180130171144.GA42146@davejwatson-mba>
 <9e81c5b4-f319-8b33-5dec-dad19582bde4@chelsio.com>
 <20180131164347.GA34501@davejwatson-mba>
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
To: Dave Watson <davejwatson@fb.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180131164347.GA34501@davejwatson-mba>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



-----Original Message-----
From: Dave Watson [mailto:davejwatson@fb.com]=20
Sent: Wednesday, January 31, 2018 10:14 PM
To: Atul Gupta <atul.gupta@chelsio.com>
Cc: sd@queasysnail.net; herbert@gondor.apana.org.au; linux-crypto@vger.kern=
el.org; ganeshgr@chelsio.co; netdev@vger.kernel.org; davem@davemloft.net; B=
oris Pismenny <borisp@mellanox.com>; Ilya Lesokhin <ilyal@mellanox.com>
Subject: Re: [RFC crypto v3 8/9] chtls: Register the ULP

On 01/31/18 04:14 PM, Atul Gupta wrote:
>=20
>=20
> On Tuesday 30 January 2018 10:41 PM, Dave Watson wrote:
> > On 01/30/18 06:51 AM, Atul Gupta wrote:
> >=20
> > > What I was referring is that passing "tls" ulp type in setsockopt=20
> > > may be insufficient to make the decision when multi HW assist=20
> > > Inline TLS solution exists.
> > Setting the ULP doesn't choose HW or SW implementation, I think that=20
> > should be done later when setting up crypto with
> >=20
> > setsockopt(SOL_TLS, TLS_TX, struct crypto_info).
> setsockpot [mentioned above] is quite late for driver to enable HW=20
> implementation, we require something as early as tls_init=20
> [setsockopt(sock, SOL_TCP, TCP_ULP, "tls", sizeof("tls"))], for driver=20
> to set HW prot and offload connection beside Inline Tx/Rx.
> >=20
> > Any reason we can't use ethtool to choose HW vs SW implementation,=20
> > if available on the device?
> Thought about it,=A0 the interface index is not available to fetch=20
> netdev and caps check to set HW prot eg. bind [prot.hash] --> tls_hash to=
 program HW.

Perhaps this is the part I don't follow - why do you need to override hash =
and check for LISTEN?  I briefly looked through the patch named "CPL handle=
r definition", this looks like it is a full TCP offload?

Yes, this is connection and record layer offload, and the reason I used dif=
ferent ulp type, need to see what additional info or check can help setup t=
he required sk prot.
