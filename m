From: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@freescale.com>
Subject: Re: [PATCH v3 11/14] ARM: dts: mx6sx: Add CAAM device node
Date: Fri, 7 Aug 2015 09:58:36 +0300
Message-ID: <55C4571C.2040900@freescale.com>
References: <55C321F6.1040801@freescale.com>
 <1438886557-28431-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <ruchika.gupta@freescale.com>, <kernel@pengutronix.de>,
	<linux@arm.linux.org.uk>, <robh+dt@kernel.org>
To: Victoria Milhoan <vicki.milhoan@freescale.com>,
	<linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<shawnguo@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0145.outbound.protection.outlook.com ([157.56.110.145]:27708
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752297AbbHGG6r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Aug 2015 02:58:47 -0400
In-Reply-To: <1438886557-28431-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 8/6/2015 9:42 PM, Victoria Milhoan wrote:
> Add CAAM device node to the i.MX6SX device tree.
>=20
> Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>

Vicki, thanks for your work!

=46or the series:
Tested-by: Horia Geant=C4=83 <horia.geanta@freescale.com>
on imx6q-sabresd.

Note that patch 14/14
crypto: caam - Detect hardware features during algorithm registration
should be applied before 13/14
ARM: imx_v6_v7_defconfig: Select CAAM
(in case the patches won't go through different trees).

Horia
