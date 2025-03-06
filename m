Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617F74A1D
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 03:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741232220; cv=none; b=QH7Jt48LEsP/ohP0lNqYlh03oumFxbSYve5I45kS2QI2r3048GwqlBQllRntreSqkv8XR2Uj36os9d8uJbfU2zxieGNHikMcWjuQ2ySbucMRYwokQIhOk5vvwEOMfAQYZOOw/Pea3D8gU5SsH236Tw4CuDuYmqBUWzjm+6Dn8Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741232220; c=relaxed/simple;
	bh=N2X3322JrBtCTUzZoZYfuo1GOpZcBXVTpnKkjNASp3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C2G44NvuDQEHKY/UazxWDUXZjJjXzEhPvIGE6dCT85rs8wsbif6aoLWLr5fiRLVK0c0WsmQjdGdQSgjaoZwG4kPi3fq18XdOsM7UFVIP+/2QeVjgFp1z6qEM9Yt3RtI89yUlHTMbPDTj2or+1WNaKJPicKk7G8gpUaj3ovIn4Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K7iARpQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K7iARpQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3DAC4CED1;
	Thu,  6 Mar 2025 03:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741232219;
	bh=N2X3322JrBtCTUzZoZYfuo1GOpZcBXVTpnKkjNASp3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K7iARpQH3GYok6ryC1EH5bAD1QyfDLJOkS7obwnVET+ab3CgYf0CEkQkNCSPwXZsz
	 byJN8FYssI5dURmgH/e18ven8JiH1w1pK1tbtdxB/q0zNJ/QD9p9xvOVhWV7YRcJzE
	 kq/ZuZEl3MAkjfCi82RVTrTC8MJ0qFFLbp8oPLZAS3uNtg2IRVuzqsmWyJLGjDXYe2
	 mdr47EiFDrqJYcLPcpeekHFk3rxCyvo3CXN4XCNeqxj9qJVAhngJbcz1QuF9XhLG1p
	 BUKlSwTlH3OwRidKG73FAU93NPc08hRqaB8Xvk2hsonqh2j2gNCEXDNSuSfRJ1MLPo
	 GoGrDXOkfCepA==
Date: Wed, 5 Mar 2025 19:36:58 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: scatterwalk - Change scatterwalk_next calling
 convention
Message-ID: <20250306033658.GD1592@sol.localdomain>
References: <Z8kOABHrceBW7EiK@gondor.apana.org.au>
 <20250306031005.GB1592@sol.localdomain>
 <Z8kT90qXaTo15271@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8kT90qXaTo15271@gondor.apana.org.au>

On Thu, Mar 06, 2025 at 11:18:15AM +0800, Herbert Xu wrote:
> 
> Do you have a usage scenario where this struct is embedded into
> something bigger and bloat is a real concern?

That's exactly what happens to struct skcipher_walk.  This patch adds two
redundant pointers to it.  Yes it's allocated on the stack, but it's still not a
great result.

- Eric
