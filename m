Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0063264F9;
	Tue, 22 Sep 2026 05:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790056347; cv=none; b=SOuDKBxgcrRCfX0Z2ovW//BmoX4Xdu63+SO0vrFU7cMmKl1x9YS68pJew3ru0h0rBzJEXwlskSlW3JXp0CVJIgpQagej0grQH9du5YPfV9aebeTB6UfD9Poo2bPfBbLU3azjpQdANP5rBu9wUHbRnx1DRgdPnyjqm7jOnT3+B8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790056347; c=relaxed/simple;
	bh=RDwKLdBgQQO7mj0zEckeXeywAggCXVR5XKZyZA2JvwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KqSgr5aAH35ONaOOVT7FAHGG6JVPQKcB4VinZS5fq5L2To85Fulcw7FtpQO/1TD/7FjmTsYF1NrUVZFffKme+vndD3wso67NUmndN2+OtoidCcOgnIAwLwbV7SqCvMWtkvJj4Jze0l7b8kus1kIcmBX35OSTxnpHeYKnHeTFrk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FaTu2i+c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FaTu2i+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD0B1F000FF;
	Tue, 22 Sep 2026 05:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790056346;
	bh=As/vxWHhNUub4BNZFQs2kxwfn6UV/YUfsSwsyKwBmlg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FaTu2i+cS6F1a22YBgrRwP8TZ2qw9lyDsKZS7rCNunFtfJAlUg1FiMFL/8BXK6q/a
	 KbDZBr3B8LU3/SKrjrOKMa1s9XlzFRjCGY6UsJq93yUqxY8nAl/ClB3wOo5mRksSwH
	 89MnV4VcrllnxwvfJQAjFqVHNhLgemjNZ+wis+GrKUvboCCupVsAQji9vfrsGf9sP4
	 CL6fhkpfyfOrt6Dp+8K/eqdwKthIVPENtHT69FVuWHUYiYNnEsnD+bZQ8h7Yg7J+Rn
	 KOhgD2e5pCR7YUlkNWEwXlaBngtksHLyUxV8UGxCDXrWZyTSWThkStdSjyBe35ExzM
	 PhPwnPp+wTFSQ==
Date: Mon, 21 Sep 2026 22:52:24 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH 19/20] lib/crypto: riscv/aes-ctr: Migrate optimized code
 into library
Message-ID: <20260922055224.GC14616@sol>
References: <20260921050910.296144-1-ebiggers@kernel.org>
 <20260921050910.296144-20-ebiggers@kernel.org>
 <20260922054401.19194-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922054401.19194-1-kmehltretter@gmail.com>

On Tue, Sep 22, 2026 at 07:44:01AM +0200, Karl Mehltretter wrote:
> On Sun, 20 Sep 2026 22:09:05 -0700 Eric Biggers <ebiggers@kernel.org> wrote:
> > -// void aes_ctr32_crypt_zvkned_zvkb(const struct crypto_aes_ctx *key,
> > -//				    const u8 *in, u8 *out, size_t len,
> > -//				    u8 iv[16]);
> > +// void aes_ctr32_crypt_zvkned_zvkb(u8 *dst, const u8 *src, u32 len, u8 iv[16],
> > +//				    const struct aes_enckey *key);
> >  SYM_FUNC_START(aes_ctr32_crypt_zvkned_zvkb)
> 
> isn't this a sign extension problem on rv64? The psABI sign-extends
> 32-bit args, so for len >= 2G a2 comes in as 0xffffffff8xxxxxxx, and
> the asm uses it as a 64-bit length as is.
> 
> That would run off the end of both buffers.
> 
> Nothing passes that much in one call today, but aes_ctr_arch() only
> chunks down to 0xfffffff0 and aes_ctr() takes a size_t, so it is
> allowed. The old prototype was size_t and the caller zero-extended.

Yes, Sashiko found this too.  I'll probably make the assembly function
continue to take size_t.

- Eric
