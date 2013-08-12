From: Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 1/3] ARM: dts: mxs: set dcp to "disabled" by default
Date: Mon, 12 Aug 2013 09:17:05 -0500
Message-ID: <73E20626-6771-4F37-BE65-8AA0D49FA94D@codeaurora.org>
References: <1375968629-10091-1-git-send-email-LW@KARO-electronics.de> <1375968629-10091-2-git-send-email-LW@KARO-electronics.de> <20130812110523.GD25292@S2101-09.ap.freescale.net> <21000.53151.841177.378797@ipc1.ka-ro>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shawn Guo <shawn.guo@linaro.org>, <devicetree@vger.kernel.org>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Rob Herring <rob.herring@calxeda.com>,
	<linux-crypto@vger.kernel.org>,
	Tobias Rauter <tobiasrauter@gmail.com>,
	<linux-arm-kernel@lists.infradead.org>
To: =?iso-8859-1?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:50222 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab3HLORA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Aug 2013 10:17:00 -0400
In-Reply-To: <21000.53151.841177.378797@ipc1.ka-ro>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Aug 12, 2013, at 7:05 AM, Lothar Wa=DFmann wrote:

> Hi,
>=20
> Shawn Guo writes:
>> On Thu, Aug 08, 2013 at 03:30:27PM +0200, Lothar Wa=DFmann wrote:
>>> Reintroduce 'status =3D "disabled"' for the dcp node that was dropp=
ed by
>>> commit 519d8b1a "Added support for Freescale's DCP co-processor".
>>=20
>> For IP blocks that do not have pins to be routed on boards, it shoul=
d be
>> fine to have it enabled in <soc>.dtsi.
>>=20
> That means that when a new driver is added, it will start wasting
> resources on all board using that SoC unless the board maintainers
> explicitly disable that driver in DTB.
>=20
> I would prefer things to be the other way:
> New drivers (no matter whether for chip-internal or external hardware=
)
> should require to be explicitly enabled for those platforms on which
> they are being used.

But that enablement should be in the kernel and not the device tree.  T=
he device tree is describing the HW, if the DCP exists and is usable w/=
o an external IO than by default it should be enabled in the SoC .dts

- k

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, host=
ed by The Linux Foundation
