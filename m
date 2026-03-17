Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF703ED11B;
	Tue, 17 Mar 2026 16:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765673; cv=none; b=RlakZF+qX+KXlnHAZjR8m6FhFo0c9dTTaNbid4YpTD5zPb31EflT5oYOsQ6IEsT4aLHrMl1gcnEBSDsFRUW57CQW2SrBq/n5S4URf5oG1Wfkyo+hAl9pg/xw+NqQxwEWrIP1X7YiIO3/VAMdnTXK6T32Kd2g3+ADk2HQtCd/Gc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765673; c=relaxed/simple;
	bh=UXz9k9VacabS+9Bo/BKg4HLMwnU4iYW2qe69lmOgkWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L19r0IpJ81S+a4rOesgboXLR+73Poc6SkD6MXFpbujHFWN/ok7PMyNdTbn7CwhxeBM7T+ly37XzVCc7dIFbJeGFjG14hJy5I1GBpLLgx/SP7TZT1Vf67klxZOwIr4bUS0CGb46iBy+TWC9KwANCtgBCv0Tvtwy2cjq+zMYHqGTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vFYKatUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vFYKatUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4EFC2BC86;
	Tue, 17 Mar 2026 16:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773765672;
	bh=UXz9k9VacabS+9Bo/BKg4HLMwnU4iYW2qe69lmOgkWA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vFYKatUqNCjLiyvVwY3IdzCctHgHNpYSdIRzHjHzhN2vmsk/hsUbBAfmxQdocVw5s
	 vK08CW78J4QahmBUwMmSW4SHBrphHksMkFc37FJQkQ9YIKdxSseEQQ7eLJ0YKZW3NG
	 XZPmRcTQgp6c/3A/Mmj6NCY91TpxCgIDO1BJ7J7QsdSItIO8Tcp3hS5yJGKUiUALta
	 cUXM01vwgklwbRzLTl3fz+m7P7TZ2pSYqHVLe8ntdXBNakl5ZnynpRJqFoAkQKPkSU
	 CXZl0ZuO35BaPpRuNvwWbVTNtI6GDVU7m+nFd/kseWtCaPu00KeminWOaqhRF7tlwF
	 Yumy2M2vy3SlQ==
Date: Tue, 17 Mar 2026 09:40:12 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH] lib/crypto: arm64: Drop checks for
 CONFIG_KERNEL_MODE_NEON
Message-ID: <20260317164012.GD6226@sol>
References: <20260314175049.26931-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314175049.26931-1-ebiggers@kernel.org>

On Sat, Mar 14, 2026 at 10:50:49AM -0700, Eric Biggers wrote:
> CONFIG_KERNEL_MODE_NEON is always enabled on arm64, and it always has
> been since its introduction in 2013.  Given that and the fact that the
> usefulness of kernel-mode NEON has only been increasing over time,
> checking for this option in arm64-specific code is unnecessary.  Remove
> these checks from lib/crypto/ to simplify the code and prevent any
> future bugs where e.g. code gets disabled due to a typo in this logic.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting libcrypto-next
> (https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
