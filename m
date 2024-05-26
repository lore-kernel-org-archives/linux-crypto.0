Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954BA5CDE6;
	Sun, 26 May 2024 09:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716716578; cv=none; b=FCbsuxhwkK0Yp7FjeQR+EQGlTRyupXrGGEKbqEFBp92E0PMwdxgXbBRpNJ4nfX1hS7J91LPZHV0WwWK7pO3k0qQMB1wCEXTHIERJbRzU9A/2Vv9wLlSN0FGmU/S0RMXufmd3blNwGN6GGwiyjvm9dhXlUkQ6LieyRypBIZfD8e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716716578; c=relaxed/simple;
	bh=0ZuciJzVARnrTE1AxoBdp6YW8TmW18SE8EqJzx8eryg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMMT8WKloJKVcbXAFFIXIcHxfZHx7SB2qSLn7KsdrN5eh1Eo7GW5OS1AMv5mEeTQt6pQKx6AzEyY/tN7RlVCpBwjU3mloy2chlQn5tgWF4AbC8FKTkV14nv2iq0TN7ScdmM2S6uNticfVbNCaiuwYFp5lYxk1Ycc6kIs2547Rlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nYe3HjTC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nYe3HjTC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9195FC32781;
	Sun, 26 May 2024 09:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716716578;
	bh=0ZuciJzVARnrTE1AxoBdp6YW8TmW18SE8EqJzx8eryg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYe3HjTCHuqzYmII/0QunSvgtnF2aoPBzii6zwDF/2sVyQZcoMTKphzKwCL7D3znE
	 +RHn387jMSANL8o4KDs39HtUd18Pc7jTW53Y2rXjmCFKYLoX8ir4vqxRGZphAbz8B/
	 Bum8jqzp7J3oXeIpGfOG8F3O+/yxxqgXbTSZfhGN9KoNykMI/0qICAjHhIKmpJodF1
	 Wm3ML48EydpnmA1UKi1J/Wtm/s0fj+8FSxV3T0HZedTLETerrqLBLJlNMVLGzvl09s
	 u7L7VnCTa12fGP2heERiTTbDWUPsVulOYHuyl7f4XLmEw22kU1nVSYbDfeKFspysOe
	 i+qLnfdmYdPPw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	liulongfang@huawei.com,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 04/11] crypto: hisilicon/sec - Fix memory leak for sec resource release
Date: Sun, 26 May 2024 05:42:42 -0400
Message-ID: <20240526094251.3413178-4-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240526094251.3413178-1-sashal@kernel.org>
References: <20240526094251.3413178-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.31
Content-Transfer-Encoding: 8bit

From: Chenghai Huang <huangchenghai2@huawei.com>

[ Upstream commit bba4250757b4ae1680fea435a358d8093f254094 ]

The AIV is one of the SEC resources. When releasing resources,
it need to release the AIV resources at the same time.
Otherwise, memory leakage occurs.

The aiv resource release is added to the sec resource release
function.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index c3a630cb27a62..932cc277eb3a5 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -478,8 +478,10 @@ static void sec_alg_resource_free(struct sec_ctx *ctx,
 
 	if (ctx->pbuf_supported)
 		sec_free_pbuf_resource(dev, qp_ctx->res);
-	if (ctx->alg_type == SEC_AEAD)
+	if (ctx->alg_type == SEC_AEAD) {
 		sec_free_mac_resource(dev, qp_ctx->res);
+		sec_free_aiv_resource(dev, qp_ctx->res);
+	}
 }
 
 static int sec_alloc_qp_ctx_resource(struct hisi_qm *qm, struct sec_ctx *ctx,
-- 
2.43.0

