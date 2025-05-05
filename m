Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467722820CF;
	Mon,  5 May 2025 22:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746483787; cv=none; b=JbusdVdnd03CUqYSUEL7Klb9gB1K/MN4M6Vn9ZajPrEOcuDJ3+y9pDZYAvfsc42fAibV8KmQci34PmKy7InJIVri12mnM+opdH6OVk/t/yXQSjBkhB5mgVe6ZVv8XEAElxHCo+bA/g3LL+9tN3L+LKG6/1o/eyhldCAHoKtr8bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746483787; c=relaxed/simple;
	bh=LLJphMoB/scWFhUMq04iybMYcAOBEZhyWhFBrETrC4o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dI744nRkPY9bxZJ47i2TrUyoeMOYhPxPgCyyoxP1SKFKUVI2GmfZDnFwKnzjWI7Bz0f0BGMSyZvK1r9pLGRIFEENbVfWbU8hSAvvkccgzMFplwoIB5AH9h+EYjlvJeTzBsktuSSwC/RaXkbP140SlQm/5s2MuzlfUvmwdVuUBHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DllBo6ki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DllBo6ki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A019FC4CEED;
	Mon,  5 May 2025 22:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746483786;
	bh=LLJphMoB/scWFhUMq04iybMYcAOBEZhyWhFBrETrC4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DllBo6kieUN2UWIA/fvl6GXL0gsIEipbnrtIS/KTNgD9ygaRS3M4fw5VQwwHFS8iP
	 JbH5XpgLd5/l3AOdsmXein94PbZurgp5QlxTM9Md4q/KZXr7z4LyqENgHYDTD1+Dv2
	 3u/jmjDz3BhkM2uwgWGWBpfnWzBFErJCuiUuMrOI+n72ZOn5IKnrRad2fDNv8ybyhf
	 7g4VcdGk+S3xketEgLC/7W/ym2I5kZM93IIOjCM8hp6XyS92pOaIAAJLLmX0FFt1OL
	 vqkPojw3OWTQeUOZ1xzqt+6nv1o4NNyyv1Nu9WoCrDVbCzsCR/Xqjf7689Uw/xCCeF
	 SzLF42vqb89AQ==
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
Subject: [PATCH AUTOSEL 6.14 217/642] crypto: mxs-dcp - Only set OTP_KEY bit for OTP key
Date: Mon,  5 May 2025 18:07:13 -0400
Message-Id: <20250505221419.2672473-217-sashal@kernel.org>
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
index d94a26c3541a0..133ebc9982362 100644
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

