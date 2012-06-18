From: Phil Sutter <phil.sutter@viprinet.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Mon, 18 Jun 2012 15:47:18 +0200
Message-ID: <20120618134718.GL9122@philter.vipri.net>
References: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
 <1339806021-14271-1-git-send-email-gmbnomis@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, cloudy.linux@gmail.com
To: Simon Baatz <gmbnomis@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:43266 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab2FRNr2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jun 2012 09:47:28 -0400
Content-Disposition: inline
In-Reply-To: <1339806021-14271-1-git-send-email-gmbnomis@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Simon,

On Sat, Jun 16, 2012 at 02:20:19AM +0200, Simon Baatz wrote:
> thanks for providing these patches; it's great to finally see DMA
> support for CESA in the kernel. Additionally, the implementation seem=
s
> to be fine regarding cache incoherencies (at least my test in [*]
> works).

Thanks for testing and the fixes. Could you also specify the platform
you are testing on?

> I have two patches for your patchset...
>=20
> - Fix for mv_init_engine error handling
>=20
> - My system locked up hard when mv_dma and mv_cesa were built as
>   modules. mv_cesa has code to enable the crypto clock in 3.5, but
>   mv_dma already accesses the CESA engine before. Thus, we need to
>   enable this clock here, too.

I have folded them into my patch series, thanks again. I somewhat miss
the orion_clkdev_add() part for orion5x platforms, but also fail to fin=
d
any equivalent place in the correspondent subdirectory. So I hope it is
OK like this.

The updated patch series is available at git://nwl.cc/~n0-1/linux.git,
branch 'cesa-dma'. My push changed history, so you have to either reset
--hard to it's HEAD, or rebase skipping the outdated patches.

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
