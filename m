Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449E51847;
	Fri,  7 Jun 2024 11:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717761435; cv=none; b=nVs7mD964CvqCfRNDmEGCOFuKzu5lxODDF5tgW0/A991GdxRmgjSKC3qDfn4gOnI3MJSUl4TJr3KmEHaZqkUM3/ny/l8EDjC+4vA4Aw7VpHBNYyBWkjGqxoxZs+usyrggp5Hi5CI6NZQNhlnI1GFE0OmbWRPGL3pMAyFGV3j/3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717761435; c=relaxed/simple;
	bh=adjTYryesZPpS5hAWfrCjwqqYGcWxRjoYGnUfbQ27wI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wk2prfNv9pBhtlXl5uHsCpMrvd4umE/o9SQOWjP3RSnXPYYTbqiLJ7ICL8Z4pJyZyR32ztiu6/3V1HMIu4Tr5sTZybGo+E2gpFmk7MWdmY9iS84p+0ZPPgUBncx64qnD0IGaN0LPNQgw5mnC5BweudJcnCvQwY9GfXx1iGpbcGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFYCw-006pHZ-21;
	Fri, 07 Jun 2024 19:56:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 19:56:37 +0800
Date: Fri, 7 Jun 2024 19:56:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: x86 - add missing MODULE_DESCRIPTION() macros
Message-ID: <ZmL1deAM0RrEDHJ4@gondor.apana.org.au>
References: <20240530-md-x86-crypto-v1-1-b480cbcc6bdf@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530-md-x86-crypto-v1-1-b480cbcc6bdf@quicinc.com>

On Thu, May 30, 2024 at 05:53:17PM -0700, Jeff Johnson wrote:
> On x86, make allmodconfig && make W=1 C=1 warns:
> 
> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/crypto/crc32-pclmul.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/crypto/curve25519-x86_64.o
> 
> Add the missing MODULE_DESCRIPTION() macro invocations.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  arch/x86/crypto/crc32-pclmul_glue.c | 1 +
>  arch/x86/crypto/curve25519-x86_64.c | 1 +
>  2 files changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
