Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3533E1FDA
	for <linux-crypto@vger.kernel.org>; Tue, 23 Jul 2024 01:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721699237; cv=none; b=QoNrbo+XEJRVqbP2YNhi3KDkHzQHAmYbtP939mjbv/5o2N30Jd2kn3ruoY9foK9nFn7018LkYkksRZwb2A0wycx2ZSTIkIVoiVoitjEB3RtjbdrcJ246jtqny/nlv8pMKvzZE6hRhyRDwpIyuuW2AixZhP9wpqoD0Q5dI/8q4/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721699237; c=relaxed/simple;
	bh=1qD7OygewgIbFcjAXnb+L1GDWAFAWUP1dFyU5n2QMw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jprBtogDkaJfeJUGsKJIXAm+vVprKqm2X2LCF2LrPeE0F7F1qljkuD6nJIObB3jZDGa6G6waupew6vFCk4W5j20I7IajDYIPSKUlan+7MlfSUBGQMCRpDHlHMqfNJQ5uM+5YtUfv5qBVPyDAZThnKW7Umweegws5gD7901FHOcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qvFaOE7u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qvFaOE7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E131AC116B1;
	Tue, 23 Jul 2024 01:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721699237;
	bh=1qD7OygewgIbFcjAXnb+L1GDWAFAWUP1dFyU5n2QMw4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qvFaOE7unC9L3dtAZBCnEwLCvyRr+pBBDzO1z/+4bpUCUZADpdUDn7dvHZuvJ2Nvj
	 8WXVlkJ2p2l2JJK19JvoCZKX4PxlYTSfka7IV2NsKhDk30htSPBIp1niqDZX/xXRQq
	 rnf2Pg+UvWf7nMT5FGQnTwZw/nq/mkM7Mkge6TiEfmCBYgOdiEnJFRb3tpliM2n6cP
	 hueXAlp2gzyYR+8ClamueqqJdJgcLdfjXyqAuLLG8eMoCn8ynXhC/oLAGfsDnsBSpU
	 wbw0NNZMw4RrSBcqbzGXnS9B7AuB8P4R0wEXeB1J0X5NdebO2k/nIWcnSDbxvAPH4L
	 AlvMq6niV6XTQ==
Date: Tue, 23 Jul 2024 01:47:15 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Hannes Reinecke <hare@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>, linux-crypto@vger.kernel.org,
	linux-nvme@lists.infradead.org
Subject: Re: [PATCH 4/9] nvme: add nvme_auth_derive_tls_psk()
Message-ID: <20240723014715.GB2319848@google.com>
References: <20240722142122.128258-1-hare@kernel.org>
 <20240722142122.128258-5-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240722142122.128258-5-hare@kernel.org>

On Mon, Jul 22, 2024 at 04:21:17PM +0200, Hannes Reinecke wrote:
> +/*
> + * Derive a TLS PSK as specified in TP8018 Section 3.6.1.3:
> + *   TLS PSK and PSK identity Derivation
> + *
> + * The TLS PSK shall be derived as follows from an input PSK
> + * (i.e., either a retained PSK or a generated PSK) and a PSK
> + * identity using the HKDF-Extract and HKDF-Expand-Label operations
> + * (refer to RFC 5869 and RFC 8446) where the hash function is the
> + * one specified by the hash specifier of the PSK identity:
> + * 1. PRK = HKDF-Extract(0, Input PSK); and
> + * 2. TLS PSK = HKDF-Expand-Label(PRK, "nvme-tls-psk", PskIdentityContext, L),
> + * where PskIdentityContext is the hash identifier indicated in
> + * the PSK identity concatenated to a space character and to the
> + * Base64 PSK digest (i.e., "<hash> <PSK digest>") and L is the
> + * output size in bytes of the hash function (i.e., 32 for SHA-256
> + * and 48 for SHA-384).
> + */
> +int nvme_auth_derive_tls_psk(int hmac_id, u8 *psk, size_t psk_len,
> +		u8 *psk_digest, u8 **ret_psk)
> +{
> +	struct crypto_shash *hmac_tfm;
> +	const char *hmac_name;
> +	const char *psk_prefix = "tls13 nvme-tls-psk";
> +	size_t info_len, prk_len;
> +	char *info;
> +	unsigned char *prk, *tls_key;
> +	int ret;
> +
> +	hmac_name = nvme_auth_hmac_name(hmac_id);
> +	if (!hmac_name) {
> +		pr_warn("%s: invalid hash algoritm %d\n",
> +			__func__, hmac_id);
> +		return -EINVAL;
> +	}
> +	if (hmac_id == NVME_AUTH_HASH_SHA512) {
> +		pr_warn("%s: unsupported hash algorithm %s\n",
> +			__func__, hmac_name);
> +		return -EINVAL;
> +	}
> +
> +	hmac_tfm = crypto_alloc_shash(hmac_name, 0, 0);
> +	if (IS_ERR(hmac_tfm))
> +		return PTR_ERR(hmac_tfm);
> +
> +	prk_len = crypto_shash_digestsize(hmac_tfm);
> +	prk = kzalloc(prk_len, GFP_KERNEL);
> +	if (!prk) {
> +		ret = -ENOMEM;
> +		goto out_free_shash;
> +	}
> +
> +	ret = hkdf_extract(hmac_tfm, psk, psk_len, prk);
> +	if (ret)
> +		goto out_free_prk;
> +
> +	ret = crypto_shash_setkey(hmac_tfm, prk, prk_len);
> +	if (ret)
> +		goto out_free_prk;
> +
> +	info_len = strlen(psk_digest) + strlen(psk_prefix) + 1;
> +	info = kzalloc(info_len, GFP_KERNEL);
> +	if (!info)
> +		goto out_free_prk;
> +
> +	memcpy(info, psk_prefix, strlen(psk_prefix));
> +	memcpy(info + strlen(psk_prefix), psk_digest, strlen(psk_digest));

The code doesn't match the description given in the function comment (which
looks like it was quoted from a specification).

The code does HKDF-Expand with info="tls13 nvme-tls-psk<PSK digest>".

The description does HKDF-Expand-Label with Label="nvme-tls-psk",
Context="<hash identifier> <PSK digest>", Length=digest_size.

Not only does the code not actually use <hash identifier>, but it doesn't follow
the definition of HKDF-Expand-Label from RFC8446
(https://datatracker.ietf.org/doc/html/rfc8446#section-7.1) in that it's missing
all the length fields.  So the info string used by the actual code ends up being
quite different from the one specified.

- Eric
