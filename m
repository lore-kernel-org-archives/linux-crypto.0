Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0D339061C
	for <linux-crypto@vger.kernel.org>; Mon,  1 Jun 2026 09:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780305581; cv=none; b=QC5bLRuDxmh3H1aH0qfm3bljKTnWAr1IDVG97pqNgpjPp3l7chOo2KmT7PoS0rO7+Mj1Tdi78haxaxPtwjPVdCilN9GAHwnUKH0ZjvKihQGYklMVD/QzgX4U9k3XVeGHPTsDevOSYJEUTiqh7cyvZ+eFUk1ohbAR53OvEtl1OBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780305581; c=relaxed/simple;
	bh=PPChPTR/glaiNHISsa+FGiwhtJkD2/oee5H5c/F4L5k=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc; b=HiN5a3OGiKkafhVnxl/9+vq54to2qRNwDoYL9NiEFvhom4BdKjYsXJL0vgTwCpXWVtm96c9ywxkw2PQ3jyVIy/u0aJj7M7nKfMaM2L5WaoRtEVKqxwStaAnLkFgIzihW9eswu0R7BHEDeo1ovUs9QNkhY1fOBx9sjaVGB1vwmx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iKIKQJRy; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iKIKQJRy"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780305566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=d5IyFKFbRT3IKZtpikCYlnIfXgvvgQ7v1CmhoyZgrLI=;
	b=iKIKQJRyZO7nrywzvbDm3R6lAw+dIiZnj3xTdbymV1G11dNR4PzQ5gu3ZcC38ePos4UHZz
	dbJexfJbtJKCAi6nLtpJ67BFXN0C1G54yyypw8GGbuCHn6f8LFZto5N85lKcz+6n5qKHH+
	USlkhKTQOCl3Nbyu3whgXhpp4klhYEA=
Date: Mon, 01 Jun 2026 09:19:23 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Tianchu Chen" <tianchu.chen@linux.dev>
Message-ID: <d52449abfd8e1e46c8bfe9ebdc00d931fc0e4147@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] crypto: sun4i-ss - Remove insecure and unused rng_alg
To: ebiggers@kernel.org
Cc: clabbe.montjoie@gmail.com, herbert@gondor.apana.org.au,
 jernej.skrabec@gmail.com, linux-arm-kernel@lists.infradead.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-sunxi@lists.linux.dev, samuel@sholland.org, stable@vger.kernel.org,
 wens@kernel.org
X-Migadu-Flow: FLOW_OUT

From: Tianchu Chen <flynnnchen@tencent.com>
In-Reply-To: <20260529193648.18172-1-ebiggers@kernel.org>
References: <20260529193648.18172-1-ebiggers@kernel.org>

On Fri, May 29, 2026 at 12:36:48PM -0700, Eric Biggers wrote:
> Remove sun4i_ss_rng, as it is insecure and unused:
>
> - It has multiple vulnerabilities.  sun4i_ss_prng_seed() is missing
>   locking and has a buffer overflow.

Thanks for cleaning this up.

For the record, the sun4i_ss_prng_seed() buffer overflow you mention here
is the same issue we reported earlier with a targeted fix:
  https://lore.kernel.org/linux-crypto/20260529194152.GA3628@quark/

It is an unauthenticated, unbounded memcpy() into the 24-byte ss->seed[]
buffer, reachable from any user via AF_ALG ALG_SET_KEY with no privileges
on affected Allwinner sun4i hardware.

Please note that this should be treated as a security fix. For the earlie=
r
stable releases, keeping the rng_alg but adding a proper bounds check in
sun4i_ss_prng_seed() might still be a preferable option to consider.

Given the above, would you mind adding the following trailers to the comm=
it
message?  Besides crediting the discovery and report, they would also mak=
e
this security issue easier to track and reference across the stable trees=
:

  Discovered by Atuin - Automated Vulnerability Discovery Engine
  Reported-by: Tianchu Chen <flynnnchen@tencent.com>


Thanks,
Tianchu
