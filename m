Received: from mail.schwermer.no (mail.schwermer.no [49.12.228.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E0718FC9F
	for <linux-crypto@vger.kernel.org>; Mon, 24 Feb 2025 07:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.228.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740382964; cv=none; b=hZfixt/PAqSWpyTCYNcRwPSpr+FK7WmXmb2W2XKSNWIBgtklAn2DHbAtmAIUzyGZn3oTZKe3KS2x90sTofvdV26V88z2cj78sCS2XQ0DngyZmsLpgmOgbh1SF506QsDjN1ZC6H7Ihg9jfPZjGdaQuD0Lw8bfWNfRCUeR0E6ZBr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740382964; c=relaxed/simple;
	bh=bT+R5Ojp3C/Y6vHxHYv68xmOfTEq/NnXIfrdP3PsGAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qe3g6rtxAsM0e6Pp+e3AkvWlUqiYZ9fYC85by39fkqyq+jX2ORSJwfrrohh+9eda67x4m99osJwLZdCLyOwCRjk/j5ynsthycyK0akFuby/PymG0LEETJb5yA8mOpXQPuZwX90V3XBKcXQJ5aE7rtZIhKx39SqGlJBg2qkqbHrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=svenschwermer.de; spf=pass smtp.mailfrom=svenschwermer.de; dkim=pass (2048-bit key) header.d=svenschwermer.de header.i=@svenschwermer.de header.b=c7r8UN3M; arc=none smtp.client-ip=49.12.228.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=svenschwermer.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=svenschwermer.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=svenschwermer.de header.i=@svenschwermer.de header.b="c7r8UN3M"
X-Virus-Scanned: Yes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=svenschwermer.de;
	s=mail; t=1740382959;
	bh=bT+R5Ojp3C/Y6vHxHYv68xmOfTEq/NnXIfrdP3PsGAk=;
	h=From:To:Cc:Subject:In-Reply-To:References;
	b=c7r8UN3MwWgh+nEMw00FR2EQFDvLpx+twva7MGNljwnEif+63hXDBkFMxtn7vBWZ3
	 cFsbIJxTOsmIfgHJ/3KBftGTMSRRMVI5f2ZpMzMwo29i8d3Dsw30nHAbGTejReH+RE
	 VQrKae3+FUIkflXGB8vhn+GmIYE2uUkkU//nB5g+pd+NGvF/BKEcPqpBq/JQR887vC
	 Y4S0QJSp1rWWxAOD/z6JIBMoRGVX40VHTX4vOQpggsB1pwXOXsroSiypLTNcgbaj6V
	 BcMOOG6obPeFtqi49lXioJVrxuk9lSnZ7Q3mXIaEbPeJhZbbd9KoCBgErNSY+RnCp8
	 /kdFaqsMadOMw==
From: Sven Schwermer <sven@svenschwermer.de>
To: linux-crypto@vger.kernel.org
Cc: Sven Schwermer <sven@svenschwermer.de>,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	shawnguo@kernel.org,
	s.hauer@pengutronix.de,
	kernel@pengutronix.de,
	festevam@gmail.com,
	imx@lists.linux.dev,
	david@sigma-star.at,
	richard@nod.at,
	david.oberhollenzer@sigma-star.at
Subject: [PATCH 1/1] crypto: mxs-dcp: Only set OTP_KEY bit for OTP key
Date: Mon, 24 Feb 2025 08:42:25 +0100
Message-ID: <20250224074230.539809-2-sven@svenschwermer.de>
In-Reply-To: <20250224074230.539809-1-sven@svenschwermer.de>
References: <20250224074230.539809-1-sven@svenschwermer.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While MXS_DCP_CONTROL0_OTP_KEY is set, the CRYPTO_KEY (DCP_PAES_KEY_OTP)
is used even if the UNIQUE_KEY (DCP_PAES_KEY_UNIQUE) is selected. This
is not clearly documented, but this implementation is consistent with
NXP's downstream kernel fork and optee_os.

Signed-off-by: Sven Schwermer <sven@svenschwermer.de>
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
2.48.1

