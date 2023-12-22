Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C929539A
	for <linux-crypto@vger.kernel.org>; Fri, 22 Dec 2023 04:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rw/ooVov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D633CC433C7;
	Fri, 22 Dec 2023 04:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703220753;
	bh=Mu4nPZC3NYzqa5KLa5exHzdEdFc25nyFrTi4UQ9rNBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rw/ooVoveUFs91tCBZEnBnmCofcXiScCjMUoAyRAy77AVQVTAW5nioT+cgXD1L5La
	 btxOLV06PsPckESHWuy8zq5UzZLW+wOhTgA66qlU9HNP37JnHcLx+GnW96Zp/COekT
	 ZH7FInFgsI+bGj7w6mkEtEvhdx5Svg5NAwCgfLzlBFMzrilXzWuECXUWA2pmywpZJ2
	 rbEDL9FjUbJ6tavkY1MjQqGHHqG6avYpAj6D5FGdp6sGUFw0dzALWNkJ1vhzonTBTX
	 In1nfwt4Cl/Hd+TmYZYVCj3zXAs7VUh0owCcDx3z2Ky8FqtLNRc425L3ixGji+Ueze
	 ZlZ2/y1wtsW9A==
Date: Thu, 21 Dec 2023 22:52:27 -0600
From: Eric Biggers <ebiggers@kernel.org>
To: Jerry Shih <jerry.shih@sifive.com>
Cc: linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
	Christoph Muellner <christoph.muellner@vrull.eu>
Subject: Re: [PATCH] crypto: riscv - use real assembler for vector crypto
 extensions
Message-ID: <20231222045227.GA52600@quark.localdomain>
References: <20231220065648.253236-1-ebiggers@kernel.org>
 <3C51992F-B8F8-4023-81EE-3C95102B072A@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3C51992F-B8F8-4023-81EE-3C95102B072A@sifive.com>

On Fri, Dec 22, 2023 at 10:15:04AM +0800, Jerry Shih wrote:
> On Dec 20, 2023, at 14:56, Eric Biggers <ebiggers@kernel.org> wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > LLVM main and binutils master now both fully support v1.0 of the RISC-V
> > vector crypto extensions.  Therefore, delete riscv.pm and use the real
> > assembler mnemonics for the vector crypto instructions.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> > 
> > Hi Jerry, this patch applies to your v3 patchset
> > (https://lore.kernel.org/linux-crypto/20231205092801.1335-1-jerry.shih@sifive.com).
> > Can you consider folding it into your patchset?  Thanks!
> 
> Thank you for the vector crypto asm mnemonics works.
> Do you mean that fold this patch or append this one as the separated
> commit into my next v4 patchset?

Just fold the changes into your individual patches, please.  Thanks!

> > config TOOLCHAIN_HAS_ZBB
> > 	bool
> > 	default y
> > 	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64ima_zbb)
> > 	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32ima_zbb)
> > 	depends on LLD_VERSION >= 150000 || LD_VERSION >= 23900
> > 	depends on AS_HAS_OPTION_ARCH
> > 
> > +# This option indicates that the toolchain supports all v1.0 vector crypto
> > +# extensions, including Zvk*, Zvbb, and Zvbc.  LLVM added all of these at once.
> > +# binutils added all except Zvkb, then added Zvkb.  So we just check for Zvkb.
> > +config TOOLCHAIN_HAS_ZVK
> > +	def_bool $(as-instr, .option arch$(comma) +zvkb)
> > +
> 
> Could we rename to other terms like
> `TOOLCHAIN_HAS_VECTOR_CRYPTO/TOOLCHAIN_HAS_V_CRYPTO `?
> Some ciphers don't use `ZVK*` extensions.

Yes, TOOLCHAIN_HAS_VECTOR_CRYPTO sounds good.

- Eric
