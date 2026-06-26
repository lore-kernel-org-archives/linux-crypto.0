Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4ED3CAA30;
	Fri, 26 Jun 2026 05:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782452872; cv=none; b=V0I30QXBlpQrepoXsyBldSaJCg/SQNBr17bJLE/tX4oay7X7kidOMduvUkCJZ2mMSn7orluLlomJLVlW9CP4zzMzf1YlDuMARl3aBaweQcXMdxjnzLATDnN2urImDHHx/eyZnFRrilMNt3T1S+VCfilzV2jcManNFfc/HOQJ/b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782452872; c=relaxed/simple;
	bh=v/QsVU3J4c524p/jn1Furnq9EctvTT7/41/f9atcJME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qcb3rfBa2TUExJyucN1c05u7o9BvAMzQ/oLfd3K3Ne9J+95PEOlfYxzkadj+ImRDRWOQQeQfrwfWRKBs+JijcwMxzdmV+Y38nfTYMXrI3gNUnXjnUtmyVrgyprzAhPbJC6sX6/opJmwrwFsyeWWExbDFp/TksCCFpjEW3G/Pcn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4496268B05; Fri, 26 Jun 2026 07:47:49 +0200 (CEST)
Date: Fri, 26 Jun 2026 07:47:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>
Subject: Re: [PATCH 8/8] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Message-ID: <20260626054749.GD9629@lst.de>
References: <20260626043731.319287-1-ebiggers@kernel.org> <20260626043731.319287-9-ebiggers@kernel.org> <20260626054731.GC9629@lst.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626054731.GC9629@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 26, 2026 at 07:47:31AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 25, 2026 at 09:37:31PM -0700, Eric Biggers wrote:
> > +	if (IS_ENABLED(CONFIG_X86_64) && boot_cpu_has(X86_FEATURE_AVX512F) &&
> > +	    !boot_cpu_has(X86_FEATURE_PREFER_YMM)) {
> > +		/* AVX-512 will be the best; no need to try others. */
> > +		/* !PREFER_YMM excludes CPUs with overly-eager downclocking. */
> 
> Can you turn this into a single block comment using full sentences?
> Right now the two separate comments almost feel contradictory even
> if I get what you mean.  While you're at it also through in a blurb
> why we dont bother with AVX-512 (number of register, no one in the right
> mind would bother running high performance code on modern cpus in 32-bit
> mode).

Otherwise looks good, btw:

Reviewed-by: Christoph Hellwig <hch@lst.de>
