Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8122229952C;
	Mon,  5 May 2025 22:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485123; cv=none; b=tsgPWBbcTKwYaxKZWXYrT/0ZItcj6qb4C69yAUgXiH1LCUL86q6cNGk6BH39kEsRE6yNR3fyb/YsQHUAOv4tj5CONz3F8+hZetaC5XmiLQryFGp6iryVFQEjGN4jAVKSJFxRI9UMvexxhkCihuUCQGhhI8A45LEJnV8q/G/UiDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485123; c=relaxed/simple;
	bh=3w4xnCa7yz2sFPD98buYOotV9SZTKXDZt93rf+QO1JA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y56koy5LeuZoGh+/8zSUhs33APCjtqeQZUjgbeR1CudnTN86niolpF7k5/9uP7SPFqvl6MqpfRSCQ8LFPttxfGuNjTolcC3RpGPlI5E7hOtI5se+9/do6+Bys457iNxpWZft8VU/ufb9FYdm8LAvMI1bE9YetDNfid04hKXTu2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oC0c4UX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oC0c4UX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415EDC4CEED;
	Mon,  5 May 2025 22:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485123;
	bh=3w4xnCa7yz2sFPD98buYOotV9SZTKXDZt93rf+QO1JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oC0c4UX5uPqWKtljH+jWg2JICB2WIhRlw69pXRy/G+DscE4PXU4xYZBQoPp8XqWKB
	 Eo3Okjf2WLtghDbSm0AehsnXw6vkq+5qrTHTZMSiQNyB3fgpjRKQ9d33zAQhNT6Vxz
	 fkQt6syV+jB7bSNhxwqF9C0ASgnPpjLXVXJyLSIKcBup8bjIWZg2OgMaPD+gEdsRmg
	 oLRuMXdic4n0/Hc3zaeR02u2/DiKl/7nEpsdEbrGF8N7J0+lzdHbK3iJFHwodbgMPm
	 KS2cS55LNXEKacUrL1c9QfSbkax+xMgi7aHSUXgrkuDdghYhxIUHN5aUYXR57nKmT8
	 +SpchrKgU50/w==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Sven Schwermer <sven@svenschwermer.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	shawnguo@kernel.org,
	linux-crypto@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.12 172/486] crypto: mxs-dcp - Only set OTP_KEY bit for OTP key
Date: Mon,  5 May 2025 18:34:08 -0400
Message-Id: <20250505223922.2682012-172-sashal@kernel.org>
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

From: Sven Schwermer <sven@svenschwermer.de>

[ Upstream commit caa9dbb76ff52ec848a57245062aaeaa07740adc ]

While MXS_DCP_CONTROL0_OTP_KEY is set, the CRYPTO_KEY (DCP_PAES_KEY_OTP)
is used even if the UNIQUE_KEY (DCP_PAES_KEY_UNIQUE) is selected. This
is not clearly documented, but this implementation is consistent with
NXP's downstream kernel fork and optee_os.

Signed-off-by: Sven Schwermer <sven@svenschwermer.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/mxs-dcp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 77a6301f37f0a..29c0c69d5905d 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -265,12 +265,12 @@ static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
 		    MXS_DCP_CONTROL0_INTERRUPT |
 		    MXS_DCP_CONTROL0_ENABLE_CIPHER;
 
-	if (key_referenced)
-		/* Set OTP key bit to select the key via KEY_SELECT. */
-		desc->control0 |= MXS_DCP_CONTROL0_OTP_KEY;
-	else
+	if (!key_referenced)
 		/* Payload contains the key. */
 		desc->control0 |= MXS_DCP_CONTROL0_PAYLOAD_KEY;
+	else if (actx->key[0] == DCP_PAES_KEY_OTP)
+		/* Set OTP key bit to select the key via KEY_SELECT. */
+		desc->control0 |= MXS_DCP_CONTROL0_OTP_KEY;
 
 	if (rctx->enc)
 		desc->control0 |= MXS_DCP_CONTROL0_CIPHER_ENCRYPT;
-- 
2.39.5

