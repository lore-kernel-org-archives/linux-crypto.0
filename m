Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D1D2DF3D1;
	Tue, 24 Jun 2025 13:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773231; cv=none; b=WVocyq+0+uwlrmjUA/KPiGGCj4boEiVtqDiRy2XusTskinrfJI59MaXXLM7zMJBrqqlfB8XSlVdsnvOVbTy4rYk7+0P2RKYHoocWzBMb4PhaIMDdTz07y8jLmwoXmL+XqSOvCOldOsRjxm+76+UbNFyjuLgNf+nt/jggfUBnaWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773231; c=relaxed/simple;
	bh=oiGDOTQlQJJvb4XNy0QogZP8XaCDTe3pugDhckuwwgU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kVKklP7IO0/UrYiLRLzDRa+Be1DtdVwXq7tTkM7A+eb48ABd2yaNgNlsv4Ub8VuxWZPsuzwfEMOPkPl0kXTtyiIXxgM1zsf5GrQ0uD/y6iaS7I7JvpR9Nvq/hoHl4UJ2b7qIQQloCL9ijAfHm1D47k/8fyMAojpKlLBnWTFIml0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YYOJxEzY; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YYOJxEzY"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-553b51f5218so452233e87.0;
        Tue, 24 Jun 2025 06:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773228; x=1751378028; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=at4AGtoJzuUSMRoGQaflHxu5wCpuyRhNqdSwxFevlHw=;
        b=YYOJxEzY60+mh/G8twOwmhGNRX5erhpyKSAsgProFQdZ3mzxFjxelw0GTnOhplEp0E
         0Ab1CS+pbbQLs5rhFCBzh2Pj5DX0wD3P1EjLOwFIyiYdXT0FY6nVkKlU3wmsA+fBsvpB
         5ovqXG/bCloqruYS23+oGbZdrmuCb6SGHF4Y2mC/yGEwjaMgnJkIwtiZ3B+t1T9zHo+x
         ZF7DqxQ7K3M8SXxPeSXl0BqMNRuYD6SSK3XlJVQwu6TkhaVkkPIvRumXlCj5NgKB7UwL
         oaXqriViFl7Go2gWYTMESKsO7Qsv20gQ59kx3o0p+9Xtaf8tN2YbWQDuodc9cat947W/
         Eghw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773228; x=1751378028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=at4AGtoJzuUSMRoGQaflHxu5wCpuyRhNqdSwxFevlHw=;
        b=XNrhd8okYxS5mZgzV1QZJvCOHt5UTx4S8K2EdygFxa7n3i2FCj7HtllKLS6xYUDXCx
         5diRNh7XudsPf1RxggJU8inxeUleTvm2VgyTlRfYlzy+FRVzbt5ja+6uiar0lvOmNt0H
         xU5Qwor0pyokULtcX3CsU1cg9MZO1gy2r17EW0qjjTScIERrTWTFkRUM4oRGILLHVJg9
         2BzhOOl6Gs6dUYGrggeK2jGS1Gij5xatxswg43AMmdnb8zoXwizPqb8oOlr7fMs5B+tG
         EmfXwxQ/6My6zhIBxSkk8Lw2fCKGOlv4zFY23W+yhLIJNS0LGpkiJFaeWiGzA9sZf+yk
         NQ/g==
X-Forwarded-Encrypted: i=1; AJvYcCUNPMRh+LmVGrj3j8rydET7snaqkTmKjXkzuIDtxKm0jUU8VFJQM295eyvi8fYU8KVIS5T+xFtlP12tghBv@vger.kernel.org, AJvYcCXBxM6O3AQoC8m5pz2GlonE28vdPxQmxvQ4LQv+wmHl4KhHKfFfg1S9n9l/x4/ziHAHr71O6KYRxVtN@vger.kernel.org
X-Gm-Message-State: AOJu0YyU/aLS2ql6ksKFNJm1g1CeJglFYTjrnXCL6bxtpu/8D/8IhODZ
	thn9ZrpXcHi2V0rvvo3Lq8votiGYONGFzBuZPaUSuD8fWipPf2Ch9MR6RpQu+BAYUPI=
X-Gm-Gg: ASbGncvw3pSrdzw4+bsiPVIqCLfOlSpJUEXwsEgLrrduPKqYLY7rIQUnSvccca9fTF7
	2ib052M8K/l4W9aQgDJXW4wHjjPWmfSrBJdqtW7cq8uhqJF50HOIBX+jmRb7UpbOa/+T7MYCKs7
	45qcPaVcOahkbuKHX/+WRNUXU1mQHqlgqJyUnGnyycFipTvx6w1jqnNqaA+ycTmfWZeeFt0E8rr
	9Dnn3oolyQXl2yKtrGnGQ9ZnwATWwuUudT3gmkODdtrvFvzNyU/31yKkOKu+gtijrDu6lVPWVQ3
	z9azADgwARpjA33fsX8xnhsdHBxNgwEr+6tyUTe6uqITeg9IWIyQXggSQnUvghzo5VIgr1R4cSt
	BLtoVFSYtKWVdKJJPyUq2+qOUJm+uhdHT+IWdXKG+H7OOmf4McF8Lp/m4lV5Amw==
X-Google-Smtp-Source: AGHT+IFbDE+lWZiMZmwadCBMjxfgjChAjL5/r/S/Zb6cyZMzeD+uljn9vGxJOP6BB4iHquZJI37Mkw==
X-Received: by 2002:a05:6512:3f19:b0:553:2c93:6140 with SMTP id 2adb3069b0e04-553e3b98f31mr5355681e87.9.1750773228139;
        Tue, 24 Jun 2025 06:53:48 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:53:47 -0700 (PDT)
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
Subject: [PATCH v12 22/22] arm64: dts: amlogic: axg: add crypto node
Date: Tue, 24 Jun 2025 16:52:14 +0300
Message-Id: <20250624135214.1355051-23-romanov.alexey2000@gmail.com>
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

This patch adds a crypto node declaration. With the
Amlogic crypto driver we can use HW implementation
of SHA1/224/256 and AES algo.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index 2df143aa77ce..f126097ab013 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -294,6 +294,13 @@ ethmac: ethernet@ff3f0000 {
 			status = "disabled";
 		};
 
+		crypto: crypto@ff63e000 {
+			compatible = "amlogic,axg-crypto";
+			reg = <0x0 0xff63e000 0x0 0x48>;
+			interrupts = <GIC_SPI 180 IRQ_TYPE_EDGE_RISING>;
+			clocks = <&clkc CLKID_CLK81>;
+		};
+
 		pcie_phy: phy@ff644000 {
 			compatible = "amlogic,axg-pcie-phy";
 			reg = <0x0 0xff644000 0x0 0x1c>;
-- 
2.34.1

