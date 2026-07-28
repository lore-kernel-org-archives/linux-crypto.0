Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C57D373BF3;
	Tue, 28 Jul 2026 03:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785210290; cv=none; b=JEz26XpZuArMTnyBp5C4mhmUobeA1xoK3u+LS3O76jR7ZMBWT7zlzLLx3E3Dgu0atBVn98N1iCt9frxYK7Ejd1B9Ezf8g3dZ3Ism7bDdVEyahnhEsRs7UB4aHxzgR5oeYOqvwOury1+LenOAIkcCvcNdWRvCnHFnGwwQ6Yuwo3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785210290; c=relaxed/simple;
	bh=hhgRhGArrVtTP2LqGzn/+hkznDNMa8RwY/fTzBi4mWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HqFb+AaI+PWIJrDFJgqRPLN8AoL9MUhrRoNxJjStj2QS2qXyHaZzT7gFcfIhBIBiIRMPMgj5J/NAHtY2lAbEqUi/7tuApcImjfEIT6SYKWOeolMXJZdhMdNgmTWKGB3pxJhA50dlsEgvCKhS7ZNtGbRnQJ2vGnqfWHhKpmv/SHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5704F68AFE; Tue, 28 Jul 2026 05:44:46 +0200 (CEST)
Date: Tue, 28 Jul 2026 05:44:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 0/8] x86: Remove cpu_has_xfeatures() and add AVX-512
 xor_gen()
Message-ID: <20260728034445.GF18902@lst.de>
References: <20260728021603.79870-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728021603.79870-1-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

The whole approach looks nice from the user POV:

Acked-by: Christoph Hellwig <hch@lst.de>

I'll leave it to the x86 experts to make sure nothing is missed in
the nitty gritty details.

