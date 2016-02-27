From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/3] crypto: caam - add support for RSA algorithm
Date: Sat, 27 Feb 2016 17:08:24 +0000
Message-ID: <20160227170824.GA8398@gondor.apana.org.au>
References: <VI1PR04MB131149561E463EA7BE714866B8A30@VI1PR04MB1311.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smueller@chronox.de, linux-crypto@vger.kernel.org,
	cristian.stoica@nxp.com, horia.geanta@nxp.com,
	alexandru.porosanu@nxp.com
To: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34832 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340AbcB0RIb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 27 Feb 2016 12:08:31 -0500
Content-Disposition: inline
In-Reply-To: <VI1PR04MB131149561E463EA7BE714866B8A30@VI1PR04MB1311.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com> wrote:
> Hi Stephan,
> 
>> -----Original Message-----
>> >+++ b/drivers/crypto/caam/caam_rsaprivkey.asn1
>> >@@ -0,0 +1,11 @@
>> >+RsaPrivKey ::= SEQUENCE {
>> >+    version         INTEGER,
>> >+    n               INTEGER ({ caam_rsa_get_n }),
>> >+    e               INTEGER ({ caam_rsa_get_e }),
>> >+    d               INTEGER ({ caam_rsa_get_d }),
>> >+    prime1          INTEGER,
>> >+    prime2          INTEGER,
>> >+    exponent1       INTEGER,
>> >+    exponent2       INTEGER,
>> >+    coefficient     INTEGER
>> >+}
>> 
>> Why do you define your own ASN.1 sequence? Why not using the common
>> crypto/rsaprivkey.asn1?
>> 
> 
> [ta] The functions indicated in crypto/rsaprivkey.asn1 return the key members in MPI format. Our hardware expects the keys as u8 buffers; retrieving the key members in MPI format and then writing them to u8 buffers would be an unnecessary step.

Is there any reason why we can't change it to return the raw
integer and make the software RSA implementation do the MPI parsing
instead?

As hardware RSA implementations are likely to want to use raw
integers we don't really want everyone to have their own parser.

I know qat has already gone in with its own parser but we should
fix it too.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
