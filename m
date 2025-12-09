Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF082FBE11;
	Tue,  9 Dec 2025 23:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765321870; cv=none; b=YST8gp3gfLg4Y7gVMaPMxEHsxnjNW9EfFSOlwspInuPESJ/Me3R2ElA1CLQTyi5f9ZigDckMuBQIBnr3cokR3exdfw6L/3TCFz5ZkSESHb+Dxj1TQH9HI8SaB2+7ITl9DWv/yBUIJeBX2VFRoU8FU7dEGrrnCvfdwVZtM6pMwH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765321870; c=relaxed/simple;
	bh=xTdPv8q97x4PbM5YqwwTBVGIK1mcDoCY4ApJB11EGyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PEwe/AeTGUPn/ETI7Xxg0MkK81dByVZgZf+r4pdiEffMDhWvC7SXFFkBWC/FLJ+7ioRvKVBO0jcfc2qRynXHwSjIk8CFmVczsDjNbztuunQqdnRFTNtowQ4Udl1d4rqjPBGn/IcDKh5Lg7EEUWXQafCy1qrnItxYVbe2JbUDxy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cmj7TuaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cmj7TuaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9724FC4CEF5;
	Tue,  9 Dec 2025 23:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765321869;
	bh=xTdPv8q97x4PbM5YqwwTBVGIK1mcDoCY4ApJB11EGyI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cmj7TuaFId3/sT7FRAoUHf6ghzR0NWx16b9Lq1FV2Wa7WuD2GP69yi+9IIu/lrMhm
	 Czko3te1xMeE0kvHNtSTJT4/VzfWMZfNcoCe7BHqSMprdG0VfX4aklEqHxliZtUe8Y
	 tTJxMvKDbCtCsHYXOilrH7rmg1gH+EMNpycWR3JuOYU5LrK3EOQXLRmL8x8H6tHjRA
	 LMZDlsZ5go2vLsFTAR3n1Ru0ErSFtP8fyJc1UG76kef+yohKpWWX7/i+tscOLTlxM/
	 8yMYbch2wK5KIAT+31W6GDz3QQtFIHjf2AzG7X+6hXzT/J7TPE7eIoJx4i1xqgkhIX
	 UmBYNFui03Z4w==
Date: Tue, 9 Dec 2025 15:11:08 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/crypto: blake2s: Replace manual unrolling with
 unrolled_full
Message-ID: <20251209231108.GC54030@quark>
References: <20251205051155.25274-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205051155.25274-1-ebiggers@kernel.org>

On Thu, Dec 04, 2025 at 09:11:55PM -0800, Eric Biggers wrote:
> As we're doing in the BLAKE2b code, use unrolled_full to make the
> compiler handle the loop unrolling.  This simplifies the code slightly.
> The generated object code is nearly the same with both gcc and clang.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/blake2s.c | 38 ++++++++++++++++----------------------
>  1 file changed, 16 insertions(+), 22 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
