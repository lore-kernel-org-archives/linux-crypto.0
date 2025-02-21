Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA007204098
	for <linux-crypto@vger.kernel.org>; Fri, 21 Feb 2025 09:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740129703; cv=none; b=rxBVaBYMo0knZp48KRTvdQSWw6DZRRzWZP2Kc6qT7QEhQsm4Jdkiy//H3ofiydtJsq/MPOe0viP0r0a/AKGeQd9iV5mz5JWxJ/fr4CPDiIx//T131oRnBHTrttUbmIMoZrPKfrvBQel7Tr6HfsnN1GLAdRyXtKzW/bjOVQ4JaBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740129703; c=relaxed/simple;
	bh=4rGkMG8mVhlmxBebes0krxPsUtfcJ+KiHlE+ogUkqxs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=LV1OXH+njbLUpPZ8ul2OYnBNRwHrwudarL1BPDH4cXAEgLaUqGgjZO+HUNSB151GoW7hwwpuVrGeJnPK+xuulLHOSdzyuF7EvD/KUEXFThCLZaNmn5mU8iQVq4dqkH4iw36ZAfnXF1c6hhtUBSNpmUTg3a5CVuPsrCE+s08lRw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YhJkpMKZ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YhJkpMKZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=0llTEwL4KI51uTuh/FO/lPuCFmyYfQqOUWvmtheCSr4=; b=YhJkpMKZin/mnIKL0sjLIIyPJu
	V1d1FpUIobrdhx7U1Qxc6jhQn9VQAZdSKdlbP9AqzfrTcwA4yDppqXNaAGIKqRZ99pkhRL/tX2+Z6
	PVFT6chlN4/CHGXLqxeBl0+i1ymVj8V+xMQ2eTjQRjAIFy2sDfG0NCMUbGtpPkY5yu3qFqZRqBiV7
	7r+P+w5EoRhoNjdKvD9aEdzs+zYIModxSSEpvUurhN7o1iPJIQ7EQMchmXo5C7KKHmmf1YrZTAwJW
	DGBg/KRldmGw6ZpyX5WGwGxA2Tu32VTdlmq4KIgJkSHPGhU4r8EokkY+vjntpM4NjDspUORR7glxw
	u4M4xAKQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tlPE1-000YHn-0C;
	Fri, 21 Feb 2025 17:21:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Feb 2025 17:21:37 +0800
Date: Fri, 21 Feb 2025 17:21:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: x86/aes-xts - change license to Apache-2.0 OR
 BSD-2-Clause
Message-ID: <Z7hFoYqKWWHWdqJ3@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210171740.65546-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> As with the other AES modes I've implemented, I've received interest in
> my AES-XTS assembly code being reused in other projects.  Therefore,
> change the license to Apache-2.0 OR BSD-2-Clause like what I used for
> AES-GCM.  Apache-2.0 is the license of OpenSSL and BoringSSL.
> 
> Note that it is difficult to *directly* share code between the kernel,
> OpenSSL, and BoringSSL for various reasons such as perlasm vs. plain
> asm, Windows ABI support, different divisions of responsibility between
> C and asm in each project, etc.  So whether that will happen instead of
> just doing ports is still TBD.  But this dual license should at least
> make it possible to port changes between the projects.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> arch/x86/crypto/aes-xts-avx-x86_64.S | 55 ++++++++++++++++++++++++----
> 1 file changed, 47 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
