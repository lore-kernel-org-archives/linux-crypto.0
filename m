Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775C624466F
	for <linux-crypto@vger.kernel.org>; Fri, 25 Apr 2025 11:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745581254; cv=none; b=byy2ynuv6CnK/JHJ/dYrFy5JtJfFVhklzKTCvE15QA7TalS9yLhutogG8gzl/yZVDV21tetjLcFKorAqgURFIJ5wQwh0Q2L+MtRAYo4x6YHqelp//hgsxNYzQt2VNLiN2eaSaQEWA44xxhLAeqD9IerKCsce9zNG0noyKACcN+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745581254; c=relaxed/simple;
	bh=Hs3iiq79vDR3UpXTUZSNPNo7ajxRzC8QYUMIdo2oj28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rcHJvWHzSQHVmpBVQwr+HNCoYGrjuP9SXuByCWq/L4vBILY2p84HgpmwUWr7U2fJn40qvizuikW5A/90DpPNITzXXtJG43VXx76IeG68d17/8VLXsv1iHEYar623FS/QGsXQfBLBWJdzfdEemW2bDlutxA6/AoD758/b/8BzPWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=UTkVmmqL; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="UTkVmmqL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=b3+/BgFG+NEFiGVhq1w+PgAhx1lyVOnIsWO9dDB85OU=; b=UTkVmmqLUF2waNC3DgJfT0vkFF
	9SkdSzIbwj70a0D36IvjzTgrT20OBLPYEXnMg5hy5Xnl3rh4NojoUwztafI9qe80xXyBsKJC0vOEE
	LgkxH/38T5hjWyAyfOWhzDXzvm7X5sF058MnOTOWhBIY/g82Uv/2gb9XOmZZYM7nxajIJrgpd09mZ
	yI6O/VvnNN02B+ZFj5WtgnJtfTlD+dM0g6BdBna0I+vYQ4MhOnVfn5WbBSE+B3XL78tLzhMj7vj5n
	JChm0st/TU6bilpAchsUtCyHAT63AzDvHZP+BzCQm0lDTlBzbmlCkUfln7w3lMKlf7p0y+gGyK+VC
	1UvEY4aA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u8HQF-000yUW-1Q;
	Fri, 25 Apr 2025 19:40:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Apr 2025 19:40:47 +0800
Date: Fri, 25 Apr 2025 19:40:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 08/15] crypto: poly1305 - Use API partial block handling
Message-ID: <aAt0v0fiJg2NYq1g@gondor.apana.org.au>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
 <20c70ad952dc0893294f490a1e31c9cfe90812a9.1745490652.git.herbert@gondor.apana.org.au>
 <20250424153647.GA2427@sol.localdomain>
 <aAsErcJZ_FeJ7YEg@gondor.apana.org.au>
 <20250425035901.GH2427@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425035901.GH2427@sol.localdomain>

On Thu, Apr 24, 2025 at 08:59:01PM -0700, Eric Biggers wrote:
>
> I already did that.  See commit 4bf4b5046de0 in mainline.

Thanks.  So I'll pull that into cryptodev.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
