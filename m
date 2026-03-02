Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A1136308B
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 11:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772450533; cv=none; b=NagYxidgAXHFIdvhfh6shtGqgbx7CDJse942KWWTDJgrT7TPMS7ouO95L1FeF8eKJOnfoN/Z6SETR+rTJ+XoFjVLh8IaK/KAN8fW5By5dfE/QgkS4vlcrz+1eTZcyTdtNCLckXoFjIOZBD1Xgsyt7RcO987hLJPkdjfg8+4LNok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772450533; c=relaxed/simple;
	bh=56I7rIxd9f8s6A0xYF9o3Ogl/zPP8ZpCKxAq5HCjTMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNJaMozAHNaD7mNXnQzg/DJoKRrC8ArlYzOHyF4L7H3NnwNafVUqvVBITkeTudnwAwHIHUyAAh3ujh6RE4S7wJhQagOWxBqzsxd+nnr+J7NYcPsbRG5gESLF9+FwDLrvdwEbQEqImt3YawLyygGhynbEKldgiNiXmHJTujasS5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=ubTNzV8q; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="ubTNzV8q"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4836e3288cdso29769105e9.0
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2026 03:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1772450527; x=1773055327; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BEL8xD6r/LZl69+xMFv9iWD7+sHUzbOpHHkJN7M+9SA=;
        b=ubTNzV8qeMd8RRiTPlIHTZfRMgGbcezBdbpt9bT7h98nDMcUcA4evVEZvztjLKBfnc
         vZ7WbrhLTP6eUVnyafz1Bn+znjrwozj5ezRTD3OhP5MRIFInoKNa9YlUfbr+BAYdSCDB
         jlYSx3n7UnMGHlwdbNDKw+HlYxn7PMrk4612aLOnnBCc3KrLILIhgyFzq7zijaDyaD85
         3s+9FO4taR46wau+5wBn5XraczHF3h+1zWIH9mZge3kepHEUqQ1sGFqglq/kfb/RA1cl
         5x4l/xHp3kZBBHMfS6ZFs5WLwg7YhRQaxtE+mgT6TQf92yPl4+c8Md11A0GjVPucCvMi
         TKhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772450527; x=1773055327;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BEL8xD6r/LZl69+xMFv9iWD7+sHUzbOpHHkJN7M+9SA=;
        b=hAZcwGRb5rI8SsRafMHAOUhvv7Ko4nO9FcYuVRWY35slojh9StrsJ933z04xRrHP0G
         JrH99OG0xNCrnJHYNlGI8mkcrrHZZDpt7ZOtugmmQqL5idWdtvgZyUnwQNOM15A/oaSt
         vZAlzIbR6I9KOpTvJxM9R6FvymNVmpyVhIyLLYlCiT72d59NRUw1DCRzgA6wRbfNAtWd
         3fhmVsdKqAW7Z0DqwNMa+ChkV1OA57JjuRB2fUCP1E/EAikxojBWfNMQE5egm4YcesEG
         /08XKiO+9GCodzvywqJ9R1wyiVfogO9cxfcENEuNUE790si8rmxdtD9IS0iCnkg6M/av
         9Kwg==
X-Forwarded-Encrypted: i=1; AJvYcCXNLYGcviGA6hpcTLfeEQpE+3gaB3v3EXHjNtjFC93YGdP0CYDAHfKnbR90FNK8G97NdAJszd824U48JC4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+Gutg8Oeqqz5+0ian1RdFntx8swESKH8+VHhhdg+VIRmlLbQ2
	5pEWRX8FiJGdpl9lTowLTHtmTeY7inKhnK3wXx2M1nt+GvBkt+gNQll3VUZYZJakZBA=
