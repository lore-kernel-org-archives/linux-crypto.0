Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC502C2AA1;
	Mon,  5 May 2025 22:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746483613; cv=none; b=KOkZS2be2MGWA9/ZONhliIPgKv9LP126FTk3koifAzSpHwFEjp00O48HXPTlCh1URHNIKnWbDiAXSR6m1U2VIHNgL4OkRr2aevCw4nC/3mSvi8zd/382Zu9qYt4vUUW2yp7+lWCYtOSg26PPdMpfxV4fLZSYH1WWiStn8NuBKqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746483613; c=relaxed/simple;
	bh=BFmc84IeGC9GR1voaM5+gS5OimBrB7/kQB36gwmZwUE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lB+taffPffD/nRvm/cR0XL+JujTJ76bE807uRF93X9HD/ES41117BAx/mJmYpR0vNb9yiMMvRrLDSfN0g/rQS+EZ7EFaEkXX7gQkgR6STXVKcsisTx7mIoMFlubZTr0OrsPlrAQGeF/E/WisUXbWS26bZox5cpdGIQcKCg1Ls1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VvzQd0lh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VvzQd0lh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A669C4CEE4;
	Mon,  5 May 2025 22:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746483613;
	bh=BFmc84IeGC9GR1voaM5+gS5OimBrB7/kQB36gwmZwUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvzQd0lhJfWi43IdA2LoScdb0G2OtmFDyCKgMId7pF8jDMzjjYwfwAB1UoY5tc3E8
	 4kacsG7RjzdrD9tptuK892ThBzRyLRqtntVpSq1qhT5+vLHinuhSRrrT86e85zQjJQ
	 W4DnrwCvUe3cembYPPtvH30yNGa6mJF705ICWa9ZvtQAm9jmotYZ3QLKGxyG7rHXyX
	 r8dhGR51ZS+bGWq0N2UZIIGSVrYeSEIuXDbgNjqebOIuJsxuF/WcUIba05m/Zbx+bS
	 UGo76T1QTu8gOnftv+fPYRmIk6cUQKpddkmkjoVb/yCxe3CHSYBY604rpgiHiJUo/C
	 QZAeH/kIGlvvQ==
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
Subject: [PATCH AUTOSEL 6.14 143/642] crypto: octeontx2 - suppress auth failure screaming due to negative tests
Date: Mon,  5 May 2025 18:05:59 -0400
Message-Id: <20250505221419.2672473-143-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
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

