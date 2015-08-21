From: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@freescale.com>
Subject: Re: [PATCH v2 1/3] crypto: caam: ctrl: Fix the error handling
Date: Fri, 21 Aug 2015 19:37:58 +0300
Message-ID: <55D753E6.6060103@freescale.com>
References: <1440173804-26780-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <vicki.milhoan@freescale.com>, <linux-crypto@vger.kernel.org>,
	"Fabio Estevam" <fabio.estevam@freescale.com>
To: Fabio Estevam <festevam@gmail.com>, <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bn0105.outbound.protection.outlook.com ([157.56.110.105]:6496
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751602AbbHUQiS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Aug 2015 12:38:18 -0400
In-Reply-To: <1440173804-26780-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 8/21/2015 7:16 PM, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>=20
> In the error path we should disable the resources that were previousl=
y
> acquired, so fix the error handling accordingly.
>=20
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

=46or the series:
Reviewed-by: Horia Geant=C4=83 <horia.geanta@freescale.com>

Thanks!
Horia
