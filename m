Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668F51E25EC;
	Fri, 13 Dec 2024 14:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734098909; cv=none; b=rOKeLjt67KKE2HKdmv8gaBLu113grjYKd8RujGJEkp5jNp/Bht3rp/TaqohCNlx+tiwzeSWK4YIO+YZJ6qElRuYoCzSSOnN6CNcrMkCsjBfXH/feHDFKi9RfzUjGLN8tdo2MjliFkRcHxX7bBU4woDO4nBbB5LlmcjBf182kCjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734098909; c=relaxed/simple;
	bh=6zDnCmK0Cp/QUZqRbQsZg9nX3KABCbknqvxd9i796iQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s8KtaPp2LAq6JD9Q0FpXJTWhQRqpmbwf94YKs22NpZPbMj0YJVLyxUu15xnGO6AQWL2wB9KLzelNH1zA4xSQhfB8lFFiLuoez+UNjUeKQsVxLw9h/ziLLopoDqLlHxJuAGYH8yiCVA9ebmaBtFUB6LlnHfrzghB4lvr8R2w0bSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=T0s0RTcs; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="T0s0RTcs"
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 8ED0712002D;
	Fri, 13 Dec 2024 17:08:25 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 8ED0712002D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1734098905;
	bh=NlTgjLiDZB3+EThS0OjBAYlr2cUeyj8y7VZ7+LTPTmY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=T0s0RTcsYh+tq+G9iLzn6qRJ5hLrpNXzPOT+hl7KG78anIHk9823KnEgrKoIabCKN
	 n/mSX2lLPIwndwXSSnoyzz3vJOlMIxlK9yU26CQ1EKcZ8IWf/8Btb7iliTFWlzp+do
	 8nEb7MGjI/2x6nzz9S8Q03MBTpiF1brYrKrm+lP+mIAKm+pnTSpDUkagOofoBi33+5
	 lf9A/N2iAFTHV2h8w2eVksuXmZGwb6c+pUWJE6o9YB+gor4unAZu9joqhXUlc88ReL
	 /+vkSWuvbHSyjIAVryg5d/jmOVeErLvb5SabSa5BqLtqkDgJq624LHuYqm/XriwL4N
	 iOVpbikQNH3dg==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri, 13 Dec 2024 17:08:25 +0300 (MSK)
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
Subject: [PATCH v11 13/22] crypto: amlogic - Add support for G12-series
Date: Fri, 13 Dec 2024 17:07:46 +0300
Message-ID: <20241213140755.1298323-14-avromanov@salutedevices.com>
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
index 0f4b3db85031..6529ae24b75f 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -282,11 +282,23 @@ static const struct meson_pdata meson_gxl_pdata = {
 	.support_192bit_key = true,
 };
 
+static const struct meson_pdata meson_g12a_pdata = {
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
 		.data = &meson_gxl_pdata,
 	},
+	{
+		.compatible = "amlogic,g12a-crypto",
+		.data = &meson_g12a_pdata,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, meson_crypto_of_match_table);
-- 
2.34.1

