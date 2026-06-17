Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5C333A6E0;
	Wed, 17 Jun 2026 17:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781716696; cv=none; b=oTHuLJJ+dJfyeAmPzBp0wEjXnQL51HYA95bNN+9LHEl9gLofeSANV+IhISyhbw9JDUnINaybMepmoCwcogtV7H52NipfuC0SH1OHdEcYoU2uvAVSozIkCbD3rVEdlrlTE07uvrklpb6ZNO9iUzD3drZFs0hlf8n3b9Y9p9PvAoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781716696; c=relaxed/simple;
	bh=l8hcPdpn9AMbyB99DvePSyEqaE1eyDAHze7o2OkGcyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TgqMbPaQLnh63G3945YwBuvRFaqeah1TFLuHZJMamMdW9cMmmAK/j/te0IXAUhx5v4a0vTyhaZThmoYxL+/XantXKtQVAliVTAbrEZ1ajan58P0egw0UJAex31e3TUGgrkEoZb4rk1KOnqKkI9pSg/hWaB33gmXOBslhADOFnhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lGjKtV47; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lGjKtV47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72911F000E9;
	Wed, 17 Jun 2026 17:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781716694;
	bh=/f4xE4u+ffk1oOCvjwpeDXHL3oZ9vgO7YB9e19Vu9+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lGjKtV47NvY+G1P9uYXp+4/gyMgLgDQrduLqzC88KWb/cELicXoS4/uYfna+omLzA
	 kTHHIct7/E2IiozpSqUUXbTi0AVd24bRx7SBTtA3lHZSjIUIla+rki3EISH2x79xLE
	 CZUMDLUK7L9IaS4nt4AJcFcZOKp7PMVIBfV/yCOLJB0rS0RncSbTAIVo9CxmbK/Z8c
	 oQ5G8jwL3wjVVS4VFuozCCk5p8svSa1boqDf+QX5jj0Vgc0TOXUVQHzxUGMRBuH8/8
	 bNfs3awYHQHSiqXNUlqME9aeWEplWjUluKIFhib0XNuqoTUoh7Hj5pjz6T7DyKwkwA
	 rUHiH9wBR2reg==
Date: Wed, 17 Jun 2026 17:18:12 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Mike Lothian <mike@fireburn.co.uk>
Cc: rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Asahi Lina <lina+kernel@asahilina.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Krishna Ketan Rai <prafulrai522@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] rust: crypto: add library AES-128 / SHA-256 /
 HMAC-SHA256 bindings
Message-ID: <20260617171812.GE785086@google.com>
References: <20260617150143.2152-1-mike@fireburn.co.uk>
 <20260617150143.2152-2-mike@fireburn.co.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617150143.2152-2-mike@fireburn.co.uk>

On Wed, Jun 17, 2026 at 04:01:32PM +0100, Mike Lothian wrote:
> +/*
> + * AES-128 single-block ECB encryption: out = AES(key, in).
> + *
> + * A helper because aes_encrypt() takes a transparent union (aes_encrypt_arg)
> + * that bindgen cannot express. SHA-256 and HMAC-SHA256 are plain extern
> + * functions and are bound directly.
> + */
> +__rust_helper int
> +rust_helper_aes128_encrypt_block(const u8 *key, const u8 *in, u8 *out)
> +{
> +	struct aes_enckey enckey;
> +	int ret;
> +
> +	ret = aes_prepareenckey(&enckey, key, AES_KEYSIZE_128);
> +	if (ret)
> +		return ret;
> +	aes_encrypt(&enckey, out, in);
> +	memzero_explicit(&enckey, sizeof(enckey));
> +	return 0;
> +}

This is kind of an anti-pattern, both in expanding the key for every
block and also exposing bare AES instead of AES modes of operation.
It's true that lib/crypto/ is missing a lot of AES modes (I'm working on
that), but AES-CMAC is there already which is one of the two you need.

- Eric
