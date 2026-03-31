Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F43283FDD;
	Tue, 31 Mar 2026 15:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970907; cv=none; b=CRmCJhA0BCZOKKkvyX9oKzz+ygWXSyVjm6S4wh6Tfh4h3KVRRzzGBbrX8XevEez7u4pipOIGphfDfkaysXrUXOzPsWlQcJaes+uW7Ap3W4tCjVkm2360fRVGiq6xEURWJNjppd6EhacD4DU/KQRCrGps37JDeoOWOMoj3Xfdno8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970907; c=relaxed/simple;
	bh=R4NXVOYIByLH0dw7F6K+jnkUFHgQldz1RlrfDEcu4sE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=upqI/Hi5tQqutwfKg2f78DNObEHUn5loGPNpbbbivBWl0XaEozyfgCXaol3LvB4lCoMLxjHY/86qtz8c/H9YZvTDQC2B+rKqO0BSu/3CvP78GM+MAsQRUFDDI4aSSbfLCJYnIAZG1u1JfF0v8pk+osIIj4dmElcJHXdZRcYGiYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A1B1E68BFE; Tue, 31 Mar 2026 17:28:22 +0200 (CEST)
Date: Tue, 31 Mar 2026 17:28:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Ard Biesheuvel <ardb+git@google.com>,
	linux-raid@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 0/5] xor/arm: Replace vectorized version with
 intrinsics
Message-ID: <20260331152822.GA8238@lst.de>
References: <20260331074940.55502-7-ardb+git@google.com> <20260331151653.GA8011@lst.de> <2176aab5-2167-4cdf-9090-0f8e0a6fb5a0@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2176aab5-2167-4cdf-9090-0f8e0a6fb5a0@app.fastmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 31, 2026 at 05:26:33PM +0200, Ard Biesheuvel wrote:
> The RAID pieces are going through akpm's tree, right?

Yes.
