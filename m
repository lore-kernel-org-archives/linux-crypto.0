Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED9B13119B;
	Thu,  9 May 2024 12:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715258633; cv=none; b=E9YZJqbOiG9nr6CMYe7uGQqE0EJADDgTHVrjko+cx0oviXsaUC5yQdmzL9rn3Gfq/pjM3p6X6IvJQjJv9170XaKtuMfzLufnf3m9UNGDJ9c9aXwhMZ/utgnFS5+cc3kCwFXIKwxOL+GH/iR6hyo3agAkw9HvUS8U2kVItL/DHJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715258633; c=relaxed/simple;
	bh=HBcVcBSYqlBUAm8jvtm5+A58mC2yPRD1whRmcdP6P1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tcqVFo5J/yaf66EU/mvcpwPAtOJbJh6DeF4YQmCy3196Wc2DHGxNDM9F01j6wGI1Gkw31DRsae3Ah7Eh8zPYuuW5KquKRaLhQefYRsfNBRhC1TDSrSmJnLCvGxvykVMrQmIDVLmmijnp9PqDsmvnXWrQoonoAM5S7jvaL0DYl1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1H9Ln6N4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1H9Ln6N4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CLJUPZZT4rSELmqegiikr7a3zGPJvoLk74CHf7f3U60=; b=1H9Ln6N4Ls0YJx5s+D/LXGYj8Y
	iw8xSy6uiaWGZCbVIlkzFqGlEPbGDmP2qHiytPFsNx3/5G38xKw8aZxMFdUOC8GA0H0TAObEL+idJ
	z8LJIoEmmzIlglY6bNnznAdlF5bP/eegGaIph8asX/FNy7fFgkvNiMycAcMLBwetgO0+cYEqqUc1M
	/svUCZ73XxeeJyqWDC26W9i6itQD+tS8HJ9H+n3o9nKsuz8Bd4FfYprC9cJll812v84I7XNY+HpJo
	lIa5r/5wV2L3uba08Ow8B4/svgHxy3xbGcR3Yh272y5sIDEeUmCZvcuY3irAOytulG0uVzgo1p60s
	qoin6rYA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s537n-00000001T9s-1bCv;
	Thu, 09 May 2024 12:43:51 +0000
Date: Thu, 9 May 2024 05:43:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCHv3 00/19] zram: convert to custom compression API and
 allow algorithms tuning
Message-ID: <ZjzFB2CzCh1NKlfw@infradead.org>
References: <20240508074223.652784-1-senozhatsky@chromium.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240508074223.652784-1-senozhatsky@chromium.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, May 08, 2024 at 04:41:53PM +0900, Sergey Senozhatsky wrote:
> 	This patch set moves zram from crypto API to a custom compression
> API which allows us to tune and configure compression algorithms,
> something that crypto API, unfortunately, doesn't support.

[...]

>  21 files changed, 1203 insertions(+), 111 deletions(-)

Why can't it?  This is an awful lot of crazy code duplication just
to pass a few parameters.

