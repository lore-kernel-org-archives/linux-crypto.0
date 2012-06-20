From: Phil Sutter <phil.sutter@viprinet.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Wed, 20 Jun 2012 17:41:31 +0200
Message-ID: <20120620154131.GR9122@philter.vipri.net>
References: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
 <1339806021-14271-1-git-send-email-gmbnomis@gmail.com>
 <20120618134718.GL9122@philter.vipri.net>
 <20120618201235.GA20755@schnuecks.de>
 <4FE1D09E.4040104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, andrew@lunn.ch,
	Simon Baatz <gmbnomis@gmail.com>
To: "cloudy.linux" <cloudy.linux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:33776 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779Ab2FTPlk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Jun 2012 11:41:40 -0400
Content-Disposition: inline
In-Reply-To: <4FE1D09E.4040104@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Cloudy,

On Wed, Jun 20, 2012 at 09:31:10PM +0800, cloudy.linux wrote:
> On 2012-6-19 4:12, Simon Baatz wrote:
> > I see one effect that I don't fully understand.
> > Similar to the previous implementation, the system is mostly in
> > kernel space when accessing an encrypted dm-crypt device:
>=20
> Today I also compiled the patched 3.5.0-rc3 for another NAS box with=20
> MV88F6282-Rev-A0 (LS-WVL), I noticed one thing that when the CESA eng=
ine=20
> was used, the interrupt number of mv_crypto kept rising, but the=20
> interrupt number of mv_tdma was always zero.

Yes, that is exactly how it should be: the DMA engine is configured to
run "attached" to CESA, meaning that when CESA is triggered from
mv_cesa.c, it first enables the DMA engine. Using a special descriptor
in the chain, the DMA engine knows when to stop and signals CESA again
so it can start the crypto operation. Afterwards, CESA triggers the DMA
engine again for copying back the results (or more specific: process th=
e
remaining descriptors in the chain after the special one). After a
descriptor with it's next descriptor field being zero has been handled,
CESA is signaled again which in turn generates the interrupt to signal
the software. So no DMA interrupt needed, and no software interaction i=
n
between data copying and crypto operation, of course. :)

Greetings, Phil

PS: I am currently working at the address decoding problem, will get
back to in a few days when I have something to test. So stay tuned!

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
