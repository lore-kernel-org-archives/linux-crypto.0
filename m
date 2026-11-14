Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794630659;
	b=yewuvbv3XHoTb6Bbv9kA2BOTu4Jkg8H2UekCTU+RXi4jwcpx+Kw5iEy0tzUKfEmQgrrI
	 6hG1zEOyAJWH9mzqg1xKV7ZmHvyEZBokzGaD1n6AiGN0tYkh69kTHYi0YwyyVsSPdWJR1
	 duo9oP2z08tkRAtWQIUyrtYhmLBzercOmk3PadS26aAyNw/ksOmcEsFE3ldQCSyIhSdBJ
	 HzZi3hpj9UOJQEPbm7qYLJAtUBeIv4NF5YuAG3uQzpWZ+4BHLInaAPES7PfT2NBE9NLm3
	 Tgxa9a/YxZyww24xk2Hgjnzr+aFpgP7Xl1kM51jUL8dZKH2omW/QiJTDLhsYsbBR5fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794630659;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=e55L0t3g+P1raUsxhQohVvt16c1BNbrGNEVGHs5A5zM=;
	b=dNsWlCYckIKebJi0xJ0zrduuG+zuG1notguY9qeVBzNPlixlV7tBjHX82VyMaTOYzrsS
	 BqZX9OJCalXtCpnzllfeRw8sT/CgV/lhfQW8zXGAOXziI/HIn9iHG4x6gjgfYElCXTqTO
	 rLe0DnVnEeinN9VdZlTHbgRHrPoCS5ItqrLLmy2rahlpBV/25S3D2EVZ/phGZrKPs4Xd2
	 37aDLFPG9zT7jpjd+EByLNrTdnYHVOHjvcX6E78XZukpbeatB1Cu2w2KVash6xTs618+7
	 2a8N8R+0H9eX5wJfq23IKkMThzBg4t2I7Xo4+o+XPRabLbcDNtvk6JpCwVuPJV1wd9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PJ6Pw2Ms;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D41606A323;
	Sat, 14 Nov 2026 04:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PJ6Pw2Ms
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459AF1F000C4;
	Sat, 14 Nov 2026 04:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794630659;
	bh=e55L0t3g+P1raUsxhQohVvt16c1BNbrGNEVGHs5A5zM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PJ6Pw2MsYk0MsW9RvltJDySPq0PVOF0TMfZ87rnPo7n2pwCbJQspVa7uAZG/vGuG0
	 idZvOVGTcdEg5FH1GkbqJR+iRkj44p+bRR2IN+GlokclSBF9HRKkWcKmLyDqgTn1Ym
	 +qHrcIKTl3Sb6s0hspZhwLkuCt42lV2R3lkJ1JOV8DTZDxmC40HG/ydE4ZoNZ+o+iT
	 yz2YjhsxIz2tz/VDcAHM5Bt/Nrpw6BHIVWpWzNaiCJ2STfWcmhMlkKYOdRkAZQpfTu
	 FQA8sbCVJkG2UuiBSzoDUjZDAMYDbXV2nTe038Vc7XwIH4bqyLExDmox18xRIr40bP
	 WVpVlEOThBz9w==
Date: Fri, 13 Nov 2026 20:30:57 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Emanuele Rocca <emanuele.rocca@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lib/crc: arm64: use .arch_extension to enable CRC and
 crypto
Message-ID: <20261114043057.GH2025@sol>
References: <20261111142556.67489-1-emanuele.rocca@arm.com>
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
In-Reply-To: <20261111142556.67489-1-emanuele.rocca@arm.com>

On Wed, Nov 11, 2026 at 03:25:56PM +0100, Emanuele Rocca wrote:
> Use .arch_extension instead of .arch and .cpu in crc32-core.S and
> crc-t10dif-core.S.
> 
> .arch and .cpu reset the assembler's feature set, dropping extensions
> enabled via -march. See commit 9142c2f8f84b ("octeontx2: use
> arch_extension to enable LSE"), where this caused an actual build
> failure.
> 
> That is not a problem here: the instructions these files use are all
> covered by the CRC and crypto extensions. Switch anyway for consistency
> and to avoid surprises if the files later use instructions outside
> generic+crc+crypto.
> 
> .arch_extension is supported by binutils since 2.26 and by clang since
> 8.0.0, both older than the minimum versions currently required to build
> the kernel (2.30 and 17.0.1 respectively).
> 
> Signed-off-by: Emanuele Rocca <emanuele.rocca@arm.com>
> ---
> Changes in v2:
>   - Update crc-t10dif-core.S in addition to crc32-core.S 
>   - Clarify in commit message that this is not a functional change
> 
> Link to v1:
>   https://lore.kernel.org/all/20261105154145.557042-1-emanuele.rocca@arm.com/
> ---
>  lib/crc/arm64/crc-t10dif-core.S | 2 +-
>  lib/crc/arm64/crc32-core.S      | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
