Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C62C3ED5AD;
	Tue, 17 Mar 2026 16:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765645; cv=none; b=iq5vMoe7JAIj2jUGb+9KQQGH/92MFJGHSoLMK/FizF2nv4Lygh2a5qUiywEPaqY4D841jPj5Fntsp2cKGoEs2/MTJRFzsA4r+t/+wRafxEzAaQhTRpTyhDC2t4yudUbohfMj7Wu8EfoHpXOSsHKlI6R8mkPYZAEuJ3hhO92enUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765645; c=relaxed/simple;
	bh=oGmrY+PmqBfflbdhmIoYB56APfW8yTiCKtXMx4pMBnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=baGa/TwBfayWHSvLA6gY40S9YiMnBYHk3B6/9GxlHAQ8tIfmtB9pfenmk9zD69MJ4Z5Lt2/0ELFt0lbMOQsg3bo+0O7mvYKfS+c2de//FsD8Vzw4CkOOZawlXhUnwnaTEeZYe9/1gyRKWOkkDDXo/9BXNi7VG1XyLekW6gqlhqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYWR2goX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYWR2goX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A407FC2BCB1;
	Tue, 17 Mar 2026 16:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773765644;
	bh=oGmrY+PmqBfflbdhmIoYB56APfW8yTiCKtXMx4pMBnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DYWR2goXGTel+rSJVHS3SC1OkpBsOslVuIZw+AsKQIgG5R7MDXdee12y2Sbs6tC9D
	 /LI2X4lVy/wmX1hGqZqUWNZztoqx7XLICsmTxhfpE+zVejdMHzOTjfhQsTp1CzzgCX
	 3UwnUvPtmKYRoiy/p9M+jIqIeDNLEOr5bYLMNfo84hWvaQyV+sKlUjTKWIyjnjK2ik
	 Q7tOS1ND3cCYchDEzv171T6xKi7JVQcm5bBFWDI5rIK4FW3OCZg79gtqrmUhmaEcqm
	 +LKh+RO6OJ7/YhFQsexfSrfqK9v5RYdBMTGlap3g4MNcrhKoWbWVD84ox7+LYnQzRV
	 SkT1rAHPt8C+A==
Date: Tue, 17 Mar 2026 09:39:45 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/crypto: Remove unused file blockhash.h
Message-ID: <20260317163945.GC6226@sol>
References: <20260314173526.17349-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314173526.17349-1-ebiggers@kernel.org>

On Sat, Mar 14, 2026 at 10:35:26AM -0700, Eric Biggers wrote:
> For a short time this file was used by the SHA-256 and Poly1305 library
> code, but they are no longer using it.  Remove this unused file.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting libcrypto-next

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
