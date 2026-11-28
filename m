Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795886729;
	b=IRnG0+TVh2tSAPwac6gM7YNLPcvKzhXeBuAAam2U5+ZS8RArGKHIdBRPiEDLQSvqwgHA
	 e8qrAsNQra+7zBvidUXvj3RjgbWLXuReitcz5RI17JbD/8HMu4+K67v+8Ka59Nuvl/H5R
	 FcmFDKmxh0/H8EIXxaaVazd62UCcybpUJISrf3hj2EQ1c2n5FdzSmCaohea2GM6DIvqMz
	 s8c3/f468koAXtOzOH761Da647TJDOk080QH4kygxp7FNvbuWMXrCstUCAXcxIa0ynUr3
	 7Cvt5Rv8MUK5q7BVBK1bSYO9abBl3AEsrI6ivSCPij2UClKHkRaz5/nuqv2/cH9E6NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795886729;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=GoINvI2p3H/uspH9CroxM8NPViIp5LkoZHRvOZM5sZg=;
	b=OGOM6P5xjbVsn0n8fnB38U/r0xBhMuBMJvcdCDeudfdMj/z5Iug0Lo+cYpcThyjg14E3
	 3vWF/7o8OIaPVEy5bP/xvAeUiuqQNF1gkScCtTPZZudPFwZ2NLUtXku4NBGDYRWewLujP
	 EVwAoavulIBWVUx5hWsKUXJJ9ZGBKurD8rMxljJ6SeQMvjH7rfqRq6g/1X8c10WysKcep
	 /XCCqEAlsI3aZfk4uSwsFNRweUbRAUBXnZUWYXRQtwxbve+DcbZPeyhDxJ3Ta0FmfIKCZ
	 DN0dj40ZgivTJ4zcbUiZ1xjrpr1/TGcBjcrhKY6lPKdXlL8EsAjhrOTxAjbTR1uylAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hAepRGn1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81800606A31C;
	Sat, 28 Nov 2026 17:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hAepRGn1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42FA1F00897;
	Sat, 28 Nov 2026 17:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795886729;
	bh=GoINvI2p3H/uspH9CroxM8NPViIp5LkoZHRvOZM5sZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hAepRGn1NtpgBwNVWLU0g+iiLrjKtBMWv/8z9D7zmFtuW9srlgaEoB+zHKo7j9Xyf
	 UfPLV5fdl7Q4kNTLgZ807VquHXvjgryXgAOI6ilYV7dHPMe7gFkAyFcZ3XL0N3jT5Z
	 mruVW4VNbZciiHo4gb6m+RmzyKmoTbzqmKZTXMXZ+IYNRpg16QpGHo4Y1zy7i9zRgm
	 i/JnRQnv65YDKUaHDd5wRvP6KBENDFaMALj6TfhMjNwQyzauMnh1gmA5oF2BdJQMN6
	 N8yJH0SWWwAngvHKIZVD1F3UrDaQraAd2gHl0muRct5wN/pEy7r/XiOYuuL2/dg5gM
	 LNDv6jGkepmxQ==
Date: Sat, 28 Nov 2026 18:25:24 +0100
From: Thorsten Blum <blum@kernel.org>
To: Ryan Prinz <rc4d5a@protonmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] crypto: atmel-ecc - fix missing ECDH public key
 validation
Message-ID: <awsOhD7tlH1YZPdr@kernel.org>
References: <20261125231745.1857056-1-rc4d5a@protonmail.com>
 <awouRON5Mgq6pbhf@kernel.org>
 <20261128084418.2057984-1-rc4d5a@protonmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261128084418.2057984-1-rc4d5a@protonmail.com>

Hi Ryan,

This should probably have been submitted as v2, not v3, but let's
continue with v4.

Please post each revision as a new thread to the list and not as a reply
to a review.

On Sat, Nov 28, 2026 at 08:46:06AM +0000, Ryan Prinz wrote:
> atmel_ecdh_compute_shared_secret() passes the peer's ECDH public point
> to the ATECC508A/608A/608B secure element without validating it; only
> req->src_len is checked.

Please clarify that this refers to software validation, as the device
may perform its own hardware validation.

> Add the same check to this driver's path, before the point reaches the
> I2C command, reusing ecc_is_pubkey_valid_partial().

Which same check? Somebody reading this later in the git history will
have no idea what you're referring to without the context of earlier
revisions.

[...]

>  drivers/crypto/atmel-ecc.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> --- a/drivers/crypto/atmel-ecc.c
> +++ b/drivers/crypto/atmel-ecc.c
> @@ -19,7 +19,9 @@
>  #include <linux/slab.h>
>  #include <linux/workqueue.h>
>  #include <crypto/internal/kpp.h>
> +#include <crypto/ecc_curve.h>
>  #include <crypto/ecdh.h>
> +#include <crypto/internal/ecc.h>

Please keep the crypto includes in alphabetical order.

>  #include <crypto/kpp.h>
>  #include "atmel-i2c.h"
> 
> @@ -146,6 +148,34 @@ static int atmel_ecdh_generate_public_key(struct kpp_request *req)
>  	return 0;
>  }
> 
> +static int atmel_ecdh_peer_pubkey_valid(struct scatterlist *src,
> +					unsigned int src_len)
> +{
> +	const struct ecc_curve *curve = ecc_get_curve(ECC_CURVE_NIST_P256);
> +	u8 pubkey_buf[ATMEL_ECC_PUBKEY_SIZE];
> +	u64 x[ECC_CURVE_NIST_P256_DIGITS], y[ECC_CURVE_NIST_P256_DIGITS];
> +	struct ecc_point pk;
> +	size_t copied;
> +
> +	if (!curve)
> +		return -EINVAL;

This check can be dropped as ecc_get_curve(ECC_CURVE_NIST_P256) always
returns a valid pointer.

> +	if (src_len != ATMEL_ECC_PUBKEY_SIZE)
> +		return -EINVAL;

The caller already checks the length, so this check is also redundant.

> +	copied = sg_copy_to_buffer(src, sg_nents_for_len(src, src_len),
> +				   pubkey_buf, src_len);

Could we validate work_data->cmd.data after atmel_i2c_init_ecdh_cmd()
and before enqueueing? That would avoid an extra copy.

Thanks,
Thorsten
