From: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Subject: RE: [PATCH v3 3/3] crypto: caam - add support for RSA algorithm
Date: Mon, 18 Apr 2016 12:52:59 +0000
Message-ID: <VI1PR04MB1311C8CC7D4373BE6648A6F3B86B0@VI1PR04MB1311.eurprd04.prod.outlook.com>
References: <1459949876-11989-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <1459949876-11989-4-git-send-email-tudor-dan.ambarus@nxp.com>
 <1615938.dYpiRBWbDV@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Cristian Stoica" <cristian.stoica@nxp.com>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db3on0073.outbound.protection.outlook.com ([157.55.234.73]:3136
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750717AbcDRMxI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Apr 2016 08:53:08 -0400
In-Reply-To: <1615938.dYpiRBWbDV@tauon.atsec.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

> Am Mittwoch, 6. April 2016, 16:37:56 schrieb Tudor Ambarus:
> 
> > +static size_t scatterwalk_skip_zeros(struct scatter_walk *walk, size_t
> > nbytes) +{
> 
> Do you really want to keep that function after Herbert mentioned we should
> leave the zeros for the RSA operation? Or asked differently, why is the
> skipping of the zeroes not introducing a side channel?

The skipping of the zeros does not introduce a side channel because it is done
only for the output data, after the computation completes.

Thanks,
ta
