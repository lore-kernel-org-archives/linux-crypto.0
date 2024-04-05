Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4414A143862
	for <linux-crypto@vger.kernel.org>; Fri,  5 Apr 2024 07:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712303826; cv=none; b=M5Z+B5rahH8sSMRzKLeYgRQbu88VsnCxGMQt3Q9J4AWGFz1EW1/jqqP+SJT7OQDJpEn+nbgLUZKTkNK4WeeDwRv8pFa4AHrr5tNCGJAzhVhBE0DZJKxKulPItavsQ1CfRwSwA7NWtDmJhVOmBbpPtaA+zTZo120mW73YssupP1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712303826; c=relaxed/simple;
	bh=8TnUvStlVlZ0x0cwlJ4Ix6SJCSmJtCxyxcCTq9T4lXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r0Z72YiQ8nNO+TWZl7OHolNAEPDrQmOTVznPGky/AfdpL3MX3ct2MF94DqOo7YnminkhVkeHN/UIUExV+AXSSH3qEzkF75Ch9qSPbuRiQqO1hg9BbwPIOFkGzfAdNJpzQ5MDMHBkTbNK9LJSjVlgHjorplNwaUT3ehrsI0z5Q/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rseRX-00FUBI-To; Fri, 05 Apr 2024 15:57:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 05 Apr 2024 15:57:16 +0800
Date: Fri, 5 Apr 2024 15:57:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: linux-crypto@vger.kernel.org,
	Salvator Benedetto <salvatore.benedetto@intel.com>
Subject: Re: [PATCH v2] crypto: ecdh - explicitly zeroize private_key
Message-ID: <Zg+u3J1urW0z0C4L@gondor.apana.org.au>
References: <20240328162430.28657-1-git@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328162430.28657-1-git@jvdsn.com>

On Thu, Mar 28, 2024 at 11:24:30AM -0500, Joachim Vandersmissen wrote:
> private_key is overwritten with the key parameter passed in by the
> caller (if present), or alternatively a newly generated private key.
> However, it is possible that the caller provides a key (or the newly
> generated key) which is shorter than the previous key. In that
> scenario, some key material from the previous key would not be
> overwritten. The easiest solution is to explicitly zeroize the entire
> private_key array first.
> 
> Note that this patch slightly changes the behavior of this function:
> previously, if the ecc_gen_privkey failed, the old private_key would
> remain. Now, the private_key is always zeroized. This behavior is
> consistent with the case where params.key is set and ecc_is_key_valid
> fails.
> 
> Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
> ---
>  crypto/ecdh.c | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
