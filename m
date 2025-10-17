Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05D62BEC5E;
	Fri, 17 Oct 2025 22:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760739043; cv=none; b=HKV8XYA2A7cDu6sLt3G5xLqHLgebDkz+SvvrSTYVAOSr/O2LPjDZuzFFxP9+J6FZe8/kPAFPGDH6HBYJqtbijCfYFmFPZLDpJnbVmxqldn9iUkClxLWgUIXuZunUCu0m08M8uVWDI+1JOuaEBfFFJsCW7lWCfc+JjGB5TnvxRrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760739043; c=relaxed/simple;
	bh=EEsZGRbAPEeFOFZf1zr44Anq0yETmx+SNImVAINwq8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q8pGBO8TL/bq9XMaF+uv0juJN3FEF9u6NsvsETj+WXFcTarzz5NKvKzs68OFn69o3GdU+xXZcD+nXJ9d6Z4tjUJwt58WjnpdtLK6HCLQhwauPPrp3m1hNiMeDD+6EMF6QDUjh/0MeH5t0TvZJudhcj9NQq+eRii41zISB1Hjsbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=gV3JvCJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gV3JvCJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A629C4CEE7;
	Fri, 17 Oct 2025 22:10:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="gV3JvCJP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1760739038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KYxrKJmqrlF5+oXJtNZxXyzrFuUCGdcIV9hIKRkfibI=;
	b=gV3JvCJPrdxpQPhIFynu21AXaps8an+hE6VpSAj0ZBKrf2R+6AkeNj+rH/LAxH3g5oQx6N
	KZTV9eaDQ6XezVNOle3djGdoyT16wpzyZMvhlg8jlTUXAIIxSUs/pC4iKrErdvkaIiOs0m
	XVvwKLZYJYO3yJWVhOKCl2HgGYY5r0c=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e56e64a5 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Fri, 17 Oct 2025 22:10:38 +0000 (UTC)
Date: Sat, 18 Oct 2025 00:10:34 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Gregory Price <gourry@gourry.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	hpa@zytor.com, peterz@infradead.org, mario.limonciello@amd.com,
	riel@surriel.com, yazen.ghannam@amd.com, me@mixaill.net,
	kai.huang@intel.com, sandipan.das@amd.com, darwi@linutronix.de,
	stable@kernel.org, linux-crypto@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH] x86/amd: Disable RDSEED on AMD Zen5 Turin because of an
 error.
Message-ID: <aPK-2iYHnt8DYFAF@zx2c4.com>
References: <20251016182107.3496116-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251016182107.3496116-1-gourry@gourry.net>

On Thu, Oct 16, 2025 at 02:21:07PM -0400, Gregory Price wrote:
> Under unknown architectural conditions, Zen5 chips running rdseed
> can produce (val=0,CF=1) as a "random" result over 10% of the time
> (when rdseed is successful).  CF=1 indicates success, while val=0
> is typically only produced when rdseed fails (CF=0).
> 
> This suggests there is an architectural issue which causes rdseed
> to misclassify a failure as a success under unknown conditions.
> 
> This was reproduced reliably by launching 2-threads per available
> core, 1-thread per for hamming on RDSEED, and 1-thread per core
> collectively eating and hammering on ~90% of memory.
> 
> Fix was modeled after a different RDSEED issue in Zen2 Cyan Skillfish.

Yikes. I suppose we should get some more info from AMD, so that they can
really figure out what's affected and why and such. In the meanwhile,
maybe it makes sense to disable a broad set of Zen 5 subfamilies? From a
random.c perspective, it'll use RDRAND instead, which appears to be
unaffected according to your report.

(Though, how could you tell if it was affected? RDRAND runs everything
 through its internal DRBG, so if part of the key that it uses is made of
 fixed zeros, we probably wouldn't notice. AMD really needs to look into
 this.)

Impact-wise on random.c, assuming the most pessimistic conditions -- no
other entropy source being used other than RDSEED, which is never
actually the case but good for analysis here -- the first usage of
getrandom() will use 512 bits (random_init_early()) + 256 bits
(extract_entropy()) = 768 bits of RDSEED output, so assuming your 10%
failure rate, that's still 688 bits, which is roughly 2.69x as much as
we really "need" anyway. So I suspect overkill engineering is saving us
a bit here, and there's not any security impact to random.c.

Users who don't use getrandom() and try to use RDSEED directly might be
in a different situation, however. Don't do this. Just use getrandom().

Jason
