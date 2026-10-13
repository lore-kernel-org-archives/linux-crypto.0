Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61533DA7D9
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 17:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791912634; cv=none; b=orZK/uFltVEFpvdFdoDHnXrfLPCFE3T4jKDFt76Nenkav+VU7Kma/UoZINJ500kaCGpTWLEQlWUCZxPfuAnTUSZ8i0v8bieo6Z9aouOjY7N056K9s5HwqZqkuAwfWT0Wqbhdej+OdxgoVzqxOZZxmG1INdeWlQy1c2kXzjHnHgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791912634; c=relaxed/simple;
	bh=+FCedmsoPNrqOGsrwSaasZ6jBz4NDHCNgJwq1aGBsj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K/TRp2pWlHnNqLw/L71ut/2KaRLPjAkycvz5amtCaXM+gTJ1C1CEAwr9hD8L80M3MnyVjiKdKNlZRVkhPXZ7CYcIvaVK1ap1RlrWbJnQYZosfbS2dh4xA5mD++nE1xMvLhbKauVRZgZS8BMyFbrr2HM3vZj9ZrqzG4AcQtpQU+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N49/SOtY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N49/SOtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6941F00893;
	Tue, 13 Oct 2026 17:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791912633;
	bh=7hvCoOmIFj87M8tXyus3RyBorrayZ7R5r1nen08jhPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N49/SOtYDHyz+b+D9tk79XQNV0mZDOXG1P29Sb1C7G6mroWmbeW5noiu/iMzQ1MgQ
	 fZv1rZjevOGNefAcgq64cLSRob78yd5FtZiCA2JsuIXMGyXUMU3WSQ2YAbHwlRO36S
	 QkJThAuFRf+caj9oZTFhfaSGsuFPqX9uEwsf67LH5MrmYm5m3Bgf1M4lgY5Z1YQ2DS
	 u/ZtMMjDskIt8ALZOb1hcSp1SkJX2i+0fAv1OUxJ+U1yxwz6jxS7LLJlpNlTr2p07q
	 NhK88skcjZ0SYngFGpursHKTPTMdapMm62jmPkd7r7jMcS9zFokqGnKisQmcGZxaFj
	 oFDunta/KlcaQ==
Date: Tue, 13 Oct 2026 19:30:24 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org
Subject: Re: [PATCH 0/3] lib/crypto: x86/sha: Follow the normal %rbp
 convention
Message-ID: <20261013173024.GA3830@quark>
References: <20261011134843.166585-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011134843.166585-1-ebiggers@kernel.org>

On Sun, Oct 11, 2026 at 03:48:40PM +0200, Eric Biggers wrote:
> This series updates the x86 SHA-1, SHA-256, and SHA-512 assembly code to
> set up %rbp before pushing GPRs rather than after, so that the frame
> pointer unwinder will generate call traces reliably.
> 
> This doesn't matter much, given that the ORC unwinder is the default,
> and the fallback to scanning the stack made call traces sort of "work"
> anyway.  But it annoyed me that these assembly functions use the "wrong"
> %rbp convention, differing from the C code.
> 
> This series is targeting libcrypto-next.
> 
> Eric Biggers (3):
>   lib/crypto: x86/sha1: Follow the normal %rbp convention
>   lib/crypto: x86/sha256: Follow the normal %rbp convention
>   lib/crypto: x86/sha512: Follow the normal %rbp convention
> 
>  lib/crypto/x86/sha1-avx2-asm.S      | 10 +++++-----
>  lib/crypto/x86/sha1-ssse3-and-avx.S |  9 +++++----
>  lib/crypto/x86/sha256-avx-asm.S     | 10 +++++-----
>  lib/crypto/x86/sha256-avx2-asm.S    | 10 ++++------
>  lib/crypto/x86/sha256-ni-asm.S      |  9 +++++----
>  lib/crypto/x86/sha256-ssse3-asm.S   |  8 ++++----
>  lib/crypto/x86/sha512-avx-asm.S     | 11 ++++++-----
>  lib/crypto/x86/sha512-avx2-asm.S    | 11 ++++++-----
>  lib/crypto/x86/sha512-ssse3-asm.S   | 11 ++++++-----
>  9 files changed, 46 insertions(+), 43 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
