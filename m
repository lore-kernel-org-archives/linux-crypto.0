Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE75D35E92B;
	Tue,  1 Sep 2026 08:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250350; cv=none; b=OJ2VcgUfiDEZEDzCC/jpMxQLeYlGEfTACHLyPREhg5uZI7GT5O9l/86wuYJiRSI83ulnR1WxGWm08hynh6BzCzwKBj9tih3MBIMXv1kXjkoc7k0u9mIj0cJ87LfPKIp2VBOdAGrEESTBqgAmbaD+w7FyKYDm3W8shn1P6Ok0jUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250350; c=relaxed/simple;
	bh=lP4IcbhOCso8ldkbTMrdVP7Oezs/Fqa6rR5XKkHkloY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XLhDRpBeP+427LsWw9IAWqXYNCwgrNa4rG2xOe7WeUdQ5VxUrcmbiUWgbJ7sNIsO9eDDOEM0SjSEqaiL0DehHW9TMNEh7ZXp7Cv3g/sFiM1OewV/7mjXBitSomAUTOgtTQu8n/a01n9reqUqjM+Bi8B1r5Ff5K64REvlluQTvc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YbQjDD1f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YbQjDD1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2034D1F000E9;
	Tue,  1 Sep 2026 08:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788250349;
	bh=ifjEpv0OpaPqvPhZfHyatOOmfJhWqJigF07DwVGfQz4=;
	h=From:To:Cc:Subject:Date;
	b=YbQjDD1fvsxnh58EmpHbX59P2uesxx1/1452O70uZILJ5WGE4NJsb+UvxamAvIZYH
	 +pXdMX+bC7qAEGpnIvInPTFHdqACwfmRXTIiTsSpyuE7LFf9H/nTTG3yJirPamTEnU
	 qtx2LUFmFDpeVEGtXqZHABA1k4YrGfAAOVEd7T3c4B4WZDsOKJuMmBtmcN8kKOG/UY
	 aT0ExUai2x2uu2rMz9RBCnNarvSxYrB7sBKYk6QHrF2zBHx36wZqMnlH5UATRGrtBR
	 sXDrSj3kdtg74SCsJWUxht5u45qN+f/aPrhg1pekuuCpw8SxNbGdBr7nkv10v4zc3R
	 ZOUgCdyaBymFA==
From: Thorsten Blum <blum@kernel.org>
To: Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-ecc - simplify atmel_ecdh_compute_shared_secret
Date: Tue,  1 Sep 2026 10:11:27 +0200
Message-ID: <20260901081126.44790-2-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=897; i=blum@kernel.org; h=from:subject; bh=lP4IcbhOCso8ldkbTMrdVP7Oezs/Fqa6rR5XKkHkloY=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnTOtZ5dJ1VWaCx+earuw39E7IPXE0OcJnNfFc9+c/T8 Ouc5yq7OkpZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAi5qsY/pl9mcTds676y3rW ml9eotrbW7Za3ZvSPkFJS/33z5+sDF6MDNNcW/PdrjXe6+T49Pnsw/TeS9qnbWW22JgxrhSPt1r JxgkA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Free work_data and return ret directly to simplify the control flow.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/crypto/atmel-ecc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 075f38a67935..ad9f031cbc29 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -177,16 +177,14 @@ static int atmel_ecdh_compute_shared_secret(struct kpp_request *req)
 	work_data->client = ctx->client;
 
 	ret = atmel_i2c_init_ecdh_cmd(&work_data->cmd, req->src);
-	if (ret)
-		goto free_work_data;
+	if (ret) {
+		kfree(work_data);
+		return ret;
+	}
 
 	atmel_i2c_enqueue(work_data, atmel_ecdh_done, req);
 
 	return -EINPROGRESS;
-
-free_work_data:
-	kfree(work_data);
-	return ret;
 }
 
 static struct i2c_client *atmel_ecc_i2c_client_alloc(void)
