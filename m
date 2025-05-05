Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119D62F3A63;
	Mon,  5 May 2025 23:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486884; cv=none; b=ptpXXJvg5dDZGVkqyvwzIMCY+Ks/rUYRTWoxIs382SyRXDe3nZncnMyWQVu2x/1l3+R3hKE6s62eC6QeKZ9QQOddxp33z7nFs32QH/0KBbv6guxQDJXOFoM9BsvKtIy4NNM8BuI1ekml9t7OJ6MnOKedD9eUiwwt1TU8xf7kl3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486884; c=relaxed/simple;
	bh=Y1nCOUYyEEMAjqY3ZzPW6+yjZTimEC9xDeL7HEYfkvg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UcdmLEb8VAm3i7K0zW2M+DgvIUfo4WIQJ2M1Am3XTthLIpncIyMBWa6m+uK9Mo+lOyAhlr1OmLKGbwaaYWycM9ZMHEzftejMDxbiXz/E8or93AQ7Q2OcqIdp+qqqdf8VPVzue5F+1l8vdENtWpFtgjrSZEmB/6CBm27Xd1EgW+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EYaTSbr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EYaTSbr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D373DC4CEED;
	Mon,  5 May 2025 23:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486882;
	bh=Y1nCOUYyEEMAjqY3ZzPW6+yjZTimEC9xDeL7HEYfkvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYaTSbr/kyfDkk9J4kryeeP+0buAiSXLXE6KmaMnYXQUk/IKxPxkhtkwIL/bOAg85
	 Ig5W8okyC/wntq7iMyx1Mi1ZEMjDMYbIr7liZZRyrH5mtIU9QlJarEitjCfIV73sxV
	 6E70COEw1B0+tAriFBDXlgHk59Sj3VizSAMv0U58uSIBMBqaQO2c0GnAH9u0E4V8e6
	 +ymmdyeegbgZBfxFfRg4Cbxk0jB2zyFpQ96V8WFFHYR6WdcE1IuVTG7cEJnsoNTgQc
	 pSKfaR924ruGrEFftQYKuV5VYGNuvmlhp6SvrAEO6rBGQmbxf54BY+3kLondsTN2Jj
	 HfLTX6R0qM4Og==
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
Subject: [PATCH AUTOSEL 5.15 041/153] crypto: octeontx2 - suppress auth failure screaming due to negative tests
Date: Mon,  5 May 2025 19:11:28 -0400
Message-Id: <20250505231320.2695319-41-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505231320.2695319-1-sashal@kernel.org>
References: <20250505231320.2695319-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.181
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

