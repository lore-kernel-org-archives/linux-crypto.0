Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794080254;
	b=aCTZSPMPIVKIqIM4lX6H6lf8ExjoV5eHWik0cZgOaIuMmd2NgeFZpYIbQEr0eJRFjJ7B
	 tpRysIfPXxx9nh7sKSPJXLhzZfFFEEyV7pD7S1pFlWq/MgDL69J9Z7/H1cyVsPtlzHdDr
	 Cj7ZU1OKq5JkQC8DrRdCjbIP/OneITvk8ATq9KyYtamgjjuXWB5yXHrfUmjxGWaBjXR6W
	 cWyGlwLzQsSrHvdDHA176NOPJhkrc21bKCHzP/0tI7a8U0p9byek8oimHh0Lctsd/O9QS
	 DqgWiDgfA755H3UzocJgIxQoj47TrQEuYasT0H9ZunJFcfkEINWjubosmPps74GIKfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794080254;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=J28D76vigY1x0q3PndZXdhZsdxLHUeQhHl/TW06na0k=;
	b=fSfW1oMxyUWma+wte8sNxcfwdyaNuFK2e16nD16M+mpZKJxQ0fdUaGaFRSL6fy1Ku2Js
	 D0aIFezUvkH18JiZ8uXgCgnHLqK0p72Hcm4cSpzk4LfCuRXzgsDU9x/3u5X2kURe+2zJ6
	 0TaCO8Q8BnLQditI+aQjYJ14IdVCHUi/z3KfQPcF5rIx35jjM3v2emkMHTiNqQxk6D/p/
	 T63IFGxwpzYz6pv+ENtCn4yadLVKVcryiyQaiaS4sf0IIMrqI/EYcZdhJ2RkCm1XKYK6O
	 l23UKQJnuXR0anx580Jmmr0nQQ56y12rlSNW1w3LTQWZq0N8mOZCvYq4Z7nyGyR7BlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CwsG3UsV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A09E606A326;
	Sat,  7 Nov 2026 19:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CwsG3UsV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B8F1F0089F;
	Sat,  7 Nov 2026 19:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794080253;
	bh=J28D76vigY1x0q3PndZXdhZsdxLHUeQhHl/TW06na0k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CwsG3UsVdufq6iv7NioeMVsalbu8uf8VUvmfGUBXnWfEEPbY3ExsnVN8Pb18+iqMV
	 7gBH4E/mk+X3Y8iZe7m1as0lE01oK9d49Z9kHt3N3v6HQAILprPNwUCA/ngWhnFqii
	 Hwj6Tgyi2mn9+ESkUn6KOss/vaqh6ak93pFtjVVF+H270dG4EMd/+GvdhPNhhtFQN8
	 SJq258UEGPFglGng2oCF5zj8MOUAFXN8mqX7QnRByDpYAH1V5N9yCDt0hle23M8XQC
	 ZlpeSoshHLnm991mfqvemMJtpMLGusjl0lvVIRMbq2hAxsbJTgCWRoKrmqudGcI1p5
	 CBfk/+/X6ZimQ==
Date: Sat, 7 Nov 2026 11:37:32 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6.18] crypto: sa2ul - Fix HMAC key preparation
Message-ID: <20261107193732.GD6049@quark>
References: <20261107192358.47287-1-ebiggers@kernel.org>
 <sashiko-outbox-203214@kernel.org>
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
In-Reply-To: <sashiko-outbox-203214@kernel.org>

On Sat, Nov 07, 2026 at 07:34:55PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [Critical] crypto: sa2ul: negative index out-of-bounds read in
>   sa_aead_setkey() [1]

drivers/crypto/ is buggy.  No surprise there.

- Eric
