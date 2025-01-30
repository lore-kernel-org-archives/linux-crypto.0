Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899801EE03B;
	Thu, 30 Jan 2025 16:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738254748; cv=pass; b=iy6x+ysyNjVfE1T1uydTfUUyiLDZhU8dwqtA858ivxSoFsntFDnjm8eT591NNVLWbHHlD70633pLxs8iPTW+qEQMDRXvYtDT+7rEUyQVgIXUL4Owck+v6oVR2clF+IcWokzIR5pKxlcNi7tNCwa9mk6r0D/MbCpMxXbkqLpB3R0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738254748; c=relaxed/simple;
	bh=H+faJSQERz6XlVXgIvWmgdDgoXnSY+tvteu/1tTDi6Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bAY03krxzy2LTYmK09wi8FEV8E9Refuod+huN5asSwm7NCEmOd7tbfFxbuT9mZjAqdAnl80kf1oNsLD+THhi6UWQ8uwW8weX0HdaQ5Qpzx9RGctZY1WGHvVtIPv1WgfIdwxFToS06XISl/g7RhAX8yrX3h04349KmD3q0MaNCck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=czPoU5by; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="czPoU5by"
ARC-Seal: i=1; a=rsa-sha256; t=1738254708; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=HzZyOzS0iI+diApu/Me9R9cQq2rPXqw6qolEUG0i4cqN5lSvk94dDo7bBxt5/LpZgixsUk5yhwuUXFcGoXNNuENQcmOOZpW0qMnwrsYNXhTJqB29M2Aoqvoo0MSdojr/006QvpfFIxKZ+FGkjPx9tMprrYQykBkJBeUFXmeNsDQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1738254708; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=G9OrBOk1WRWC9wWzqwllT47RSn682Pz6FtVpe94Ta+8=; 
	b=m+/3eKuJ7IfxarcwiARJsC/aDHjoQgKLaFA5aDQNqekygpFi5pByw7QDPtPqlQ/tmQIoxYJosfHwSeAXcFkz2ZJUg+jgHxfCeJ9xIDORe84ROnXSIrUVfRjV1ZFFHDcP5+vkTn/ZZxZY6mw3z0dFWTZE5vfX/pw+ECzBNl756Uk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1738254708;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=G9OrBOk1WRWC9wWzqwllT47RSn682Pz6FtVpe94Ta+8=;
	b=czPoU5by5qkdk/H4IEkIGWo2inh9yEQ8/QkI1OBG3+pzaHyjtQ3Fd9dBIkCnUwSx
	DN+Xf5L7tAP6Hd+b+IIS+yM7AN5RMW0F3m8bF/nvrMX3vMONXsNJVssf7EUNeHxgLqg
	VF0lKVWgZy84Crcbc+3K5PYXDENag1ud9ne9NFTc=
Received: by mx.zohomail.com with SMTPS id 1738254702522121.14800745094715;
	Thu, 30 Jan 2025 08:31:42 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 30 Jan 2025 17:31:15 +0100
Subject: [PATCH 1/7] dt-bindings: reset: Add SCMI reset IDs for RK3588
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250130-rk3588-trng-submission-v1-1-97ff76568e49@collabora.com>
References: <20250130-rk3588-trng-submission-v1-0-97ff76568e49@collabora.com>
In-Reply-To: <20250130-rk3588-trng-submission-v1-0-97ff76568e49@collabora.com>
To: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Daniel Golle <daniel@makrotopia.org>, Aurelien Jarno <aurelien@aurel32.net>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>, 
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 XiaoDong Huang <derrick.huang@rock-chips.com>
X-Mailer: b4 0.14.2

When TF-A is used to assert/deassert the resets through SCMI, the
IDs communicated to it are different than the ones mainline Linux uses.

Import the list of SCMI reset IDs from mainline TF-A so that devicetrees
can use these IDs more easily.

Co-developed-by: XiaoDong Huang <derrick.huang@rock-chips.com>
Signed-off-by: XiaoDong Huang <derrick.huang@rock-chips.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 include/dt-bindings/reset/rockchip,rk3588-cru.h | 41 ++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/include/dt-bindings/reset/rockchip,rk3588-cru.h b/include/dt-bindings/reset/rockchip,rk3588-cru.h
index e2fe4bd5f7f01569c804ae4ea87c7cf0433d2ae7..878beae6dc3baaa9a2eb46f7a81454d360968754 100644
--- a/include/dt-bindings/reset/rockchip,rk3588-cru.h
+++ b/include/dt-bindings/reset/rockchip,rk3588-cru.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
 /*
- * Copyright (c) 2021 Rockchip Electronics Co. Ltd.
+ * Copyright (c) 2021, 2024 Rockchip Electronics Co. Ltd.
  * Copyright (c) 2022 Collabora Ltd.
  *
  * Author: Elaine Zhang <zhangqing@rock-chips.com>
@@ -753,4 +753,43 @@
 
 #define SRST_A_HDMIRX_BIU		660
 
+/* SCMI Secure Resets */
+
+/* Name=SECURE_SOFTRST_CON00,Offset=0xA00 */
+#define SCMI_SRST_A_SECURE_NS_BIU	10
+#define SCMI_SRST_H_SECURE_NS_BIU	11
+#define SCMI_SRST_A_SECURE_S_BIU	12
+#define SCMI_SRST_H_SECURE_S_BIU	13
+#define SCMI_SRST_P_SECURE_S_BIU	14
+#define SCMI_SRST_CRYPTO_CORE		15
+/* Name=SECURE_SOFTRST_CON01,Offset=0xA04 */
+#define SCMI_SRST_CRYPTO_PKA		16
+#define SCMI_SRST_CRYPTO_RNG		17
+#define SCMI_SRST_A_CRYPTO		18
+#define SCMI_SRST_H_CRYPTO		19
+#define SCMI_SRST_KEYLADDER_CORE	25
+#define SCMI_SRST_KEYLADDER_RNG		26
+#define SCMI_SRST_A_KEYLADDER		27
+#define SCMI_SRST_H_KEYLADDER		28
+#define SCMI_SRST_P_OTPC_S		29
+#define SCMI_SRST_OTPC_S		30
+#define SCMI_SRST_WDT_S			31
+/* Name=SECURE_SOFTRST_CON02,Offset=0xA08 */
+#define SCMI_SRST_T_WDT_S		32
+#define SCMI_SRST_H_BOOTROM		33
+#define SCMI_SRST_A_DCF			34
+#define SCMI_SRST_P_DCF			35
+#define SCMI_SRST_H_BOOTROM_NS		37
+#define SCMI_SRST_P_KEYLADDER		46
+#define SCMI_SRST_H_TRNG_S		47
+/* Name=SECURE_SOFTRST_CON03,Offset=0xA0C */
+#define SCMI_SRST_H_TRNG_NS		48
+#define SCMI_SRST_D_SDMMC_BUFFER	49
+#define SCMI_SRST_H_SDMMC		50
+#define SCMI_SRST_H_SDMMC_BUFFER	51
+#define SCMI_SRST_SDMMC			52
+#define SCMI_SRST_P_TRNG_CHK		53
+#define SCMI_SRST_TRNG_S		54
+
+
 #endif

-- 
2.48.1

