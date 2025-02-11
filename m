Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1869C254B05;
	Tue, 11 Feb 2025 17:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739293517; cv=none; b=he7W9LTJ2YBiSXTs2/360m5a0ZXu1XWwP7CaUP3v+b16qDClMmMOrtmexb8RsCJWwVTlIK/D4HTsEcndGEyhUzeh/LkVtGMb5hXILKSItkRqpksDKb7UnI9Yn25uYW6wyrkoDLBSm6hlOK/tOjCRQMvkyEuZQvvxhugGdc4CHWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739293517; c=relaxed/simple;
	bh=4SlwwWxS+SQPd/d/oR8xE4I/YSQQ0zoz8M3b8E1zjEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NoaIPNUyjAAsx+/WftDs9YFWlDoWKgPLPvHPwNWdLg55Cm4t8MEy8v6uWZDuot9eDLwL+0Ng4N81M4+yvbSEBp4vC4GmfDmjAvEmPudGppXmhEE6JpEKIFIWU9QXhz2hCAHvKkCQDYZA8B5AhWoNp8u4FIfoMshEAz2sAEgjVcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mBdf+Ih1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mBdf+Ih1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E328CC4CEDD;
	Tue, 11 Feb 2025 17:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739293515;
	bh=4SlwwWxS+SQPd/d/oR8xE4I/YSQQ0zoz8M3b8E1zjEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mBdf+Ih1kmF4vUqTTwGdNBZW1z5ZtYlGN9Kh6h5Gk5GhSITdAVnJPI6X6ephobZNV
	 hos0cutdV7vSuPGGlstWzPG9Kvn7ZIMgJil6bGWg0cUUmp07Wce1WBsK3AUpU+WxeY
	 iMHkw7qzR78mKym7mwM9oukCpMwUmAdw9jASVA3ZjiHEw/cahlZPna0Fpm4sZfmuid
	 fSPRg7tcveI4gATGV9y28wo++LFYoqM7al68GG2FaQel8Sh2S2edpAubVwe7D9JE1D
	 tiHk93fnPPxWR2j0nC8rEU72HvMlGhSFP/eFEn3MdibI33N4fEbj5/BW+Ir+9x+HjN
	 PBwHo/3BR1nwA==
Date: Tue, 11 Feb 2025 09:05:13 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, surenb@google.com,
	kristen.c.accardi@intel.com, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com
Subject: Re: [PATCH v6 00/16] zswap IAA compress batching
Message-ID: <20250211170513.GB1227@sol.localdomain>
References: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>

On Wed, Feb 05, 2025 at 11:20:46PM -0800, Kanchana P Sridhar wrote:
> IAA Compression Batching:
> =========================
> 
> This patch-series introduces the use of the Intel Analytics Accelerator
> (IAA) for parallel batch compression of pages in large folios to improve
> zswap swapout latency.

So, zswap is passed a large folio to swap out, and it divides it into 4K pages
and compresses each independently.  The performance improvement in this patchset
comes entirely from compressing the folio's pages in parallel, synchronously,
using IAA.

Before even considering IAA and going through all the pain of supporting
batching with an off-CPU offload, wouldn't it make a lot more sense to try just
compressing each folio in software as a single unit?  Compared to the existing
approach of compressing the folio in 4K chunks, that should be much faster and
produce a much better compression ratio.  Compression algorithms are very much
designed for larger amounts of data, so that they can find more matches.

It looks like the mm subsystem used to always break up folios when swapping them
out, but that is now been fixed.  It looks like zswap just hasn't been updated
to do otherwise yet?

FWIW, here are some speed and compression ratio results I collected in a
compression benchmark module that tests feeding vmlinux (uncompressed_size:
26624 KiB) though zstd in 4 KiB page or 2 MiB folio-sized chunks:

zstd level 3, 4K chunks: 86 ms; compressed_size 9429 KiB
zstd level 3, 2M chunks: 57 ms; compressed_size 8251 KiB
zstd level 1, 4K chunks: 65 ms; compressed_size 9806 KiB
zstd level 1, 2M chunks: 34 ms; compressed_size 8878 KiB

The current zswap parameterization is "zstd level 3, 4K chunks".  I would
recommend "zstd level 1, 2M chunks", which would be 2.5 times as fast and give a
6% better compression ratio.

What is preventing zswap from compressing whole folios?

- Eric
