Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7021F2361
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772294; cv=none; b=Ydngat96nN5RwbofFjProG7S6ZEhnRs/cEf14q8vjbQ0X+Uw7zy006P1XxIgQ8ES5crYBHhViu1Iag+HyFYoSXfjQEnFyamDr4yP8DH5yGx3BxJN7qyU7Z/5VujnI8c1wsX4LGdKsbeSsBYfpNNagMqQsK9qI6Z4GK7HpMZ5TeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772294; c=relaxed/simple;
	bh=gTqiJ83GC+y9ntGuuGLBowL4XoaSaAg3tom8EPVefuE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmwJyuMtdjvMoR1ph75EscdoNM7HUsP4HlrFnjSkVwh5iAFAd2ULLiSG1RjHI5InARddFXSiUidDT44UmGzlbNOnHktGo2W4ktjpS0/DFYkwRHqTXdcGf8ocPy672kWSga9AZRgR9UGMrb+AwfFGlm7/CxWtFuF0m2iHMkgCw5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y8Id6Zul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y8Id6Zul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C603AC4CEDD
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772293;
	bh=gTqiJ83GC+y9ntGuuGLBowL4XoaSaAg3tom8EPVefuE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Y8Id6Zulh0YG6d8I5noG2Nw/d2ppYHV4Qm8IoRNMsNfL0jFy7+SeZdFA+/cBC//Ab
	 E2oanVBd6Ame730CCC6/Py8eDgNy2hLKPKAAupynslHTQGpAO+XmuUb9rbIFwK8Q7r
	 aXLV2mZFZK0nOD2SOnCPpmvPlIgPLW3VpjKvd2DYmYELlpySs/OozpKhFcEwb/zYtW
	 9U3jF/p8rtMwF2H7BIkTvGeAJRkZmcYarxHhy0gRjsB0uiEk6okavzaXUd3Nim423T
	 Fv0fJ2kDoGTAedZzj2CTcg5o/S3Ro881PD1cZ+sohw2JhDpVg3M+cruAB0rYeze9D4
	 lqcUbLRpEKJgA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 15/29] crypto: skcipher - use scatterwalk_start_at_pos()
Date: Sat, 21 Dec 2024 01:10:42 -0800
Message-ID: <20241221091056.282098-16-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241221091056.282098-1-ebiggers@kernel.org>
References: <20241221091056.282098-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

In skcipher_walk_aead_common(), use scatterwalk_start_at_pos() instead
of a sequence of scatterwalk_start(), scatterwalk_copychunks(..., 2),
and scatterwalk_done().  This is simpler and faster.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 441e1d254d36..7abafe385fd5 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -355,18 +355,12 @@ static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 		walk->flags = 0;
 
 	if (unlikely(!walk->total))
 		return 0;
 
-	scatterwalk_start(&walk->in, req->src);
-	scatterwalk_start(&walk->out, req->dst);
-
-	scatterwalk_copychunks(NULL, &walk->in, req->assoclen, 2);
-	scatterwalk_copychunks(NULL, &walk->out, req->assoclen, 2);
-
-	scatterwalk_done(&walk->in, 0, walk->total);
-	scatterwalk_done(&walk->out, 0, walk->total);
+	scatterwalk_start_at_pos(&walk->in, req->src, req->assoclen);
+	scatterwalk_start_at_pos(&walk->out, req->dst, req->assoclen);
 
 	walk->blocksize = alg->base.cra_blocksize;
 	walk->stride = alg->chunksize;
 	walk->ivsize = alg->ivsize;
 	walk->alignmask = alg->base.cra_alignmask;
-- 
2.47.1

