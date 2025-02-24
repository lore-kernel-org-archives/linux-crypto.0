Received: from mail.schwermer.no (mail.schwermer.no [49.12.228.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929EE18F2EF
	for <linux-crypto@vger.kernel.org>; Mon, 24 Feb 2025 07:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.228.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740382964; cv=none; b=F4BczXTJx0fplLMoSYxdmGRNzoN5otyAIlOUEkecQwjQLyveAz1rPDKOo+xg+PaiPwmnnxRZ47mAzO/HTctY9h4vGYQofRjH3zQrQ8W8RXlVXLiJAvonFs+Xxe115m+DaDG30LRW8kvCY96YuIY5KPZIZO1oZVfzGpR8e0i7Llo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740382964; c=relaxed/simple;
	bh=pmrjU2hLPPSEpzzwiV8h4Tse1Sp1INdKPPBuNMm9sxc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iBCA0v7A0Zzc36wGpQWbhDfCb+I7myCGap1n62r1/Y4BgrgJOl3CYcyX0I2FWNY9jjCcFSEDN8gyrbagMXUzd6XAuI8DwK+H0JlAsE4qHgGJdBuaB+4E7uBXoGw4JvDesaFA7dJ0ILs4CRxYRPvP/sq6moK+ym8bYF/oh+OhbKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=svenschwermer.de; spf=pass smtp.mailfrom=svenschwermer.de; dkim=pass (2048-bit key) header.d=svenschwermer.de header.i=@svenschwermer.de header.b=Lu3IyLzP; arc=none smtp.client-ip=49.12.228.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=svenschwermer.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=svenschwermer.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=svenschwermer.de header.i=@svenschwermer.de header.b="Lu3IyLzP"
X-Virus-Scanned: Yes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=svenschwermer.de;
	s=mail; t=1740382958;
	bh=pmrjU2hLPPSEpzzwiV8h4Tse1Sp1INdKPPBuNMm9sxc=;
	h=From:To:Cc:Subject;
	b=Lu3IyLzP1Kgj29D8VtZ3yT6DgaMCcClhgk440w+0kGYLoFZ1Mv6eGWHpdzhioKtxU
	 VS5Y1QQt9bkoOhq+NtDaR/3GYHwYTvVwylhMHnkNM6zXi414uGjoRncyCLWoAQ7yyb
	 DiTQ9EiOu2h1PVFtGv0p2TMRKP3ddO5nALaI0qYUvLTj9kFjQZPSoaFO7xKty4FVar
	 tgK0zozSONJ6McxXClUw7eliLjMEnxH4ka7lh5kukDcq4cMCbtgZlm+c84HZHTGTvs
	 IuNKwzAe92WzzVaoE8yMwQ76MkgDBkk6dwK5JwONDVt9yaUfQFhgUQk/Is70KV1GTe
	 64d2v7nQC354Q==
From: Sven Schwermer <sven@svenschwermer.de>
To: linux-crypto@vger.kernel.org
Cc: Sven Schwermer <sven@svenschwermer.de>,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	shawnguo@kernel.org,
	s.hauer@pengutronix.de,
	kernel@pengutronix.de,
	festevam@gmail.com,
	imx@lists.linux.dev,
	david@sigma-star.at,
	richard@nod.at,
	david.oberhollenzer@sigma-star.at
Subject: [PATCH 0/1] mxs-dcp: Fix support for UNIQUE_KEY?
Date: Mon, 24 Feb 2025 08:42:24 +0100
Message-ID: <20250224074230.539809-1-sven@svenschwermer.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi there,

I'm not 100% certain about this patch but trial and error seems to
confirm that this patch makes it indeed possible to use UNIQUE_KEY which
I was not able to do with the current implementation.

I would appreciate if somebody with access to this hardware could test
this independently, e.g. the folks at sigma star who authored the
original patch (3d16af0b4cfac).

Best regards,
Sven

Sven Schwermer (1):
  crypto: mxs-dcp: Only set OTP_KEY bit for OTP key

 drivers/crypto/mxs-dcp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.48.1

