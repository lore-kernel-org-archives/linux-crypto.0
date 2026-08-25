Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23C736A36A;
	Tue, 25 Aug 2026 17:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787680589; cv=none; b=OIELhFsCQzzF/48ID9T8cxOpeLNX0pTClD7XVK1gUXO9eMCE/4M4u+WlHXDIvPrRJEZblgHcsxUokV9d7zvvkU5T1O0A7F4fxgVNPopmlUSALzyPxxfaut3JJ9WaDdcNuEVkoWAzv84ME6fW57XOmPfYLvyoUdW2KHOTmzx3t/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787680589; c=relaxed/simple;
	bh=0IZNqUaqznsXbat6uAyGD6/PQMpX1Ku5fP/Exuz8t+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KIn+0ZZsi76qBllrtUHNROmkV8WbKSYr5DTm9AOW++tWi6D4sH8Vx5Zgx0vrop80GTtVTOFR2SmjoW1sOUn64l1RfDEnJf4UD8/TydEnDDUPSRp1SH4t3WH71zB64bBSg7bt3br/Jg8wWbMQWps53CfJjSJgQF70rgHqBQHeG6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XcvaehR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XcvaehR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6797A1F000E9;
	Tue, 25 Aug 2026 17:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787680588;
	bh=cr3sE+cVYK6tw/l2CJTQdBhZ0n0WYwtgkDzEqTpHk1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XcvaehR/JCkzqX43q1fWN1QogxR8Rp1LGt9hUXB5t0csFr/+E8t3OiZmzqZHJgqjT
	 8hsaVccZ6AcG5FWhi9qegv54MPifTg95BA1Y07ljaWICSSBoOzVdpY11rkmsVqtHhq
	 WLj/Cc/zasIuip1orCfMlKPH1/ucq6u7clY1HS+Ph6gmGrYH0um/CvglFX1k5XukK4
	 2cE5yyiilWMYPCmc2h1kUMaZH6TxuB6Qd9G1Zg8vaYcRjpQnkHEnDhDoNqYNRrYYDF
	 oEsm81n+MmNibgKE+AE5HJGfz1gZwNVcVrz4MYVPsbt/dzZ/cq48b++RVvNPzYjzHD
	 jV6r29RKJS0oQ==
Date: Tue, 25 Aug 2026 17:56:25 +0000
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
Message-ID: <20260825175625.GA3673306@google.com>
References: <20260820-gb-uart-transport-v1-0-282da14ab7b7@beagleboard.org>
 <20260820-gb-uart-transport-v1-3-282da14ab7b7@beagleboard.org>
 <20260821030018.GA1961@sol>
 <93977935-ea60-48de-9d13-23454e038c18@beagleboard.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93977935-ea60-48de-9d13-23454e038c18@beagleboard.org>

On Fri, Aug 21, 2026 at 10:55:41AM +0530, Ayush Singh wrote:
> > > diff --git a/rust/kernel/crc_ccitt.rs b/rust/kernel/crc_ccitt.rs
> > > new file mode 100644
> > > index 000000000000..6042ada16967
> > > --- /dev/null
> > > +++ b/rust/kernel/crc_ccitt.rs
> > Is there a reason why the kconfig symbol is being put in lib/crc/ but
> > the actual code is being put in rust/kernel/?  It seems inconsistent.
> > 
> > - Eric
> 
> 
> Was copying `RUST_SERIAL_DEV_BUS_ABSTRACTIONS`. It is also in
> `drivers/tty/serdev/Kconfig`.

kconfig options usually should be in the same directory as the code they
control.

- Eric
