Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBE8214A66;
	Tue,  4 Feb 2025 15:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738683465; cv=pass; b=ac4BZZFl1KSL3Js1D18m+aapkrMAmJ0adGlouhkZcQTxcLB6weTgVD1wwUgDwGme1HDxcq5HbxqFDstjxvGeYwmmowyoI8j19UIUx8HVuLugyGcq2vsOX8JVENijJY31jeB2W+gneXOfYO5McVdrmAHXQbDUl1XcVdJW9/neI1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738683465; c=relaxed/simple;
	bh=ej/o4cJTTIHJl837+qTjEsvcPeb+gw3vdk7Zvl80cEw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cKtU79f8Vtzro54np/mOHKbF4+uQEVq/fsiXtl1LzkNm8hpHnZ/fxNj+mc15xiAyI65e2M/RQMuDpAkNPj/XETVpkvatjJKxNqAelWCLxp7KqUBwAUHSVAt74jbj9ktSisLx+vDeUjvTPaSRaRVBxS01q92sxLwHgOHRPhEw2mw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=DXzJxLQF; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="DXzJxLQF"
ARC-Seal: i=1; a=rsa-sha256; t=1738683433; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=AvmAv3ZMNNQjKa92Q6A2zTNwgoxiWnuPZzRppLkhkGNhZTOwYvFJ0ieCOJkgvakEiC3gTdK7ZskBm+GinrqsWsKrf2kyGLJZBpvJ76vkdJau6YA3gRi1+tfvTqavfFwjqcM+8uJQQbcFK3yNGB9KvKAtBA91HlkUu+aM0cwP/Fw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1738683433; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=BUfhFIAuuxHyoIK02RnTA8La0/z0w6Oz5SQr/C+g/RE=; 
	b=BZhD3Zacf06Fmqn84zREbGo0msErPb0U58lhgoqwReNycuGx4TzkfpIka2KhKh+j2xWgF2j1rcKPDL8Vm3zjV7q5MK15Cq8g7eGVJTYuDuVPCFXpR9qS2h9AIVx4jw/F/bSkoItarHChVzxI5RLkOL9FvAqYJlQzr2fMifuWVZA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1738683433;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=BUfhFIAuuxHyoIK02RnTA8La0/z0w6Oz5SQr/C+g/RE=;
	b=DXzJxLQFAlVb8TqTDspK5pXb87qZEYvLfBtpV3b2+T4pRghR4U9PhIyqi7AGjuKm
	YlVwBQz+fJ4MwKy8/6uVzOapV01IScLgUYAkqR5fXQm5z53v39J74qlFupKgTQzWEUa
	kjn/P6i44WKej6TjjUfHLMvxqw6UKy0QHrQz63AM=
Received: by mx.zohomail.com with SMTPS id 1738683409157388.8818067976115;
	Tue, 4 Feb 2025 07:36:49 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Tue, 04 Feb 2025 16:35:52 +0100
Subject: [PATCH v2 7/7] MAINTAINERS: add Nicolas Frattaroli to rockchip-rng
 maintainers
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250204-rk3588-trng-submission-v2-7-608172b6fd91@collabora.com>
References: <20250204-rk3588-trng-submission-v2-0-608172b6fd91@collabora.com>
In-Reply-To: <20250204-rk3588-trng-submission-v2-0-608172b6fd91@collabora.com>
To: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Daniel Golle <daniel@makrotopia.org>, Aurelien Jarno <aurelien@aurel32.net>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>, 
 kernel@collabora.com, devicetree@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, 
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.2

I maintain the rockchip,rk3588-rng bindings, and I guess also the part
of the driver that implements support for it. Therefore, add me to the
MAINTAINERS for this driver and these bindings.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 256d0217196586d179197393e46a1e78da850712..7daf9bfeb0cb4e9e594b809012c7aa243b0558ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20420,6 +20420,7 @@ F:	include/uapi/linux/rkisp1-config.h
 ROCKCHIP RK3568 RANDOM NUMBER GENERATOR SUPPORT
 M:	Daniel Golle <daniel@makrotopia.org>
 M:	Aurelien Jarno <aurelien@aurel32.net>
+M:	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
 F:	Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml

-- 
2.48.1

