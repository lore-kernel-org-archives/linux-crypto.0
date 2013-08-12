From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: Re: [PATCH 1/3] ARM: dts: mxs: set dcp to "disabled" by default
Date: Mon, 12 Aug 2013 14:05:51 +0200
Message-ID: <21000.53151.841177.378797@ipc1.ka-ro>
References: <1375968629-10091-1-git-send-email-LW@KARO-electronics.de>
	<1375968629-10091-2-git-send-email-LW@KARO-electronics.de>
	<20130812110523.GD25292@S2101-09.ap.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <devicetree@vger.kernel.org>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Rob Herring <rob.herring@calxeda.com>,
	<linux-crypto@vger.kernel.org>,
	Tobias Rauter <tobiasrauter@gmail.com>,
	<linux-arm-kernel@lists.infradead.org>
To: Shawn Guo <shawn.guo@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.karo-electronics.de ([81.173.242.67]:58140 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab3HLMF7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Aug 2013 08:05:59 -0400
In-Reply-To: <20130812110523.GD25292@S2101-09.ap.freescale.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Shawn Guo writes:
> On Thu, Aug 08, 2013 at 03:30:27PM +0200, Lothar Wa=C3=9Fmann wrote:
> > Reintroduce 'status =3D "disabled"' for the dcp node that was dropp=
ed by
> > commit 519d8b1a "Added support for Freescale's DCP co-processor".
>=20
> For IP blocks that do not have pins to be routed on boards, it should=
 be
> fine to have it enabled in <soc>.dtsi.
>=20
That means that when a new driver is added, it will start wasting
resources on all board using that SoC unless the board maintainers
explicitly disable that driver in DTB.

I would prefer things to be the other way:
New drivers (no matter whether for chip-internal or external hardware)
should require to be explicitly enabled for those platforms on which
they are being used.


Lothar Wa=C3=9Fmann
--=20
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstra=C3=9Fe 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Gesch=C3=A4ftsf=C3=BChrer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
