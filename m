From: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@freescale.com>
Subject: Re: [PATCH] crypto: caam - Fix error handling in caam_rng_init()
Date: Wed, 12 Aug 2015 20:14:17 +0300
Message-ID: <55CB7EE9.2020509@freescale.com>
References: <1439390922-25091-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <vicki.milhoan@freescale.com>, <steve.cornelius@freescale.com>,
	<linux-crypto@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@freescale.com>
To: Fabio Estevam <festevam@gmail.com>, <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0144.outbound.protection.outlook.com ([157.56.111.144]:64631
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932437AbbHLRaU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Aug 2015 13:30:20 -0400
In-Reply-To: <1439390922-25091-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 8/12/2015 5:48 PM, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>=20
> In the error paths we should free the resources that were=20
> previously acquired, so fix it accordingly.
>=20
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Reviewed-by: Horia Geant=C4=83 <horia.geanta@freescale.com>

Thanks,
Horia
