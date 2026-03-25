Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB543290B7;
	Wed, 25 Mar 2026 21:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774472992; cv=none; b=PcC+KDrdyHoiGsblmIt6NfyncJ/GqxQ1Gknn+JKQhyia9LKP21UZ9Op6rF84ilszIW9Jo5wcw7Hku0Td23uqj5Tv+MEoRIj5/JwdyLKxrCZMOnjz5Hi+NPTov3Szg/MtyMouwn3lCNVjJhyft21nHhRPSS9Fw14tJCTtg6B9qiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774472992; c=relaxed/simple;
	bh=5hyCtszn78xanL3/NAItzF/R51/fZ06Mwx7h3Z1IvlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HBxDEyZd41ft6bRS19z7b3Dz/qfWEPOkslaTdFle0eruL6W79oHhdgWqvZrOGsOnU37JoQK/Dz0fda+rpYXhibBCJt0ZhAUuvRfMGlNzg2pp/4xKlxwsaCLXvrnV775P27dZ3EiLFnDhau2sql4lAu+g7UiuKtRuutDcHTew5yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XUCQnJyo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XUCQnJyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF5EC4CEF7;
	Wed, 25 Mar 2026 21:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774472992;
	bh=5hyCtszn78xanL3/NAItzF/R51/fZ06Mwx7h3Z1IvlI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XUCQnJyoZhUt4VnYhJ8veC05VFp9zs8kQa2c1wzAm+I/r95r3fOHJjFJ4QrUOV+OQ
	 AJ1GEXBIMy+vi2BNW+A6QL88gNMmZwyUbeMdGRxRRQK/HrYhQfWtVJNuSS9Hsi/Bcv
	 IKKZgLI1Vc4vYdzJMjHRVORuUGxWgKWgui6QHgfJJBzajti9HYugpYs6z4JZvhiwEJ
	 n147CnMBhQ/ZvfuD+1sanPvpEAu6W8C4LHAR6OW/V3AySeF4HL07UY6SPLI8vRt7bL
	 1ub7P0dQqq+IQ4SfMby6Tkl5HkIQt3zSulWcOLMgpoR2Ni9c+knm4kCWKjNsP1cgjy
	 2pMe06tzHVsVg==
Date: Wed, 25 Mar 2026 15:09:49 -0600
From: Keith Busch <kbusch@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 00/21] nvme-auth: use crypto library for HMAC and hashing
Message-ID: <acRPHRZs_hZYDj4O@kbusch-mbp>
References: <20260302075959.338638-1-ebiggers@kernel.org>
 <20260304132327.GA15515@lst.de>
 <20260305193150.GF2796@quark>
 <aanbGwda2pHmMTMx@kbusch-mbp>
 <20260325202053.GE2305@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325202053.GE2305@quark>

On Wed, Mar 25, 2026 at 01:20:53PM -0700, Eric Biggers wrote:
> 
> This hasn't made its way into linux-next yet.  Is that expected?

It's in the nvme-7.1 branch, but linux-next doesn't pull from there.
I'll need to send a pull to Jens' block tree for linux-next inclusion. I
suppose it's about time we get the first one sent this week, so I'll
just double check everything and get something ready for tomorrow.
