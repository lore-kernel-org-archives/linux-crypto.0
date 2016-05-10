From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 2/8] asm-generic/io.h: add io{read,write}64 accessors
Date: Tue, 10 May 2016 17:34:47 +0800
Message-ID: <20160510093447.GA15756@gondor.apana.org.au>
References: <1462462435-27403-1-git-send-email-horia.geanta@nxp.com>
 <1462462556-27684-1-git-send-email-horia.geanta@nxp.com>
 <20160510093321.GA15677@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Scott Wood <scott.wood@nxp.com>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Cristian Stoica <cristian.stoica@nxp.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160510093321.GA15677@gondor.apana.org.au>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 10, 2016 at 05:33:21PM +0800, Herbert Xu wrote:
> On Thu, May 05, 2016 at 06:35:56PM +0300, Horia Geant=C4=83 wrote:
> > This will allow device drivers to consistently use io{read,write}XX
> > also for 64-bit accesses.
> >=20
> > Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
>=20
> I don't see patch 1/8.

Never mind, I've found it now.

Cheers,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
