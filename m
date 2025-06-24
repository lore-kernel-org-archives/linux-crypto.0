Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA3D2C3265;
	Tue, 24 Jun 2025 13:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773229; cv=none; b=uvWLszJoLl7Sa/0fmL80fcUV0Pj2Cn7N2FQN9OYhtr+e+yvhD3Sgt22Y1ZYIxqiRtO+7J8zJZdV7k5OMfUXrY2dMaKrC6IUvzyn4f3boZJQCWul2Omf/eEMejkg6/6ucV8/pIQm8P+FiEN0bzSuNEVfSH2UMWYwPe1Sd9L9aHCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773229; c=relaxed/simple;
	bh=lEpmw1OvKdosAkcwZQTIaVjsiOJJxS27WNgGVVTE8J0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lAzLLUD2afIK00mO9qiSj6MjaV2KQ1rsVXDNMgj+SqnD4O5Wia4L2Fm9f6k29tLAgjiyq30SSlwIQTugygTp6BO1k+uTTTUh/vO/YQjP6suiKedLa1RwnN1GrX7Ck6iQlhUpxpQG7775UcW7UP3BJNsgnnnqNwVflL7cIlwKcqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QU2xMQzB; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QU2xMQzB"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-553b544e7b4so5592873e87.3;
        Tue, 24 Jun 2025 06:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773226; x=1751378026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ojIxQ7ZXn4BuWD/72s/OuzCO15xAe0zqbzQsADO8BmY=;
        b=QU2xMQzBiwFkEymlaVJ/jkSSYOODw8cqsNTRun9D4h27/JeFo2UMQtd61sRTkyerG3
         iF4+RZfcHgkOGeKtAniRsHiURKpMoZjzuKCrxiMU3iT3v0MUIOThSr8pro4R2M+VaGu8
         GBDeFHEDP30ZNFTbdusWQVJZjWTzzb9TyZkJi46PUHuGMd4hYNQ2sg/6+YTLXS6IAZr6
         s0GxgG3qOolRB3hkRlYuJx8Nw+KPQpsmina8rcfIHtaOobpbvc0CACo3scfycAZXn06m
         mbEhBAhPxyqu8PkeIIb5qxmerjyjb/5+kNCDNgfCoSCRNwhIhZkhLjNoxuU+IN1hBGDM
         NrnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773226; x=1751378026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ojIxQ7ZXn4BuWD/72s/OuzCO15xAe0zqbzQsADO8BmY=;
        b=NU1Yl0b6oseF5o4ZDaWnhI3ukta7LkgRqzQ5b9vKnDKnw7mGF4QgaOJKtCfefABYlu
         mgl4dOSSSJqUoCasfD/qS2SKQjsrvtfyRkYAZ7blktS2G9w8d/jDT13Ia8Xmk78bRWsa
         IiGkcVEq9fol7csOzVT1d1aKxDpInLTtH3O8KpDKP3jUihx91+oxAx+Y6vc0zta6Zo2b
         zAuC1e1XLLqDnrifeo1IsYXQjl9Rdqik5KJ6eJO6hz6fZzBFeL8vlKrOK72/Kj+vQPQ5
         l7/F8iuQNEeSiLE9kNnDrTNcVOAhDbRdlCfE7HLxpSwEbbciBW46yY8eWvOETRPqe6IP
         yArw==
X-Forwarded-Encrypted: i=1; AJvYcCVAaj9NUJdUVdQErHRxc9KA0JLHC9fN80dFcMc4SHr9sG7b5ELX5E7HPtqKxnnuT66+EcOCPabz6/51Ujqg@vger.kernel.org, AJvYcCWKmWlVu2Id/EKOseFs17e1HogiuOmJPHQXwIpNsIFryiIfCLLqfjCbjoG7BQdDCb2/PURv+yVJnfRd@vger.kernel.org
X-Gm-Message-State: AOJu0Ywca1ZkJxW+c2iMDk9rVGznj3382kqrLMAClBRdtg13MM6Ft+4G
	pTUNIK8Ym281tDiqCrcNHpfH3ud/FhCXNJpmxxJ0ogdvqdmWzt/LYmcS
X-Gm-Gg: ASbGncvOSsDb6DiMR/rnY2l8tdUCHn1+QQAC1J2Jv43O7p/rFLyemdhoIhxKE9Zuk9Q
	M5Q1cK5VrcGxjNjoEeQ1L80JlZ+x20MHZTNLpaumgVz3BazfjlRTdAZTzQdVsICmyMr1SjwXq3Q
	Fw9R8mIvh9ZHiFUAEkYBdDWhZLUpIfkkVWnGZJgURPFbzwmc6dDOvqYewTunuA8YW23H78qNgVI
	JuQEJKjTV+h9wg+YTg1u/jGUCUIiIrNYtgKWI8uhR9W33ugIeU9h6d3qUNPha1zz9NZf3ubEW/t
	k4OKOUVQgTo4oiCJZ9sP8u9z3jCxDqenySB3EQ5aZxEFykDumSCiw2mMTedQyHvVZCpmhwaJlPZ
	zyBTR2kU3bdF8tf7FA96yluA+ageCCyVvl5mnscUtXAE1quDKi4S6MvatkiC1NQ==
X-Google-Smtp-Source: AGHT+IEttd797kBbdZQwU83qr+T1pUIvczg11xawPSLQGuHM+rw95Tm4IhToVETAc1tjXhgqp5guBQ==
X-Received: by 2002:a05:6512:3684:b0:554:e7f2:d76b with SMTP id 2adb3069b0e04-554e7f2d9c8mr2322834e87.56.1750773225873;
        Tue, 24 Jun 2025 06:53:45 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:53:45 -0700 (PDT)
From: Alexey Romanov <romanov.alexey2000@gmail.com>
To: neil.armstrong@linaro.org,
	clabbe@baylibre.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	khilman@baylibre.com,
	jbrunet@baylibre.com,
	martin.blumenstingl@googlemail.com
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v12 20/22] arm64: dts: amlogic: s4: add crypto node
Date: Tue, 24 Jun 2025 16:52:12 +0300
Message-Id: <20250624135214.1355051-21-romanov.alexey2000@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
References: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds a crypto node declaration for Amlogic S4-series.
With the Amlogic crypto driver we can use HW implementation
of SHA1/224/256 and AES algo.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
index 9d99ed2994df..4c897073a33f 100644
--- a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
@@ -66,6 +66,12 @@ xtal: xtal-clk {
 		#clock-cells = <0>;
 	};
 
+	clk81: clk81 {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <166000000>;
+	};
+
 	firmware {
 		sm: secure-monitor {
 			compatible = "amlogic,meson-gxbb-sm";
@@ -586,6 +592,13 @@ mux {
 
 			};
 
+			crypto: crypto@440400 {
+				compatible = "amlogic,s4-crypto", "amlogic,a1-crypto";
+				reg = <0x0 0x440400 0x0 0x48>;
+				interrupts = <GIC_SPI 24 IRQ_TYPE_EDGE_RISING>;
+				clocks = <&clk81>;
+			};
+
 			gpio_intc: interrupt-controller@4080 {
 				compatible = "amlogic,meson-s4-gpio-intc",
 					     "amlogic,meson-gpio-intc";
-- 
2.34.1

