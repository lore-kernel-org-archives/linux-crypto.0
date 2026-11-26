Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721616;
	b=16AwripANHGWvUjvvAnosVpQVajjvktS1nMQAKFAdb4w/Y7T51Qsa3S4W38QWsEp2KdQ
	 s+0YgV2P757NoCpb5vrn21qo63FkhoChxay4WbQzjTv2Utn/hktnZMPOV6qphkEjaMwy1
	 HKp9kr+Ajo7WpKhFiSGzMxFfn6DTPWme0wcLtd6DbEgI8EnQrz47i9ZvvundNQCqnUVZJ
	 xp9m/KTyh1iT46zp4m68++qX3xDHnLNvb1i/Zpi3+8ZtUXDUAp6oCV6g1EvNkL6XrMQci
	 fHsAaOTtRNynf4jzzUw0HPvbhBsz7KlbmI6fpJxxJWuCBjGvpJ4MuK+9EDcNnJ25XVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721616;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TyMpVGhTjV/u04TckFiyynsoMuEnZrBpJU3DYNeD5YM=;
	b=QlkzbmZZXKK+d0nuROODI1b02uHDFJexiw/RK+8kO5Aoc/byo4GnWwF4/KAagvLvUYX4
	 S4lSwGKU+6hfUdqfUrf+E1bJzHARYXKRevKuo9L3sjdnzCoiS+pPL4i4tACqwcx2t6Xge
	 tsrH5GEZ5H8b8WjHHt+WJ8rCTcxVkLLbUp3siTkn1vAWmwA9i2XPblXOo6cIno84A48iY
	 JGThr0lyo8bZ2IxRQmMM6CVVOZSqVsofNk2qf56igR80cqBPlwO6kS4o3LoVIsKLkrTIB
	 wD4VkDUzuKrfFkF/n5TwqbNNN/aWHPICs1W0CweRfFcIkxCCqf7VTGvry05pnD+oGUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ySuqqjZj;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023B1606A323
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 023B1606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ySuqqjZj
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4acb44dcd7bso6623906f8f.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721614; x=1796326414; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TyMpVGhTjV/u04TckFiyynsoMuEnZrBpJU3DYNeD5YM=;
        b=ySuqqjZjZ9WVNDz2VrYAP5v7NKHGZc7h/6bDIXIwGx+NLxILQ3/JWU+a0vTved9rwx
         edhTzXLbcE4bVj+QEKMhwmBzY4WfLeGyjDk7TEiNhyAGnHO79UNwTKOgXsdxr2nRxkF5
         1QiSZiOAClJOsO511K9mER1Vy6dhA7ngw9HGEzbS9kVZVEOWNH9+Xu9EVeT6VfFw7jQP
         8M+j9Pyhu0AfgJSlspeik+SDiYCPZDzgl/bnB+PvZ/E6AehD9jHkPEZdu2/xP08lp5xd
         bxFVi2NxK51Auv49SDeb01PpPtsfP4WGVx0+3d4qm5jNK2z7/Dfyf+IIF61Y3InbSJIe
         s+SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721614; x=1796326414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TyMpVGhTjV/u04TckFiyynsoMuEnZrBpJU3DYNeD5YM=;
        b=xCRFqRS7hJOR+fkOJmOehlTBLDyVwpqhB4duj6om+vCTBYVhX35c0vffQ8ICDBaLq6
         7yK1l8IWDwMBEOLc2wtEaIRX8gcgBN/VRkRWcnTmjnZBBA/iKSd2I7ziEiYJR0LkfGaf
         Xas0RHdDzpXQf5RH7hLLwQtWtX+SsZXZ/n6Tis5BXl6f2dOvn84mhHo0NOE/GaWlnDBl
         dD9xd4Jjl2YjhBB3vApnQPtKlZNLPWUoCTfEGpTLUOTAikqfr3mimz90bFBXI/nZybI9
         6esap0V2xaBAchn6N8bsYGwcwsYTbpQKhuyq8cy4tn6o6OVm8D93KfJOIG+wjPdxwKss
         9IvQ==
X-Gm-Message-State: APuU4Z/rB70elp0Ywrlro9fT9e0Swszve1kIueA/pfgdoiVgaobXgGk4
	XunamBV+qWPIyPAzGS7Xtu+ImDystskbWnThqG0QoyjL2+yPju5PF7FYeH2KBOKk1ok=
X-Gm-Gg: AZFdTZetX+QFJi1V33Pluz3F+uuzQxT4Sg9Uw98GtLmmiwKHEvcPSWD7L0uBGOWNaD5
	XHQZsG95qm94lp2JP/9y9HOsKg2qU0w4O+cea/jGCrn+ZgR5hiesLPZGEmajuqvW/QEv8BYQSKE
	FfXuA8sB2vW1aafodhDwl+75RkHz2WNV9kIycuvor+QT5p3fqjFxMN9zKenM9xXyozkug+mpk+l
	PlS9Y+gyQH43SLPYP5y+MtAqw3RvdBXvQ3cNFTsfWs/g53WXR7EI7MnIsmVwJsg4T+NPBSBHqEI
	x0u7YUpqIP0lqcnfPL9ZX0NV3bYNUW7BS6JPmUrkApbTWyhL0twmmAjnllPqY2Q7bpKDjXmve3b
	xMCVbJbu1B7pCsYwSV7T+AjGgqmrD2czVPPYGKmjLM55HilQSnsN8zxvb/Vv9GqKDO2e9d3Ecck
	kNKG3FAHI3+aqVCym/sO5f4Jgm6ePGaX1+80x7KIC8gEU8QFVobfdNKxsP1nwxYy5QClySO6958
	HhA7NCQ5QNfrF3IG76U3zseIkse4EE1QuXKNYiXXgvmUthRlR6sPHhbHqwoWoD47fj1vbCMsOZt
	i/1hAbJdLQgXCXqI/dBhY4j8W5U1PBPpcfCZKUUtG4t9wg==
X-Received: by 2002:a05:600c:c086:b0:4bb:a5e1:8288 with SMTP id 5b1f17b1804b1-4bba5e1b76amr99845895e9.6.1795721614313;
        Thu, 26 Nov 2026 11:33:34 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:33 -0800 (PST)
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
Subject: [PATCH v13 21/25] arm64: dts: amlogic: gxl: correct crypto node definition
Date: Thu, 26 Nov 2026 20:32:37 +0100
Message-ID: <20261126193241.1471372-22-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
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

GXL and newer SoC's uses the DMA engine (not blkmv) for crypto HW.
Crypto HW doesn't actually use the blkmv clk. At RTL level, crypto
engine is hard weired to clk81 (CLKID_CLK81). And remove clock-names
field: according to the new dt-binding, it is no longer required.

Also, GXL crypto IP isn't to seconnd interrput line. So we must
remove it from dt-bindings.

Fixes: c4a0457eb858 ("ARM64: dts: amlogic: adds crypto hardware node")
Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index f257fe3860f7..5d0bffda8f19 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -68,10 +68,8 @@ acodec: audio-controller@c8832000 {
 		crypto: crypto@c883e000 {
 			compatible = "amlogic,gxl-crypto";
 			reg = <0x0 0xc883e000 0x0 0x36>;
-			interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>,
-				     <GIC_SPI 189 IRQ_TYPE_EDGE_RISING>;
-			clocks = <&clkc CLKID_BLKMV>;
-			clock-names = "blkmv";
+			interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>;
+			clocks = <&clkc CLKID_CLK81>;
 			status = "okay";
 		};
 	};
-- 
2.47.3

