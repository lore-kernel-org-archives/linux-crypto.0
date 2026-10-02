Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAAD48124C;
	Fri,  2 Oct 2026 10:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790936139; cv=none; b=D/gazh8cNR5Ib64UqpLdJYppvFmrTm9CfB8hlt3Z2VLCrMb0oQDQVTptKwr5ZM1nihPWCtsGQ/uwpFxqzHsFb/3q5zBjij6dsl0zuDl2xEatA/p4EAFpsVFYRCiRPRtKEghEKh4cDsDb2p6vsZzb3JFxHo4fISwOOHnJ8GBp2rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790936139; c=relaxed/simple;
	bh=1cm8b+PscqJIAbv/Qk0ZbqKyzZHRC65AUyJx7Yw7Pdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KjOKOd/IGj8+DIpl8ynfozDbn0gyZUZRoISSvXhEwe6StDyZ1r+ZkTsXcxd3C8JTzCFiI1sdlEj2QAVgN0mkjFARtMa+Mzeb750f4lNpBEmo6/6BPboCwyvGjmtWCEJG/hkotk03UsUzE3kwbWGGzGsP2Pk/G7a1xdjAYvRJ788=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=dzyJzPRV; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="dzyJzPRV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=DpO+tCzXIrvQsZ80X0O2EcvFjKUYJbaUbIT8ntOBJWQ=; 
	b=dzyJzPRVpXG/RNA259cYzK5hLFijyjx+W/zSPCKg0mFCIP6oGfin4qvYH9oJqzp0vQEFyG5fYHQ
	11fPqRhtD5MRKQh6IDvNEsro3yM2IG7LY8c2vbm3llmbLxYqEXxxJh9tnjBWDeFXPXQezyvUhtgc3
	qZEHorMPb1JbUWsULB6+ML0yQ2DJatKDqjyrGov15znmWDfrkV6VqoQ7JmqlGtbtgfUwHnlAeqY83
	K4KY7m9GBrZMahOtujInDujecqQCbWeIbY7rNtyzSnvSVifGFbna5zNqVXQaFxA2O3VQto5pZTvHM
	CA3LCbth2o1Lcg9tGJtqZ7EHAjY2Xb+Iiy6A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCaIf-000000001iK-0diR;
	Fri, 02 Oct 2026 18:15:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 20:15:33 +1000
Date: Fri, 2 Oct 2026 20:15:33 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Laurent Vivier <lvivier@redhat.com>,
	Olivia Mackall <olivia@selenic.com>, virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hwrng: virtio - use min() in copy_data()
Message-ID: <ar-ERTXkn9C12yBr@gondor.apana.org.au>
References: <20260926055853.4868-3-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926055853.4868-3-blum@kernel.org>

On Sat, Sep 26, 2026 at 07:58:54AM +0200, Thorsten Blum wrote:
> Use the simpler min() macro since all values are unsigned and
> compatible. The subtraction avail - vi->data_idx is also guaranteed to
> be positive by the preceding check.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/virtio-rng.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
