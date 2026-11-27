Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780925;
	b=dLLeaXokVocizxl/Qbmd3Vo4RCsOqUCxpErcDcaUvuXEKMRLUd/iaLvyjKL2YZE2cyyb
	 0rRUsFW5bY3xoWptNdtp7da+wvpR9AzK6CHrJumDKQ2jIZZzzrdHC9V/KHNLQjGuX06me
	 RvXxVyei+JWIRyUi/QyxhPIb+5+EDBM0N1CXQDikWLrnsW3nf/6UDblr1bR6vX/7tHb1X
	 Jc4VVt0BZfjKYDAe85LBQv7E75M+WcHmsGWBqM8FrpSk5bVMhYyLYGDhVZPR3cEf8L/bM
	 0eF2aV5NDJ3mHh4ec3IovlKjKJABNR4WSi0S6JORVKLaJFcWQrP1KfOT+IRbaCS0OlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780925;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Jf5GtpRuXRchR2ff5N5v4AswDiRdBOtYpnk/23HLdl0=;
	b=wxg0BXyiLIu6IWwg8YRAQ24PP716pytl8Nro9+M6eGroOvHjLyKYyNMTsLwEg69jldn8
	 2ESYfD/lM5m6VNfBVoEr8uYSdOYO4JY0NVE930b/0PobsBwm6CfjiPV7bYfgurCBCSaq9
	 FRb3P7GeymVbnJhYrHKyFOsm0rZBdrSQ/LPmsyBhiUwP35N/7NpXJUxk09TzHa4l3V1+G
	 1y+t1LfINUN6bdDEo30hCbT+cZ4dUK8u7MhspcZHEcTAq6KHRAcFeUGOZSKQfohOV9r+6
	 kuoQMmpiSwK3IHY2ZwcogNlTzI7+JmfrolZs/WJED7hX4nejnzqBiSFooCz85fP6HJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xG8UIP57;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F50606A32A
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:02:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45F50606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xG8UIP57
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4ad6219f7d8so7259681f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780924; x=1796385724; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jf5GtpRuXRchR2ff5N5v4AswDiRdBOtYpnk/23HLdl0=;
        b=xG8UIP57aQAh4LxxzZJ/TvkrRYPWeefgdJwtmYMs7xi6VJp4Or79E0tc8x+MfDB8IZ
         omaH8nlF9TBaEgC5gXXs3WkdnZdsY50vtZNhvKHnOFjXaBbEC+dYyHNhskpsbcNPhZOs
         okqYTJi827WMMzKYQ4/LvZnCP2LkhFMOStqPk/taF3Icqr7QBdA7iEK2PBTqzdrHVB2P
         mlm/6sPqd8sWJ7TR9oYOphDne76uC3brOhDW5JwVrjMD+OxxO4keMSi/Dq6Td0XzAWCe
         teduCj+kP7ZNVp5O+KFt77phDc3sjvQIHEKt/iqEGiygCbdroBkYQCtutIQIPWvw+i+S
         3Wbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780924; x=1796385724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jf5GtpRuXRchR2ff5N5v4AswDiRdBOtYpnk/23HLdl0=;
        b=imQLd6ccUm2AwflTUiTpKWLm9ulYpyKkiYmNDvS8GkFAKVMMR6hq2prijko/hGlkEm
         BrwkZdPn+KJucTS4ym56wrskIQnNfaFf49GFipMazOXczkN8hwjN0N2wAq4CipJm0Ss4
         FF7EgANpirLdX8RVyNHMqFldV/IXVFEOL1i7csn0WpHhVObkeiqmw77iQCDaWtn/mO47
         f+yr16WOFSj61FMruIYrz0j17CbKl9+dMnqz/bCHGMz76/jghOaR5NsOFDfAhw8srNSe
         ir/4gX42Wzce/LAYt3mGMaEvkdOS9HbgOkIXxmNh5Gt3p4ELf3XovHMOKpC2lk/Gpx23
         JmOg==
X-Gm-Message-State: APuU4Z8n34AMfnXeaRDvzyEtIrb3d4+/JExMvSOxmZdN1cakT9O2dwdK
	lRiEPjJ8D7C1B2GHz+RIakotYFGoN1QTJliq6WvD5+NeG2FxKFFH4OBv
X-Gm-Gg: AZFdTZdfSW/Uz+deCzlHtzU6JICWaWNNdA9gM3I1c452+bF0/Pvx15aAy2Lkb1tlZSX
	E1Wf3E9IDeHR31WMZRskwA1QkLXa0Q1vU+b1yX1i5wnerILDIQp7H3+Wwc1mo1oOFj7g5S8TMAT
	1KSOYsVaFWXmMufCOpXze+Uv47FuEXdpAaKeys1n1RcA6tULTw2WjTVXlI09o88ISqNeSGoZiNU
	MPAaj7JPF87AsNngm1lVwHXwtzujlaoYm/X1pzWKfotpf9uQjbg0WTZa2woQ6s8HSKOgrtjFYn8
	UiTl7NI2h/3Ra7glHpAUcDUDAMl1cpaE1HquhAwYes/TJoPqKXv60MJ8PJrH0T1J9XeoD+5ggus
	I/caL/BG4f+uNQ507Dj3ey0ENnPmkq9yitgi/VD38R2QqOcCLUCYWAkl/NMcg7ml6e5b7GE6DwH
	fvrB4cBVIEJDZZSdPTw+T3UudP3a+8TCi0+5uy+7jeJo++wMS5h8VzosB2ZN38ZFwQJgDyuV/PC
	TTRT9wuL+cizNXcvkP4uG99FKpPQdKIiqUhHVebk/IUzH0M6RrMS9mLo4/NfJyhapbqAzTow+P8
	UUt+6W334THJL4TEPXEKDAedA8CymEPL9Rv92f8e3l0vy/8=
X-Received: by 2002:a05:600c:34d0:b0:4bb:6a5a:7839 with SMTP id 5b1f17b1804b1-4bb889428eamr488791765e9.34.1795780923213;
        Fri, 27 Nov 2026 04:02:03 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:02:02 -0800 (PST)
From: Jose Nieto <jnieto.alaber@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v14 24/30] arm64: dts: amlogic: g12: add crypto node
Date: Fri, 27 Nov 2026 13:00:57 +0100
Message-ID: <20261127120103.1532882-25-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127120103.1532882-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexey Romanov <romanov.alexey2000@gmail.com>

This patch adds a crypto node declaration for Amlogic G12-series.
With the Amlogic crypto driver we can use HW implementation
of SHA1/224/256 and AES algo.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 3135566df880..df1383f86366 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1742,6 +1742,13 @@ internal_ephy: ethernet-phy@8 {
 					};
 				};
 			};
+
+			crypto: crypto@3e000 {
+				compatible = "amlogic,g12a-crypto";
+				reg = <0x0 0x3e000 0x0 0x48>;
+				interrupts = <GIC_SPI 180 IRQ_TYPE_EDGE_RISING>;
+				clocks = <&clkc CLKID_CLK81>;
+			};
 		};
 
 		aobus: bus@ff800000 {
-- 
2.47.3

