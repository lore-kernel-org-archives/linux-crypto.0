Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAE42DF57A;
	Mon,  5 May 2025 22:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485928; cv=none; b=YUkIQE4zvwSQv2P1TDoxL0KS5pTqW2/rFYzgU/cXpeN9WwVucIfFF90E/6+deFJRl6kGRAVoUHmjUCN+vOnvtsp2rnPT2P38g+N9OwdoEv7P2C9KQhFWfCdXgg9Bvaeot/4G/VKEVQNdiL7Htqv+G8+RKNngmhraHQiHfZlXAiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485928; c=relaxed/simple;
	bh=Y1nCOUYyEEMAjqY3ZzPW6+yjZTimEC9xDeL7HEYfkvg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JXlJ7gZs80LPYpZyhinbKZtkKx9OUYbXL2x5XY2Ggh3WZJ+OQqcEQizsLztj1DNC1knrVfu9jssaeQkthZyHw0Af+0bUmR0fyqmwM40LogDjssHj5u9MmNa24HWdpsvYmlpKon+GXNFyWPDPxi8dOwVzacTYjCEvEtxgZKc9jMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZbrjIAN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZbrjIAN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7697DC4CEE4;
	Mon,  5 May 2025 22:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485928;
	bh=Y1nCOUYyEEMAjqY3ZzPW6+yjZTimEC9xDeL7HEYfkvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZbrjIAN2ksLJYXlW+/WikyVbad8gqT0qPSRoGlKE05fungzVLSmf8h3H79d+13/s4
	 Wsxh0FQ0JLxL5UGIC/kkikDCdh6fJ2d2qfnMFXLz0QqEaW/h3ZZTcA6tNWmIN7t3tx
	 O4zCXtCUuaukpX7e+lf94NgMEPyZcNYREmBx3501q1ZWMlaN6P1ommn4mxtOmeEyiS
	 IOaT1hChIi8tnSkZBjvnXAqHEdboXoCOjxHL6oqeKwVWe3JWqukNuS68ybe1/n7jJU
	 zrybZP8kBAqMDzF9X9MUhPL58M+Ed1bUD7LnGuDBsjv1SS6AY3uFBLa3LuqVWpTpdJ
	 SlmLQooGQVgbw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Shashank Gupta <shashankg@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	bbrezillon@kernel.org,
	arno@natisbad.org,
	schalla@marvell.com,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 070/294] crypto: octeontx2 - suppress auth failure screaming due to negative tests
Date: Mon,  5 May 2025 18:52:50 -0400
Message-Id: <20250505225634.2688578-70-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505225634.2688578-1-sashal@kernel.org>
References: <20250505225634.2688578-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
Content-Transfer-Encoding: 8bit

From: Shashank Gupta <shashankg@marvell.com>

[ Upstream commit 64b7871522a4cba99d092e1c849d6f9092868aaa ]

This patch addresses an issue where authentication failures were being
erroneously reported due to negative test failures in the "ccm(aes)"
selftest.
pr_debug suppress unnecessary screaming of these tests.

Signed-off-by: Shashank Gupta <shashankg@marvell.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
index 811ded72ce5fb..798bb40fed68d 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
@@ -410,9 +410,10 @@ static int cpt_process_ccode(struct otx2_cptlfs_info *lfs,
 				break;
 			}
 
-			dev_err(&pdev->dev,
-				"Request failed with software error code 0x%x\n",
-				cpt_status->s.uc_compcode);
+			pr_debug("Request failed with software error code 0x%x: algo = %s driver = %s\n",
+				 cpt_status->s.uc_compcode,
+				 info->req->areq->tfm->__crt_alg->cra_name,
+				 info->req->areq->tfm->__crt_alg->cra_driver_name);
 			otx2_cpt_dump_sg_list(pdev, info->req);
 			break;
 		}
-- 
2.39.5

