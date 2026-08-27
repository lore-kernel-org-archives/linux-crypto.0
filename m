Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F81366075;
	Thu, 27 Aug 2026 18:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787855352; cv=none; b=HTMBF1wWYXZtpTQkgeOlzAVBzMxYNNnWL5bnJ/2ZsQqEvA5vYr9cq8bdSXaMZyktSLZdNYwgBDkqUShInlsPy6hnv2XzmOtmTp8KQvqMD6clyx8HTW3cYkkVZ3nSRGBp6MXqJjEQf4asf6koM4u/0pC8lC6Ke1piJOQk6GF3MH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787855352; c=relaxed/simple;
	bh=hFDd7WwfRGCUYE0lkXdHmuSJnlTWM1ANDkV9+8cBjKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MVKSdfl+A2BoGffL3BdGmpGA6YNWCEK+0Ecc8tvzzDo/bYB/vaSnciDHmfEwrMGJvKMxaHrWDwmAL8oNUxSRbV9suLKEBUqlhdmTiJu2mE53WkveedBp8J+Qwj5Pf7LUhUJK/CsFkMfGOeEQnWx4lMLmK9ElWlIJ9wKLibhU1bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WCR4f8fx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WCR4f8fx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EFB1F000E9;
	Thu, 27 Aug 2026 18:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787855350;
	bh=Enn2jVR+wGYS5PbDLLpikDc9ImvnNJB9B9qQYrMw8IQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WCR4f8fx95jXrAut3gRLTI1ilBAeCz+uF/+vpixXxS482SYQ/R9ixnJkvz7HqMadO
	 S98+YTw3/E2dhnDVcbw03SNuQyBwin6/dJKI+tPd+pVk62qS2Ea7Y+K+YrSCeKK3ZD
	 0dpFoM+eQH9FFdAj+FpU3dPBs6Zr5NnvLi2m/alXwnvsRgsJ0hp+KXjVwk9lM1Ijwv
	 GGBYwL7ZIS7tfJcXUvK4LHcK5Q/uzqgBzY/KO/55DbsPk8g39UmzwDC3DzrdmJvqbw
	 pg8fvC3Cnz3QFpgJMX6HRKO4aRffRbaamH48sl7g9gY8KbHhk94zfqQ9gklYfffB4r
	 X62429Ud7SrdA==
Date: Thu, 27 Aug 2026 18:29:07 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Mike Lothian <mike@fireburn.co.uk>, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
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
Message-ID: <20260827182907.GA2137493@google.com>
References: <20260826163004.3365-1-mike@fireburn.co.uk>
 <20260826163004.3365-3-mike@fireburn.co.uk>
 <20260827030352.GB2327@sol>
 <CANiq72k3COcjo1s1MXdh=K7qRcOMMSq7-3_JCMtNKN3J0zQmjg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72k3COcjo1s1MXdh=K7qRcOMMSq7-3_JCMtNKN3J0zQmjg@mail.gmail.com>

On Thu, Aug 27, 2026 at 04:46:55PM +0200, Miguel Ojeda wrote:
> On Thu, Aug 27, 2026 at 5:05 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > As I've been commenting on other of these bindings patches, it also
> > doesn't really make sense to have the kconfig symbol be in lib/ but then
> > have the actual code be in rust/.  They should be in the same place.
> 
> Did you see my reply at
> 
>   https://lore.kernel.org/rust-for-linux/CANiq72=uUR4Vo9W55Kq6tQjc+6Q4_+wiWhCo-VLdkvg6PJeoAw@mail.gmail.com/
> 
> ?
> 
> But if you feel strongly about it, I guess it can be temporarily
> placed elsewhere, i.e. Kconfig symbols are not tied to the path anyway
> so they should be easy to move later on.

Yes, it doesn't explain why they need to be inconsistent though.

And if the code is "conceptually part of the subsystem", why is the
MAINTAINERS entry for "CRYPTO LIBRARY" not being updated to include it?

FWIW: I do think the Rust bindings need to live alongside the code
itself and be maintained by the same people.

I just don't think it makes sense to mostly *not* be doing it that way,
but then also having the kconfig options randomly be different.  We
should at least be consistent.

> If you mean a function in the standard library to zero memory without
> being optimized out: no, there isn't.
> 
> For context: I added `memset_explicit` to the ISO C standard and
> informally asked upstream Rust about adding an equivalent function
> many years ago, but at least back then they didn't want to add it (or
> at least in a way similar to how it is specified in C, which doesn't
> really give guarantees, letting compiler writers do their best
> effort).
> 
> I guess I can ask again since now we would finally have an actual user
> in Linux... :)

Userspace crypto libraries need this too, so it's kind of surprising it
would just be coming up now.

- Eric
