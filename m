Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31AB2ECFC6;
	Mon,  5 May 2025 23:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486489; cv=none; b=Z9rDASzHvmgRRd83qB+lXosbpUTFIgFqSGI5+fYuLU4DxKs0Rpzuj4Mfq/cp3krMvPPHVeWNj2X6wwSbYVd3RgE3M6qeFsZtzplbOPcdC5TGqfOeWhyxlioL6ZLRfjJ0qqYLGkddwGSVLAI8KG507l93ghywUXk3C/OqXXOMEz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486489; c=relaxed/simple;
	bh=Y1nCOUYyEEMAjqY3ZzPW6+yjZTimEC9xDeL7HEYfkvg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OYIHLtLyt6lbvFl3rOroZpJ90ZIu7G3eY6LKLFqDcqx67oj+Hf8HyWquHeZihRlbw+Mu+5tClkBXrSqx0n2LBsdBs9Cl7M7JsgO1KtkkgZ3GT/0z8Nhz1W/9D6fZaAXI47d+MG8DbFZ9KY9P5OkdW1b6FOeoiWxc7RlDCYJmRfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XCi0HxNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XCi0HxNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BFDC4CEE4;
	Mon,  5 May 2025 23:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486488;
	bh=Y1nCOUYyEEMAjqY3ZzPW6+yjZTimEC9xDeL7HEYfkvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCi0HxNjk0sC8zZNjDd8yMZXoghzUbvDEfYgnucer7jZjKFZew2q9PGReVNXuHaua
	 6+r58EBFP60D0PMpSasZGkLZAt1pWVry8HVKwBbxGMqd3QCxWALx/zgQq3uDEn7Sy2
	 jo1OupoanohbgPS4DzOgn9qD8semiFdKO0yk/Q6MLhbh8urkvFasuXsFbzXmIiuS3p
	 CUt+XbDW8uh7VLdfrTXPz/BaerdERLgsERLxjSAVKHPXLJ370uwwDwswlfeM6mXLaj
	 +tA5NVwe8TQjq3UOZw+F5q5reCIxSJheuW22BPVho2aVG3a13JYaPJQ/pYmvX6GKSB
	 sxeqdKLdeUU+g==
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
Subject: [PATCH AUTOSEL 6.1 056/212] crypto: octeontx2 - suppress auth failure screaming due to negative tests
Date: Mon,  5 May 2025 19:03:48 -0400
Message-Id: <20250505230624.2692522-56-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505230624.2692522-1-sashal@kernel.org>
References: <20250505230624.2692522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.136
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

