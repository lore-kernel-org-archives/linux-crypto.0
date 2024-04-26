Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDDD13EFEC
	for <linux-crypto@vger.kernel.org>; Fri, 26 Apr 2024 09:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714124356; cv=none; b=NDe1gfJqseZxScTORzoPmBKCnPAhmLkhl7h3CWoNWZRyJWsMjprJJGvTPgN+SWumbeh4MifCKA5JHVQ0vZoWV4BefNuSJ/yNFrDfddQ5C7X2TZOMYGu9V3IqHwerCBjNs/qz5nltX3Nt5pRirV05bgpwKDJZ+Hvtdu9vv018poM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714124356; c=relaxed/simple;
	bh=erkWEGRbFFLRABB1w72Q/fVwouVEZcpGn2NzwH8neIo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=EbqZiXRUTCdXQrtJfzLRmaF3AdR2qoHx57NWdgWeWtou+cGaiMlJoDCfULkBE2Ea+dsjRHFlcv+929f9qw0Ipc8JidqkVXDCVjse7XpTJ1IQm4n4C3icb5ZWBjuFhXQuVDJArR/5HCOJQK8vSL7OtBg6XPCFi+0k1KvuVgEtWcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1s0I2w-006ebl-TZ; Fri, 26 Apr 2024 17:39:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Apr 2024 17:39:28 +0800
Date: Fri, 26 Apr 2024 17:39:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2] crypto: x86/aes-gcm - simplify GCM hash subkey
 derivation
Message-ID: <Zit2UFW+vM7BsOet@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240420182016.28159-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Remove a redundant expansion of the AES key, and use rodata for zeroes.
> Also rename rfc4106_set_hash_subkey() to aes_gcm_derive_hash_subkey()
> because it's used for both versions of AES-GCM, not just RFC4106.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> arch/x86/crypto/aesni-intel_glue.c | 26 ++++++++------------------
> 1 file changed, 8 insertions(+), 18 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
