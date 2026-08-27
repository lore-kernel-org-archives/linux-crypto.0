Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D9738238A;
	Thu, 27 Aug 2026 03:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787799959; cv=none; b=cZL2+lfa+YCjupHZ3pkZvEVWbsE6YeDbYQUumH8kSIMzXf+ITvSRsONhgPAqKsn9Z0fJKa/zHTg8lUa+/8rrTnidcqfuI34WWzPP8VMmvv5NVVzkvaumF5bRgQt7tyee8pNmrHs2K8DnnKB0LlvtMX15AqCq2R9W44dqLQ84SD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787799959; c=relaxed/simple;
	bh=AUx7U3OpWJcrye93z38lmXpDH4ADz5pRhq1T4nZWzLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZtRoTCqqL1Xl+o5zN12uSdsCVkqj5orMZ24y0GgztLgWnIFGp2BBO7XG8X7Ys4CP/JVYJ2EYMRe3AEvjQXOgorFadGS+76aJfqSfl9DuYqrMBcMgDP2FJU2gLhChMRv5643RjKNYyyY3beCLWyPm5apdqwlEE4yRSYMdd9+s+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KgtOCfGU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KgtOCfGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F0F1F000E9;
	Thu, 27 Aug 2026 03:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787799957;
	bh=k8RVPVMvXObg79Z+d2yr4Qr7Zpo99L01oMO9TL4qGKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KgtOCfGUqH0E3we6ceMOklZKjQ7GgeMzUFGCsSG4Gbdkf7i+Brr6QCWOX+5dvr4+w
	 /A1Otz23lnUucA33XK2Mb+LW13Zy/Di9CFjCwaPXutTvM7vYooZkjNJ2ZSdGetPoX/
	 5Bf/CJT84LA1HlMhycAVG4kgYdYnZ2870exm6pEv/QNIKEWASijtInLXgTMCn5Xo+j
	 +KOqY0r3GkxN24UBvdDS5WcRgaC6tKeUL8cc9JvA7UFcsgFIUop0Cqp21bahgWbaZP
	 Z16KRunuY6kNKzyc2msM2C4O8DVQy18DXn8C6buLTmSPq8nuZLJnLJEsY4hTDg44+s
	 OqI0YELdylTsg==
Date: Wed, 26 Aug 2026 20:03:52 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Mike Lothian <mike@fireburn.co.uk>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Lyude Paul <lyude@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Asahi Lina <lina+kernel@asahilina.net>, Burak Emir <bqe@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Yury Norov <ynorov@nvidia.com>, David Gow <david@davidgow.net>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v3 2/2] rust: crypto: add synchronous RSA akcipher support
Message-ID: <20260827030352.GB2327@sol>
References: <20260826163004.3365-1-mike@fireburn.co.uk>
 <20260826163004.3365-3-mike@fireburn.co.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826163004.3365-3-mike@fireburn.co.uk>

On Wed, Aug 26, 2026 at 05:29:49PM +0100, Mike Lothian wrote:
> +config RUST_CRYPTO_LIB_AES
> +	bool
> +	depends on RUST
> +	select CRYPTO_LIB_AES
> +	select CRYPTO_LIB_AES_CBC_MACS
> +	help
> +	  Enable the Rust bindings for the synchronous AES library functions.
> +	  The selected C libraries are built into the kernel because Rust
> +	  abstractions are part of the built-in kernel crate.

This is being added in the wrong patch.

>  config CRYPTO_LIB_AESGCM
>  	tristate
>  	select CRYPTO_LIB_AES
> @@ -216,6 +226,15 @@ config CRYPTO_LIB_SHA256
>  	  Select this if your module uses any of these functions from
>  	  <crypto/sha2.h>.
>  
> +config RUST_CRYPTO_LIB_SHA256
> +	bool
> +	depends on RUST
> +	select CRYPTO_LIB_SHA256
> +	help
> +	  Enable the Rust bindings for the synchronous SHA-256 and HMAC-SHA256
> +	  library functions. The selected C library is built into the kernel
> +	  because Rust abstractions are part of the built-in kernel crate.

Likewise.

As I've been commenting on other of these bindings patches, it also
doesn't really make sense to have the kconfig symbol be in lib/ but then
have the actual code be in rust/.  They should be in the same place.

> +__rust_helper void rust_helper_memzero_explicit(void *s, size_t count)
> +{
> +	memzero_explicit(s, count);
> +}

Isn't there a standard Rust solution for this?

> +#ifdef CONFIG_RUST_CRYPTO_AKCIPHER
> +__rust_helper void rust_helper_crypto_free_akcipher(struct crypto_akcipher *tfm)
> +{
> +	crypto_free_akcipher(tfm);
> +}

If you need RSA, then please just create an API for RSA specifically.
The crypto_akcipher abstraction has never worked well, due to
differences between the algorithms and various other reasons.

> +__rust_helper void rust_helper_aes_enckey_zero(struct aes_enckey *key)
> +{
> +	memzero_explicit(key, sizeof(*key));
> +}

Similarly, isn't there a standard Rust solution to zeroize memory?

- Eric
