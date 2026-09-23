Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997F53D0BE7;
	Wed, 23 Sep 2026 04:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790139345; cv=none; b=Y5SJ65EkGQ4tojESWihnwHo3tiXZ/6TqyxTFYDWROtrwLyH++CoBKdqUfTvxPAMTRuNaTwrYj81/5y/oLuatow78JXpNBVviCNmHlLAq1e4dCjyPWovLVGrmcjIt9rsnRxajUyHt/DMQU7h8rOwKPQlUXmp9yFLZOKImb7wBTRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790139345; c=relaxed/simple;
	bh=dPpWB2ndfkRjSDLdVwoeEYvC16/YT8+V07UEeqqDZVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UIF8Q4AkVS0mc2ggsarq9S/Rv5XdrGD2XbhdNSmunzMeEgZvKjyJ+pKs8slpuzPKmrw54CjEU/hyyZ1jTc2GFGngCIng7Qo4j2azrF45Dfbo7+D7A5DKwhjXD58/BmWSoPC0pfvXvEKIcKjMcw+fbrW8P9h6Rw6yCPxtB19hCxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jHHiocIL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHHiocIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304481F000FF;
	Wed, 23 Sep 2026 04:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790139336;
	bh=cQFE+5Y9vqqj0SUL0R7R8gaTB/4Mu8qOPt5YrkM61Bk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jHHiocILMM7wNQb1Q65hVk/ZD5ZTzjBtOHYizJzftLuOigAKcQEcdIiRJmli4aI95
	 Q8uoq4432FafyvLDUiaS5aOGuku1p7UseA9j3crHVS/Zx1mePmtAZgwyn02qTasq0y
	 28MCrEZPSrfWTjtONm8iwMxwqHm79qZN31oIZsDz8U5F3PMO1dJ8GiwToPhLc68yOD
	 wdWjIjQpSdW7SoGgwI5kVgqEsvFC+UgzqfIlWtFCkJciUUcIT3m+v8qu32WK+3N0mt
	 Vp40dzykIxmkdI9qmJhglNIeM1EcEhvTZn+UajJsznFgGC79eWN4/jafn9krvKzQbU
	 gAM/VJqkbyXOA==
Date: Tue, 22 Sep 2026 21:55:34 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: bot+bpf-ci@kernel.org
Cc: bpf@vger.kernel.org, vadim.fedorenko@linux.dev, ast@kernel.org,
	daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com,
	memxor@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, martin.lau@linux.dev, song@kernel.org,
	yonghong.song@linux.dev, jolsa@kernel.org, emil@etsalapatis.com,
	ihor.solodrai@linux.dev, john.fastabend@gmail.com,
	kmehltretter@gmail.com, martin.lau@kernel.org, mason@kernel.org
Subject: Re: [PATCH bpf-next v4] bpf: crypto: Use AES-CBC and AES-ECB
 libraries
Message-ID: <20260923045534.GD42709@sol>
References: <20260923032703.59816-1-ebiggers@kernel.org>
 <a5e07fdd93b0f6b38dfce4cf977e88eac653bed08ee713372bf31bc6cff349e7@mail.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5e07fdd93b0f6b38dfce4cf977e88eac653bed08ee713372bf31bc6cff349e7@mail.kernel.org>

On Wed, Sep 23, 2026 at 04:22:57AM +0000, bot+bpf-ci@kernel.org wrote:
> This isn't a bug, but struct aes_enckey pads itself so the round keys
> can be 16-byte aligned for better performance (as documented in
> include/crypto/aes.h). Putting the 4-byte algo enum before the key union
> means key.aes lands at offset 4, so the round keys can never hit that
> alignment. Would putting key first (or aligning it) be worth considering
> here?

Sure, but it's very much bikeshedding.  If someone cared about
performance enough to be micro-optimizing the data alignment here, they
would also have noticed than the optimized implementations of AES modes
aren't actually being used, which is way, *way* more important.
Coincidentally, I'm addressing that in a separate series
(https://lore.kernel.org/linux-crypto/20260921050910.296144-1-ebiggers@kernel.org/)...

I would not consider it worth worrying about the alignment here.

> This isn't a bug, but both helpers repeat the same src_len %
> AES_BLOCK_SIZE and dst_len < src_len checks. Could that validation stay
> in bpf_crypto_crypt() next to the existing length checks, leaving only
> the iv_len check per mode?

It's done the way it is because it makes it more straightforward to add
AES-GCM support, which is desired as per previous discussions.

Anyway, these random bpf-ci bot comments on every version are getting a
bit annoying.  Especially when it explicitly says "This isn't a bug",
and then the instructions at the end of the email assume it is.

- Eric
