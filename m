Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86538299A87;
	Mon,  5 May 2025 22:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484993; cv=none; b=Bs+Jhdx1SA1M/p28qRX+BllakIh8IQ2RFAodwbct8FxAE/pv/C9fkwOfN5B85JlK1JDQ/4mo8gOQmTRXXof1ewlGLqjhMNDSTmt9EaD+Z27kgsHEy86+vhKJ1QdpTC3YiRIynNyWpNosutA2A/xEGERU/qZwaW4zFuKnEq35jGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484993; c=relaxed/simple;
	bh=BFmc84IeGC9GR1voaM5+gS5OimBrB7/kQB36gwmZwUE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o/KGQRnzs2qeuTivQB7NfARO9PFPMYSvrtJGjpqeO7GhtHuQAZrF0W2NnRcqBmi+XSIuMBinEvBr0i86faJeavDrCKkdazRHKqTSjTTIIlW5gl8m9McCTKJ/0L2vigIehMaCSX0QxG9OYB4MRW38htDf71wSY30D6BrEJdM29+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DKQTVHT7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DKQTVHT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFF2C4CEE4;
	Mon,  5 May 2025 22:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484992;
	bh=BFmc84IeGC9GR1voaM5+gS5OimBrB7/kQB36gwmZwUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKQTVHT7vYWdgro1OP8dzORulSrRWmaD/8DlDOsLWOEl7/PAiqCrKod+Ah0AEwoMF
	 FHYCeo1kMurkDE5PuI44rQeiagQhKzBDKQsurZhowv/0aReO3RXuisWbUmM2/k0xO9
	 3SkpQdEKrIi6lANEaRhcQ+AKaxj+vvAhmI7cdynHKrIgFVhHpfeGmAmbbT1m9b1YSv
	 coCbAXupT8mgDO3vmaCyJZ9DhHLFzrX8lb4xuYD7CzodOLGuSrFwVRwGcYDLpdi+Cn
	 4ehBBqJvqDKZv08JdyeJfmqe237Je4AxJL41yXr3i3ZkrLzmUfOGo8ghfyc4F2g0WO
	 vS+GDdpmbG3Fg==
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
Subject: [PATCH AUTOSEL 6.12 114/486] crypto: octeontx2 - suppress auth failure screaming due to negative tests
Date: Mon,  5 May 2025 18:33:10 -0400
Message-Id: <20250505223922.2682012-114-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
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
index 5387c68f3c9df..4262441070372 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
@@ -264,9 +264,10 @@ static int cpt_process_ccode(struct otx2_cptlfs_info *lfs,
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

