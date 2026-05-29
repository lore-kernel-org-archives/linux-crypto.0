Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825EE33F5B1
	for <linux-crypto@vger.kernel.org>; Fri, 29 May 2026 08:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780042100; cv=none; b=kERXJ346PUaNKJ937zX7w3wHqbuXg/QexVcy4Mo+RVfWAYc8S88EMBYVTYOvubx+CNpZT8oi46Ul/Ia6pJ0650sexcFeRdprcQISSNp61J6VeG6sIPVOievjLllWR5Om7Yne9JFOaEt19jQilMSWnwSo4vDiGGVUoV7a6Ah/jWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780042100; c=relaxed/simple;
	bh=pwbq1GQXPiFQwNmyslF6wkzZlnjwVzAbBnldA7Mxa1U=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=ZJizl5Lw4P8xpho2/kHPW2x+CnPXTgDlySqGZ3ZhqmD8IqHbfU6MgpxArAvWxhMNgCQAUscHX4aTdXDt/awdIm73N8z1CbO0/iEKrkOVk3savUWCkiKF4hKkQUG7XLEhWqC4m91Ut9o8td8MnUuBber7kyJIlfO8brko6UmCtA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IzCxCgfY; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IzCxCgfY"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780042087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cn8RGbbWhMK+fmOfLvNDrpH9fQ9BHow0UZabfx8bzzE=;
	b=IzCxCgfYrXXqAra8csjkLDYzBUaXEP1y+20GkUNHakvuHgvPcnDcVazIECq/qCx+KlXa51
	z9zMh+/V02p5KPJoKO5ii3Pkefr2lloZdWh0UE1xSxUpDsPzd/rR0+qFVIIf51SCtyi4Aw
	tnYQobxdi72BP9jrI96qSccPDLP3woI=
Date: Fri, 29 May 2026 08:08:01 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Tianchu Chen" <tianchu.chen@linux.dev>
Message-ID: <4d4407c05835a50413fa1e974e3aa3f4abfe2d5b@linux.dev>
TLS-Required: No
Subject: [PATCH v2] crypto: sun4i-ss - clamp PRNG seed length to prevent heap
 overflow
To: clabbe.montjoie@gmail.com, herbert@gondor.apana.org.au,
 davem@davemloft.net
Cc: wens@kernel.org, jernej.skrabec@gmail.com, samuel@sholland.org,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
In-Reply-To: <af749a8447bd7f0e9dd26ca6c87e9c6afecb09d9@linux.dev>
References: <af749a8447bd7f0e9dd26ca6c87e9c6afecb09d9@linux.dev>
X-Migadu-Flow: FLOW_OUT

From: Tianchu Chen <flynnnchen@tencent.com>

sun4i_ss_prng_seed() copies the user-supplied seed into ss->seed
using the user-provided length with no bounds check. The crypto core
does not enforce slen <=3D seedsize before calling into the driver, so a
userspace caller via AF_ALG setsockopt(ALG_SET_KEY) can pass up to
sysctl_optmem_max bytes, overflowing the fixed-size buffer and
corrupting adjacent heap memory.

Clamp the copy length to the buffer size, matching the approach used by
loongson-rng for oversized seeds.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System cr=
ypto accelerator")
Cc: stable@vger.kernel.org
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
---
v2: Silently clamp oversized seeds with min_t instead of returning
    -EINVAL (Herbert Xu).

 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c b/drivers/=
crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
index 491fcb7b8..7f6a51dd8 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
@@ -8,7 +8,7 @@ int sun4i_ss_prng_seed(struct crypto_rng *tfm, const u8 *=
seed,
 	struct rng_alg *alg =3D crypto_rng_alg(tfm);
=20
=20	algt =3D container_of(alg, struct sun4i_ss_alg_template, alg.rng);
-	memcpy(algt->ss->seed, seed, slen);
+	memcpy(algt->ss->seed, seed, min_t(unsigned int, slen, sizeof(algt->ss-=
>seed)));
=20
=20	return 0;
 }
--=20
2.51.0
