Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4108119E7F7;
	Fri, 29 Nov 2024 17:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732902625; cv=none; b=HhGW9LoR7ZPNDnW5f9AbgPixrc1yYuQZ8YrycGMfi7FjwEje0U/vPC+GcHeBLvJWm6cEfdCkIW7jfY61y/k0q8Zye8NCVuKZ2erd6BzGqIjsPvDbNndQ1IXt+hyFT/70QB2KAx8wOtIVUhr6XfdY28lYtwyzbJMY9/1ufLNj4hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732902625; c=relaxed/simple;
	bh=568Y/BHT4alsJnY/HseWLVP1VbMrDIEGvY3L/iTfEnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ezl6v1RIK4zxKjiqn3MhvyQwH03qkBD933axXNNV3YwWOTFK+Ey87/lIA8VNaZDzuDCJGT3p19ht4UU86A7PjB85NUIXxUTzlkMwdMnVQ3I5pAyQ1DO3wvybj+rW3ywM5q5pe50z8f+5Lwmr7H5NEeNb8ubOzdNHpr7F1Pd0bBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pz3UlEyv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pz3UlEyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DBCCC4CECF;
	Fri, 29 Nov 2024 17:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732902624;
	bh=568Y/BHT4alsJnY/HseWLVP1VbMrDIEGvY3L/iTfEnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pz3UlEyvhMRt0nlsQimRXAo63CvWiwPHf7x/clvUK5zONX8YdkySwbVan0MhMUY5w
	 6jV3N2aXvKWBYn847SZwBYZR3eyS9kYZ8WESxsTII0pfpfO3pZijfciYb4AHS7gOo4
	 L69bs15We/DuibbY6jOdnutVUYpNk4MMg67wE/aPY20ubiPfmxKbgGWxEUu6s0Prdg
	 tW36PvpiOS7UZhpC1nxjzJn0uNRUrvVWDyB14llpLMBPlMXCkgtGbIIW6J6omXKgWm
	 57tMdPqKZeo/tLj+WNdRJcP5uTXlpPPDKfmz4pQUUBocBnNs0DybQoH3TASHkIupMW
	 C3/vOMrC436bA==
Date: Fri, 29 Nov 2024 09:50:23 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH 0/6] x86: new optimized CRC functions, with VPCLMULQDQ
 support
Message-ID: <20241129175023.GB1179@sol.localdomain>
References: <20241125041129.192999-1-ebiggers@kernel.org>
 <CAMj1kXHPXS3r244jABjOKTEWaqWX2TYf-KA9i+J2-C3B4XxmUQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHPXS3r244jABjOKTEWaqWX2TYf-KA9i+J2-C3B4XxmUQ@mail.gmail.com>

On Fri, Nov 29, 2024 at 05:16:42PM +0100, Ard Biesheuvel wrote:
> On Mon, 25 Nov 2024 at 05:12, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > This patchset is also available in git via:
> >
> >     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git crc-x86-v1
> >
> > This patchset applies on top of my other recent CRC patchsets
> > https://lore.kernel.org/r/20241103223154.136127-1-ebiggers@kernel.org/ and
> > https://lore.kernel.org/r/20241117002244.105200-1-ebiggers@kernel.org/ .
> > Consider it a preview for what may be coming next, as my priority is
> > getting those two other patchsets merged first.
> >
> > This patchset adds a new assembly macro that expands into the body of a
> > CRC function for x86 for the specified number of bits, bit order, vector
> > length, and AVX level.  There's also a new script that generates the
> > constants needed by this function, given a CRC generator polynomial.
> >
> > This approach allows easily wiring up an x86-optimized implementation of
> > any variant of CRC-8, CRC-16, CRC-32, or CRC-64, including full support
> > for VPCLMULQDQ.  On long messages the resulting functions are up to 4x
> > faster than the existing PCLMULQDQ optimized functions when they exist,
> > or up to 29x faster than the existing table-based functions.
> >
> > This patchset starts by wiring up the new macro for crc32_le,
> > crc_t10dif, and crc32_be.  Later I'd also like to wire up crc64_be and
> > crc64_rocksoft, once the design of the library functions for those has
> > been fixed to be like what I'm doing for crc32* and crc_t10dif.
> >
> > A similar approach of sharing code between CRC variants, and vector
> > lengths when applicable, should work for other architectures.  The CRC
> > constant generation script should be mostly reusable.
> >
> > Eric Biggers (6):
> >   x86: move zmm exclusion list into CPU feature flag
> >   scripts/crc: add gen-crc-consts.py
> >   x86/crc: add "template" for [V]PCLMULQDQ based CRC functions
> >   x86/crc32: implement crc32_le using new template
> >   x86/crc-t10dif: implement crc_t10dif using new template
> >   x86/crc32: implement crc32_be using new template
> >
> 
> Good stuff!
> 
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> 
> Would indeed be nice to get CRC-64 implemented this way as well, so we
> can use it on both x86 and arm64.

Thanks!  The template actually supports CRC-64 already (both LSB and MSB-first
variants) and I've tested it in userspace.  I just haven't wired it up to the
kernel's CRC-64 functions yet.

- Eric
