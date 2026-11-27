Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780922;
	b=poDvZJ9LfKtUrVjkFvlqCNBdPDrhg2d1BNVQ6OFzNFTIqJBMFKJxcR4+/kQzTSZionUx
	 XdLzCETWVT5bQI5yA07j20O8R+7vJclBEzL3qh5aVWzA1FiOCSkBBWWEfskEMX8Hmg3Dg
	 8MAzn+P1uj8uPvzWPZgNWdCuzrkvtSQbjgElaF68Uv5hm4GZuAWEgq5eMDWcStqumobsR
	 kmxG5YzOz622mRSpoxEgretyr672l2Fm+RE2XqjRaYfphdKBMwjXhqcdz6TpBLYbu59tO
	 i/b2dhy6GLS56a29qlJ6DVr5qpXBcWnwG0ystO6LNqwsTuAS/7Um/3y3Xy8XmV1GtxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780922;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9EgS1eeYniF1lumgzc+HBSwMC0WmhqQn1YuP8Q7M2uI=;
	b=ydvsxogpheKgRTx1FQoN24F4Bn46EcDS++DWNPLXXEChotCkhDk0SO/xOu+hJMlK9vhC
	 mecxc67eJgGaBjrVYcluNIfOo+1zyDh7bxEKyhP5a+I9KeJd8zd1WBNhx166TVSxmoVSs
	 LVKypOyx4hMTk2d1JKSvHEDkSoL2aiXZEG5zFra8RDvsewnYxvhGlom3aTkmY5i+Sdgmk
	 o1UCaPjaKKUScccgDDoYCKIX4rv1qYJ+GVed0+sWiBk023AajYBi3A8+mx1HyrWqWR1cu
	 g4XSuuoyOTNJCv1M9omPFnp3GU07pFjUwluNb0ev+034NmFPjpfc3qNlswDaRIx5MJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wVbMeUKJ;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EE1606A323
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:02:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39EE1606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wVbMeUKJ
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-490c3ae81d3so5022684f8f.2
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780921; x=1796385721; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9EgS1eeYniF1lumgzc+HBSwMC0WmhqQn1YuP8Q7M2uI=;
        b=wVbMeUKJKrlsDR8fjY+qRr47vkVur6UIyLrXaCQ190chnkWZEtHUHx+oLMUJDAIloL
         72AKH+eD1I0e5fIJW0VAiqIC4l1CfmcC09dpVnZW74kqiwsHtFWqtIaLIuv0XEu0iadI
         n5hCY216rCsSuIMOBRPuRfL8F4DN729jtI2gTwBZMuFAsgayhBnq+TZeTlZt04E5swm5
         J/44+VZiIjo+j5izaQpSrGLZv4Bk+ueZWFDZPHQqA54JecZkoPZwUNsy035aIBqj+IBV
         1eC/uKlk5L1TC8S1tb1JQt/Sm7OxiT9hFya35wy2QQEZz1+JzLUyJ55NT0bbur4AkTCR
         CT3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780921; x=1796385721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9EgS1eeYniF1lumgzc+HBSwMC0WmhqQn1YuP8Q7M2uI=;
        b=HYXHhiqhGSxU0F1THrnYGhll33SRVNLJ6R49rC6EiPv8/hJXb2hxrxoPt24Gkf1m9v
         dLT8LhjWG/woZvPYKtblA4Hfirg9z4ZA0bKvjGNQSm9aLRAdtgTLDn8mHJO9Ra6vI6f/
         EFWsAAW77kCmEwN8a6atmnFh9nXfZ8PCk4MJ3OzXuObaoK2SDrvJV6rRYV3XYIdIjZFw
         1KAVN6ky0CJyt4beUXz6ApKE7Jev54SuWZUpWEYLEzgphj1kODmLxupyu3wluhMa3CBz
         NJPS8fFzp64DxHGBf/0wnEMfpLGbI871odXosfFoc3aCvd/WvvF262PGmR4DLY0Qprxp
         lIMQ==
X-Gm-Message-State: APuU4Z9YWSIMWZJwaZc2nj/9PMsOh3sMznBzBpsL6g7cAjxnbMtY5cVJ
	kZ6sZNU2LYmMpF4KtzD1fQZKG6R5Y3OU5fOqYNy1nGxzWNYjTM2pXZoW
X-Gm-Gg: AZFdTZdrvMyfLaUpVSYncRoSPnZYUSIZaYhCQfmqFSr2at9aUmwNvixdSlp/Nz0E5N/
	lR3C3nZYGiz4e78cQJIowSMoinCqcLkyh9Aynwsflqg9aVolx+SHo5ZDvpHyKKjY1SpWDpyf4aA
	md9S8Lw48MeJFUVXe5l9SiQauwpSIhgVTzaeMWdjwtBUN156U1Ws4YVaR3gux7pTBBENUins1cv
	jfGIVnlUbZZc3qmuWcyAjRvkEHcUbrZdVp3KrfvZdR8acntwtCiZYrk74TLpQxgATlCi1awp2uQ
	4dqVCBhpRdQLl9sZKH31tfRDcji6Q3moeLBQBdtMwGQXBCkhQcRt7k00LO85pXi6YsJef2w8+Sh
	nOsyh/N9Cg+b8K7AxyPrKBxr1b+Pj2OEkpDfXD/zeh+9q9ub0e6M2hW3URGv9/Ql1/03ztd7J6w
	QGOvEnEHR5LYVirbGgu9mIIevq9csjB8VEC6/CtRqRY7/Wora0tRl2Ptmez321nSg27lMOxljrT
	5Qb34ibHV8VPgQiR6vIdyE6nfl8DEws0W6Fup2LSmNOBcwgqx7nsuAyS+dJk5dV1Ju3PQfWbyTd
	jJp8QJtRfAU5aV/rBqE/HeCEkc7tyaEvXY44sLZnYmOeat0=
X-Received: by 2002:a05:600d:18:b0:4bb:9001:1aa with SMTP id 5b1f17b1804b1-4bb900102b8mr353987715e9.10.1795780920450;
        Fri, 27 Nov 2026 04:02:00 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:01:59 -0800 (PST)
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
Subject: [PATCH v14 22/30] arm64: dts: amlogic: a1: add crypto node
Date: Fri, 27 Nov 2026 13:00:55 +0100
Message-ID: <20261127120103.1532882-23-jnieto.alaber@gmail.com>
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

This patch adds a crypto node declaration. With the
Amlogic crypto driver we can use HW implementation
of SHA1/224/256 and AES algo.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 arch/arm64/boot/dts/amlogic/meson-a1.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi b/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
index 6f6a6145cba1..396260b7b398 100644
--- a/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-a1.dtsi
@@ -686,6 +686,14 @@ sd_emmc: mmc@10000 {
 				assigned-clocks = <&clkc_periphs CLKID_SD_EMMC>;
 				assigned-clock-rates = <24000000>;
 			};
+
+			crypto: crypto@6000 {
+				compatible = "amlogic,a1-crypto";
+				reg = <0x0 0x6000 0x0 0x48>;
+				interrupts = <GIC_SPI 120 IRQ_TYPE_EDGE_RISING>;
+				clocks = <&clk81>;
+				power-domains = <&pwrc PWRC_DMA_ID>;
+			};
 		};
 
 		usb: usb@fe004400 {
@@ -767,4 +775,10 @@ xtal: xtal-clk {
 		clock-output-names = "xtal";
 		#clock-cells = <0>;
 	};
+
+	clk81: clk81 {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <64000000>;
+	};
 };
-- 
2.47.3

