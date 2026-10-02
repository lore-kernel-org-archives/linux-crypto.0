Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11684425860;
	Fri,  2 Oct 2026 07:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790925728; cv=none; b=l0MSwwbu2rd6awyGimxPmHQiVrxubvl7wsXNgYf9iufvA5qLuANxTGhiP0tUk4P6SEoAST7OSeNSjlJ9O+i9PJclGBlNdWq/yCsSzBph+llRuYE8p8xnisk/WWJykVkVTtOFu/zHj/rWXdxGPymUzUu4/q+HcDhFzkvAUF1PRk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790925728; c=relaxed/simple;
	bh=DbKHsRJ0/1fphp2EygeU31h+SjA9hextSE8MrX+uqec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NKwS4e4D4YzkqhBXTWKagzJ2kDdgUypnAYxSG225OQA7UXiPkGvIZWplqEjoPuMuU2LIXHCvwI+3mtsTOAVWAw8e5ISlOaVRjo/SrIOYKRIIwenCKcw5XOuXVEQFyY+pUpoArxxyTFKaROj83YUARIjwMD5XENXIi1AmofCp9Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=COEZP69/; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="COEZP69/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=DQPjvqrT2ssm3b1JgWpqWRmIiMZpxBhnouqMGqlTq34=; 
	b=COEZP69/+gjs3QLzNZ2SHt0ZcN2+5h2h8JYzcQcdf/AU8rkV777AdFW5+0K5/mS/Sc21hcuyh8l
	BYqqFbY1IwtTqD1uMdUCGbgz6Ces/cmXMWrbPz/ieNNlrucy2NeLAQF+x+bnboEfXiJdsBtACSaoW
	PryGY5J/IxU0jKCfzSfeTKQguaOPfUW3ew3oyp+zYAmoDTwgbQ3EOuSu8+zm7nJSTUIdURM5BAsT9
	glueFw2FjMMgxsPbWP+cE/EkmocH5OMlK5byCwS/u49LcHfv99d7YWwOFbjS+uo6JKoh7vDzUN+ug
	d8ScE0J7lbe9eKZxiVXS4lrn/nDjwpeJiAWQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCXaY-00000002lLF-33p0;
	Fri, 02 Oct 2026 15:21:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 17:21:50 +1000
Date: Fri, 2 Oct 2026 17:21:50 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>, Kees Cook <kees@kernel.org>,
	Michael Buesch <mb@bu3sch.de>, Andrew Morton <akpm@osdl.org>,
	Jan Beulich <jbeulich@novell.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Chris Wright <chrisw@sous-sol.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hwrng: intel - return -ENOMEM when ioremap() fails
Message-ID: <ar9bjjPC6xAgfPzT@gondor.apana.org.au>
References: <20260922181102.67309-3-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922181102.67309-3-blum@kernel.org>

On Tue, Sep 22, 2026 at 08:11:01PM +0200, Thorsten Blum wrote:
> intel_init_hw_struct() incorrectly returns -EBUSY when ioremap() fails.
> Return -ENOMEM instead.
> 
> Fixes: 641dd002d207 ("[PATCH] fix Intel RNG detection")

This commit ID appears to be incorrect (but the subject is correct).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
