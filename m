Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1771DE894;
	Fri, 21 Aug 2026 03:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787281344; cv=none; b=ssNqHwGg33OyKUEvyrsBxOWZjLSAKlM49QZV2GSIn0CA0udhV/zUFBhFrc7O7KfkZ0MPYJ/rZEm6qBBoMVd/+UtXTI3r0FAjOCgFdRIE1Hk36HnqiEZ17J2RIOybcbR95dPOwe8Em595E6vKbkKHw9FjQIf7u94hnLdpKgY74Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787281344; c=relaxed/simple;
	bh=qnqaRB7nNdgSA026ZY1qQ1hUcjrdu7pE8LsbynHbof4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qgV1bnyJWW+URqMVaqShCvKKUi2M2Elucotk7kViP4O/CXmNTK5KcpalM0kG7+SVbgGcoIUJCKsHFlGkzq2EJfQbumcau6cybh/q3i7m7FXo8TgQcYhnOh8LRiiGl5qsUBXCwGTfCfK2mr42QCZBfxf62Bc5UdgwMZ8qzaIzTN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MP9irSsN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MP9irSsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746601F000E9;
	Fri, 21 Aug 2026 03:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787281343;
	bh=yQqHSIqNyc4PHFpn1E8swdiluWKo1xy24GDFNbPwmeo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MP9irSsN3zeZh1NcD69E76Ew8ShhQayETkEzOukVzCZfudsZ1bJxfK0LXIpbASuiP
	 x73X6fMDiHrqmVlK2LfoItQL78CQGndj0mYndDGT7WLtlcUDmhhWFbuypd1UMyGeLt
	 82WXvljmZ2wXOqwZ//OAcXUgReIMm/y+cY8ny+esgSZh6iJDhfFWcBYTgwnaHfldLl
	 4MTVUilGX0jioIluHW5EXTflyXIYk+wUggILHpzsPXKLQFCmUe9oRfo3azOjhFv8Wt
	 4KRR0ms6zT3sKokQD3O2blhgc/QyfvK0vagwJei9Rtxg5LYgd8afeYcS0SGwVO8fYx
	 dS+NRcmgz3Alw==
Date: Thu, 20 Aug 2026 20:00:18 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ayush Singh <ayush@beagleboard.org>
Cc: Jason Kridner <jkridner@beagleboard.org>, robertcnelson@gmail.com,
	Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ayush Singh <ayush@beagleboard.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, greybus-dev@lists.linaro.org,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 3/7] rust: crc_ccitt: add CRC-CCITT abstraction
Message-ID: <20260821030018.GA1961@sol>
References: <20260820-gb-uart-transport-v1-0-282da14ab7b7@beagleboard.org>
 <20260820-gb-uart-transport-v1-3-282da14ab7b7@beagleboard.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820-gb-uart-transport-v1-3-282da14ab7b7@beagleboard.org>

On Thu, Aug 20, 2026 at 02:55:45PM +0530, Ayush Singh wrote:
> The module is gated behind the new RUST_CRC_CCITT_ABSTRACTIONS Kconfig
> symbol, which selects CRC_CCITT, so the C library is only built when a
> Rust user actually needs it.
> 
> Signed-off-by: Ayush Singh <ayush@beagleboard.org>
> ---
>  MAINTAINERS                     |  1 +
>  lib/crc/Kconfig                 |  7 +++++++
>  rust/bindings/bindings_helper.h |  1 +
>  rust/kernel/crc_ccitt.rs        | 26 ++++++++++++++++++++++++++
>  rust/kernel/lib.rs              |  2 ++
>  5 files changed, 37 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6008f16ae2ca..1e3b42eff741 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6921,6 +6921,7 @@ T:	git https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git crc-ne
>  F:	Documentation/staging/crc*
>  F:	include/linux/crc*
>  F:	lib/crc/
> +F:	rust/kernel/crc*
>  F:	scripts/gen-crc-consts.py
>  
>  CREATIVE SB0540
> diff --git a/lib/crc/Kconfig b/lib/crc/Kconfig
> index 927fc6a6b2b9..aceb8fe8f0ed 100644
> --- a/lib/crc/Kconfig
> +++ b/lib/crc/Kconfig
> @@ -32,6 +32,13 @@ config CRC_CCITT
>  	  The CRC-CCITT library functions.  Select this if your module uses any
>  	  of the functions from <linux/crc-ccitt.h>.
>  
> +config RUST_CRC_CCITT_ABSTRACTIONS
> +	bool "Rust CRC-CCITT abstractions"
> +	depends on RUST
> +	select CRC_CCITT
> +	help
> +	  This enables the Rust abstraction for the CRC-CCITT API.

Like the other library kconfig symbols, this shouldn't have a prompt.
It should just be selected by the other symbols that need it.

> diff --git a/rust/kernel/crc_ccitt.rs b/rust/kernel/crc_ccitt.rs
> new file mode 100644
> index 000000000000..6042ada16967
> --- /dev/null
> +++ b/rust/kernel/crc_ccitt.rs

Is there a reason why the kconfig symbol is being put in lib/crc/ but
the actual code is being put in rust/kernel/?  It seems inconsistent.

- Eric
