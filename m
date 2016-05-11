From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v2 4/8] powerpc: add io{read,write}64 accessors
Date: Wed, 11 May 2016 10:35:04 +1000
Message-ID: <1462926904.10184.2.camel@ellerman.id.au>
References: <1462462435-27403-1-git-send-email-horia.geanta@nxp.com>
	 <1462462573-27779-1-git-send-email-horia.geanta@nxp.com>
	 <AM2PR04MB0673A09EBC13818E0C2D764E98700@AM2PR04MB0673.eurprd04.prod.outlook.com>
	 <DB5PR0401MB1928B01F60FF3137118F237891710@DB5PR0401MB1928.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Cristian Stoica <cristian.stoica@nxp.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"David S. Miller" <davem@davemloft.net>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>
To: Scott Wood <scott.wood@nxp.com>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <DB5PR0401MB1928B01F60FF3137118F237891710@DB5PR0401MB1928.eurprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2016-05-10 at 18:50 +0000, Scott Wood wrote:

> On 05/09/2016 03:20 AM, Horia Ioan Geanta Neag wrote:

> > On 5/5/2016 6:37 PM, Horia Geant=C4=83 wrote:

> > > This will allow device drivers to consistently use io{read,write}=
XX
> > > also for 64-bit accesses.
> > >=20
> > > Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
> >=20
> > It would be great if PPC maintainers could Ack this patch.
> >=20
> > As stated in the cover letter: https://lkml.org/lkml/2016/5/5/340
> > I'd like to go with the whole patch set via cryptodev-2.6 tree.
>=20
> It looks good to me.  Michael?

I didn't get the cover letter, or any of the rest of the series, so alt=
hough I
saw the patch I had no context. And I didn't have time to chase it up.

At a glance it seems fine, so:

Acked-by: Michael Ellerman <mpe@ellerman.id.au>

cheers
