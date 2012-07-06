From: Phil Sutter <phil.sutter@viprinet.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Fri, 6 Jul 2012 17:30:19 +0200
Message-ID: <20120706153018.GB24676@philter.vipri.net>
References: <1339806021-14271-1-git-send-email-gmbnomis@gmail.com>
 <20120618134718.GL9122@philter.vipri.net>
 <20120618201235.GA20755@schnuecks.de>
 <4FE1D09E.4040104@gmail.com>
 <20120620154131.GR9122@philter.vipri.net>
 <20120625134050.GB12294@philter.vipri.net>
 <4FE874BD.2020909@gmail.com>
 <4FE88C63.8010103@gmail.com>
 <20120625215928.GA3853@philter.vipri.net>
 <4FEEAC54.10503@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, andrew@lunn.ch,
	Simon Baatz <gmbnomis@gmail.com>
To: "cloudy.linux" <cloudy.linux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:55633 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757649Ab2GFPa1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Jul 2012 11:30:27 -0400
Content-Disposition: inline
In-Reply-To: <4FEEAC54.10503@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Cloudy,

On Sat, Jun 30, 2012 at 03:35:48PM +0800, cloudy.linux wrote:
> Although I had no idea about what's wrong, I looked in the functional=
=20
> errata (again), And I found what's attached (The doc I got from Inter=
net=20
> was a protected PDF, that's why I had to use screen capture).
> Is this relevant? Or maybe you have already addressed this in the cod=
e=20
> (I can just read some simple C code)?

To me, doesn't read like a real problem, just a guideline for doing
things. From the output you sent me in your previous mail, I'd rather
suspect fetching the first descriptor to be faulty: the next descriptor
pointer contains the first descriptor's DMA address, all other fields
are zero (this is the situation when triggering the engine, as on
kirkwood all I have to do is fill the first descriptor's address in and
TDMA does the rest) and IDMA triggers an address miss interrupt at
address 0x0. So probably IDMA starts up and tries to look up decoding
windows for he up the still zero source and destination addresses.

According to the specs, when using the next descriptor field for
fetching the first descriptor one also has to set the FETCH_ND field in
DMA_CTRL register, also for TDMA. Though, on my hardware the only
working configuration is the implemented one, i.e. without FETCH_ND
being set.

I have implemented a separate approach just for IDMA, which instead of
just writing the first descriptor's address to NEXT_DESC does:
1. clear CTRL_ENABLE bit
2. fill NEXT_DESC
3. set CTRL_ENABLE along with FETCH_ND
hopefully this is the way to go on Orion. Since Marvell's BSP doesn't
implement *DMA attached to CESA, I have nowhere to look this up. Gettin=
g
it right for TDMA was just a matter of trial and error.

My public git got a few updates, including the code described above.
Would be great if you could give it a try.

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
