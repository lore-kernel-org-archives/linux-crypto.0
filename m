Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF081CF8B
	for <linux-crypto@vger.kernel.org>; Mon, 16 Feb 2026 07:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771227968; cv=none; b=G2HZX/2u9fQnptoRG7TZjKwQYL2pH7XhVB5Quigup7oe9qVhkvWYwaOZmGiJRL4qn0h+XOkLDG1rbbPXz7JyhZi6uiVWu2QN9AB59+VhhZ4kkazgnBkLgtrNJQEUWq5elVCL+hhlFLvn+J48FG2O0dZx65u8sUxMrYLb9mEb2Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771227968; c=relaxed/simple;
	bh=h+OOEab+U7JqfLqZuXWtg2YBLqENHho+Xge8wtX7DTo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gr9Xaj31BSAD/Sz08P+Pk6Dq3QyCrfcEwxGFizOTFGeuV9nhwULaWxYTewTEERd9XCPIC4bCvwP9g//VH16KDSIcyDLiYoetcFRSXP1B1vUpLyHhGMDl5DvbAFgO6cNr7Ps/unYY/l0ZB5yK5Hs5sjx+mf0JW1ou5ri82GOESno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RZ52Jdyx; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RZ52Jdyx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771227964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RLvrlavvqhsMsZumdIpLoyT+Im13G14jyGnOLsn5bKE=;
	b=RZ52Jdyxe6XiQTHXDsQO6GihvOPBgC0lqv3st4LY4st0n6eYcTDf7S+11dnYK8nSGx/hyh
	bzgQBFfmjlJX9TUPTPKwh8k01uY2Nn7Jfr75wJ/nN4OLMcHT6o60Y8EDGTrUiiWnru4As1
	YGJszJkW9kRtVdpj5oYMoDVnJzrcmrg=
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
Subject: [PATCH v2] crypto: atmel-sha204a - Fix OTP sysfs read and error handling
Date: Mon, 16 Feb 2026 08:45:51 +0100
Message-ID: <20260216074552.656814-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Fix otp_show() to read and print all 64 bytes of the OTP zone.
Previously, the loop only printed half of the OTP (32 bytes), and
partial output was returned on read errors.

Propagate the actual error from atmel_sha204a_otp_read() instead of
producing partial output.

Replace sprintf() with sysfs_emit_at(), which is preferred for
formatting sysfs output because it provides safer bounds checking.

Cc: stable@vger.kernel.org
Fixes: 13909a0c8897 ("crypto: atmel-sha204a - provide the otp content")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Compile-tested only.

Changes in v2:
- Return the total number of bytes written by sysfs_emit_at() after
  feedback from Lothar (thanks!)
- Link to v1: https://lore.kernel.org/lkml/20260215124125.465162-2-thorsten.blum@linux.dev/
---
 drivers/crypto/atmel-sha204a.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 0fcf4a39de27..8af767f903ea 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
+#include <linux/sysfs.h>
 #include <linux/workqueue.h>
 #include "atmel-i2c.h"
 
@@ -119,21 +120,22 @@ static ssize_t otp_show(struct device *dev,
 {
 	u16 addr;
 	u8 otp[OTP_ZONE_SIZE];
-	char *str = buf;
 	struct i2c_client *client = to_i2c_client(dev);
-	int i;
+	ssize_t len = 0;
+	int i, ret;
 
-	for (addr = 0; addr < OTP_ZONE_SIZE/4; addr++) {
-		if (atmel_sha204a_otp_read(client, addr, otp + addr * 4) < 0) {
+	for (addr = 0; addr < OTP_ZONE_SIZE / 4; addr++) {
+		ret = atmel_sha204a_otp_read(client, addr, otp + addr * 4);
+		if (ret < 0) {
 			dev_err(dev, "failed to read otp zone\n");
-			break;
+			return ret;
 		}
 	}
 
-	for (i = 0; i < addr*2; i++)
-		str += sprintf(str, "%02X", otp[i]);
-	str += sprintf(str, "\n");
-	return str - buf;
+	for (i = 0; i < OTP_ZONE_SIZE; i++)
+		len += sysfs_emit_at(buf, len, "%02X", otp[i]);
+	len += sysfs_emit_at(buf, len, "\n");
+	return len;
 }
 static DEVICE_ATTR_RO(otp);
 
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

