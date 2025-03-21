Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439951F09A8
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 11:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742555104; cv=none; b=hytX6RIUNqadZJsAVPF2DZJaUAWT1VM9peyyL2B72b4Tt0ll22F6evVTBTLcQjOawT7S/RqUHH2NZ7CrUZnehNiTNoUc5rbNx8hP2jc6AbtE0jCeakpCuu5Wu4eJ/eFvnBNXvYesOcEzyCb/xXxYJsDVSFDVja/HLa2BGzmDMx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742555104; c=relaxed/simple;
	bh=+NxUk7WnEDsq7q+OUsqkqz6MsOFm3MMO8P2vT9vrbD0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=u8zluxIbg2RIx9ngdp64Zn4HNSnZ/px26Slz0R3nq7GZZ8osS34qodCFjhLz7CIwFifRX90NL5S0Ugp1kRsTkquPeDxRsPbMRfDLcEDFtfo2RLznNbT5dQB6jrKcAxbwDgtQVMgjmM45iy9/B38+imAdUnh2+nK2SGo/4JmuEcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Hxf8Jvkd; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Hxf8Jvkd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=NcnZiLmIL8O3cpGZKNidIp9qMd3OoC1U+ll0Kk4iU94=; b=Hxf8JvkdS9S09NTLfxuDvF6IkG
	RsFu69sWFkBFZ2OTuykHEX4KYJqDa4rmE8sSL2mg9YZFBsCxG6Dr+ioWVh1b4krZn8RVf3rIXAmjU
	DJPRzCKBptk7JmWzTl2WgoLa5F40Or19TjWCy3dRfQOQBTP4Cpgy4AnMbv9sdSsUQzAs4Veile8dA
	w669L7xSsVSUZcOf8qLjTsnFKrcNvGCjBvMcvpL3VWOTjzdBpXJsUFbjlXcFwMKUwsiawgtcspjnN
	uCx3f6EGF5TuAkm8v5yOV+R94/xJCwUd11K3eYd4t5wErferYXRiQErg9icq+kSDVzJ7V/fQDgU0E
	M1FgSl9Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvaBN-0090AN-0O;
	Fri, 21 Mar 2025 19:04:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 19:04:57 +0800
Date: Fri, 21 Mar 2025 19:04:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: scatterwalk - simplify map and unmap calling
 convention
Message-ID: <Z91H2Uz7Al4EtIuT@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250310172016.153423-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Now that the address returned by scatterwalk_map() is always being
> stored into the same struct scatter_walk that is passed in, make
> scatterwalk_map() do so itself and return void.
> 
> Similarly, now that scatterwalk_unmap() is always being passed the
> address field within a struct scatter_walk, make scatterwalk_unmap()
> take a pointer to struct scatter_walk instead of the address directly.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> arch/s390/crypto/aes_s390.c  |  3 +--
> crypto/skcipher.c            | 28 +++++++----------------
> include/crypto/scatterwalk.h | 43 ++++++++++++++++++++----------------
> 3 files changed, 33 insertions(+), 41 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
