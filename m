Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8765323D285;
	Wed, 21 May 2025 10:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747823091; cv=none; b=qE7bhwCpFdllbe/qYmmznmGu9dWaRIt+/RA+S7sFIygErwNnX9FAl6qPFwA13F7Yg+Jmgu/c4USbiUiF7LSKc21/fPSCyPPxd7MhbT7rnscLwn0TBGguczhLBl1VgfKfritH6Et+F+E6h+BzYnaCjV3tb5lJqik8t3At5K6g4ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747823091; c=relaxed/simple;
	bh=+UyyDkCLnte6nSq5RVuDCL8H3Zb2YQ1cvE/Ic8mCabQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fqXn1QXqXtrGuBy1PnNwq+mfxFkWtnnwbpJXue8ZIEE8nkgHr60hLzcshBDvwYZ+RYaHrY8VpLSL/xElUEzY818pl7WvxcvgKPsM26wMjjU02XSxkFvykxH5bRkdK6CjSpKweIcnbgWZ9SDMt/Vdgo7UKZEVClEkrIDwunEzfog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=G8wNYWt3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="G8wNYWt3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=d2yQuISbJ04EJUZm+IrtAPLTrcn10JzQXufghkOjASU=; b=G8wNYWt34RJHIH444OeP0P/0fj
	ZI781h2me7cKV/U5fwMKb0BqlCZgLEqzS9OwjoUzpRjidH+BfRcKHtmoyIgpMcLtQCDM6L5epCOIZ
	66TORFwgyrxxCLeF5IxfIqoqvvuCjRHE+exNAdqZYTPjMjebPu8iSF6X4lLrK8VG/6QgidDLNafh1
	zfpEPQiKxZqF+aaOCPMAiWrxGV1JfhWt85u/UgEt/8hUbEzFx8t9yz/QwvcJU8ustFI0lWFVnpt4F
	LW27mT91EBTEYhs/ZWibOUsvYOrAGtj49MbjCmP0CODa+mN8De+tTIDXICCkny8ys+AswOVfWRnoi
	JIwGKN7w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uHgct-007mXn-2b;
	Wed, 21 May 2025 18:24:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 21 May 2025 18:24:43 +0800
Date: Wed, 21 May 2025 18:24:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>,
	Klaus Kudielka <klaus.kudielka@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"'bbrezillon@kernel.org'" <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aC2p6xkMz4BtzPYH@gondor.apana.org.au>
References: <20250515182131.GC1411@quark>
 <f0dc235e3d7bfa1f60cc01fd527da52024af54e0.camel@gmail.com>
 <aCZ3_ZMAFu6gzlyt@gondor.apana.org.au>
 <aCcyXkeBvHQYvf2d@Red>
 <aCczV6MF6xk5rRA3@gondor.apana.org.au>
 <aChx_ODF_hYKL8XO@Red>
 <aCmTQoJw6XG1CkuZ@gondor.apana.org.au>
 <aC1fY6IP-8MzVIbx@gondor.apana.org.au>
 <aC2aAvX07Aaho08d@gondor.apana.org.au>
 <23fe1dec-032a-41fb-8e60-3a1b6c098c4e@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23fe1dec-032a-41fb-8e60-3a1b6c098c4e@app.fastmail.com>

On Wed, May 21, 2025 at 11:58:49AM +0200, Arnd Bergmann wrote:
>
> I did not see the entire background of the discussion, but would
> point out that this is not supposed to work at all:

We're trying to find out why this driver fails under concurrent
load.  It works perfectly if you do one request at a time, but
when you hit it with load coming from both CPUs, it ends up
corrupting the data.

My suscipicion right now is DMA corruption.  One common thread
seems to be that if you only use dma_map_sg it works, but if
dma_alloc_coherent memory is used then it is corrupted (this
isn't proven yet, it's just what the printk patch was showing).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
