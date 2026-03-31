Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB17B3126DF;
	Tue, 31 Mar 2026 15:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970219; cv=none; b=LqbDHwARz2+dAXpgxrpj1ilE7W04s+24z5AD/hwgi52CmaDODdP+/2XrsMQKg9Fb2O6qXwJ1olUo7oFzWOYOSt69cPtfaSMhqsIrG0GG36Jv3PNsksdTZDHnsmFkXyacQawWeWUTBsYSxvXGoRxOGget3AuCzoNP+9XlZwBNJOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970219; c=relaxed/simple;
	bh=BvYJMv6jCryhNn7Soq6PFp6s/tK+JHRyrI6npMZTO5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YyIuyoo3rSlgGlA6H6+xOdi+5Lbc/6RCoOweyF+XoKdg0hdV/Ee3pg703O78auLwcdpUQQshChpveDHhPR6Bwe+uN0FEC37+oNkVdT31EAyfzmlNPlQXfNt7A2wZYyF6aGkeAdNN1z3kOp1BnO1/Nnd+lZ9Yieljf2+2z1hmV0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0BF1B68BFE; Tue, 31 Mar 2026 17:16:54 +0200 (CEST)
Date: Tue, 31 Mar 2026 17:16:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-raid@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Russell King <linux@armlinux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 0/5] xor/arm: Replace vectorized version with
 intrinsics
Message-ID: <20260331151653.GA8011@lst.de>
References: <20260331074940.55502-7-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331074940.55502-7-ardb+git@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I think some of the intrinsics patches were also in your crc64 series,
so I'm not sure how to be merge this.

