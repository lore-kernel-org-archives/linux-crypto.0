Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D099F2206B8;
	Mon, 16 Jun 2025 16:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750092502; cv=none; b=NNyv1yscxMDFXCH/Ekcd3Ex+JtH/LAXYGXdsriEy44RBLRew0wAAR3mYiJ5IbtNwruK1rUsVBzHIKzME5JazbOYglcFuPBBfFZHJdJGhgjBvDbDzxLIdsPYwWr83b2/dQDypioFgai+7Xh0/FIN28n02U9YT6pFXi609AnRXIAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750092502; c=relaxed/simple;
	bh=SBTpm63UHMFqCZdV2G/xC06X9kxXxQkDL/LS1vLHYmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q8s59xJkS2WY3jU+luABSmZGGNhUYr6RosYY643Rq4vHoFzxemdllZRWadyd7P33cYIan7J6ZWEDA6TZ3WQfTDhjU/DuXNf08t31hM8y10hm1t7Pnd/tQO4P36J5koirfHUBj9T2RPcYcXcoGsrxMxPAl9Jv7P/2YC6cDwvSU8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QAriSCxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QAriSCxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AECBC4CEEA;
	Mon, 16 Jun 2025 16:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750092502;
	bh=SBTpm63UHMFqCZdV2G/xC06X9kxXxQkDL/LS1vLHYmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QAriSCxSAHoR6nDEUqFI0MWvzAIv18W4eSBqzrC6yktFrsGialIDya0O2HAXrPGSy
	 vU3Jj028dhcD5iaA7RgNLqLRWgpQKZr9J2x2se3fuszoM0LOaz3MJZ2ihp5ivZXteC
	 J7H3YzT5Aut7Awn+aod3WGjpNsjbTaLe1W2+gFA946pHdnL68Se5HGa+/R6ZtZ7gln
	 XjdORki1iTpT8CQ8ndbixmesVwd0GC69E8Bc/JCVvXXEvX9FAGQCOPXXBP+z913+gs
	 5bryDUyLEZfiwgYaESNerirLHs/lxPoQK6UmABz1l+lBumresmWH44KWcjJQJL9gUg
	 fS3pD/NUyxbAA==
Date: Mon, 16 Jun 2025 09:47:52 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
	qat-linux@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - lower priority for skcipher and aead
 algorithms
Message-ID: <20250616164752.GB1373@sol>
References: <20250613103309.22440-1-giovanni.cabiddu@intel.com>
 <aE-a-q_wQ5qNFcF_@gondor.apana.org.au>
 <aFAyBgwCUN2NLXOE@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFAyBgwCUN2NLXOE@gcabiddu-mobl.ger.corp.intel.com>

On Mon, Jun 16, 2025 at 04:02:30PM +0100, Giovanni Cabiddu wrote:
> On Mon, Jun 16, 2025 at 12:18:02PM +0800, Herbert Xu wrote:
> > On Fri, Jun 13, 2025 at 11:32:27AM +0100, Giovanni Cabiddu wrote:
> > > Most kernel applications utilizing the crypto API operate synchronously
> > > and on small buffer sizes, therefore do not benefit from QAT acceleration.
> > 
> > So what performance numbers should we be getting with QAT if the
> > buffer sizes were large enough?
> 
> Specifically for AES128-XTS, under optimal conditions, the current
> generation of QAT (GEN4) can achieve approximately 12 GB/s throughput at
> 4KB block sizes using a single device. Systems typically include between
> 1 and 4 QAT devices per socket and each device contains two internal
> engines capable of performing that algorithm.
> 
> This level of performance is observed in userspace, where it is possible
> to (1) batch requests to amortize MMIO overhead (e.g., multiple requests
> per write), (2) submit requests asynchronously, (3) use flat buffers
> instead of scatter-gather lists, and (4) rely on polling rather than
> interrupts.
> 
> However, in the kernel, we are currently unable to keep the accelerator
> sufficiently busy. For example, using a synthetic synchronous and single
> threaded benchmark on a Sapphire Rapids system, with interrupts properly
> affinitized, I observed throughput of around 500 Mbps with 4KB buffers.
> Debugfs statistics (telemetry) indicated that the accelerator was
> utilized at only ~4%.
> 
> Given this, VAES is currently the more suitable choice for kernel use
> cases. The patch to lower the priority of QAT's symmetric crypto
> algorithms reflects this practical reality. The original high priority
> (4001) was set when the driver was first upstreamed in 2014 and had not
> been revisited until now.

For some perspective, encrypting or decrypting 4 KiB messages with AES-128-XTS
serially, I get 18.4 GB/s per thread with the VAES-accelerated code on an Intel
Emerald Rapids processor.  (The code is arch/x86/crypto/aes-xts-avx-x86_64.S,
which I wrote and contributed in Linux 6.10.)  The processor appeared to be
running at about 3.28 GHz.  That's about 5.6 bytes per cycle.

Emerald Rapids processors have 6 to 60 cores per socket.  Even assuming that a
second thread in each core provides no benefit due to competing for the same
core's resources, that would be an AES-128-XTS throughput of 110 to 1100 GB/s.

That's way more than QAT could provide, even under the optimal conditions which
do not exist in reality as QAT is much harder to use than VAES.

FWIW, on an AMD EPYC 9B45 (Zen 5 / Turin) server processor, I get 35.2 GB/s.
This processor appeared to run at about 4.15 GHz, so that's about 8.5 bytes per
cycle.  That's 51% more bytes per cycle than Intel.  This shows that there is
still room for improvement in VAES, even when it's already much better than QAT.

It's unclear why Intel's efforts seem to be focused on QAT instead of VAES.

- Eric
