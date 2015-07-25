From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 06/11] crypto: caam - Enable MXC devices to select
 CAAM driver in Kconfig
Date: Sat, 25 Jul 2015 09:43:51 +0800
Message-ID: <20150725014351.GA29321@gondor.apana.org.au>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
 <1434412379-11623-7-git-send-email-vicki.milhoan@freescale.com>
 <20150617072734.GK7947@pengutronix.de>
 <55B27277.2010403@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	Victoria Milhoan <vicki.milhoan@freescale.com>,
	linux-crypto@vger.kernel.org, ruchika.gupta@freescale.com
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37255 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbbGYBn7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jul 2015 21:43:59 -0400
Content-Disposition: inline
In-Reply-To: <55B27277.2010403@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 24, 2015 at 08:14:31PM +0300, Horia Geant=C4=83 wrote:
>
> Even more, not all SOC_IMX6 variants have a CAAM block.
>=20
> Not sure what's better:
> -try to exactly indicate the HW that has the IP
> -only name the arch / SoC (provided compilation passes), and then dep=
end
> on defconfig and/or device tree (and possibly boot loader dynamically
> fixing the DT)
>=20
> For e.g. Sahara crypto driver also depends on ARCH_MXC and it's not
> available on all i.MX SoCs.

Kconfig entry dependencies do not have to guarantee the existence
of the device.  It only has to guarantee the ability to compile the
code.

Cheers,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
