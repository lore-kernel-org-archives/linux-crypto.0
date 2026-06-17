Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7786E24E4A1;
	Wed, 17 Jun 2026 05:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781675818; cv=none; b=Zv1/AScNK7NbEnVUvYdOYsEZ4dNR96arDIjkyE2n606v14qbAlh5LHXeGMqXv1Eflo58d1p4TjU0JMGsNYVxbk1kkmrsm2VM5JD5v0CBeqzKr9s/tSNkxPu5j8vhLPjJ9exZ5EZkK5QjgpYV0UIU9hNS5Xkl2+Vfe7CCG/N2xCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781675818; c=relaxed/simple;
	bh=AlxlUmcTFzCEcSUgIUeo8Ciqtxn3tGl46YqUMpD6NOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qRWuR1Q9YlgfZFn3AQ8HnbzFzXfM3z74e7COe7EpozTT20pKD6J21wsuDDTu75RZRpVR+5dANlrDHbJB3A05Rp0szvG8RzRDewlf26tIuFd3p8oOqRkAMmbFp6T2yRBpD1H3iAk5KweZ426Jv7H3OHJldpGhrIllFQZvco3fkvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4784E68AFE; Wed, 17 Jun 2026 07:56:54 +0200 (CEST)
Date: Wed, 17 Jun 2026 07:56:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-crypto@vger.kernel.org,
	x86@kernel.org, David Laight <david.laight.linux@gmail.com>,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH v3] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Message-ID: <20260617055653.GB19218@lst.de>
References: <20260615190338.26581-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615190338.26581-1-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Can use the xor: prefix used for all other commits to lib/raid/xor?

> Benchmark on AMD Ryzen 9 9950X (Zen 5):
> 
>     src_cnt    avx          avx512       Improvement
>     =======    ==========   ==========   ===========
>     1          56353 MB/s   75388 MB/s   33%
>     2          54274 MB/s   68409 MB/s   26%
>     3          44649 MB/s   64042 MB/s   43%
>     4          41315 MB/s   55002 MB/s   33%

On my Zen 5 mobile (AMD Ryzen AI 7 PRO 350) both the existing
AVX2 and this AVX512 code give numbers in the 200+ GB/s range.  Not
sure if is just the different benchmarking or something else going on.

FYI, one or 2 sources are basically useless as they RAID5 configs
that have no benefits over simple mirroring and thus the numbers
aren't too interesting.

> +DO_XOR_BLOCKS(avx512_inner, xor_avx512_2, xor_avx512_3, xor_avx512_4,
> +	      xor_avx512_5);

Is there really much of a benefit of doing the historic DO_XOR_BLOCKS
vs doing the loop manually?  Especially as the common cases for a
modern RAID will usually loop over more disks than this was built
for.  I.e., in practice one or two source buffers only happen at the
end of a loop over more disks.

