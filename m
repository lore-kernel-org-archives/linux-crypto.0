Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB953143C61;
	Tue, 17 Jun 2025 03:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750130861; cv=none; b=JVeLdbwIB/pVKrw1tNESfGWnA9+H0xOI6l8y0zHpbnGtDgjSL8+kaFVFo6WsnleIL2W4CNVkNUqiArMMrgoXwuflLXGMRWN5Dl6yF6CbVKuRLG3J3DVNOoUQ+LR2cnBF141VTajDC2FQC69EQkcapfrmbGGxS3Yi7d7FvZeeGX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750130861; c=relaxed/simple;
	bh=p9lozJqVasI7Hf5gbpRsyMuAP/AKnTQ2rTPVzTMp/Wg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O9mOzNEPlpm8+7yrB6Io6nSxAVUjuicA1fY23zFyFbgmlxF6WR38y2Faea63BgNlc7kt81/MJZKpGMyrW6mRtTMPlCivGRCTB3VjpcSu0lMaKQsw4lL80OZsQoh4lXJWGBcsotsp5eybTILUrZBxEE+0XyCAwEQSNF/SFw9/p2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KlEn4EuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KlEn4EuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384BDC4CEEA;
	Tue, 17 Jun 2025 03:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750130860;
	bh=p9lozJqVasI7Hf5gbpRsyMuAP/AKnTQ2rTPVzTMp/Wg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KlEn4EuUiyvHT5r3KGOwbBww88XMxnyjpq9GCpOOIlxG137b+TAuYCeYh2kHdGYN9
	 7uLWsn69wJB/AMGKoyonVChKSIZFZ6mjpja6CKyRHJINMrEksBvGV5puzpzvUb7cFv
	 Gd8h6+xSpLvgBzkEn2ZPLULx5Px8pGie+p7hPsLpvSp2zojz3gfpHX7TBliU8d2tPx
	 tqfvy44EgJp3N7Vv3wlFRcFnbhcpCHRvVAySaSycWrph8u1QtOiJx38cziRy92Obxu
	 yrhtkwlwhVtD2mlQBhPG7aaZDTExTebi7N778WM/qFNKdaNyex5MSzQh+zVpMVLbvO
	 ap8wHmAdftDKg==
Date: Mon, 16 Jun 2025 20:27:10 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	"Jason A . Donenfeld " <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH] lib/crypto/poly1305: Fix arm64's poly1305_blocks_arch()
Message-ID: <20250617032710.GD8289@sol>
References: <20250616010654.367302-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250616010654.367302-1-ebiggers@kernel.org>

On Sun, Jun 15, 2025 at 06:06:54PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> For some reason arm64's Poly1305 code got changed to ignore the padbit
> argument.  As a result, the output is incorrect when the message length
> is not a multiple of 16 (which is not reached with the standard
> ChaCha20Poly1305, but bcachefs could reach this).  Fix this.
> 
> Fixes: a59e5468a921 ("crypto: arm64/poly1305 - Add block-only interface")
> Reported-by: Kent Overstreet <kent.overstreet@linux.dev>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/arm64/lib/crypto/poly1305-glue.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
