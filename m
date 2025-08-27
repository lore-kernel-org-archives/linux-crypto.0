Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DEB25557;
	Wed, 27 Aug 2025 02:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756261011; cv=none; b=jcgvsfZrIbH/hKfiRXKM2Y6IdvpK4Q6dfVxeJq1bM7w53u8b4m763zl0Ds5SoYFsbMjZKKy+knA4CzyBu0mmy9mBnqeiYo4yaPTfVi/deJBaVqF8sua4icTgkeJIo1yJJ2qVw2eOd/qo+Xz2BCVgzOru09RiGwA5ZusX58kfBmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756261011; c=relaxed/simple;
	bh=eDcnJCa93Xe3vxBW0ZfBX8WQI8Q3WYp0DM/g3zZt1X0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XuLuMf5iWpiWzthBesAfFl2BwY+LfYWJMmWr1c0wn0moWmCg4phuzVHOAcHR5ZQt3gke04k5jwwEjp8ZqmyE8C86N5ivrh60a8KRYufra3RPdoGTehSy4cDfK1TWbwlMsTnPzRf9gSzrB/lbhWuEyQRpVvHfwFnCd8rmB63wJGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vMrdH3wQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vMrdH3wQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FA1C4CEF1;
	Wed, 27 Aug 2025 02:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756261011;
	bh=eDcnJCa93Xe3vxBW0ZfBX8WQI8Q3WYp0DM/g3zZt1X0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vMrdH3wQ73KH16B2mWQKpADZU9EJelPjqrVz8uwbk1UXIqcjU3eZLTUtQc9YSV/cw
	 8yfTYJsdTcwfAgie0JzfQ/v72kcAcuEIk1CwhprXAsl7qoICZ2fsu05rGgKMasYr8L
	 hVlxymar9e0J9SiHHpk7gq4sCx0YdPe42OTFPPiOKZ3sGexuVULTW3MI0Tmdr2bcFk
	 lsIDAJ+QxCSEKNpiXG2w4zHg9iVODxbqRvucvgucw1Du6bZhSa7Kwp5BXoNQlMu4Lm
	 1Adqp8bed4u6GC+aPwrCl4gEo1iH3KmF0EBFyz7c5hT+r2JdqV04dnZZ1bA8/mgmUf
	 gMpNSm0rhFRSQ==
Date: Tue, 26 Aug 2025 20:16:46 -0600
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Zhihang Shao <zhihang.shao.iscas@gmail.com>,
	Andy Polyakov <appro@cryptogams.org>
Subject: Re: [PATCH v2 0/3] Consolidate Poly1305 code and add RISC-V
 optimization
Message-ID: <20250827021646.GA62136@quark>
References: <20250824025736.148576-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250824025736.148576-1-ebiggers@kernel.org>

On Sat, Aug 23, 2025 at 10:57:33PM -0400, Eric Biggers wrote:
> This series is targeting libcrypto-next.  It can also be retrieved from:
> 
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git poly1305-v2
> 
> This series simplifies and optimizes the organization of the Poly1305
> code by consolidating it into a single module.  This follows the example
> of SHA-1, SHA-256, SHA-512, CRC32, etc.
> 
> Since the RISC-V Poly1305 patch has had a moving target, I also rebased
> it on top of this series and included it as patch 3.
> 
> Changed in v2:
> - Added missing 'FORCE' to the make rules for mips/poly1305-core.S
>   and riscv/poly1305-core.S
> 
> Eric Biggers (2):
>   lib/crypto: poly1305: Remove unused function
>     poly1305_is_arch_optimized()
>   lib/crypto: poly1305: Consolidate into single module
> 
> Zhihang Shao (1):
>   lib/crypto: riscv/poly1305: Import OpenSSL/CRYPTOGAMS implementation

FYI, I applied this series to
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

But as always, reviews and acks would be greatly appreciated!

- Eric
