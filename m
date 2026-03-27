Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923973624B5;
	Fri, 27 Mar 2026 10:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774606024; cv=none; b=ss8y3oIrOWvTYsiWWruDTcEB0KZWRyPKNiVAeM+6b1hVs0QSpPjF0mIMACD7J+dSSaB83g7QpzgQssxDvHoG48uZCINz+k8XgwzppepS4YfgO2iLGKmmiGkzaV+f8fgsi1tkStPATuXgpeKLEkqvjwkCxjjdx9cYlbpueTzdSRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774606024; c=relaxed/simple;
	bh=7ZoZM6Aa/5n3vq5O0G5Jt3216oup94Q2NSc6Y7+mw04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ufto1lLMpE/0NLRoYkBo2aNNkxNBX5PEptJgdvKLsgMFvyfsqOWKsFWIvCRfvX7zLFmMzdzbQjAxsQ5jaRWJQNnSSSXdD+VywaT94JbD7HMw3OX5vCTOW+uiUc6zSOMJH2e5bBL4br0d01hgSnr8AOCkzwyaWwC+rNWS24c/vBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=fCwsOXor; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="fCwsOXor"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=lOW6hBhzRdBbEJxmwfJeE8L+H5z0momZPOfQVcGg08I=; 
	b=fCwsOXorstWIWwmDXDlY7q3VI9hWP0uLLCP2mJH61FAWwmJocqU8uCt/P77Ntn9Bswc/Rzwp2N8
	5rp3f/4HWk54mhGNO+cuqxd+bw6ieYrTr9pExoRmGjw5fwP/ONplWtWtlfKQZjk+Cp3vFuwUPMJR2
	1WmETXAdGMihYhDXQ4etl8F3A7D6bV10rkhPIxbZkSgb3dgF4FWR9rtA4q3TRqk1nTmzZ5ktDZVER
	MQx03liEuDQJKY9mPBWHRXAhrtbNgLDCc9dpA8q/dGgDG1/cwCPTlsUOtEwmqnGUO6bUvwRBj6ygf
	0Nds4UhPoAzkgMGUf3d80TwkVVycA7e7g0uA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w63g7-001bmd-12;
	Fri, 27 Mar 2026 18:06:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Mar 2026 19:06:50 +0900
Date: Fri, 27 Mar 2026 19:06:50 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Haren Myneni <haren@us.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: nx - Fix packed layout in struct
 nx842_crypto_header
Message-ID: <acZWugqQs1PBgojz@gondor.apana.org.au>
References: <abnmUvHzhgS9xA-m@kspp>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abnmUvHzhgS9xA-m@kspp>

On Tue, Mar 17, 2026 at 05:40:02PM -0600, Gustavo A. R. Silva wrote:
> struct nx842_crypto_header is declared with the __packed attribute,
> however	the fields grouped with struct_group_tagged() were not packed.
> This caused the grouped header portion of the structure to lose the
> packed layout guarantees of the containing structure.
> 
> Fix this by replacing struct_group_tagged() with __struct_group(...,
> ..., __packed, ...) so the grouped fields are packed, and the original
> layout is preserved, restoring the intended packed layout of the
> structure.
> 
> Before changes:
> struct nx842_crypto_header {
> 	union {
> 		struct {
> 			__be16     magic;                /*     0     2 */
> 			__be16     ignore;               /*     2     2 */
> 			u8         groups;               /*     4     1 */
> 		};                                       /*     0     6 */
> 		struct nx842_crypto_header_hdr hdr;      /*     0     6 */
> 	};                                               /*     0     6 */
> 	struct nx842_crypto_header_group group[];        /*     6     0 */
> 
> 	/* size: 6, cachelines: 1, members: 2 */
> 	/* last cacheline: 6 bytes */
> } __attribute__((__packed__));
> 
> After changes:
> struct nx842_crypto_header {
> 	union {
> 		struct {
> 			__be16     magic;                /*     0     2 */
> 			__be16     ignore;               /*     2     2 */
> 			u8         groups;               /*     4     1 */
> 		} __attribute__((__packed__));           /*     0     5 */
> 		struct nx842_crypto_header_hdr hdr;      /*     0     5 */
> 	};                                               /*     0     5 */
> 	struct nx842_crypto_header_group group[];        /*     5     0 */
> 
> 	/* size: 5, cachelines: 1, members: 2 */
> 	/* last cacheline: 5 bytes */
> } __attribute__((__packed__));
> 
> Fixes: 1e6b251ce175 ("crypto: nx - Avoid -Wflex-array-member-not-at-end warning")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/crypto/nx/nx-842.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
