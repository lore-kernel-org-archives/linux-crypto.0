From: Horia Ioan Geanta Neag <horia.geanta@nxp.com>
Subject: Re: [PATCH v6 0/3] crypto: caam - add support for RSA algorithm
Date: Thu, 19 May 2016 15:45:43 +0000
Message-ID: <AM2PR04MB0673093C3064FCF4C1AFC71F984A0@AM2PR04MB0673.eurprd04.prod.outlook.com>
References: <1463660118-19188-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1on0070.outbound.protection.outlook.com ([157.56.112.70]:34752
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751760AbcESQSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 May 2016 12:18:55 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 5/19/2016 3:15 PM, Tudor Ambarus wrote:
> Depends on:
> [PATCH v2] crypto: rsa - return raw integers for the ASN.1 parser
>=20
> Changes in v6:
> - write descriptor PDB fields with inline append
> - move Protocol Data Block (pdb) structures to pdb.h
> - move setting of PDB fields in new functions
> - unmap sec4_sg_dma on done callback
> - remove redundant clean code on error path
> - fix doc typos
>=20
> Changes in v5:
> - sync with ASN.1 parser
>=20
> Changes in v4:
> - sync with ASN.1 parser
>=20
> Changes in v3:
> - sync with ASN.1 parser
>=20
> Changes in v2:
> - fix memory leaks on error path
> - rename struct akcipher_alg rsa to caam_rsa
>=20
>=20
> Tudor Ambarus (3):
>   crypto: scatterwak - Add scatterwalk_sg_copychunks
>   crypto: scatterwalk - export scatterwalk_pagedone
>   crypto: caam - add support for RSA algorithm
>=20
>  crypto/scatterwalk.c              |  31 ++-
>  drivers/crypto/caam/Kconfig       |  12 +
>  drivers/crypto/caam/Makefile      |   4 +
>  drivers/crypto/caam/caampkc.c     | 569 ++++++++++++++++++++++++++++=
++++++++++
>  drivers/crypto/caam/caampkc.h     |  56 ++++
>  drivers/crypto/caam/desc.h        |   2 +
>  drivers/crypto/caam/desc_constr.h |   7 +
>  drivers/crypto/caam/pdb.h         |  51 +++-
>  drivers/crypto/caam/pkc_desc.c    |  35 +++
>  include/crypto/scatterwalk.h      |   4 +
>  10 files changed, 768 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/crypto/caam/caampkc.c
>  create mode 100644 drivers/crypto/caam/caampkc.h
>  create mode 100644 drivers/crypto/caam/pkc_desc.c
>=20
Checked that when adding on top the patch set from here:
[PATCH v3 0/8] crypto: caam - add support for LS1043A SoC
https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg19096.html

RSA works on LS1043A, so

Tested-by: Horia Geant=E3 <horia.geanta@nxp.com>

Horia
