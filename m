Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEEC1C3C11;
	Mon, 15 Sep 2025 16:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757953277; cv=none; b=axpRU7AkC+wsxC2YqqaVuSUXKglTmoqusdzUMj2srBVlYiH7qXl5QjWjed3Ak8EUCVJbNvl76uP78gCpQjNMOMCFrDuQaUbNccWv/YF65rnA3l6zQ1Wv5Pe9MtVBBYIF/1I9Wual70Vn1eCTN7rhdMSNV5CNsPK0d7TvoRkbcB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757953277; c=relaxed/simple;
	bh=/oZk40M3r1JxWGC2sg6YKlMFmfJw9aJTTCPuYilUh4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YNAKNcn9Mi+ICFKVFgYZRmLpo6QyhEsIYhmO7ti3uQ7xJqktZAi5Z5ATWnhinrwdbmuq7f5TsOFepEaGCuyRlAgzM4Mb8SNQ8SPxJEzFFdSy/2LNYJA6L7G/8ipvgjaSNWgQyOFdsjuxz7SpoQylajtcv+ssxaBRCAjZvYJXV5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E4/QleXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E4/QleXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B05FC4CEF1;
	Mon, 15 Sep 2025 16:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757953276;
	bh=/oZk40M3r1JxWGC2sg6YKlMFmfJw9aJTTCPuYilUh4c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E4/QleXhyBLlWHjPWUXCrM3J+f13MgCFGc9UzXFq/LFkvVkVz1BQWVRFsLPZ4qyZq
	 Vl6WydJvjOvekxmnQJiFPRNqn+C5ZkFFDhJUGXreIPc6gUdWKXaeUncg8DTO9Gb5IP
	 vLweVE9iT9x6lytSrlY+tKYnh6Dv1j9WqteLdShl5xRzf6UjuqrXFlyhy2eOC8fk9x
	 +HmRM9KYVJcR0FBDcW7SuCSTv7s2tkbCOb9diylzRcWA+T+WSHoRnuFa80dMuYdkZ1
	 eblFGMjw4UntNo1KOo17ifID4v8fZv52eippOG5RN0Pl1aCZ+8h+Cm8yrx0cLsRZKe
	 BbLn9GanvoFiQ==
Date: Mon, 15 Sep 2025 11:21:11 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] crypto: md5 - Implement export_core() and import_core()
Message-ID: <20250915162111.GE1993@quark>
References: <20250906215417.89584-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250906215417.89584-1-ebiggers@kernel.org>

On Sat, Sep 06, 2025 at 02:54:17PM -0700, Eric Biggers wrote:
> Since commit 9d7a0ab1c753 ("crypto: ahash - Handle partial blocks in
> API"), the recently-added export_core() and import_core() methods in
> struct shash_alg have effectively become mandatory (even though it is
> not tested or enforced), since legacy drivers that need a fallback
> depend on them.  Make crypto/md5.c compatible with these legacy drivers
> by adding export_core() and import_core() methods to it.
> 
> Fixes: ba8ee22a7f92 ("crypto: md5 - Wrap library and add HMAC support")
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
