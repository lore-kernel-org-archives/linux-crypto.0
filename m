Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780927;
	b=eLSmX9OSLNluGWB1oqJNNc6TR4bY3Tr7xjGwaVkgvNlDxG4tIk18+0ylxwtvc7y8OFaA
	 3DSHczc6ZullK/a+gBpXeHYfFFYpl7PI1v89/GLPPYgiA7rEFLddOjVZ26DN4c5x0rcJf
	 vLZkNZZu3WfnDZKwuKlfEeCREzZyeCctnHAekklap6IVrE4kYJvOOKPuWBnbG0DUvpjMk
	 njsjdpv/0pb+hbGkzbvLeFdD2T5WSarJidtb+/CrhabTCR/pkh/xSl9ME/rveodMz3QJd
	 hqM6yXD2DQAlZwQimp1H4BAGa+XriTvUK70KEtEwgeDyE18Atthio4iB54bKW3wvmow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780927;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=l0FqxSdSkWVcKj6JvNw9SG+fnKtmoC4+i5Y2izvcenk=;
	b=uVombhVFewHvCuIdylgHiyIFKeKOvVTomKwqrYOIS3hsNGEP9EgZq4mpMezsocouasRi
	 CepvLBgAnfZ5OR52DDTNQ0SzPoM5RUCXQ/8Pwh7k14djqxesvhudTlFUoezerSLLf3uyW
	 t521Q+7o438iYsOQj6RstdFF+4l8Tz30laoCmVwlluXZb623D2ePdpbL7JtBxo+2uZCtN
	 np1DkxfwHAe3eSRFAIefkPCE8XmUryTNNCU2hugvU8Jq8BgeKQ+6HrlQ06Pu/jTtlpYrS
	 IM8v3rcYw7A03OknRltrz1eD1IN2j6VOqotSRmZ8Q+JLv60EL/ZioUih2XcHSYKmacQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="0LJt6/19";
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C10D606A31E
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:02:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C10D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0LJt6/19
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4bb9d8e8e90so51559255e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780925; x=1796385725; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l0FqxSdSkWVcKj6JvNw9SG+fnKtmoC4+i5Y2izvcenk=;
        b=0LJt6/19RSoSIxSxgAg9Vd5MQb+QWUZYn3k/Jd3nkizzsLxBtjk10mtUFQsVPDVITN
         DS7qB+kDq7XLkAYzVbQ9umbPvVnjdXg/9rgsQ0tiPiMpaSbfTaoQCJdN18PBK2twf1gn
         mIK51XMtkwc/yEf6h/3Wz+y3qTZnyICWHcQFKS/wqTiKaHwln1ZCvbNnj5sDM3n1Zbpa
         NDZO/HhfeOWV1V13Jt1hGgz0n4UXNR4IdiT93orBMNqi/FiK+06zFvJeWxkYFbxhozPd
         9FwlwSX5ipMBRtzNM92PL/W9V76XEnN3m5wxdDw827VH7aOkbSR/o8i2csnOxrRj74E0
         EIdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780925; x=1796385725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l0FqxSdSkWVcKj6JvNw9SG+fnKtmoC4+i5Y2izvcenk=;
        b=qYzUm/Qzk2j5c9W+7rzMuw2wyOIOY6sjPkTVG0lLSpU+WogBRFx1Y95N2yMRSrRqM+
         bkuv8YAHtjwDnysXRrNSBx53AR2NYp3fJFoKk9mC/Z2B+vePYZXbcCj0fpaw3cbmXMLw
         JnQ3kO3LRuSnHciaxLwyEUQ+0JUzDJOHUyqTj7DetzPclq3JpRaQPUJ4YpfLDRN4hQRi
         FVHoMHk9J1bl47jasO6gXRdwT9Jx79/ZDjQwj6Bsjk56q/PolXpatCLFPyCFF32uGhBl
         DwrJZHQZlZ5fBTzioHRvFVvyDe2zvzJlECr3rrj13i5sQG1IUVDtsz8mO4m+O4MNF/cC
         f8UA==
X-Gm-Message-State: APuU4Z9/cAIR5POJYjssLCSmSeFQAWBBurSIEl6vKKqrne7DYL8mE+VF
	vKDvDmwWddLMzoK0ev3ehe4JwB43WewpB2dT2wdDWEm+iFShJJBkgqTT
X-Gm-Gg: AZFdTZcu4RV6aCdnOFbMLV5mdpiv5E9P8GyQ+8JGF0SX85yuRkBaLkIrJXYqz8xGJ5b
	k+hcFseobyp6ZoQICJ48TtW/UltANMgTeuO/btj6MQHk5SI6MeGaV/6i+TJJYgDE25J0yt8hj17
	O5UGbqlWnGIP1rCaahGBqFsS1NWjJjtPDXAAgoT3clwsd9YVTYLcaCyZkfvC4KBWudZMThsUlAE
	jsyhqrWzRBpxQ2xktO/Os5uVY2F5jD0W+mOT/pTNYda3VTAIRxwBvxomVb8EE1mryTSmEvN3uSi
	TsuvmnBhT3+HB056KPGZ+5uJLvKVYAGoo+Sm7NydqiDv0viCUzZSlOBCf98T+jB6B+QZypVj+TH
	c067I9g7rQb3hDNPuL4n56pH33MWnQefuLR2SX0Ek8cwqgBjF4wPt1YVTNoquqd131NlLRgWJof
	aWuS78Y4a/ihNe5TisSo4nD9ilc/RsAXgyldn+5Rw4bdS+L4hHVmbbEewmm+Q5bqkwIp2IIi8Ge
	UYtGzDzCrntsSJ/8FOaaISbBRoJvyPm31cwhHfZ7gu3atPa35typQTbcmf+aD4cfLb6knlrumsN
	A/K3MzyBeAEmapsvJHUBkPHqLGQKS2u1jS9p7mci+zjo3kyAFs3jeuXiQmV3caYUc8Xn
X-Received: by 2002:a05:600c:638f:b0:4aa:2339:a375 with SMTP id 5b1f17b1804b1-4bb8880607cmr457352155e9.13.1795780924749;
        Fri, 27 Nov 2026 04:02:04 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:02:04 -0800 (PST)
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
Subject: [PATCH v14 25/30] arm64: dts: amlogic: axg: add crypto node
Date: Fri, 27 Nov 2026 13:00:58 +0100
Message-ID: <20261127120103.1532882-26-jnieto.alaber@gmail.com>
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
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index 5b8ef98f6d03..e755a019b384 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -321,6 +321,13 @@ ethmac: ethernet@ff3f0000 {
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
2.47.3

