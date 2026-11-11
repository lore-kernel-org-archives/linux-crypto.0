Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794395733;
	b=zv44MTS+xC1IKlHhrYdvipvzNLtmXebxcihmy5/xWbZI6Jq8Rm8m7X1Q1M3jWIIBpySq
	 6XiMWKd0/ZX7rwFa8z1jhJlQrVrl6zmdnl1zwgp/8Ax86sR12fmqJndByuopuj0VT/P06
	 rscUifrSYeqa9pWH3642PFRs2vu0VYCbdqJbIp6qlY4mefMNBTrvxtAWkMG1rUlu2zvfJ
	 uwzDTlsJfRqD33skcB6kml3AQf1lZadIDSHGJSV0/VklDSuaok8mKzKLHI0MlvThyuV3B
	 wwZtaOdAuYobK/h4T+j2RMPWv9mlSOi0I9sCXxDqJ8CSFcco7/kqyEaD1D8oPIC8sJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794395733;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=BlLqYPADNwQ1zF+v5NfxkIsk70HEKIc18L9HL/VuUSM=;
	b=R2KXA/J5WMtvuwDJ1BoDzry1zjbEDxReRL3yKNRsprIXZpZlQzpK/SUHOF17qEThWxza
	 yoLz7qo1Ih479MkL9ntrUepbYAweigJSXBT0S7/fqmjqS6m2B/me93jgjT7cad2DKwofj
	 KbHIjzpXvkFzOjz947gXcXM8ytuxBJBouvKPa01uw4X09y9rYQCg2I7uAevgDqbcCD7R2
	 mVQUbqSMIVvDQqGlytI4PfDpde+/ZXPSeaH7/8n6Xqr0OFN5o+/YrpQ2rCCWUaTSWUnm9
	 LPHuWykqJ+iCouuaTkZyLU8b5euBC+hOis0NfXxNPiDUBZ1rYfgkPou/L4RfvfJy+WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=B8qHdfto;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB406606A339;
	Wed, 11 Nov 2026 11:15:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB406606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=B8qHdfto
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=BlLqYPADNwQ1zF+v5NfxkIsk70HEKIc18L9HL/VuUSM=; 
	b=B8qHdfto/kn5BTMJWabTV7zaMUonK0Lpj3afLU6lnKrKz8Cj4B23jHuUj9lyOOFKFb3WbRJrIlR
	S+GcrjPE+Cp/DpYqReoBXauBUMJgKp0L19de/VX+b1vD2qcylI7IxlnM4z/xU+9arSljgiCnfp75s
	hE3tzq5QepQ0arZjxRTNSE0SGHR2cOdRj0Io6OQJO4h/Z+McC461ArautLz12Z4h5d9CJO8NFJdxA
	T6HW9asiJU6Polpu39186KRNt7gIjTTSSMstlVA63wNopTMEeBctRTJeeAZdpaelDyS8x2Rc5ru6o
	/JNCunrTVW0yWESUWInkH+8RqBjTFqnStSRQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xR6IO-0000000DmXP-06l1;
	Wed, 11 Nov 2026 19:15:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Nov 2026 19:15:16 +0800
Date: Wed, 11 Nov 2026 19:15:16 +0800
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
Message-ID: <avRORN8bPgzDY2Rf@gondor.apana.org.au>
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

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
