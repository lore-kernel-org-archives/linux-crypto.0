Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF188441636;
	Fri, 24 Jul 2026 16:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784908948; cv=none; b=IOKGHVYEFTdVLBO+H4rz2MQDHD2I478fzVnxSwecLaLB+gR13cWVU1Fca7pcqs22Njo5DoWerGHs+jsdHRpOtWa7T0lRrYjQHEJ716Xo740YZu3I+3sgTVC97SrMoURCeA5QjcckkCRvCWRrDYXldpeAe0jwXDZvPu6wh3C5IEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784908948; c=relaxed/simple;
	bh=ZQ0q9M+TGIEffyH0DQOSK0C5+lHoBtyeWsyndEZdh4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SlGt/j3u4/kMk90WHofvO6wcovFpW2hd5WRL3fckqA7KWwdmchXvYVzxBRhoagCwL5VCP4EmDp66rveZmjC7PPLowlHhPWEfay9spmgbLy3/QxfVH9BtQJwnqthI5d26v48p66OM5JnRmjNBeY+7DQBdL6z2rOXGQeEaxAcotcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dyeQFwoN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dyeQFwoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E951F000E9;
	Fri, 24 Jul 2026 16:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784908947;
	bh=J96RTthvr6jTtaMNTXKflh6cMMsn22VqdcO7ERNrSZ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dyeQFwoNQObDFdh4xdUCf18PIKz6VPd8lr7nBw1EC/RRMz22kPhtgAlo23kV9MOgY
	 XwlaUHWlO+K5ui52VBtD3+OA/c33OfUy3TUB0t0ki/RLcDEQKXsn831fy95Bs4fmSc
	 Wsi9RKoYmHO6d3UapkehRANUlRKVfuC9zu8D4Dgy3N8UvzkFyXUJ+uhllBi5mqhgk0
	 tiRAkPaLdHpazE8uVCpgttNlt68Sf5wupe2fF8rDt9qbkuz8pRK11er5IUym4D/2Cn
	 b9WClITHkH92VKAviUIxpiV3hu7osa8k4JezBwU86ScKautyywbHYzM8w9EVVjFKfa
	 VcLgl70T8Pz1w==
Date: Fri, 24 Jul 2026 09:00:34 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: demiobenour@gmail.com, Harald Freudenberger <freude@linux.ibm.com>,
	acme@kernel.org, adrian.hunter@intel.com,
	alexander.shishkin@linux.intel.com, ardb@kernel.org,
	axboe@kernel.dk, corbet@lwn.net, davem@davemloft.net,
	edumazet@google.com, herbert@gondor.apana.org.au, horms@kernel.org,
	io-uring@vger.kernel.org, irogers@google.com,
	james.clark@linaro.org, jolsa@kernel.org, kuba@kernel.org,
	kuniyu@google.com, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, mark.rutland@arm.com,
	mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
	pabeni@redhat.com, peterz@infradead.org, skhan@linuxfoundation.org,
	willemb@google.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH 2/3] AF_ALG: Drop support for off-CPU cryptography
Message-ID: <20260724160034.GB2032@sol>
References: <20260523-af-alg-harden-v1-2-c76755c3a5c5@gmail.com>
 <20260603133312.12848-1-freude@linux.ibm.com>
 <amOGWwdjnJqyxH5L@codewreck.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amOGWwdjnJqyxH5L@codewreck.org>

On Sat, Jul 25, 2026 at 12:35:55AM +0900, Dominique Martinet wrote:
> The tool source is available here:
> https://github.com/nxp-imx/crypto_af_alg
> (which now fails with:
> bind(3, {sa_family=AF_ALG, salg_type="skcipher", salg_feat=0, salg_mask=0, salg_name="tk(cbc(aes))"}, 88) = -1 ENOENT (No such file or directory)
> )
> 
> 
> I don't particularily care for the API used as long as we can keep using
> the hardware key, but as far as I can see there's no alternative API --
> what's the path forward?

There's no "tk(cbc(aes))" algorithm in the upstream kernel.  So, it's
not possible that this ever worked with upstream.  Given that, there's
no regression in upstream for this program, and it wouldn't be
appropriate to consider a sysctl knob in upstream at this time.

- Eric
