From: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Subject: RE: [PATCH 3/3] crypto: caam - add support for RSA algorithm
Date: Tue, 1 Mar 2016 11:29:34 +0000
Message-ID: <AM3PR04MB1300EE085E6E20DB3E964F9CB8BB0@AM3PR04MB1300.eurprd04.prod.outlook.com>
References: <VI1PR04MB131149561E463EA7BE714866B8A30@VI1PR04MB1311.eurprd04.prod.outlook.com>
 <20160227170824.GA8398@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "smueller@chronox.de" <smueller@chronox.de>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Cristian Stoica" <cristian.stoica@nxp.com>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-am1on0057.outbound.protection.outlook.com ([157.56.112.57]:64704
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752026AbcCALpU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Mar 2016 06:45:20 -0500
In-Reply-To: <20160227170824.GA8398@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

> >> -----Original Message-----
> >> >+++ b/drivers/crypto/caam/caam_rsaprivkey.asn1
> >> >@@ -0,0 +1,11 @@
> >> >+RsaPrivKey ::= SEQUENCE {
> >> >+    version         INTEGER,
> >> >+    n               INTEGER ({ caam_rsa_get_n }),
> >> >+    e               INTEGER ({ caam_rsa_get_e }),
> >> >+    d               INTEGER ({ caam_rsa_get_d }),
> >> >+    prime1          INTEGER,
> >> >+    prime2          INTEGER,
> >> >+    exponent1       INTEGER,
> >> >+    exponent2       INTEGER,
> >> >+    coefficient     INTEGER
> >> >+}
> >>
> >> Why do you define your own ASN.1 sequence? Why not using the common
> >> crypto/rsaprivkey.asn1?
> >>
> >
> > [ta] The functions indicated in crypto/rsaprivkey.asn1 return the key
> members in MPI format. Our hardware expects the keys as u8 buffers;
> retrieving the key members in MPI format and then writing them to u8
> buffers would be an unnecessary step.
> 
> Is there any reason why we can't change it to return the raw
> integer and make the software RSA implementation do the MPI parsing
> instead?

You will have a duplicate key allocation for the RSA software implementation.
One when returning the raw integer and the other when doing the MPI parsing.
Can we live with the duplicate allocation?

Thanks,
ta
