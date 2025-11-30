Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D2536D4E2;
	Sun, 30 Nov 2025 18:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764527465; cv=none; b=b+7juXdrC76YFWaoej6A9BH3yI48nUY4bc9w1468n95k7ni+48JDhOzb/lfdG3DgYGiQLwPXWNrib2iRlaLUGIhJ1dTbvIAYA0j3/TyfG5FIMdlZ2ozb/S5mTMW0nWf5cTy4egGbsPQVJkIK/l+7n0lXcKeSZE1hYi9hBAuUMz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764527465; c=relaxed/simple;
	bh=CKsK+rZkyPj9l638j9wDyzGlROqChz/TMWPHpx0tNRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LcF9t9IC9eLa+ut6fDrh0+aHROAi4clUVBp1MtCLeszvb6ae64Y2JRZeFnQf0hI98DmHnB5oFcFSngr29kk89Q4td0XZw+b2zB7ZDKg41//Qm3RmzMYxoxFOgJLxmbFVExRWvSZhr7Mru036A80bV7uQces6TOvJ+Quy/JLPSRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f3o7TK7i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f3o7TK7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36188C4CEF8;
	Sun, 30 Nov 2025 18:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764527464;
	bh=CKsK+rZkyPj9l638j9wDyzGlROqChz/TMWPHpx0tNRg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f3o7TK7ivBGxABHNZK+hYdznvpHQQ8FEKIrYEKrSSFYVvJfav69c+0BP+zWbq/H4R
	 ZaC1sh6ChiBRb8xLvAIPPAjV8S5xnDMtRt/tfQxh54l+1/Op3wvH9eYFHAmtig1PKK
	 gqEW2rI8OvmsBtYJZLyI7K7Tux9yrskUdrVJL2cB1kQXini9k4lzML7EbPxX0owUnO
	 cqCNWX16CcntAgQqxtUHrYvQZNQkFI3MH9ehWHDP5+4FOTWCiFyIzYx2SC1EDvWnTO
	 moTRE7WpapEnlqsRXvpGZNPzr/hYDl8IlaPVpJD90MwbW6Y2705u2ofQP/7oVq3glF
	 dHut5tkfaspqQ==
Date: Sun, 30 Nov 2025 10:29:14 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Vivian Wang <wangruikang@iscas.ac.cn>
Cc: Jerry Shih <jerry.shih@sifive.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: riscv/chacha: Maintain a frame pointer
Message-ID: <20251130182914.GA1395@sol>
References: <20251130-riscv-chacha_zvkb-fp-v1-1-68ef7a6d477a@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251130-riscv-chacha_zvkb-fp-v1-1-68ef7a6d477a@iscas.ac.cn>

On Sun, Nov 30, 2025 at 06:23:50PM +0800, Vivian Wang wrote:
> crypto_zvkb doesn't maintain a frame pointer and also uses s0, which
> means that if it crashes we don't get a stack trace. Modify prologue and
> epilogue to maintain a frame pointer as -fno-omit-frame-pointer would.
> Also reallocate registers to match.
> 
> Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
> ---
> Found while diagnosing a crypto_zvkb "load address misaligned" crash [1]
> 
> [1]: https://lore.kernel.org/r/b3cfcdac-0337-4db0-a611-258f2868855f@iscas.ac.cn/
> ---
>  lib/crypto/riscv/chacha-riscv64-zvkb.S | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)

Do I understand correctly that the problem isn't so much that
crypto_zvkb() doesn't set up its own frame pointer, but rather it reuses
the frame pointer register (s0 i.e. fp) for other data?

That's what we've seen on other architectures, like x86_64 with %rbp.
Assembly functions need to set their own frame pointer only if they call
other functions.  Otherwise, they can just run with their parent's frame
pointer.  However, in either case, they must not store other data in the
frame pointer register.

Is that the case on RISC-V too?  If so, the appropriate fix is to just
stop using s0 for other data; we don't actually need to set up a frame
pointer.  (Note that none of the RISC-V crypto assembly code sets up
frame pointers.  So if that was an issue, it would affect every file.)

- Eric
