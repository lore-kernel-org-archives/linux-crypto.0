Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BB81C84AE
	for <linux-crypto@vger.kernel.org>; Fri, 25 Apr 2025 03:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745553543; cv=none; b=I9SAj/lbsHbtApRY6aRkKuE71y+4SLffFtTp/GGiFa1AjBK2IZAAL9Wo+8n7q5qQF0qROE8cdvwNgM+riEZ5OqJKkDzUq1QDwCOc6HaskTvpl8yDHdkcAEJR7FrvnVPjKvX1QZ/LG9EidthB04UM/+6Rn+pHJIzHBGHHKHkCGwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745553543; c=relaxed/simple;
	bh=j7BRX9eg4BW1UpoFaQHZxznhD7KmPlsu0cARzsupBCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mHCTbBaFOs1UBaa2tkcpNUeShTILYl0ZXbOFVVkIZUZpix7SKjeJpv/YwvuOtsxGScgBSa+e1rYwWUKBG+xrWdPjVeFL73d4YnbAl0XOMy1Jp9IYTXaHol5fFljmPdeTdc1+uO5cqpHSOpNGXEAiH4uiC1KjeKARUXaIiaffMGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M4zgARnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M4zgARnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15890C4CEE8;
	Fri, 25 Apr 2025 03:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745553543;
	bh=j7BRX9eg4BW1UpoFaQHZxznhD7KmPlsu0cARzsupBCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M4zgARnBwLcShW9HvPE3IqP83PzvmVuDd3CU4tVq9CQr3BVwGHnccgtk6HRo0UFtp
	 sBraiReoFEshzTQgBJbUb7vWeJEfDVTYyNyMCuk2StQduKeHUsXC7rYYnyxRaKoe1R
	 G4q0TKrSnsAPQf44nNt3Tdb2VV/DB20mXbLcRsacFzOGLHciwLSVVXOX6LzLgwvXeQ
	 pdW3jKOqWo3LfLt55w3RVsumbXgOA/IqL2Nr+xRstwnJ/nByWAtcfHEHVO9nkfeSgh
	 HMiv57wlfqjRlsQsQu7d8dLqmYunxK01miTi1eyvSCUxYbK5M0nPRkKKNcpCCBLGnQ
	 5Pt0FniTNxm4Q==
Date: Thu, 24 Apr 2025 20:59:01 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 08/15] crypto: poly1305 - Use API partial block handling
Message-ID: <20250425035901.GH2427@sol.localdomain>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
 <20c70ad952dc0893294f490a1e31c9cfe90812a9.1745490652.git.herbert@gondor.apana.org.au>
 <20250424153647.GA2427@sol.localdomain>
 <aAsErcJZ_FeJ7YEg@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAsErcJZ_FeJ7YEg@gondor.apana.org.au>

On Fri, Apr 25, 2025 at 11:42:37AM +0800, Herbert Xu wrote:
> On Thu, Apr 24, 2025 at 08:36:47AM -0700, Eric Biggers wrote:
> >
> > So now users randomly need to "clone" the tfm for each request.  Which is easy
> > to forget to do (causing key reuse), and also requires a memory allocation.
> 
> It appears that we have exactly one user of the Crypto API poly1305
> other than IPsec, and that is bcachefs.  But yes I forgot to convert
> it to the new interface.  It should just use the library interface
> since it doesn't support any other keyed algorithms so there is zero
> point in the abstraction.

I already did that.  See commit 4bf4b5046de0 in mainline.

- Eric
