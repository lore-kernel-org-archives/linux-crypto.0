From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/2] crypto: caam - make write transactions bufferable
 on PPC platforms
Date: Mon, 25 Jan 2016 21:59:24 +0800
Message-ID: <20160125135924.GC8256@gondor.apana.org.au>
References: <1452611650-15803-2-git-send-email-horia.geanta@nxp.com>
 <1452614369-21252-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@nxp.com>,
	Alex Porosanu <alexandru.porosanu@nxp.com>,
	Scott Wood <scott.wood@nxp.com>, stable@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452614369-21252-1-git-send-email-horia.geanta@nxp.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 12, 2016 at 05:59:29PM +0200, Horia Geant=C4=83 wrote:
> Previous change (see "Fixes" tag) to the MCFGR register
> clears AWCACHE[0] ("bufferable" AXI3 attribute) (which is "1" at POR)=
=2E
>=20
> This makes all writes non-bufferable, causing a ~ 5% performance drop
> for PPC-based platforms.
>=20
> Rework previous change such that MCFGR[AWCACHE]=3D4'b0011
> (bufferable + cacheable) for all platforms.
> Note: For ARM-based platforms, AWCACHE[0] is ignored
> by the interconnect IP.
>=20
> Cc: <stable@vger.kernel.org> # 4.3+
> Fixes: f10967495144 ("crypto: caam - fix snooping for write transacti=
ons")
> Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>

Patch applied.  Thanks!
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
