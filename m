Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3434A2C86A;
	Sat, 27 Jan 2024 19:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706385123; cv=none; b=Gtsg7ELq9ckerXVgaOXlahd1HCx9koZM5KhPBG7mOxNpWmL3Rno32LtsPKvBc9zVuXZO8Jkxs5B1OvCMP1h6DgCcjx+Hv4KAvsyds/LQ9LxtF7nz/beIJcjSkTnDbvEOKdQulcA+RFbUhAhTxYRnluNiISbGk+qPS34X5Qln/eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706385123; c=relaxed/simple;
	bh=nNNOg9OGw4VfRgQPR3+oq9lPYHSxhSiGjos34RuwKwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AJMCdH9aR4uDlHQgXS3IWfeNqH9vdc/EgukYCwGtHPgPquzz0lR1etQJw+fxmbe//W2oE7czNI8eV6hDL2w5kihNmZK5vcUrvoKNlpGsHoQK1udTmjbjAlHYEMU6uCS3IWtHQIQ7lD6WynoBoxUMyyL7sQ5ZRc++x/ctTcND9M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JhQ7Z/Wp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JhQ7Z/Wp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5234DC433C7;
	Sat, 27 Jan 2024 19:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706385122;
	bh=nNNOg9OGw4VfRgQPR3+oq9lPYHSxhSiGjos34RuwKwg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JhQ7Z/WpfC6u+Gt7BEU5AzxNheIqn1BiZynbNIvhZE2FqnHPvbc9p0C0TY0Kt6trZ
	 uuATYufIzZBJipqarY5MYAgq/cwRUWrbhoqlBKr5ZPGk29orVU74ch4vQPO0j6Spmj
	 0/EMdTrcqzUM7GvLCFm9aJsC8bsE6qd1klm2rVNQ9zxhbW7V9xFwMflAXU7DspfmBY
	 9gnD2qDIjkwBKrPNlLNDPFnAENURqVvIY71wyRCnkGbNJvcZIXmHhMdkmndmIPenuI
	 HjyT+v+N9yioOd4aSR0VPfJ8wtNRmBb833PMPp0eXhsO9PD9lBdD2Cf968NQJ8p6a9
	 6dgxtErdKbqyA==
Date: Sat, 27 Jan 2024 12:52:00 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-riscv@lists.infradead.org, linux-crypto@vger.kernel.org,
	llvm@lists.linux.dev, Brandon Wu <brandon.wu@sifive.com>
Subject: Re: [PATCH] RISC-V: fix check for zvkb with tip-of-tree clang
Message-ID: <20240127195200.GA781164@dev-arch.thelio-3990X>
References: <20240127090055.124336-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240127090055.124336-1-ebiggers@kernel.org>

On Sat, Jan 27, 2024 at 01:00:54AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> LLVM commit 8e01042da9d3 ("[RISCV] Add missing dependency check for Zvkb
> (#79467)") broke the check used by the TOOLCHAIN_HAS_VECTOR_CRYPTO
> kconfig symbol because it made zvkb start depending on v or zve*.  Fix
> this by specifying both v and zvkb when checking for support for zvkb.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

I also verified this does not regress GCC.

> ---
>  arch/riscv/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index b49016bb5077b..912fff31492b9 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -581,21 +581,21 @@ config TOOLCHAIN_HAS_ZBB
>  	default y
>  	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64ima_zbb)
>  	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32ima_zbb)
>  	depends on LLD_VERSION >= 150000 || LD_VERSION >= 23900
>  	depends on AS_HAS_OPTION_ARCH
>  
>  # This symbol indicates that the toolchain supports all v1.0 vector crypto
>  # extensions, including Zvk*, Zvbb, and Zvbc.  LLVM added all of these at once.
>  # binutils added all except Zvkb, then added Zvkb.  So we just check for Zvkb.
>  config TOOLCHAIN_HAS_VECTOR_CRYPTO
> -	def_bool $(as-instr, .option arch$(comma) +zvkb)
> +	def_bool $(as-instr, .option arch$(comma) +v$(comma) +zvkb)
>  	depends on AS_HAS_OPTION_ARCH
>  
>  config RISCV_ISA_ZBB
>  	bool "Zbb extension support for bit manipulation instructions"
>  	depends on TOOLCHAIN_HAS_ZBB
>  	depends on MMU
>  	depends on RISCV_ALTERNATIVE
>  	default y
>  	help
>  	   Adds support to dynamically detect the presence of the ZBB
> 
> base-commit: cb4ede926134a65bc3bf90ed58dace8451d7e759
> -- 
> 2.43.0
> 
