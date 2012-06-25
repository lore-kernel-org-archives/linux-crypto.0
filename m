From: Phil Sutter <phil.sutter@viprinet.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Mon, 25 Jun 2012 15:40:50 +0200
Message-ID: <20120625134050.GB12294@philter.vipri.net>
References: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
 <1339806021-14271-1-git-send-email-gmbnomis@gmail.com>
 <20120618134718.GL9122@philter.vipri.net>
 <20120618201235.GA20755@schnuecks.de>
 <4FE1D09E.4040104@gmail.com>
 <20120620154131.GR9122@philter.vipri.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, andrew@lunn.ch,
	Simon Baatz <gmbnomis@gmail.com>
To: "cloudy.linux" <cloudy.linux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:48387 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576Ab2FYNlA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jun 2012 09:41:00 -0400
Content-Disposition: inline
In-Reply-To: <20120620154131.GR9122@philter.vipri.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Wed, Jun 20, 2012 at 05:41:31PM +0200, Phil Sutter wrote:
> PS: I am currently working at the address decoding problem, will get
> back to in a few days when I have something to test. So stay tuned!

I have updated the cesa-dma branch at git://nwl.cc/~n0-1/linux.git with
code setting the decoding windows. I hope this fixes the issues on
orion. I decided not to publish the changes regarding the second DMA
channel for now, as this seems to be support for a second crypto sessio=
n
(handled consecutively, so no real improvement) which is not supported
anyway.

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
