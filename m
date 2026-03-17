Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16541376467;
	Tue, 17 Mar 2026 16:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765080; cv=none; b=LhO1MqPnHAwV2qfGGDN0lkRqDLBUeiA7+/gLXo2pPfJevSDJF0iGXIZb57BaTOc5LKf0ukboWBh385/rD7SgMZr72fSI3vYjw1JlR6zHUDEbdt+zqH8uWyqC7gXLizOnVKUHoyR4Q6+vcxTQNR43FJP4EebZ0LHG5F7BlUHCpyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765080; c=relaxed/simple;
	bh=QYEzhcOGj4TazD6Th7URMgV9zPpTd8lpRnUIxICheDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AFObG7ByMsKIKPJnfVCYP/D77Ap+P3vJh464cRRf8cdC9VuBuB4L53PuCK+nbwiHLcJOpdPqFpU1SSUr4fUm0tf/gOvt3ie8RWnkjrGCIL+JwdoAZt6tzvK3AHtW9cKDY4RhUYW9QAO+2l78tVbqVuTLQjBoU+hBLrGbBsIOBz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DyUT7Gvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DyUT7Gvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BB9C19424;
	Tue, 17 Mar 2026 16:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773765079;
	bh=QYEzhcOGj4TazD6Th7URMgV9zPpTd8lpRnUIxICheDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DyUT7GvyEbIreqzf4/8GMxrg6XFwmFJ/2c/4U1oDjCFE3fMcYZXVa1ASO9JWnz5Bv
	 vpugXbo88UW0ukm2Sm305okE1uiE95Jw+x/bLqwYfnZ0nXuIMO1pVgHBdbL45SukQZ
	 dVGuzIfgDbNorlt8JTrGwBgc1L8cK4lqVh/+2fSd6t4BuS1hTRc3iTmZdCUdwryRmR
	 EA/dB0ta02LiKm3ASiayH9aKQN17uc9qaGx/uKtuPP5OFisTgSpFjNGpUBm5N9owEA
	 LIKRk/Z/YFJob43Uwmavnv7cOI8JTFxjknYqSvzhyqga51E1n+Wg+aYa/N8AhVb+Es
	 AhxjieER8kqrw==
Date: Tue, 17 Mar 2026 09:30:19 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH] crypto: crc32c - Remove more outdated usage information
Message-ID: <20260317163019.GC2931@sol>
References: <20260314173130.16683-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314173130.16683-1-ebiggers@kernel.org>

On Sat, Mar 14, 2026 at 10:31:30AM -0700, Eric Biggers wrote:
> Remove information from the crypto/crc32c.c file comment that is no
> longer applicable now that nearly all users of CRC-32C are simply using
> the crc32c() library function instead.  This continues the cleanup from
> commit 0ef6eb10f2e0 ("crypto: Clean up help text for CRYPTO_CRC32C").
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting crc-next.
> 
>  crypto/crc32c.c | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
