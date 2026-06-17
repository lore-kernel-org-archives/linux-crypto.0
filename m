Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA462375F8E;
	Wed, 17 Jun 2026 17:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781718756; cv=none; b=TeA5yh6ZHt/236sXLPBZ6wIaJsZq8MR64Av/nIJRT8Ml7DOUCPamVnPDPBOJqL6zmB2CEyclnnyfrRDPVzpIVzjfYXAHrU/9vVlupKdTPhMqCaZ24Y1lg5QJATRFHpV9oV1qJXmmBIkWDi/Npx8w4Umzfe0rAZ1XQZgTH3e+vbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781718756; c=relaxed/simple;
	bh=x7t8hhmqX9+kcaLwuSWvihabD9248t8+GAYxlxSb3QM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z9I6MdjmWr1FtLoCYJZUeWwZOAxs8rzZJPpqVC9RD7tfabDdVgmA3je7xGQNVR+n2a0s1GXdiiirrohzbLLoM0tPTAeQ6wpthNSKjcuKo9XFYSHjEhw+0Vj0lpzei4iTfmMePIwUslTCw1x8OUgGuG17cUhkg769TjSQ3reu6P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DcCogTJC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DcCogTJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2021F000E9;
	Wed, 17 Jun 2026 17:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781718755;
	bh=zlxyb6tK+cgT4hkcQSggGyv1AE7xUuhts4Aau+pWaZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DcCogTJCn9XXFP1PANQFwGbAZOhA7dTrLW9o7KWrSM0ctdI2Sgx8Esu7pt7ZTrwxT
	 Dj/rgCt1FLbtQAIxJYwBAIIdFUUdEyTW5+b5NPsBvsl6SffRE7kwahaLMpCfX0aw/I
	 ywxMMg9un8dtVZNovkqm/C6J5KRN45h+uDluTTKeH9cQnHFgpkcDxObc30GXWr/C13
	 4vpLn9ABy4e3Qqmgj6FcWtIfz2cY3+iuWHbW9FgcTWLgjVrCENSp2iU1q3MrEOMPMN
	 P1cqyt2qaH5wL+VrqIyl1A9jotFUiUDfK+WJiBb/+/1WBbXqz4U/KrDAHkLxd2vOWw
	 rA5CPs2gIf8fw==
Date: Wed, 17 Jun 2026 17:52:33 +0000
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
Subject: Re: [RFC PATCH 2/2] rust: crypto: add RSA public-key encryption via
 crypto_akcipher
Message-ID: <20260617175233.GF785086@google.com>
References: <20260617150143.2152-1-mike@fireburn.co.uk>
 <20260617150143.2152-3-mike@fireburn.co.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617150143.2152-3-mike@fireburn.co.uk>

On Wed, Jun 17, 2026 at 04:01:33PM +0100, Mike Lothian wrote:
> Add a Rust binding for the asynchronous public-key cipher API
> (crypto_akcipher), driven synchronously, and a crypto::rsa_pubkey_encrypt()
> convenience built on it.

Could you keep the crypto_akcipher support private to the file and just
expose rsa_pubkey_encrypt()?  I don't want the use of crypto_akcipher to
be growing significantly.  It's a very bad API, as I think is clear by
all the workarounds you had to implement to use it.  I'd like to replace
it with lib/crypto/ APIs for RSA eventually.

- Eric
