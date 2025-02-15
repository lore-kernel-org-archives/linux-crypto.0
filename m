Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A2B17B50B;
	Sat, 15 Feb 2025 17:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739639055; cv=none; b=PsqTbsdRqzHRq0am6fOgbipqw0bvdsh+hfPlK9qsf8QUPGYizV/Q9uhGtrGXceg81EnulPF1GePerYaHoMFlm1R1tngXQ3Jgsyj6D+RKTiAvY1RL8Xz/5i0OJjTPeYwPL/UqtHBVz2livAONrxuGhJvNRu91002q4j9/ICXui+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739639055; c=relaxed/simple;
	bh=WnvWKZs75WCihl2RK6XN/hRaYXzrXSYWLy9EHEla2Gw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nnkZ3NnjktvjLLgJgBFFE+bGiewX86fr1KyGz/3PZkoYEbrZWciml7OPmIhE6gjvT2gGkmssup7rvL46FKbZLxLpVho3u2fJYTLww5iMnD+fAj4kw2vZnhVywvfyuTxkibD3E+TiVjUNLg+AJk1+DVE7XeiWaGkGBYDuGiAU62M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ak36cCJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ak36cCJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17FEC4CEDF;
	Sat, 15 Feb 2025 17:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739639054;
	bh=WnvWKZs75WCihl2RK6XN/hRaYXzrXSYWLy9EHEla2Gw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ak36cCJGIrDMyh8JLoBwWJiYVWmf3huXTUGfoyTfnuZpGXjQ+worJ/7PW4lqmh2XY
	 PYtsLtQ2vZoVSEl+fUHGhQdA4mmCjtF8c3nnP4011ahg5XFRhb5Mj01McFZex0Pogc
	 GmCKwtSclIvKvylbEQDbk2qFGGpm+z53vQeHt1UxcSkuZnmGH+O7fo9SDhqnwaz9NE
	 cIAXkIiab1/bYW7UaaWNFK/0ZVsP+pP7xcE4+MJkOcy1cIcBEJSOeRDNnbyinemZiU
	 TRbhAUGAfr0EftL6DQgiiFtm7B4ummm5LBzhEPBOb6WkjJQCKdDDh8s9wvF3/5w06P
	 Zy4mrHEzz8nvw==
Date: Sat, 15 Feb 2025 09:04:12 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, fsverity@lists.linux.dev,
 linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Ard
 Biesheuvel <ardb@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, Linus
 Torvalds <torvalds@linux-foundation.org>, Mikulas Patocka
 <mpatocka@redhat.com>, David Howells <dhowells@redhat.com>,
 netdev@vger.kernel.org
Subject: Re: [PATCH v8 0/7] Optimize dm-verity and fsverity using
 multibuffer hashing
Message-ID: <20250215090412.46937c11@kernel.org>
In-Reply-To: <20250213063304.GA11664@sol.localdomain>
References: <20250212154718.44255-1-ebiggers@kernel.org>
	<Z61yZjslWKmDGE_t@gondor.apana.org.au>
	<20250213063304.GA11664@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Feb 2025 22:33:04 -0800 Eric Biggers wrote:
> So anyone who cares about TLS or IPsec performance should of course be using
> AES-GCM, as it's the fastest by far, and it has no need for multibuffer.

Can confirm, FWIW. I don't know as much about IPsec, but for TLS
lightweight SW-only crypto would be ideal.
