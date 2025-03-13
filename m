Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C96CAD5E
	for <linux-crypto@vger.kernel.org>; Thu, 13 Mar 2025 02:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741833411; cv=none; b=ayQ6WtxW1Hi4bFb+q6ojra/pjGOjuCgGdwXyMSAZWRmVosv4VJhKgLJQHYB1xJ9nQyEKc8aayjognUZHSYs12Q3MpsxlWxbr7WN/AHH+ezIS+/Hj5YulqQ6t3XoKiZciGudMriRfCxvmLlHrJhVEQ+JTxOtOmOtLGhGQmxoKvcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741833411; c=relaxed/simple;
	bh=ouacnWA5VBamxVK5em6+a5Q/eQybvwomLja576vBzIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XPCMi83AnIEZFYRuDq+M3gr9vPPPTBrrUI3k3sn0P47rjQCiI2F0mk3vFTtTttqms+kVQ3ph3xiIW9VvJ2zn1C+kiezamDkHqq4MRxINGV+PrGIdyjvQkSouDd8xabzp8sRsyYk9h7d2u1twga1adFts4t2UNOMoBsyxhv103TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jM9qF9+2; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jM9qF9+2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oFo9xZUTT8PXodOUCWowctknOvkLrFhmhdLjUvYBRLg=; b=jM9qF9+24XaetwMTMxb0s+G701
	TtgXZ09ExeGlf1WOHtdOl3atm9celxkKGZygTGXQuaM1pOiCFl9Fl4lvW8r9lWXt2ffGo6sLBVSKn
	WShC7p+6R9WTEO8bhDksN2P4ei3bM86HtKTHEygx2s0o+t2XwG+GJSqoxdliGzM+NI/zhu4R4c5oy
	5I0GVZ+euWEZbgkuKHwtFcM39TOKaRDO26b8Znv7weBraeWmdsYUK/BFObDJTDQfCe4XZMCPOXkVP
	rgsZMXPOutIL0OGhVhJDF1Ugf3ZzctcwP8gWOKoCkxp22WXpwhZEbFMeLMmyOw3Z+FF/Y4dheFPxH
	48AOXmFQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tsYRA-0067AF-1L;
	Thu, 13 Mar 2025 10:36:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Mar 2025 10:36:44 +0800
Date: Thu, 13 Mar 2025 10:36:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 2/2] crypto: hash - Use nth_page instead of doing it
 by hand
Message-ID: <Z9JEvCT-3Q6BUnOt@gondor.apana.org.au>
References: <cover.1741753576.git.herbert@gondor.apana.org.au>
 <a68366725ab6130fea3a5e3257e92c8109b7f86a.1741753576.git.herbert@gondor.apana.org.au>
 <20250312200908.GB1621@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312200908.GB1621@sol.localdomain>

On Wed, Mar 12, 2025 at 01:09:08PM -0700, Eric Biggers wrote:
>
> It seems that the "real bug" mentioned above is the case of
> scatterlist::offset > PAGE_SIZE.  That's unrelated to the nth_page() fix, which
> seems to be for scatterlist elements that span physical memory sections.  Also,

Alright I'll try to split it up.

> Note that there is also page arithmetic being done in scatterwalk_done_dst() and
> scomp_acomp_comp_decomp().  Those presumably need the nth_page() fix too.

Thanks, I had missed the flushing code in scatterwalk.

As for scomp yes that's already fixed in my acomp series which I
will repost soon.

> scomp_acomp_comp_decomp() also assumes that if the first page in a given
> scatterlist element is lowmem, then any additional pages are lowmem too.  That

Yes I've fixed that by changing it to test the last page rather than
the first, assuming that highmem indeed comes after lowmem.

> sounds like another potentially wrong assumption.  Can scatterlist elements span
> memory zones?  Or just physical memory sections?

Theoretically it can cross anything.  Check out the block merging
code in __blk_rq_map_sg, it tries to merge any physically contiguous
page.

> Is there actually going to be a clear specification of the scatterlist based
> crypto APIs, or just random broken and incomplete fixes?

Have you considered working in the mm subsystem? :)

But yes folios seem to be a lot nicer than a scatterlist.  At
least it's guaranteed to not cross any boundaries and is always
a power of 2.

So I've added folio support to acomp and I'll be doing the same
to the other interfaces.

Of course folios don't support the kind of non-linear memory used
in sk_buff so we'll still need scatterlists for that.
 
> This is clearly untested, so not much point in reviewing it.

Thanks for catching this.  I hadn't noticed Linus turning off
-Wmaybe-uninitialized.  For all this time I'd been thinking that
gcc has suddenly got a lot smarter.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
