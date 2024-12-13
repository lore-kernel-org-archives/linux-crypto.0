Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2C31E0B86;
	Fri, 13 Dec 2024 14:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.18.73.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734098908; cv=none; b=g/vYfXRzh7jtnQPtlR1Yvw7S7K9Na8QgkgYiVUp6qxsGlwRj318jTTE7K3ETElFu2ATDBlFWAWpaLCfTkkbKZofKy0ae/ZpKJv4dptBzPpSiAAG61H9JDkDSEfcLMrRfd+caBdokk9BPUdx7V/A3TWvzZzelzrKQhEsMfjBCqVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734098908; c=relaxed/simple;
	bh=Vo0MsS+H+TxscqIXVjbbsvo9pafIs0cGbqTf1/JjM1E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q1SMznYGIp3ame+Q+tjrwI3aWWxo04Fx7KDvqdA5ZMkXzMXHOTAJb6j/U3pd/0amW3Lo8d5YRNfuIaBXz7yviKDpCELpIyXxDFYPUVmrof0jSFyI0LQvqZblQeyxmohngUcpnjFqu/nlITSOvEdwzJFgvrY/vWusQVELSz/gNb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=evShQP/P; arc=none smtp.client-ip=37.18.73.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="evShQP/P"
Received: from p-infra-ksmg-sc-msk01.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 20B1E100028;
	Fri, 13 Dec 2024 17:08:21 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 20B1E100028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1734098901;
	bh=d6BPrifupscmjIDZDQZM1FWfnOb6tdoBUYZfkPEmwss=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=evShQP/P4wUe54RZPpCLtymbRMMxSRWQrdLOpxr5g4597Uc+dPUEDcCTAn9GTZhdc
	 k5sQxByFndQyRkZsrxsH7Zg9azGhO2eoFsn/H3pwSrYbh7JLoykwRMCeZgbJaY62S/
	 HLit4ZlCTaxvkmLXFFZaGCDDKRYeLKUNX4pWGRrs74XuCkQkz1QALY2ltpWIy9Rm4E
	 I9FK98thXUqmOYhiHLINBuNZPALjHIR4puJTU6dthrtknJ4EIOAQAfecOP2dOEi8J3
	 u40fJJo103fn3iH8ED3SZlSX38SHoWjwvo6IyRzCFiVcxf9dLEmmk2QlaFMZ3BgP/m
	 dhvNXw+mpmNzw==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri, 13 Dec 2024 17:08:20 +0300 (MSK)
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
Subject: [PATCH v11 12/22] crypto: amlogic - Use fallback for 192-bit keys
Date: Fri, 13 Dec 2024 17:07:45 +0300
Message-ID: <20241213140755.1298323-13-avromanov@salutedevices.com>
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

Unforunately, not all Amlogic SoC's have a 192-bit key
support for AES algo. In this case, use fallback.

Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 7 +++++++
 drivers/crypto/amlogic/amlogic-gxl-core.c   | 1 +
 drivers/crypto/amlogic/amlogic-gxl.h        | 2 ++
 3 files changed, 10 insertions(+)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index df42940f1112..6070ee6b488e 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -41,6 +41,13 @@ static bool meson_cipher_need_fallback_sg(struct skcipher_request *areq,
 
 static bool meson_cipher_need_fallback(struct skcipher_request *areq)
 {
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx_dma(tfm);
+	struct meson_dev *mc = op->mc;
+
+	if (op->keymode == DESC_MODE_AES_192 && !mc->pdata->support_192bit_key)
+		return true;
+
 	if (areq->cryptlen == 0)
 		return true;
 
diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 706db22b9f65..0f4b3db85031 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -279,6 +279,7 @@ static const struct meson_pdata meson_gxl_pdata = {
 	.status_reg = 0x4,
 	.setup_desc_cnt = 3,
 	.hasher_supported = false,
+	.support_192bit_key = true,
 };
 
 static const struct of_device_id meson_crypto_of_match_table[] = {
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index 409141851cae..9c74f70df068 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -94,12 +94,14 @@ struct meson_flow {
  * @reg_status:	offset to status register
  * @setup_desc_cnt:	number of setup descriptor to configure.
  * @hasher_supported:	indecates whether hasher is supported.
+ * @support_192bit_key:	indicates whether platform support AES 192-bit key
  */
 struct meson_pdata {
 	u32 descs_reg;
 	u32 status_reg;
 	u32 setup_desc_cnt;
 	bool hasher_supported;
+	bool support_192bit_key;
 };
 
 /*
-- 
2.34.1

