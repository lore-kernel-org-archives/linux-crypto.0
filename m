From: Michael Halcrow <mike@halcrow.us>
Subject: Re: [PATCH 1/1]: Add countersize to CTR
Date: Tue, 23 Oct 2007 15:40:08 -0500
Message-ID: <20071023204007.GT1635@halcrow.us>
References: <200710232026.l9NKQTkC000737@faith.austin.ibm.com>
Reply-To: Michael Halcrow <mike@halcrow.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="IfZ+tgy+ooJOsAAy"
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	mikko.herranen@cs.helsinki.fi
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:24397 "EHLO
	nlpi001.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbXJWU7j (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Oct 2007 16:59:39 -0400
Content-Disposition: inline
In-Reply-To: <200710232026.l9NKQTkC000737@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--IfZ+tgy+ooJOsAAy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 23, 2007 at 03:26:29PM -0500, Joy Latten wrote:
> +	unsigned int countersize;

It's somewhat nicer to just use size_t in the kernel for these sorts
of data types. If you care about the exact number of bytes used by the
variable, types like u32 make the code more parsable.

> +	err = crypto_attr_u32(tb[4], &countersize);
> +	if (err)
> +		goto out_put_alg;

It's also nice to have printk's along error paths. Syslogs down the
road tend to be less cryptic.

> -		test_cipher("ctr(aes,4,8)", ENCRYPT, aes_ctr_enc_tv_template,
> +		test_cipher("ctr(aes,4,8,4)", ENCRYPT, aes_ctr_enc_tv_template,
>  			    AES_CTR_ENC_TEST_VECTORS);
> -		test_cipher("ctr(aes,4,8)", DECRYPT, aes_ctr_dec_tv_template,
> +		test_cipher("ctr(aes,4,8,4)", DECRYPT, aes_ctr_dec_tv_template,
>  			    AES_CTR_DEC_TEST_VECTORS);

I have never been particularly thrilled about the the string-based
method of parameterizing block ciphers for in-kernel API calls.

Mike

--IfZ+tgy+ooJOsAAy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iQEVAwUBRx5cJ9tAhTFtyodpAQOjpAgAldB6N2TjYACFwcAa1vg45lX4k2na7O06
RjzlAK9ossZ/6G/McghrM89Xtifp+89W9w77oKP/zzXZfZ1VtZcTfcwcAUtV5W3F
klz4sS3bq2EsjzwFAXOnqKHLzkeDBM4YFlwDfZ1FWtWNLerTe204rYP38+Py9FHh
Ou1UMSRgafzUUs5Li3fj1iRzhQb+D3nWS3wLh/sWAKUqUDfPTyWmPj38wMzv4WMn
DL834ub7L/5aXj8QAvSU4hrHpWGzk3y55Ct7SXsHuYEJQIbUdwXx8E2v2rxypsS6
ETMks/8nsPYjtcVLeylfh71iN0FunxXDQ8PyHuq9ag455o/3v8r6Bg==
=DF9k
-----END PGP SIGNATURE-----

--IfZ+tgy+ooJOsAAy--
