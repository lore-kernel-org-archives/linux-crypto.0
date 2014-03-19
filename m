From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 1/6] SP800-90A Deterministic Random Bit Generator
Date: Wed, 19 Mar 2014 08:51:45 +0100
Message-ID: <34882876.HnRfi0MJtt@myon.chronox.de>
References: <2396177.vxvG2ljJL8@myon.chronox.de> <5770301.bQ9lKffXf3@myon.chronox.de> <3662681.npTzbSq3ye@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: aquini@redhat.com, jeremy.wayne.powell@gmail.com
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:28726 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757420AbaCSHvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Mar 2014 03:51:54 -0400
In-Reply-To: <3662681.npTzbSq3ye@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 17. M=E4rz 2014, 08:34:06 schrieb Stephan Mueller:

> +static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pe=
rs,
> +		     bool reseed)
> +{
> +	int ret =3D 0;
> +	unsigned char *entropy =3D NULL;
> +	size_t entropylen =3D 0;
> +	struct drbg_string data1;
> +	struct drbg_string *data2;
> +
> +	/* 9.1 / 9.2 / 9.3.1 step 3 */
> +	if (pers && pers->len > (drbg_max_addtl(drbg)))
> +		return -EINVAL;
> +
> +	if (drbg->test_data) {
> +		data1.buf =3D drbg->test_data->testentropy->buf;
> +		data1.len =3D drbg->test_data->testentropy->len;
> +		data1.next =3D NULL;
> +	} else {
> +		/* Gather entropy equal to the security strength of the DRBG.
> +		 * With a derivation function, a nonce is required in addition
> +		 * to the entropy. A nonce must be at least 1/2 of the=20
security
> +		 * strength of the DRBG in size. Thus, entropy * nonce is 3/2
> +		 * of the strength. The consideration of a nonce is only
> +		 * applicable during initial seeding. */
> +		entropylen =3D (drbg_sec_strength(drbg->core->flags) / 8);

drbg_sec_strength returns the strength in bytes, thus the division by 8=
 must=20
be removed

> +		if (!entropylen)
> +			return -EFAULT;
> +		if (!reseed)
> +			/* make sure we round up strength/2 in
> +			 * case it is not divisible by 2 */
> +			entropylen =3D ((entropylen + 1) / 2) * 3;
> +
> +		entropy =3D kzalloc(entropylen, GFP_KERNEL);
> +		if (!entropy)
> +			return -ENOMEM;
> +		get_random_bytes(entropy, entropylen);
> +		drbg_string_fill(&data1, entropy, entropylen);
> +	}
> +
> +	/* concatenation of entropy with personalization str / addtl input)=
 */
> +	if (pers && 0 < pers->len) {
> +		data2 =3D pers;
> +		data2->next =3D NULL;
> +		data1.next =3D data2;
> +	}
> +
> +	ret =3D drbg->d_ops->update(drbg, &data1, reseed);
> +	if (ret)
> +		goto out;
> +
> +	drbg->seeded =3D true;
> +	/* 10.1.1.2 / 10.1.1.3 step 5 */
> +	drbg->reseed_ctr =3D 1;
> +
> +out:
> +	if (entropy)
> +		kzfree(entropy);
> +	return ret;
> +}
> +

[...]=20
> +static unsigned int drbg_generate(struct drbg_state *drbg,
> +				  unsigned char *buf, unsigned int buflen,
> +				  struct drbg_string *addtl)
> +{
> +	unsigned int len =3D 0;
> +	struct drbg_state *shadow =3D NULL;
> +
> +	if (0 =3D=3D buflen || !buf)
> +		return 0;
> +	if (addtl && NULL =3D=3D addtl->buf && 0 < addtl->len)
> +		return 0;
> +
> +	if (drbg_make_shadow(drbg, &shadow))
> +		return 0;
> +	/* 9.3.1 step 2 */
> +	if (buflen > (drbg_max_request_bytes(shadow)))
> +		goto err;
> +	/* 9.3.1 step 3 is implicit with the chosen DRBG */
> +	/* 9.3.1 step 4 */
> +	if (addtl && addtl->len > (drbg_max_addtl(shadow)))
> +		goto err;
> +	/* 9.3.1 step 5 is implicit with the chosen DRBG */
> +	/* 9.3.1 step 6 and 9 supplemented by 9.3.2 step c -- the spec is a
> +	 * bit convoluted here, we make it simpler */
> +	if ((drbg_max_requests(shadow)) < shadow->reseed_ctr)
> +		shadow->seeded =3D false;
> +
> +	/* allocate cipher handle */
> +	if (shadow->d_ops->crypto_init && shadow->d_ops->crypto_init(shadow=
))
> +		goto err;
> +
> +	if (shadow->pr || !shadow->seeded) {
> +		/* 9.3.1 steps 7.1 through 7.3 */
> +		if (drbg_seed(shadow, addtl, true))
> +			goto err;
> +		/* 9.3.1 step 7.4 */
> +		addtl =3D NULL;
> +	}
> +	/* 9.3.1 step 8 and 10 */
> +	len =3D drbg->d_ops->generate(shadow, buf, buflen, addtl);

This needs to be shadow->d_ops
> +
> +	/* 10.1.1.4 step 6, 10.1.2.5 step 7, 10.2.1.5.2 step 7 */
> +	shadow->reseed_ctr++;
> +
> +err:
> +	if (shadow->d_ops->crypto_fini)
> +		shadow->d_ops->crypto_fini(shadow);
> +	drbg_restore_shadow(drbg, &shadow);
> +	return len;
> +}

Ciao
Stephan
