From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: Question about Talitos Linux driver for MPC885
Date: Tue, 27 Nov 2012 17:15:59 -0600
Message-ID: <20121127171559.977360c0cf3f9de61c29e1c6@freescale.com>
References: <50616F1D.108@c-s.fr>
	<20120925194730.85456a91d813a7fa35b637f4@freescale.com>
	<50AF7F4C.9080704@c-s.fr>
	<50AF9E43.7080409@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>
To: leroy christophe <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:23727
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484Ab2K0XSa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Nov 2012 18:18:30 -0500
In-Reply-To: <50AF9E43.7080409@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 23 Nov 2012 17:03:15 +0100
leroy christophe <christophe.leroy@c-s.fr> wrote:

> Kim,
>=20
> Looking once more at talitos.h file, it looks like none of the values=
=20
> corresponds to what is in the reference manuals.
> But it looks like in the talitos.h it is encoded as if it was with LS=
B=20
> first. Hence for instance the TALITOS_MCR_SWR which is 0x01 instead o=
f =20
> 0x01000000.
> Then I'm wondering what/where the problem is.

the problem is they're not the same on all SECs - some SECs just
have different bitfield encodings.  One solution is to #ifdef
CONFIG_PPC_8xx for the values correct for the 885, and #else the
existing values.

Kim

> Christophe
>=20
>=20
> Le 23/11/2012 14:51, leroy christophe a =E9crit :
> > Dear Kim,
> >
> > Thank you for you quick answer.
> > I didn't have much time to look at it until this week unfortunatly.
> >
> > I have some more questions/observations below
> >
> > Le 26/09/2012 02:47, Kim Phillips a =E9crit :
> >> On Tue, 25 Sep 2012 10:45:17 +0200
> >> leroy christophe <christophe.leroy@c-s.fr> wrote:
> >>
> >>> I'm trying to use the Talitos crypto driver with the MPC885
> >>> microcontroller. For the time being, it doesn't work.
> >> yes, they're not exactly compatible...
> >>
> >>> The kernel startup blocks at the test of the DES function.
> >>>
> >>> I have added the following definition in the DTS file:
> >>>
> >>>           crypto@20000 {
> >>>               compatible =3D "fsl,sec2.0";
> >> interesting, its called "SEC Lite" and its version register does
> >> indeed say 2.  I see it has a single channel FIFO instead of a rin=
g,
> >> that the SEC v1.x (MPC185) used, so you probably don't have to
> >> rewrite talitos_submit.
> > Good news, it was also my understanding.
> >>
> >>>               reg =3D <0x20000 0x8000>;
> >>>               interrupts =3D <1 1>;
> >> I couldn't find the IRQ line in the MPC855RM - if there's no IRQ
> >> line, then that's a problem.
> > Neither do I on the drawing, however in Table 52-1, there are 3 bit=
s=20
> > in the CPTR register for defining the interrupt level of the SEC li=
te,=20
> > just like you do for the CPM and for the FEC.
> > So I believe this should be ok ?
> >>
> >>>               interrupt-parent =3D <&PIC>;
> >>>               fsl,num-channels =3D <1>;
> >>>               fsl,channel-fifo-len =3D <24>;
> >>>               fsl,exec-units-mask =3D <0x4c>;
> >>>               fsl,descriptor-types-mask =3D <0x301f>;
> >> the descriptor type enumeration isn't uniform across into the mpc8=
xx
> >> SEC version, e.g., the SEC Lite doesn't support the ipsec_esp
> >> descriptor type, represented in mpc8xxx SEC versions as the second
> >> bit, so this descriptor-types-mask setting should be fixed to at
> >> least omit that since the driver checks for, and uses it if
> >> available.
> >>
> >>> Is there anything wrong in what I did ? Or is there something els=
e I
> >>> should do ?
> >> might want to go through the defines in talitos.h, e.g,
> >> TALITOS_MCR_SWR is 0x1 on mpc8xxx vs. 0x10000000 on
> >> mpc8xx (I suppose CONFIG_PPC_8xx can be used as the ifdef, btw).
> > I'm surprised about this, I didn't check the talitos.h file, but ha=
d=20
> > checked the Reference Manual of the MPC 8272.
> > I rechecked yesterday and the SWR bit is at the same place as on th=
e=20
> > MPC885 which is different from what is defined in talitos.h
> >>
> >> Descriptor header and pointer formats, along with field locations,
> >> sizes, and enumerations may also be different.
> >>
> >> It also appears the SEC Lite doesn't support scatter-gather tables=
,
> >> which will make performance hurt for fragmented (large) packet siz=
es.
> > Does it mean something has to be modified if the SW ?
> >>
> >> Kim
> >>
> > Thanks,
> > Christophe
>=20
>=20
