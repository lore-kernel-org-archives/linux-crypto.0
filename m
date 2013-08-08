From: Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 0/3] ARM: dts: mxs: dcp cleanup patches
Date: Thu, 8 Aug 2013 16:14:06 -0500
Message-ID: <6BB0ACA6-8B65-44FE-9DF1-1465DFC4CC48@codeaurora.org>
References: <1375968629-10091-1-git-send-email-LW@KARO-electronics.de>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tobias Rauter <tobiasrauter@gmail.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Rob Herring <rob.herring@calxeda.com>,
	linux-arm-kernel@lists.infradead.org
To: =?iso-8859-1?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:49025 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966575Ab3HHVOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Aug 2013 17:14:08 -0400
In-Reply-To: <1375968629-10091-1-git-send-email-LW@KARO-electronics.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Aug 8, 2013, at 8:30 AM, Lothar Wa=DFmann wrote:

> This patch series does the following:
>=20
> - let the driver be "disabled" by default in imx28.dtsi
> - coding style cleanups in drivers/crypto/dcp.c
> - use the "official" 'fsl,' prefix in the 'compatible' property
>=20
> The last patch adds a new entry to the of_match_table of the driver,
> so that current DT blobs will still work. When out of tree users
> (mentioned in the commit log of 519d8b1a "Added support for
> Freescale's DCP co-processor") have updated their DTBs the old entry
> 'fsl-dsp' can be removed from the driver.
>=20
> This patch series requires at least
> "[PATCH 2/8] ARM: dts: mxs: add labels to most nodes for easier refer=
ence"
> from the patch series:
> <1375966287-6784-1-git-send-email-LW@KARO-electronics.de> to be
> applied.
>=20
> arch/arm/boot/dts/imx28.dtsi      |    2 +-
> b/arch/arm/boot/dts/imx28-evk.dts |    4 ++++
> b/arch/arm/boot/dts/imx28.dtsi    |    3 ++-
> b/drivers/crypto/dcp.c            |   11 +++++------
> drivers/crypto/dcp.c              |    2 ++
> 5 files changed, 14 insertions(+), 8 deletions(-)
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Is there an actual binding spec for fsl,dcp?  If not, there really shou=
ld be.

- k

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, host=
ed by The Linux Foundation
