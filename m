Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792656876;
	b=qt3sHT1/WMHdqHYT6rinJ9teCHNArCSryvsglMdGmJHxfMTSpHywZt1S0gRdbqzNjjjM
	 GpVI40qz9/yGcT19RqTj5lOMnYa6UT+ymE499hGnwJnGOxQmuh20eZPhxBqANlxElxYnW
	 qULLZ8T7nJNIfBueHMFUcSVTEH+a+FT0rwYWcS7UF8p6XznSsWgXg7t5x7hPc7Z+SUDPg
	 QKQfplE7EPYmJyoYvoQ/YZySzHo1jJjzDtmoKOuhJB1K9d9wBzCbk/vDavrnH9FIiN/3T
	 0Ok6o2QOFagOTPIdgvZQOvLNXfIk+9VFEDMDsD81nmoNe/gGfGRTTKxbdej18CfvOIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792656876;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=3sD0G4G8uCR6QoPuFMFokC4gDJ/4LjJ7maE0ec9iXuw=;
	b=nISmTdqSeDOHP9gZqwoM9pnl5XrXijpk2ux63YFZI/+D13C65qXKCS1TbKGzNBQE39kV
	 N0y4Ek9qUANRvLHJIUz3Wu4GVTiG+vyTSkXTf+PhkuBx6sqFS16dafTfI3fz/3W4NoU//
	 qgMkFDXtVBIOnNbFcmJ9Lu4NgqWRFB/K6Z8z5j2MtkxD1NA1w/rBkcZZm3XaIE1xvw+iA
	 3EkM5jGsLOvvRcGfrjPWjKMhWvimFAkvRkzCcVQtpPdbOlgKfrBmp/9BrAXynXE/tu4rW
	 /SU2a5AqttSIP4Fn2CAMotY86UNY8wmMHd2qFblmQPeuM5Dn4nbzEz9DKEQ3f3ZldXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=a6C+nt7i;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEFC606A31A;
	Thu, 22 Oct 2026 08:14:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFEFC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=a6C+nt7i
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=3sD0G4G8uCR6QoPuFMFokC4gDJ/4LjJ7maE0ec9iXuw=; 
	b=a6C+nt7iqTVvYfxU6QjSdBPTeQZyNPTtqpAaRGegAEHnBAgGiGQM2em8ubMFe1+mi0LpiuxjZQ1
	qLGSJSv9CpXaRcaIPaU2lN4fTgfJz/Gl9500tuBzTazyvIeYgAhC4rZxMYr+14zYXZcSHuXpwxYB+
	C4uP7b6XHYzOuIy1PydxpFYJR1ppAkLStuM3jRxtNCRirVs8nkTiRvGvwHTUE56Z0YwUXsqMx0XR4
	Ts3zuI4z+xMgD/QjZIShvMPQv4Dc1RAg4zE0Hb3mJ/ySFIs9ZDS9zf63dF4+YXPknPIDlROiP2rr2
	1FpGMsIHAtCV6LFjeG57eTbtesmtOiF5znOg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xJnw2-00000006Sw6-1DCV;
	Thu, 22 Oct 2026 16:14:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 22 Oct 2026 16:14:02 +0800
Date: Thu, 22 Oct 2026 16:14:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suseendran Bhaskaran <suseendranb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"David S . Miller" <davem@davemloft.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
	SJ Park <sj@kernel.org>, Chris Li <chrisl@kernel.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	linux-crypto@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: return -ENOSPC on compression destination
 overflow
Message-ID: <atnFygk8xsQ-8Mj5@gondor.apana.org.au>
References: <20261021205626.3286270-1-suseendranb@google.com>
 <20261021205626.3286270-2-suseendranb@google.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021205626.3286270-2-suseendranb@google.com>

On Wed, Oct 21, 2026 at 08:56:25PM +0000, Suseendran Bhaskaran wrote:
> In the acomp/scomp compression interface, callers pass a bounded
> destination buffer and rely on the return code to distinguish a
> destination buffer overflow (incompressible input) from genuine
> compressor failures (such as invalid parameters, uninitialized state, or
> hardware errors).
> 
> While the multi-segment streaming path in zstd_compress(),
> crypto/deflate.c, and lib/842/842_compress.c returns -ENOSPC when the
> destination buffer runs out of space, the single-buffer path
> zstd_compress_one() (taken when input and output are contiguous single
> pages, such as in zswap) as well as lz4, lz4hc, lzo, and lzo-rle return
> -EINVAL instead of -ENOSPC on destination buffer overflow.
> 
> For users such as zswap, which reduced its per-CPU compression buffer to
> a single page in commit 0b1bf60c324a ("mm/zswap: reduce the size of the
> compression buffer to a single page"), incompressible pages typically
> overflow the PAGE_SIZE destination buffer due to compressor header/token
> overhead. Because these compressors return -EINVAL rather than -ENOSPC,
> zswap cannot distinguish a destination buffer overflow from a compressor
> failure, causing broken debugfs error accounting (reject_compress_fail
> vs. reject_compress_poor) or masking real compressor errors.
> 
> Update zstd_compress_one(), lz4, lz4hc, lzo, and lzo-rle to return
> -ENOSPC when the compressed output overflows the destination buffer,
> matching the streaming path in zstd_compress(), deflate, and 842.
> 
> Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
> Signed-off-by: Suseendran Bhaskaran <suseendranb@google.com>
> ---
>  crypto/lz4.c     | 2 +-
>  crypto/lz4hc.c   | 2 +-
>  crypto/lzo-rle.c | 2 +-
>  crypto/lzo.c     | 2 +-
>  crypto/zstd.c    | 5 ++++-
>  5 files changed, 8 insertions(+), 5 deletions(-)

I can take this patch through the cryptodev tree.  Is that OK with
you Yosry?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
