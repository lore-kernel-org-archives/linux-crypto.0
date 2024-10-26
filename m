Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822981CF96;
	Sat, 26 Oct 2024 07:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729926219; cv=none; b=oaYZKmL8zJcqDvfx0ziaeYOOMO+OHEX4U1Q40rGkVv0Pkbu88UtZmw8Fd4DGpvrtnSRpaxvroE1YmKncXsChkp6nm/mppZRfh9UKqj8UYSNJdDfmJVTIIYhCVsQA1aR0RQ6yptr96JiXki26nle0g2xJTSMkxMliPFqwaBBX8Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729926219; c=relaxed/simple;
	bh=H9fGZnzwcKNn6KZo3Ntsp5Charx8ZXj2oZObi1Cr8es=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DFuYvXIZ3KuAkkiQKLex7x0DU54tSpSzXfCju/sEvmara7XVXXwRn2HCj1MAGKj+WjBeG0NWboMav2HU9dEoUYpry/bPMq1nTHpdVJpS/wbGLkEAEVR07xOlvdP52UWibIHlfG6voaMB9ns/bXkfot3q+Z3fr/MT5B7k8gj39Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GBd/UPkJ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GBd/UPkJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=M2BQO23FpOGOopTnjnb/SBnH2W0PJxbtAGu6aviJOXA=; b=GBd/UPkJVMgSHaFTmTxNrbuQil
	kxxy2FwTV4L88peK2+YZzcnV88swtO+6pGDGXN4y7tIcHk3A4P4OMuu2EXgBGopvy09+Vlai1cfLE
	/tOqgK0tVzNVNcxkKc28md94bQ/q0FU/BKLEjUYJobKYUiwIlK9y3rusyKvWXEF18ufbo3bDCeWst
	2FzP6HIHOf0iW2i9WFYBcRzx6VBbbduyT05dS4eRaw1MBtNYkOUK2hV97yFnGiCOFxFQ61QsEEcKq
	9ZFWIGY4TwNtN2Vm+SLziLRUFB/OZ299+zdyyxHDvu7SZcbcl5QtSeX85/ZD/Fb1522vkeNWXoG3A
	/w1K9A4w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4apZ-00CG16-1k;
	Sat, 26 Oct 2024 15:03:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Oct 2024 15:03:25 +0800
Date: Sat, 26 Oct 2024 15:03:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Everest K.C." <everestkc@everestkc.com.np>
Cc: gcherian@marvell.com, davem@davemloft.net, skhan@linuxfoundation.org,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: cavium - Fix the if condition to exit loop after
 timeout
Message-ID: <ZxyUPf9qjZlSA-bK@gondor.apana.org.au>
References: <20241018162311.4770-1-everestkc@everestkc.com.np>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241018162311.4770-1-everestkc@everestkc.com.np>

On Fri, Oct 18, 2024 at 10:23:10AM -0600, Everest K.C. wrote:
> The while loop breaks in the first run because of incorrect
> if condition. It also causes the statements after the if to
> appear dead.
> Fix this by changing the condition from if(timeout--) to
> if(!timeout--).
> 
> This bug was reported by Coverity Scan.
> Report:
> CID 1600859: (#1 of 1): Logically dead code (DEADCODE)
> dead_error_line: Execution cannot reach this statement: udelay(30UL);
> 
> Fixes: 9e2c7d99941d ("crypto: cavium - Add Support for Octeon-tx CPT Engine")
> Signed-off-by: Everest K.C. <everestkc@everestkc.com.np>
> ---
>  drivers/crypto/cavium/cpt/cptpf_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
