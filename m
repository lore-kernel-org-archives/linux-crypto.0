Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280C053817
	for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 17:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cnGCPorL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C758C433C7;
	Tue, 28 Nov 2023 17:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701192218;
	bh=VxGlt7hegXrzPaBYpjEp75xdeopS3/YpGUiONM5sob0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cnGCPorLQr7ZkBy0m2cT2BizcFYs+Iw9nHvy00zenf2+hPwWyUBRrpbxR1aQ1UlIp
	 kmCJpgsqhz1ihkVLH/tPfhbMpJOFxaf3hFO/Uial2me2nbfIj9al0FJUZxJWCtiSBS
	 dqNs1VYYBRrB3hE98xRSnuS12VxaX4xKL63iemfaOEDFfC7qy/xpd5UkvAkb/o+0Yr
	 c6URq2fk/I7MkBVqlvO+etcIWQ7i5SJf527CKCb4dlqfRWGhjJQ8/R4xhvX2eiI3cC
	 p+fg6DYbBWo1u4ypje/QufX/riQN9fjkJXTc9Z6jIWPClr0b/vgDdcBC+vm+mpsVI2
	 30oBqj68fZi6A==
Date: Tue, 28 Nov 2023 09:23:36 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jerry Shih <jerry.shih@sifive.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, palmer@dabbelt.com,
	Albert Ou <aou@eecs.berkeley.edu>, herbert@gondor.apana.org.au,
	davem@davemloft.net, conor.dooley@microchip.com, ardb@kernel.org,
	heiko@sntech.de, phoebe.chen@sifive.com, hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 09/13] RISC-V: crypto: add Zvknha/b accelerated
 SHA224/256 implementations
Message-ID: <20231128172336.GC1148@sol.localdomain>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-10-jerry.shih@sifive.com>
 <20231128041235.GJ1463@sol.localdomain>
 <51190E7A-25BD-4D9A-AADF-02FE2A280508@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51190E7A-25BD-4D9A-AADF-02FE2A280508@sifive.com>

On Tue, Nov 28, 2023 at 03:16:53PM +0800, Jerry Shih wrote:
> On Nov 28, 2023, at 12:12, Eric Biggers <ebiggers@kernel.org> wrote:
> > On Mon, Nov 27, 2023 at 03:06:59PM +0800, Jerry Shih wrote:
> >> +/*
> >> + * sha256 using zvkb and zvknha/b vector crypto extension
> >> + *
> >> + * This asm function will just take the first 256-bit as the sha256 state from
> >> + * the pointer to `struct sha256_state`.
> >> + */
> >> +asmlinkage void
> >> +sha256_block_data_order_zvkb_zvknha_or_zvknhb(struct sha256_state *digest,
> >> +					      const u8 *data, int num_blks);
> > 
> > The SHA-2 and SM3 assembly functions are potentially being called using indirect
> > calls, depending on whether the compiler optimizes out the indirect call that
> > exists in the code or not.  These assembly functions also are not defined using
> > SYM_TYPED_FUNC_START.  This is not compatible with Control Flow Integrity
> > (CONFIG_CFI_CLANG); these indirect calls might generate CFI failures.
> > 
> > I recommend using wrapper functions to avoid this issue, like what is done in
> > arch/arm64/crypto/sha2-ce-glue.c.
> > 
> > - Eric
> 
> Here is the previous review comment for the assembly function wrapper:
> > > +asmlinkage void sha256_block_data_order_zvbb_zvknha(u32 *digest, const void *data,
> > > +					unsigned int num_blks);
> > > +
> > > +static void __sha256_block_data_order(struct sha256_state *sst, u8 const *src,
> > > +				      int blocks)
> > > +{
> > > +	sha256_block_data_order_zvbb_zvknha(sst->state, src, blocks);
> > > +}
> > Having a double-underscored function wrap around a non-underscored one like this
> > isn't conventional for Linux kernel code.  IIRC some of the other crypto code
> > happens to do this, but it really is supposed to be the other way around.
> > 
> > I think you should just declare the assembly function to take a 'struct
> > sha256_state', with a comment mentioning that only the 'u32 state[8]' at the
> > beginning is actually used.  That's what arch/x86/crypto/sha256_ssse3_glue.c
> > does, for example.  Then, __sha256_block_data_order() would be unneeded.
> 
> Do you mean that we need the wrapper functions back for both SHA-* and SM3?
> If yes, we also don't need to check the state offset like:
> 	BUILD_BUG_ON(offsetof(struct sha256_state, state) != 0);
> 
> Could we just use the `SYM_TYPED_FUNC_START` in asm directly without the
> wrappers?

Sorry, I forgot that I had recommended against wrapper functions earlier.  I
didn't realize that SYM_TYPED_FUNC_START was missing.  Yes, you can also do it
without wrapper functions if you add SYM_TYPED_FUNC_START to the assembly.

- Eric
