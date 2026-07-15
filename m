Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B13E3B27DF;
	Wed, 15 Jul 2026 16:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784132875; cv=none; b=c8GxldF7QhIVzJPA6ZCG5Kd+wqrBidbHD9u0PtRkeapJ8VApoQ4QqRlpWH5CKepiNzY4XQ900bscnA4h33RaUF9C5650vM9prbwGPkTpgRc5JJGBl9pkV55P/RrQ6qEfNAJsYZJyn/nBbeLLitf9UJNvR2gKgBJVkOK3B4vleqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784132875; c=relaxed/simple;
	bh=lj1rgJJQ8Iw7DFQDnqucdEqnKnOgE8yauIKaWfv1cU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AF0j5CGJK8vVhKbCOmIhkBXoMdKa/r2q2Gdp7jhkpaxJWBMG84fcoLvk7MjZNjjtOAcwwtajVxAGITWsuxhLFFuFPt2jsrRKUTHiIzL/id3xBDmuWwM9DbYt4QB3IdQT9dMwXqiW1PbnI0ZFgqrpICcgjaKdoc9/fbhlwv4CcBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MGvWJam+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MGvWJam+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F581F000E9;
	Wed, 15 Jul 2026 16:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784132871;
	bh=54R+2ukVfD8PZgTffVmOpuZHh7XCR2jNtp1pGUhqRN0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MGvWJam+kbgESefZNKMsozGwUbsIGMpTwoUjT18AUXzt1JfCEBkzL68tFCCZzQO0u
	 dZOURABJCk4Y5ZogKyGKKqgt5nsjgrVRVIvtvRRdHieGmkjBSb/+UGL+Gwcku0wJKj
	 +EoKyWLYL4y3BrW8IJ4ylICkG714ZxX1t0Ng91Esdz4dTOMXWo6odWHD2xTF3tE6N4
	 52fZ2RSoCdFBet0pv0yRKOlwER/y1E2xeW5DX6P5WtmAoIj5q1s5qfcrKSxOQQOdII
	 qgAawh8mTu1QrIhijtdu/04RldudnfYbPPRL8coBvv6fkng+BiFCRs/wyP8H4UJt0E
	 sP6GtG7i5dqRg==
Date: Wed, 15 Jul 2026 16:27:49 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
	Herbert Xu <herbert@gondor.apana.org.au>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [linux-next:master] [crypto]  2f204fe718:
 stress-ng.af-alg.ops_per_sec 113.7% improvement
Message-ID: <20260715162749.GA1794078@google.com>
References: <202607152204.a0a3bf98-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202607152204.a0a3bf98-lkp@intel.com>

On Wed, Jul 15, 2026 at 11:00:46PM +0800, kernel test robot wrote:
> 
> 
> Hello,
> 
> 
> we don't have enough knowledge to deeply analyze the impact of this commit
> to stress-ng.af-alg performance tests.
> 
> along with the major kpi improvement:
> 
>    7756377          +113.7%   16578454        stress-ng.af-alg.ops_per_sec
> 
> we also noticed lots of misc tests seem have changes, e.g.
> 
>     697423            -9.5%     630908 ±  2%  stress-ng.af-alg.aes_cipher_ops/sec
>     245103          -100.0%       0.00        stress-ng.af-alg.blowfish_cipher_ops/sec
>     369646          -100.0%       0.00        stress-ng.af-alg.camellia_cipher_ops/sec
>     162192          -100.0%       0.00        stress-ng.af-alg.cast5_cipher_ops/sec
>     115113          -100.0%       0.00        stress-ng.af-alg.cast6_cipher_ops/sec
> 
> we don't know if these are expected behavior upon 2f204fe718.
> so this report is just FYI what we observed in our tests.
> 
> 
> 
> kernel test robot noticed a 113.7% improvement of stress-ng.af-alg.ops_per_sec on:
> 
> 
> commit: 2f204fe718f5bf519013cc2536ad7bb2cbb51661 ("crypto: af_alg - Add af_alg_restrict sysctl, defaulting to 1")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

That commit makes AF_ALG block access to some algorithms by default,
overridable by a sysctl.  Apparently these performance tests
misinterpret that as a change in performance.

It actually doesn't make much sense to do performance testing on AF_ALG
at all anymore, given that AF_ALG is deprecated.  A limited form of
AF_ALG is being left in place just for backwards compatibility with a
few programs.  None of those programs use it in a performance-critical
way, as far as I know.

To the extent that it's still done at all, it shouldn't test random
algorithms like "ecb(cast5)" that are obsolete and unused.

- Eric
