Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF796AB1
	for <linux-crypto@vger.kernel.org>; Thu,  9 Nov 2023 07:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b53gh+xj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDEAC433C7;
	Thu,  9 Nov 2023 07:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699514186;
	bh=bXtq92H2lB9I1j4FNYbEXcH9mwbTZ3yucWnUpEsvSu8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b53gh+xjIAMX5TIJgr2iD0QbJEC/4hWxmS8AAAUQYv7lmKQ9umk4k9gi9TCo1tw+M
	 svu0/XvTdxJaZQA0lEBUbNkhDZB/L1yO9RA6pzgMHzL6rEnaRyljRDVxg2mQfwkCwh
	 Kv/B2Oi0+gdx5gHMETqbd4aS93Zdnt7J811QH/+cqB+9Lk1LrOyy+haKhyJ6jNUiep
	 9Ifm795/MqeHQa93xPifVoL7kn+wWIxkH0HqpRVGVzcuJr3ayofZwDBrg1uTL6a4Ys
	 ut7HSxk6F8+NeWPjlRw4F3AaE6eagdYCANS8dzcSjXNf+WbLnKeBmxj/B1XCS0JIRC
	 Vw9az8ujLLo9w==
Date: Wed, 8 Nov 2023 23:16:23 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jerry Shih <jerry.shih@sifive.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, palmer@dabbelt.com,
	Albert Ou <aou@eecs.berkeley.edu>, herbert@gondor.apana.org.au,
	davem@davemloft.net, andy.chiu@sifive.com, greentime.hu@sifive.com,
	conor.dooley@microchip.com, guoren@kernel.org, bjorn@rivosinc.com,
	heiko@sntech.de, ardb@kernel.org, phoebe.chen@sifive.com,
	hongrong.hsu@sifive.com, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 06/12] RISC-V: crypto: add accelerated
 AES-CBC/CTR/ECB/XTS implementations
Message-ID: <20231109071623.GB1245@sol.localdomain>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
 <20231025183644.8735-7-jerry.shih@sifive.com>
 <20231102051639.GF1498@sol.localdomain>
 <39126F19-8FEB-4E18-B61D-4494B59C43A1@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39126F19-8FEB-4E18-B61D-4494B59C43A1@sifive.com>

On Tue, Nov 07, 2023 at 04:53:13PM +0800, Jerry Shih wrote:
> On Nov 2, 2023, at 13:16, Eric Biggers <ebiggers@kernel.org> wrote:
> > On Thu, Oct 26, 2023 at 02:36:38AM +0800, Jerry Shih wrote:
> >> +static int ecb_encrypt(struct skcipher_request *req)
> >> +{
> >> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> >> +	const struct riscv64_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> >> +	struct skcipher_walk walk;
> >> +	unsigned int nbytes;
> >> +	int err;
> >> +
> >> +	/* If we have error here, the `nbytes` will be zero. */
> >> +	err = skcipher_walk_virt(&walk, req, false);
> >> +	while ((nbytes = walk.nbytes)) {
> >> +		kernel_vector_begin();
> >> +		rv64i_zvkned_ecb_encrypt(walk.src.virt.addr, walk.dst.virt.addr,
> >> +					 nbytes & AES_BLOCK_VALID_SIZE_MASK,
> >> +					 &ctx->key);
> >> +		kernel_vector_end();
> >> +		err = skcipher_walk_done(
> >> +			&walk, nbytes & AES_BLOCK_REMAINING_SIZE_MASK);
> >> +	}
> >> +
> >> +	return err;
> >> +}
> > 
> > There's no fallback for !crypto_simd_usable() here.  I really like it this way.
> > However, for it to work (for skciphers and aeads), RISC-V needs to allow the
> > vector registers to be used in softirq context.  Is that already the case?
> 
> The kernel-mode-vector could be enabled in softirq, but we don't have nesting
> vector contexts. Will we have the case that kernel needs to jump to softirq for
> encryptions during the regular crypto function? If yes, we need to have fallbacks
> for all algorithms.

Are you asking what happens if a softirq is taken while the CPU is between
kernel_vector_begin() and kernel_vector_end()?  I think that needs to be
prevented by making kernel_vector_begin() and kernel_vector_end() disable and
re-enable softirqs, like what kernel_neon_begin() and kernel_neon_end() do on
arm64.  Refer to commit 13150149aa6ded which implemented that behavior on arm64.

- Eric
