Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EAE200136;
	Fri, 21 Feb 2025 09:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740129983; cv=none; b=BDmcDWw3XQU/KIRGXvhOkn9i62QzmSSJKZISn65Bt/5Fk+MgIw0Drf3RGiPZG3qK3cKzuPIzbGo8c/WwKs09to12SAq5KAG306uJbiMHHgVu6hoE7DDAtg0cSgRe/IlJgDEtmfdsspoHaCzYvdrppBk1NQ4cyz9sjTDmKySVRxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740129983; c=relaxed/simple;
	bh=hOSsedCj3g38FhSSOd3SZ3fzOuo+HAK04UOzp4+ZXs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XQh4o6xZF6sFmam62nf2PjBHCM4G5n0zdhOoG0r23oMK6fsMR7kqTIVAPdRNwCVFAuY58u0xesDNRhkegmQz9apPUgwp0Ikf/uG7jXVzCJLB8JGH1Z2tLPfbaCaAzrI2NPm5fmU5rPjJw8tvK8iGG2gSP6c5E+Iu3Saa4gzqcXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=kG7XmSet; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="kG7XmSet"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XVUfXHkgpf0123n4/unRomqnVdNIJe5wzJMUHc/kqRE=; b=kG7XmSetoUZNQPGCyJL6PT6Gm0
	N6tTiUhuzxjKG+Fmgqn42cXHYBopi+X4PM0AY9OfGgP4vxXrkLnMYYfn7/WNzLkGJgG0e1OXuct5v
	c7gZHkjizflCnSjVkuwLcEmuvWHf7iluts+cY/OllGDpWhVmbbyWm8PGXmr3EPU3gWOLIbs7oPbJl
	hbREmBl3R/iYaMktJ5SjctwVgp5BdfF7QhfAcVf4b7Cw9WkxeHDCtu/TvaqBW6lE3rD9o2pmM0922
	ElicLgm5czPVDjG7Pc81dDOnR1NMTbE66eUZpvC5v3pQzKSirHXrUrxB5NTLcFZAR3xo3Z8RTUwC4
	agpOZtag==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tlPIR-000YQo-20;
	Fri, 21 Feb 2025 17:26:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Feb 2025 17:26:11 +0800
Date: Fri, 21 Feb 2025 17:26:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH] crypto: inside-secure: eip93: Correctly handle return of
 for sg_nents_for_len
Message-ID: <Z7hGs9rzgceurzWo@gondor.apana.org.au>
References: <20250215233621.6277-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250215233621.6277-1-ansuelsmth@gmail.com>

On Sun, Feb 16, 2025 at 12:36:18AM +0100, Christian Marangi wrote:
> Fix smatch warning for sg_nents_for_len return value in Inside Secure
> EIP93 driver.
> 
> The return value of sg_nents_for_len was assigned to an u32 and the
> error was ignored and converted to a positive integer.
> 
> Rework the code to correctly handle the error from sg_nents_for_len to
> mute smatch warning.
> 
> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  .../crypto/inside-secure/eip93/eip93-common.c | 25 ++++++++++++++-----
>  1 file changed, 19 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
