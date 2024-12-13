Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C783E383;
	Fri, 13 Dec 2024 14:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.18.73.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734098912; cv=none; b=a0LF0XDk8cplE/gBLtGP48JH59qtZkaxUtueq7e7zStxMFoki8b60CP+sPg/+xJFCD8OSlQspiAFb+Isb9OnhjwDdjyitCUSRBbjijTiB0pn+iiu2nKvKCNUqq9wJoDVUxFEi1BwvT8uvDExBS0gO4oEkbjfA2lsFTowifN0O8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734098912; c=relaxed/simple;
	bh=SKHuXu9YPlBn9V92FYpaIh5e5lAMJ5IXNWPh5V7t12s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jKayzDNXBy6RTPfAru3bDuMGveW4yNJRIvUh7sbEV++CUDQXSTqxbHRrf+W0aXcp37Eu+O1EZy5wSM5cb2EGEEM/ZytGKl8b5CVxgLYCatVh94twmb8wQE3ZK9vFNOB3ivGndpSHeXyE6uHVpu5excf7QwhPrH0oRPYjNfwQrxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=o3TuU0v/; arc=none smtp.client-ip=37.18.73.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="o3TuU0v/"
Received: from p-infra-ksmg-sc-msk01.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 10DC310002C;
	Fri, 13 Dec 2024 17:08:29 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 10DC310002C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1734098909;
	bh=LJlG70JtBlnjpPCQMnY1PE8mfw0nNx3w6EaNQEUmDSU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=o3TuU0v/PdTUGJjexkY1nQgrwze+Hg5Tm2+dvntPirIpYllgvlFwSw0PJjB3w3Vip
	 taPaKxysAsKDs2PzzIUwXFXuNk/3oOgdOTMA7atxwmFc6aICYgrhAZrkiObBztYhMG
	 GFQSRnd0MD1Az7wS/Dj5vJGj6fCP1/BimMU6TDhTfGk8koJLVofv4ebiXOzXJEMf39
	 QSRMJQ5w16io4a2DsHnmUMFfTNHl2YGG1wHjGn6iwyq5LvBZgmpTeNDVcyctUYT6oM
	 Dmne6rTdQjjW2+51uaA6/ccJyRO0xbLcsS6V65Cj8s2V00cgbWxLtMfgzGZzb0e2sl
	 2Ld5dnSUdvlJQ==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri, 13 Dec 2024 17:08:28 +0300 (MSK)
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
Subject: [PATCH v11 15/22] crypto: amlogic - Add support for A1-series
Date: Fri, 13 Dec 2024 17:07:48 +0300
Message-ID: <20241213140755.1298323-16-avromanov@salutedevices.com>
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
X-KSMG-AntiSpam-Info: LuaCore: 47 0.3.47 57010b355d009055a5b6c34e0385c69b21a4e07f, {Tracking_from_domain_doesnt_match_to}, smtp.sberdevices.ru:5.0.1,7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/12/13 12:33:00 #26873825
X-KSMG-AntiVirus-Status: Clean, skipped

This platform data also can be used for S4 as fallback.
Tested via tcrypt module and with custom tests.

Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 9452f05d2f10..55a35697c0d7 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -298,6 +298,14 @@ static const struct meson_pdata meson_axg_pdata = {
 	.support_192bit_key = true,
 };
 
+static const struct meson_pdata meson_a1_pdata = {
+	.descs_reg = 0x0,
+	.status_reg = 0x8,
+	.setup_desc_cnt = 1,
+	.hasher_supported = true,
+	.support_192bit_key = false,
+};
+
 static const struct of_device_id meson_crypto_of_match_table[] = {
 	{
 		.compatible = "amlogic,gxl-crypto",
@@ -311,6 +319,14 @@ static const struct of_device_id meson_crypto_of_match_table[] = {
 		.compatible = "amlogic,axg-crypto",
 		.data = &meson_axg_pdata,
 	},
+	{
+		.compatible = "amlogic,a1-crypto",
+		.data = &meson_a1_pdata,
+	},
+	{
+		.compatible = "amlogic,s4-crypto",
+		.data = &meson_a1_pdata,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, meson_crypto_of_match_table);
-- 
2.34.1

