Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B3848BD35;
	Wed, 26 Aug 2026 22:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787782163; cv=none; b=JvC6cIFwrE10XIbfGEIgm4YshKFCxIuRFUwweT1MlKbCCVPvqolgle62LhAM0D/vzqzwjP9NdP/9ifLQrVPVuOfUQfDShtRIzmU7QZMcubbDy88v3rv0NJD620lGKEZHSuP27N4ZwUj9VjVJZ2kJXwW0rx3EtyAISZR98/DiMLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787782163; c=relaxed/simple;
	bh=iTKpZVVyrvHn2/PCIjerZLBtqXbA9duX7JUWfnO/5NE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rtDm7elu+E9WEw/tU/lD/su0A215azU4GMZThpZzq3jb0YIB/+Zk7jU3Yu2JG4/9ST4uchXLFnj1ajUaD8kbC68pBlZuD7SJJ1sQcpNfi/e6y4nr8RcUIlNJM0ZcXGdnwn88hKsncvs0DyY8eiAvXdmr8HPtTb0MoPeiElmN1nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GBvqK8f7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GBvqK8f7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2B21F00A3A;
	Wed, 26 Aug 2026 22:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787782161;
	bh=iTKpZVVyrvHn2/PCIjerZLBtqXbA9duX7JUWfnO/5NE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GBvqK8f7dmrEM3THcISrY5CFpwfXtdnbipD8dTJfvVdDzqi20tOgSMQdvz/DJdClv
	 ws1N9lD8PnzoRzjeIctFqjbLxC21dT52HibPghILC/tqnr7+ENb1lJgeYJziR+1Mol
	 OurMhexqppTX+v7OwZdkweKsBzZqrjmiMyazkm9dR8A8oSeR3roSmVwRyJYCscsNzR
	 t9WqgduXFUoS8cH/X1Y+YFGUFe3H4Zb84oTEOGDgmOKJvBXv9BQ//MYD8PSesVo1aX
	 s6nUcf2AUpZiSMg+46EvNPzx8EBRzIwC86T9kkCd10tvxWfcFtC+DWqtxpQ55Clh1K
	 BjI80kTzyfgkA==
Date: Wed, 26 Aug 2026 22:09:18 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Mike Lothian <mike@fireburn.co.uk>
Cc: linux-crypto@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
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
	Asahi Lina <lina+kernel@asahilina.net>,
	Matthew Maurer <mmaurer@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>, Burak Emir <bqe@google.com>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v3 1/2] rust: crypto: add AES-128, AES-CMAC, SHA-256, and
 HMAC bindings
Message-ID: <20260826220918.GB3382628@google.com>
References: <20260826163004.3365-1-mike@fireburn.co.uk>
 <20260826163004.3365-2-mike@fireburn.co.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260826163004.3365-2-mike@fireburn.co.uk>

On Wed, Aug 26, 2026 at 05:29:48PM +0100, Mike Lothian wrote:
> +//! Safe wrappers over the kernel's synchronous library crypto.
> +//!
> +//! Exposes the one-shot `lib/crypto` primitives — AES-128 (an [`Aes128`] key
> +//! prepared once for single-block encryption, the building block for modes the
> +//! library does not yet provide such as AES-CTR)

There's an aes_ctr() function now.

With that, is bare AES still needed?

- Eric
