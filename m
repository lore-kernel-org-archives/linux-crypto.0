Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055BF3C1F
	for <linux-crypto@vger.kernel.org>; Wed, 11 Jun 2025 03:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749611019; cv=none; b=In2eWuL14RbHXIckcoebhiof4WE/GurCLNNl+6K+Dz+3ZrXKhXMZkZWgCcIzHkH9fdlV2Jofh7+5doMU01MkFp4yBoRnBLAjmRpZ4NJlgvcBItnCR53+4kXMFD+Gs6+puP89QZGUVbPSMPJaQFi2DEO4AWlRy5ZORdJnypABJR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749611019; c=relaxed/simple;
	bh=N76sVOnhOqOUdThrMAyGo8GCtS8th2Z7GiNA4WGn1XY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SSg+Cv8UMixsgRFmk5gKpBJIJDzZmLTx8EUp8nY2O+r3t8SY4LvnDMHd+DgdJFwV8x0Al426HPyWIlLd/n3IYt5XtgTN6pMeSItdFi8NBq/cokq12Zq7Hb0AM/yYkjGgmJ4bNOTLcNNFqgv4zwFXGI7qeI50N/DEQ8o488T6APY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=IGD8mcFA; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="IGD8mcFA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KpRNpS7NZwnUKP8a81F4FBb9SxoFuRPqovB5pyZ/EwU=; b=IGD8mcFA27nYpGH5Te03YphbrC
	/6CqF2qjNK8CIeJmlge8oMfAtIW07M+/EeSxut1Ex0nyyTIzLh7UbN3bSb8tTEiqKYMufiLp6ORIC
	RIcVr2Syy47qFNGAunhwYpdfCzCVp0AAWeIPhMFOGF+BlFSJo7PjY/GgUgNxGVkZK/umXvfMB9dhN
	8AEbyPd6m8vnnyAhA7TcFYd6bK6m0rzpLHvLI2hK/Dx+yWrgdRVKtaluN5tgL+BPULF9ExwWsxYyc
	P/sXujL4+ftyTGKbTdtKvvICKBTln4HIPBAwNGSxTrFrZZLltl4U7RNZG7WrFGS/vRk7+3dJyGbsJ
	/xL2Weaw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uPBkS-00CFCc-0j;
	Wed, 11 Jun 2025 11:03:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Jun 2025 11:03:32 +0800
Date: Wed, 11 Jun 2025 11:03:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Ingo Franzki <ifranzki@linux.ibm.com>,
	freude@linux.ibm.com, dengler@linux.ibm.com
Subject: Re: [PATCH] crypto: hkdf - move to late_initcall
Message-ID: <aEjyBGU7MiPvglQC@gondor.apana.org.au>
References: <8bf5f1b2-db97-4923-aab0-0d2a8b269221@linux.ibm.com>
 <20250610191600.54994-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250610191600.54994-1-ebiggers@kernel.org>

On Tue, Jun 10, 2025 at 12:16:00PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The HKDF self-tests depend on the HMAC algorithms being registered.
> HMAC is now registered at module_init, which put it at the same level as
> HKDF.  Move HKDF to late_initcall so that it runs afterwards.
> 
> Fixes: ef93f1562803 ("Revert "crypto: run initcalls for generic implementations earlier"")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/hkdf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
