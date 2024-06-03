Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56634F9E9;
	Mon,  3 Jun 2024 18:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440604; cv=none; b=QGklGZvmlhMJ8FBjUhOXlvhhzHQCwxQoWkNYTQ57taqOkSE+N+ruA/u83Qa+8g0ydgIUPP2RLV5KWWV90CrFbFkHjPPUxMF1TkCvk8XJGB3XnypjlwRXOe+n0z0x7ckbNwPUI8eH5dQPGL+Zk4xhT1zHb/KZOFHMdhAX+3D7XDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440604; c=relaxed/simple;
	bh=tAoh6E2HyT2I7zRPieUiEXpLsGE3VAG7l4WoETX8/KA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PcF/DwL1cu0WSPNNqhtcBvuomYIs5+vcJOK8eLAfHstBmeK3nye7MoNJMgfzjidVWBJUYFdIB3YKke5NE66C8YccO0VYML5nXXABbmfs5RR7i+T/1hx/LYbZLHQNGVVRZcwyqKzw+5epQ+VlBLCRQCas7LINxCWJNqcAQFWXbng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GEf/jxEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GEf/jxEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF99DC2BD10;
	Mon,  3 Jun 2024 18:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440604;
	bh=tAoh6E2HyT2I7zRPieUiEXpLsGE3VAG7l4WoETX8/KA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GEf/jxEHtJGXB7kScrOu7h0DjjNeWIg9lmhillOkUjsewEoDtkkXOBYTxIubLXC0D
	 AF4raCk7yLDQsjaEiVt9L4jATQZdkgU4JttVpSxom5jc+RhW+ziwtinDv6R8RdlHfV
	 2aq5gfLjxWyk1YHIbAwIGdaZo9nVrrLnghqYrrhZV1LMVmHyB1umUBQI+ZgnubF8Kd
	 3KpP1RkPnIGdxnhu8CnsDUw7RZmxAFd6pHxvh6XERMEtX/eCfJDWXm7RlHjS4oYoai
	 JflohoHAJ9g5V2MQ1cx1bAp9uDtUvT/iiJL/ne32mD6T06oKQfIC+1n85wD8kDzzHu
	 1ndEUQNWLyvTA==
Date: Mon, 3 Jun 2024 11:50:02 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, ardb@kernel.org,
	samitolvanen@google.com, bvanassche@acm.org
Subject: Re: [PATCH v3 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <20240603185002.GA35358@sol.localdomain>
References: <20240507002343.239552-7-ebiggers@kernel.org>
 <ZllXDOJKW2pHWBTz@gondor.apana.org.au>
 <20240531061348.GG6505@sol.localdomain>
 <20240531065258.GH6505@sol.localdomain>
 <ZlmPGEt68OyAfuWo@gondor.apana.org.au>
 <20240531185126.GA1153@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531185126.GA1153@sol.localdomain>

On Fri, May 31, 2024 at 11:51:26AM -0700, Eric Biggers wrote:
> On Fri, May 31, 2024 at 04:49:28PM +0800, Herbert Xu wrote:
> > On Thu, May 30, 2024 at 11:52:58PM -0700, Eric Biggers wrote:
> > >
> > > Looking at it again a bit more closely, both fsverity and dm-verity have
> > > per-block information that they need to keep track of in the queue in addition
> > > to the data buffers and hashes: the block number, and in dm-verity's case also a
> > > bvec_iter pointing to that block.
> > 
> > Again I'm not asking you to make this API asynchronous at all.
> 
> What exactly are you suggesting, then?  It seems that you want multibuffer
> hashing to be supported by the existing ahash API.  However, that only works if
> it's made asynchronous, given how the messages would have to be queued up on a
> global queue.  That has a huge number of issues which I've already explained.
> (And it was even tried before, and it failed.)
> 
> > I was just commenting on the added complexity in fsverify due to
> > the use of the linear shash API instead of the page-based ahash API.
> 
> It's the other way around.  The shash version is much simpler.  Just look at the
> diff of commit 8fcd94add6c5 that changed from ahash to shash:
> 
>     4 files changed, 71 insertions(+), 200 deletions(-)
> 
> > This complexity was then compounded by the multi-buffer support.
> 
> fsverity and dm-verity will have to be updated to use multibuffer hashing
> anyway, given that transparently supporting it in the existing API is not
> viable.  If your concern is that in my current patchset fsverity and dm-verity
> have separate code paths for multibuffer vs. single-buffer, as I mentioned I can
> address that by restructuring them to operate on arrays (similar to what I
> already did with the crypto API part).
> 
> > I think this would look a lot simpler if it moved back to ahash.
> > 
> > The original commit mentioned that ahash was bad for fsverify
> > because of vmalloc.  But the only use of linear pointers in fsverify
> > seems to be from kmalloc.  Where is the vmalloc coming from?
> 
> XFS is working on adding support for fsverity, and XFS was planning to provide
> their Merkle tree blocks in vmalloced buffers.  Their plans have shifted several
> times, and I think their latest plan no longer uses vmalloced buffers.  But in
> any case it's still very convenient and much simpler to be able to just use
> virtual addresses without having to worry about what type of memory it is.
> 

I've now unified the code paths for single-block and multi-block processing in
fsverity and dm-verity, which I think addresses your remaining concern that's
feasible to address.  Your feedback has been conflating different issues, and it
only comes in once every few weeks, so it's a bit hard to follow.  But I think
the remaining thing that you're asking for is to make the API to be part of
"ahash" and use the existing async completion callback.  That's not actually
feasible, for the reasons that I've explained in detail.  See in particular
https://lore.kernel.org/linux-crypto/20240503152810.GA1132@sol.localdomain/.

Thanks,

- Eric
