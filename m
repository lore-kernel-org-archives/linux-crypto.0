Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B368635F8B9;
	Thu,  2 Apr 2026 23:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775171533; cv=none; b=o8Id7AQaat8XxcX825i91Q8lJw8TEJtEHDeAa0y6lLu939sSa3qH5e4KsHC2IVu+bkkl42ZcIro5ftBRJpRsug3hzauXXzXuRG+XVmtTweqiE/z8FMRoxcMQPGJTWtSj9lYyMyZz4viwmVrneUl6sy4aN2Y9A0SfzS0O8sIKjRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775171533; c=relaxed/simple;
	bh=AlQcHq0q3oR6NEiP4jcaPQ2aCDBphhzMdw3wZ91g/MU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i7SPFKClzDIIm62+2qe6ufzzf44Zw9T87NRT6xhcZy4SBdJF6PmyO/wPBNCaoFNPurCyGWVsqNapax/yHQITBj6RiPc9g5dlq0zA48Q+ZmToknq0HPuu4u/Av4Zd25vuYC0779zEtQfIjqOI8YIUYNni/9naMPdj5+/67W0RYkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tRI4AqK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tRI4AqK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF4BC116C6;
	Thu,  2 Apr 2026 23:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775171533;
	bh=AlQcHq0q3oR6NEiP4jcaPQ2aCDBphhzMdw3wZ91g/MU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tRI4AqK8e/TacyNpwXSTBMfh2L3lbi6A+5ll/Pju1P9ZQdw2GhsNNw6idKf2EEZa6
	 lpGpcYt/GSBDUXNGvefebyTOVUzGdklJWMZt7JZBVc4ciOuISjuHyvYxbM3RVSok9d
	 h8Bp6ghwWoEjX2meOTGuxfpnprt40657QSAF1DrhmkX21yWWtL/k/+6+c7E+4ptOk+
	 5NBLV+xMPVIj6oEvfhztnlW03n6YOtRGgqMw1V1MoWoImr1a2pnme5hYI22O9bwlWV
	 ByKe9dqEbF51zKX5hB70HDxn2CSu5QzzPDazLKWxOK3g3ii4c2btwkpIZwqRYySz/b
	 Bw8FCpQpTnmsQ==
Date: Thu, 2 Apr 2026 16:12:09 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/9] lib/crypto: arm64: Remove obsolete chunking logic
Message-ID: <20260402231209.GD2910@quark>
References: <20260401000548.133151-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401000548.133151-1-ebiggers@kernel.org>

On Tue, Mar 31, 2026 at 05:05:39PM -0700, Eric Biggers wrote:
> Since commit aefbab8e77eb ("arm64: fpsimd: Preserve/restore kernel mode
> NEON at context switch"), kernel-mode NEON sections have been
> preemptible on arm64.  And since commit 7dadeaa6e851 ("sched: Further
> restrict the preemption modes"), voluntary preemption is no longer
> supported on arm64 either.  Therefore, there's no longer any need to
> limit the length of kernel-mode NEON sections on arm64.
> 
> This series simplifies the code in lib/crypto/arm64/ accordingly by
> using longer kernel-mode NEON sections instead of multiple shorter ones.
> 
> This series is targeting libcrypto-next.

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
