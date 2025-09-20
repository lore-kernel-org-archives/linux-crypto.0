Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CD42FFF8A;
	Sat, 20 Sep 2025 12:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758371060; cv=none; b=kl73xVV+R4Z6UOaxSqvp0zE4pzz5cvfnqaUT6chI0gblqWYJM3yPs4Ce/GtxI5QQT85kVNDVcynkN1WBL3TGKEQSkUo+7AgmCny42Uj8QxdYDJ8yfSarhWWPeaiW6d+qVs5QBXXR0MC0Xk++bPU79REKJGTJ1eu1XDh2uREYy1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758371060; c=relaxed/simple;
	bh=+VCl2qNOG76VOfRVAj3hMp0FVTlFw4IHD4CkVEVV9qI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gAMajFcXjltnFODXeAAfiyLD2skMsxPDIzguPYtZvVam5/zmPkGQ0ll/dsx1FcxFVqKrp8mR7qMSuwI42n7JpDnk0VD4HBhPB2X5Jdf42BgPpoLOktCumeqvcFe/Fy4yKzzxWpWL2Kqr/aoe4uNc+ul7zyRvXXceXP2ispA4g8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=BQgzDLUk; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="BQgzDLUk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:MIME-Version:References:Message-ID:Subject:Cc:To:
	From:Date:cc:to:subject:message-id:date:from:reply-to;
	bh=qHT8BTzKJhP5NNuPsa6/wkhiJ9T4Mc5AUPkCGtid+r8=; b=BQgzDLUkRT5bICBTs58EM3KrHO
	YDPfJ/i355q++ehPHfQ6+qdJKSlzXV30z+4kJK3muaVACQVO7zH7Te3BlPfMP2raZAtSAHSLw1UM0
	ZOkop71XLAdVXpNd7XtfVwWqqh3K50rpccD182V5IbURLXiDL1d0zNMW3OItkQEfnnL4tp5PT6U1s
	RhuHr3lbDWhJNmasDbKf4WM8DBEvE/oJuWGBdUDn/hI1Fz90inHur3TSYx3yzvJy6w5vwn2bH7bjb
	L7fGEuM7j/FfORs7p7xpTiKIN90RMGuawkFGN4cJIbANsOnFzVixLe91r8clDIUgtalEpb0WFGtmq
	lO0XFeDA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uzwdM-00704f-2u;
	Sat, 20 Sep 2025 20:24:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 20 Sep 2025 20:24:08 +0800
Date: Sat, 20 Sep 2025 20:24:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Moulding <dan@danm.net>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	regressions@lists.linux.dev
Subject: Re: [PATCH v5] crypto: acomp/scomp: Use same definition of context
 alloc and free ops
Message-ID: <aM6c6IzPiHnmqTaX@gondor.apana.org.au>
References: <20250908160002.26673-1-dan@danm.net>
 <20250908161243.27239-1-dan@danm.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908161243.27239-1-dan@danm.net>

On Mon, Sep 08, 2025 at 10:12:43AM -0600, Dan Moulding wrote:
> In commit 42d9f6c77479 ("crypto: acomp - Move scomp stream allocation
> code into acomp"), the crypto_acomp_streams struct was made to rely on
> having the alloc_ctx and free_ctx operations defined in the same order
> as the scomp_alg struct. But in that same commit, the alloc_ctx and
> free_ctx members of scomp_alg may be randomized by structure layout
> randomization, since they are contained in a pure ops structure
> (containing only function pointers). If the pointers within scomp_alg
> are randomized, but those in crypto_acomp_streams are not, then
> the order may no longer match. This fixes the problem by removing the
> union from scomp_alg so that both crypto_acomp_streams and scomp_alg
> will share the same definition of alloc_ctx and free_ctx, ensuring
> they will always have the same layout.
> 
> Signed-off-by: Dan Moulding <dan@danm.net>
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> Fixes: 42d9f6c77479 ("crypto: acomp - Move scomp stream allocation code into acomp")
> ---
> Changes in v4:
>   * After the change in v3, the deflate algorithm was no longer
>     affected, but the patch still had some whitespace changes in
>     deflate.c. This version removes those (so deflate.c is no longer
>     patched here).
> 
> Changes in v4:
>   * Rebased on crypto-2.6/master (previous versions were based on
>     stable v6.16).
> 
> Changes in v3:
>   * Intead of adding a new struct containing alloc and free function
>     pointers, which both crypto_acomp_streams and scomp_alg can share,
>     simply remove the union that was added to scomp_alg, forcing it to
>     share the same definition of the function pointers from
>     crypto_acomp_streams. The pointers won't be randomized in this
>     version (since there is no pure ops struct any longer), but
>     overall the structure layout is simpler and more sensible this
>     way. This change was suggested by Herbert Xu.
> 
> Changes in v2:
>   * Also patch all other crypto algorithms that use struct scomp_alg
>     (v1 patch only patched LZ4).
>   * Fix whitespace errors.
> 
>  crypto/842.c                          |  6 ++++--
>  crypto/lz4.c                          |  6 ++++--
>  crypto/lz4hc.c                        |  6 ++++--
>  crypto/lzo-rle.c                      |  6 ++++--
>  crypto/lzo.c                          |  6 ++++--
>  drivers/crypto/nx/nx-common-powernv.c |  6 ++++--
>  drivers/crypto/nx/nx-common-pseries.c |  6 ++++--
>  include/crypto/internal/scompress.h   | 11 +----------
>  8 files changed, 29 insertions(+), 24 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
