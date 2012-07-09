From: Phil Sutter <phil.sutter@viprinet.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Mon, 9 Jul 2012 14:54:50 +0200
Message-ID: <20120709125450.GB30493@philter.vipri.net>
References: <20120618201235.GA20755@schnuecks.de>
 <4FE1D09E.4040104@gmail.com>
 <20120620154131.GR9122@philter.vipri.net>
 <20120625134050.GB12294@philter.vipri.net>
 <4FE874BD.2020909@gmail.com>
 <4FE88C63.8010103@gmail.com>
 <20120625215928.GA3853@philter.vipri.net>
 <4FEEAC54.10503@gmail.com>
 <20120706153018.GB24676@philter.vipri.net>
 <4FF91CE7.7090205@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, andrew@lunn.ch,
	Simon Baatz <gmbnomis@gmail.com>
To: "cloudy.linux" <cloudy.linux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:54133 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab2GIMy7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Jul 2012 08:54:59 -0400
Content-Disposition: inline
In-Reply-To: <4FF91CE7.7090205@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Sun, Jul 08, 2012 at 01:38:47PM +0800, cloudy.linux wrote:
> Newest result. Still couldn't boot up. This time the source was clone=
d=20
> from your git repository.
>=20
> MV-DMA: window at bar0: target 0, attr 14, base 0, size 8000000
> MV-DMA: window at bar1: target 5, attr 0, base f2200000, size 10000
> MV-DMA: IDMA engine up and running, IRQ 23
> MV-DMA: idma_print_and_clear_irq: address miss @0!
> MV-DMA: tpg.reg + DMA_CTRL =3D 0x80001d04
> MV-DMA: tpg.reg + DMA_BYTE_COUNT =3D 0x0
> MV-DMA: tpg.reg + DMA_SRC_ADDR =3D 0x0
> MV-DMA: tpg.reg + DMA_DST_ADDR =3D 0x0
> MV-DMA: tpg.reg + DMA_NEXT_DESC =3D 0x79b1000
> MV-DMA: tpg.reg + DMA_CURR_DESC =3D 0x0
> MV-DMA: DMA descriptor list:
> MV-DMA: entry 0 at 0xffdbb000: dma addr 0x79b1000, src 0x79b4000, dst=
=20
> 0xf2200080, count 16, own 1, next 0x79b1010
> MV-DMA: entry 1 at 0xffdbb010: dma addr 0x79b1010, src 0x799c28c, dst=
=20
> 0xf2200000, count 80, own 1, next 0x79b1020
> MV-DMA: entry 2 at 0xffdbb020: dma addr 0x79b1020, src 0x0, dst 0x0,=20
> count 0, own 0, next 0x79b1030
> MV-DMA: entry 3 at 0xffdbb030: dma addr 0x79b1030, src 0xf2200080, ds=
t=20
> 0x79b4000, count 16, own 1, next 0x0
> MV-CESA:got an interrupt but no pending timer?

Sucks. What's making me wonder here is, address decoding of address 0x0
actually shouldn't fail, since window 0 includes this address.

=46or now, I have pushed two new commits to my public git, adding more
debugging output for decoding window logic and interrupt case as well a=
s
decoding window permission fix and changing from FETCH_ND to programmin=
g
the first DMA descriptor's values manually.

In the long term, I probably should try to get access to some
appropriate hardware myself. This is rather a quiz game than actual bug
tracking.

Greetings, Phil


Phil Sutter
Software Engineer

--=20
VNet Europe GmbH
Mainzer Str. 43
55411 Bingen am Rhein
Germany

Management Buy-Out at Viprinet - please read
http://www.viprinet.com/en/mbo
Management Buy-Out bei Viprinet - bitte lesen Sie
http://www.viprinet.com/de/mbo

Phone/Zentrale:               +49 6721 49030-0
Direct line/Durchwahl:        +49 6721 49030-134
=46ax:                          +49 6721 49030-109

phil.sutter@viprinet.com
http://www.viprinet.com

Registered office/Sitz der Gesellschaft: Bingen am Rhein, Germany
Commercial register/Handelsregister: Amtsgericht Mainz HRB44090
CEO/Gesch=C3=A4ftsf=C3=BChrer: Simon Kissel
