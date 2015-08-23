From: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@freescale.com>
Subject: Re: [PATCH v3 1/3] crypto: caam: ctrl: Fix the error handling
Date: Sun, 23 Aug 2015 16:27:20 +0300
Message-ID: <55D9CA38.2060307@freescale.com>
References: <1440175920-30884-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <vicki.milhoan@freescale.com>, <linux-crypto@vger.kernel.org>,
	"Fabio Estevam" <fabio.estevam@freescale.com>
To: Fabio Estevam <festevam@gmail.com>, <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0143.outbound.protection.outlook.com ([207.46.100.143]:28592
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752415AbbHWOCH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 23 Aug 2015 10:02:07 -0400
In-Reply-To: <1440175920-30884-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 8/21/2015 7:51 PM, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>=20
> In the error path we should disable the resources that were previousl=
y
> acquired, so fix the error handling accordingly.
>=20
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

=46or v3 series
Reviewed-by: Horia Geant=C4=83 <horia.geanta@freescale.com>

Thanks,
Horia
