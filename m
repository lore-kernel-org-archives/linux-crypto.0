From: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Subject: RE: [PATCH 07/10] crypto: qat - remove duplicate ASN.1 parser
Date: Mon, 21 Mar 2016 10:12:58 +0000
Message-ID: <AM3PR04MB13002D8FB6F93E96333348D4B88F0@AM3PR04MB1300.eurprd04.prod.outlook.com>
References: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <1458325927-14737-7-git-send-email-tudor-dan.ambarus@nxp.com>
 <56EEB9E8.3070808@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"smueller@chronox.de" <smueller@chronox.de>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db3on0089.outbound.protection.outlook.com ([157.55.234.89]:63776
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752647AbcCUKNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Mar 2016 06:13:01 -0400
In-Reply-To: <56EEB9E8.3070808@intel.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> -----Original Message-----
> From: Tadeusz Struk [mailto:tadeusz.struk@intel.com]
> Sent: Sunday, March 20, 2016 4:56 PM
> To: Tudor-Dan Ambarus; herbert@gondor.apana.org.au
> Cc: linux-crypto@vger.kernel.org; smueller@chronox.de; Horia Ioan Geanta
> Neag
> Subject: Re: [PATCH 07/10] crypto: qat - remove duplicate ASN.1 parser
> 
> On 03/18/2016 11:32 AM, Tudor Ambarus wrote:
> > Use the RSA's software implementation parser with
> > raw integer actions.
> >
> > Compile-tested only.
> >
> > Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
> > ---
> >  drivers/crypto/qat/Kconfig                        |   3 +-
> >  drivers/crypto/qat/qat_common/Makefile            |  10 +-
> >  drivers/crypto/qat/qat_common/qat_asym_algs.c     | 265 +++++++---------
> ------
> >  drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1 |  11 -
> >  drivers/crypto/qat/qat_common/qat_rsapubkey.asn1  |   4 -
> >  5 files changed, 83 insertions(+), 210 deletions(-)
> >  delete mode 100644 drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1
> >  delete mode 100644 drivers/crypto/qat/qat_common/qat_rsapubkey.asn1
> 
> Thanks for converting qat, but I'm working on adding support for the
> Chinese
> remainder algorithm, which gives us big performance improvement, so please
> do not change the qat driver just yet.
> Please just add a generic ANS.1 parser that would allow to obtain all
> components of the private key and I'll use it to add the handlers
> and remove the ASN.1 parsing from qat. I will then test it to make sure
> that it works fine before it is committed.

[ta] Ok.

> Thanks,
> --
> TS
