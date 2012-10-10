From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 1/2] ARM: OMAP: Trivial driver changes to remove
 include plat/cpu.h
Date: Tue, 9 Oct 2012 17:19:44 -0700
Message-ID: <20121010001943.GK12552@atomide.com>
References: <20121008173452.10603.53886.stgit@muffinssi>
 <20121008173557.10603.18539.stgit@muffinssi>
 <5073E84E.4090408@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
	linux-omap@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
	linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Liam Girdwood <lrg@ti.com>,
	Deepak Saxena <dsaxena@plexity.net>,
	Chris Ball <cjb@laptop.org>, Matt Mackall <mpm@selenic.com>,
	Venkatraman S <svenkatr@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jarkko Nikula <jarkko.nikula@bitmer.com>,
	linux-crypto@vger.kernel.org
To: =?utf-8?B?UMOpdGVy?= Ujfalusi <peter.ujfalusi@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:14708 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753742Ab2JJATz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Oct 2012 20:19:55 -0400
Content-Disposition: inline
In-Reply-To: <5073E84E.4090408@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* P=C3=A9ter Ujfalusi <peter.ujfalusi@ti.com> [121009 02:03]:
> On 10/08/2012 07:35 PM, Tony Lindgren wrote:
>=20
> > - omap-dma.c and omap-pcm.c can test the arch locally as
> >   omap1 and omap2 cannot be compiled together because of
> >   conflicting compiler flags
>=20
> >  sound/soc/omap/omap-pcm.c         |    9 +++++++--
>=20
> Tony: is this going to be included in 3.7?

Hmm I guess we could try to get this out of the way
to cut down the dependencies. Let's if maintainers
of the other affected drivers this is OK for the
-rc series.

Regards,

Tony
