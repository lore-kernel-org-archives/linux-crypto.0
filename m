From: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Subject: RE: [PATCH 3/3] crypto: caam - add support for RSA algorithm
Date: Mon, 22 Feb 2016 11:40:49 +0000
Message-ID: <VI1PR04MB131149561E463EA7BE714866B8A30@VI1PR04MB1311.eurprd04.prod.outlook.com>
References: <1456132577-332-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <1456132577-332-3-git-send-email-tudor-dan.ambarus@nxp.com>
 <4006899.JzsglbT4Hf@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Cristian Stoica" <cristian.stoica@nxp.com>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db3on0098.outbound.protection.outlook.com ([157.55.234.98]:22003
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754213AbcBVMM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Feb 2016 07:12:59 -0500
In-Reply-To: <4006899.JzsglbT4Hf@tauon.atsec.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

> -----Original Message-----
> >+++ b/drivers/crypto/caam/caam_rsaprivkey.asn1
> >@@ -0,0 +1,11 @@
> >+RsaPrivKey ::= SEQUENCE {
> >+	version		INTEGER,
> >+	n		INTEGER ({ caam_rsa_get_n }),
> >+	e		INTEGER ({ caam_rsa_get_e }),
> >+	d		INTEGER ({ caam_rsa_get_d }),
> >+	prime1		INTEGER,
> >+	prime2		INTEGER,
> >+	exponent1	INTEGER,
> >+	exponent2	INTEGER,
> >+	coefficient	INTEGER
> >+}
> 
> Why do you define your own ASN.1 sequence? Why not using the common
> crypto/rsaprivkey.asn1?
> 

[ta] The functions indicated in crypto/rsaprivkey.asn1 return the key members in MPI format. Our hardware expects the keys as u8 buffers; retrieving the key members in MPI format and then writing them to u8 buffers would be an unnecessary step.

> >diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
> >new file mode 100644
> >index 0000000..8dd5ff2
> >--- /dev/null
> >+++ b/drivers/crypto/caam/caampkc.c
> >@@ -0,0 +1,616 @@
> >+int caam_rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
> >+		   const void *value, size_t vlen)
> 
> This function and the following functions are very similar to the ones in
> rsa_helper.c -- shouldn't those be used instead?
> 

[ta] Those functions use the MPI lib and I don't need it.

> >+static void rsa_free_key(struct caam_pkc_context *ctx)
> >+{
> >+	kfree(ctx->n);
> >+	ctx->n = NULL;
> >+	kfree(ctx->e);
> >+	ctx->e = NULL;
> >+
> >+	if (ctx->d) {
> >+		memset(ctx->d, '\0', ctx->key_sz);
> >+		kfree(ctx->d);
> 
> kzfree, please
> 

Thanks,
ta
