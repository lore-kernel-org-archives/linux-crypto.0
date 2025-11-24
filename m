Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCDD31A56C;
	Mon, 24 Nov 2025 19:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764011823; cv=none; b=Tu6fFrPfvN9xP5AAi0Q/OYh3Bm/rHEF5xPtbcrnkqeADTwCaGwjEo8UpssG5QL3E4vLZku2O8tiRQbGevgWsTGaGSuw4PJS4Q3Xt/9TKaxzhayIOXd2h3CGGipngXuOhFLbxU8+TjAqotvMFgtqGf8l2SrKRnwDW+L6+82jiJjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764011823; c=relaxed/simple;
	bh=rf9SmuGA69dp8z9SOKIPdTiLCFzfVwMM1BoLId+7PGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yi/93tsA187c3cIptGXiDbz5vCBy/g7pGJi/Kt+x9MxbaIoGgJM60JVt2MdiADsv244D3FlUdPXgruJiOhmlBTTlQrv6VlE0xLrNXmbWJAwZOCI7gqA3pWQ03sJHLY6za/uS2PkhD1E+abHQ5//nBUdXH8UJ8btjBM62mcdIkuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L4ibhHh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L4ibhHh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB65FC4CEFB;
	Mon, 24 Nov 2025 19:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764011822;
	bh=rf9SmuGA69dp8z9SOKIPdTiLCFzfVwMM1BoLId+7PGM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L4ibhHh0nY8/6xDahZJjyUuTUJrxh1CsYME3pOwvkdtLSydfFVtNHBLT7qaUXgNfb
	 HQ9wXjBO02W3X5fxTjjYkKfcrUg8jTC1rK3Nbk+UpqjuKaI4/o5OPHvI0GFgGJWbkE
	 Rn8WJC0orKItRDntsWqXBxc4m80N2J6AU48q47kAJQEm1qFNH8MZF6XMa4Xqzykigy
	 OX3LaY7CWkbTnHFUX5GorJX+hLgfqBI78j5ZwF4F2T9p7fTFBIxoXlKHi+qBKZuScH
	 jBcGwtq14k3JT2VB/PhgrdKkJ+bgnHGBZBZjhNkEb4Rbb164hAK2e71Jd12AWbnPNC
	 lbuPHdpyVNDsw==
Date: Mon, 24 Nov 2025 11:17:02 -0800
From: Kees Cook <kees@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/6] lib/crypto: More at_least decorations
Message-ID: <202511241115.BAFD2FC@keescook>
References: <20251122194206.31822-1-ebiggers@kernel.org>
 <CAMj1kXFSL9=TWzv35mSwVMVaKAQ=3n=w93=1+VSfKyDe+0A+Ow@mail.gmail.com>
 <20251123203558.GD49083@sol>
 <CAHmME9qm8Xo6ccUUBm=QJ4X9BfTc3WgkmWohHsi_+xaGsgY4rw@mail.gmail.com>
 <20251123205431.GE49083@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251123205431.GE49083@sol>

On Sun, Nov 23, 2025 at 12:54:31PM -0800, Eric Biggers wrote:
> Oh, there's actually a difference between const and non-const
> parameters.  A const parameter gives -Wstringop-overread, while a
> non-const one gives -Wstringop-overflow.  Only the latter is disabled.

FWIW, I'm hoping we can make the last bit of progress needed to get
-Warray-bounds and -Wstringop-overflow enabled globally after this
patch helps us track down any stragglers:
https://lore.kernel.org/lkml/20251121184342.it.626-kees@kernel.org/

-Kees

-- 
Kees Cook
