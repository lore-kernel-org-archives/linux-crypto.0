Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB89AD5E;
	Sun, 29 Dec 2024 22:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735512889; cv=none; b=dRN6K+4HFh6s9IWgyF3GyLNSVnnkirHcJrm5KvoDvQnY7+Pad9nT7IKRsKW6JR3H4QI9JM/LVFrltPANjm6zs7d5wux2UGeDeYGs8Rr3wBSuBIazxEKW9UIdFnBFYsns2X3jBTRcW5uqVTn/oD8WTcBVDlUfCyM6PIXQH/MBUGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735512889; c=relaxed/simple;
	bh=u/Avk1u4FAJQuUYSkM+Zz7Sxlyry6JL/GViKf/XJP3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c6FClhqkxGRerFH0DMTG+pgERIykd4AImBMxT5d7ZIVi/ODU3S+yiheEPJA+n5WwEBcZRUI2/LUc4+uwvocBxqMiEmCANaolE4z+ziZwVvKqlwrmAAXNOY8e4fvvxgmZdcKQC7RYHl1NDAqbwSGPNgFgGJHLpdgvFq+e+JTKJz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IWx7l5kK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IWx7l5kK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A840CC4CED1;
	Sun, 29 Dec 2024 22:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735512888;
	bh=u/Avk1u4FAJQuUYSkM+Zz7Sxlyry6JL/GViKf/XJP3g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IWx7l5kKEy3Jx8A6PR2NCCT9CvIexP5EoCPW8ecNBGwOwuLWYyMdBJfP+k385pL8/
	 rlr6fV2uAeJkPyZDrTWcHbOmmAgpcoFSTxntXKQfskb8xdcPuXqRn7nuy3r5sTZseH
	 d+C5nZmsthbuA7/PSBHc4oFgcZOlcXagtaYasqIOYefecck2VZNcNFtFpQfwKVNF0W
	 9+BoRU5MfAsC36cQV9Os3aGaSnJOWMtj+5yYMS0tMQbRzRmvtyzCkbnN+N+dxwtFOB
	 iH8wxB5UY9R9aJOIE5J9KwlRIwvh0KSFSjrt9RHhjPWGjqjg2ghvpn1Sn7FQSjUwB5
	 mn2rtLoa7y49w==
Date: Sun, 29 Dec 2024 12:54:47 -1000
From: Tejun Heo <tj@kernel.org>
To: kernel test robot <oliver.sang@intel.com>
Cc: Breno Leitao <leitao@debian.org>, oe-lkp@lists.linux.dev, lkp@intel.com,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org
Subject: Re: [herbert-cryptodev-2.6:master] [rhashtable]  e1d3422c95:
 stress-ng.syscall.ops_per_sec 98.9% regression
Message-ID: <Z3HTN1gvVE9tfa4Y@slm.duckdns.org>
References: <202412271017.cad7675-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202412271017.cad7675-lkp@intel.com>

On Fri, Dec 27, 2024 at 11:10:11AM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed a 98.9% regression of stress-ng.syscall.ops_per_sec on:
> 
> 
> commit: e1d3422c95f003eba241c176adfe593c33e8a8f6 ("rhashtable: Fix potential deadlock by moving schedule_work outside lock")
> https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git master
> 
> testcase: stress-ng
> config: x86_64-rhel-9.4
> compiler: gcc-12
> test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480CTDX (Sapphire Rapids) with 256G memory
> parameters:
> 
> 	nr_threads: 100%
> 	testtime: 60s
> 	test: syscall
> 	cpufreq_governor: performance

Hmm... the only meaningful behavior difference would be that after the
patch, rht_grow_above_75() test is done regardless of the return value while
before it was done only when the return value is zero. Breno, can you please
look into whether this report is valid and whether restoring the NULL check
makes it go away?

Thanks.

-- 
tejun
