Return-Path: <SRS0=Z4qA=PO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:11080 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfAFSL5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Jan 2019 13:11:57 -0500
From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] crypto: Add EC-RDSA algorithm
Date: Sun, 06 Jan 2019 19:11:50 +0100
Message-ID: <1893001.R2IGJoHzOM@positron.chronox.de>
In-Reply-To: <20190106133608.820-5-vt@altlinux.org>
References: <20190106133608.820-1-vt@altlinux.org> <20190106133608.820-5-vt@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 6. Januar 2019, 14:36:08 CET schrieb Vitaly Chikunov:

Hi Vitaly,

> Add Elliptic Curve Russian Digital Signature Algorithm (GOST R
> 34.10-2012, RFC 7091, ISO/IEC 14888-3) is one of the Russian (and since
> 2018 the CIS countries) cryptographic standard algorithms (called GOST
> algorithms). Only signature verification is supported, with intent to be
> used in the IMA.

Do you happen to have test vectors for the testmgr?


> +
> +/* Parse DER encoded subjectPublicKey. */
> +static int ecrdsa_set_pub_key(struct crypto_akcipher *tfm, const void *ber,
> +			      unsigned int len)
> +{
> +	struct ecrdsa_ctx *ctx = akcipher_tfm_ctx(tfm);
> +	unsigned int ndigits;
> +	const u8 *k = ber;
> +	unsigned int offset;
> +
> +	/* First chance to zero ctx */
> +	memset(ctx, 0, sizeof(*ctx));
> +
> +	if (len < 3 ||
> +	    k[0] != 0x04 || /* OCTET STRING */
> +	    (k[1] < 0x80 && len != k[1] + 2) ||
> +	    (k[1] == 0x81 && len != k[2] + 3) ||
> +	    k[1] > 0x81)
> +		return -EBADMSG;
> +	offset = (k[1] < 0x80)? 2 : 3;
> +	k += offset;
> +	len -= offset;

Why do you manually parse the ASN.1 structure instead of using the ASN.1 
parser?

> +	/* Key is two 256- or 512-bit coordinates. */
> +	if (len != (2 * 256 / 8) &&
> +	    len != (2 * 512 / 8))
> +		return -ENOPKG;
> +	ndigits = len / sizeof(u64) / 2;
> +	ctx->pub_key = ECC_POINT_INIT(ctx->_pubp[0], ctx->_pubp[1], ndigits);
> +	vli_from_le64(ctx->pub_key.x, k, ndigits);
> +	vli_from_le64(ctx->pub_key.y, k + ndigits * sizeof(u64), ndigits);
> +
> +	return 0;
> +}
> +
> +/* Parse DER encoded SubjectPublicKeyInfo.AlgorithmIdentifier.parameters.
> */ +static int ecrdsa_set_params(struct crypto_akcipher *tfm, enum OID
> algo, +			     const void *params, unsigned int paramlen)
> +{
> +	struct ecrdsa_ctx *ctx = akcipher_tfm_ctx(tfm);
> +	const u8 *p = params;
> +	int i;
> +
> +	if (algo == OID_gost2012PublicKey256) {
> +		ctx->digest	= "streebog256";
> +		ctx->digest_oid	= OID_gost2012Digest256;
> +		ctx->digest_len	= 256 / 8;
> +	} else if (algo == OID_gost2012PublicKey512) {
> +		ctx->digest	= "streebog512";
> +		ctx->digest_oid	= OID_gost2012Digest512;
> +		ctx->digest_len	= 512 / 8;
> +	} else
> +		return -ENOPKG;
> +	ctx->curve = NULL;
> +	ctx->curve_oid = 0;
> +	ctx->algo_oid = algo;
> +
> +	for (i = 0; i < paramlen; i += p[i + 1] + 2) {
> +		const struct ecc_curve *curve;
> +		enum OID oid;
> +
> +		if (paramlen - i < 2 ||
> +		    p[i] != 0x06 || /* OBJECT IDENTIFIER */

Same here and in the following

> +		    p[i + 1] > paramlen - i - 2)
> +			return -EBADMSG;
> +		oid = look_up_OID(p + i + 2, p[i + 1]);
> +		if (oid == OID__NR)
> +			return -ENOPKG;
> +
> +		if (oid == OID_gost2012Digest256 ||
> +		    oid == OID_gost2012Digest512) {
> +			if (oid != ctx->digest_oid)
> +				return -ENOPKG;
> +		} else {
> +			curve = get_curve_by_oid(oid);
> +			if (!curve || ctx->curve)
> +				return -ENOPKG;
> +			ctx->curve = curve;
> +			ctx->curve_oid = oid;
> +		}
> +	}
> +	/* Sizes of algo, curve, pub_key, and digest should match each other. */
> +	if (!ctx->curve ||
> +	    ctx->curve->g.ndigits * sizeof(u64) != ctx->digest_len ||
> +	    ctx->curve->g.ndigits != ctx->pub_key.ndigits)
> +		return -ENOPKG;
> +
> +	/* First chance to validate the public key. */
> +	if (ecc_is_pubkey_valid_partial(ctx->curve, &ctx->pub_key))
> +		return -EKEYREJECTED;
> +
> +	return 0;
> +}
> +

> +MODULE_ALIAS_CRYPTO("ecrdsa");

I do not think you need that alias as the module name already will be named 
this way. I guess you rather should add ecrdsa-generic as module alias.



Ciao
Stephan
