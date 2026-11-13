Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539761;
	b=zgK1yeRYHLAZ2JSvkvmcum+8VftmM1NvJRBpesDZK3f5DRBXIqXn9oeaFApnpaInQyc7
	 Bxth53S92NtSQBhf8poyaBP8FNpcoyZMXPdrfnZy6H0K5QpS59ADWmJJuVWFMdNirmZjN
	 eNK02LqC97ySxsanj6eVvkhN4RaEzDfE2AIGuvxiFprYcqSY3HO9M4dVZRR6L1/pzG+zR
	 3PFcGWMJiCv9EFZ5qFqaTV5Y1XmYo/wffwwT5uAGD6bvlJZzKFONNXwWGv1qJEr35gFSl
	 HGnksSyfe8X8SrP0opjfEtQb7DMiI5C6MIlQm6vKfcfjE1tEVMX+RfWrEtF5U79wStQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539761;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=gRqI3nT1cevu1i7c7BwE5z5uo6WHuT3yYFTjqhfw4P8=;
	b=x/P9xK6OtMNHXdYl1soj+5k/JmCeKj9CW01JeSwd8KflTkRrqqNuxTh1memocFLfogMS
	 //+Segs//PFfFz7TMjTD63lct9jSeW/Dqdt5YVr5+w2hZMphdOvVQq4i5s+2QEhMrbcha
	 QXJ4H6CQ3weLCXrys39TRiAqEqb0axvZv1J6/Jf5IOO47GHrvvHxAco8VctgJSu6gZuTp
	 EBpnaFXDN/kP6TnTs9gByFg4omJ7BQbrZLnmaWAdypPKQQ9HusY3+FXgOw4br7bE4a44A
	 gRRQUnRttkyCigyKAxUaJdgLDdr+qp8ZoJQn1VrXW9BOp1KXfat/nz+E5VMYVtMY70Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="j+/nNzY+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3397606A321
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 03:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j+/nNzY+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0741F000C4;
	Fri, 13 Nov 2026 03:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794539760;
	bh=gRqI3nT1cevu1i7c7BwE5z5uo6WHuT3yYFTjqhfw4P8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j+/nNzY+i1Wa/Mxf/qiGq4z+b3srJ/7WpJ4Khzsf3A+Jx1AyqmD7vitmo1I82d/pV
	 PVuTOm2E2wB5CKNit8Qj9gw/RVBSHxvq3qCwh8gE35NHRd4v0UMjY5UiRW+uKiWGbA
	 d3gDqeClv6SzHLFTfyAl5AHDujGlBI4qpT2Oye9EOd+qC4Ycjj0JT8V2gUG2uRLslZ
	 BRMa2gmVFGXGq99WBvIxmBJbcy0zG9YqZI8ppJb8m/PNZEgyvpOs29ghZ6B+yGUrpo
	 GVpc8V61hc/NQbPNbeeouAmMmMPo+tAd6zuFmAPA3W05TWyp5jLQnzH9F+CasJNWHB
	 aEZpOneCeYKqw==
Date: Thu, 12 Nov 2026 19:15:59 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Antonio Quartulli <antonio@mandelbit.com>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Willi <martin@strongswan.org>
Subject: Re: [PATCH] lib/crypto: x86/chacha: Fix mistakes and inconsistencies
 in comments
Message-ID: <20261113031559.GC1742@sol>
References: <20261112034453.12795-1-ebiggers@kernel.org>
 <0280ecc9-fcc1-48e5-b248-4641c30e5cb5@mandelbit.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0280ecc9-fcc1-48e5-b248-4641c30e5cb5@mandelbit.com>

On Thu, Nov 12, 2026 at 11:35:45AM +0100, Antonio Quartulli wrote:
> 
> Maybe you want to also fix chacha-avx512-x86_64.S:588?
> 
>         # x0..15 += s[0..15]
>         vpaddd          V16,V0,V0
> 
> If I am not wrong, it'd be the only lacking the lane range now.

Done in v2.

- Eric
