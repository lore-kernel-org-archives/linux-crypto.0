Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE885693
	for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 04:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CEWumhAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A027DC433C8;
	Tue, 28 Nov 2023 04:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701144757;
	bh=8sgnTlTTe9L/d3q6KejWDFP12I9AsyGGo8/4VhNtpCw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CEWumhAEPzcP6ei2al6jYGIp3TiLr1CvuhBdMYtBFRd4npdj1hflBmoIui2KHuHiX
	 rjCsWTYe/2Jf401q1YWW5Y9W3zJPFvHEB9Df4EdJqKUhUKQaPLg4mIu6mHj/1RH2Iw
	 8pfKefIpVE+XyPCSE4GrYI2IudRAyPwoIkZhhSZM1h5F70Lwzdt1t333/2Z+mm6Pap
	 HvrzKTSaaq9xkeRFrqC8+MW8TvOghwdacuvgAlkCG6NbwTI8fiE2fQ/x6RT4cLdVLj
	 qdGAFrpVTW07QHGRmBOKB7Ml2unZzzZAV6K8crtdLfy/OsO+A6RjUXQjOvq38CFjRu
	 HbbiG9Z+p8KJg==
Date: Mon, 27 Nov 2023 20:12:35 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jerry Shih <jerry.shih@sifive.com>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	conor.dooley@microchip.com, ardb@kernel.org, heiko@sntech.de,
	phoebe.chen@sifive.com, hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 09/13] RISC-V: crypto: add Zvknha/b accelerated
 SHA224/256 implementations
Message-ID: <20231128041235.GJ1463@sol.localdomain>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-10-jerry.shih@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127070703.1697-10-jerry.shih@sifive.com>

On Mon, Nov 27, 2023 at 03:06:59PM +0800, Jerry Shih wrote:
> +/*
> + * sha256 using zvkb and zvknha/b vector crypto extension
> + *
> + * This asm function will just take the first 256-bit as the sha256 state from
> + * the pointer to `struct sha256_state`.
> + */
> +asmlinkage void
> +sha256_block_data_order_zvkb_zvknha_or_zvknhb(struct sha256_state *digest,
> +					      const u8 *data, int num_blks);

The SHA-2 and SM3 assembly functions are potentially being called using indirect
calls, depending on whether the compiler optimizes out the indirect call that
exists in the code or not.  These assembly functions also are not defined using
SYM_TYPED_FUNC_START.  This is not compatible with Control Flow Integrity
(CONFIG_CFI_CLANG); these indirect calls might generate CFI failures.

I recommend using wrapper functions to avoid this issue, like what is done in
arch/arm64/crypto/sha2-ce-glue.c.

- Eric
