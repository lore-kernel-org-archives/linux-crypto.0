Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB993074AC
	for <linux-crypto@vger.kernel.org>; Thu, 25 Sep 2025 16:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758818455; cv=none; b=Y1cu1CUM/IJhtSJM0Zh9pNvcX5hBt4o/zna/1h0G+tN0cuxliNFaXJHlZH54vFp4/0PuXb/bL3eXfNUCBy5DxA+OVx/D2R23EQ0/syrZNUbL4checn+BOlLlPgMtBI0+BRNNj7zr/+AKhhWQ1blHKF3oERGbGkrgDUFSmTP0eD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758818455; c=relaxed/simple;
	bh=5bKaIyYtkl+MP8Bbq3igxb/jXbBeVFx0aqkgSriTev0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vev8Xc0DwlUSqpdDDpXxKGejber87ma5YEVWaHLjWX3EFDwd2+4sYXV9IDwCUbVf8aw/tqNEWquhZ50SUeHN72+sjPx8td2il2i1mzo6Yzl3wtZaJ+RIeMao9IdQIGWZz48dOKfMijTN0ALEN+/ZVHUWy0biSTQVTmvY8HQlUxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e7a2QSA2; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e7a2QSA2"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3f42b54d1b9so1428803f8f.0
        for <linux-crypto@vger.kernel.org>; Thu, 25 Sep 2025 09:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758818452; x=1759423252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2eyp9Gi1dreOzDe7chY8j7wPpNbM6pbeZ96TyLDdfpM=;
        b=e7a2QSA2TOGxL50CH7x8FYWAIaHtCmjWVXSJlEEaHykFssFgAUUaSzl9CA0iI3OQd+
         S2PxDRp0mhh53lnxRnsuXgT7N/YMqMtrdP0E4ZgdYfeTDMa75XQrt4mnTfihLKNLyTr5
         M7rgK6KPpL6A5Uq0t+Bo+53aXuuABxmePeJkVPtzFGf4/JG1GV7IwoG79CG/3cibaJNM
         dSHtqTzgl7frw4fRw5y7jb63Qc5gk11Cz+PPnBpQjYCiPuH6HrL9UxCK2GYWIygZCn5K
         lNBDOjU0uShScE4bwA2qLeJcG3N1lmbhhxbYjxuBOIJuICNU42pi93ajw0R7KE9jNBaY
         Zb/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758818452; x=1759423252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2eyp9Gi1dreOzDe7chY8j7wPpNbM6pbeZ96TyLDdfpM=;
        b=vg4qsz/yZAVBXIMmqOQce1uGRcdKGNV/nytokoH8mte+vGCOmbKVEUqdP0hRci/20j
         /DuNIIQsHnuYdC8NuhajzjD2HpJrjQHo/y40ILfEiqdLyBRMUej5Qc98dtz2VKrVRAo6
         kPCsPLKHmjsbjqyfz4CwShCLaJyr8HGd4XNYtoSjdaaWKlNSYZHuEZaAoI87bJWg27uo
         L1F9JnyfDCdlyYyQpsR5O82gv/Asqn+iYGfGjc46RuVLKi/nisgo4l3NN3CZtDfER/ZK
         ON8r90kSmjz1g0vzxdv128SdKAXByQMD1ZF9lZsNJot1qw6LK/hca1ADq5GdBsJOAICl
         LgJw==
X-Forwarded-Encrypted: i=1; AJvYcCUfmh+/FFuM1Fc6LJGYyj3mMinp01giy2kpsoRcD4cbwBktXySEQWySO0p4rH8A7ukFHqx9StkzvgwiIxc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRyj1RWaFFC0I0eVaD8zPOXnmOPcpbOFRMUAMNOFVUe69cDlHx
	PFQAoJIZYXHUE3bNrPPZARxkGqIzceBj++wm/pdjosRfCeRTU99sQ3fd
X-Gm-Gg: ASbGncs/7OBcBjfE4qDZtSdEBy7gJL6OKRBl1Tx3BYUfhHblEni6BQswdiHwChTM5JB
	lr/od5NfPqPcZQz14XWYqFHFjpJb6eFhkm59DOnJ+P6LnKfzVTR5BGejAAS8LU/7KdM+OQvyrqw
	7vLA/X0sOnqGbliwL6ndlU+3UTXE9SPW8/ccJdgRCtIoDShOxqpCJtThKNy6ct1PFDIcd2/dXS7
	yAokYXtCJ5ZTHdAcH9hfd3AG2sqmb7AusVf4ff6gTdECuTj+Qf7TC0T0SjJVfg0U6eYJnJyaSMb
	RRjWsSz+mJeQ/Wu2kjZfAE3O5Dly6QvXeFQZSixMxy44yCQzx2MTBpm+lLef8Xawpzlf/L8GsZe
	IHCsjpLo8iXY1scVA+7RbPEAQZ6RcjpYPdDVJeny3MxoLgIUlMhJaXH5Eus3w6V2zreU3dPFjgB
	ns4qjuUg==
X-Google-Smtp-Source: AGHT+IFuboP96UTpd7Lrf1lzxKViS1D5GdrbEgDmgGvbVgns+3irooGx/K0KSA4xhs66h89FOOvM5g==
X-Received: by 2002:a05:6000:3102:b0:405:3028:1bce with SMTP id ffacd0b85a97d-40e4886dea7mr4262966f8f.32.1758818452397;
        Thu, 25 Sep 2025 09:40:52 -0700 (PDT)
Received: from Ansuel-XPS24 (host-95-249-236-54.retail.telecomitalia.it. [95.249.236.54])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-40fc6921f4esm3591904f8f.44.2025.09.25.09.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 09:40:52 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Felix Fietkau <nbd@nbd.name>,
	John Crispin <john@phrozen.org>,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-watchdog@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH v3 2/4] dt-bindings: watchdog: airoha: Add support for Airoha AN7583 SoC
Date: Thu, 25 Sep 2025 18:40:35 +0200
Message-ID: <20250925164038.13987-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925164038.13987-1-ansuelsmth@gmail.com>
References: <20250925164038.13987-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add compatible for Airoha AN7583 SoC. The implementation is exactly the
same of Airoha EN7581 hence we add the compatible in addition to EN7581
ones.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/watchdog/airoha,en7581-wdt.yaml     | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/watchdog/airoha,en7581-wdt.yaml b/Documentation/devicetree/bindings/watchdog/airoha,en7581-wdt.yaml
index 6bbab3cb28e5..6259478bdae5 100644
--- a/Documentation/devicetree/bindings/watchdog/airoha,en7581-wdt.yaml
+++ b/Documentation/devicetree/bindings/watchdog/airoha,en7581-wdt.yaml
@@ -14,7 +14,11 @@ allOf:
 
 properties:
   compatible:
-    const: airoha,en7581-wdt
+    oneOf:
+      - items:
+          - const: airoha,an7583-wdt
+          - const: airoha,en7581-wdt
+      - const: airoha,en7581-wdt
 
   reg:
     maxItems: 1
-- 
2.51.0

