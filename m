Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF6A3FB04
	for <linux-crypto@vger.kernel.org>; Wed, 20 Dec 2023 15:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oJpmbySA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF40CC433C9;
	Wed, 20 Dec 2023 15:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703086320;
	bh=bJrXRcY+g/Zhyk8TW6XZqRLmOKlhPoFZoeRcr95OHAk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oJpmbySAxKPqvlBNNh0uHDkKT392pfPwzUcxeMf1SAQwSzPm3LIZJcf5o+oCD/R3Y
	 6Cjn6qo7opW3EyTozovruSthCjWFVVSa06SX6ZsSUeGw5UwPXEsKQpf/etNetMl+Lp
	 vd5dhQzaSLh9DMoy23FTdHsOUftdzC5HFBApSDmepwOm5kWcQfg+hPipRc4NPL5Y+w
	 7iAbKvDaAVZwgS9amxh+1g6k37+BmWL7MOn2pdRGVIJcgS6wRtGV3rQiR863vCJ8Sq
	 US3Vvcqj5l3vvaU8RQXzJDDXtXAjAHtyR4S023FAL4lb2JKQ51Wg/6IynUL68hC4ms
	 eKiTS2oQHAwCw==
Date: Wed, 20 Dec 2023 09:31:55 -0600
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph =?iso-8859-1?Q?M=FCllner?= <christoph.muellner@vrull.eu>
Cc: Jerry Shih <jerry.shih@sifive.com>, linux-crypto@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH] crypto: riscv - use real assembler for vector crypto
 extensions
Message-ID: <20231220153155.GA817@quark.localdomain>
References: <20231220065648.253236-1-ebiggers@kernel.org>
 <CAEg0e7hh-qY9eF1nW5U32j7XYV2RLEdqRP1LzRi+eZHKtKR-aQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEg0e7hh-qY9eF1nW5U32j7XYV2RLEdqRP1LzRi+eZHKtKR-aQ@mail.gmail.com>

On Wed, Dec 20, 2023 at 08:52:45AM +0100, Christoph Müllner wrote:
> On Wed, Dec 20, 2023 at 7:57 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > LLVM main and binutils master now both fully support v1.0 of the RISC-V
> > vector crypto extensions.  Therefore, delete riscv.pm and use the real
> > assembler mnemonics for the vector crypto instructions.
> >
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> For OpenSSL, these hand-written assembler functions were mainly written
> to make OpenSSL's CI builds happy, which run on the latest Ubuntu LTS.
> 
> I'm happy to see these functions disappear, but I wonder if there is a
> guideline or best-practice for assembly optimizations like this.
>
> The upcoming Binutils release (presumably available in Jan 24) will
> (presumably) be available in Ubuntu 24.10.
> And until then most users won't be even building the code.
>
> 
> 
> Reviewed-by: Christoph Müllner <christoph.muellner@vrull.eu>

As far as I can tell, kernel code usually just relies on assembler support for
new instructions.  See e.g. CONFIG_AS_AVX512 for x86's AVX-512.  You can't build
the AVX-512 optimized crypto code unless your assembler supports AVX-512.
Beyond that observation, I don't think there's a specific guideline.

The kernel doesn't have CI on Ubuntu, at least not officially for upstream.
Either way, it's possible to install newer LLVM and binutils on old Linux
distros anyway.  Also, the RISC-V crypto code won't make it into v6.8 since it
depends on a separate patch that adds support for kernel mode vector.  It will
be merged into v6.9 at the earliest.

So my vote is to just rely on the LLVM and binutils support.

- Eric
