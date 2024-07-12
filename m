Received: from norbury.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A25413C68E
	for <linux-crypto@vger.kernel.org>; Fri, 12 Jul 2024 23:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720828644; cv=none; b=CP+P3jvY73pBRd2Sfm05Ab+2acHmiE4jrpX0xFhbO1UMhX/JkN3WwnrjvNcZAIEYlCn0FurUyOnrJ2quGF85m5v5Ipp9np1+Z7APgIlwI3cLcUN11JC6avW+nkWfULLQoJahSE4onPk5oPm/czNxb5oZBOB6uIYbULpdwYwxQcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720828644; c=relaxed/simple;
	bh=JrxXV/6gEmH3kwWPW+6uXUHcEMIZKmdTl+UZSte3sec=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=ro0OhOFua32+OdAuX+5dwicyaWXUJJ0NihAFP/hurLyj+wbH0FFiUGa37eBVfm8HKZgQ38ruR3jxs9FW4hbOOqFW46XMsgyYdmGM8sr+b6xgkN+7gdkRdcn+gyXtYfuwZiM/LRbgeyMZGEtVMP2ZdRsA1gGWmw125yvIkIAIjjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sSQ8Q-001q5U-0V;
	Sat, 13 Jul 2024 09:57:07 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Jul 2024 11:57:06 +1200
Date: Sat, 13 Jul 2024 11:57:06 +1200
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, samitolvanen@google.com, ardb@kernel.org
Subject: Re: [PATCH] crypto: testmgr - generate power-of-2 lengths more often
Message-ID: <ZpHC0jHJj2smmR3A@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703190431.6513-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Implementations of hash functions often have special cases when lengths
> are a multiple of the hash function's internal block size (e.g. 64 for
> SHA-256, 128 for SHA-512).  Currently, when the fuzz testing code
> generates lengths, it doesn't prefer any length mod 64 over any other.
> This limits the coverage of these special cases.
> 
> Therefore, this patch updates the fuzz testing code to generate
> power-of-2 lengths and divide messages exactly in half a bit more often.
> 
> Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> This is the same as
> https://lore.kernel.org/linux-crypto/20240621165922.77672-3-ebiggers@kernel.org/,
> just resent as a standalone patch.
> 
> crypto/testmgr.c | 16 ++++++++++++----
> 1 file changed, 12 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
