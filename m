Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819AE1F3B87
	for <linux-crypto@vger.kernel.org>; Sun, 15 Feb 2026 20:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771188761; cv=none; b=p4iOMkQvqorJO50MCXy8MltvM0rY8eiVSq7ZrtBG115zqYR+/ReYItLO0GNahq8mV9idIOkRWnKtkINpb7ucG46YdGlOStu5kg6r1ijyF1bQVdMzg7V+UaZQdOl8A8Kw2x2Bk1dZRajKlbxsU1t8814RbDNzV9LXIm/xoqR5Vwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771188761; c=relaxed/simple;
	bh=IaRfvG8hmQqdCiU5gHdwwHAEt2t/xdCLu/2rHPHDMBY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AdNF2inJDIqtOw+bo18ub6FRV2Ux9kf1glNVYIDyUTv9vSwp+57KKyjt+yvx6mj5TsecNVRlZlHOXTN+E25kCz5fyOfvtoW5jkw/DGzvOzX39ujrBQt37WyT58Vll6PkdrPJVSQiDpWp3enxNb9Re/ehlq4X4l+vSdnKqYlAFKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MyDr4+eu; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MyDr4+eu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771188757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Y4yLFGf0HuJyxk3nhKGUWRxXjLXHz3M7orS/XBgijeE=;
	b=MyDr4+euL02IC4+VXxYcvssTN0X0GLTlmegXORHSNzzOSyvjqXycitdGbS8kjNWcRdWxz1
	eYUleSUGyg/uhoEXwIkjtopdVJyiPqvrnP/JHY+I7QhPWaqEW0QRJWjbzJsCUsMIsh1wq3
	IadfEfh2clOZk1Xz5e38pTRw7TEQ6GM=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Lothar Rubusch <l.rubusch@gmail.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	stable@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-sha204a - Fix error codes in OTP reads
Date: Sun, 15 Feb 2026 21:51:53 +0100
Message-ID: <20260215205152.518472-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Return -EINVAL from atmel_i2c_init_read_otp_cmd() on invalid addresses
instead of -1. Since the OTP zone is accessed in 4-byte blocks, valid
addresses range from 0 to OTP_ZONE_SIZE / 4 - 1. Fix the bounds check
accordingly.

In atmel_sha204a_otp_read(), propagate the actual error code from
atmel_i2c_init_read_otp_cmd() instead of -1. Also, return -EIO instead
of -EINVAL when the device is not ready.

Cc: stable@vger.kernel.org
Fixes: e05ce444e9e5 ("crypto: atmel-sha204a - add reading from otp zone")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Compile-tested only.
---
 drivers/crypto/atmel-i2c.c     | 4 ++--
 drivers/crypto/atmel-sha204a.c | 7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index 9688d116d07e..ba9d3f593601 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -72,8 +72,8 @@ EXPORT_SYMBOL(atmel_i2c_init_read_config_cmd);
 
 int atmel_i2c_init_read_otp_cmd(struct atmel_i2c_cmd *cmd, u16 addr)
 {
-	if (addr < 0 || addr > OTP_ZONE_SIZE)
-		return -1;
+	if (addr >= OTP_ZONE_SIZE / 4)
+		return -EINVAL;
 
 	cmd->word_addr = COMMAND;
 	cmd->opcode = OPCODE_READ;
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 0fcf4a39de27..6b4e2764523e 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -94,9 +94,10 @@ static int atmel_sha204a_rng_read(struct hwrng *rng, void *data, size_t max,
 static int atmel_sha204a_otp_read(struct i2c_client *client, u16 addr, u8 *otp)
 {
 	struct atmel_i2c_cmd cmd;
-	int ret = -1;
+	int ret;
 
-	if (atmel_i2c_init_read_otp_cmd(&cmd, addr) < 0) {
+	ret = atmel_i2c_init_read_otp_cmd(&cmd, addr);
+	if (ret < 0) {
 		dev_err(&client->dev, "failed, invalid otp address %04X\n",
 			addr);
 		return ret;
@@ -106,7 +107,7 @@ static int atmel_sha204a_otp_read(struct i2c_client *client, u16 addr, u8 *otp)
 
 	if (cmd.data[0] == 0xff) {
 		dev_err(&client->dev, "failed, device not ready\n");
-		return -EINVAL;
+		return -EIO;
 	}
 
 	memcpy(otp, cmd.data+1, 4);
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

