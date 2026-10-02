Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3593D471D00;
	Fri,  2 Oct 2026 10:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790936169; cv=none; b=bP06pVKgqiH/ZxcDdbPThFDoLv6mpjyPfe/kTjlRvV0LwfEqld7E72TQXTq3DFfr190LFKuikG2w4VQ4DZQtNpIZ0x25OLwDV1wp+m6YQG06T1Iw0dnXtnbqrrcc3gx6yyuBWczs4tj7k6rpQynHgRPJzCaePrvU06A75czwkhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790936169; c=relaxed/simple;
	bh=X2Ebc6tLj5pIA1zMWNKioEXI8YkXRm0VnlJaK2vkcB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KtsXR7DWV1s8vzNgVPA9kHAf3Lt2ROn856XCim7TWfI1UWQnveRMzxRlgLJAVv3/KUn883Fb6tRvmhhgCsqEFjoSGQdwuQEmQ8Lo/u0lWBcggfAVAd3alkpW5KEi4hBTMOdn8xvzEZNjmBLIW49tTFmqP62heoNNgtscUPGEPjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=q7LnU0km; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="q7LnU0km"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=t66sqEvgjPu5eqIB2QAmy+AC5KfBWnu8nCcammsIiX8=; 
	b=q7LnU0kmL4OQ7NME5MvQM1j8ktWSrqzz3kU9RpnEdsy4aZp8o9Yr9vSzuHOc3jF8RiSFPnR+yO9
	/wm22oYux8HKha49vv62SXdjdjIRr75s5+wcuCWYV7S7plbidGVQRhlWLraGRIubNNFFkeyNd7u/+
	KR5UVSHv0xMILBitJjkMDVCZB9s6TjR4BhdbRbHKgeFqz9pNU/qAxyG2fswkDqa4LfEdwOF+Rb+42
	RI9Iwgd3mLguNwc4dQJXJ9FfU3dyOy+DP1n+R+ffP66E8gbjw8DFRw7I2M6PrKhedCdXwBqWLlR2U
	ocCP8rf2HIYCYMsriMLKIP06OzNe71EQcHcg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCaIy-000000001iS-1Xy0;
	Fri, 02 Oct 2026 18:15:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 20:15:52 +1000
Date: Fri, 2 Oct 2026 20:15:52 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?iso-8859-1?B?Suly6W15?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
	Stefan Berger <stefanb@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: ecc - Handle exceptional points in Shamir
 multiplication
Message-ID: <ar-EWEQc_Y7eiwWL@gondor.apana.org.au>
References: <20260926204323.1913803-4-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260926204323.1913803-4-Jeremy.Jean@oss.cyber.gouv.fr>

On Sat, Sep 26, 2026 at 08:43:26PM +0000, Jérémy Jean wrote:
> Shamir multiplication mishandles equal points, opposite points and the
> point at infinity. This rejects valid ECDSA signatures and can accept
> invalid digest/signature tuples when the public key is G or -G. The
> kernel incorrectly rejects 16 valid signatures from Wycheproof.
> 
> Handle doubling, cancellation and the point at infinity in precomputation
> and accumulation. Add regression tests for P-256 ECDSA and 256/512-bit
> EC-RDSA. The valid vectors are Wycheproof P1363 secp256r1/SHA-256 cases
> 60 and 210 converted to X9.62, two constructed ECDSA signatures for
> Q = +/-G with k = 2, and six constructed EC-RDSA signatures for Q = G,
> -G and -2G. Also add two invalid P-256 digest/signature tuples for
> Q = +/-G that must return -EKEYREJECTED.
> 
> Fixes: 0d7a78643f69 ("crypto: ecrdsa - add EC-RDSA (GOST 34.10) algorithm")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---
>  crypto/ecc.c     |  33 ++++-
>  crypto/testmgr.c |  11 +-
>  crypto/testmgr.h | 327 ++++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 363 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
