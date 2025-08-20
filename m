Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0E236CE0B
	for <linux-crypto@vger.kernel.org>; Wed, 20 Aug 2025 18:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755715595; cv=none; b=EnkRBD9QZ9NLpVwEFX8NGhD5Thi1Gpr8UrdzP/GPM7ouUQ9NVcnwys2lTxK/NhKwmSrmzt8AB6hN4dRhnYeGyOmoVXpR9LgoGPM0GM6mNbdYHquWH3W200KbLkS0hjmYUiOLTjL2Fd6s+wLJSCnxZQClReaY4N7oxIB6JdBL0wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755715595; c=relaxed/simple;
	bh=P+VT/QpHjuwTmaUxpbbIuh2m8fFEWJiARnreN7fVcEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GGSBgsMtgoBjw7oM5jS+BedQlK/GAY7uFF4WfJMw1wDNxaFdFsfTxBFEDyK5N+T9ldObv8VSDr9zP8u8EaKaHfsNo+inrhv8F7SF35Vux7Hj9W/ogo0ISygW+rRrowqvjl5X87TfmLfeT4Y6et3TI0BlP8ogG8wiTJ47MovpwL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=shYTZggb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="shYTZggb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD38C4CEE7;
	Wed, 20 Aug 2025 18:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755715594;
	bh=P+VT/QpHjuwTmaUxpbbIuh2m8fFEWJiARnreN7fVcEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=shYTZggbgepXa6AqR6TvpViF9sgTmzGY0CLQJCtS/AuldI/1Su+ZLjqzdFdk6r6mN
	 dWCoM0i5bhCLcvHJg26zoFqXUyz+maed92if5EwwPDUQUUdiX7syQPmeH6I/wF/Ha9
	 TuaP7APyRXpXvanrGKVMeOukk/e6OVcO4swPZDOw2KvtPJV3hryPJeirSvLQHfcmwN
	 e0X6DKWkSKX4MI0TXLiED6Vc9LeVCDQRa+K+FY6VreiSvLxncoqa5xFnA5FHqksaSP
	 21xJBjk95V4Z/yg41ydoCwYMIUrDrUatrLXLdj2X0AmUrAT1DLwico69QUNxjhJPF/
	 N2zQ+i3uaGPhQ==
Date: Wed, 20 Aug 2025 11:46:33 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: hare@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>, Chris Leech <cleech@redhat.com>,
	linux-nvme@lists.infradead.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: hkdf: add hkdf_expand_label()
Message-ID: <20250820184633.GB1838@quark>
References: <20250820091211.25368-1-hare@kernel.org>
 <20250820091211.25368-2-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820091211.25368-2-hare@kernel.org>

On Wed, Aug 20, 2025 at 11:12:10AM +0200, hare@kernel.org wrote:
> From: Chris Leech <cleech@redhat.com>
> 
> Provide an implementation of RFC 8446 (TLS 1.3) HKDF-Expand-Label
> 
> Cc: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Chris Leech <cleech@redhat.com>
> Signed-off-by: Hannes Reinecke <hare@kernel.org>
> ---
>  crypto/hkdf.c         | 55 +++++++++++++++++++++++++++++++++++++++++++
>  include/crypto/hkdf.h |  4 ++++
>  2 files changed, 59 insertions(+)
> 
> diff --git a/crypto/hkdf.c b/crypto/hkdf.c
> index 82d1b32ca6ce..465bad6e6c93 100644
> --- a/crypto/hkdf.c
> +++ b/crypto/hkdf.c
> @@ -11,6 +11,7 @@
>  #include <crypto/sha2.h>
>  #include <crypto/hkdf.h>
>  #include <linux/module.h>
> +#include <linux/unaligned.h>
>  
>  /*
>   * HKDF consists of two steps:
> @@ -129,6 +130,60 @@ int hkdf_expand(struct crypto_shash *hmac_tfm,
>  }
>  EXPORT_SYMBOL_GPL(hkdf_expand);
>  
> +/**
> + * hkdf_expand_label - HKDF-Expand-Label (RFC 8846 section 7.1)
> + * @hmac_tfm: hash context keyed with pseudorandom key
> + * @label: ASCII label without "tls13 " prefix
> + * @label_len: length of @label
> + * @context: context bytes
> + * @contextlen: length of @context
> + * @okm: output keying material
> + * @okmlen: length of @okm
> + *
> + * Build the TLS 1.3 HkdfLabel structure and invoke hkdf_expand().
> + *
> + * Returns 0 on success with output keying material stored in @okm,
> + * or a negative errno value otherwise.
> + */
> +int hkdf_expand_label(struct crypto_shash *hmac_tfm,
> +		const u8 *label, unsigned int labellen,
> +		const u8 *context, unsigned int contextlen,
> +		u8 *okm, unsigned int okmlen)
> +{
> +	int err;
> +	u8 *info;
> +	unsigned int infolen;
> +	static const char tls13_prefix[] = "tls13 ";
> +	unsigned int prefixlen = sizeof(tls13_prefix) - 1; /* exclude NUL */
> +
> +	if (WARN_ON(labellen > (255 - prefixlen)))
> +		return -EINVAL;
> +	if (WARN_ON(contextlen > 255))
> +		return -EINVAL;
> +
> +	infolen = 2 + (1 + prefixlen + labellen) + (1 + contextlen);
> +	info = kzalloc(infolen, GFP_KERNEL);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	/* HkdfLabel.Length */
> +	put_unaligned_be16(okmlen, info);
> +
> +	/* HkdfLabel.Label */
> +	info[2] = prefixlen + labellen;
> +	memcpy(info + 3, tls13_prefix, prefixlen);
> +	memcpy(info + 3 + prefixlen, label, labellen);
> +
> +	/* HkdfLabel.Context */
> +	info[3 + prefixlen + labellen] = contextlen;
> +	memcpy(info + 4 + prefixlen + labellen, context, contextlen);
> +
> +	err = hkdf_expand(hmac_tfm, info, infolen, okm, okmlen);
> +	kfree_sensitive(info);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(hkdf_expand_label);

Does this belong in crypto/hkdf.c?  It seems to be specific to a
particular user of HKDF.

- Eric