X-Gm-Gg: ATEYQzxWNOkqskcrf4fnrDlNlQ5ZS9fpSqRSooaJ8kZ9OxbL/hOegxvxWhnFCzJOnrr
	J88YTQi+UXhCWFqvfQeWUR1rwSxsjV2bZMEMGLP2ZgGa0hiPqn81aXzXqHBUHkEbQHhOyuu85dZ
	WJFISVdESMbrEqI2MV0X7P8XC4JYyT8hJYIpuqLHOkSzK1uHHMHpzVwrZiBYy35TjqNEcIb1z4p
	uZjltiIHOGJYEpEaWAeMaVgN45X7XsDMDO4DukYMYNd2nfYFJrFQo/81JHm5uyl7FUhJK43wtqU
	Tqf64NJR5+JxNCLJeRp7PDwRsZzYlMWGMo4O7mPNsE9Aqey1lfVyBauwmHxTXZfD8CrUwLPk11R
	2/Ln8qVDaIgb9NQ4lcAIGHW5ftMPGlIY2GTSTk9Irgob58Z7RRiLva+wzhkaG3PnTEH17PG5U+P
	Ce9vK8R+E2QYd1hh19tEISfQL7YOGqIkDvTI53SbUkXZv3vGB7w8TZSMD1simcX98Hvpg9L+TWK
	PEjymALx0QObQ1LENWNFn9ob+Y7tC46yx07Vv0DZCkiJdRgLYLxCg==
X-Received: by 2002:a05:600c:1549:b0:47e:e59c:67c5 with SMTP id 5b1f17b1804b1-483c990de68mr204131235e9.8.1772450527342;
        Mon, 02 Mar 2026 03:22:07 -0800 (PST)
Received: from fedora (cpe-109-60-83-135.zg3.cable.xnet.hr. [109.60.83.135])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-483bfbb465bsm292493035e9.3.2026.03.02.03.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 03:22:06 -0800 (PST)
From: Robert Marko <robert.marko@sartura.hr>
To: robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	olivia@selenic.com,
	herbert@gondor.apana.org.au,
	radu_nicolae.pirea@upb.ro,
	richard.genoud@bootlin.com,
	gregkh@linuxfoundation.org,
	jirislaby@kernel.org,
	horatiu.vultur@microchip.com,
	Ryan.Wanner@microchip.com,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org,
	daniel.machon@microchip.com
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH v6 3/6] arm64: dts: microchip: add LAN969x clock header file
Date: Mon,  2 Mar 2026 12:20:11 +0100
Message-ID: <20260302112153.464422-4-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302112153.464422-1-robert.marko@sartura.hr>
References: <20260302112153.464422-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LAN969x uses hardware clock indexes, so document theses in a header to make
them humanly readable.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
---
Changes in v6:
* Pick Reviewed-by from Claudiu

Changes in v5:
* Relicense to GPL-2.0-or-later OR MIT to match DTSI

 arch/arm64/boot/dts/microchip/clk-lan9691.h | 24 +++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 arch/arm64/boot/dts/microchip/clk-lan9691.h

diff --git a/arch/arm64/boot/dts/microchip/clk-lan9691.h b/arch/arm64/boot/dts/microchip/clk-lan9691.h
new file mode 100644
index 000000000000..0f2d7a0f881e
--- /dev/null
+++ b/arch/arm64/boot/dts/microchip/clk-lan9691.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: (GPL-2.0-or-later OR MIT) */
+
+#ifndef _DTS_CLK_LAN9691_H
+#define _DTS_CLK_LAN9691_H
+
+#define GCK_ID_QSPI0		0
+#define GCK_ID_QSPI2		1
+#define GCK_ID_SDMMC0		2
+#define GCK_ID_SDMMC1		3
+#define GCK_ID_MCAN0		4
+#define GCK_ID_MCAN1		5
+#define GCK_ID_FLEXCOM0		6
+#define GCK_ID_FLEXCOM1		7
+#define GCK_ID_FLEXCOM2		8
+#define GCK_ID_FLEXCOM3		9
+#define GCK_ID_TIMER		10
+#define GCK_ID_USB_REFCLK	11
+
+/* Gate clocks */
+#define GCK_GATE_USB_DRD	12
+#define GCK_GATE_MCRAMC		13
+#define GCK_GATE_HMATRIX	14
+
+#endif
-- 
2.53.0

