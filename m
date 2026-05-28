Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6ED451068
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 14:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779980009; cv=none; b=VHtWxUj5IiblXwOXB+i+WfxR1zsBsgJqxF9r+WykuYkkfAEZ6qRyjZtEsTqz4Q1MTsjGRHndKlQx8y2PQGKbI3zrjxfrYwZeQhU43g4x5YA6tHDCjbgrc33IsZKcLLm0w+itjfXJ1jauXlVPaZconKMBPRi6t5T9XsWYal96aKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779980009; c=relaxed/simple;
	bh=Ixh0YbBJf+pswoH+BffSh+FjEQOZ7B9JPVWmf9gtkao=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc; b=OFK70lDOjwKVjIpeguCEWolIdY0Xtg55Ianes93XKDWqJY2nuKAI3WzCCfc4XKT1ltnWZOzaE7gdBs2rCl6vudDQlC4p37iL6VTqnVTJ0Zl1ntB0L8QcAbmWMdJ139JmSdzzDlfO/FDl3gzrlwr+ZVumFife+x7+bxC2FUDBEBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=njfeg0aU; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="njfeg0aU"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779980000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BMaA7h5kGMRU9hf/QRuYJW/W07yAJ1I7bh7FabXITYU=;
	b=njfeg0aU996w3zpMP+2q1ucUGMIvYDZSs21CeNIOfUiL1ZrI0VSfYke6OkZz2zMRnjkD9j
	OzS4sgXyyDAn5IBflYCdRtLbZwtsqaBKdQVzjCLPth+ha49m+0zG+Sdj6psnpFjZ5esy00
	yLfOy1+rIG/JFMKekOtTFrmiKmtpp1U=
Date: Thu, 28 May 2026 14:53:17 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Tianchu Chen" <tianchu.chen@linux.dev>
Message-ID: <af749a8447bd7f0e9dd26ca6c87e9c6afecb09d9@linux.dev>
TLS-Required: No
Subject: [PATCH] crypto: sun4i-ss: restrict PRNG seed length to prevent heap
 overflow
To: clabbe.montjoie@gmail.com, herbert@gondor.apana.org.au,
 davem@davemloft.net
Cc: wens@kernel.org, jernej.skrabec@gmail.com, samuel@sholland.org,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
X-Migadu-Flow: FLOW_OUT

From: Tianchu Chen <flynnnchen@tencent.com>

sun4i_ss_prng_seed() copies the user-supplied seed into ss->seed
using the user-provided length with no bounds check. The crypto core
does not enforce slen <=3D seedsize before calling into the driver, so a
userspace caller via AF_ALG setsockopt(ALG_SET_KEY) can pass up to
sysctl_optmem_max bytes, overflowing the fixed-size buffer and
corrupting adjacent heap memory.

Add a length check rejecting seeds larger than the buffer.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System cr=
ypto accelerator")
Cc: stable@vger.kernel.org
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c b/drivers/=
crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
index 491fcb7b8..010fa891c 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
@@ -8,6 +8,8 @@ int sun4i_ss_prng_seed(struct crypto_rng *tfm, const u8 *=
seed,
 	struct rng_alg *alg =3D crypto_rng_alg(tfm);
=20
=20	algt =3D container_of(alg, struct sun4i_ss_alg_template, alg.rng);
+	if (slen > sizeof(algt->ss->seed))
+		return -EINVAL;
 	memcpy(algt->ss->seed, seed, slen);
=20
=20	return 0;
--=20
2.51.0
