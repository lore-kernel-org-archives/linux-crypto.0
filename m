Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E401C3ADB9A;
	Mon, 15 Jun 2026 22:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781563320; cv=none; b=ikBycq11SgcQSpV/kUgzc3bQFdvqQR9TLMBALD/aUlQ2SPf2RfUMqQ+NLSD6ZAYFWD2rl/9/a6zmH1psmf9/2ycruWL+vRvxhAZwHUQc5SuTx6ObZMhWQ+OAsdxLV4TZ7HEqabgTu3PlA21sPczg2d0t0Lk2l+8MTmJUT1ZBXCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781563320; c=relaxed/simple;
	bh=e4LnrobsKtuGE0GRhT8t6httiivqwfZmahaW88frjV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cr9PMQltzAlsM16gR3ajGGrr+enN0tWSp+MZNkxl0PUz4hsziWpAFwCZyolGXGjnJrNG+fb4bdS+i65MG5V2blk84SPVEuUIwZ87w7Yvhe2A9PsEWPQ2XPMNSB8YRXw+FoTqCAEuV2GneVEoEfUVkO6KviBih/tjp2bE1+T1/Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mmXeNfCh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mmXeNfCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFD61F00A3E;
	Mon, 15 Jun 2026 22:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781563319;
	bh=fixzsSatwpbdDeKxep8EfQNOVkvT2mu9en9QqOJWwmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mmXeNfCh86jCo4KWo+KAlMIsSF9Au9pbHjXVum9H4TefQ0k9lP39sxD4slURnnIh0
	 HyEZdw26idPNCNxjKvybvOhTUUe6H9PSXDOHgZXvn4nxmxRS/AIp53j6QLaur51AFX
	 6zbxDrrnkYfpof5yX+OdWDcgC4itZZurUnu+KisX0fnSAxalp2YXV0OXqBNZaUHma8
	 b3tkwTgUPi4nQ3AqPXxhpuEwgv8kH6blzUvV5LJezjQ9LnO+xvWKVecML/UJhBDOkP
	 QFEye8Xt+RB+d5YikV2T3UncVl/IKTDYPtxUSMMQPQpDVZS7XckAtP2U3jAcObp6eb
	 cIGxwMhnYsXVg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Gaurav Jain <gaurav.jain@nxp.com>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 2/7] crypto: qcom-rng - Allow zero as a random number
Date: Mon, 15 Jun 2026 15:41:26 -0700
Message-ID: <20260615224131.69370-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260615224131.69370-1-ebiggers@kernel.org>
References: <20260615224131.69370-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zero is a valid random number and needs to be allowed.  Otherwise the
output is distinguishable from random.

Fixes: f29cd5bb64c2 ("crypto: qcom-rng - Add hw_random interface support")
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/crypto/qcom-rng.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
index f31a7fe07ba7..7058bd98f9e9 100644
--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -63,12 +63,10 @@ static int qcom_rng_read(struct qcom_rng *rng, u8 *data, unsigned int max)
 					 200, 10000);
 		if (ret)
 			return ret;
 
 		val = readl_relaxed(rng->base + PRNG_DATA_OUT);
-		if (!val)
-			return -EINVAL;
 
 		if ((max - currsize) >= WORD_SZ) {
 			memcpy(data, &val, WORD_SZ);
 			data += WORD_SZ;
 			currsize += WORD_SZ;
-- 
2.54.0

