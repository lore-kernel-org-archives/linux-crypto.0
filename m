Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E6E440C;
	Wed, 26 Mar 2025 03:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742960046; cv=none; b=VmtiAKT7NY9aproZJcNQ0APTFqYOkfmK+LcvThPT/XXHNqWyAWr/aStP36WebJhTBtuNA1rgsjwD6ctUhxQjdO+DcgGYT8VR2itXhwGqTvtyl5FTRfSdBUGESnVQks4BDAdTH9Xz7KszApFVrZvTKx67bB+799VQ9266I2aXwqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742960046; c=relaxed/simple;
	bh=lHJCSYi8Awi2VZ4AGZ36vH8nXN6Bptp+8jJllW5gEcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nIRPK9EJ2vqMyqkGuGUnOZ97k+mEY0+I2Itgwv0kJ4Fi6JD3UrFXOePK6GngKTKHgx8BAD8kPi5YzG70swDvNphkxGzfaoKJunWEL4gKOcyIu7lEOCsyZSZGZtjTx+WhblFZVhH2ryW3O390QmPfha0KS/Ha+Nv927Q/RH2cPJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eItc9XJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eItc9XJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8F2C4CEE2;
	Wed, 26 Mar 2025 03:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742960045;
	bh=lHJCSYi8Awi2VZ4AGZ36vH8nXN6Bptp+8jJllW5gEcE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eItc9XJkgl+A0WliyNF0L6ICYlZAYdm9C4JSeExrCqOfM5Kv4TdBkOMHLhCziqiAI
	 LmDN5CLX6UgjXOXqsFeVmldEpK6gNBeAPUctCGKmgsNol8cQ6WYZpDewxc4PSdFb09
	 MpiZTURSuVkWd060bUshDIWZGc9ceqLVbpjMFw8HCT3Jv30h69Q2L4YU9Wjqa6hVIt
	 UyAhqYQBIHhe/Zrd/+x9FfMlxva/08LrGInORKKMNemYs9SI3CRPY3GaGXi4V2bH4I
	 CA+du+tl8N99z+ct+QsiCSnIrO+zBp4GuwmGXB6HlsQl4B5Q0vJOVBSo/jGMTtSiup
	 c83NtcXpTeGGQ==
Date: Tue, 25 Mar 2025 20:34:04 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [GIT PULL] Crypto Update for 6.15
Message-ID: <20250326033404.GD1661@sol.localdomain>
References: <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
 <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
 <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
 <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
 <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
 <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
 <20250325152541.GA1661@sol.localdomain>
 <Z-NdGvErMGS5OT7X@gondor.apana.org.au>
 <Z-NjarWmWSmQ97K0@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-NjarWmWSmQ97K0@gondor.apana.org.au>

On Wed, Mar 26, 2025 at 10:16:10AM +0800, Herbert Xu wrote:
> On Wed, Mar 26, 2025 at 09:49:14AM +0800, Herbert Xu wrote:
> >
> > Let's see how your version is so much better:
> > 
> > https://lore.kernel.org/all/20250212154718.44255-6-ebiggers@kernel.org/
> 
> BTW, I absolutely hate how the fs/block layer uses work queues
> for everything.  It's been used as an argument for async being
> unnecessary because you can always wait for completion since
> you're in a work queue.
> 
> But this is exactly the wrong way to do asynchronous completion.
> In fact, now that async support has been removed because of
> religious opposition to ahash, we now end up with the worst of
> both worlds where hashing is punted off to a work queue where
> it is simply executed on the CPU:
> 
> /**
>  * fsverity_enqueue_verify_work() - enqueue work on the fs-verity workqueue
>  * @work: the work to enqueue
>  *
>  * Enqueue verification work for asynchronous processing.
>  */
> void fsverity_enqueue_verify_work(struct work_struct *work)
> {
>         queue_work(fsverity_read_workqueue, work);
> }
> 
> The correct way to do async offload is to do it conditionally:
> 
> 	ret = submit_request(rq);
> 	if (unlikely(needs_async(ret))) {
> 		allocate for async path with fallback to sync
> 		processing in case of OOM
> 		return;
> 	}
> 
> 	execute normal synchronous path
> 

In the general case, the workqueue is needed anyway because the work can block
(e.g. to read Merkle tree blocks) or can take longer than should be spent in
softirq context.  But in many cases the workqueue is indeed overkill and hurts
I/O performance.  For that reason, dm-verity and dm-crypt already support doing
the read completion work in softirq context in some cases.  It's not enabled by
default though, and isn't implemented in quite the way it should be.  Several
people, including me, have been looking into improving that.

So I think your observation about the workqueue being unhelpful is generally
correct, but fixing that is already partially implemented and is being worked on
further.  And regardless, this does not have that much relevance to the crypto
API.  Yes, you can't sleep from a softirq, which means you can't wait for an
async crypto request to complete (other than polling).  So if you want to do
that, you have to go down the workqueue code path.  But in practice 99% of users
are just using the CPU-based crypto that is synchronous and does not block.

- Eric
