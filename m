From: Scott Wood <scottwood@freescale.com>
Subject: Re: [RFC][PATCH 2/2] crypto: caam - handle core endianness != caam
 endianness
Date: Wed, 2 Sep 2015 17:33:32 -0500
Message-ID: <1441233212.4966.174.camel@freescale.com>
References: <1440762306-7764-1-git-send-email-horia.geanta@freescale.com>
	 <1440762608-7866-1-git-send-email-horia.geanta@freescale.com>
	 <1441068591.4966.47.camel@freescale.com>
	 <BY1PR03MB1404538A6C4D0A85F7DD2E7080690@BY1PR03MB1404.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Geanta Neag Horia Ioan-B05471 <Horia.Geanta@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Milhoan Victoria-B42089 <Vicki.Milhoan@freescale.com>,
	Cornelius Steven-STEVENEC <steve.cornelius@freescale.com>,
	Estevam Fabio-R49496 <Fabio.Estevam@freescale.com>
To: Porosanu Alexandru-B06830 <alexandru.porosanu@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0141.outbound.protection.outlook.com ([65.55.169.141]:44899
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751678AbbIBWds (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Sep 2015 18:33:48 -0400
In-Reply-To: <BY1PR03MB1404538A6C4D0A85F7DD2E7080690@BY1PR03MB1404.namprd03.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2015-09-02 at 01:25 -0500, Porosanu Alexandru-B06830 wrote:
> Hi Scott,
>=20
> > -----Original Message-----
> > From: Wood Scott-B07421
> > Sent: 1 septembrie 2015 03:50
> > To: Geanta Neag Horia Ioan-B05471
> > Cc: Herbert Xu; Catalin Marinas; Will Deacon; linux-crypto@vger.ker=
nel.org;
> >=20
> > David S. Miller; linux-arm-kernel@lists.infradead.org; linux-
> > kernel@vger.kernel.org; Milhoan Victoria-B42089; Cornelius Steven-
> > STEVENEC; Estevam Fabio-R49496; Porosanu Alexandru-B06830
> > Subject: Re: [RFC][PATCH 2/2] crypto: caam - handle core endianness=
 !=3D
> > caam endianness
> >=20
> > On Fri, 2015-08-28 at 14:50 +0300, Horia Geant=C4=83 wrote:
> > >=20
> > > -#ifdef __BIG_ENDIAN
> > > -#define wr_reg32(reg, data) out_be32(reg, data)
> > > -#define rd_reg32(reg) in_be32(reg)
> > > +#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_LE
> > > +#define caam16_to_cpu(value) le16_to_cpu(value)
> > > +#define cpu_to_caam16(value) cpu_to_le16(value)
> > > +#define caam32_to_cpu(value) le32_to_cpu(value)
> > > +#define cpu_to_caam32(value) cpu_to_le32(value)
> > > +#define caam64_to_cpu(value) le64_to_cpu(value)
> > > +#define cpu_to_caam64(value) cpu_to_le64(value)
> >=20
> > What if we want to build a kernel that supports a chip with an LE C=
AAM and
> > another chip with a BE CAAM (e.g. ls1043a plus ls2080a)?  This info=
rmation
> > needs to come at runtime.
> [AP] We're currently targeting local SEC (where local means SEC is on=
 the=20
> SoC). Having this information at run-time will add some penalty as op=
posed=20
> to having these accessory as macros.

It is important to be able to have one kernel that works on multiple So=
Cs. =20
You could perhaps have a config option that optimizes one way or anothe=
r=20
(with a check that refuses to probe on the wrong-endian hardware) but p=
lease=20
have a runtime check for the default configuration.  Otherwise the most=
=20
likely result is that default configs won't enable CAAM support at all.

How severe is the performance penalty?  Perhaps the decision can be mad=
e at a=20
higher level for performance-critical parts of the driver (e.g. replace=
 the=20
entire calling function rather than each I/O access)?  Have the hardwar=
e=20
designers been made aware of the performance consequence of their=20
inconsistency?

-Scott
