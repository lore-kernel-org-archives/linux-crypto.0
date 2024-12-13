Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10291E3760;
	Fri, 13 Dec 2024 14:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734098911; cv=none; b=GD31cNfdT/yNNq5qecQ+gZTZhEMkLp6PmMxssFFzouHoTjeRuFwrBWM2nsvMZGhA21C0bRo//YqPPvRfOnDMWpPi2o2g13AcIrbQFOAl/xbPM3P+0TgJraEixleBtNdcfjX5ASx+YwBE76s9vsri/YkL1vAlXdB01Ynv79/6YW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734098911; c=relaxed/simple;
	bh=YZWxxksRW0XFn6jn9rLNtKvpcDilJtfFiOmnCZsj6aw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sP+XNWozExTJDg90WQrhBXC7EOAj9YoGk+cWpa70udwYHkC1zqT1q7+GolfG6ImHE2nJh6kANWIghthQM30Hg+YrYffIfVi/6QeNJsgSRN5Kw0onHT+YgafO4kispjuS+1WXzh3l5CLlrSdhnJW59j3tbhmhhpbfrNTPggqjcCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=dqYJrG9Z; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="dqYJrG9Z"
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id DF2DE12002E;
	Fri, 13 Dec 2024 17:08:27 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru DF2DE12002E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1734098907;
	bh=fAcgV1r7oNNX9AxRnU+3mnq4q6Fxo7+EuYkriNujJnA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=dqYJrG9Zl2WrpsK5HbDS5INEvWbfF/Uvw8Ew20C1eJ0D9RqFhB+B9QtzgvbP9CWtA
	 ST/XN1HAa7RT0nVy2iY/UvqfcZXGbO6aCYwolLTvTbohQctGqhkO4dmrf6AZcM3RWO
	 ErEDcSsSc7GQi/fRvO0bh6QvNgfVNarUH6Sr/GB7RNjKjuV+XSo/5qV8QzctdowWGO
	 C5BJAk9+Vlo8TcyqNzr6eFjHCGw/Ox2nm8oAC4PacrTFtHqJJgK2KD9zo64s+7hrcM
	 bhtbMVUUS/YK/kzqZTuPB4cq/05br87O1M/gziP3k4iuJ1Cx+lZ+F3amF/w12a/7dW
	 SLuceTIaxyqJw==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri, 13 Dec 2024 17:08:27 +0300 (MSK)
From: Alexey Romanov <avromanov@salutedevices.com>
To: <neil.armstrong@linaro.org>, <clabbe@baylibre.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>, <krzk+dt@kernel.org>,
	<conor+dt@kernel.org>, <khilman@baylibre.com>, <jbrunet@baylibre.com>,
	<martin.blumenstingl@googlemail.com>, <vadim.fedorenko@linux.dev>
CC: <linux-crypto@vger.kernel.org>, <linux-amlogic@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kernel@salutedevices.com>, "Alexey
 Romanov" <avromanov@salutedevices.com>
Subject: [PATCH v11 14/22] crypto: amlogic - Add support for AXG-series
Date: Fri, 13 Dec 2024 17:07:47 +0300
Message-ID: <20241213140755.1298323-15-avromanov@salutedevices.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241213140755.1298323-1-avromanov@salutedevices.com>
References: <20241213140755.1298323-1-avromanov@salutedevices.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-a-m1.sberdevices.ru (172.24.196.116) To
 p-i-exch-a-m1.sberdevices.ru (172.24.196.116)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 189823 [Dec 13 2024]
X-KSMG-AntiSpam-Version: 6.1.1.7
X-KSMG-AntiSpam-Envelope-From: avromanov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 47 0.3.47 57010b355d009055a5b6c34e0385c69b21a4e07f, {Tracking_from_domain_doesnt_match_to}, smtp.sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/12/13 12:33:00 #26873825
X-KSMG-AntiVirus-Status: Clean, skipped

Tested via tcrypt module and with custom tests.

Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 6529ae24b75f..9452f05d2f10 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -290,6 +290,14 @@ static const struct meson_pdata meson_g12a_pdata = {
 	.support_192bit_key = false,
 };
 
+static const struct meson_pdata meson_axg_pdata = {
+	.descs_reg = 0x0,
+	.status_reg = 0x8,
+	.setup_desc_cnt = 3,
+	.hasher_supported = true,
+	.support_192bit_key = true,
+};
+
 static const struct of_device_id meson_crypto_of_match_table[] = {
 	{
 		.compatible = "amlogic,gxl-crypto",
@@ -299,6 +307,10 @@ static const struct of_device_id meson_crypto_of_match_table[] = {
 		.compatible = "amlogic,g12a-crypto",
 		.data = &meson_g12a_pdata,
 	},
+	{
+		.compatible = "amlogic,axg-crypto",
+		.data = &meson_axg_pdata,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, meson_crypto_of_match_table);
-- 
2.34.1

