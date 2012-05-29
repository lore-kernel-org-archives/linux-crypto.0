From: Phil Sutter <phil.sutter@viprinet.com>
Subject: Re: [PATCH 2/4] mv_cesa: no need to write to that FPGA_INT_STATUS
 field
Date: Tue, 29 May 2012 13:45:29 +0200
Message-ID: <20120529114529.GB5711@philter.vipri.net>
References: <1337954089-12702-1-git-send-email-phil.sutter@viprinet.com>
 <1337954089-12702-2-git-send-email-phil.sutter@viprinet.com>
 <4FC2DBC8.2070805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: "cloudy.linux" <cloudy.linux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:41408 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab2E2Lp7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 May 2012 07:45:59 -0400
Content-Disposition: inline
In-Reply-To: <4FC2DBC8.2070805@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Mon, May 28, 2012 at 09:58:32AM +0800, cloudy.linux wrote:
> On 2012-5-25 21:54, Phil Sutter wrote:
> > Also drop the whole definition, since it's unused otherwise.
> >
> > Signed-off-by: Phil Sutter<phil.sutter@viprinet.com>
> > ---
> >   drivers/crypto/mv_cesa.c |    1 -
> >   drivers/crypto/mv_cesa.h |    7 -------
> >   2 files changed, 0 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
> > index 8327bed..4a1f872 100644
> > --- a/drivers/crypto/mv_cesa.c
> > +++ b/drivers/crypto/mv_cesa.c
> > @@ -908,7 +908,6 @@ irqreturn_t crypto_int(int irq, void *priv)
> >   		       "got an interrupt but no pending timer?\n");
> >   	}
> >   	val&=3D ~SEC_INT_ACCEL0_DONE;
> > -	writel(val, cpg->reg + FPGA_INT_STATUS);
> >   	writel(val, cpg->reg + SEC_ACCEL_INT_STATUS);
> >   	BUG_ON(cpg->eng_st !=3D ENGINE_BUSY);
> >   	cpg->eng_st =3D ENGINE_W_DEQUEUE;
> > diff --git a/drivers/crypto/mv_cesa.h b/drivers/crypto/mv_cesa.h
> > index 08fcb11..81ce109 100644
> > --- a/drivers/crypto/mv_cesa.h
> > +++ b/drivers/crypto/mv_cesa.h
> > @@ -29,13 +29,6 @@
> >   #define SEC_ST_ACT_0		(1<<  0)
> >   #define SEC_ST_ACT_1		(1<<  1)
> >
> > -/*
> > - * FPGA_INT_STATUS looks like a FPGA leftover and is documented on=
ly in Errata
> > - * 4.12. It looks like that it was part of an IRQ-controller in FP=
GA and
> > - * someone forgot to remove  it while switching to the core and mo=
ving to
> > - * SEC_ACCEL_INT_STATUS.
> > - */
> > -#define FPGA_INT_STATUS		0xdd68
> >   #define SEC_ACCEL_INT_STATUS	0xde20
> >   #define SEC_INT_AUTH_DONE	(1<<  0)
> >   #define SEC_INT_DES_E_DONE	(1<<  1)
>=20
> According to the functional errata of 88F5182, the FPGA_INT_STATUS is=
=20
> needed (at least for 88F5182-A1/A2). Here is the quote from that erra=
ta:
>=20
> 4.12	Clearing the Cryptographic Engines and Security Accelerator=20
> Interrupt Cause Register
> 	Type:		Guideline
> 	Ref#:		GL-CESA-100
> 	Relevant for:	88F5182-A1/A2
>=20
> Description:
> Writing 0 to bits[6:0] of the Crytographic Engines ...  Interrupt Cau=
se=20
> register (offset 0x9DE20) has no effect.
>=20
> Steps to be performed by the designer
> Before writing 0 to any of the bits[6:0] of the Cryptographic Engines=
 ..=20
> Interrupt Cause register, the software must write 0 to the correspond=
ing=20
> bit of the internal register at offset 0x9DD68.
> Writing to offset 0x9DD68 is not possible when any of the Security=20
> Accelerators' sessions are active. Therefore, the software must verif=
y=20
> that no channel is active before clearing any of those interrupts.

Oh, that explains why it's not needed on Kirkwood but still left there.
I could make it compile-time optional, depending on ARCH_ORION5X e.g. o=
r
simply drop the patch and leave it alone since it really doesn't hurt
that much.=20

Anyway, thanks a lot for your kind review!

Greetings, Phil



Phil Sutter
Software Engineer

--=20


Viprinet GmbH
Mainzer Str. 43
55411 Bingen am Rhein
Germany

Phone/Zentrale:         +49-6721-49030-0
Direct line/Durchwahl:  +49-6721-49030-134
=46ax:                    +49-6721-49030-209

phil.sutter@viprinet.com
http://www.viprinet.com

Registered office/Sitz der Gesellschaft: Bingen am Rhein
Commercial register/Handelsregister: Amtsgericht Mainz HRB40380
CEO/Gesch=C3=A4ftsf=C3=BChrer: Simon Kissel
