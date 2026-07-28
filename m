Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0E33BB674
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 20:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785272329; cv=none; b=Mv6HHfPlqDKWbig3VUs6MI6/pzOhhT0HGU5FvFmS1QkkMyJ3Oam9s9hq1C8MB7J9aCsMQs8zVLWSe/GOS2yRRdvQy5xzYdITY6rqDU0OoPfvsxU5Z5tl9emyRX43y7xsMmdVEaCulaqq7Ikiqobjle5Xz/LSwmTecmP+OEiRGsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785272329; c=relaxed/simple;
	bh=lD5H0k2lSGSVpGxnOKY3vZo2BDaBYInh+gMUWUUxkRk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D01KGVqRmcWfOZPDZjCDSOZ8uGxG+0n+PvZvhIZOU+v4gn8ftsSx14YLIDPEdns/y8qjWaa5+Y4cRSUDjPK7i2pYS3W/v0I3oJu8OXAFnZpr7Fp4tPiXocMVhPIKS3uA7eoX7Rn/jhqxeMVdP76v40MgSo0SLvZMafuv/eUeia4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=URnoggRL; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="URnoggRL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785272323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hHfDxtXRviIyVvBGh7Iys+RpSMSujoxdzUaAudT4Lqg=;
	b=URnoggRLAi//Yn8I0oChl2VmZb3x2JvAVNV34sJNohP3Y1cDtn0TezrBeSMv8DmJDZr8JR
	3IyZXXn5GnAGFcnXunvc91g64lUi1G0h2CCrKXFtCGs4OJbpWHTi6p5fgRNZJybXE/UwT/
	1n4ZtPuyU21bEq8okCUr+SOZ8A4PtaQ=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: atmel-ecc - simplify control flow in atmel_ecdh_set_secret
Date: Tue, 28 Jul 2026 22:58:26 +0200
Message-ID: <20260728205825.471233-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=980; i=thorsten.blum@linux.dev; h=from:subject; bh=lD5H0k2lSGSVpGxnOKY3vZo2BDaBYInh+gMUWUUxkRk=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmZ4p8kLCtKbWq+z6+wiJDt2OOnY7DipFH91ofzIguvC n37YSPcUcrCIMbFICumyPJg1o8ZvqU1lZtMInbCzGFlAhnCwMUpABPJ92D4Hycr3Bb4QaazbcON XxtWS6ZuWCq60To3UeFxXWi37wOGIob/uZtubF/p9+Ybx6JHW3O2rI3nMn08YwsHh6VIqcCiNX/ 38AAA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Free the public key directly on I2C transaction failure and remove the
free_public_key label to simplify the code.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-ecc.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 21192a042fa2..f98782f0a2c6 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -107,17 +107,14 @@ static int atmel_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	atmel_i2c_init_genkey_cmd(cmd, DATA_SLOT_2);
 
 	ret = atmel_i2c_send_receive(ctx->client, cmd);
-	if (ret)
-		goto free_public_key;
+	if (ret) {
+		kfree(public_key);
+		goto free_cmd;
+	}
 
 	memcpy(public_key, &cmd->data[RSP_DATA_IDX], ATMEL_ECC_PUBKEY_SIZE);
 	ctx->public_key = public_key;
 
-	kfree(cmd);
-	return 0;
-
-free_public_key:
-	kfree(public_key);
 free_cmd:
 	kfree(cmd);
 	return ret;
