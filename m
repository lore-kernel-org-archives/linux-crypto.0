Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E17540BF8
	for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 20:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I2oSykRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884BBC433C7;
	Tue, 28 Nov 2023 20:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701202351;
	bh=MhX9PEGZOUPQ3Y/dHE9lpPPcT4wCLCEPYr8D6D5VCtI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I2oSykRN0FvNVERNHm6/mDH1mmOkc0Q49tLDgd40gyaDip6gEW7TAl9Jl/MxHObYA
	 mdl/hcepl0h4CXURQz3Tn8VcDCpPQ0NXOnPu68SuNYjvg/HQgzZ8g4KrNzM5TZPDbJ
	 vDC1pzxUpGiHmYxfU45duhcvVDLjsmwei0St+4UE1NUI6IMhUgdA8mzeRXuH+mLU4q
	 a9yc1zaSWu/cJYpBKDvcaynYd9nSzkV4ILJkE9pokYSgNviVD9rofuNx9vfvhXXoO0
	 vs/iR/aqK59xYP/4AVrqBmBlKYcCuz41pVbRh1aFxjKBpXasnU4aR8ZDjcQrf4mS9b
	 /NZ1g23uTLU3w==
Date: Tue, 28 Nov 2023 12:12:28 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Conor Dooley <conor@kernel.org>
Cc: Jerry Shih <jerry.shih@sifive.com>, paul.walmsley@sifive.com,
	palmer@dabbelt.com, aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	conor.dooley@microchip.com, ardb@kernel.org, heiko@sntech.de,
	phoebe.chen@sifive.com, hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 04/13] RISC-V: crypto: add Zvkned accelerated AES
 implementation
Message-ID: <20231128201228.GE1148@sol.localdomain>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-5-jerry.shih@sifive.com>
 <20231128-await-tipper-2094715466f2@spud>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128-await-tipper-2094715466f2@spud>

On Tue, Nov 28, 2023 at 05:54:49PM +0000, Conor Dooley wrote:
> > +static inline bool check_aes_ext(void)
> > +{
> > +	return riscv_isa_extension_available(NULL, ZVKNED) &&
> > +	       riscv_vector_vlen() >= 128;
> > +}
> 
> I'm not keen on this construct, where you are checking vlen greater than
> 128 and the presence of Zvkned without checking for the presence of V
> itself. Can you use "has_vector()" in any places where you depend on the
> presence of vector please?

Shouldn't both of those things imply vector support already?

> Also, there are potentially a lot of places in this drivers where you
> can replace "riscv_isa_extension_available()" with
> "riscv_has_extension_likely()". The latter is optimised with
> alternatives, so in places that are going to be evaluated frequently it
> may be beneficial for you.

These extension checks are only executed in module_init functions, so they're
not performance critical.

- Eric
