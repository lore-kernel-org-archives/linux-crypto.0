Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3AA22A4E9;
	Tue, 28 Apr 2026 01:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777340202; cv=none; b=K8E0t+dXsLdXTJdbf3iBC/YeL64kjg02wELif38xAistlWeebBr3CHMv8B8wyRURBGDzz47RVGRzCMmunR9bSdW9WqqsjgPPWYli/oqfVqEOwcSKSdFxvH3mWwGexPU4Ev07ouALtM+AOtk5sgzeNV2jfxQUijT5Iu7Ajp+lkpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777340202; c=relaxed/simple;
	bh=SxEnJ5lG7Z3dI9JA/sUF0K65BeJfFboQkDmohfpIDPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CExG5A4dGRYGEWfy3QKAUKqD9agsrgOMRJz/KbMKt2Qkgz9u6DQQVcj7sPX4/EojSUTEpav26TQRflqh7pIJL8l0uSEUbjIbZaU/pzlaxfTud+vtzOhLV3koNb9dPBKAosi9K7VthYZqxHa8Z56JAB55RqeV97QyVpv923fAFds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gNoXSzz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gNoXSzz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C431CC19425;
	Tue, 28 Apr 2026 01:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777340202;
	bh=SxEnJ5lG7Z3dI9JA/sUF0K65BeJfFboQkDmohfpIDPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gNoXSzz9njbbGSOq71tipeGEgjt4i+Nq2t1QmvP0O1uNKQMyq/2NLqswpkfsvTaDM
	 fjQpokGjQG9lS67rzUV0Kqqyk7B93gRLgWMLcfzkn7r0SdMM9cJaN6wXblS9v2/I8J
	 KjcxQbMmsXQHuqYq6i2MKu1bC6sPJ5q8fqDsQlFhGyIL5IaqYQ1FUlRDxptQeyUHSo
	 5iwI7nPcWUWngIRs5suRvgYrpN4zWlMh3mnuL/frmthtO6D4sJbwqUGy3D64qmjimK
	 FcsJXV+lSuMVjpaxxczEoX5DkGrmiNjTEzzjMxeYA3Rgs3prI6mbKNvBtCGOxNKV1O
	 HXWcR/tufMzBw==
Date: Mon, 27 Apr 2026 18:35:24 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dmitry Safonov <0x7f454c46@gmail.com>
Subject: Re: [PATCH net-next v2 2/5] net/tcp-ao: Use crypto library API
 instead of crypto_ahash
Message-ID: <20260428013524.GB2700@sol>
References: <20260427172727.9310-1-ebiggers@kernel.org>
 <20260427172727.9310-3-ebiggers@kernel.org>
 <20260428022445.65e14a27@pumpkin>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428022445.65e14a27@pumpkin>

On Tue, Apr 28, 2026 at 02:24:45AM +0100, David Laight wrote:
> On Mon, 27 Apr 2026 10:27:24 -0700
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > Currently the kernel's TCP-AO implementation does the MAC and KDF
> > computations using the crypto_ahash API.  This API is inefficient and
> > difficult to use, and it has required extensive workarounds in the form
> > of per-CPU preallocated objects (tcp_sigpool) to work at all.
> > 
> > Let's use lib/crypto/ instead.  This means switching to straightforward
> > stack-allocated structures, virtually addressed buffers, and direct
> > function calls.  It also means removing quite a bit of error handling.
> > This makes TCP-AO quite a bit faster.
> > 
> > This also enables many additional cleanups, which later commits will
> > handle: removing tcp-sigpool, removing support for crypto_tfm cloning,
> > removing more error handling, and replacing more dynamically-allocated
> > buffers with stack buffers based on the now-statically-known limits.
> > 
> > Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ...
> > @@ -344,33 +444,26 @@ static int tcp_v4_ao_calc_key(struct tcp_ao_key *mkt, u8 *key,
> >  	struct kdf_input_block {
> >  		u8                      counter;
> >  		u8                      label[6];
> >  		struct tcp4_ao_context	ctx;
> >  		__be16                  outlen;
> > -	} __packed * tmp;
> 
> That looks a bit horrid.
> I also had a feeling that the compiler sometimes rejects non-packed structures
> inside packed ones.
> Perhaps nest the whole thing inside another structure that has an initial
> u8 pad and is marked __packed __aligned(4).
> Then the assignments to the fields of 'ctx' will be known to be aligned
> even when tcp4_ao_context is also __packed.
> 
> 	David

This series doesn't change the definition of struct kdf_input_block.
Could we defer changing it (if it makes sense to) to a later patch?
Yes, there might be a way to get the be32 and be16 fields naturally
aligned and get the compiler to understand that.  But that would be a
pretty small micro-optimization compared to removing all the tcp_sigpool
overhead from the same function (which this series does).

- Eric
