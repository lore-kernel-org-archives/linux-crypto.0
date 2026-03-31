Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB4D27A462
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 06:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774939665; cv=none; b=JZ7/pZnRCIkkN+6636aS17Jp2L7CdlDt9XqYQLdG4zqVq1n0WXLYEmzJNh0YYQbwQyOZifs90qqvrr71rzSlCk4OwCjeom7dCRsbUrlu66rtZRNj7Cp3dUHvzjwb/9rdAcHlB8FAQHeUa+ebBQAyIwGOzC5lHiulcWfGhYp63bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774939665; c=relaxed/simple;
	bh=8DPyNr+dkT1z3DWXsiNlNh5fnlsp2ats5a6xm4LK2Y0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BUs2YCYWjDKYztbPc4bj+AgMsKlkGkpoErN9A9ADSiRm28O06eWFrY9bJ9MA6+mQ+32GSIJFdHvnwDMoGwgampUGULtE88mDwV/MJ7UKDor6wliiEUe6FQHDciIXGzgPpEDZAk+uVz4PqJbhBpQ7Wg78VIJArxunO2qetoKpyEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=C07+twf7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C07+twf7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=afivXW2PTC36kmyMDBN3SIricSfoCKcEeqYymXRdbNI=; b=C07+twf7CgOQFRK8STZQ4F0WMm
	PL/U2F2SMWVvUSc/E0+v2A2JFiyl69bkL+qIYeog/CruzwK4owdxcjUuNgUUSDvKZ3tYubAfp7UYJ
	U4dRFt+bUX46tlrHN15prTBCWC79Z2rk4ZxRJtTkZACO+4E0OALxaW6Mh8ndZcG2QvD0YlvEE87iJ
	FTju0fnkSOPvbvQGvKSXO2gmtPWKRGTYPWIvezzp3KyScmFM+W+UnAasxcesetV4Jj19MJcyOdF7g
	gIm1KWkvwIN6Uoi4IetOhZOTJ0KkTSLq3BxOvr8kS5wWvqH3LAKUfI6gIjoSP/iS8WjRsuPEGPUGL
	yETDV4/w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7St4-0000000CP8w-1Lgd;
	Tue, 31 Mar 2026 06:47:42 +0000
Date: Mon, 30 Mar 2026 23:47:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Demian Shulhan <demyansh@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 5/5] lib/crc: arm: Enable arm64's NEON intrinsics
 implementation of crc64
Message-ID: <actuDkpYbzLj0sI8@infradead.org>
References: <20260330144630.33026-7-ardb@kernel.org>
 <20260330144630.33026-12-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330144630.33026-12-ardb@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

>  	depends on CRC64 && CRC_OPTIMIZATIONS
> +	default y if ARM && KERNEL_MODE_NEON && !(CPU_BIG_ENDIAN && CC_IS_CLANG)

It would be useful to throw in a comment here why it is disabled for
big-endian on clang.

> +#define crc64_be_arch crc64_be_generic
> +
> +static inline u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len)
> +{
> +	if (len >= 128 && static_branch_likely(&have_pmull) &&
> +	    likely(may_use_simd())) {
> +		do {
> +			size_t chunk = min_t(size_t, len & ~15, SZ_4K);
> +
> +			scoped_ksimd()
> +				crc = crc64_nvme_arm64_c(crc, p, chunk);
> +
> +			p += chunk;
> +			len -= chunk;
> +		} while (len >= 128);
> +	}

From reading the earlier patches, I'll assume arm SIMD code is
non-preemptable and thus you want the chunking here?  Maybe add
a little comment explaining that?

