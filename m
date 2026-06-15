Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF553B9DBC;
	Mon, 15 Jun 2026 22:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781564000; cv=none; b=KBWvP5Wn9SGVLFQ8MTljYr/uW3lDwvhYuwylJlTbrS7x/e98oIsI4bAB1I+EhuBeGNO/oZWsTIJyrYS63orhAd1ufw16r1b095WMrXcc8OiOmFh3FjJ7GMZHvhVf7DX6tgWqSFIwvn1rn6BagvDzTAFAFpkRnXSL5MfHAN4LiPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781564000; c=relaxed/simple;
	bh=QrWwRpOZlbqR/ijsvjrylyXZdIn7/QTqxQdNFwTdOvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VxH4eT5S9peQYjfNUf7kbQSKj9UsdT3wZ4/41YPQ8Coao01Dqf2Wz8RaqG4Mv3tixZpQbfmOujEb4wBEi/TWAvaJc5lajehKYOd8FfbKMFNkpO0+qcr6IULxsbKkgqOmIR6/iDa9Sd+V+svaABjhFs06Gv35EXT6thDvV8nEGIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MV8U6ioU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MV8U6ioU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BF31F000E9;
	Mon, 15 Jun 2026 22:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781563999;
	bh=/OfPahqSyS/jHREvee15nAI++QhhEJbHrIUvoqnSfKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MV8U6ioUVmLQsXR/wZk0yLXYM6FP1llitrjboLCexn7CV4JM+jwnGcuImHAg0bdbV
	 Nu38+GtYissDdR8A938hcuYWn3L0CoxNddcJd48Pxw/Wv6UqLntofPAfoZIpNQAVB2
	 Oe+FKxEWhDE3YDMHSXOpnz6ZcY0YOQa68BOJRCw1Bq6i+nEeH3wta4xKCYevfRpLdB
	 q7P7fLLmvhuxL5xcxanWfPJIaSGC1KFlcz4jwEVGrMi5EoG5P3Zu9e2FcsduXjrTjn
	 0gr1kNPTr0h71tmSA9JGSwal++3nru2HQgb8KE5x1bPPwZhP0RmqX+IzpacPj3Gj1s
	 PoYtmVMsE3m/A==
Date: Mon, 15 Jun 2026 15:53:17 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Leonid Ravich <lravich@amazon.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Alasdair Kergon <agk@redhat.com>, Ard Biesheuvel <ardb@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Horia Geanta <horia.geanta@nxp.com>,
	Gilad Ben-Yossef <gilad@benyossef.com>,
	linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v4 0/3] crypto: skcipher - per-request multi-data-unit
 batching
Message-ID: <20260615225317.GB28589@quark>
References: <20260615111459.9452-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615111459.9452-1-lravich@amazon.com>

On Mon, Jun 15, 2026 at 11:14:56AM +0000, Leonid Ravich wrote:
> The series adds a per-request "data unit size" to the skcipher API
> so a caller can submit several data units (typically 512..4096-byte
> sectors) sharing one starting IV in a single request.  Algorithms
> derive each data unit's IV from the caller-supplied IV by treating
> it as a 128-bit little-endian counter and adding the data-unit
> index, matching the layout produced by dm-crypt's plain64 IV mode
> and by typical inline-encryption hardware.
> 
> This mirrors the data_unit_size concept already exposed by
> struct blk_crypto_config for inline encryption.
> 
> The first user is dm-crypt, which today issues one skcipher request
> per sector and so pays a per-sector cost in request allocation,
> callback dispatch, completion handling, and scatterlist setup.
> 
> Proof-of-concept performance numbers from the RFC reply [1]: +19%
> throughput / -40% CPU on a single-core arm64 system with a hardware
> XTS-AES-256 accelerator running fio 4 KiB sequential writes through
> dm-crypt, when an out-of-tree arm64 xts driver advertises
> CRYPTO_ALG_SKCIPHER_NATIVE_MULTI_DU.  This series itself does not
> include arch enablement; the fast path is opt-in per driver, the
> slow path is universal via the auto-splitter.
> 
> The native fast path amortises both per-sector dispatch and per-sector
> crypto setup across a bio - the measured win above, on an engine that
> offloads the AES compute.  The auto-splitter is for correctness and
> reach: any consumer can set data_unit_size and get correct output with
> the per-request allocation/callback/completion cost removed, but it
> still issues one alg->encrypt per data unit, so on a software cipher it
> saves only dispatch overhead (no throughput figure claimed - that is
> hardware- and workload-dependent).  What it guarantees unconditionally
> is byte-identical output (Verification below) at O(entries + units),
> walking the scatterlists with a pair of struct scatter_walk cursors
> rather than rescanning from the head per unit.

So in other words, this series slows down dm-crypt and crypto_skcipher
for everyone to optimize for an out-of-tree driver.  And there's also no
benchmark showing that your driver is even worth it over just using the
CPU.

- Eric
