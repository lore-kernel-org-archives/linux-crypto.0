Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CDF36B05D;
	Fri,  6 Mar 2026 05:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772776545; cv=none; b=UyOejsl6ZG0aoXtGbWA7UH4Dql2NBLoJl/GKg/GCKJsplWlf4DmrZasWEZ9JyIocBSj/FU/5rE3slVT+GOZHePNRxJS2RurF8pSkrmbsCppSK3h3/rUMoNoP65+omkW7uOKbJViOuuR4eDBcXMLuidOEJFu78inNkEzwbU22zSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772776545; c=relaxed/simple;
	bh=u9n47FJlOV4YmotAXSe6JiDOvgFEjn3GBPGgBNYT3eo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gZOhtIQWHGXK4TMRhWeID+ysKxcJ2j9rNp2xo/FN58ECEQEHo/01qZfKy61Tq5y8SJr+l0eA1rQmAgkfCXij/ZtBpanawSOmSbyVPjhzo1Q6OUHkZKnlHkVUyYUHOWQFy6rnyOqFeci4uorkGM3b/11XyPl566Lx3uPTWgxjaJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bK1nUrOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bK1nUrOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45F5C4CEF7;
	Fri,  6 Mar 2026 05:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772776545;
	bh=u9n47FJlOV4YmotAXSe6JiDOvgFEjn3GBPGgBNYT3eo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bK1nUrOQVjiI+eAqKuqGQtkV5FTbGa0MoWrSh8bJ6NQBvN12mXKDqDzT+LJdI3wKQ
	 MYYS/LOvXL5PI7x48iNAO8leOoyVCMZd2D0wX1Z6CC9cn6hzq2QEdK/mnjdPoi8rzb
	 zaBO+boiRq93THg2TPj707RaoI4aWEYiScfmxRGLKgFZOgWoczZ9S8jn/UEQE2J6OS
	 wbrmtSDBUNwBQP1tJ68IcGsEpzUTFDR50lAKXZqJtayIU8gWdBT4T8v7Fedl6EFwRz
	 RNJRcx1vBDpNqrLWu0d2bTaxlaWC4ApmYjmMm53i7dpI2Yn3FuD4T7DzpxFHlGe/JT
	 rZzccBL2ZN5iw==
Date: Thu, 5 Mar 2026 21:54:48 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Cheng-Yang Chou <yphbchou0911@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	catalin.marinas@arm.com, will@kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, jserv@ccns.ncku.edu.tw
Subject: Re: [PATCH 1/1] crypto: arm64/aes-neonbs - Move key expansion off
 the stack
Message-ID: <20260306055448.GA304682@sol>
References: <20260305183229.150599-1-yphbchou0911@gmail.com>
 <20260305183229.150599-2-yphbchou0911@gmail.com>
 <20260305193847.GG2796@quark>
 <aapqOeRMJDmYc4lc@eric-acer>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aapqOeRMJDmYc4lc@eric-acer>

On Fri, Mar 06, 2026 at 01:46:33PM +0800, Cheng-Yang Chou wrote:
> Hi Eric,
> 
> On Thu, Mar 05, 2026 at 11:38:47AM -0800, Eric Biggers wrote:
> > Instead of memzero_explicit() followed by kfree(), just use
> > kfree_sensitive().
> > 
> > Also, single patches should not have a cover letter.  Just send a single
> > patch email with all the details in the patch itself.
> > 
> > As for the actual change, I guess it's okay for now.  Ideally we'd
> > refactor the aes-bs key preparation to not need temporary space.
> 
> Thanks for the feedback.
> I'll send a v2 to address your comments.
> 
> The arm implementation also allocates struct crypto_aes_ctx on the
> stack in aesbs_setkey(). Should I include a fix for it as well?
> Note that I can only test on arm64.
> 
> Also, I'd be happy to help with the refactoring if you can point me
> in the right direction.

arm doesn't store the kernel-mode NEON context on the stack, so a
similar change shouldn't be needed there.  This issue showed up only
because arm64 started doing that, which made the stack memory used by
aesbs_setkey() exceed ~1000 bytes due to the crypto_aes_ctx and the
kernel-mode NEON context each using about 500.

- Eric
