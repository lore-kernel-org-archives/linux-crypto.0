From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: Question about Talitos Linux driver for MPC885
Date: Tue, 27 Nov 2012 17:11:40 -0600
Message-ID: <20121127171140.8fcc7a0b49c26248b7bddd5e@freescale.com>
References: <50616F1D.108@c-s.fr>
	<20120925194730.85456a91d813a7fa35b637f4@freescale.com>
	<50AF7F4C.9080704@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>
To: leroy christophe <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:37003
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755623Ab2K0X3K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Nov 2012 18:29:10 -0500
In-Reply-To: <50AF7F4C.9080704@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 23 Nov 2012 14:51:08 +0100
leroy christophe <christophe.leroy@c-s.fr> wrote:

> Le 26/09/2012 02:47, Kim Phillips a =E9crit :
> > On Tue, 25 Sep 2012 10:45:17 +0200
> > leroy christophe <christophe.leroy@c-s.fr> wrote:
> >
> >> I'm trying to use the Talitos crypto driver with the MPC885
> >> microcontroller. For the time being, it doesn't work.
> > yes, they're not exactly compatible...
> >
> >> The kernel startup blocks at the test of the DES function.
> >>
> >> I have added the following definition in the DTS file:
> >>
> >>           crypto@20000 {
> >>               compatible =3D "fsl,sec2.0";
> > interesting, its called "SEC Lite" and its version register does
> > indeed say 2.  I see it has a single channel FIFO instead of a ring=
,
> > that the SEC v1.x (MPC185) used, so you probably don't have to
> > rewrite talitos_submit.
> Good news, it was also my understanding.
> >
> >>               reg =3D <0x20000 0x8000>;
> >>               interrupts =3D <1 1>;
> > I couldn't find the IRQ line in the MPC855RM - if there's no IRQ
> > line, then that's a problem.
> Neither do I on the drawing, however in Table 52-1, there are 3 bits =
in=20
> the CPTR register for defining the interrupt level of the SEC lite, j=
ust=20
> like you do for the CPM and for the FEC.

not sure how interrupt _level_ is relevant, but I'm going to assume
you're saying the SEC's IRQ line is integrated into that of the CPM
and/or FEC.

> So I believe this should be ok ?

Assuming the above, the 'interrupts' property above should
equal that of the CPM and/or FEC, and the IRQ_SHARED flag set in
request_irq (in both talitos and the CPM and/or FEC drivers).  The
talitos IRQ handler will return IRQ_NONE if none of the channel
done/error bits are set in the SEC.

> >>               interrupt-parent =3D <&PIC>;
> >>               fsl,num-channels =3D <1>;
> >>               fsl,channel-fifo-len =3D <24>;
> >>               fsl,exec-units-mask =3D <0x4c>;
> >>               fsl,descriptor-types-mask =3D <0x301f>;
> > the descriptor type enumeration isn't uniform across into the mpc8x=
x
> > SEC version, e.g., the SEC Lite doesn't support the ipsec_esp
> > descriptor type, represented in mpc8xxx SEC versions as the second
> > bit, so this descriptor-types-mask setting should be fixed to at
> > least omit that since the driver checks for, and uses it if
> > available.
> >
> >> Is there anything wrong in what I did ? Or is there something else=
 I
> >> should do ?
> > might want to go through the defines in talitos.h, e.g,
> > TALITOS_MCR_SWR is 0x1 on mpc8xxx vs. 0x10000000 on
> > mpc8xx (I suppose CONFIG_PPC_8xx can be used as the ifdef, btw).
> I'm surprised about this, I didn't check the talitos.h file, but had=20
> checked the Reference Manual of the MPC 8272.
> I rechecked yesterday and the SWR bit is at the same place as on the=20
> MPC885 which is different from what is defined in talitos.h

right, for some odd reason the h/w designers decided to scramble
the bitfield definitions.

> > Descriptor header and pointer formats, along with field locations,
> > sizes, and enumerations may also be different.
> >
> > It also appears the SEC Lite doesn't support scatter-gather tables,
> > which will make performance hurt for fragmented (large) packet size=
s.
> Does it mean something has to be modified if the SW ?

yes, s/w will have to allocate a new contiguous memory buffer and
sg_copy_to_buffer() prior to crypto request submission to the h/w,
and sg_copy_from_buffer() after h/w completion.

Kim
