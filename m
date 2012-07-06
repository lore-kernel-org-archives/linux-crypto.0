From: Phil Sutter <phil.sutter@viprinet.com>
Subject: Re: [PATCH 0/1] MV_CESA with DMA: Clk init fixes
Date: Fri, 6 Jul 2012 17:05:55 +0200
Message-ID: <20120706150555.GA24676@philter.vipri.net>
References: <20120618134718.GL9122@philter.vipri.net>
 <1340742712-5821-1-git-send-email-gmbnomis@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, cloudy.linux@gmail.com
To: Simon Baatz <gmbnomis@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:55253 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab2GFPGE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Jul 2012 11:06:04 -0400
Content-Disposition: inline
In-Reply-To: <1340742712-5821-1-git-send-email-gmbnomis@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Simon,

On Tue, Jun 26, 2012 at 10:31:51PM +0200, Simon Baatz wrote:
> I just found the time to test your updates. Alas, the mv_dma module
> hangs at boot again.  The culprit seems to be setup_mbus_windows(),
> which is called before the clock is turned on but accesses the DMA
> engine.
>=20
> I shifted the clock init code a bit and while doing so, fixed some er=
ror
> case handling for mv_dma and mv_cesa.  See proposed patch in next mai=
l.

I applied that to my public git, thanks a lot!

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
