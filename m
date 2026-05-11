Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144863CFF4A;
	Mon, 11 May 2026 16:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778518372; cv=none; b=CFid3iQ3Cpd75yzXQP+VwuOHtSKlZbMvHPlrOHYbSIjHqg/rQFx/ZoUASf2y0KZKziBdidUh5UndFsWUUFBl70XX2QFnI0WJV51yP/m5u1q5KP0bjF38bFTbyPqRbXguSj5cdEk6/h5beaEN3qOBXjPCL+z75GMMG5Kd6XGCThA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778518372; c=relaxed/simple;
	bh=bGQru4i8iuqLtZIcNQ+A51kfAX9HGCq5YIWwHJ+csxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OsJXW198ylDgKIfAbLZA+7Nd7TNgS3Jed9K1SRrg04SKp/0vghvCHKBr1lKB6tog1W2BcjdEnKJLcAmVtyZpUxFKTdeo9C9rncjxhvVGP8KSFaC0pH9ANJO4brwz+wbOapebFBDC1wKxOdtEZHleF7s1jiQL4as5OKv2ee+MdAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L4lXNyvu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L4lXNyvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4CFC2BCB0;
	Mon, 11 May 2026 16:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778518371;
	bh=bGQru4i8iuqLtZIcNQ+A51kfAX9HGCq5YIWwHJ+csxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L4lXNyvub6RvjsgfxnaOqDAteL2G4qSJ4+vBNArQgTjSiKxOLt8tRPKf9RYklVTsc
	 glapEI4zYAFg0HecVL+oGeHM/1Byn/t2TU9Kuo3cCfaXscEFn+Ogv8yEzauUewalrH
	 rzG2bXaf/dS3b7HrH549Bbt3fyoMLmoiPSfOfCOW45zclNxqyVqhX2RigdqLSCD3RF
	 oV64w/0Deg7glJN99rZa/CtG75lXvwTAe42BLiNBe5sNgx1M7Q5g59YpI+xJIhEY+Y
	 QzbEUATVFUTLzLlZ0/8yKGCbnLzxXPu7ejWho3Q221pvv03eWNxkDpAfDQO9qhKyIx
	 Qv2bG30P+xPbg==
Date: Mon, 11 May 2026 10:52:48 -0600
From: Tycho Andersen <tycho@kernel.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: ashish.kalra@amd.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, aik@amd.com, nikunj@amd.com, michael.roth@amd.com
Subject: Re: [RFC v2] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
Message-ID: <agIJOXYubt382Jbo@tycho.pizza>
References: <20260501152051.17469-1-prsampat@amd.com>
 <afitM-Ub50JsTCHz@tycho.pizza>
 <673592c4-8eca-4b84-9f60-7020327d1afd@amd.com>
 <agHl3ow90IdKTS72@tycho.pizza>
 <a15e8eaf-c0fd-44ea-ac5d-9a6bc8b97312@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a15e8eaf-c0fd-44ea-ac5d-9a6bc8b97312@amd.com>

On Mon, May 11, 2026 at 12:21:35PM -0400, Pratik R. Sampat wrote:
> I am not keen on caching the result either though. For simplicity, we could just
> drop the failed_status interface, log failure_status with pr_[err|warn](), and
> return -EIO?

Yeah, that sounds reasonable to me.

> > The spec is a bit messy here, though. Table 131 mentions a
> > MIT_REQ_CHECK operation, which I assume should really be _STATUS. It
> > describes what the output VECTOR should be for VERIFY in table 131,
> > but not what it is for STATUS. Table 132 suggests the output VECTOR is
> > the list of supported mitigations, which matches what I was seeing
> > when I played with this.
> > 
> 
> That is a good catch! We should get that changed in spec.

Yep, I pinged our spec maintainer, hopefully it'll be resolved Real Soon.

Thanks,

Tycho
