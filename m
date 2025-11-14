Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15F4310625;
	Fri, 14 Nov 2025 10:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763115870; cv=none; b=m/l6DbMVqXRRYS7h8ZZmXwW36LOAtSzbPA/xygEv7sPZcDVNycZful3nbXqjtYjs/JZv1Pcqst4sgTtsl2smjIxERp0qdsoUdouhkFmk1nJIq4vycIUhJkpZWeYZMRrXzinqtdMLOMWde1ZtYZC7UJmA/5nNj+Gj+YQqH549+Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763115870; c=relaxed/simple;
	bh=bNhvioKBzeYotWLwLlMuFXr6cOzd+IVyztOwDZMDB2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FT9MtBPRhGwxsm8L28wJmcdUPVFWhlu9a+ggMtYWWPyrYhOHcqDxa13aogTiO8Q6++e25OhDZrZM5M0phwHE1fFeooZuYewf8cSBclkimikDmQSj32yHst9oG0/NJIfou32F/Um1QNhMkFDEzbGG3PjnS7UNZ/+oP8pEICZKNEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=EI5KF70N; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="EI5KF70N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=DhM5a6OHBs1Czle+0v0GKIrkt1BiG80uxsfXotnY/Qs=; 
	b=EI5KF70NpynHoM8ag79cWgxGapFAiNoEiyPHkIloE+n3xCn/IdiTky/nExyjlcbb/94zbJpNXdS
	NCCqkJCgRDG50DkJIEyvfBAWrCl/Dqnzkl5+8kbDITCZfXQ47uFf/OOb0jewp6geXQ4FpBXwanqO1
	Ho6o78kgefjyB0Sx9AR4a8LXX4WMd+sfmLdm6PRjru7ESRkRwyB0viFqSMGtPPwvOjxm4R8I4kx8C
	Yl2jctK/zyJjTXAZUXp7rl3wP4KHZOQ9NblYQp1rZE1PMnmUY0KdaoaGOAeiKLZtwfvA1Vu2ZJpI2
	5535W76JEs6/Ttg6rR1pOs2MGsXZYUUnPB9g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vJqyU-002yRI-0t;
	Fri, 14 Nov 2025 18:24:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Nov 2025 18:24:14 +0800
Date: Fri, 14 Nov 2025 18:24:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: zstd - Remove unnecessary size_t cast
Message-ID: <aRcDTgh9c4rRA6Pr@gondor.apana.org.au>
References: <20251108145707.258538-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251108145707.258538-2-thorsten.blum@linux.dev>

On Sat, Nov 08, 2025 at 03:57:07PM +0100, Thorsten Blum wrote:
> Use max() instead of max_t() since zstd_cstream_workspace_bound() and
> zstd_dstream_workspace_bound() already return size_t and casting the
> values is unnecessary.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/zstd.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
